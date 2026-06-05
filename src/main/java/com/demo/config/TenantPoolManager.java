package com.demo.config;

import com.demo.entity.TenantRegistry;
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class TenantPoolManager {
    @Autowired
    private JdbcClient jdbcClient;

    // 快取租戶的資料，避免每次租戶請求都透過 JDBC TCP 連線查詢
    private final ConcurrentHashMap<String, HikariDataSource> pools = new ConcurrentHashMap<>();

    public DataSource getDataSource(String tenantId) {
        return pools.computeIfAbsent(tenantId, this::createPool);
    }

    private HikariDataSource createPool(String tenantId) {
        // 這裡不能用 JPArepository，會有 entityManager 循環依賴問題
        TenantRegistry tenant = jdbcClient.sql("SELECT * FROM tenant_registry WHERE tenant_id = :tenantId")
                .param("tenantId", tenantId)
                .query(TenantRegistry.class)
                .single();
        if (tenant == null) {
            throw new IllegalArgumentException("Unknown tenant: " + tenantId);
        }
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(tenant.getJdbcUrl());
        config.setUsername("root");
        config.setPassword("password");
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(1);
        config.setPoolName("tenant-" + tenantId);
        return new HikariDataSource(config);
    }
}
