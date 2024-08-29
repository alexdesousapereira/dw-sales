import os
import pandas as pd
import psycopg2
from psycopg2 import sql
import logging
import tempfile
from dotenv import load_dotenv
import requests
from mappers.mappers import MapperSalesData
from datetime import datetime

# Carregar variáveis do arquivo .env
load_dotenv()

# Configurações de conexão com o banco de dados a partir do .env
DB_CONFIG = {
    'host': os.getenv('DB_HOST'),
    'port': os.getenv('DB_PORT'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'dbname': os.getenv('DB_NAME')
}

# Configuração de detalhamento de logs
DEBUG_MODE = True  # Altere para False para logs menos detalhados

# Determinar o diretório temporário para criar o arquivo de log
log_file_path = os.path.join(tempfile.gettempdir(), 'import_log.log')

# Configurações de log
try:
    logging.basicConfig(
        filename=log_file_path,
        level=logging.DEBUG if DEBUG_MODE else logging.INFO,
        format='%(asctime)s - %(levelname)s - %(message)s'
    )
    print(f'Configuração de logging foi bem-sucedida. Logs salvos em: {log_file_path}')
except Exception as e:
    print(f'Erro durante a configuração de logging: {e}')
    exit(1)

def send_telegram_message(message):
    """Envia uma mensagem ao Telegram usando um bot."""
    try:
        token = os.getenv('TELEGRAM_BOT_TOKEN')
        chat_id = os.getenv('TELEGRAM_CHAT_ID')
        if not token or not chat_id:
            print("Token do bot do Telegram ou chat ID não configurado.")
            return

        url = f"https://api.telegram.org/bot{token}/sendMessage"
        payload = {
            'chat_id': chat_id,
            'text': message,
            'parse_mode': None  # Remova o 'Markdown' para evitar problemas de parsing
        }
        response = requests.post(url, data=payload)
        if response.status_code == 200:
            print("Mensagem enviada ao Telegram com sucesso.")
        else:
            print(f"Falha ao enviar mensagem ao Telegram. Status: {response.status_code}, Response: {response.text}")
    except Exception as e:
        print(f"Erro ao enviar mensagem ao Telegram: {e}")

def log_to_database(conn, level, message):
    """Insere informações de log na tabela vendas.logs no banco de dados."""
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
        print(f'Erro ao inserir log no banco de dados: {e}')
        conn.rollback()

def debug(message, level='INFO', conn=None):
    """Função para depuração que imprime e registra mensagens, e insere logs no banco de dados."""
    if level == 'DEBUG' and not DEBUG_MODE:
        return
    
    # Log para o arquivo e console
    getattr(logging, level.lower())(message)
    
    print(message)
    
    # Inserir log no banco de dados, se a conexão for fornecida e ainda estiver aberta
    if conn is not None and not conn.closed:
        try:
            log_to_database(conn, level, message)
        except Exception as e:
            print(f"Erro ao registrar log no banco de dados: {e}")
    elif conn is None:
        print("Aviso: Conexão não fornecida para registrar logs no banco de dados.")
    elif conn.closed:
        print("Aviso: Tentativa de log após a conexão ter sido fechada.")


def connect_to_db():
    """Função para conectar ao banco de dados."""
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        debug("Conexão com o banco de dados estabelecida com sucesso.", 'INFO', conn)
        return conn
    except Exception as e:
        debug(f'Erro ao conectar ao banco de dados: {e}', 'ERROR')
        raise


def truncate_table(conn):
    """Trunca a tabela antes de inserir novos dados."""
    try:
        cur = conn.cursor()
        cur.execute("TRUNCATE TABLE vendas.stage_sales_data")
        conn.commit()
        cur.close()
        debug("Tabela vendas.stage_sales_data truncada com sucesso.", 'INFO', conn)
    except Exception as e:
        debug(f'Erro ao truncar a tabela: {e}', 'ERROR', conn)
        conn.rollback()


def get_row_count(conn):
    """Retorna o número de linhas na tabela vendas.stage_sales_data."""
    try:
        cur = conn.cursor()
        cur.execute("SELECT COUNT(*) FROM vendas.stage_sales_data")
        row_count = cur.fetchone()[0]
        cur.close()
        return row_count
    except Exception as e:
        debug(f'Erro ao contar as linhas da tabela: {e}', 'ERROR', conn)
        conn.rollback()
        return 0


class DataFrameTransformer:
    def __init__(self, df):
        self.df = df
        self.mapper = MapperSalesData()


    def remove_unused_columns(self,conn, columns_to_keep=None):
        """
        Remove colunas que não são utilizadas, mantendo apenas as colunas especificadas.
        
        Args:
            columns_to_keep (list, optional): Lista de colunas a serem mantidas. 
                                              Se None, mantém apenas as colunas mapeadas em _MAPEAMENTO_TO_TABELA.
        """
        if columns_to_keep is None:
            columns_to_keep = list(self.mapper._MAPEAMENTO_TO_TABELA.values())

        columns_to_remove = [col for col in self.df.columns if col not in columns_to_keep]
        if columns_to_remove:
            self.df = self.df.drop(columns=columns_to_remove)
            debug(f"Colunas removidas: {columns_to_remove}.", 'WARNING,conn')
        else:
            debug("Nenhuma coluna não utilizada encontrada para remoção.", 'INFO',conn)

        return self.df
    
    def remove_blank_rows(self, conn):
        """Remove linhas que estão completamente em branco."""
        before_removal = len(self.df)
        self.df = self.df.dropna(how='all')
        after_removal = len(self.df)
        removed_rows = before_removal - after_removal
        debug(f"{removed_rows} linhas em branco foram removidas.", 'WARNING', conn)
        return self.df

    def remove_spaces(self, conn):
        """Remove espaços antes e depois dos valores em strings."""
        self.df = self.df.applymap(lambda x: x.strip() if isinstance(x, str) else x)
        debug("Espaços entre stings removidos.", 'WARNING', conn)
        return self.df
    
    def remove_duplicates(self, conn):
        """Remove duplicatas do DataFrame e retorna o DataFrame limpo."""
        before_removal = len(self.df)
        self.df = self.df.drop_duplicates()
        after_removal = len(self.df)
        removed_duplicates = before_removal - after_removal
        debug(f"{removed_duplicates} linhas duplicadas foram removidas.", 'WARNING', conn)
        return self.df

    def transform(self, conn):
        """Executa todas as transformações no DataFrame em sequência."""
        self.remove_unused_columns(conn)
        self.remove_spaces(conn)
        self.remove_blank_rows(conn)
        self.remove_duplicates(conn)
        return self.df

class DataFrameValidator:
    def __init__(self, df):
        self.df = df
        self.mapper = MapperSalesData()
        self.expected_columns = list(self.mapper._MAPEAMENTO_TO_TABELA.values())
    
    def valida_colunas(self,conn):
        """Verifica se o DataFrame tem o número esperado de colunas e se os nomes das colunas estão corretos."""
        actual_columns = self.df.columns.tolist()
        actual_column_count = len(actual_columns)
        expected_column_count = len(self.expected_columns)
        
        if actual_column_count != expected_column_count:
            error_message = (f'Número incorreto de colunas. Esperado: {expected_column_count}, '
                            f'Encontrado: {actual_column_count}.')
            debug(error_message, 'ERROR', conn)
            return False
        
        incorrect_columns = [col for col in actual_columns if col not in self.expected_columns]
        
        if incorrect_columns:
            error_message = (f'Nomes de colunas incorretos encontrados: {incorrect_columns}. '
                            f'Esperado: {self.expected_columns}.')
            debug(error_message, 'ERROR',conn)
            return False
        
        debug(f'O DataFrame tem o número correto de colunas ({actual_column_count}) e os nomes estão corretos.', 'INFO',conn)
        return True
    
    def valida_codigos(self, conn):
        """Verifica se os códigos nas colunas especificadas têm exatamente 4 caracteres."""
        invalid_codes = 0
        for col in self.mapper._COLUNAS_COD:
            def check_codigo(value):
                nonlocal invalid_codes
                if isinstance(value, (int, str)):
                    value_str = str(value)
                    if len(value_str) == 4:
                        return value_str
                    else:
                        highlighted_value = f'[INVALID CODE: {value_str}]'
                        debug(f'Código inválido encontrado e destacado: {highlighted_value} na coluna {col}.', 'WARNING', conn)
                        invalid_codes += 1
                        return highlighted_value
                else:
                    highlighted_value = f'[INVALID CODE: {value}]'
                    debug(f'Código inválido encontrado e destacado: {highlighted_value} na coluna {col}.', 'WARNING', conn)
                    invalid_codes += 1
                    return highlighted_value

            self.df[col] = self.df[col].apply(check_codigo)

        return self.df

    def validate_dates(self, conn):
        """Formata as colunas de datas para o formato YYYY-MM-DD, mantendo o valor original destacado se a data for inválida."""
        ignored_dates = 0
        
        for col in self.mapper._COLUNAS_DATA:
            def try_convert_date(value):
                nonlocal ignored_dates
                try:
                    return pd.to_datetime(value, format='%d/%m/%Y', errors='raise', dayfirst=True).strftime('%Y-%m-%d')
                except Exception:
                    highlighted_value = f'[INVALID DATE: {value}]'
                    debug(f'Data inválida encontrada e destacada: {highlighted_value} na coluna {col}.', 'WARNING', conn)
                    ignored_dates += 1
                    return highlighted_value
            
            self.df[col] = self.df[col].apply(try_convert_date)
        
        return self.df

    def validate_decimals(self, conn):
        """Verifica e formata colunas decimais, mantendo o valor original destacado se for inválido."""
        ignored_decimals = 0
        for col in self.mapper._COLUNAS_DECIMAL:
            def try_convert_decimal(value):
                nonlocal ignored_decimals
                try:
                    return float(value)
                except (ValueError, TypeError):
                    highlighted_value = f'[INVALID DECIMAL: {value}]'
                    debug(f'Número decimal inválido encontrado e destacado: {highlighted_value} na coluna {col}.', 'WARNING', conn)
                    ignored_decimals += 1
                    return highlighted_value

            self.df[col] = self.df[col].apply(try_convert_decimal)

        return self.df

    def validate_integers(self, conn):
        """Verifica e formata colunas inteiras, mantendo o valor original destacado se for inválido."""
        ignored_integers = 0
        for col in self.mapper._COLUNAS_INTEIRO:
            def try_convert_integer(value):
                nonlocal ignored_integers
                try:
                    return int(value)
                except (ValueError, TypeError):
                    highlighted_value = f'[INVALID INTEGER: {value}]'
                    debug(f'Número inteiro inválido encontrado e destacado: {highlighted_value} na coluna {col}.', 'WARNING', conn)
                    ignored_integers += 1
                    return highlighted_value

            self.df[col] = self.df[col].apply(try_convert_integer)

        return self.df

    def validate_all(self, conn):
        """Executa todas as validações no DataFrame em sequência."""
        self.valida_colunas(conn)
        self.valida_codigos(conn)
        self.validate_dates(conn)
        self.validate_decimals(conn)
        self.validate_integers(conn)
        return self.df
    
def insert_data(row, conn):
    """Insere uma única linha de dados no banco de dados usando o mapeamento do MapperSalesData."""
    try:
        cur = conn.cursor()

        # Obtenha o mapeamento das colunas
        mapper = MapperSalesData()
        column_mapping = mapper._MAPEAMENTO_TO_TABELA

        # Crie uma lista de colunas e valores com base no mapeamento
        columns = list(column_mapping.values())
        values = [row[col] for col in column_mapping.keys()]

        # Construa a consulta SQL dinamicamente com base nas colunas mapeadas
        insert_query = sql.SQL("""
            INSERT INTO vendas.stage_sales_data ({})
            VALUES ({})
        """).format(
            sql.SQL(', ').join(map(sql.Identifier, columns)),
            sql.SQL(', ').join(sql.Placeholder() * len(columns))
        )

        # Execute a consulta com os valores mapeados
        cur.execute(insert_query, values)
        conn.commit()
        cur.close()
    except Exception as e:
        conn.rollback()
        raise e

def insert_monitoring_data(conn, original_count, cleaned_count, ignored_count, data_inicio, data_fim):
    """Insere as informações de monitoramento na tabela de monitoramento e retorna o monitoring_stage_id."""
    try:
        cur = conn.cursor()
        insert_monitoring_query = sql.SQL("""
            INSERT INTO vendas.monitoring_stage_data (
                data_inicio, arquivo_original_registros, registros_apos_limpeza, registros_ignorados, data_fim
            ) VALUES (%s, %s, %s, %s, %s)
            RETURNING id;
        """)
        cur.execute(insert_monitoring_query, (data_inicio, original_count, cleaned_count, ignored_count, data_fim))
        monitoring_stage_id = cur.fetchone()[0]  # Obter o ID gerado
        conn.commit()
        cur.close()
        debug("Dados de monitoramento inseridos com sucesso.", 'INFO', conn)
        return monitoring_stage_id
    except Exception as e:
        debug(f'Erro ao inserir dados de monitoramento: {e}', 'ERROR', conn)
        conn.rollback()
        return None

def process_data(df, conn):
    """Processa o DataFrame, inserindo linha por linha no banco de dados e lidando com erros."""
    error_rows = []
    
    for index, row in df.iterrows():
        try:
            insert_data(row, conn)
        except Exception as e:
            debug(f'Erro ao inserir linha {index}: {e}', 'ERROR', conn)
            error_rows.append(row)
    
    return error_rows

def save_error_rows_to_csv(error_rows,conn):
    """Salva as linhas com erro em um arquivo .csv na pasta linhas_erradas."""
    if not error_rows.empty:
        os.makedirs('linhas_erradas', exist_ok=True)
        error_file_path = os.path.join('linhas_erradas', 'erros.csv')
        error_rows.to_csv(error_file_path, index=False)
        debug(f'{len(error_rows)} linhas com erro foram salvas em {error_file_path}', 'WARNING', conn)

def main():
    conn = None
    try:
        send_telegram_message("📊 Iniciando o processo de carregamento de dados...")
        conn = connect_to_db()

        # Registrar o início do processo
        data_inicio = datetime.now()

        df = pd.read_excel('sales_data_with_dates.xlsx')
        original_count = len(df)

        debug("✅ Dados Carregados com sucesso", 'INFO', conn)

        debug("🌀 Iniciando o processo de transformação de dados...", 'INFO', conn)

        transformer = DataFrameTransformer(df)
        df = transformer.transform(conn)

        debug("✅ Transformações de dados concluídas.", 'INFO', conn)

        debug("🔍 Iniciando o processo de validação dos dados...", 'INFO', conn)

        validator = DataFrameValidator(df)
        df = validator.validate_all(conn)

        debug("✅ Validações de dados concluídas.", 'INFO', conn)

        debug("📥 Iniciando o processo de inserção dos dados...", 'INFO', conn)
        truncate_table(conn)

        error_rows = process_data(df, conn)

        after_insert_count = get_row_count(conn)

        ignored_count = original_count - after_insert_count

        # Registrar o fim do processo

        data_fim = datetime.now()

        # Inserir os dados de monitoramento com o ID gerado, data_inicio e data_fim
    
        insert_monitoring_data(conn, original_count, after_insert_count, ignored_count, data_inicio, data_fim)

        # Verificação de erros
        if len(error_rows) > 0:
            send_telegram_message(f"⚠️ Dados inseridos no banco com sucesso, mas {len(error_rows)} linhas apresentaram erros.")
        else:
            send_telegram_message("✅ Dados inseridos no banco com sucesso.")

        debug('Script executado com sucesso.', 'INFO', conn)

    except Exception as e:
        if conn and not conn.closed:
            debug(f'Ocorreu um erro na execução do script: {e}', 'ERROR', conn)
        else:
            print(f'Ocorreu um erro na execução do script: {e}')
        send_telegram_message(f"❌ *Ocorreu um erro na execução do script:* {e}")
    finally:
        if conn and not conn.closed:
            conn.close()


if __name__ == '__main__':
    main()
