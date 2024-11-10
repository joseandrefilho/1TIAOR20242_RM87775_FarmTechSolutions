# FIAP - Faculdade de Informática e Administração Paulista

<p align="center">
<a href= "https://www.fiap.com.br/"><img src="../assets/logo-fiap.png" alt="FIAP - Faculdade de Informática e Admnistração Paulista" border="0" width=40% height=40%></a>
</p>

<br>

# Sistema Inteligente de Monitoramento Agrícola com ESP32

## Integrantes: 
- <a href="https://www.linkedin.com/in/joseandrefilho">Jose Andre Filho</a>

## Professores:
### Tutor(a) 
- <a href="https://www.linkedin.com/in/lucas-gomes-moreira-15a8452a/">Lucas Gomes Moreira</a>
### Coordenador(a)
- <a href="https://www.linkedin.com/in/profandregodoi/">André Godoi Chiovato</a>

## Objetivo do Projeto

Este projeto visa criar um sistema inteligente de monitoramento agrícola utilizando o microcontrolador ESP32 e sensores para coletar dados ambientais e automatizar a irrigação baseado na cultura de cana-de-açúcar. O sistema integra as variáveis de temperatura, umidade, luminosidade e nível de água no reservatório para tomar decisões automatizadas, garantindo eficiência no uso de água e melhor desenvolvimento da planta.

O sistema também incorpora uma lógica de segurança, onde a irrigação é interrompida caso o sensor PIR detecte movimento de pessoas ou animais.

## Estrutura do Repositório

```plaintext
/
├── assets/
│   ├── logo-fiap.png           # Logo da FIAP
├── docs/
│   ├── README.md               # Documentação detalhada do projeto
│   ├── circuito_diagrama.png   # Diagrama do circuito utilizado
├── src/
│   ├── sketch.ino              # Código-fonte principal
│   ├── diagram.json            # Arquivo JSON que representa o diagrama do circuito
├── tests/
│   └── README.md               # Documentação dos testes dos sensores e funções do projeto
│   └── *.png                   # Prints dos testes dos sensores e funções do projeto utilizados no README
├── README.md                   # Este arquivo
```

## Funcionalidades

1. **Monitoramento climático**: O sensor DHT22 mede constantemente a temperatura e umidade do ambiente, ajustando a irrigação de acordo com os níveis ideais baseado na cultura de cana-de-açúcar.
   
2. **Controle de irrigação automatizada**: O sensor HC-SR04 verifica o nível de água no reservatório e garante que a irrigação só seja ativada quando há água suficiente disponível para o tipo de irrigação necessário (leve, moderada ou intensiva).

3. **Detecção de presença**: O sensor PIR detecta a presença de intrusos (humanos ou animais) e bloqueia a ativação da irrigação por motivos de segurança.

4. **Ajuste de irrigação com base na luminosidade**: O sensor LDR ajusta a quantidade de água utilizada na irrigação, aumentando-a em dias ensolarados e reduzindo-a em dias nublados, para garantir eficiência no uso de água.

## Desenho do Circuito Completo

O projeto utiliza o ESP32 como microcontrolador e é conectado aos seguintes sensores:

1. **DHT22 (Temperatura e Umidade):** Conectado ao GPIO 4.
2. **HC-SR04 (Nível de Água):** Trigger no GPIO 5 e Echo no GPIO 18.
3. **PIR (Movimento):** Conectado ao GPIO 14.
4. **LDR (Luminosidade):** Conectado ao GPIO 32 (entrada analógica).

### Diagrama do Circuito

Inclua o diagrama abaixo para conectar corretamente os sensores ao ESP32.

![Diagrama do Circuito](circuito_diagrama.png)

## Como Configurar e Rodar o Projeto no Wokwi e ESP32

### No Wokwi

1. Acesse o [Wokwi.com](https://wokwi.com/).
2. Monte o circuito conforme o diagrama e insira o código-fonte disponível na pasta `/src`.
3. Utilize o ESP32 como microcontrolador na simulação.
4. Verifique os dados dos sensores no Monitor Serial do Wokwi para garantir que o sistema está funcionando corretamente.

### Simulação no Wokwi

Você pode visualizar e interagir com a simulação do projeto no Wokwi clicando no link abaixo:

[![Simulação no Wokwi](circuito_diagrama.png)](https://wokwi.com/projects/413777804461865985)

Clique na imagem acima ou [aqui](https://wokwi.com/projects/413777804461865985) para acessar a simulação.

### No ESP32

1. Abra a **IDE Arduino**.
2. Instale as bibliotecas necessárias:
   - `DHT sensor library` para o sensor DHT22.
   - `Ultrasonic` para o sensor HC-SR04.
3. Conecte o ESP32 ao computador via USB e faça o upload do código.
4. Abra o Monitor Serial na IDE para acompanhar as leituras dos sensores em tempo real.

## Instruções de Instalação e Dependências

- **Bibliotecas necessárias:** `DHT sensor library`, `Ultrasonic` (instaláveis via IDE Arduino).
- **Plataforma:** Wokwi.com ou IDE Arduino para simulações e deploy no ESP32.
- **Hardware:** ESP32, DHT22, HC-SR04, PIR, LDR.

## Contribuição e Versionamento

- **Branch principal:** `main`.
- **Branch de desenvolvimento:** `develop`.
- Os Pull Requests devem ser criados a partir da branch `develop` e revisados por antes de serem fundidos à `main`.
