-- Gerado por Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   em:        2024-11-10 10:59:02 BRT
--   site:      Oracle Database 11g
--   tipo:      Oracle Database 11g



DROP TABLE t_ssa_alertas CASCADE CONSTRAINTS;

DROP TABLE t_ssa_aplicacao CASCADE CONSTRAINTS;

DROP TABLE t_ssa_cultura CASCADE CONSTRAINTS;

DROP TABLE t_ssa_irrigacao CASCADE CONSTRAINTS;

DROP TABLE t_ssa_leitura CASCADE CONSTRAINTS;

DROP TABLE t_ssa_sensor CASCADE CONSTRAINTS;

DROP TABLE t_ssa_tipo_produto CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE t_ssa_alertas (
    cd_alerta INTEGER NOT NULL,
    ds_tipo   VARCHAR2(200 CHAR) NOT NULL,
    dt_alerta TIMESTAMP NOT NULL,
    cd_sensor INTEGER NOT NULL
);

COMMENT ON TABLE t_ssa_alertas IS
    'Armazena os alertas gerados com base nas leituras dos sensores.';

COMMENT ON COLUMN t_ssa_alertas.cd_alerta IS
    'Código único do alerta.';

COMMENT ON COLUMN t_ssa_alertas.ds_tipo IS
    'Tipo de alerta (umidade baixa, pH fora do normal).';

COMMENT ON COLUMN t_ssa_alertas.dt_alerta IS
    'Data e hora do alerta.';

COMMENT ON COLUMN t_ssa_alertas.cd_sensor IS
    'Referencia o sensor que gerou o alerta.';

ALTER TABLE t_ssa_alertas ADD CONSTRAINT pk_t_alertas PRIMARY KEY ( cd_alerta,
                                                                    cd_sensor );

CREATE TABLE t_ssa_aplicacao (
    cd_aplicacao           INTEGER NOT NULL,
    dt_aplicacao           DATE NOT NULL,
    vl_quantidade_aplicada NUMBER(10, 2) NOT NULL,
    cd_cultura             INTEGER NOT NULL,
    cd_tipo_produto        INTEGER NOT NULL
);

ALTER TABLE t_ssa_aplicacao ADD CHECK ( vl_quantidade_aplicada > 0 );

COMMENT ON TABLE t_ssa_aplicacao IS
    'Armazena informações sobre as aplicações de produtos nas culturas.';

COMMENT ON COLUMN t_ssa_aplicacao.cd_aplicacao IS
    'Código único da aplicação.';

COMMENT ON COLUMN t_ssa_aplicacao.dt_aplicacao IS
    'Data e hora da aplicação.';

COMMENT ON COLUMN t_ssa_aplicacao.vl_quantidade_aplicada IS
    'Quantidade aplicada.';

COMMENT ON COLUMN t_ssa_aplicacao.cd_cultura IS
    'Referencia a cultura que recebeu a aplicação.';

COMMENT ON COLUMN t_ssa_aplicacao.cd_tipo_produto IS
    'Referencia o tipo de produto aplicado.';

ALTER TABLE t_ssa_aplicacao ADD CONSTRAINT pk_t_aplicacao PRIMARY KEY ( cd_aplicacao,
                                                                        cd_tipo_produto );

CREATE TABLE t_ssa_cultura (
    cd_cultura      INTEGER NOT NULL,
    nm_cultura      VARCHAR2(100 CHAR) NOT NULL,
    dt_plantio      DATE,
    vl_area_cultivo NUMBER(10, 2) NOT NULL
);

ALTER TABLE t_ssa_cultura ADD CHECK ( vl_area_cultivo > 0 );

COMMENT ON TABLE t_ssa_cultura IS
    'Armazena informações sobre as culturas plantadas';

COMMENT ON COLUMN t_ssa_cultura.cd_cultura IS
    'Código único da cultura.';

COMMENT ON COLUMN t_ssa_cultura.nm_cultura IS
    'Nome da cultura.';

COMMENT ON COLUMN t_ssa_cultura.dt_plantio IS
    'Data de plantio da cultura.';

COMMENT ON COLUMN t_ssa_cultura.vl_area_cultivo IS
    'Área de cultivo.';

ALTER TABLE t_ssa_cultura ADD CONSTRAINT pk_t_cultura PRIMARY KEY ( cd_cultura );

ALTER TABLE t_ssa_cultura ADD CONSTRAINT un_t_cultura_nm_cultura UNIQUE ( nm_cultura );

