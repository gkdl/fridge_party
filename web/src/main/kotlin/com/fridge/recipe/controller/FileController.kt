package com.fridge.recipe.controller

import com.fridge.recipe.service.FileService
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.multipart.MultipartFile

@RestController
class FileController(
    private val fileService: FileService
) {

    /**
     * 이미지 파일 업로드 API
     * @param file 업로드할 이미지 파일
     * @param type 이미지 용도 (recipe - 레시피 이미지, step - 단계별 이미지)
     * @return 업로드된 이미지 파일의 URL
     */
    @PostMapping("/api/upload/image", consumes = [MediaType.MULTIPART_FORM_DATA_VALUE])
    fun uploadImage(
        @RequestParam("file") file: MultipartFile,
        @RequestParam("type", required = false, defaultValue = "recipe") type: String
    ): ResponseEntity<Map<String, Any>> {
        return try {
            val subDir = when (type) {
                "step" -> "recipe/steps"
                "avatar" -> "users/avatars"
                else -> "recipe/images"
            }
            
            val imageUrl = fileService.saveFile(file, subDir)
            
            ResponseEntity.ok(mapOf(
                "success" to true,
                "imageUrl" to imageUrl
            ))
        } catch (e: Exception) {
            ResponseEntity.status(HttpStatus.BAD_REQUEST).body(mapOf(
                "success" to false,
                "error" to (e.message ?: "파일 업로드 중 오류가 발생했습니다")
            ))
        }
    }
}