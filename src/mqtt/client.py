import paho.mqtt.client as mqtt
import json
from utils.funcoes import Funcoes

class MQTTClient:
    def __init__(self, broker="mqtt.eclipseprojects.io", port=1883, topic="rm87775/farmtech/data"):
        self.broker = broker
        self.port = port
        self.topic = topic
        self.client = mqtt.Client(protocol=mqtt.MQTTv5)
        self.client.on_message = self.on_message

    def connect(self):
        self.client.connect(self.broker, self.port, 60)
        self.client.subscribe(self.topic)
        print(f"Conectado ao broker MQTT {self.broker} e inscrito no tópico {self.topic}.")

    def start(self):
        self.connect()
        self.client.loop_forever()

    def on_message(self, client, userdata, msg):
        try:
            raw_payload = msg.payload.decode()
            payload = json.loads(raw_payload)

            # Criando objeto Funcoes com os dados do ESP32
            funcoes = Funcoes(
                umidadeSolo=payload.get('U'),      # Umidade
                temperatura=payload.get('T'),      # Temperatura
                pH=payload.get('pH'),              # pH
                nutrienteP=payload.get('P'),       # Nutriente P
                nutrienteK=payload.get('K'),       # Nutriente K
                irrigacao=payload.get('IRR')       # Estado da Irrigação
            )
            funcoes.save()  # Salva a leitura no banco de dados
        except json.JSONDecodeError as e:
            print(f"Erro ao decodificar mensagem MQTT: {e}")
