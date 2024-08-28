# mappers/mappers.py

class MapperSalesData:

    _QTDE_ATRIBUTOS_CABECALHO_RELATORIO = 11
    _PRIMARY = []
    _DATA_REFERENCIA = 'data_venda'
    _EXTRA_INFO = {}

    _MAPEAMENTO_TO_TABELA = {
        "data_venda": "data_venda",
        "numero_nota": "num_nota",
        "codigo_produto": "cod_produto",
        "descricao_produto": "desc_produto",
        "codigo_cliente": "cod_cliente",
        "descricao_cliente": "desc_cliente",
        "valor_unitario_produto": "val_unit_produto",
        "quantidade_vendida_produto": "quant_vend_produto",
        "valor_total": "val_total",
        "custo_da_venda": "custo_venda",
        "valor_tabela_de_preco_do_produto": "val_tab_produto"
    }

    _COLUNAS_DATA = [
        "data_venda",
    ]

    _COLUNAS_HORA = []

    _COLUNAS_DECIMAL = [
        "valor_unitario_produto",
        "valor_total",
        "custo_da_venda",
        "valor_tabela_de_preco_do_produto"
    ]

    _COLUNAS_INTEIRO = [
        "numero_nota",
        "quantidade_vendida_produto"
    ]

    _COLUNAS_TEXTO = [
        ('descricao_produto', True),
        ('descricao_cliente', True),
    ]

    _COLUNAS_COD = [
        "codigo_produto",
        "codigo_cliente"
    ]
