package com.minidocto.service;

import com.minidocto.dto.AppointmentRequest;
import com.minidocto.dto.AppointmentResponse;
import com.minidocto.exception.BadRequestException;
import com.minidocto.exception.NotFoundException;
import com.minidocto.model.*;
import com.minidocto.repository.AppointmentRepository;
import com.minidocto.repository.TimeSlotRepository;
import com.minidocto.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class AppointmentService {
    
    @Autowired
    private AppointmentRepository appointmentRepository;
    
    @Autowired
    private TimeSlotRepository timeSlotRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Transactional
    public Appointment createAppointment(String patientId, AppointmentRequest request) {
        User patient = userRepository.findById(patientId)
            .orElseThrow(() -> new NotFoundException("Patient non trouvé"));
        
        if (patient.getRole() != UserRole.PATIENT) {
            throw new BadRequestException("Seuls les patients peuvent créer des rendez-vous");
        }
        
        TimeSlot timeSlot = timeSlotRepository.findById(request.getTimeSlotId())
            .orElseThrow(() -> new NotFoundException("Créneau non trouvé"));
        
        if (!timeSlot.isAvailable()) {
            throw new BadRequestException("Ce créneau n'est plus disponible");
        }
        
        if (!timeSlot.getProfessionalId().equals(request.getProfessionalId())) {
            throw new BadRequestException("Créneau invalide pour ce professionnel");
        }
        
        // Marquer le créneau comme non disponible
        timeSlot.setAvailable(false);
        timeSlotRepository.save(timeSlot);
        
        Appointment appointment = new Appointment();
        appointment.setPatientId(patientId);
        appointment.setProfessionalId(request.getProfessionalId());
        appointment.setTimeSlotId(request.getTimeSlotId());
        appointment.setAppointmentTime(timeSlot.getStartTime());
        appointment.setStatus(AppointmentStatus.CONFIRMED);
        appointment.setReason(request.getReason());
        appointment.setCreatedAt(LocalDateTime.now());
        appointment.setUpdatedAt(LocalDateTime.now());
        
        return appointmentRepository.save(appointment);
    }
    
    public List<AppointmentResponse> getPatientAppointments(String patientId) {
        List<Appointment> appointments = appointmentRepository.findByPatientIdOrderByAppointmentTimeDesc(patientId);
        return appointments.stream()
            .map(this::mapToResponse)
            .collect(Collectors.toList());
    }
    
    public List<AppointmentResponse> getProfessionalAppointments(String professionalId) {
        List<Appointment> appointments = appointmentRepository.findByProfessionalIdOrderByAppointmentTimeDesc(professionalId);
        return appointments.stream()
            .map(this::mapToResponse)
            .collect(Collectors.toList());
    }
    
    @Transactional
    public Appointment updateAppointment(String patientId, String appointmentId, AppointmentRequest request) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
            .orElseThrow(() -> new NotFoundException("Rendez-vous non trouvé"));
        
        if (!appointment.getPatientId().equals(patientId)) {
            throw new BadRequestException("Vous ne pouvez modifier que vos propres rendez-vous");
        }
        
        // Libérer l'ancien créneau
        TimeSlot oldSlot = timeSlotRepository.findById(appointment.getTimeSlotId())
            .orElse(null);
        if (oldSlot != null) {
            oldSlot.setAvailable(true);
            timeSlotRepository.save(oldSlot);
        }
        
        // Réserver le nouveau créneau
        TimeSlot newSlot = timeSlotRepository.findById(request.getTimeSlotId())
            .orElseThrow(() -> new NotFoundException("Créneau non trouvé"));
        
        if (!newSlot.isAvailable()) {
            throw new BadRequestException("Ce créneau n'est plus disponible");
        }
        
        newSlot.setAvailable(false);
        timeSlotRepository.save(newSlot);
        
        appointment.setProfessionalId(request.getProfessionalId());
        appointment.setTimeSlotId(request.getTimeSlotId());
        appointment.setAppointmentTime(newSlot.getStartTime());
        appointment.setReason(request.getReason());
        appointment.setUpdatedAt(LocalDateTime.now());
        
        return appointmentRepository.save(appointment);
    }
    
    @Transactional
    public void cancelAppointment(String patientId, String appointmentId) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
            .orElseThrow(() -> new NotFoundException("Rendez-vous non trouvé"));
        
        if (!appointment.getPatientId().equals(patientId)) {
            throw new BadRequestException("Vous ne pouvez annuler que vos propres rendez-vous");
        }
        
        // Libérer le créneau
        TimeSlot timeSlot = timeSlotRepository.findById(appointment.getTimeSlotId())
            .orElse(null);
        if (timeSlot != null) {
            timeSlot.setAvailable(true);
            timeSlotRepository.save(timeSlot);
        }
        
        appointment.setStatus(AppointmentStatus.CANCELLED);
        appointment.setUpdatedAt(LocalDateTime.now());
        appointmentRepository.save(appointment);
    }
    
    private AppointmentResponse mapToResponse(Appointment appointment) {
        AppointmentResponse response = new AppointmentResponse();
        response.setId(appointment.getId());
        response.setPatientId(appointment.getPatientId());
        response.setProfessionalId(appointment.getProfessionalId());
        response.setAppointmentTime(appointment.getAppointmentTime());
        response.setStatus(appointment.getStatus());
        response.setReason(appointment.getReason());
        response.setNotes(appointment.getNotes());
        response.setHasReview(appointment.isHasReview());
        
        // Charger les informations du patient
        userRepository.findById(appointment.getPatientId()).ifPresent(patient -> {
            response.setPatientName(patient.getFirstName() + " " + patient.getLastName());
        });
        
        // Charger les informations du professionnel
        userRepository.findById(appointment.getProfessionalId()).ifPresent(professional -> {
            response.setProfessionalName(professional.getFirstName() + " " + professional.getLastName());
            response.setProfessionalSpeciality(professional.getSpeciality());
        });
        
        return response;
    }
}
