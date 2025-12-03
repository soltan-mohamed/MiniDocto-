package com.minidocto.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class AppointmentRequest {
    @NotBlank(message = "L'ID du professionnel est obligatoire")
    private String professionalId;
    
    @NotBlank(message = "L'ID du créneau est obligatoire")
    private String timeSlotId;
    
    private String reason;
}
