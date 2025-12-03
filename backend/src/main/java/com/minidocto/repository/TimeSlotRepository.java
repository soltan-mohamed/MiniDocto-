package com.minidocto.repository;

import com.minidocto.model.TimeSlot;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
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
    
    @Query("{ 'professionalId': ?0, $or: [ " +
           "{ $and: [ { 'startTime': { $lt: ?2 } }, { 'endTime': { $gt: ?1 } } ] }, " +
           "{ $and: [ { 'startTime': { $gte: ?1 } }, { 'startTime': { $lt: ?2 } } ] }, " +
           "{ $and: [ { 'endTime': { $gt: ?1 } }, { 'endTime': { $lte: ?2 } } ] } " +
           "] }")
    List<TimeSlot> findOverlappingSlots(String professionalId, LocalDateTime startTime, LocalDateTime endTime);
    
    List<TimeSlot> findByAvailableAndEndTimeBefore(boolean available, LocalDateTime endTime);
}
