package com.example.mini_ecommerce.service;

import java.util.Optional;
import org.springframework.stereotype.Service;

import com.example.mini_ecommerce.Exceptions.BadRequestException;
import com.example.mini_ecommerce.entity.User;
import com.example.mini_ecommerce.repository.UserRepository;

@Service
public class UserService implements IUserService {
    private final UserRepository userRepository;
    private final TokenService tokenService;

    public UserService(UserRepository userRepository, TokenService tokenService) {
        this.userRepository = userRepository;
        this.tokenService = tokenService;
    }

    @Override
    public AuthenticationResponseDTO register(UserRegisterDTO dto) {
        Optional<User> email = userRepository.findByEmail(dto.getEmail());
        if (email.isPresent()) {
            throw new BadRequestException("User already exists: " + dto.getEmail());
        }

        User user = User.builder()
                .email(dto.getEmail())
                .password(dto.getPassword())
                .role("USER")
                .build();

        userRepository.save(user);

        String token = tokenService.generateToken(user);

        return AuthenticationResponseDTO.builder()
                .id(user.getId())
                .email(user.getEmail())
                .token(token)
                .build();
    }

    @Override
    public AuthenticationResponseDTO login(UserLoginDTO dto) {
        User user = userRepository.findByEmail(dto.getEmail())
                .orElseThrow(() -> new BadRequestException("Invalid info"));

        if (!dto.getPassword().equals(user.getPassword())) {
            throw new BadRequestException("Invalid password");
        }

        String token = tokenService.generateToken(user);

        return AuthenticationResponseDTO.builder()
                .id(user.getId())
                .email(user.getEmail())
                .token(token)
                .build();
    }

}
