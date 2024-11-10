import paho.mqtt.client as mqtt
import json
from utils.funcoes import Funcoes

class MQTTClient:
    def __init__(self, broker="test.mosquitto.org", port=1883, topic="farmtech/monitoramento"):
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

            # Cria um objeto Leitura com os dados recebidos
            funcoes = Funcoes(
                umidadeSolo=payload.get('Umidade do Solo'),
                temperatura=payload.get('Temperatura'),
                pH=payload.get('PH'),
                nutrienteP=payload.get('Nutriente P'),
                nutrienteK=payload.get('Nutriente K'),
                irrigacao=payload.get('Irrigacao')               
            )

            funcoes.save()  # Salva a leitura no banco de dados
        except json.JSONDecodeError as e:
            print(f"Erro ao decodificar mensagem MQTT: {e}")
