// Inclusão das bibliotecas necessárias
#include <Wire.h>              // I2C para comunicação com LCD
#include <LiquidCrystal_I2C.h> // Controle do LCD
#include <WiFi.h>              // Conectividade WiFi
#include <PubSubClient.h>      // Comunicação MQTT
#include <DHT.h>               // Sensor DHT22

// Otimização: Definição de constantes em PROGMEM para economia de RAM
static const char PROGMEM WIFI_SSID[] = "Wokwi-GUEST";
static const char PROGMEM WIFI_PASS[] = "";
static const char PROGMEM MQTT_SERVER[] = "mqtt.eclipseprojects.io";
static const char PROGMEM MQTT_TOPIC[] = "rm87775/farmtech/data";

// Otimização: Definição de pinos como const para melhor performance
static const uint8_t DHTPIN = 4;        // DHT22 data pin
static const uint8_t LDRPIN = 34;       // LDR analog pin
static const uint8_t BP_PIN_P = 12;     // Button P pin
static const uint8_t BP_PIN_K = 14;     // Button K pin
static const uint8_t LED_P = 26;        // LED P pin
static const uint8_t LED_K = 27;        // LED K pin
static const uint8_t LED_RELE = 19;     // LED Relay status
static const uint8_t RELE_PIN = 23;     // Relay control pin

// Otimização: Constantes do sistema usando tipos apropriados
static const uint8_t DHTTYPE = DHT22;
static const uint16_t DISPLAY_INTERVAL = 2000;
static const float UMIDADE_MIN = 50.0;
static const float TEMP_MAX = 30.0;
static const float PH_MIN = 5.0;
static const float PH_MAX = 7.0;

// Estrutura otimizada para dados do sistema
struct SystemData {
    float umidade;
    float temperatura;
    float pHLevel;
    struct {
        uint8_t led_P : 1;
        uint8_t led_K : 1;
        uint8_t nutrientP : 1;
        uint8_t nutrientK : 1;
        uint8_t releState : 1;
    } flags;
} sysData;

// Instanciação dos objetos
LiquidCrystal_I2C lcd(0x27, 16, 2);
WiFiClient wifiClient;
PubSubClient mqttClient(wifiClient);
DHT dht(DHTPIN, DHTTYPE);

// Variáveis de controle de tempo
unsigned long lastUpdate = 0;

// Função para inicializar o LCD
void setupLCD() {
    Wire.begin();
    lcd.init();
    lcd.backlight();
    lcd.clear();
    lcd.print(F("Iniciando..."));
    delay(1000);
}

// Função para configuração do WiFi
void setup_wifi() {
    lcd.clear();
    lcd.print(F("Conectando WiFi"));
    Serial.print(F("Conectando a "));
    Serial.println(WIFI_SSID);

    WiFi.begin(WIFI_SSID, WIFI_PASS);

    while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
        lcd.print(".");
    }

    lcd.clear();
    lcd.print(F("WiFi Conectado!"));
    lcd.setCursor(0, 1);
    lcd.print(WiFi.localIP());
    Serial.println(F("\nWiFi conectado"));
    Serial.println(F("Endereço IP: "));
    Serial.println(WiFi.localIP());
    delay(2000);
}

// Função para reconexão MQTT
void reconnect() {
    int tentativas = 0;
    while (!mqttClient.connected() && tentativas < 3) {
        Serial.print(F("Conectando MQTT..."));
        lcd.clear();
        lcd.print(F("Conectando MQTT"));
        
        if (mqttClient.connect("ESP32_FarmTech")) {
            Serial.println(F("Conectado"));
            lcd.clear();
            lcd.print(F("MQTT Conectado"));
            delay(1000);
        } else {
            tentativas++;
            Serial.print(F("Falha, rc="));
            Serial.print(mqttClient.state());
            Serial.println(F(" tentando novamente em 5s"));
            lcd.clear();
            lcd.print(F("Erro MQTT"));
            lcd.setCursor(0, 1);
            lcd.print(F("Tentativa: "));
            lcd.print(tentativas);
            delay(5000);
        }
    }
}

// Função para publicar dados no MQTT
void publishData() {
    if (!mqttClient.connected()) return;

    static char message[128];
    snprintf(message, sizeof(message),
            "{\"U\":%.1f,\"T\":%.1f,\"pH\":%.1f,\"P\":%d,\"K\":%d,\"IRR\":%d}",
            sysData.umidade, sysData.temperatura, sysData.pHLevel,
            sysData.flags.nutrientP, sysData.flags.nutrientK, sysData.flags.releState);

    if (mqttClient.publish(MQTT_TOPIC, message)) {
        Serial.println(F("Dados publicados"));
    }
}

