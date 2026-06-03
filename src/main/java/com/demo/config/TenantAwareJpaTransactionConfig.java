package com.demo.config;

import com.demo.context.TenantContext;
import jakarta.persistence.EntityManagerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.jdbc.datasource.DataSourceUtils;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

//@Configuration
//@EnableTransactionManagement
public class TenantAwareJpaTransactionConfig {
    @Bean
    public PlatformTransactionManager transactionManager(EntityManagerFactory emf, DataSource dataSource) {
        return new TenantJpaTransactionManager(emf, dataSource);
    }

    static class TenantJpaTransactionManager extends JpaTransactionManager {
        private final DataSource dataSource;

        public TenantJpaTransactionManager(EntityManagerFactory emf, DataSource dataSource) {
            super(emf);
            this.dataSource = dataSource;
        }

        @Override
        protected void doBegin(Object transaction, TransactionDefinition definition) {
            // 1. 先讓 Spring 正常開 Transaction
            super.doBegin(transaction, definition);
            // 2. 取得 tenant
            String tenantId = TenantContext.getCurrentTenant();
            if (tenantId == null) {
                throw new IllegalStateException("No tenant in context");
            }
            // 3. 拿到同一個 transaction-bound connection
            Connection con = DataSourceUtils.getConnection(dataSource);
            try (Statement stmt = con.createStatement()) {
                stmt.execute(String.format("SET LOCAL app.tenant_id = '%s'; ", tenantId));
            } catch (SQLException e) {
                throw new DataAccessResourceFailureException(e.getMessage(), e);
            }
        }
    }
}
