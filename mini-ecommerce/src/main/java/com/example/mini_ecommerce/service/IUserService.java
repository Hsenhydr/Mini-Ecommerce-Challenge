package com.example.mini_ecommerce.service;

public interface IUserService {
    // bye5od dto and authenticate email and return id, email and token
    AuthenticationResponseDTO register(UserRegisterDTO dto);
    AuthenticationResponseDTO login(UserLoginDTO dto);
}
