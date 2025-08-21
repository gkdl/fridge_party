package com.fridge.recipe.port

import com.fridge.recipe.enum.ActivityType
import com.fridge.recipe.vo.UserActivityCreateDTO
import com.fridge.recipe.vo.UserActivityDTO
import com.fridge.recipe.vo.UserDTO
import com.fridge.recipe.vo.UserRegistrationDTO

interface UserPort {
    fun getUserByEmail(email: String): UserDTO?

    fun registerUser(registrationDTO: UserRegistrationDTO): UserDTO
}