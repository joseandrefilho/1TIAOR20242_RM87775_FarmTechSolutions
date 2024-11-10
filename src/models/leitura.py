from db.connection import DBConnection
from typing import Optional

class Leitura:
    def __init__(self, cd_leitura: int, dt_leitura: str, vl_valor_leitura: float, cd_sensor: int):
        self.cd_leitura = cd_leitura
        self.dt_leitura = dt_leitura
        self.vl_valor_leitura = vl_valor_leitura
        self.cd_sensor = cd_sensor

    @classmethod
    def create(cls, cd_sensor: int, vl_valor_leitura: float) -> Optional['Leitura']:
        with DBConnection() as conn:
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO t_ssa_leitura (cd_leitura, dt_leitura, vl_valor_leitura, cd_sensor)
                VALUES (t_leitura_cd_leitura_seq.nextval, CURRENT_TIMESTAMP, :vl_valor_leitura, :cd_sensor)
            """, [vl_valor_leitura, cd_sensor])
            conn.commit()
            
            # Recupera o ID da leitura recém-criada
            cursor.execute("SELECT t_leitura_cd_leitura_seq.currval FROM dual")
            cd_leitura = cursor.fetchone()[0]
            
            # Recupera a data e hora da leitura recém-criada
            cursor.execute("SELECT dt_leitura FROM t_ssa_leitura WHERE cd_leitura = :cd_leitura", [cd_leitura])
            dt_leitura = cursor.fetchone()[0]
            
            return cls(cd_leitura, dt_leitura, vl_valor_leitura, cd_sensor)
