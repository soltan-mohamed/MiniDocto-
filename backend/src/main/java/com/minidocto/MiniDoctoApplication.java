package com.minidocto;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.mongodb.config.EnableMongoAuditing;

@SpringBootApplication
@EnableMongoAuditing
public class MiniDoctoApplication {
    public static void main(String[] args) {
        SpringApplication.run(MiniDoctoApplication.class, args);
    }
}
