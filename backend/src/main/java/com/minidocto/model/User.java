package com.minidocto.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.index.Indexed;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Data
@Document(collection = "users")
public class User {
    @Id
    private String id;
    
    @Indexed(unique = true)
    private String email;
    
    private String password;
    
    private String firstName;
    
    private String lastName;
    
    private String phone;
    
    private UserRole role;

    private String speciality;
    
    private String description;
    
    private Integer score = 20;
    
    private String address;
    
    private LocalDateTime createdAt;
    
    private LocalDateTime updatedAt;
    
    private boolean active = true;
}
