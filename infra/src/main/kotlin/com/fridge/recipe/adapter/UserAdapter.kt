package com.fridge.recipe.adapter

import com.fridge.recipe.entity.User
import com.fridge.recipe.entity.UserActivity
import com.fridge.recipe.enum.ActivityType
import com.fridge.recipe.port.UserPort
import com.fridge.recipe.repository.RecipeRepository
import com.fridge.recipe.repository.UserActivityRepository
import com.fridge.recipe.repository.UserRepository
import com.fridge.recipe.util.JwtUtil
import com.fridge.recipe.vo.*
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional
import java.time.format.DateTimeFormatter

@Component
class UserAdapter (
    private val userRepository: UserRepository,
    private val passwordEncoder: PasswordEncoder,
    private val userActivityRepository: UserActivityRepository,
    private val recipeRepository: RecipeRepository
) : UserPort {
    override fun getUserById(id: Long): UserDTO? {

        val userOptional = userRepository.findById(id)

        if (!userOptional.isPresent) {
            return null
        }

        val user = userOptional.get()
        return UserDTO(
            id = user.id,
            email = user.email,
            username = user.username
        )
    }

    override fun getUserByEmail(email: String): UserDTO? {
        val userOptional = userRepository.findByEmail(email)

        if (!userOptional.isPresent) {
            return null
        }

        val user = userOptional.get()
        return UserDTO(
            id = user.id,
            email = user.email,
            username = user.username
        )
    }

    @Transactional
    override fun registerUser(registrationDTO: UserRegistrationDTO): UserDTO {
        if (userRepository.existsByEmail(registrationDTO.email)) {
            throw IllegalArgumentException("이미 등록된 이메일입니다")
        }

        if (registrationDTO.password != registrationDTO.confirmPassword) {
            throw IllegalArgumentException("비밀번호가 일치하지 않습니다")
        }

        val user = User(
            email = registrationDTO.email,
            password = passwordEncoder.encode(registrationDTO.password),
            username = registrationDTO.username,
            emailNotifications = false  // 명시적으로 false 설정
        )

        val savedUser = userRepository.save(user)

        return UserDTO(
            id = savedUser.id,
            email = savedUser.email,
            username = savedUser.username
        )
    }
}