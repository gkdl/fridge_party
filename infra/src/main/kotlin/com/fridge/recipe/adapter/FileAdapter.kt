package com.fridge.recipe.adapter

import com.fridge.recipe.port.FilePort
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Component
import org.springframework.web.multipart.MultipartFile
import java.io.File
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.*

@Component
class FileAdapter (
    @Value("\${file.upload.path:/tmp/uploads}") private var uploadPath: String
) : FilePort {
    /**
     * 이미지 파일 저장 및 접근 URL 반환
     * @param file 업로드할 파일
     * @param subDir 저장할 하위 디렉토리 (기본값 "images")
     * @return 저장된 파일의 접근 URL
     */
    override fun saveFile(file: MultipartFile, subDir: String): String {
        if (file.isEmpty) {
            throw IllegalArgumentException("파일이 비어있습니다")
        }

        // 허용된 이미지 파일만 업로드
        val contentType = file.contentType ?: ""
        if (!contentType.startsWith("image/")) {
            throw IllegalArgumentException("이미지 파일만 업로드 가능합니다")
        }

        // 현재 날짜를 포함한 디렉토리 생성
        val dateFormatter = DateTimeFormatter.ofPattern("yyyyMMdd")
        val dateDir = LocalDateTime.now().format(dateFormatter)

        // 최종 저장 경로
        val directory = File("$uploadPath/$subDir/$dateDir")
        if (!directory.exists()) {
            directory.mkdirs()
        }

        // 파일명 생성 (UUID 사용)
        val originalFilename = file.originalFilename ?: "image.jpg"
        val extension = originalFilename.substringAfterLast(".", "jpg")
        val saveFilename = "${UUID.randomUUID()}.$extension"

        // 파일 저장
        val targetFile = File(directory, saveFilename)
        file.transferTo(targetFile)

        // 파일 접근 URL 반환
        return "/uploads/$subDir/$dateDir/$saveFilename"
    }
}