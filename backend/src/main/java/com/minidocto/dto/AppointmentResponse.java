package com.minidocto.dto;

import com.minidocto.model.AppointmentStatus;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class AppointmentResponse {
    private String id;
    private String patientId;
    private String patientName;
    private String professionalId;
    private String professionalName;
    private String professionalSpeciality;
    private LocalDateTime appointmentTime;
    private AppointmentStatus status;
    private String reason;
    private String notes;
    private boolean hasReview;
    private Integer reviewRating;
}
