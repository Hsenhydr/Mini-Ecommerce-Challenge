package com.example.mini_ecommerce.service;

import com.example.mini_ecommerce.entity.User;

// used the help of ai 
public interface ITokenService {
    String generateToken(User user);

    boolean validateToken(String token);

    String extractUserEmail(String token);

    String extractUserRole(String token);
}
