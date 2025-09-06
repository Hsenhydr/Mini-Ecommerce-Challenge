package com.example.mini_ecommerce.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.mini_ecommerce.entity.Order;
import com.example.mini_ecommerce.entity.OrderItem;
import com.example.mini_ecommerce.entity.User;
import com.example.mini_ecommerce.service.OrderService;

@RestController
@RequestMapping("/orders")
public class OrderController {
    
    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @PostMapping
    @PreAuthorize("hasRole('USER')")
  public ResponseEntity<Order> addOrder(
        @AuthenticationPrincipal User user,
        @RequestBody List<OrderItem> items) {

    Long userId = user.getId();
    Order order = orderService.addOrder(userId, items);
    return ResponseEntity.status(201).body(order);
}

    @GetMapping("/me")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<List<Order>> getOrdersByUser(@AuthenticationPrincipal User user) {
        Long userId = user.getId();
        List<Order> orders = orderService.getOrdersByUser(userId);
        return ResponseEntity.ok(orders);
    }
    
    @GetMapping("/admin/orders")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<List<Order>> getAllOrders() {
        List<Order> orders = orderService.getAllOrders();
        return ResponseEntity.ok(orders);
    }
    
}