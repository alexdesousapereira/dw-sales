"""Create views for sales data

Revision ID: f39a82f66cdd
Revises: d7645968a28f
Create Date: 2024-08-30 15:08:56.070510

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'f39a82f66cdd'
down_revision: Union[str, None] = 'd7645968a28f'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade():
    # Criar a primeira view para código e descrição do produto
    op.execute("""
    CREATE VIEW vendas.view_produto AS
    SELECT DISTINCT 
        codigo_produto, 
        descricao_produto 
    FROM vendas.stage_sales_data ssd;
    """)

    # Criar a segunda view para código e descrição do cliente
    op.execute("""
    CREATE VIEW vendas.view_cliente AS
    SELECT DISTINCT 
        codigo_cliente, 
        descricao_cliente  
    FROM vendas.stage_sales_data ssd;
    """)

    # Criar a terceira view com as colunas selecionadas de stage_sales_data
    op.execute("""
    CREATE VIEW vendas.view_sales_summary AS
    SELECT 
        data_venda,
        numero_nota,
        codigo_produto,
        codigo_cliente,
        valor_unitario_produto,
        quantidade_vendida_produto,
        valor_total,
        custo_da_venda,
        valor_tabela_de_preco_do_produto
    FROM vendas.stage_sales_data;
    """)

def downgrade():
    # Dropar as views na ordem inversa de criação
    op.execute("DROP VIEW IF EXISTS vendas.view_sales_summary;")
    op.execute("DROP VIEW IF EXISTS vendas.view_cliente;")
    op.execute("DROP VIEW IF EXISTS vendas.view_produto;")