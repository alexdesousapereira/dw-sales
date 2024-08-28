from sqlalchemy import Column, Integer, TIMESTAMP, Sequence
from .model_base import ModelBase  
from sqlalchemy.sql import func

class MonitoringStageData(ModelBase):
    __tablename__ = 'monitoring_stage_data'
    __table_args__ = {'schema': 'vendas'}

    id = Column(Integer, Sequence('monitoring_stage_data_id_seq'), primary_key=True)
    arquivo_original_registros = Column(Integer, nullable=True)
    registros_apos_limpeza = Column(Integer, nullable=True)
    registros_ignorados = Column(Integer, nullable=True)
    data_processamento = Column(TIMESTAMP, server_default=func.current_timestamp(), nullable=False)
