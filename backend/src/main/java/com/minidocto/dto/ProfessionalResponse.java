package com.minidocto.dto;

import lombok.Data;

@Data
public class ProfessionalResponse {
    private String id;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String speciality;
    private String description;
    private Integer score;
    private String address;
}
