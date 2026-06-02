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
import org.springframework.transaction.support.TransactionSynchronizationManager;

@Aspect
@Component
@Order(Ordered.LOWEST_PRECEDENCE)
public class TenantTransactionalAspect {

    @Autowired
    private EntityManager entityManager;

    @Around("@annotation(tenantTransactional)")
    public Object around(ProceedingJoinPoint joinPoint, TenantTransactional tenantTransactional) throws Throwable {
        String tenantId = TenantContext.getCurrentTenant();
        // 避免交易還沒開始
        if (!TransactionSynchronizationManager.isActualTransactionActive()) {
            throw new IllegalStateException("@TenantTransactional must run inside transaction");
        }
        if (tenantId == null) {
            throw new IllegalStateException("No tenant found in TenantContext");
        }
        entityManager.createNativeQuery(String.format("SET LOCAL app.tenant_id = '%s'", tenantId)).executeUpdate();
        return joinPoint.proceed();
    }
}
