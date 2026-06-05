package com.demo.config;

import org.hibernate.cfg.AvailableSettings;
import org.hibernate.dialect.Dialect;
import org.hibernate.engine.jdbc.connections.spi.DatabaseConnectionInfo;
import org.hibernate.engine.jdbc.connections.spi.MultiTenantConnectionProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.hibernate.autoconfigure.HibernatePropertiesCustomizer;
import org.springframework.stereotype.Component;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;

@Component
public class DatabasePerTenantProvider implements MultiTenantConnectionProvider<String>, HibernatePropertiesCustomizer {
    @Autowired
    private TenantPoolManager tenantPoolManager ;

    @Override
    public Connection getAnyConnection() throws SQLException {
        throw new UnsupportedOperationException();
    }

    @Override
    public void releaseAnyConnection(Connection connection) throws SQLException {
        connection.close();
    }

    @Override
    public Connection getConnection(String tenantIdentifier) throws SQLException {
        System.out.println("getConnection!");
        return tenantPoolManager.getDataSource(tenantIdentifier).getConnection();
    }

    @Override
    public void releaseConnection(String s, Connection connection) throws SQLException {
        System.out.println("releaseConnection!");
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
