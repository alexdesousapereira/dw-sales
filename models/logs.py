from sqlalchemy import Column, Integer, String, TIMESTAMP, Sequence
from .model_base import ModelBase  
from sqlalchemy.sql import func

class Logs(ModelBase):
    __tablename__ = 'logs'
    __table_args__ = {'schema': 'vendas'}

    id = Column(Integer, Sequence('logs_id_seq'), primary_key=True)
    log_timestamp = Column(TIMESTAMP, server_default=func.current_timestamp(), nullable=False)
    log_level = Column(String(10), nullable=True)
    message = Column(String, nullable=True)
