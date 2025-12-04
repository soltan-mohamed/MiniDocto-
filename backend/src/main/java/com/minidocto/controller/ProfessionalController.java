package com.minidocto.controller;

import com.minidocto.dto.ProfessionalResponse;
import com.minidocto.service.ProfessionalService;
import com.minidocto.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/professionals")
public class ProfessionalController {
    
    @Autowired
    private ProfessionalService professionalService;
    
    @Autowired
    private ReviewService reviewService;
    
    @GetMapping
    public ResponseEntity<List<ProfessionalResponse>> getAllProfessionals() {
        List<ProfessionalResponse> professionals = professionalService.getAllProfessionals();
        return ResponseEntity.ok(professionals);
    }
    
    @GetMapping("/list")
    public ResponseEntity<List<ProfessionalResponse>> getProfessionalsList() {
        List<ProfessionalResponse> professionals = professionalService.getAllProfessionals();
        return ResponseEntity.ok(professionals);
    }
    
    @PostMapping("/{professionalId}/recalculate-score")
    public ResponseEntity<String> recalculateScore(@PathVariable String professionalId) {
        reviewService.updateProfessionalScore(professionalId);
        return ResponseEntity.ok("Score recalculé avec succès");
    }
}
