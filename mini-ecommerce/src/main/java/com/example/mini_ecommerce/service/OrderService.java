package com.example.mini_ecommerce.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import com.example.mini_ecommerce.Exceptions.BadRequestException;
import com.example.mini_ecommerce.Exceptions.NotFoundException;
import com.example.mini_ecommerce.entity.Order;
import com.example.mini_ecommerce.entity.OrderItem;
import com.example.mini_ecommerce.entity.Product;
import com.example.mini_ecommerce.entity.User;
import com.example.mini_ecommerce.repository.OrderRepository;
import com.example.mini_ecommerce.repository.ProductRepository;
import com.example.mini_ecommerce.repository.UserRepository;

import jakarta.transaction.Transactional;

@Service
public class OrderService {
    private final OrderRepository orderRepository;
    private final ProductRepository productRepository;
    private final UserRepository userRepository;

    public OrderService(OrderRepository orderRepository,
            ProductRepository productRepository,
            UserRepository userRepository) {
        this.orderRepository = orderRepository;
        this.productRepository = productRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public Order addOrder(Long userId, List<OrderItem> items) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NotFoundException("User not found"));
    
        Order order = new Order();
        order.setUser(user);
        order.setCreatedAt(LocalDateTime.now());
    
        double totalAmount = 0;
        List<OrderItem> orderItems = new ArrayList<>();
    
        for (OrderItem item : items) {
            Product product = productRepository.findById(item.getProduct().getId())
                    .orElseThrow(() -> new NotFoundException("Product not found"));

            OrderItem orderItem = new OrderItem();
            orderItem.setProduct(product);
            orderItem.setQuantity(item.getQuantity());
    
            double price = product.getPrice();
            orderItem.setPrice(price);
    
            orderItem.setOrder(order);
    
            if (product.getStock() < item.getQuantity()) {
                throw new BadRequestException("Insufficient stock for product: " + product.getName());
            }
    
            product.setStock(product.getStock() - item.getQuantity());
            productRepository.save(product);
    
            totalAmount += price * item.getQuantity();
            orderItems.add(orderItem);
        }
    
        order.setItems(orderItems);
        order.setTotalAmount(totalAmount);
    
        return orderRepository.save(order);
    }
      
    public List<Order> getOrdersByUser(Long userId) {
        if (userId == null) {
            throw new NotFoundException("User ID cannot be null");
        }

        try {
            List<Order> orders = orderRepository.findByUserId(userId);
            return orders;
        } catch (Exception e) {
            throw new BadRequestException("Failed to get orders by user - " + e.getMessage());
        }
    }

    public List<Order> getAllOrders() {
        try {
            List<Order> orders = orderRepository.findAll();
            return orders;
        } catch (Exception e) {
            throw new BadRequestException("Failed to get all orders - " + e.getMessage());
        }
    }
}