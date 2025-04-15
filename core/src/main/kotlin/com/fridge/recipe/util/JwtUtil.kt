package com.fridge.recipe.util

import io.jsonwebtoken.Claims
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureAlgorithm
import io.jsonwebtoken.security.Keys
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Component
import java.util.*

@Component
class JwtUtil {

    @Value("\${jwt.secret:not_used}")
    private lateinit var secret: String
    
    @Value("\${jwt.expiration:not_used}")
    private var expiration: Long = 0 // 24시간 (밀리초)

    fun extractUsername(token: String): String {
        return extractClaim(token, Claims::getSubject)
    }
    
    fun extractUserId(token: String): Long {
        return extractAllClaims(token).get("userId", Integer::class.java).toLong()
    }

    fun extractExpiration(token: String): Date {
        return extractClaim(token, Claims::getExpiration)
    }

    fun <T> extractClaim(token: String, claimsResolver: (Claims) -> T): T {
        val claims = extractAllClaims(token)
        return claimsResolver(claims)
    }

    private fun extractAllClaims(token: String): Claims {
        val key = Keys.hmacShaKeyFor(Base64.getDecoder().decode(secret));

        return Jwts.parserBuilder()
            .setSigningKey(key)
            .build()
            .parseClaimsJws(token).body
    }

    private fun isTokenExpired(token: String): Boolean {
        return extractExpiration(token).before(Date())
    }

    fun createToken(username: String): String {
        val claims = HashMap<String, Any>()
        val key = Keys.hmacShaKeyFor(Base64.getDecoder().decode(secret))

        return Jwts.builder()
            .setClaims(claims)
            .setSubject(username)
            .setIssuedAt(Date(System.currentTimeMillis()))
            .setExpiration(Date(System.currentTimeMillis() + expiration))
            .signWith(key, SignatureAlgorithm.HS256)
            .compact()
    }

    fun validateToken(token: String): Boolean {
        return !isTokenExpired(token)
    }
}
