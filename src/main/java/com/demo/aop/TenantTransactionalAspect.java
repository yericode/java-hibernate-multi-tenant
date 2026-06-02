package com.demo.aop;

import com.demo.annotation.TenantTransactional;
import com.demo.context.TenantContext;
import jakarta.persistence.EntityManager;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Aspect
@Component
@Order(Ordered.LOWEST_PRECEDENCE)
public class TenantTransactionalAspect {

    @Autowired
    private EntityManager entityManager;

    @Around("@annotation(tenantTransactional)")
    public Object around(ProceedingJoinPoint joinPoint, TenantTransactional tenantTransactional) throws Throwable {
        String tenantId = TenantContext.getCurrentTenant();
        if (tenantId == null) {
            throw new IllegalStateException("No tenant found in TenantContext");
        }
        entityManager.createNativeQuery("SET LOCAL app.tenant_id = :tenantId")
                .setParameter("tenantId", "'" + tenantId + "'")
                .executeUpdate();
        return joinPoint.proceed();
    }
}
