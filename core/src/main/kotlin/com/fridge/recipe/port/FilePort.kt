package com.fridge.recipe.port

import org.springframework.web.multipart.MultipartFile

interface FilePort {
    fun saveFile(file: MultipartFile, subDir: String = "images"): String
}