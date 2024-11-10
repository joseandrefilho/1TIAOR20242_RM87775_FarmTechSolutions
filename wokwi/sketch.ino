#include <WiFi.h>            // Biblioteca para se conectar ao WiFi
#include <PubSubClient.h>    // Biblioteca para se conectar a um broker MQTT
#include <DHT.h>             // Biblioteca para manipular o sensor DHT22 (temperatura e umidade)

// Credenciais para acesso à rede WiFi e ao broker MQTT
const char* ssid = "Wokwi-GUEST";        // Nome da rede WiFi
const char* password = "";               // Senha da rede WiFi (não há senha neste caso)
const char* mqtt_server = "test.mosquitto.org";  // Endereço do servidor MQTT (broker)

WiFiClient WOKWI_Client;                 // Cria um cliente WiFi
PubSubClient client(WOKWI_Client);       // Cria um cliente MQTT usando o cliente WiFi

// Definição dos pinos para sensores e atuadores
#define DHTPIN 4        // Pino GPIO onde o sensor DHT22 está conectado
#define DHTTYPE DHT22   // Tipo do sensor DHT
#define LDRPIN 34       // Pino GPIO onde o LDR está conectado (simulando sensor de pH)
#define BP_PIN_P 12     // Pino GPIO do botão para o nutriente P
#define BP_PIN_K 14     // Pino GPIO do botão para o nutriente K
#define LED_P 26        // Pino GPIO do LED para indicar a necessidade do nutriente P
#define LED_K 27        // Pino GPIO do LED para indicar a necessidade do nutriente K
#define LED_RELE 21     // Pino GPIO do LED para indicar o estado do relé de irrigação
#define RELE_PIN 22     // Pino GPIO do relé que controla a bomba de irrigação

// Inicializa o sensor DHT no pino definido
DHT dht(DHTPIN, DHTTYPE);

// Variáveis globais
bool button_P = false;       // Estado do botão P
bool button_K = false;       // Estado do botão K
int led_P_state = LOW;       // Estado do LED do nutriente P
int led_K_state = LOW;       // Estado do LED do nutriente K
int led_Rele_state = LOW;    // Estado do LED do relé de irrigação
float pHLevelIntermediario;  // Valor intermediário para o cálculo do pH
bool nutrientP = false;      // Indica se o nutriente P é necessário
bool nutrientK = false;      // Indica se o nutriente K é necessário
float umidade = 0.0;         // Valor da umidade do solo
bool releState = false;      // Estado do relé

// Função para configurar a conexão WiFi
void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.mode(WIFI_STA);             // Configura o ESP32 para modo station (conectar-se à rede)
  WiFi.begin(ssid, password);      // Inicia a conexão WiFi

  // Espera a conexão ser estabelecida
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());  // Exibe o endereço IP atribuído pelo roteador
}

// Função para reconectar ao broker MQTT caso a conexão seja perdida
void reconnect() {
  // Continua tentando até conseguir se reconectar
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
        
    if (client.connect("WOKWI_Client")) {  // Tenta conectar ao broker MQTT
      Serial.println("connected");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000); // Aguarda 5 segundos antes de tentar novamente
    }
  }
}

// Configuração inicial dos componentes
void setup() {
  Serial.begin(115200);  // Inicializa a comunicação serial com taxa de 115200 bps
  
  randomSeed(analogRead(0));  // Inicializa o gerador de números aleatórios (usado para simular dados de irrigação)

  setup_wifi();  // Configura o WiFi
  client.setServer(mqtt_server, 1883);  // Define o servidor MQTT e a porta

  // Inicialização dos pinos como entrada/saída
  pinMode(BP_PIN_P, INPUT_PULLUP);  // Botão com pull-up interno (evita leitura flutuante)
  pinMode(BP_PIN_K, INPUT_PULLUP);  
  pinMode(LED_P, OUTPUT);           // LED do nutriente P como saída
  pinMode(LED_K, OUTPUT);           
  pinMode(LED_RELE, OUTPUT);        
  pinMode(LDRPIN, INPUT);           // LDR como entrada
  pinMode(RELE_PIN, OUTPUT);        
  digitalWrite(RELE_PIN, LOW);      // Relé inicialmente desligado
  
  dht.begin();  // Inicializa o sensor DHT

}

