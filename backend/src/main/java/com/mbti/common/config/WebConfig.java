package com.mbti.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig {

    // @Value("${file.profile.upload.path}")
    // private String fileUploadPath;
    //
    // @Value("${file.story.upload.path}")
    // private String storyUploadPath;
    //
    // @Value("${file.post.upload.path}")
    // private String postUploadPath;

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                // REST API CORS 설정
                // edge, chrome 의 경우 개발자가 개발을 하기 위한 테스트 모드 -> 매번 포트 번호가 바뀐다.
                // 1. debug print 를 사용해서 개발자가 작성한 데이터나 기능 결과를 확인할 수 있음.
                // 2. 테스트가 종료되고 나면 웹사이트를 필요로 하지 않으나,
                // 3. 상황에 따라 테스트 모드 웹사이트를 배포용 웹사이트로 사용할 수 있음.
                // 4. 다시 시작할 때 마다 변경되는 포트 번호를 고정적으로 변경해서 사용할 수 있다.
                registry.addMapping("/api/**")
                        .allowedOrigins("http://localhost:57472",
                                "http://localhost:3000", // iOS 테스트에서는 8080 사용
                                "http://localhost:55617",
                                "http://10.0.2.2:8080"   // 안드로이드 핸드폰 테스트
                        )
                        .allowCredentials(true)
                        .allowedMethods("GET","POST","PUT","DELETE","PATCH","OPTIONS")
                        .allowedHeaders("*");

                // WebSocket CORS 설정 추가
                // registry.addMapping("/ws/**")
                //         .allowedOrigins("http://localhost:57472",
                //                 "http://localhost:3000",
                //                 "http://localhost:54829",
                //                 "https://insta-front-orcin.vercel.app/")
                //         .allowCredentials(true)
                //         .allowedMethods("GET","POST","PUT","DELETE","PATCH","OPTIONS")
                //         .allowedHeaders("*");
            }
        };
    }

    // @Override
    // public void addResourceHandlers(ResourceHandlerRegistry registry) {
    //     registry.addResourceHandler("/profile_images/**")
    //             .addResourceLocations("file:" + fileUploadPath + "/");
    //
    //     registry.addResourceHandler("/story_images/**")
    //             .addResourceLocations("file:" + storyUploadPath + "/");
    //
    //     registry.addResourceHandler("/post_images/**")
    //             .addResourceLocations("file:" + postUploadPath + "/");
    // }
}
