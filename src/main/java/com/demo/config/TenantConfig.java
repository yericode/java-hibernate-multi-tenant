package com.demo.config;

import com.demo.context.TenantContext;
import org.hibernate.context.spi.CurrentTenantIdentifierResolver;
import org.hibernate.engine.jdbc.connections.spi.MultiTenantConnectionProvider;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.sql.Connection;
import java.sql.SQLException;

@Configuration
public class TenantConfig {

    @Bean
    public CurrentTenantIdentifierResolver<String> resolver() {
        return new CurrentTenantIdentifierResolver<>() {
            @Override
            public String resolveCurrentTenantIdentifier() {
                String tenantId = TenantContext.getCurrentTenant();
                return tenantId != null ? tenantId : "";
            }

            @Override
            public boolean validateExistingCurrentSessions() {
                return true;
            }
        };
    }

    @Bean
    public MultiTenantConnectionProvider<String> provider() {
      return new MultiTenantConnectionProvider<>() {
          @Override
          public Connection getAnyConnection() throws SQLException {
              return null;
          }

          @Override
          public void releaseAnyConnection(Connection connection) throws SQLException {

          }

          @Override
          public Connection getConnection(String s) throws SQLException {
              return null;
          }

          @Override
          public void releaseConnection(String s, Connection connection) throws SQLException {

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
      };
    };
}
