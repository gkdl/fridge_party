package com.fridge.recipe.entity

import javax.persistence.*

@Entity
@Table(name = "recipe_ingredients")
data class RecipeIngredient(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "recipe_id", nullable = false)
    val recipe: Recipe,

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ingredient_id", nullable = false)
    val ingredient: Ingredient,

    @Column(length = 50)
    val quantity: String,

    @Column
    val unit: String? = null,

    @Column(name="extra_quantity")
    val extraQuantity: String? = null,

    @Column
    val optional: Boolean = false
) {
    override fun toString(): String {
        return "RecipeIngredient(id=$id, recipeId=${recipe.id}, ingredientId=${ingredient.id}, quantity=$quantity, unit=$unit, optional=$optional)"
    }
}
