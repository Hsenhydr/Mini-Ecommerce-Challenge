package com.example.mini_ecommerce.service;

import java.security.Key;
import java.util.Date;

import org.springframework.stereotype.Service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;

import com.example.mini_ecommerce.entity.User;

// used the help of ai
@Service
public class TokenService implements ITokenService {
    private static final String SECRET_KEY = "KKzSFcSg5yf9pberlcKg6mvDUfHyYi+WnkMr2kGRUtGK8IDc5VA6Samh2rhVjEWn";

    // string to key
    private Key getSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(SECRET_KEY);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    @Override
    public String generateToken(User user) {
        return Jwts.builder()
                .setSubject(user.getEmail()) // l email in subject, so we can extract it later
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 3))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();

    }

    // check if token is valid and not expired
    @Override
    public boolean validateToken(String token) {
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

    // extract user email from token
    @Override
    public String extractUserEmail(String token) {
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
        return claims.getSubject();
    }
}
