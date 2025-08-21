package com.fridge.recipe.service

import com.fridge.recipe.entity.Ingredient
import com.fridge.recipe.entity.Recipe
import com.fridge.recipe.entity.RecipeIngredient
import com.fridge.recipe.repository.IngredientRepository
import com.fridge.recipe.repository.RecipeIngredientRepository
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Component
import java.util.Locale


/**
 * 식품의약품안전처 API에서 가져온 레시피 재료 문자열을 파싱하는 컴포넌트
 */
@Component
class IngredientParser(
    private val ingredientRepository: IngredientRepository,
    private val recipeIngredientRepository: RecipeIngredientRepository
) {
    private val logger = LoggerFactory.getLogger(IngredientParser::class.java)

    // 재료 단위 매핑
    private val unitMap = mapOf(
        "g" to "g",
        "그램" to "g",
        "gram" to "g",
        "kg" to "kg",
        "ml" to "ml",
        "cc" to "ml",
        "리터" to "L",
        "L" to "L",
        "컵" to "컵",
        "개" to "개",
        "개입" to "개",
        "장" to "장",
        "마리" to "마리",
        "tsp" to "작은술",
        "작은술" to "작은술",
        "작은스푼" to "작은술",
        "티스푼" to "작은술",
        "큰술" to "큰술",
        "큰스푼" to "큰술",
        "밥숟가락" to "큰술",
        "T" to "큰술",
        "Ts" to "큰술",
        "ts" to "작은술",
        "dl" to "dl",
        "cm" to "cm",
        "mm" to "mm",
        "m" to "m",
        "oz" to "oz",
        "온스" to "oz",
        "lb" to "lb",
        "파운드" to "lb",
        "fl oz" to "fl oz",
        "갤런" to "갤런"
    )

    // 과거 파싱된 재료 캐싱 (성능 최적화)
    private val ingredientCache = mutableMapOf<String, Ingredient>()

    /**
     * 레시피와 재료 문자열을 받아 파싱 및 저장
     * @param recipe 레시피 객체
     * @param ingredientText 원본 재료 문자열
     * @return 저장된 RecipeIngredient 목록
     */
    fun parseAndSaveRecipeIngredients(recipe: Recipe, ingredientText: String?): List<RecipeIngredient> {
        if (ingredientText.isNullOrBlank()) {
            logger.warn("레시피 ID: ${recipe.id}에 재료 정보가 없습니다.")
            return emptyList()
        }

        try {
            // 재료 정보 파싱
            val ingredientInfos = parseIngredientText(ingredientText)
            logger.info("레시피 ID: ${recipe.id}, 파싱된 재료 ${ingredientInfos.size}개")

            val recipeIngredients = mutableListOf<RecipeIngredient>()

            ingredientInfos.forEach { info ->
                try {
                    // 재료 찾기 또는 생성
                    val ingredient = findOrCreateIngredient(info.name)

                    // 재료 수량 및 단위 정규화
                    val (quantity, unit) = normalizeQuantityAndUnit(info.quantity, info.unit)

                    // RecipeIngredient 저장
                    val recipeIngredient = RecipeIngredient(
                        recipe = recipe,
                        ingredient = ingredient,
                        quantity = quantity,
                        unit = unit,
                        optional = info.isOptional,
                        extraQuantity = info.extraQuantity
                    )

                    val savedRecipeIngredient = recipeIngredientRepository.save(recipeIngredient)
                    recipeIngredients.add(savedRecipeIngredient)

                    logger.debug("재료 매핑 성공: ${info.name} (${info.quantity}${info.unit})")
                } catch (e: Exception) {
                    logger.error("재료 등록 실패: ${info.name}, 에러: ${e.message}")
                }
            }

            logger.info("레시피 ID: ${recipe.id}, 저장된 재료 ${recipeIngredients.size}개")
            return recipeIngredients
        } catch (e: Exception) {
            logger.error("레시피 ID: ${recipe.id}, 재료 파싱 중 오류 발생: ${e.message}", e)
            return emptyList()
        }
    }

    /**
     * 재료 문자열 파싱
     * 다양한 형식 처리:
     * - "소고기(300g), 간장(2T), 설탕(1T), 물(100ml)"
     * - "당근 1개, 양파 1/2개, 소금 약간"
     * - "브로콜리 1송이, 마늘 3쪽"
     */
    private fun parseIngredientText(ingredientText: String): List<IngredientParser.IngredientInfo> {
        val results = mutableListOf<IngredientParser.IngredientInfo>()

        // 1. 재료 문자열 정제 전 처리: 타이틀 부분 제거
        val preprocessedText = removeRecipeTitles(ingredientText)

        // 2. 재료 문자열 정제: 괄호 포맷을 표준화하고 특수문자 처리
        val cleanedText = preprocessedText
            .replace("（", "(")
            .replace("）", ")")
            .replace("[", "(")
            .replace("]", ")")
            .replace("【", "(")
            .replace("】", ")")
            .replace(';', ',')
            .replace("×", "x")
            .replace("✕", "x")
            .replace("X", "x")
        // 2. 재료 목록 분리 (여러 구분자 지원)
        val items = cleanedText.split(',', '●')
            .map { it.trim() }
            .filter { it.isNotBlank() }

        for (item in items) {
            try {
                // 패턴 1: "재료명(수량단위)" 형식
                val parenthesesPattern = "(.*?)\\s*\\((.*?)\\)(.*)".toRegex()
                val parenthesesMatch = parenthesesPattern.find(item)

                if (parenthesesMatch != null) {
                    val name = parenthesesMatch.groupValues[1].trim()
                    val quantityUnit = parenthesesMatch.groupValues[2].trim()
                    val remainingText = parenthesesMatch.groupValues[3].trim()

                    // 수량과 단위 분리
                    val (quantity, unit) = extractQuantityAndUnit(quantityUnit)

                    val isOptional = isOptionalIngredient(name, remainingText)

                    results.add(
                        IngredientParser.IngredientInfo(
                            name = cleanIngredientName(name),
                            quantity = quantity,
                            unit = unit,
                            isOptional = isOptional,
                            extraQuantity = remainingText
                        )
                    )
                }
                // 패턴 2: "재료명 수량단위" 형식
                else {
                    val spacePattern = "(.*?)\\s+(\\d+[\\d./]*)\\s*([^\\d\\s]*)(.*)".toRegex()
                    val spaceMatch = spacePattern.find(item)

                    if (spaceMatch != null) {
                        val name = spaceMatch.groupValues[1].trim()
                        val quantity = spaceMatch.groupValues[2].trim()
                        val unit = spaceMatch.groupValues[3].trim()
                        val remainingText = spaceMatch.groupValues[4].trim()

                        val isOptional = isOptionalIngredient(name, remainingText)

                        results.add(
                            IngredientParser.IngredientInfo(
                                name = cleanIngredientName(name),
                                quantity = quantity,
                                unit = unit,
                                isOptional = isOptional,
                                extraQuantity = remainingText
                            )
                        )
                    }
                    // 패턴 3: 단순 재료명만 있는 경우 ("소금 약간", "후추 조금" 등)
                    else {
                        val approximatePattern = "(.*?)\\s+(약간|조금|적당량|적당히|소량|한 꼬집|한 줌|넉넉히)(.*)".toRegex()
                        val approximateMatch = approximatePattern.find(item)

                        if (approximateMatch != null) {
                            val name = approximateMatch.groupValues[1].trim()
                            val approximateQuantity = approximateMatch.groupValues[2].trim()
                            val remainingText = approximateMatch.groupValues[3].trim()

                            // "약간", "조금" 등의 표현은 수량 0.1로 통일
                            val quantity = "0.1"
                            val isOptional = isOptionalIngredient(name, remainingText)

                            results.add(
                                IngredientParser.IngredientInfo(
                                    name = cleanIngredientName(name),
                                    quantity = quantity,
                                    unit = "소량",
                                    isOptional = isOptional,
                                    extraQuantity = remainingText
                                )
                            )
                        }
                        // 패턴 4: 그 외 파싱할 수 없는 경우는 재료만 등록
                        else {
                            val isOptional = isOptionalIngredient(item, "")

                            results.add(
                                IngredientParser.IngredientInfo(
                                    name = cleanIngredientName(item),
                                    quantity = "0.0",
                                    unit = null,
                                    isOptional = isOptional
                                )
                            )
                        }
                    }
                }
            } catch (e: Exception) {
                // 파싱 실패 시에도 기본적인 형태로 추가
                results.add(
                    IngredientParser.IngredientInfo(
                        name = cleanIngredientName(item),
                        quantity = "0.0",
                        unit = null,
                        isOptional = false
                    )
                )
            }
        }

        return results
    }

    /**
     * 수량과 단위 추출
     */
    private fun extractQuantityAndUnit(quantityUnit: String): Pair<String, String?> {
        // 특수 패턴: "4x6cm"와 같은 치수 패턴
        val dimensionPattern = "(\\d+)[xX×](\\d+)(cm|mm|m)".toRegex()
        val dimensionMatch = dimensionPattern.find(quantityUnit)
        if (dimensionMatch != null) {
            val width = dimensionMatch.groupValues[1].toDoubleOrNull() ?: 0.0
            val height = dimensionMatch.groupValues[2].toDoubleOrNull() ?: 0.0
            val unit = dimensionMatch.groupValues[3].trim()

            // 치수 정보는 원래 형식을 유지하도록 수량은 0.0으로, 단위는 원본 그대로 반환
            return Pair("0.0", "${width}x${height}${unit}")
        }

        // 일반 숫자 패턴
        val numericPattern = "(\\d+[\\d./]*)\\s*(.*)".toRegex()
        val numericMatch = numericPattern.find(quantityUnit)

        return if (numericMatch != null) {
            val unit = numericMatch.groupValues[2].trim().let {
                if (it.isBlank()) null else it
            }
            Pair(numericMatch.groupValues[1].toString(), unit)
        } else {
            // 숫자가 없는 경우 ("약간", "조금" 등)
            if (quantityUnit.contains("약간") || quantityUnit.contains("조금") ||
                quantityUnit.contains("적당량") || quantityUnit.contains("적당히") ||
                quantityUnit.contains("소량")) {
                Pair("0.1", "소량")
            } else {
                Pair("0.0", quantityUnit.takeIf { it.isNotBlank() })
            }
        }
    }

    /**
     * 재료명 정제
     */
    private fun cleanIngredientName(name: String): String {
        return name
            .replace(Regex("\\([^)]*\\)"), "") // 괄호 내용 제거
            .replace(Regex("[^가-힣A-Za-z0-9 ]"), " ") // 특수문자 공백으로 변경
            .replace(Regex("\\s+"), " ") // 연속 공백 제거
            .trim()
    }

    /**
     * 재료가 선택적인지 확인
     */
    private fun isOptionalIngredient(name: String, description: String): Boolean {
        val optionalKeywords = listOf(
            "선택", "취향껏", "기호에 따라", "기호대로",
            "필요하면", "필요시", "있으면", "있다면",
            "없으면 생략", "생략 가능", "넣어도 됨", "안 넣어도 됨",
            "옵션", "optional"
        )

        val combinedText = "$name $description".lowercase(Locale.getDefault())
        return optionalKeywords.any { combinedText.contains(it.lowercase(Locale.getDefault())) }
    }

    /**
     * 기존 재료 찾기 또는 새로 생성
     */
    private fun findOrCreateIngredient(name: String): Ingredient {
        // 캐시에서 먼저 확인
        ingredientCache[name]?.let { return it }

        // 1. 정확히 일치하는 재료 찾기
        val exactMatch = ingredientRepository.findByNameIgnoreCase(name)
        if (exactMatch.isPresent) {
            val ingredient = exactMatch.get()
            ingredientCache[name] = ingredient
            return ingredient
        }

        // 2. 유사한 재료 찾기
        val normalizedName = normalizeName(name)
        val allIngredients = ingredientRepository.findAll()

        val similarIngredients = allIngredients.filter {
            calculateSimilarity(normalizedName, normalizeName(it.name)) > 0.8
        }

        if (similarIngredients.isNotEmpty()) {
            val bestMatch = similarIngredients.maxByOrNull {
                calculateSimilarity(normalizedName, normalizeName(it.name))
            }!!
            ingredientCache[name] = bestMatch
            logger.debug("유사 재료 매칭: '$name' -> '${bestMatch.name}'")
            return bestMatch
        }

        // 3. 새 재료 생성
        logger.info("새 재료 등록: '$name'")
        val ingredient = ingredientRepository.save(Ingredient(name = name))
        ingredientCache[name] = ingredient
        return ingredient
    }

    /**
     * 수량과 단위 정규화
     */
    private fun normalizeQuantityAndUnit(quantity: String, unit: String?): Pair<String, String?> {
        if (unit == null) return Pair(quantity.toString(), null)

        // 치수 패턴(예: 4x6cm) 감지 및 처리
        val dimensionPattern = "(\\d+)x(\\d+)(cm|mm|m)".toRegex(RegexOption.IGNORE_CASE)
        if (dimensionPattern.matches(unit)) {
            // 치수 단위는 그대로 유지
            return Pair(quantity.toString(), unit)
        }

        // 단위 정규화
        val normalizedUnit = unitMap[unit.lowercase(Locale.getDefault())] ?: unit

        // 필요한 경우 수량 변환 (예: 0.01kg -> 10g)
        var normalizedQuantity = quantity
        var finalUnit = normalizedUnit

        when {
            // kg -> g 변환 (1kg 미만인 경우)
            normalizedUnit == "kg" && quantity < "1.0" -> {
                normalizedQuantity = (quantity as Double * 1000).toString()
                finalUnit = "g"
            }
            // L -> ml 변환 (1L 미만인 경우)
            normalizedUnit == "L" && quantity < "1.0" -> {
                normalizedQuantity = (quantity as Double * 1000).toString()
                finalUnit = "ml"
            }
        }

        return Pair(normalizedQuantity.toString(), finalUnit)
    }

    /**
     * 재료명 정규화
     */
    private fun normalizeName(name: String): String {
        return name.trim()
            .lowercase(Locale.getDefault())
            .replace(Regex("[^가-힣a-z0-9]"), "") // 특수문자 및 공백 제거
    }

    /**
     * 레시피 타이틀 부분 제거
     * 예시: "●방울토마토 소박이 : \n방울토마토 150g(5개), 양파 10g(3×1cm), 부추 10g(5줄기)"
     * -> "방울토마토 150g(5개), 양파 10g(3×1cm), 부추 10g(5줄기)"
     */
    private fun removeRecipeTitles(text: String): String {
        val titlePattern = "(●[^:\\n]*)[:\\n]".toRegex()
        var processedText = text.trim()

        // 줄 단위로 분리
        val lines = processedText.lines()

        // 첫 줄이 타이틀로 보이면 제거
        if (lines.isNotEmpty()) {
            val firstLine = lines[0]
            val isTitleLike = !firstLine.contains(",") &&
                    !firstLine.contains("(") &&
                    firstLine.length <= 20 // 재료명은 보통 더 길고 복잡

            if (isTitleLike) {
                processedText = lines.drop(1).joinToString("\n")
            }
        }

        // 섹션 타이틀 제거 (예: "●양념장 : ")
        processedText = processedText.replace(titlePattern, "")

        // 단일 ● 문자 제거 (섹션 구분자 처리)
        processedText = processedText.replace("●", ",")

        // 콜론(:) 제거 및 정리
        processedText = processedText.replace(":", ",")

        // 연속된 쉼표 정리
        processedText = processedText.replace(Regex(",+"), ",")

        // 줄바꿈을 쉼표로 변환
        processedText = processedText.replace(Regex("\\n+"), ",")

        // 앞뒤 쉼표 제거
        return processedText.trim(',')
    }


    /**
     * 문자열 유사도 계산 (레벤슈타인 거리 기반)
     */
    private fun calculateSimilarity(s1: String, s2: String): Double {
        val distance = levenshteinDistance(s1, s2)
        val maxLength = maxOf(s1.length, s2.length)
        return if (maxLength == 0) 1.0 else 1.0 - (distance.toDouble() / maxLength)
    }

    /**
     * 레벤슈타인 거리 계산
     */
    private fun levenshteinDistance(s1: String, s2: String): Int {
        val m = s1.length
        val n = s2.length

        // 길이가 0인 경우 처리
        if (m == 0) return n
        if (n == 0) return m

        // 거리 행렬 초기화
        val d = Array(m + 1) { IntArray(n + 1) }

        // 행렬 초기 설정
        for (i in 0..m) {
            d[i][0] = i
        }

        for (j in 0..n) {
            d[0][j] = j
        }

        // 거리 계산
        for (j in 1..n) {
            for (i in 1..m) {
                val cost = if (s1[i - 1] == s2[j - 1]) 0 else 1
                d[i][j] = minOf(
                    d[i - 1][j] + 1,      // 삭제
                    d[i][j - 1] + 1,      // 삽입
                    d[i - 1][j - 1] + cost // 대체
                )
            }
        }

        return d[m][n]
    }

    /**
     * 재료 정보를 담는 내부 데이터 클래스
     */
    data class IngredientInfo(
        val name: String,
        val quantity: String,
        val unit: String?,
        val isOptional: Boolean = false,
        val extraQuantity: String? = null // 👈 추가

    )
}