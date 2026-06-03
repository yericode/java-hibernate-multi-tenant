package com.demo.config;

import com.demo.context.TenantContext;
import org.hibernate.cfg.AvailableSettings;
import org.hibernate.dialect.Dialect;
import org.hibernate.engine.jdbc.connections.spi.DatabaseConnectionInfo;
import org.hibernate.engine.jdbc.connections.spi.MultiTenantConnectionProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.hibernate.autoconfigure.HibernatePropertiesCustomizer;
import org.springframework.stereotype.Component;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Map;

@Component
public class TenantConnectionProvider implements MultiTenantConnectionProvider<String>, HibernatePropertiesCustomizer {
    @Autowired
    private DataSource dataSource;

    @Override
    public Connection getAnyConnection() throws SQLException {
        return dataSource.getConnection();
    }

    @Override
    public void releaseAnyConnection(Connection connection) throws SQLException {
        connection.close();
    }

    @Override
    public Connection getConnection(String s) throws SQLException {
        String tenantId = TenantContext.getCurrentTenant();
        if (tenantId == null) {
            throw new IllegalStateException("No tenant in context");
        }
        System.out.println("getConnection!");
        Connection conn = dataSource.getConnection();
        try (Statement stmt = conn.createStatement()) {
            stmt.execute(String.format(" SET app.tenant_id = '%s'; ", tenantId));
        }
        return conn;
    }

    @Override
    public void releaseConnection(String s, Connection connection) throws SQLException {
        System.out.println("releaseConnection!");
        try (Statement stmt = connection.createStatement()) {
            stmt.execute(" RESET app.tenant_id; ");
        }
        connection.close();
    }

    @Override
    public void customize(Map<String, Object> hibernateProperties) {
        hibernateProperties.put(AvailableSettings.MULTI_TENANT_CONNECTION_PROVIDER, this);
    }

    @Override
    public Connection getReadOnlyConnection(String tenantIdentifier) throws SQLException {
        return MultiTenantConnectionProvider.super.getReadOnlyConnection(tenantIdentifier);
    }

    @Override
    public void releaseReadOnlyConnection(String tenantIdentifier, Connection connection) throws SQLException {
        MultiTenantConnectionProvider.super.releaseReadOnlyConnection(tenantIdentifier, connection);
    }

    @Override
    public boolean handlesConnectionSchema() {
        return MultiTenantConnectionProvider.super.handlesConnectionSchema();
    }

    @Override
    public boolean handlesConnectionReadOnly() {
        return MultiTenantConnectionProvider.super.handlesConnectionReadOnly();
    }

    @Override
    public DatabaseConnectionInfo getDatabaseConnectionInfo(Dialect dialect) {
        return MultiTenantConnectionProvider.super.getDatabaseConnectionInfo(dialect);
    }

    @Override
    public boolean supportsAggressiveRelease() {
        return false;
    }

    @Override
    public boolean isUnwrappableAs(Class<?> aClass) {
        return false;
    }

    @Override
    public <T> T unwrap(Class<T> aClass) {
        return null;
    }
}
