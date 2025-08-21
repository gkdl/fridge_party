package com.fridge.recipe.entity

import com.fridge.recipe.enum.IngredientAvailability
import com.fridge.recipe.enum.Season
import javax.persistence.*

@Entity
@Table(name = "ingredients")
data class Ingredient(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @Column(nullable = false)
    val name: String,

    @Column
    val category: String? = null, // 예: 육류, 채소류, 유제품 등

    @Column
    val unit: String? = null, // 예: g, ml, 개 등
    
    // 계절별 가용성
    @Column(name = "spring_availability")
    @Enumerated(EnumType.STRING)
    val springAvailability: IngredientAvailability = IngredientAvailability.MEDIUM,

    @Column(name = "summer_availability")
    @Enumerated(EnumType.STRING)
    val summerAvailability: IngredientAvailability = IngredientAvailability.MEDIUM,

    @Column(name = "fall_availability")
    @Enumerated(EnumType.STRING)
    val fallAvailability: IngredientAvailability = IngredientAvailability.MEDIUM,

    @Column(name = "winter_availability")
    @Enumerated(EnumType.STRING)
    val winterAvailability: IngredientAvailability = IngredientAvailability.MEDIUM,
    
    // 식재료에 대한 추가 정보
    @Column(name = "description", columnDefinition = "TEXT")
    val description: String? = null,

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "ingredient", cascade = [CascadeType.ALL], orphanRemoval = true)
    val userIngredients: MutableList<UserIngredient> = mutableListOf(),

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "ingredient", cascade = [CascadeType.ALL], orphanRemoval = true)
    val recipeIngredients: MutableList<RecipeIngredient> = mutableListOf()
) {
    // 현재 계절에 따른 가용성 반환
    fun getAvailabilityForSeason(season: Season): IngredientAvailability {
        return when (season) {
            Season.SPRING -> springAvailability
            Season.SUMMER -> summerAvailability
            Season.FALL -> fallAvailability
            Season.WINTER -> winterAvailability
            Season.ALL -> IngredientAvailability.HIGH // ALL은 항상 HIGH로 간주
        }
    }

    override fun toString(): String {
        return "Ingredient(id=$id, name=$name, category=$category, unit=$unit)"
    }
}
