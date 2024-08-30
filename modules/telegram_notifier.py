import os
import requests
from dotenv import load_dotenv

# Carregar variáveis do arquivo .env
load_dotenv()

class TelegramNotifier:
    def __init__(self):
        self.token = os.getenv('TELEGRAM_BOT_TOKEN')
        self.chat_id = os.getenv('TELEGRAM_CHAT_ID')

    def send_message(self, message):
        """Envia uma mensagem ao Telegram usando um bot."""
        try:
            if not self.token or not self.chat_id:
                print("Token do bot do Telegram ou chat ID não configurado.")
                return

            url = f"https://api.telegram.org/bot{self.token}/sendMessage"
            payload = {
                'chat_id': self.chat_id,
                'text': message,
                'parse_mode': None  # Remova o 'Markdown' para evitar problemas de parsing
            }
            response = requests.post(url, data=payload)
            if response.status_code == 200:
                print("Mensagem enviada ao Telegram com sucesso.")
            else:
                print(f"Falha ao enviar mensagem ao Telegram. Status: {response.status_code}, Response: {response.text}")
        except Exception as e:
            print(f"Erro ao enviar mensagem ao Telegram: {e}")