CREATE TABLE t_ssa_irrigacao (
    cd_irrigacao                INTEGER NOT NULL,
    dt_irrigacao                TIMESTAMP NOT NULL,
    vl_quantidade_agua_aplicada NUMBER(10, 2) NOT NULL,
    cd_cultura                  INTEGER NOT NULL
);

ALTER TABLE t_ssa_irrigacao ADD CHECK ( vl_quantidade_agua_aplicada > 0 );

COMMENT ON TABLE t_ssa_irrigacao IS
    'Armazena os eventos de irrigação das culturas.';

COMMENT ON COLUMN t_ssa_irrigacao.cd_irrigacao IS
    'Código único da irrigação.';

COMMENT ON COLUMN t_ssa_irrigacao.dt_irrigacao IS
    'Data e hora da irrigação.';

COMMENT ON COLUMN t_ssa_irrigacao.vl_quantidade_agua_aplicada IS
    'Quantidade de água aplicada.';

COMMENT ON COLUMN t_ssa_irrigacao.cd_cultura IS
    'Referencia a cultura irrigada.';

ALTER TABLE t_ssa_irrigacao ADD CONSTRAINT pk_t_irrigacao PRIMARY KEY ( cd_irrigacao );

CREATE TABLE t_ssa_leitura (
    cd_leitura       INTEGER NOT NULL,
    dt_leitura       TIMESTAMP DEFAULT current_timestamp NOT NULL,
    vl_valor_leitura NUMBER(10, 2) NOT NULL,
    cd_sensor        INTEGER NOT NULL
);

COMMENT ON TABLE t_ssa_leitura IS
    'Armazena as leituras realizadas pelos sensores.';

COMMENT ON COLUMN t_ssa_leitura.cd_leitura IS
    'Código único da leitura.';

COMMENT ON COLUMN t_ssa_leitura.dt_leitura IS
    'Data e hora da leitura.';

COMMENT ON COLUMN t_ssa_leitura.vl_valor_leitura IS
    'Valor da leitura (umidade, pH, nutrientes).';

COMMENT ON COLUMN t_ssa_leitura.cd_sensor IS
    'Referencia o sensor que realizou a leitura.';

ALTER TABLE t_ssa_leitura ADD CONSTRAINT pk_t_leitura PRIMARY KEY ( cd_leitura,
                                                                    cd_sensor );

CREATE TABLE t_ssa_sensor (
    cd_sensor           INTEGER NOT NULL,
    nm_sensor           VARCHAR2(50 CHAR) NOT NULL,
    ds_tipo_sensor      VARCHAR2(50 CHAR) NOT NULL,
    vl_latitude_sensor  NUMBER(9, 6) NOT NULL,
    vl_longitude_sensor NUMBER(9, 6) NOT NULL,
    cd_cultura          INTEGER NOT NULL
);

COMMENT ON TABLE t_ssa_sensor IS
    'Armazena informações sobre os sensores utilizados para monitoramento das condições do solo.';

COMMENT ON COLUMN t_ssa_sensor.cd_sensor IS
    'Código único do sensor.';

COMMENT ON COLUMN t_ssa_sensor.nm_sensor IS
    'Nome do sensor (umidade, pH, nutrientes).';

COMMENT ON COLUMN t_ssa_sensor.ds_tipo_sensor IS
    'Tipo do sensor (umidade, pH, nutrientes).';

COMMENT ON COLUMN t_ssa_sensor.vl_latitude_sensor IS
    'Latitude da localização do sensor.';

COMMENT ON COLUMN t_ssa_sensor.vl_longitude_sensor IS
    'Longitude da localização do sensor.';

COMMENT ON COLUMN t_ssa_sensor.cd_cultura IS
    'Referencia a cultura monitorada pelo sensor.';

ALTER TABLE t_ssa_sensor ADD CONSTRAINT pk_t_sensor PRIMARY KEY ( cd_sensor );

ALTER TABLE t_ssa_sensor ADD CONSTRAINT un_t_sensor_nm_sensor UNIQUE ( nm_sensor );

CREATE TABLE t_ssa_tipo_produto (
    cd_tipo_produto   INTEGER NOT NULL,
    nm_tipo_produto   VARCHAR2(100 CHAR) NOT NULL,
    nm_unidade_medida VARCHAR2(20 CHAR) NOT NULL
);

COMMENT ON TABLE t_ssa_tipo_produto IS
    'Armazena os tipos de produtos aplicados nas culturas, como fertilizantes, pesticidas e água.';

COMMENT ON COLUMN t_ssa_tipo_produto.cd_tipo_produto IS
    'Código único do tipo de produto.';

COMMENT ON COLUMN t_ssa_tipo_produto.nm_tipo_produto IS
    'Descrição do tipo de produto.';

