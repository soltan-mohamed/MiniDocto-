package com.minidocto.controller;

import com.minidocto.dto.ProfessionalResponse;
import com.minidocto.service.ProfessionalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/professionals")
public class ProfessionalController {
    
    @Autowired
    private ProfessionalService professionalService;
    
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
}
