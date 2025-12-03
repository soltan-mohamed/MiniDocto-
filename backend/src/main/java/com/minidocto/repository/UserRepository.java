package com.minidocto.repository;

import com.minidocto.model.User;
import com.minidocto.model.UserRole;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends MongoRepository<User, String> {
    Optional<User> findByEmail(String email);
    
    List<User> findByRoleAndActiveOrderByScoreDesc(UserRole role, boolean active);
    
    boolean existsByEmail(String email);
}
