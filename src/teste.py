import paho.mqtt.client as mqtt
import oracledb
import json

# Configurações do banco de dados Oracle
oracle_config = {
    'user': 'RM87775',
    'password': 'nova_senha',
    'dsn': 'oracle.fiap.com.br:1521/ORCL'
}

# Função para inserir os dados no banco de dados Oracle
def inserir_dados_oracle(payload):
    try:
        # Conectar ao banco de dados
        with oracledb.connect(**oracle_config) as conn:
            with conn.cursor() as cursor:
                # Inserir os dados na tabela apropriada
                sql = """
                    INSERT INTO t_leitura (id_sensor, dt_leitura, vl_umidade, vl_ph, vl_nutrientes)
                    VALUES (:id_sensor, :dt_leitura, :vl_umidade, :vl_ph, :vl_nutrientes)
                """
                cursor.execute(sql, payload)
                conn.commit()
    except oracledb.Error as e:
        print(f"Erro ao inserir dados no Oracle: {e}")

# Callback para quando a mensagem é recebida do broker MQTT
def on_message(client, userdata, msg):
    try:
        # Imprimir o payload bruto para depuração
        raw_payload = msg.payload.decode()
        print(f"raw_payload: {raw_payload}")

        # Converter a mensagem para JSON
        payload = json.loads(raw_payload)
        print(f"payload: {payload}")

        # # Preparar o dicionário para ser inserido no Oracle
        # dados = {
        #     'id_sensor': payload.get('id_sensor'),
        #     'dt_leitura': payload.get('dt_leitura'),
        #     'vl_umidade': payload.get('vl_umidade'),
        #     'vl_ph': payload.get('vl_ph'),
        #     'vl_nutrientes': payload.get('vl_nutrientes')
        # }
        
        # # Inserir os dados no banco de dados Oracle
        # inserir_dados_oracle(dados)
    except json.JSONDecodeError as e:
        print(f"Erro ao decodificar mensagem MQTT: {e}")

# Configurar cliente MQTT
client = mqtt.Client(protocol=mqtt.MQTTv5)  # Atualizar para a versão mais recente da API de callback
client.on_message = on_message

# Conectar ao broker MQTT e se inscrever no tópico
client.connect("test.mosquitto.org", 1883, 60)
client.subscribe("farmtech/monitoramento")

# Manter o loop do MQTT para receber mensagens
client.loop_forever()