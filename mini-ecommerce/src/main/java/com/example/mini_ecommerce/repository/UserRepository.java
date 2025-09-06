package com.example.mini_ecommerce.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.mini_ecommerce.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    // just this to authenticate (login/reg)
    Optional<User> findByEmail(String email);
}
