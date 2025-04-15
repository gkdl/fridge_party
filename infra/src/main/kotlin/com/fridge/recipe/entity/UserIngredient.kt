package com.fridge.recipe.entity

import javax.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "user_ingredients")
class UserIngredient(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        val id: Long = 0,

        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "user_id", nullable = false)
        val user: User,

        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "ingredient_id", nullable = false)
        val ingredient: Ingredient,

        @Column(length = 50)
        val quantity: String? = null,

        @Column
        val unit: String? = null,

        @Column(name = "expiry_date")
        val expiryDate: LocalDateTime? = null,

        @Column(name = "added_at")
        val addedAt: LocalDateTime = LocalDateTime.now(),

        @Column(name = "updated_at")
        var updatedAt: LocalDateTime = LocalDateTime.now()
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as UserIngredient

        if (id != other.id) return false
        if (user.id != other.user.id) return false // 주의: 객체 자체가 아닌 ID만 비교
        if (ingredient.id != other.ingredient.id) return false // 주의: 객체 자체가 아닌 ID만 비교
        if (quantity != other.quantity) return false
        if (unit != other.unit) return false
        if (expiryDate != other.expiryDate) return false

        return true
    }

    override fun hashCode(): Int {
        var result = id.hashCode()
        result = 31 * result + user.id.hashCode() // 주의: 객체 자체가 아닌 ID만 사용
        result = 31 * result + ingredient.id.hashCode() // 주의: 객체 자체가 아닌 ID만 사용
        result = 31 * result + (quantity?.hashCode() ?: 0)
        result = 31 * result + (unit?.hashCode() ?: 0)
        result = 31 * result + (expiryDate?.hashCode() ?: 0)
        return result
    }

    override fun toString(): String {
        return "UserIngredient(id=$id, userId=${user.id}, ingredientId=${ingredient.id}, quantity=$quantity, unit=$unit, expiryDate=$expiryDate)"
    }
}
