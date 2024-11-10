-- Dados de exemplo para a tabela t_cultura
INSERT INTO t_ssa_cultura (cd_cultura, nm_cultura, dt_plantio, vl_area_cultivo)
VALUES (t_cultura_cd_cultura_seq.nextval, 'Cana-de-Açúcar', TO_DATE('2024-03-01', 'YYYY-MM-DD'), 150.0);

-- Dados de exemplo para a tabela t_tipo_produto
INSERT INTO t_ssa_tipo_produto (cd_tipo_produto, nm_tipo_produto, nm_unidade_medida)
VALUES (t_tipo_produto_cd_tipo_produto.nextval, 'Nutriente P', 'mg/L');

INSERT INTO t_ssa_tipo_produto (cd_tipo_produto, nm_tipo_produto, nm_unidade_medida)
VALUES (t_tipo_produto_cd_tipo_produto.nextval, 'Nutriente K', 'mg/L');

INSERT INTO t_ssa_tipo_produto (cd_tipo_produto, nm_tipo_produto, nm_unidade_medida)
VALUES (t_tipo_produto_cd_tipo_produto.nextval, 'PH', 'pH');

INSERT INTO t_ssa_tipo_produto (cd_tipo_produto, nm_tipo_produto, nm_unidade_medida)
VALUES (t_tipo_produto_cd_tipo_produto.nextval, 'Umidade do Solo', '%');

-- Dados de exemplo para a tabela t_sensor
INSERT INTO t_ssa_sensor (cd_sensor, cd_cultura, ds_tipo_sensor, nm_sensor, vl_latitude_sensor, vl_longitude_sensor)
VALUES (t_sensor_cd_sensor_seq.nextval, 1, 'Sensor de Nutriente P', 'nutrienteP', -22.90556, -47.06083);

INSERT INTO t_ssa_sensor (cd_sensor, cd_cultura, ds_tipo_sensor, nm_sensor, vl_latitude_sensor, vl_longitude_sensor)
VALUES (t_sensor_cd_sensor_seq.nextval, 1, 'Sensor de Nutriente K', 'nutrienteK', -22.90557, -47.06084);

INSERT INTO t_ssa_sensor (cd_sensor, cd_cultura, ds_tipo_sensor, nm_sensor, vl_latitude_sensor, vl_longitude_sensor)
VALUES (t_sensor_cd_sensor_seq.nextval, 1, 'Sensor de PH', 'pH', -22.90558, -47.06085);

INSERT INTO t_ssa_sensor (cd_sensor, cd_cultura, ds_tipo_sensor, nm_sensor, vl_latitude_sensor, vl_longitude_sensor)
VALUES (t_sensor_cd_sensor_seq.nextval, 1, 'Sensor de Umidade do Solo', 'umidadeSolo', -22.90559, -47.06086);

INSERT INTO t_ssa_sensor (cd_sensor, cd_cultura, ds_tipo_sensor, nm_sensor, vl_latitude_sensor, vl_longitude_sensor)
VALUES (t_sensor_cd_sensor_seq.nextval, 1, 'Sensor de Temperatura', 'temperatura', -22.90560, -47.06087);

COMMIT;