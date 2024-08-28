# mappers/mappers.py

class MapperSalesData:

    _QTDE_ATRIBUTOS_CABECALHO_RELATORIO = 11
    _PRIMARY = []
    _DATA_REFERENCIA = 'data_venda'
    _EXTRA_INFO = {}

    _MAPEAMENTO_TO_TABELA = {
        "data_venda": "data_venda",
        "numero_nota": "numero_nota",
        "codigo_produto": "codigo_produto",
        "descricao_produto": "descricao_produto",
        "codigo_cliente": "codigo_cliente",
        "descricao_cliente": "descricao_cliente",
        "valor_unitario_produto": "valor_unitario_produto",
        "quantidade_vendida_produto": "quantidade_vendida_produto",
        "valor_total": "valor_total",
        "custo_da_venda": "custo_da_venda",
        "valor_tabela_de_preco_do_produto": "valor_tabela_de_preco_do_produto"
    }

    _COLUNAS_DATA = [
        "data_venda"
    ]
    
    _COLUNAS_DECIMAL = [
        "valor_unitario_produto",
        "valor_total",
        "custo_da_venda",
        "valor_tabela_de_preco_do_produto"
    ]

    _COLUNAS_INTEIRO = [
        "numero_nota",
        "valor_tabela_de_preco_do_produto"
    ]

    _COLUNAS_TEXTO = [
        ('descricao_produto', True),
        ('descricao_cliente', True),
    ]

    _COLUNAS_COD = [
        "codigo_produto",
        "codigo_cliente"
    ]
