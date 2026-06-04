package com.demo.entity;

import jakarta.persistence.*;
import org.hibernate.annotations.TenantId;

@Entity
//public class Users extends BaseTenantEntity {
public class Users {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;

//    @TenantId
//    @Column(name = "tenant_id", nullable = false, updatable = false)
//    private String tenantId;

    private String userName;

    private String email;

    private String phone;

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
}
