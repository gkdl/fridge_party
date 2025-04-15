import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("org.springframework.boot") version "2.7.12"
    id("io.spring.dependency-management") version "1.0.15.RELEASE"
    kotlin("jvm") version "1.6.21"
    kotlin("plugin.spring") version "1.6.21"
    kotlin("plugin.jpa") version "1.6.21"
    id("org.jetbrains.kotlin.plugin.allopen") version "1.6.21"
    id("org.jetbrains.kotlin.plugin.noarg") version "1.6.21"
}

group = "com.fridge.recipe"
version = "0.0.1-SNAPSHOT"

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(17)
    }
}

repositories {
    mavenCentral()
}

dependencies {
    // Spring Boot
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-security")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("org.springframework.boot:spring-boot-starter-tomcat")

    // OAuth2 클라이언트 (소셜 로그인)
    implementation("org.springframework.boot:spring-boot-starter-oauth2-client")

    // JSP 관련
    implementation("org.apache.tomcat.embed:tomcat-embed-jasper")
    implementation("javax.servlet:jstl:1.2")

    // Kotlin
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

    // Database
    implementation("org.mariadb.jdbc:mariadb-java-client:3.1.4")
    runtimeOnly("org.mariadb.jdbc:mariadb-java-client:3.1.4")

    // 개발 도구
    developmentOnly("org.springframework.boot:spring-boot-devtools")

    // 테스트
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.springframework.security:spring-security-test")

    // 기타 유틸리티
    implementation("org.apache.commons:commons-lang3:3.12.0")

    // Caffeine 캐시 (Guava 대체)
    implementation("com.github.ben-manes.caffeine:caffeine:3.1.5")
    implementation("org.springframework.boot:spring-boot-starter-cache")

    // Quartz 스케줄러
    implementation("org.springframework.boot:spring-boot-starter-quartz")

    // HTTP 클라이언트
    implementation("org.springframework.boot:spring-boot-starter-webflux")

    implementation(project(":core"))
    implementation(project(":infra"))
}


tasks.withType<Test> {
    useJUnitPlatform()
}