// Função para atualização do LCD
void updateDisplay() {
    lcd.clear();
    
    // Linha 1: Umidade e Temperatura
    lcd.setCursor(0, 0);
    lcd.print(F("U:"));
    lcd.print(sysData.umidade, 1);
    lcd.print(F("% T:"));
    lcd.print(sysData.temperatura, 1);
    lcd.print(F("C"));
    
    // Linha 2: pH e Status
    lcd.setCursor(0, 1);
    lcd.print(F("pH:"));
    lcd.print(sysData.pHLevel, 1);
    lcd.print(F(" "));
    
    if (sysData.flags.nutrientP) lcd.print(F("P "));
    if (sysData.flags.nutrientK) lcd.print(F("K "));
    if (sysData.flags.releState) lcd.print(F("I"));
}

// Função para Serial Plotter
void updatePlotter() {
    Serial.print(F("Umidade:"));
    Serial.print(sysData.umidade);
    Serial.print(F(",Temperatura:"));
    Serial.print(sysData.temperatura);
    Serial.print(F(",pH:"));
    Serial.println(sysData.pHLevel);
}

// Função para leitura de sensores
void readSensors() {
    sysData.umidade = dht.readHumidity();
    sysData.temperatura = dht.readTemperature();
    
    if (!isnan(sysData.umidade) && !isnan(sysData.temperatura)) {
        uint16_t ldrValue = analogRead(LDRPIN);
        sysData.pHLevel = (map(ldrValue, 4063, 32, 0, 1400) / 100.0);
        
        sysData.flags.releState = (sysData.umidade < UMIDADE_MIN || 
                                 sysData.temperatura > TEMP_MAX || 
                                 sysData.pHLevel < PH_MIN || 
                                 sysData.pHLevel > PH_MAX || 
                                 sysData.flags.nutrientP || 
                                 sysData.flags.nutrientK);
        
        digitalWrite(RELE_PIN, sysData.flags.releState);
        digitalWrite(LED_RELE, sysData.flags.releState);
    }
}

// Função para verificar botões
void checkButtons() {
    if (digitalRead(BP_PIN_P) == LOW) {
        delay(50);
        if (digitalRead(BP_PIN_P) == LOW) {
            sysData.flags.nutrientP = !sysData.flags.nutrientP;
            sysData.flags.led_P = sysData.flags.nutrientP;
            digitalWrite(LED_P, sysData.flags.led_P);
        }
    }

    if (digitalRead(BP_PIN_K) == LOW) {
        delay(50);
        if (digitalRead(BP_PIN_K) == LOW) {
            sysData.flags.nutrientK = !sysData.flags.nutrientK;
            sysData.flags.led_K = sysData.flags.nutrientK;
            digitalWrite(LED_K, sysData.flags.led_K);
        }
    }
}

// Configuração inicial
void setup() {
    Serial.begin(115200);
    
    // Configuração de pinos
    pinMode(BP_PIN_P, INPUT_PULLUP);
    pinMode(BP_PIN_K, INPUT_PULLUP);
    pinMode(LED_P, OUTPUT);
    pinMode(LED_K, OUTPUT);
    pinMode(LED_RELE, OUTPUT);
    pinMode(RELE_PIN, OUTPUT);
    
    setupLCD();           // Inicializa LCD
    dht.begin();         // Inicializa DHT
    setup_wifi();        // Configura WiFi
    mqttClient.setServer(MQTT_SERVER, 1883);  // Configura servidor MQTT
    
    // Estado inicial dos LEDs
    digitalWrite(LED_P, LOW);
    digitalWrite(LED_K, LOW);
    digitalWrite(LED_RELE, LOW);
    digitalWrite(RELE_PIN, LOW);
}

// Loop principal
void loop() {
    // Verifica conexões
    if (!mqttClient.connected()) {
        reconnect();
    }
    mqttClient.loop();

    // Atualiza estado do sistema
    checkButtons();
    readSensors();

    // Atualiza displays e publica dados
    unsigned long currentMillis = millis();
    if (currentMillis - lastUpdate >= DISPLAY_INTERVAL) {
        updateDisplay();
        updatePlotter();
        publishData();
        lastUpdate = currentMillis;
    }

    delay(100);
}