package com.demo.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class Tenants {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private String tenantId;

    private String tenantName;

    public String getTenantId() {
        return tenantId;
    }

    public void setTenantId(String tenantId) {
        this.tenantId = tenantId;
    }

    public String getTenantName() {
        return tenantName;
    }

    public void setTenantName(String tenantName) {
        this.tenantName = tenantName;
    }

    @Override
    public String toString() {
        return "Tenants [tenantId=" + tenantId + ", tenantName=" + tenantName + "]";
    }
}
