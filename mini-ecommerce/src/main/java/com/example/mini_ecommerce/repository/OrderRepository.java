package com.example.mini_ecommerce.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.mini_ecommerce.entity.Order;
import com.example.mini_ecommerce.entity.User;

public interface OrderRepository extends JpaRepository<Order, String> {
    // for past orders
    List<Order> findByUser(User user);
}
