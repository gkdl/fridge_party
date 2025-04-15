package com.fridge.recipe.security

import com.fridge.recipe.repository.UserRepository
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.core.userdetails.UsernameNotFoundException
import org.springframework.stereotype.Service

@Service
class CustomUserDetailsService(
    private val userRepository: UserRepository  // 너 DB 접근하는 리포지토리
) : UserDetailsService {
    override fun loadUserByUsername(username: String): UserDetails {
        val user = userRepository.findByEmail(username)

        if (!user.isPresent) {
            throw UsernameNotFoundException("사용자를 찾을 수 없습니다: $username")
        }

        return CustomUserDetails (
            id = user.get().id,
            username = user.get().username,
            password = user.get().password,
            listOf(SimpleGrantedAuthority("ROLE_USER"))  // 권한 설정
        )
    }
}