# FIAP - Faculdade de Informática e Administração Paulista

<p align="center">
<a href= "https://www.fiap.com.br/"><img src="assets/logo-fiap.png" alt="FIAP - Faculdade de Informática e Administração Paulista" border="0" width=40% height=40%></a>
</p>

<br>

# Sistema de Sensoriamento Agrícola - FarmTech Solutions

## Integrantes: 
- <a href="https://www.linkedin.com/in/joseandrefilho">Jose Andre Filho</a>

## Professores:
### Tutor 
- <a href="https://www.linkedin.com/in/lucas-gomes-moreira-15a8452a/">Lucas Gomes Moreira</a>
### Coordenador
- <a href="https://www.linkedin.com/in/profandregodoi/">André Godoi Chiovato</a>

# Diretório `src` - Sistema de Sensoriamento Agrícola

Este diretório contém os principais módulos e código-fonte do sistema de sensoriamento agrícola **FarmTech Solutions**. Ele é responsável por conectar-se ao broker MQTT para receber dados dos sensores, realizar operações no banco de dados Oracle, e gerenciar a lógica principal de controle e monitoramento.

## Estrutura do Diretório

- **main.py**: Arquivo principal que inicializa o cliente MQTT e conecta o sistema.
- **db/**: Contém o código de conexão com o banco de dados Oracle.
  - `connection.py`: Configura e gerencia a conexão com o banco de dados usando o Oracle.
- **mqtt/**: Módulo para configuração e operação do cliente MQTT.
  - `client.py`: Configura o cliente MQTT, se conecta ao broker e processa mensagens dos sensores.
- **models/**: Contém as classes que representam as entidades principais do banco de dados.
  - `cultura.py`, `irrigacao.py`, `leitura.py`, `sensor.py`: Cada arquivo representa uma entidade e inclui métodos CRUD para manipulação de dados.
- **utils/**: Contém funções utilitárias e de suporte para o sistema.
  - `funcoes.py`: Funções para processamento e validação de dados recebidos dos sensores.

## Descrição dos Módulos

### main.py
Arquivo principal para execução do sistema. Ao rodar este arquivo, ele inicializa o cliente MQTT e mantém a escuta ativa para receber e processar dados dos sensores.

### db/connection.py
Gerencia a conexão com o banco de dados Oracle utilizando variáveis de ambiente configuradas no arquivo `.env`. O método de conexão é configurado para ser seguro e facilitar o acesso aos dados.

### mqtt/client.py
Configura o cliente MQTT e define a lógica de processamento das mensagens recebidas. Este módulo:
- Conecta ao broker MQTT especificado.
- Recebe dados JSON dos sensores, que incluem leituras de umidade, temperatura, pH, nutrientes e status da irrigação.
- Chama `funcoes.py` para salvar esses dados no banco.

### models/
Implementa classes para cada entidade no sistema:
- `Alerta`: Registra alertas críticos com base nos valores dos sensores.
- `Cultura`: Representa as culturas agrícolas e gerencia as operações relacionadas.
- `Irrigacao`: Registra eventos de irrigação aplicados às culturas.
- `Leitura`: Armazena leituras de dados dos sensores.
- `Sensor`: Cadastro e localização dos sensores.

Cada classe contém métodos para criar, ler, atualizar e deletar (CRUD) registros.

### utils/funcoes.py
Contém a classe `Funcoes`, responsável por processar e salvar as leituras dos sensores. Funções principais incluem:
- Verificação e validação dos dados recebidos.
- Inserção de dados relevantes no banco de dados Oracle.

## Configuração e Execução

1. **Configurar as Variáveis de Ambiente**:
   - No arquivo `.env`, configure as variáveis `DB_USER`, `DB_PASSWORD`, e `DB_DSN` para conectar ao banco de dados Oracle.

2. **Executar o Sistema**:
   - Inicie o sistema executando o comando:
     ```bash
     python main.py
     ```
   - No Wokwi, inicie a simulação do circuito ESP32 para enviar dados para o sistema via MQTT.

3. **Monitorar os Dados**:
   - Acompanhe a recepção e processamento das leituras dos sensores no terminal.
   - Verifique os registros diretamente no banco de dados Oracle para confirmar as operações CRUD.

---

Esse diretório organiza e gerencia a lógica principal do sistema, facilitando a interação e o monitoramento das leituras dos sensores em tempo real, com persistência segura no banco de dados Oracle.

