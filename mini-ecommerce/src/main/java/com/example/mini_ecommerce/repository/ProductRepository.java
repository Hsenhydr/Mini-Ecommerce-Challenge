package com.example.mini_ecommerce.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.mini_ecommerce.entity.Product;

public interface ProductRepository extends JpaRepository<Product, String> {
    // list of products ll admin(mafroud <5)
    List<Product> findByStockLessThan(int stock);
}
