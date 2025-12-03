package com.minidocto.controller;

import com.minidocto.dto.AppointmentRequest;
import com.minidocto.dto.AppointmentResponse;
import com.minidocto.model.Appointment;
import com.minidocto.service.AppointmentService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/appointments")
public class AppointmentController {
    
    @Autowired
    private AppointmentService appointmentService;
    
    @PostMapping
    public ResponseEntity<Appointment> createAppointment(
            Authentication authentication,
            @Valid @RequestBody AppointmentRequest request) {
        String patientId = authentication.getName();
        Appointment appointment = appointmentService.createAppointment(patientId, request);
        return ResponseEntity.ok(appointment);
    }
    
    @GetMapping("/patient")
    public ResponseEntity<List<AppointmentResponse>> getPatientAppointments(Authentication authentication) {
        String patientId = authentication.getName();
        List<AppointmentResponse> appointments = appointmentService.getPatientAppointments(patientId);
        return ResponseEntity.ok(appointments);
    }
    
    @GetMapping("/professional")
    public ResponseEntity<List<AppointmentResponse>> getProfessionalAppointments(Authentication authentication) {
        String professionalId = authentication.getName();
        List<AppointmentResponse> appointments = appointmentService.getProfessionalAppointments(professionalId);
        return ResponseEntity.ok(appointments);
    }
    
    @PutMapping("/{appointmentId}")
    public ResponseEntity<Appointment> updateAppointment(
            Authentication authentication,
            @PathVariable String appointmentId,
            @Valid @RequestBody AppointmentRequest request) {
        String patientId = authentication.getName();
        Appointment appointment = appointmentService.updateAppointment(patientId, appointmentId, request);
        return ResponseEntity.ok(appointment);
    }
    
    @DeleteMapping("/{appointmentId}")
    public ResponseEntity<Void> cancelAppointment(
            Authentication authentication,
            @PathVariable String appointmentId) {
        String patientId = authentication.getName();
        appointmentService.cancelAppointment(patientId, appointmentId);
        return ResponseEntity.ok().build();
    }
}
