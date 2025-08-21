package com.fridge.recipe.config

import com.fridge.recipe.security.CustomInterceptor
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Configuration
import org.springframework.web.servlet.config.annotation.InterceptorRegistry
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer
import java.io.File
import javax.annotation.PostConstruct

@Configuration
class WebConfig (
    private val customInterceptor: CustomInterceptor
) : WebMvcConfigurer{
    private val logger = LoggerFactory.getLogger(WebConfig::class.java)

    @Value("\${file.upload.path}")
    private lateinit var uploadPath: String

    override fun addInterceptors(registry: InterceptorRegistry) {
        registry.addInterceptor(customInterceptor)
            .addPathPatterns("/**") // 필요한 URI 경로에만 적용
    }

    override fun addResourceHandlers(registry: ResourceHandlerRegistry) {
        // 이미지 파일 접근을 위한 리소스 핸들러 설정
        logger.info("Setting up resource handler for /uploads/**")
        logger.info("Upload path: $uploadPath")

        registry.addResourceHandler("/uploads/**")
            .addResourceLocations("file:$uploadPath/")
    }

    @PostConstruct
    fun init() {
        // 애플리케이션 시작 시 업로드 디렉토리 생성
        val directory = File(uploadPath)
        if (!directory.exists()) {
            val created = directory.mkdirs()
            if (created) {
                logger.info("Upload directory created: $uploadPath")
            } else {
                logger.warn("Failed to create upload directory: $uploadPath")
            }
        } else {
            logger.info("Upload directory already exists: $uploadPath")
        }

        // 하위 디렉토리도 미리 생성
        createSubDirectory("$uploadPath/recipe/images")
        createSubDirectory("$uploadPath/recipe/steps")
        createSubDirectory("$uploadPath/users/avatars")
    }

    private fun createSubDirectory(path: String) {
        val directory = File(path)
        if (!directory.exists()) {
            val created = directory.mkdirs()
            if (created) {
                logger.info("Sub-directory created: $path")
            } else {
                logger.warn("Failed to create sub-directory: $path")
            }
        }
    }
}