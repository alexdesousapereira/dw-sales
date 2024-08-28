from sqlalchemy import Column, Integer, String, Numeric, DateTime, CHAR
from .model_base import ModelBase  


class StageSalesData(ModelBase ):
    __tablename__ = 'stage_sales_data'
    __table_args__ = {'schema': 'vendas'}
    data_venda = Column(DateTime, nullable=True,primary_key=True)
    numero_nota = Column(Integer, nullable=True,primary_key=True)
    codigo_produto = Column(CHAR(4), nullable=True)
    descricao_produto = Column(String(100), nullable=True)
    codigo_cliente = Column(CHAR(4), nullable=True)
    descricao_cliente = Column(String(100), nullable=True)
    valor_unitario_produto = Column(Numeric, nullable=True)
    quantidade_vendida_produto = Column(Integer, nullable=True)
    valor_total = Column(Numeric, nullable=True)
    custo_da_venda = Column(Numeric, nullable=True)
    valor_tabela_de_preco_do_produto = Column(Numeric, nullable=True)
