from psycopg2 import sql
from modules.log import Log

class Monitoring:
    def __init__(self, conn):
        self.conn = conn

    def insert_monitoring_data(self, original_count, cleaned_count, ignored_count, data_inicio, data_fim):
        """Insere as informações de monitoramento na tabela de monitoramento e retorna o monitoring_stage_id."""
        try:
            cur = self.conn.cursor()
            insert_monitoring_query = sql.SQL("""
                INSERT INTO vendas.monitoring_stage_data (
                    data_inicio, arquivo_original_registros, registros_apos_limpeza, registros_ignorados, data_fim
                ) VALUES (%s, %s, %s, %s, %s)
                RETURNING id;
            """)
            cur.execute(insert_monitoring_query, (data_inicio, original_count, cleaned_count, ignored_count, data_fim))
            monitoring_stage_id = cur.fetchone()[0]  # Obter o ID gerado
            self.conn.commit()
            cur.close()
            Log().debug("Dados de monitoramento inseridos com sucesso.", 'INFO', self.conn)
            return monitoring_stage_id
        except Exception as e:
            Log().debug(f'Erro ao inserir dados de monitoramento: {e}', 'ERROR', self.conn)
            self.conn.rollback()
            return None
