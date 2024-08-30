class DatabaseConnectionError(Exception):
    """Exceção lançada quando não é possível conectar ao banco de dados."""
    def __init__(self, message="Erro ao conectar ao banco de dados."):
        self.message = message
        super().__init__(self.message)

class DataValidationError(Exception):
    """Exceção lançada quando os dados falham na validação."""
    def __init__(self, message="Erro na validação dos dados."):
        self.message = message
        super().__init__(self.message)

class DataProcessingError(Exception):
    """Exceção lançada quando há um erro no processamento de dados."""
    def __init__(self, message="Erro no processamento dos dados."):
        self.message = message
        super().__init__(self.message)

class LogError(Exception):
    """Exceção lançada quando há um erro ao registrar um log."""
    def __init__(self, message="Erro ao registrar log no banco de dados."):
        self.message = message
        super().__init__(self.message)
