from db.connection import DBConnection
from typing import Optional

class Irrigacao:
    def __init__(self, cd_irrigacao: int, dt_irrigacao: str, vl_quantidade_agua_aplicada: float, cd_cultura: int):
        self.cd_irrigacao = cd_irrigacao
        self.dt_irrigacao = dt_irrigacao
        self.vl_quantidade_agua_aplicada = vl_quantidade_agua_aplicada
        self.cd_cultura = cd_cultura

    @classmethod
    def create(cls, cd_cultura: int, vl_quantidade_agua_aplicada: float) -> Optional['Irrigacao']:
        with DBConnection() as conn:
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO t_ssa_irrigacao (cd_irrigacao, dt_irrigacao, vl_quantidade_agua_aplicada, cd_cultura)
                VALUES (t_irrigacao_cd_irrigacao_seq.nextval, CURRENT_TIMESTAMP, :vl_quantidade_agua_aplicada, :cd_cultura)
            """, [vl_quantidade_agua_aplicada, cd_cultura])
            conn.commit()
            
            # Recupera o ID da irrigação recém-criada
            cursor.execute("SELECT t_irrigacao_cd_irrigacao_seq.currval FROM dual")
            cd_irrigacao = cursor.fetchone()[0]
            
            # Recupera a data e hora da irrigação recém-criada
            cursor.execute("SELECT dt_irrigacao FROM t_ssa_irrigacao WHERE cd_irrigacao = :cd_irrigacao", [cd_irrigacao])
            dt_irrigacao = cursor.fetchone()[0]
            
            return cls(cd_irrigacao, dt_irrigacao, vl_quantidade_agua_aplicada, cd_cultura)