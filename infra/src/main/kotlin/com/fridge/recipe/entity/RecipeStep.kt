package com.fridge.recipe.entity

import javax.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "recipe_steps")
data class RecipeStep(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "recipe_id", nullable = false)
    val recipe: Recipe,
    
    @Column(name = "step_number", nullable = false)
    val stepNumber: Int, // 단계 번호 (순서)
    
    @Column(name = "description", nullable = false, columnDefinition = "TEXT")
    val description: String, // 단계별 조리 설명
    
    @Column(name = "image_url")
    val imageUrl: String? = null, // 단계별 이미지 URL
    
    @Column(name = "created_at")
    val createdAt: LocalDateTime = LocalDateTime.now(),
    
    @Column(name = "updated_at")
    var updatedAt: LocalDateTime = LocalDateTime.now()
) {
    override fun toString(): String {
        return "RecipeStep(id=$id, recipeId=${recipe.id}, stepNumber=$stepNumber, description=${description.take(30)}..., imageUrl=$imageUrl)"
    }

    @PreRemove
    fun beforeRemove() {
        println("About to remove RecipeStep with id $id") // 여기서 로그를 찍을 수 있습니다.
    }

    @PostRemove
    fun afterRemove() {
        println("Successfully removed RecipeStep with id $id") // 삭제 후 로그 찍기
    }
}