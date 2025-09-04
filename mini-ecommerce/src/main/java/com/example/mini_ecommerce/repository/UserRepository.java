package com.example.mini_ecommerce.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.mini_ecommerce.entity.User;

public interface UserRepository extends JpaRepository<User, String> {
    // just this to authenticate (login/reg)
    Optional<User> findByEmail(String email);
}