// Loop principal que mantém o sistema em funcionamento
void loop() {
  if (!client.connected()) {
    reconnect();  // Reconecta ao broker MQTT, caso não esteja conectado
  }
  client.loop();  // Mantém a conexão MQTT ativa

  // Leitura dos botões com debounce
  if (digitalRead(BP_PIN_P) == LOW) {
    delay(50);  // Delay de debounce para evitar leituras falsas
    if (digitalRead(BP_PIN_P) == LOW) { 
      led_P_state = !led_P_state;  // Alterna o estado do LED do nutriente P
      nutrientP = led_P_state;     // Atualiza o estado do nutriente P
      digitalWrite(LED_P, led_P_state);  // Atualiza o LED
    }
  }

  if (digitalRead(BP_PIN_K) == LOW) {
    delay(50);
    if (digitalRead(BP_PIN_K) == LOW) { 
      led_K_state = !led_K_state;  // Alterna o estado do LED do nutriente K
      nutrientK = led_K_state;     // Atualiza o estado do nutriente K
      digitalWrite(LED_K, led_K_state);  // Atualiza o LED
    }
  }

  // Leitura do sensor DHT22 (umidade)
  float umidade = dht.readHumidity();
  if (isnan(umidade)) {
    Serial.println("Falha na leitura do sensor DHT22!");
    return;  // Sai do loop caso a leitura falhe
  }

  // Leitura do sensor DHT22 (temperatura)
  float temperatura = dht.readTemperature();
  if (isnan(temperatura)) {
    Serial.println("Falha na leitura do sensor DHT22!");
    return;
  }

  // Leitura do LDR (simulando pH)
  int ldrValue = analogRead(LDRPIN);
  
  // Conversão do valor lido para o nível de pH (ajustar conforme necessário)
  pHLevelIntermediario = map(ldrValue, 4063, 32, 0, 1400);
  float pHLevel = pHLevelIntermediario / 100.00;

  // Lógica para determinar se a irrigação deve ser ativada
  if (shouldIrrigate(nutrientP, nutrientK, pHLevel, umidade, temperatura)) {
    digitalWrite(RELE_PIN, HIGH); // Liga a bomba de irrigação
    digitalWrite(LED_RELE, HIGH); // Acende o LED
  } else {
    digitalWrite(RELE_PIN, LOW); // Desliga a bomba de irrigação
    digitalWrite(LED_RELE, LOW); // Apaga o LED
  }

  // Exibição dos dados coletados no Monitor Serial
  Serial.print("Nutriente P: "); Serial.println(nutrientP);
  Serial.print("Nutriente K: "); Serial.println(nutrientK);
  Serial.print("Umidade do Solo: "); Serial.print(umidade); Serial.println("%");
  Serial.print("Temperatura: "); Serial.print(temperatura); Serial.println("°C");
  Serial.print("Nível de pH: "); Serial.println(pHLevel);
  Serial.print("Bomba de Irrigação: "); Serial.println(digitalRead(RELE_PIN) == HIGH ? "Ligada" : "Desligada");
  Serial.println("----");

  // Gera valor de irrigação aleatório se o relé estiver ligado, senão 0
  float irrigacao = digitalRead(RELE_PIN) == HIGH ? random(50, 151) : 0;

  // Publica os dados coletados no broker MQTT
  publish_data(umidade, temperatura, pHLevel, nutrientP, nutrientK, irrigacao);

  delay(2000); // Aguarda 2 segundos antes da próxima leitura
}

// Função para decidir se a irrigação deve ser ativada
bool shouldIrrigate(bool nP, bool nK, float pH, float umidade, float temperatura) {
  // Regras funcionais para a irrigação:
  // - A irrigação é ativada se a umidade estiver abaixo de 50%
  // - Se o nutriente P ou K for necessário
  // - Se o nível de pH estiver fora da faixa ideal (5.00 a 7.00)
  // - Se a temperatura estiver acima de 30°C (indicando alta evapotranspiração)
  // - Ou se a temperatura estiver abaixo de 10°C (indicando necessidade de regulação)
  return (umidade < 50.0 || nP || nK || pH < 5.00 || pH > 7.00 || temperatura > 30.0 || temperatura < 10.0);
}

// Função para publicar dados no broker MQTT
void publish_data(float umidade, float temperatura, float pH, bool nP, bool nK, float irrigacao) {
  char message[256];
  snprintf(message, sizeof(message), 
           "{\"Umidade do Solo\": %.2f, \"Temperatura\": %.2f, \"PH\": %.2f, \"Nutriente P\": %s, \"Nutriente K\": %s, \"Irrigacao\": %.2f}",
           umidade, temperatura, pH, nP ? "true" : "false", nK ? "true" : "false", irrigacao);

  client.publish("farmtech/monitoramento", message);  // Publica a mensagem no tópico do MQTT
}
