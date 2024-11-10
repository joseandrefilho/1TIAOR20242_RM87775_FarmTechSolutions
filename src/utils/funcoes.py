import json
from models import sensor, irrigacao, leitura, cultura

class Funcoes:
    def __init__(self, umidadeSolo: float, temperatura: float, pH: float, nutrienteP: bool, nutrienteK: bool, irrigacao: float):
        self.umidadeSolo = umidadeSolo
        self.temperatura = temperatura
        self.pH = pH
        self.nutrienteP = nutrienteP
        self.nutrienteK = nutrienteK
        self.irrigacao = irrigacao
        
    def save(self):
        # Percorre as propriedades do objeto Funcoes
        for key, value in self.__dict__.items():
            print(f"Salvando {key}: {value}")

            if key == "irrigacao":
                if value == 0:
                    print("Irrigação não realizada.")
                    continue

                try:
                    #buscar cultura
                    culturaFinded = cultura.Cultura.read_by_nm_cultura("Cana-de-Açúcar")

                    if culturaFinded is None:
                        print("Cultura não encontrada.")
                        continue

                    # Cria um objeto Irrigacao
                    irrigacaoCreated = irrigacao.Irrigacao.create(cd_cultura=culturaFinded.cd_cultura, vl_quantidade_agua_aplicada=value)
                    if irrigacaoCreated:
                        print(f"Irrigação realizada com sucesso: {value}mm")
                        
                except Exception as e:
                    print(f"Erro ao criar irrigação: {e}")

            else:
                try:
                    # Busca o sensor pelo nome da propriedade
                    sensorFinded = sensor.Sensor.get_by_name(key)
                    
                    # Se o sensor não existir, pula para a próxima propriedade
                    if sensorFinded is None:
                        print(f"Sensor {key} não encontrado.")
                        continue

                    # Cria um objeto Leitura
                    leituraCreated = leitura.Leitura.create(cd_sensor=sensorFinded.cd_sensor, vl_valor_leitura=value)
                    if leituraCreated:
                        print(f"Leitura de {key} salva com sucesso: {value}")
                        
                except Exception as e:
                    print(f"Erro ao criar leitura para {key}: {e}")