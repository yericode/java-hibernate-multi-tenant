package com.demo.entity;

import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;
import org.hibernate.annotations.Filter;
import org.hibernate.annotations.FilterDef;
import org.hibernate.annotations.ParamDef;

// 1. 定義過濾器的名稱與參數類型（此註解可放在任何實體或 package-info 上）
@FilterDef(name = "tenantFilter", parameters = @ParamDef(name = "tenantId", type = String.class))
// 2. 綁定過濾器到實體上，並設定 SQL 的 WHERE 條件
@Filter(name = "tenantFilter", condition = "tenant_id = :tenantId")
@MappedSuperclass
public abstract class BaseTenantEntity {
    @Column(name = "tenant_id", nullable = false, updatable = false)
    private String tenantId;

    public String getTenantId() {
        return tenantId;
    }

    public void setTenantId(String tenantId) {
        this.tenantId = tenantId;
    }
}
