package com.demo.aop;

import com.demo.context.TenantContext;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.hibernate.Session;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class TenantFilterAspect {
    @PersistenceContext
    private EntityManager entityManager;

    @Before("execution(* com.demo.repository..*.*(..))")
    public void enableTenantFilter() {
        // 從當前 ThreadLocal 中取出租戶 ID
        String currentTenantId = TenantContext.getCurrentTenant();

        if (currentTenantId != null && !currentTenantId.isBlank()) {
            // 將 EntityManager 轉換為 Hibernate 的 Session 物件
            Session session = entityManager.unwrap(Session.class);
            // 啟用 Filter 並綁定當前執行緒的租戶 ID
            session.enableFilter("tenantFilter").setParameter("tenantId", currentTenantId);
        } else {
            throw new IllegalArgumentException("Empty currentTenantId!");
        }
    }
}
