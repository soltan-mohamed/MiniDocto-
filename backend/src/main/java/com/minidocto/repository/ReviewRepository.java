package com.minidocto.repository;

import com.minidocto.model.Review;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ReviewRepository extends MongoRepository<Review, String> {
    List<Review> findByProfessionalId(String professionalId);
    List<Review> findByPatientId(String patientId);
    boolean existsByAppointmentId(String appointmentId);
}
