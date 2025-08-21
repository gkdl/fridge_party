package com.fridge.recipe.service

import com.fridge.recipe.port.FilePort
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.multipart.MultipartFile

@Service
@Transactional
class FileService(
    private val filePort: FilePort
) {

    fun saveFile(file: MultipartFile, subDir: String = "images"): String {
        return filePort.saveFile(file, subDir)
    }
}
