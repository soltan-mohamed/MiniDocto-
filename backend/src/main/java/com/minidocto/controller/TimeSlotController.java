package com.minidocto.controller;

import com.minidocto.dto.TimeSlotRequest;
import com.minidocto.model.TimeSlot;
import com.minidocto.service.TimeSlotService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/timeslots")
public class TimeSlotController {
    
    @Autowired
    private TimeSlotService timeSlotService;
    
    @PostMapping
    public ResponseEntity<TimeSlot> createTimeSlot(
            Authentication authentication,
            @Valid @RequestBody TimeSlotRequest request) {
        String professionalId = authentication.getName();
        TimeSlot timeSlot = timeSlotService.createTimeSlot(professionalId, request);
        return ResponseEntity.ok(timeSlot);
    }
    
    @GetMapping("/professional/{professionalId}/available")
    public ResponseEntity<List<TimeSlot>> getAvailableSlots(@PathVariable String professionalId) {
        timeSlotService.updateExpiredSlots();
        List<TimeSlot> slots = timeSlotService.getAvailableSlots(professionalId);
        return ResponseEntity.ok(slots);
    }
    
    @GetMapping("/my-slots")
    public ResponseEntity<List<TimeSlot>> getMySlots(Authentication authentication) {
        String professionalId = authentication.getName();
        List<TimeSlot> slots = timeSlotService.getProfessionalSlots(professionalId);
        return ResponseEntity.ok(slots);
    }
    
    @DeleteMapping("/{slotId}")
    public ResponseEntity<Void> deleteTimeSlot(
            Authentication authentication,
            @PathVariable String slotId) {
        String professionalId = authentication.getName();
        timeSlotService.deleteTimeSlot(professionalId, slotId);
        return ResponseEntity.ok().build();
    }
}
