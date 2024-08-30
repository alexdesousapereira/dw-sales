import os
import psycopg2
from psycopg2 import sql
from dotenv import load_dotenv
from modules.log import Log

# Carregar variáveis do arquivo .env
load_dotenv()

class DatabaseConnection:
    def __init__(self):
        self.conn = None
        self.connect()

    def connect(self):
        """Função para conectar ao banco de dados."""
        try:
            self.conn = psycopg2.connect(
                host=os.getenv('DB_HOST'),
                port=os.getenv('DB_PORT'),
                user=os.getenv('DB_USER'),
                password=os.getenv('DB_PASSWORD'),
                dbname=os.getenv('DB_NAME')
            )
            Log().debug("Conexão com o banco de dados estabelecida com sucesso.", 'INFO', self.conn)
        except Exception as e:
            Log().debug(f'Erro ao conectar ao banco de dados: {e}', 'ERROR')
            raise

    def close(self):
        """Fecha a conexão com o banco de dados."""
        if self.conn and not self.conn.closed:
            self.conn.close()

    def truncate_table(self, table_name):
        """Trunca a tabela especificada antes de inserir novos dados."""
        try:
            cur = self.conn.cursor()
            cur.execute(f"TRUNCATE TABLE {table_name}")
            self.conn.commit()
            cur.close()
            Log().debug(f"Tabela {table_name} truncada com sucesso.", 'INFO', self.conn)
        except Exception as e:
            Log().debug(f'Erro ao truncar a tabela {table_name}: {e}', 'ERROR', self.conn)
            self.conn.rollback()
