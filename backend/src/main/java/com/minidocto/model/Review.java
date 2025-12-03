package com.minidocto.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Data
@Document(collection = "reviews")
public class Review {
    @Id
    private String id;
    
    private String professionalId;
    private String patientId;
    private String appointmentId;
    private Integer rating;
    private String comment;
    private LocalDateTime createdAt;
    
    public Review() {
        this.createdAt = LocalDateTime.now();
    }
}
