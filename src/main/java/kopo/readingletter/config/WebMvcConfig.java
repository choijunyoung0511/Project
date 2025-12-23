package kopo.readingletter.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        registry.addInterceptor(new LoginInterceptor())
                .addPathPatterns("/**") // ✅ 전체 보호 ("/" 포함)
                .excludePathPatterns(
                        "/auth/**",      // 로그인/회원가입/로그아웃
                        "/error",

                        // ✅ 정적 리소스(이거 안 빼면 css/js가 막힘)
                        "/css/**", "/js/**", "/images/**",
                        "/webjars/**",
                        "/auth/**"       // /auth/auth.css 같은 경로 쓰면 이것도 포함
                );
    }
}
