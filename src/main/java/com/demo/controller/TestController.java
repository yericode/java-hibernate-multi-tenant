package com.demo.controller;

import com.demo.annotation.TenantTransactional;
import com.demo.entity.Orders;
import com.demo.entity.Users;
import com.demo.repository.OrderRepository;
import com.demo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class TestController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private OrderRepository orderRepository;

    @GetMapping("/test")
    public String test() {
        return "this is a test";
    }

    @GetMapping("/users")
    public List<Users> getAllUsers() {
        return userRepository.findAll();
    }

    @GetMapping("/orders")
    public List<Orders> getAllOrders() {
        return orderRepository.findAll();
    }

}
