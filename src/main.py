from mqtt.client import MQTTClient

def main():
    # Instancia o cliente MQTT e inicia a escuta
    mqtt_client = MQTTClient()
    mqtt_client.start()

if __name__ == "__main__":
    main()
