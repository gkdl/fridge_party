package com.fridge.recipe.entity

import org.hibernate.annotations.CreationTimestamp
import org.hibernate.annotations.UpdateTimestamp
import javax.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "users")
class User(
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        val id: Long = 0,

        @Column(nullable = false, unique = true)
        var email: String,

        @Column(nullable = false)
        var password: String,

        @Column(nullable = false)
        var username: String,

        @CreationTimestamp
        @Column(name = "created_at")
        val createdAt: LocalDateTime = LocalDateTime.now(),

        @UpdateTimestamp
        @Column(name = "updated_at")
        var updatedAt: LocalDateTime = LocalDateTime.now(),

        @Column(name = "provider")
        var provider: String? = null, // "google", "kakao", "naver" 등

        @Column(name = "provider_id")
        var providerId: String? = null,

        @Column(name = "image_url")
        var imageUrl: String? = null,

        @Column(name = "email_notifications", nullable = true)
        var emailNotifications: Boolean? = false,

        @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], orphanRemoval = true, fetch = FetchType.LAZY)
        val ingredients: MutableSet<UserIngredient> = mutableSetOf(),

        @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], orphanRemoval = true, fetch = FetchType.LAZY)
        val recipes: MutableList<Recipe> = mutableListOf(),

        @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], orphanRemoval = true, fetch = FetchType.LAZY)
        val favorites: MutableList<Favorite> = mutableListOf(),

        @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], orphanRemoval = true, fetch = FetchType.LAZY)
        val ratings: MutableList<Rating> = mutableListOf(),

        @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], orphanRemoval = true, fetch = FetchType.LAZY)
        val activities: MutableList<UserActivity> = mutableListOf()
) {
    /**
     * toString() 메서드 오버라이드
     * LazyInitializationException 방지를 위해 지연 로딩 컬렉션은 제외
     */
    override fun toString(): String {
        return "User(id=$id, email='$email', username='$username', provider=$provider, providerId=$providerId)"
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as User

        if (id != other.id) return false
        if (email != other.email) return false
        if (username != other.username) return false
        if (provider != other.provider) return false
        if (providerId != other.providerId) return false

        return true
    }

    override fun hashCode(): Int {
        var result = id.hashCode()
        result = 31 * result + email.hashCode()
        result = 31 * result + username.hashCode()
        result = 31 * result + (provider?.hashCode() ?: 0)
        result = 31 * result + (providerId?.hashCode() ?: 0)
        return result
    }
}
