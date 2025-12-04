package com.minidocto.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.minidocto.model.UserRole;
import lombok.Data;

@Data
public class AuthResponse {
    private String token;
    private String userId;
    private String email;
    private String firstName;
    private String lastName;
    
    @JsonProperty("role")
    private String roleString;
    
    private String speciality;
    
    public AuthResponse(String token, String userId, String email, 
                       String firstName, String lastName, UserRole role, String speciality) {
        this.token = token;
        this.userId = userId;
        this.email = email;
        this.firstName = firstName;
        this.lastName = lastName;
        this.roleString = role != null ? role.name() : null;
        this.speciality = speciality;
    }
}
