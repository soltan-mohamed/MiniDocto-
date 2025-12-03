package com.minidocto.service;

import com.minidocto.dto.TimeSlotRequest;
import com.minidocto.exception.BadRequestException;
import com.minidocto.exception.NotFoundException;
import com.minidocto.model.TimeSlot;
import com.minidocto.model.User;
import com.minidocto.model.UserRole;
import com.minidocto.repository.TimeSlotRepository;
import com.minidocto.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class TimeSlotService {
    
    @Autowired
    private TimeSlotRepository timeSlotRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    public TimeSlot createTimeSlot(String professionalId, TimeSlotRequest request) {
        User professional = userRepository.findById(professionalId)
            .orElseThrow(() -> new NotFoundException("Professionnel non trouvé"));
        
        if (professional.getRole() != UserRole.PROFESSIONAL) {
            throw new BadRequestException("Seuls les professionnels peuvent créer des créneaux");
        }
        
        if (request.getStartTime().isBefore(LocalDateTime.now())) {
            throw new BadRequestException("Impossible de créer un créneau dans le passé");
        }
        
        if (request.getEndTime().isBefore(request.getStartTime())) {
            throw new BadRequestException("L'heure de fin doit être après l'heure de début");
        }
        
        TimeSlot timeSlot = new TimeSlot();
        timeSlot.setProfessionalId(professionalId);
        timeSlot.setStartTime(request.getStartTime());
        timeSlot.setEndTime(request.getEndTime());
        timeSlot.setAvailable(true);
        timeSlot.setCreatedAt(LocalDateTime.now());
        
        return timeSlotRepository.save(timeSlot);
    }
    
    public List<TimeSlot> getAvailableSlots(String professionalId) {
        return timeSlotRepository.findByProfessionalIdAndAvailableAndStartTimeAfter(
            professionalId, true, LocalDateTime.now()
        );
    }
    
    public List<TimeSlot> getProfessionalSlots(String professionalId) {
        return timeSlotRepository.findByProfessionalId(professionalId);
    }
    
    public void deleteTimeSlot(String professionalId, String slotId) {
        TimeSlot timeSlot = timeSlotRepository.findById(slotId)
            .orElseThrow(() -> new NotFoundException("Créneau non trouvé"));
        
        if (!timeSlot.getProfessionalId().equals(professionalId)) {
            throw new BadRequestException("Vous ne pouvez supprimer que vos propres créneaux");
        }
        
        timeSlotRepository.delete(timeSlot);
    }
}
