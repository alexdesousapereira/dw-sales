from .model_base import ModelBase  

# Importe os modelos individuais
from .stage_sales_data import StageSalesData
from .monitoring_stage_data import MonitoringStageData
from .logs import Logs

# Use um dos 'Base' para ser o principal, ou crie um Base separado
Base = ModelBase

# Certifique-se de importar todos os modelos aqui
__all__ = [
    'StageSalesData',
    'MonitoringStageData',
    'Logs'
]
