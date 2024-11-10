from db.connection import DBConnection

class Cultura:
    def __init__(self, cd_cultura, nm_cultura, dt_plantio, vl_area_cultivo):
        self.cd_cultura = cd_cultura
        self.nm_cultura = nm_cultura
        self.dt_plantio = dt_plantio
        self.vl_area_cultivo = vl_area_cultivo

    @classmethod
    def read_all(cls):
        with DBConnection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM t_ssa_cultura")
            rows = cursor.fetchall()
            return [cls(*row) for row in rows]
    
    @classmethod
    def read_by_nm_cultura(cls, nm_cultura):
        with DBConnection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM t_ssa_cultura WHERE nm_cultura = :nm_cultura", [nm_cultura])
            row = cursor.fetchone()
            return cls(*row) if row else None