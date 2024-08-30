import os
import pandas as pd
from modules.log import Log
from psycopg2 import sql
class DataProcessor:
    def __init__(self, df, conn):
        self.df = df
        self.conn = conn
        from mappers.mappers import MapperSalesData
        self.mapper = MapperSalesData()

    def transform_data(self):
        """Transforma os dados aplicando todas as etapas de transformação."""
        self.remove_unused_columns()
        self.remove_spaces()
        self.remove_blank_rows()
        self.remove_duplicates()
        return self.df

    def remove_unused_columns(self, columns_to_keep=None):
        """Remove colunas que não são utilizadas."""
        if columns_to_keep is None:
            columns_to_keep = list(self.mapper._MAPEAMENTO_TO_TABELA.values())

        columns_to_remove = [col for col in self.df.columns if col not in columns_to_keep]
        if columns_to_remove:
            self.df = self.df.drop(columns=columns_to_remove)
            Log().debug(f"Colunas removidas: {columns_to_remove}.", 'WARNING', self.conn)
        else:
            Log().debug("Nenhuma coluna não utilizada encontrada para remoção.", 'INFO', self.conn)

    def remove_blank_rows(self):
        """Remove linhas que estão completamente em branco."""
        before_removal = len(self.df)
        self.df = self.df.dropna(how='all')
        after_removal = len(self.df)
        removed_rows = before_removal - after_removal
        Log().debug(f"{removed_rows} linhas em branco foram removidas.", 'WARNING', self.conn)

    def remove_spaces(self):
        """Remove espaços antes e depois dos valores em strings."""
        self.df = self.df = self.df.map(lambda x: x.strip() if isinstance(x, str) else x)
        Log().debug("Espaços entre stings removidos.", 'WARNING', self.conn)

    def remove_duplicates(self):
        """Remove duplicatas do DataFrame e retorna o DataFrame limpo."""
        before_removal = len(self.df)
        self.df = self.df.drop_duplicates()
        after_removal = len(self.df)
        removed_duplicates = before_removal - after_removal
        Log().debug(f"{removed_duplicates} linhas duplicadas foram removidas.", 'WARNING', self.conn)

    def validate_data(self):
        """Executa todas as validações no DataFrame em sequência."""
        self.valida_colunas()
        self.valida_codigos()
        self.validate_dates()
        self.validate_decimals()
        self.validate_integers()
        return self.df

    def valida_colunas(self):
        """Verifica se o DataFrame tem o número esperado de colunas e se os nomes das colunas estão corretos."""
        actual_columns = self.df.columns.tolist()
        actual_column_count = len(actual_columns)
        expected_column_count = len(self.mapper._MAPEAMENTO_TO_TABELA.values())

        if actual_column_count != expected_column_count:
            error_message = (f'Número incorreto de colunas. Esperado: {expected_column_count}, '
                            f'Encontrado: {actual_column_count}.')
            Log().debug(error_message, 'ERROR', self.conn)
            return False

        incorrect_columns = [col for col in actual_columns if col not in self.mapper._MAPEAMENTO_TO_TABELA.values()]

        if incorrect_columns:
            error_message = (f'Nomes de colunas incorretos encontrados: {incorrect_columns}. '
                            f'Esperado: {self.mapper._MAPEAMENTO_TO_TABELA.values()}.')
            Log().debug(error_message, 'ERROR', self.conn)
            return False

        Log().debug(f'O DataFrame tem o número correto de colunas ({actual_column_count}) e os nomes estão corretos.', 'INFO', self.conn)
        return True

    def valida_codigos(self):
        """Verifica se os códigos nas colunas especificadas têm exatamente 4 caracteres."""
        for col in self.mapper._COLUNAS_COD:
            self.df[col] = self.df[col].apply(self.check_codigo, col=col)
        return self.df

    def check_codigo(self, value, col):
        """Função auxiliar para verificar os códigos."""
        if isinstance(value, (int, str)):
            value_str = str(value)
            if len(value_str) == 4:
                return value_str
            else:
                highlighted_value = f'[INVALID CODE: {value_str}]'
                Log().debug(f'Código inválido encontrado e destacado: {highlighted_value} na coluna {col}.', 'WARNING', self.conn)
                return highlighted_value
        else:
            highlighted_value = f'[INVALID CODE: {value}]'
            Log().debug(f'Código inválido encontrado e destacado: {highlighted_value} na coluna {col}.', 'WARNING', self.conn)
            return highlighted_value

    def validate_dates(self):
        """Formata as colunas de datas para o formato YYYY-MM-DD, mantendo o valor original destacado se a data for inválida."""
        for col in self.mapper._COLUNAS_DATA:
            self.df[col] = self.df[col].apply(self.try_convert_date, col=col)
        return self.df

    def try_convert_date(self, value, col):
        """Função auxiliar para validar e formatar datas."""
        try:
            return pd.to_datetime(value, format='%d/%m/%Y', errors='raise', dayfirst=True).strftime('%Y-%m-%d')
        except Exception:
            highlighted_value = f'[INVALID DATE: {value}]'
            Log().debug(f'Data inválida encontrada e destacada: {highlighted_value} na coluna {col}.', 'WARNING', self.conn)
            return highlighted_value

    def validate_decimals(self):
        """Verifica e formata colunas decimais, mantendo o valor original destacado se for inválido."""
        for col in self.mapper._COLUNAS_DECIMAL:
            self.df[col] = self.df[col].apply(self.try_convert_decimal, col=col)
        return self.df

    def try_convert_decimal(self, value, col):
        """Função auxiliar para validar e formatar números decimais."""
        try:
            return float(value)
        except (ValueError, TypeError):
            highlighted_value = f'[INVALID DECIMAL: {value}]'
            Log().debug(f'Número decimal inválido encontrado e destacado: {highlighted_value} na coluna {col}.', 'WARNING', self.conn)
            return highlighted_value

    def validate_integers(self):
        """Verifica e formata colunas inteiras, mantendo o valor original destacado se for inválido."""
        for col in self.mapper._COLUNAS_INTEIRO:
            self.df[col] = self.df[col].apply(self.try_convert_integer, col=col)
        return self.df

    def try_convert_integer(self, value, col):
        """Função auxiliar para validar e formatar números inteiros."""
        try:
            return int(value)
        except (ValueError, TypeError):
            highlighted_value = f'[INVALID INTEGER: {value}]'
            Log().debug(f'Número inteiro inválido encontrado e destacado: {highlighted_value} na coluna {col}.', 'WARNING', self.conn)
            return highlighted_value
        
    def process_data(self):
        """Processa o DataFrame, inserindo linha por linha no banco de dados e lidando com erros."""
        error_rows = []
        
        for index, row in self.df.iterrows():
            try:
                self.insert_data(row)
            except Exception as e:
                Log().debug(f'Erro ao inserir linha {index}: {e}', 'ERROR', self.conn)
                error_rows.append(row)
        
        return pd.DataFrame(error_rows) 
    
    def save_error_rows_to_csv(self, error_rows_df):
        """Salva as linhas com erro em um arquivo .csv na pasta linhas_erradas."""
        if not isinstance(error_rows_df, pd.DataFrame):
            Log().debug("O objeto error_rows_df não é um DataFrame.", 'ERROR', self.conn)
            return

        if not error_rows_df.empty:
            try:
                os.makedirs('linhas_erradas', exist_ok=True)  # Cria a pasta se não existir
                error_file_path = os.path.join('linhas_erradas', 'erros.csv')
                error_rows_df.to_csv(error_file_path, index=False)  # Salva o DataFrame como CSV
                Log().debug(f'{len(error_rows_df)} linhas com erro foram salvas em {error_file_path}', 'WARNING', self.conn)
            except Exception as e:
                Log().debug(f"Erro ao salvar as linhas com erro: {e}", 'ERROR', self.conn)

    def insert_data(self, row):
        """Insere uma única linha de dados no banco de dados usando o mapeamento do MapperSalesData."""
        try:
            cur = self.conn.cursor()

            # Obtenha o mapeamento das colunas
            column_mapping = self.mapper._MAPEAMENTO_TO_TABELA

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
            self.conn.commit()
            cur.close()
        except Exception as e:
            self.conn.rollback()
            raise e

    def get_row_count(self):
        """Retorna o número de linhas na tabela vendas.stage_sales_data."""
        try:
            cur = self.conn.cursor()
            cur.execute("SELECT COUNT(*) FROM vendas.stage_sales_data")
            row_count = cur.fetchone()[0]
            cur.close()
            return row_count
        except Exception as e:
            Log().debug(f'Erro ao contar as linhas da tabela: {e}', 'ERROR', self.conn)
            self.conn.rollback()
            return 0

