package com.example.mini_ecommerce.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.mini_ecommerce.service.AuthenticationResponseDTO;
import com.example.mini_ecommerce.service.IUserService;
import com.example.mini_ecommerce.service.UserLoginDTO;
import com.example.mini_ecommerce.service.UserRegisterDTO;

@RestController
@RequestMapping("/auth")
public class AuthenticationController {
    private final IUserService userService;

    public AuthenticationController(IUserService userService) {
        this.userService = userService;
    }

    @PostMapping("/register")
    public ResponseEntity<AuthenticationResponseDTO> register(@RequestBody UserRegisterDTO dto) {
        AuthenticationResponseDTO response = userService.register(dto);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @PostMapping("/login")
    public ResponseEntity<AuthenticationResponseDTO> login(@RequestBody UserLoginDTO dto) {
        AuthenticationResponseDTO response = userService.login(dto);
        return ResponseEntity.ok(response);
    }
}
