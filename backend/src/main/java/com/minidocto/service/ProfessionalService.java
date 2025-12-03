package com.minidocto.service;

import com.minidocto.dto.ProfessionalResponse;
import com.minidocto.model.User;
import com.minidocto.model.UserRole;
import com.minidocto.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ProfessionalService {
    
    @Autowired
    private UserRepository userRepository;
    
    public List<ProfessionalResponse> getAllProfessionals() {

        List<User> professionals = userRepository.findByRoleAndActiveOrderByScoreDesc(
            UserRole.PROFESSIONAL, true
        );
        
        return professionals.stream()
            .map(this::mapToResponse)
            .collect(Collectors.toList());
    }
    
    private ProfessionalResponse mapToResponse(User user) {
        ProfessionalResponse response = new ProfessionalResponse();
        response.setId(user.getId());
        response.setFirstName(user.getFirstName());
        response.setLastName(user.getLastName());
        response.setEmail(user.getEmail());
        response.setPhone(user.getPhone());
        response.setSpeciality(user.getSpeciality());
        response.setDescription(user.getDescription());
        response.setScore(user.getScore());
        response.setAddress(user.getAddress());
        return response;
    }
}
