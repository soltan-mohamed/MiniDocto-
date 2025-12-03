package com.minidocto.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class TimeSlotRequest {
    @NotNull(message = "L'heure de début est obligatoire")
    private LocalDateTime startTime;
    
    @NotNull(message = "L'heure de fin est obligatoire")
    private LocalDateTime endTime;
}
