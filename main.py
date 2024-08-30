import os
import pandas as pd
from datetime import datetime
from modules import DatabaseConnection, Log, TelegramNotifier, DataProcessor, Monitoring
from utils import DataProcessingError, DatabaseConnectionError

def main():
    db = DatabaseConnection()
    notifier = TelegramNotifier()
    log = Log()

    try:
        notifier.send_message("📊 Iniciando o processo de carregamento de dados...")

        # Registrar o início do processo
        data_inicio = datetime.now()

        df = pd.read_excel('data/sales_data_with_dates.xlsx')
        original_count = len(df)

        log.debug("✅ Dados Carregados com sucesso", 'INFO', db.conn)

        log.debug("🌀 Iniciando o processo de transformação de dados...", 'INFO', db.conn)

        processor = DataProcessor(df, db.conn)

        log.debug("🔍 Iniciando o processo de validação dos dados...", 'INFO', db.conn)

        db.truncate_table('vendas.stage_sales_data') 

        df = processor.validate_data()

        log.debug("✅ Validações de dados concluídas.", 'INFO', db.conn)

        log.debug("📥 Iniciando o processo de inserção dos dados...", 'INFO', db.conn)

        error_rows_df = processor.process_data()

        after_insert_count = processor.get_row_count()

        ignored_count = original_count - after_insert_count

        # Registrar o fim do processo
        data_fim = datetime.now()

        # Inserir os dados de monitoramento com o ID gerado, data_inicio e data_fim
        monitor = Monitoring(db.conn)
        monitor.insert_monitoring_data(original_count, after_insert_count, ignored_count, data_inicio, data_fim)

        processor.save_error_rows_to_csv(error_rows_df)

        # Verificação de erros
        if not error_rows_df.empty:  
            notifier.send_message(f"⚠️ Dados inseridos no banco com sucesso, mas {len(error_rows_df)} linhas apresentaram erros.")
        else:
            notifier.send_message("✅ Dados inseridos no banco com sucesso.")

        log.debug('Script executado com sucesso.', 'INFO', db.conn)

    except DatabaseConnectionError as e:
        log.debug(f"Erro de conexão com o banco de dados: {e}", 'ERROR')
        notifier.send_message(f"❌ *Erro de conexão com o banco de dados:* {e}")
    except DataProcessingError as e:
        log.debug(f"Erro no processamento de dados: {e}", 'ERROR')
        notifier.send_message(f"❌ *Erro no processamento de dados:* {e}")
    except Exception as e:
        log.debug(f"Ocorreu um erro na execução do script: {e}", 'ERROR')
        notifier.send_message(f"❌ *Ocorreu um erro na execução do script:* {e}")
    finally:
        db.close()

if __name__ == '__main__':
    main()