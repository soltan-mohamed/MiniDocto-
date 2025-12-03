package com.minidocto.repository;

import com.minidocto.model.TimeSlot;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface TimeSlotRepository extends MongoRepository<TimeSlot, String> {
    List<TimeSlot> findByProfessionalIdAndAvailableAndStartTimeAfter(
        String professionalId, 
        boolean available, 
        LocalDateTime startTime
    );
    
    List<TimeSlot> findByProfessionalId(String professionalId);
}
