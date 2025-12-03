package com.minidocto.model;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Data
@Document(collection = "time_slots")
public class TimeSlot {
    @Id
    private String id;
    
    private String professionalId;
    
    private LocalDateTime startTime;
    
    private LocalDateTime endTime;
    
    private boolean available = true;
    
    private LocalDateTime createdAt;
}
