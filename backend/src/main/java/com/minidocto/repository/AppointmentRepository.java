package com.minidocto.repository;

import com.minidocto.model.Appointment;
import com.minidocto.model.AppointmentStatus;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AppointmentRepository extends MongoRepository<Appointment, String> {
    List<Appointment> findByPatientIdOrderByAppointmentTimeDesc(String patientId);
    
    List<Appointment> findByProfessionalIdOrderByAppointmentTimeDesc(String professionalId);
    
    List<Appointment> findByPatientIdAndStatus(String patientId, AppointmentStatus status);
    
    List<Appointment> findByProfessionalIdAndStatus(String professionalId, AppointmentStatus status);
}
