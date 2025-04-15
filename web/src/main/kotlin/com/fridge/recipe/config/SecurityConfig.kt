package com.fridge.recipe.config

import com.fridge.recipe.security.CustomLoginSuccessHandler
import com.fridge.recipe.security.CustomLogoutSuccessHandler
import com.fridge.recipe.security.CustomUserDetailsService
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Lazy
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter
import org.springframework.security.config.http.SessionCreationPolicy

/**
 * Spring Security 설정 클래스
 */
@Configuration
@EnableWebSecurity
class SecurityConfig (
    private val customUserDetailsService: CustomUserDetailsService,
    @Lazy private val customLogoutSuccessHandler: CustomLogoutSuccessHandler,
    @Lazy private val customLoginSuccessHandler: CustomLoginSuccessHandler

) : WebSecurityConfigurerAdapter() {

//    @Autowired
//    @Lazy
//    private lateinit var jwtAuthenticationFilter: JwtAuthenticationFilter

    /**
     * HTTP 보안 설정
     * @param http HttpSecurity 객체
     */
    override fun configure(http: HttpSecurity) {
        http
            .csrf().disable()
            .headers().frameOptions().disable()
            .and()
            
            // 세션 관리 정책 설정 - 세션이 필요할 경우에만 생성
            .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.ALWAYS)
            .and()
            
            .authorizeRequests()
                .antMatchers("/", "/error", "/favicon.ico", "/**/*.png", "/**/*.gif", "/**/*.svg",
                    "/**/*.jpg", "/**/*.html", "/**/*.css", "/**/*.js", "/resources/**", "/images/**",
                    "/user/login", "/user/signup", "/recipe/list", "/recipe/view/**",
                    "/api/**", "/oauth2/**", "/register")
                .permitAll()
                .anyRequest().authenticated()
            .and()
            
            .formLogin()
                .loginPage("/login")
                .defaultSuccessUrl("/")
                .usernameParameter("email")   // 여기서 이름 바꿔줌
                .passwordParameter("password")
                .successHandler(customLoginSuccessHandler)
                .permitAll()
            .and()
            
            .logout()
                .logoutUrl("/api/auth/logout")
                .logoutSuccessUrl("/")
                .logoutSuccessHandler(customLogoutSuccessHandler)
                .deleteCookies("token", "userId")
                .invalidateHttpSession(true)
                .clearAuthentication(true)
                .permitAll()
            .and()
            .userDetailsService(customUserDetailsService)

        // JWT 필터를 UsernamePasswordAuthenticationFilter 이전에 추가
        //http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter::class.java)
    }
}