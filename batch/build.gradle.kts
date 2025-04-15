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
    implementation("org.springframework.boot:spring-boot-starter")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit5")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")

    // Quartz 스케줄러
    implementation("org.springframework.boot:spring-boot-starter-quartz")

    // HTTP 클라이언트
    implementation("org.springframework.boot:spring-boot-starter-webflux")

    // Database
    implementation("org.mariadb.jdbc:mariadb-java-client:3.1.4")
    runtimeOnly("org.mariadb.jdbc:mariadb-java-client:3.1.4")

    implementation(project(":core"))
    implementation(project(":infra"))
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

