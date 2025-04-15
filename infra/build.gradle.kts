import org.springframework.boot.gradle.tasks.bundling.BootJar

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
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit5")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")

    api("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-security")

    implementation(project(":core"))
}

tasks.withType<Test> {
    useJUnitPlatform()
}

//true 로 설정하게 되면 main 클래스를 찾기 때문에 에러가 발생
tasks.getByName<BootJar>("bootJar") {
    enabled = false
}

//true로 설정하면 xxx-plain.jar 파일이 생성(클래스와 리소스만 포함)
tasks.getByName<Jar>("jar") {
    enabled = true
}

// allOpen 플러그인 설정 - JPA 엔티티 클래스의 Lazy Loading을 위해 필요
allOpen {
    annotation("javax.persistence.Entity")
    annotation("javax.persistence.MappedSuperclass")
    annotation("javax.persistence.Embeddable")
}

// noArg 플러그인 설정 - JPA 엔티티 클래스의 기본 생성자 자동 생성
noArg {
    annotation("javax.persistence.Entity")
    annotation("javax.persistence.MappedSuperclass")
    annotation("javax.persistence.Embeddable")
    invokeInitializers = true
}
