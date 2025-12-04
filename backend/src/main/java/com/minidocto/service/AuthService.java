package com.minidocto.service;

import com.minidocto.dto.AuthResponse;
import com.minidocto.dto.LoginRequest;
import com.minidocto.dto.RegisterRequest;
import com.minidocto.exception.BadRequestException;
import com.minidocto.model.User;
import com.minidocto.model.UserRole;
import com.minidocto.repository.UserRepository;
import com.minidocto.security.JwtTokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class AuthService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private JwtTokenProvider tokenProvider;
    
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new BadRequestException("Cet email est déjà utilisé");
        }
        
        User user = new User();
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setFirstName(request.getFirstName());
        user.setLastName(request.getLastName());
        user.setPhone(request.getPhone());
        user.setRole(request.getRole());
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        
        if (request.getRole() == UserRole.PROFESSIONAL) {
            user.setSpeciality(request.getSpeciality());
            user.setDescription(request.getDescription());
            user.setAddress(request.getAddress());
            user.setScore(20);
        }
        
        user = userRepository.save(user);
        
        String token = tokenProvider.generateToken(user.getId(), user.getEmail());
        
        return new AuthResponse(
            token,
            user.getId(),
            user.getEmail(),
            user.getFirstName(),
            user.getLastName(),
            user.getRole(),
            user.getSpeciality()
        );
    }
    
    public AuthResponse login(LoginRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
            .orElseThrow(() -> new BadRequestException("Email ou mot de passe incorrect"));
        
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new BadRequestException("Email ou mot de passe incorrect");
        }
        
        if (!user.isActive()) {
            throw new BadRequestException("Ce compte est désactivé");
        }
        
        String token = tokenProvider.generateToken(user.getId(), user.getEmail());
        
        return new AuthResponse(
            token,
            user.getId(),
            user.getEmail(),
            user.getFirstName(),
            user.getLastName(),
            user.getRole(),
            user.getSpeciality()
        );
    }
}
