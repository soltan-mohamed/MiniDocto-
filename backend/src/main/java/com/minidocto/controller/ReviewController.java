package com.minidocto.controller;

import com.minidocto.dto.ReviewRequest;
import com.minidocto.model.Appointment;
import com.minidocto.model.Review;
import com.minidocto.repository.AppointmentRepository;
import com.minidocto.security.JwtTokenProvider;
import com.minidocto.service.ReviewService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reviews")
public class ReviewController {
    
    @Autowired
    private ReviewService reviewService;
    
    @Autowired
    private AppointmentRepository appointmentRepository;
    
    @Autowired
    private JwtTokenProvider jwtTokenProvider;
    
    @PostMapping
    public ResponseEntity<Review> addReview(
            @Valid @RequestBody ReviewRequest request,
            @RequestHeader("Authorization") String token) {
        
        String userId = jwtTokenProvider.getUserIdFromToken(token.substring(7));
        
        Appointment appointment = appointmentRepository.findById(request.getAppointmentId())
            .orElseThrow(() -> new RuntimeException("Rendez-vous non trouvé"));
        
        if (!appointment.getPatientId().equals(userId)) {
            throw new RuntimeException("Vous ne pouvez noter que vos propres rendez-vous");
        }
        
        Review review = new Review();
        review.setAppointmentId(request.getAppointmentId());
        review.setProfessionalId(appointment.getProfessionalId());
        review.setPatientId(userId);
        review.setRating(request.getRating());
        review.setComment(request.getComment());
        
        Review savedReview = reviewService.addReview(review);
        
        return ResponseEntity.ok(savedReview);
    }
    
    @GetMapping("/professional/{professionalId}")
    public ResponseEntity<List<Review>> getProfessionalReviews(@PathVariable String professionalId) {
        List<Review> reviews = reviewService.getProfessionalReviews(professionalId);
        return ResponseEntity.ok(reviews);
    }
}
