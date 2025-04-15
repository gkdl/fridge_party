package com.fridge.recipe.entity

import javax.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "recipe_images")
data class RecipeImage(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "recipe_id", nullable = false)
    val recipe: Recipe,
    
    @Column(name = "image_url", nullable = false)
    val imageUrl: String,
    
    @Column(name = "is_primary")
    val isPrimary: Boolean = false,
    
    @Column(name = "description")
    val description: String? = null,
    
    @Column(name = "created_at")
    val createdAt: LocalDateTime = LocalDateTime.now(),
    
    @Column(name = "updated_at")
    var updatedAt: LocalDateTime = LocalDateTime.now()
)