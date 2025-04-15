package com.fridge.recipe.vo

/**
 * 소셜 로그인 정보를 담는 DTO
 * @property email 사용자 이메일
 * @property username 사용자 이름
 * @property provider 소셜 로그인 제공자 (google, kakao, naver)
 * @property providerId 소셜 로그인 제공자의 ID
 */
data class SocialLoginDTO(
    val email: String,
    val username: String,
    val provider: String,
    val providerId: String
)