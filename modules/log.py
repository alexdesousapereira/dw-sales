import logging
from psycopg2 import sql

class Log:
    def __init__(self):
        pass

    def debug(self, message, level='INFO', conn=None):
        """Função para depuração que imprime e registra mensagens, e insere logs no banco de dados."""

        # Log para o arquivo e console
        getattr(logging, level.lower())(message)
        print(message)

        # Inserir log no banco de dados, se a conexão for fornecida e ainda estiver aberta
        if conn is not None and not conn.closed:
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
                print(f"Erro ao registrar log no banco de dados: {e}")
                conn.rollback()
