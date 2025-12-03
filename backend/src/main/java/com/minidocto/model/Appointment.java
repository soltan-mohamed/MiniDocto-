package com.minidocto.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Data
@Document(collection = "appointments")
public class Appointment {
    @Id
    private String id;
    
    private String patientId;
    
    private String professionalId;
    
    private String timeSlotId;
    
    private LocalDateTime appointmentTime;
    
    private AppointmentStatus status;
    
    private String reason;
    
    private String notes;
    
    private boolean hasReview = false;
    
    private LocalDateTime createdAt;
    
    private LocalDateTime updatedAt;
}
