package com.minidocto.controller;

import com.minidocto.dto.AuthResponse;
import com.minidocto.dto.LoginRequest;
import com.minidocto.dto.RegisterRequest;
import com.minidocto.model.User;
import com.minidocto.repository.UserRepository;
import com.minidocto.security.JwtTokenProvider;
import com.minidocto.service.AuthService;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    
    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);
    
    @Autowired
    private AuthService authService;
    
    @Autowired
    private JwtTokenProvider jwtTokenProvider;
    
    @Autowired
    private UserRepository userRepository;
    
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest request) {
        try {
            logger.info("Registration request received for email: {}", request.getEmail());
            AuthResponse response = authService.register(request);
            logger.info("Registration successful for email: {}", request.getEmail());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            logger.error("Error during registration: ", e);
            throw e;
        }
    }
    
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest request) {
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/me")
    public ResponseEntity<AuthResponse> getCurrentUser(@RequestHeader("Authorization") String token) {
        String jwt = token.replace("Bearer ", "");
        String userId = jwtTokenProvider.getUserIdFromToken(jwt);
        
        User user = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("Utilisateur non trouvé"));
        
        AuthResponse response = new AuthResponse(
            jwt,
            user.getId(),
            user.getEmail(),
            user.getFirstName(),
            user.getLastName(),
            user.getRole(),
            user.getSpeciality(),
            user.getScore()
        );
        
        return ResponseEntity.ok(response);
    }
}
