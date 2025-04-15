package com.fridge.recipe.service

import com.fridge.recipe.port.UserPort
import com.fridge.recipe.vo.UserDTO
import com.fridge.recipe.vo.UserLoginDTO
import com.fridge.recipe.vo.UserRegistrationDTO
import org.springframework.stereotype.Service

@Service
class UserService(
    private val userPort: UserPort
) {
    fun getUserById(id: Long): UserDTO? {
        return userPort.getUserById(id)
    }

    fun getUserByEmail(email: String): UserDTO? {
        return userPort.getUserByEmail(email)
    }

    fun registerUser(registrationDTO: UserRegistrationDTO): UserDTO {
        return userPort.registerUser(registrationDTO)
    }
}
