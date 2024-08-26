-- Cria o schema vendas
CREATE SCHEMA IF NOT EXISTS vendas;

-- Cria a tabela stage_sales_data no schema vendas
CREATE TABLE IF NOT EXISTS vendas.stage_sales_data (
    data_venda DATE,
    numero_nota INTEGER,
    codigo_produto VARCHAR(10),
    descricao_produto VARCHAR(100),
    codigo_cliente VARCHAR(10),
    descricao_cliente VARCHAR(100),
    valor_unitario_produto NUMERIC,
    quantidade_vendida_produto INTEGER,
    valor_total NUMERIC,
    custo_da_venda NUMERIC,
    valor_tabela_de_preco_do_produto NUMERIC
);

-- Cria a tabela monitoring_stage_data no schema vendas
CREATE TABLE IF NOT EXISTS vendas.monitoring_stage_data (
    id SERIAL PRIMARY KEY,
    arquivo_original_registros INTEGER,
    registros_apos_limpeza INTEGER,
    registros_ignorados INTEGER,
    data_processamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Cria a tabela logs no schema vendas
CREATE TABLE IF NOT EXISTS vendas.logs (
    id SERIAL PRIMARY KEY,
    log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    log_level VARCHAR(10),
    message TEXT
);

-- Concede todos os privilégios no schema vendas ao usuário postgres
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA vendas TO postgres;
