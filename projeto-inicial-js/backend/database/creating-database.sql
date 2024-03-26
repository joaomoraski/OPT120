CREATE DATABASE IF NOT EXISTS opt120;

USE opt120;

CREATE TABLE IF NOT EXISTS usuario
(
    id       INT AUTO_INCREMENT NOT NULL,
    nome     VARCHAR(100)       NOT NULL,
    email    VARCHAR(100)       NOT NULL,
    password VARCHAR(255)       NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS atividade
(
    id         INT AUTO_INCREMENT NOT NULL,
    titulo     VARCHAR(100)       NOT NULL,
    descricao  VARCHAR(255)       NOT NULL,
    nota       double             NOT NULL,
    dataLimite datetime           NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS usuario_atividade
(
    id         INT AUTO_INCREMENT,
    usuario_id INT      NOT NULL,
    atividade_id INT      NOT NULL,
    entrega    DATETIME NOT NULL,
    nota       DOUBLE   NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_usuario_id_usuario FOREIGN KEY (usuario_id) REFERENCES usuario (id),
    CONSTRAINT fk_atividade_id_atividade FOREIGN KEY (atividade_id) REFERENCES atividade (id)
);