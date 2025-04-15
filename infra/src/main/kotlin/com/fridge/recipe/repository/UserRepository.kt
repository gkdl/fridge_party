package com.fridge.recipe.repository

import com.fridge.recipe.entity.User
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface UserRepository : JpaRepository<User, Long> {
    fun findByEmail(email: String): Optional<User>
    fun existsByEmail(email: String): Boolean
    fun findByProviderAndProviderId(provider: String, providerId: String): Optional<User>
}
