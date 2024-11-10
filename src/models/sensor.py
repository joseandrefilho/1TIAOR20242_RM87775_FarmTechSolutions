from db.connection import DBConnection
from typing import List, Optional

class Sensor:
    def __init__(self, cd_sensor: int, nm_sensor: str, ds_tipo_sensor: str, vl_latitude_sensor: float, vl_longitude_sensor: float, cd_cultura: int):
        self.cd_sensor = cd_sensor
        self.nm_sensor = nm_sensor
        self.ds_tipo_sensor = ds_tipo_sensor
        self.vl_latitude_sensor = vl_latitude_sensor
        self.vl_longitude_sensor = vl_longitude_sensor
        self.cd_cultura = cd_cultura

    @classmethod
    def read_all(cls) -> List['Sensor']:
        with DBConnection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT cd_sensor, nm_sensor, ds_tipo_sensor, vl_latitude_sensor, vl_longitude_sensor, cd_cultura FROM t_ssa_sensor")
            rows = cursor.fetchall()
            return [cls(*row) for row in rows]

    @classmethod
    def read_by_id(cls, cd_sensor: int) -> Optional['Sensor']:
        with DBConnection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT cd_sensor, nm_sensor, ds_tipo_sensor, vl_latitude_sensor, vl_longitude_sensor, cd_cultura FROM t_ssa_sensor WHERE cd_sensor = :cd_sensor", [cd_sensor])
            row = cursor.fetchone()
            return cls(*row) if row else None
    
    @classmethod
    def get_by_name(cls, nm_sensor: str) -> Optional['Sensor']:
        with DBConnection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT cd_sensor, nm_sensor, ds_tipo_sensor, vl_latitude_sensor, vl_longitude_sensor, cd_cultura FROM t_ssa_sensor WHERE nm_sensor = :nm_sensor", [nm_sensor])
            row = cursor.fetchone()
            return cls(*row) if row else None