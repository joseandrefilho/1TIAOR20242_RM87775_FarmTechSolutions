from db.connection import DBConnection

class Alerta:
    def __init__(self, cd_alerta, ds_tipo, dt_alerta, cd_sensor):
        self.cd_alerta = cd_alerta
        self.ds_tipo = ds_tipo
        self.dt_alerta = dt_alerta
        self.cd_sensor = cd_sensor

    @classmethod
    def create(cls, cd_alerta, ds_tipo, cd_sensor):
        with DBConnection() as conn:
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO t_alertas (cd_alerta, ds_tipo, dt_alerta, cd_sensor)
                VALUES (:cd_alerta, :ds_tipo, CURRENT_TIMESTAMP, :cd_sensor)
            """, [cd_alerta, ds_tipo, cd_sensor])
            conn.commit()

    @classmethod
    def read_all(cls):
        with DBConnection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM t_alertas")
            rows = cursor.fetchall()
            return [cls(*row) for row in rows]
