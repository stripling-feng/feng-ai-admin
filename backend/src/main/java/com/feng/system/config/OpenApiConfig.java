package com.feng.system.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI fengAdminOpenApi() {
        return new OpenAPI()
                .info(new Info()
                        .title("Feng AI Admin API")
                        .description("Spring Boot 3 + Vue 3 快速开发脚手架接口文档")
                        .version("1.0.0")
                        .contact(new Contact().name("feng-ai-admin"))
                        .license(new License().name("Apache 2.0")));
    }
}
