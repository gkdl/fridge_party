package com.fridge.recipe.entity

import com.fridge.recipe.enum.Season
import com.fridge.recipe.vo.RecipeCreateDTO
import javax.persistence.CascadeType
import java.time.LocalDateTime
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.EnumType
import javax.persistence.Enumerated
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne
import javax.persistence.OneToMany
import javax.persistence.OrderBy
import javax.persistence.Table

@Entity
@Table(name = "recipes")
class Recipe(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @Column(nullable = false)
    var title: String,

    @Column(columnDefinition = "TEXT")
    var description: String? = null,

    @Column(columnDefinition = "TEXT")
    var instructions: String? = null, // 레거시 지원을 위해 유지 (단계별 조리법 도입으로 선택사항)

    @Column(name = "cooking_time")
    var cookingTime: Int? = null, // 분 단위

    @Column(name = "serving_size")
    var servingSize: Int? = null,

    @Column(name = "image_url")
    var imageUrl: String? = null, // 레거시 지원을 위해 유지 (단일 이미지)

    // 계절 정보 추가
    @Enumerated(EnumType.STRING)
    @Column(name = "season")
    var season: Season = Season.ALL,

    // 태그 정보 (계절적 특성, 재료 특성 등에 활용)
    @Column(name = "tags")
    var tags: String? = null,

    @Column(name = "created_at")
    val createdAt: LocalDateTime = LocalDateTime.now(),

    @Column(name = "updated_at")
    var updatedAt: LocalDateTime = LocalDateTime.now(),

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    val user: User,

    @OneToMany(mappedBy = "recipe", cascade = [CascadeType.ALL], orphanRemoval = true, fetch = FetchType.LAZY)
    val ingredients: MutableList<RecipeIngredient> = mutableListOf(),

    @OneToMany(mappedBy = "recipe", cascade = [CascadeType.ALL], orphanRemoval = true, fetch = FetchType.LAZY)
    val favorites: MutableList<Favorite> = mutableListOf(),

    @OneToMany(mappedBy = "recipe", cascade = [CascadeType.ALL], orphanRemoval = true, fetch = FetchType.LAZY)
    val ratings: MutableList<Rating> = mutableListOf(),

    // 다중 이미지 지원
    @OneToMany(mappedBy = "recipe", cascade = [CascadeType.ALL], orphanRemoval = true, fetch = FetchType.LAZY)
    val images: MutableList<RecipeImage> = mutableListOf(),

    // 단계별 조리법 지원
    @OneToMany(mappedBy = "recipe", cascade = [CascadeType.ALL], orphanRemoval = true, fetch = FetchType.LAZY)
    @OrderBy("stepNumber")
    val steps: MutableList<RecipeStep> = mutableListOf(),

    @Column(name = "avg_rating")
    var avgRating: Double = 0.0,

    // 외부 API ID
    @Column(name = "external_id", unique = true)
    var externalId: String? = null,

    // 난이도
    @Column(name = "difficulty")
    var difficulty: String? = null,

    // 카테고리
    @Column(name = "category")
    var category: String? = null,

    // 메인 이미지 URL
    @Column(name = "primary_image_url")
    var primaryImageUrl: String? = null,

    // 영양소 정보
    @Column(name = "calories")
    var calories: Double? = null,

    @Column(name = "carbohydrate")
    var carbohydrate: Double? = null,

    @Column(name = "protein")
    var protein: Double? = null,

    @Column(name = "fat")
    var fat: Double? = null,

    @Column(name = "sodium")
    var sodium: Double? = null,
) {
    /**
     * equals, hashCode, toString 메서드 구현
     * data class에서 일반 class로 변경되어 직접 구현 필요
     */
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as Recipe

        if (id != other.id) return false
        if (title != other.title) return false
        if (externalId != other.externalId) return false

        return true
    }

    override fun hashCode(): Int {
        var result = id.hashCode()
        result = 31 * result + title.hashCode()
        result = 31 * result + (externalId?.hashCode() ?: 0)
        return result
    }

    override fun toString(): String {
        return "Recipe(id=$id, title='$title', category=$category, externalId=$externalId)"
    }

    fun updateFrom(dto: RecipeCreateDTO) {
        this.title = dto.title
        this.description = dto.description
        this.instructions = dto.instructions
        this.cookingTime = dto.cookingTime
        this.servingSize = dto.servingSize
        this.imageUrl = dto.imageUrl ?: this.imageUrl
        this.updatedAt = LocalDateTime.now()
    }
}