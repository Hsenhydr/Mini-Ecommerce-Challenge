package com.example.mini_ecommerce.service;

import java.security.Key;
import java.util.Date;

import org.springframework.stereotype.Service;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;

import com.example.mini_ecommerce.Exceptions.BadRequestException;
import com.example.mini_ecommerce.entity.User;

@Service
public class TokenService implements ITokenService {
    private static final String SECRET_KEY = "KKzSFcSg5yf9pberlcKg6mvDUfHyYi+WnkMr2kGRUtGK8IDc5VA6Samh2rhVjEWn";

    // string to key
    public Key getSigningKey() {
        try {
            byte[] keyBytes = Decoders.BASE64.decode(SECRET_KEY);
            return Keys.hmacShaKeyFor(keyBytes);
        } catch (Exception e) {
            throw new BadRequestException("Failed to get signing key: " + e.getMessage());
        }
    }

    @Override
    public String generateToken(User user) {
        if (user == null) {
            throw new BadRequestException("User is null");
        }
        if (user.getEmail() == null) {
            throw new BadRequestException("Email is null");
        }
        if (user.getRole() == null) {
            throw new BadRequestException("Role is null");
        }

        try {
            return Jwts.builder()
                    .setSubject(user.getEmail()) // so we can get email from getSubject
                    .claim("role", user.getRole())
                    .setIssuedAt(new Date())
                    .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 3))
                    .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                    .compact();
        } catch (Exception e) {
            throw new BadRequestException("Failed to generate token: " + e.getMessage());
        }
    }

    @Override
    public boolean validateToken(String token) {
        if (token == null || token.trim().isEmpty()) {
            return false;
        }

        try {
            Jwts.parserBuilder()
                    .setSigningKey(getSigningKey())
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public String extractUserEmail(String token) {
        if (token == null || token.trim().isEmpty()) {
            throw new BadRequestException("Toke is null/empty");
        }
        try {
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(getSigningKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();

            String email = claims.getSubject();
            
            if (email == null || email.trim().isEmpty()) {
                throw new BadRequestException("email is null/empty");
            }
            return email;
        } catch (Exception e) {
            throw new BadRequestException("Failed to extract user email from token: " + e.getMessage());
        }
    }

    @Override
    public String extractUserRole(String token) {
        if (token == null || token.trim().isEmpty()) {
            throw new BadRequestException("Token is null/empty");
        }

        try {
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(getSigningKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();

            String role = claims.get("role", String.class);
            if (role == null || role.trim().isEmpty()) {
                throw new BadRequestException("Role is null/empty");
            }
            return role;
        } catch (Exception e) {
            throw new BadRequestException("Failed to extract user role from token: " + e.getMessage());
        }
    }

}