package com.fridge.recipe.vo

data class UserDTO(
    val id: Long? = null,
    val email: String,
    val username: String,
    val password: String? = null
)