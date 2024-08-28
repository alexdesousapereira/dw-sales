-- Cria o schema vendas
CREATE SCHEMA IF NOT EXISTS vendas;
-- Concede todos os privilégios no schema vendas ao usuário postgres
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA vendas TO postgres;
