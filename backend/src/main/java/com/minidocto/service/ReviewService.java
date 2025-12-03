package com.minidocto.service;

import com.minidocto.model.Appointment;
import com.minidocto.model.Review;
import com.minidocto.model.User;
import com.minidocto.repository.AppointmentRepository;
import com.minidocto.repository.ReviewRepository;
import com.minidocto.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ReviewService {
    
    @Autowired
    private ReviewRepository reviewRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private AppointmentRepository appointmentRepository;
    
    @Transactional
    public Review addReview(Review review) {
        if (reviewRepository.existsByAppointmentId(review.getAppointmentId())) {
            throw new RuntimeException("Un avis existe déjà pour ce rendez-vous");
        }
        Review savedReview = reviewRepository.save(review);
        Appointment appointment = appointmentRepository.findById(review.getAppointmentId())
            .orElseThrow(() -> new RuntimeException("Rendez-vous non trouvé"));
        appointment.setHasReview(true);
        appointmentRepository.save(appointment);
        updateProfessionalScore(review.getProfessionalId());
        return savedReview;
    }
    
    public List<Review> getProfessionalReviews(String professionalId) {
        return reviewRepository.findByProfessionalId(professionalId);
    }
    
    public void updateProfessionalScore(String professionalId) {
        List<Review> reviews = reviewRepository.findByProfessionalId(professionalId);
        
        if (reviews.isEmpty()) {
            return;
        }
        
        double averageRating = reviews.stream()
            .mapToInt(Review::getRating)
            .average()
            .orElse(0.0);
        
        int score = (int) Math.round(averageRating * 20);
        User professional = userRepository.findById(professionalId)
            .orElseThrow(() -> new RuntimeException("Professionnel non trouvé"));
        
        professional.setScore(score);
        userRepository.save(professional);
    }
}
