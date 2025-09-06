package com.example.mini_ecommerce.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.mini_ecommerce.Exceptions.NotFoundException;
import com.example.mini_ecommerce.entity.Product;
import com.example.mini_ecommerce.repository.ProductRepository;

@Service
public class ProductService {
    
    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public Product createProduct(Product product) {
        return productRepository.save(product);
    }

    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    public Product getProductById(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Product not found"));
    }

    public List<Product> getLowStock() {
        return productRepository.findByStockLessThan(5);
    }
}