COMMENT ON COLUMN t_ssa_tipo_produto.nm_unidade_medida IS
    'Unidade de medida padrão (litros, quilos, etc.).';

ALTER TABLE t_ssa_tipo_produto ADD CONSTRAINT pk_t_tipo_produto PRIMARY KEY ( cd_tipo_produto );

ALTER TABLE t_ssa_alertas
    ADD CONSTRAINT fk_t_alertas_t_sensor FOREIGN KEY ( cd_sensor )
        REFERENCES t_ssa_sensor ( cd_sensor );

ALTER TABLE t_ssa_aplicacao
    ADD CONSTRAINT fk_t_aplicacao_t_cultura FOREIGN KEY ( cd_cultura )
        REFERENCES t_ssa_cultura ( cd_cultura );

ALTER TABLE t_ssa_aplicacao
    ADD CONSTRAINT fk_t_aplicacao_t_tipo_produto FOREIGN KEY ( cd_tipo_produto )
        REFERENCES t_ssa_tipo_produto ( cd_tipo_produto );

ALTER TABLE t_ssa_irrigacao
    ADD CONSTRAINT fk_t_irrigacao_t_cultura FOREIGN KEY ( cd_cultura )
        REFERENCES t_ssa_cultura ( cd_cultura );

ALTER TABLE t_ssa_leitura
    ADD CONSTRAINT fk_t_leitura_t_sensor FOREIGN KEY ( cd_sensor )
        REFERENCES t_ssa_sensor ( cd_sensor );

ALTER TABLE t_ssa_sensor
    ADD CONSTRAINT fk_t_sensor_t_cultura FOREIGN KEY ( cd_cultura )
        REFERENCES t_ssa_cultura ( cd_cultura );

CREATE SEQUENCE t_alertas_cd_alerta_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER t_alertas_cd_alerta_trg BEFORE
    INSERT ON t_ssa_alertas
    FOR EACH ROW
    WHEN ( new.cd_alerta IS NULL )
BEGIN
    :new.cd_alerta := t_alertas_cd_alerta_seq.nextval;
END;
/

CREATE SEQUENCE t_aplicacao_cd_aplicacao_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER t_aplicacao_cd_aplicacao_trg BEFORE
    INSERT ON t_ssa_aplicacao
    FOR EACH ROW
    WHEN ( new.cd_aplicacao IS NULL )
BEGIN
    :new.cd_aplicacao := t_aplicacao_cd_aplicacao_seq.nextval;
END;
/

CREATE SEQUENCE t_cultura_cd_cultura_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER t_cultura_cd_cultura_trg BEFORE
    INSERT ON t_ssa_cultura
    FOR EACH ROW
    WHEN ( new.cd_cultura IS NULL )
BEGIN
    :new.cd_cultura := t_cultura_cd_cultura_seq.nextval;
END;
/

CREATE SEQUENCE t_irrigacao_cd_irrigacao_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER t_irrigacao_cd_irrigacao_trg BEFORE
    INSERT ON t_ssa_irrigacao
    FOR EACH ROW
    WHEN ( new.cd_irrigacao IS NULL )
BEGIN
    :new.cd_irrigacao := t_irrigacao_cd_irrigacao_seq.nextval;
END;
/

CREATE SEQUENCE t_leitura_cd_leitura_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER t_leitura_cd_leitura_trg BEFORE
    INSERT ON t_ssa_leitura
    FOR EACH ROW
    WHEN ( new.cd_leitura IS NULL )
BEGIN
    :new.cd_leitura := t_leitura_cd_leitura_seq.nextval;
END;
/

CREATE SEQUENCE t_sensor_cd_sensor_seq START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER t_sensor_cd_sensor_trg BEFORE
    INSERT ON t_ssa_sensor
    FOR EACH ROW
    WHEN ( new.cd_sensor IS NULL )
BEGIN
    :new.cd_sensor := t_sensor_cd_sensor_seq.nextval;
END;
/

CREATE SEQUENCE t_tipo_produto_cd_tipo_produto START WITH 1 NOCACHE ORDER;

CREATE OR REPLACE TRIGGER t_tipo_produto_cd_tipo_produto BEFORE
    INSERT ON t_ssa_tipo_produto
    FOR EACH ROW
    WHEN ( new.cd_tipo_produto IS NULL )
BEGIN
    :new.cd_tipo_produto := t_tipo_produto_cd_tipo_produto.nextval;
END;
/



-- Relatório do Resumo do Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             7
-- CREATE INDEX                             0
-- ALTER TABLE                             18
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           7
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          7
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
