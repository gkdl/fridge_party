package com.fridge.recipe

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty

/**
 * 식품의약품안전처 레시피 API DTO
 */
@JsonIgnoreProperties(ignoreUnknown = true)
data class FoodApiResponse(
    @JsonProperty("COOKRCP01")
    val cookRecipe: FoodRecipeWrapper
)

@JsonIgnoreProperties(ignoreUnknown = true)
data class FoodRecipeWrapper(
    @JsonProperty("total_count")
    val totalCount: String,
    
    @JsonProperty("row")
    val recipes: List<FoodRecipeDTO>
)

/**
 * 식품의약품안전처 레시피 정보
 */
@JsonIgnoreProperties(ignoreUnknown = true)
data class FoodRecipeDTO(
    // 레시피 번호
    @JsonProperty("RCP_SEQ")
    val recipeId: String,
    
    // 레시피 이름
    @JsonProperty("RCP_NM")
    val recipeName: String,
    
    // 레시피 코드
    @JsonProperty("RCP_PAT2")
    val recipeCategory: String?,
    
    // 요리 종류
    @JsonProperty("RCP_WAY2")
    val cookingMethod: String?,
    
    // 레시피 소개
    @JsonProperty("RCP_PARTS_DTLS")
    val ingredients: String?,
    
    // 칼로리
    @JsonProperty("INFO_ENG")
    val calories: String?,
    
    // 탄수화물
    @JsonProperty("INFO_CAR")
    val carbohydrate: String?,
    
    // 단백질
    @JsonProperty("INFO_PRO")
    val protein: String?,
    
    // 지방
    @JsonProperty("INFO_FAT")
    val fat: String?,
    
    // 나트륨
    @JsonProperty("INFO_NA")
    val sodium: String?,
    
    // 대표 이미지 URL
    @JsonProperty("ATT_FILE_NO_MAIN")
    val mainImageUrl: String?,
    
    // 조리 과정 - 설명 및 이미지
    @JsonProperty("MANUAL01")
    val step1: String?,
    @JsonProperty("MANUAL_IMG01")
    val step1ImageUrl: String?,
    
    @JsonProperty("MANUAL02")
    val step2: String?,
    @JsonProperty("MANUAL_IMG02")
    val step2ImageUrl: String?,
    
    @JsonProperty("MANUAL03")
    val step3: String?,
    @JsonProperty("MANUAL_IMG03")
    val step3ImageUrl: String?,
    
    @JsonProperty("MANUAL04")
    val step4: String?,
    @JsonProperty("MANUAL_IMG04")
    val step4ImageUrl: String?,
    
    @JsonProperty("MANUAL05")
    val step5: String?,
    @JsonProperty("MANUAL_IMG05")
    val step5ImageUrl: String?,
    
    @JsonProperty("MANUAL06")
    val step6: String?,
    @JsonProperty("MANUAL_IMG06")
    val step6ImageUrl: String?,
    
    @JsonProperty("MANUAL07")
    val step7: String?,
    @JsonProperty("MANUAL_IMG07")
    val step7ImageUrl: String?,
    
    @JsonProperty("MANUAL08")
    val step8: String?,
    @JsonProperty("MANUAL_IMG08")
    val step8ImageUrl: String?,
    
    @JsonProperty("MANUAL09")
    val step9: String?,
    @JsonProperty("MANUAL_IMG09")
    val step9ImageUrl: String?,
    
    @JsonProperty("MANUAL10")
    val step10: String?,
    @JsonProperty("MANUAL_IMG10")
    val step10ImageUrl: String?,
    
    @JsonProperty("MANUAL11")
    val step11: String?,
    @JsonProperty("MANUAL_IMG11")
    val step11ImageUrl: String?,
    
    @JsonProperty("MANUAL12")
    val step12: String?,
    @JsonProperty("MANUAL_IMG12")
    val step12ImageUrl: String?,
    
    @JsonProperty("MANUAL13")
    val step13: String?,
    @JsonProperty("MANUAL_IMG13")
    val step13ImageUrl: String?,
    
    @JsonProperty("MANUAL14")
    val step14: String?,
    @JsonProperty("MANUAL_IMG14")
    val step14ImageUrl: String?,
    
    @JsonProperty("MANUAL15")
    val step15: String?,
    @JsonProperty("MANUAL_IMG15")
    val step15ImageUrl: String?,
    
    @JsonProperty("MANUAL16")
    val step16: String?,
    @JsonProperty("MANUAL_IMG16")
    val step16ImageUrl: String?,
    
    @JsonProperty("MANUAL17")
    val step17: String?,
    @JsonProperty("MANUAL_IMG17")
    val step17ImageUrl: String?,
    
    @JsonProperty("MANUAL18")
    val step18: String?,
    @JsonProperty("MANUAL_IMG18")
    val step18ImageUrl: String?,
    
    @JsonProperty("MANUAL19")
    val step19: String?,
    @JsonProperty("MANUAL_IMG19")
    val step19ImageUrl: String?,
    
    @JsonProperty("MANUAL20")
    val step20: String?,
    @JsonProperty("MANUAL_IMG20")
    val step20ImageUrl: String?
) {
    /**
     * 빈 문자열이 아닌 조리 과정 단계들만 추출
     */
    fun getValidSteps(): List<Pair<String, String?>> {
        val steps = mutableListOf<Pair<String, String?>>()
        
        if (!step1.isNullOrBlank()) steps.add(Pair(step1, step1ImageUrl))
        if (!step2.isNullOrBlank()) steps.add(Pair(step2, step2ImageUrl))
        if (!step3.isNullOrBlank()) steps.add(Pair(step3, step3ImageUrl))
        if (!step4.isNullOrBlank()) steps.add(Pair(step4, step4ImageUrl))
        if (!step5.isNullOrBlank()) steps.add(Pair(step5, step5ImageUrl))
        if (!step6.isNullOrBlank()) steps.add(Pair(step6, step6ImageUrl))
        if (!step7.isNullOrBlank()) steps.add(Pair(step7, step7ImageUrl))
        if (!step8.isNullOrBlank()) steps.add(Pair(step8, step8ImageUrl))
        if (!step9.isNullOrBlank()) steps.add(Pair(step9, step9ImageUrl))
        if (!step10.isNullOrBlank()) steps.add(Pair(step10, step10ImageUrl))
        if (!step11.isNullOrBlank()) steps.add(Pair(step11, step11ImageUrl))
        if (!step12.isNullOrBlank()) steps.add(Pair(step12, step12ImageUrl))
        if (!step13.isNullOrBlank()) steps.add(Pair(step13, step13ImageUrl))
        if (!step14.isNullOrBlank()) steps.add(Pair(step14, step14ImageUrl))
        if (!step15.isNullOrBlank()) steps.add(Pair(step15, step15ImageUrl))
        if (!step16.isNullOrBlank()) steps.add(Pair(step16, step16ImageUrl))
        if (!step17.isNullOrBlank()) steps.add(Pair(step17, step17ImageUrl))
        if (!step18.isNullOrBlank()) steps.add(Pair(step18, step18ImageUrl))
        if (!step19.isNullOrBlank()) steps.add(Pair(step19, step19ImageUrl))
        if (!step20.isNullOrBlank()) steps.add(Pair(step20, step20ImageUrl))
        
        return steps
    }
}