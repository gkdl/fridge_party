package com.fridge.recipe.vo

data class UserRegistrationDTO(
    val email: String,
    val username: String,
    val password: String,
    val confirmPassword: String
)