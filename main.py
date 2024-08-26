import pandas as pd
import psycopg2
from psycopg2 import sql
import logging
import os
import tempfile


# Configurações de conexão com o banco de dados
DB_CONFIG = {
    'host': 'localhost',
    'port': '5432',
    'user': 'postgres',
    'password': 'postgres',
    'dbname': 'stage'
}

# Configuração de detalhamento de logs
DEBUG_MODE = True  # Altere para False para logs menos detalhados

# Determinar o diretório temporário para criar o arquivo de log
log_file_path = os.path.join(tempfile.gettempdir(), 'import_log.log')

# Configurações de log
try:
    logging.basicConfig(
        filename=log_file_path,
        level=logging.DEBUG if DEBUG_MODE else logging.INFO,  # Nível de log baseado no modo debug
        format='%(asctime)s - %(levelname)s - %(message)s'
    )
    print(f'Configuração de logging foi bem-sucedida. Logs salvos em: {log_file_path}')
except Exception as e:
    print(f'Erro durante a configuração de logging: {e}')
    exit(1)

def debug(message, level='INFO', conn=None):
    """Função para depuração que imprime e registra mensagens, e insere logs no banco de dados."""
    if level == 'DEBUG' and not DEBUG_MODE:
        return  # Não logar mensagens de debug se o modo debug estiver desativado
    
    # Log para o arquivo e console
    if level == 'DEBUG':
        logging.debug(message)
    elif level == 'INFO':
        logging.info(message)
    elif level == 'WARNING':
        logging.warning(message)
    elif level == 'ERROR':
        logging.error(message)
    
    print(message)
    
    # Inserir log no banco de dados, se a conexão for fornecida
    if conn:
        try:
            cur = conn.cursor()
            insert_log_query = sql.SQL("""
                INSERT INTO vendas.logs (
                    log_timestamp, log_level, message
                ) VALUES (CURRENT_TIMESTAMP, %s, %s)
            """)
            cur.execute(insert_log_query, (level, message))
            conn.commit()
            cur.close()
        except Exception as e:
            print(f'Erro ao registrar log no banco de dados: {e}')
            conn.rollback()

def connect_to_db():
    """Função para conectar ao banco de dados."""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        debug("Conexão com o banco de dados estabelecida com sucesso.", 'INFO')
        return conn
    except Exception as e:
        debug(f'Erro ao conectar ao banco de dados: {e}', 'ERROR')
        raise

def remove_spaces(value):
    """Remove espaços antes e depois dos valores em strings."""
    if isinstance(value, str):
        return value.strip()
    return value

def remove_duplicates(df):
    """Remove duplicatas do DataFrame e retorna o DataFrame limpo."""
    before_removal = len(df)
    df = df.drop_duplicates()
    after_removal = len(df)
    removed_duplicates = before_removal - after_removal
    debug(f"{removed_duplicates} linhas duplicadas foram removidas.", 'WARNING')
    return df

def format_dates(df, date_columns):
    """Formata as colunas de datas para o formato YYYY-MM-DD, mantendo o valor original destacado se a data for inválida."""
    for col in date_columns:
        before_formatting = df[col].notna().sum()
        
        def try_convert_date(value):
            try:
                return pd.to_datetime(value, format='%d/%m/%Y', errors='raise', dayfirst=True).strftime('%Y-%m-%d')
            except Exception:
                # Destacar o valor original como inválido
                highlighted_value = f'[INVALID DATE: {value}]'
                debug(f'Data inválida encontrada e destacada: {highlighted_value} na coluna {col}.', 'WARNING')
                return highlighted_value
        
        df[col] = df[col].apply(try_convert_date)
        after_formatting = df[col].notna().sum()
        ignored_dates = before_formatting - after_formatting
        
        if ignored_dates > 0:
            debug(f"{ignored_dates} registros tiveram datas ignoradas e mantidas como o valor original na coluna {col}.", 'WARNING')
    
    return df

def insert_data(row, conn):
    """Insere uma única linha de dados no banco de dados."""
    try:
        cur = conn.cursor()
        insert_query = sql.SQL("""
            INSERT INTO vendas.stage_sales_data (
                data_venda, numero_nota, codigo_produto, descricao_produto,
                codigo_cliente, descricao_cliente, valor_unitario_produto,
                quantidade_vendida_produto, valor_total, custo_da_venda,
                valor_tabela_de_preco_do_produto
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """)
        cur.execute(insert_query, (
            row['data_venda'], row['numero_nota'], row['codigo_produto'],
            row['descricao_produto'], row['codigo_cliente'], row['descricao_cliente'],
            row['valor_unitario_produto'], row['quantidade_vendida_produto'],
            row['valor_total'], row['custo_da_venda'], row['valor_tabela_de_preco_do_produto']
        ))
        conn.commit()
        cur.close()
    except Exception as e:
        conn.rollback()
        raise e

def process_data(df, conn):
    """Processa o DataFrame, inserindo linha por linha no banco de dados e lidando com erros."""
    error_rows = []
    
    for index, row in df.iterrows():
        try:
            insert_data(row, conn)
        except Exception as e:
            debug(f'Erro ao inserir linha {index}: {e}', 'ERROR')
            error_rows.append(row)
    
    return error_rows

def save_error_rows_to_csv(error_rows):
    """Salva as linhas com erro em um arquivo .csv na pasta linhas_erradas."""
    if not error_rows.empty:
        os.makedirs('linhas_erradas', exist_ok=True)
        error_file_path = os.path.join('linhas_erradas', 'erros.csv')
        error_rows.to_csv(error_file_path, index=False)
        debug(f'{len(error_rows)} linhas com erro foram salvas em {error_file_path}', 'WARNING')

def main():
    try:
        # Leitura dos dados do arquivo Excel
        df = pd.read_excel('sales_data_with_dates.xlsx')

        # Remoção de espaços em branco
        df = df.applymap(remove_spaces)
        debug("Espaços em branco removidos dos dados.", 'INFO')

        # Remoção de linhas duplicadas
        df = remove_duplicates(df)

        # Formatar colunas de data
        date_columns = ['data_venda']
        df = format_dates(df, date_columns)
        debug("Datas formatadas para o padrão YYYY-MM-DD, com datas inválidas ignoradas.", 'INFO')

        # Conectar ao banco de dados
        conn = connect_to_db()

        # Processar os dados, inserindo-os no banco de dados
        error_rows = process_data(df, conn)

        # Salvar as linhas com erros em um arquivo .csv
        error_rows_df = pd.DataFrame(error_rows)
        save_error_rows_to_csv(error_rows_df)

        # Fechar a conexão
        conn.close()
        debug('Script executado com sucesso.', 'INFO')

    except Exception as e:
        debug(f'Ocorreu um erro na execução do script: {e}', 'ERROR')

if __name__ == '__main__':
    main()
