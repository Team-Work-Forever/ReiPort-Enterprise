create database reiport;

CREATE TABLE Pais(
    codPais SERIAL NOT NULL,
    pais VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (codPais)
);

CREATE TABLE CodigoPostal(
    cPostal VARCHAR(8) NOT NULL,
    descCPostal VARCHAR(200) DEFAULT NULL,
    localidade VARCHAR(100) NOT NULL,
    codPais INT NOT NULL,
    PRIMARY KEY (cPostal),
    CONSTRAINT codPais_fk1
        FOREIGN KEY (codPais)
            REFERENCES Pais (codPais)
);

CREATE TABLE TipoUtilizador(
    idTipoUt SERIAL NOT NULL,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao VARCHAR(100) DEFAULT NULL,
    PRIMARY KEY (idTipoUt)
);


CREATE TABLE Utilizador(
    idUtilizador SERIAL NOT NULL,
    nomeIni VARCHAR(50) NOT NULL,
    nomeApelido VARCHAR(50) NOT NULL,
    dataNasc DATE NOT NULL,
    nif NUMERIC(9) NOT NULL UNIQUE,
    rua VARCHAR(100) NOT NULL,
    nPorta INT NOT NULL,
    dataElim DATE DEFAULT NULL,
    estaElim BOOLEAN NOT NULL DEFAULT FALSE,
    cPostal VARCHAR(8) NOT NULL,
    telefone NUMERIC(9) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    passwd VARCHAR(100) NOT NULL,
    idTipoUt INT NOT NULL,
    PRIMARY KEY (idUtilizador),
    CONSTRAINT codPostal_fk1
        FOREIGN KEY (cPostal)
            REFERENCES CodigoPostal (cPostal),
    CONSTRAINT idTipoUt_fk1
        FOREIGN KEY (idTipoUt)
            REFERENCES TipoUtilizador (idTipoUt)
);

CREATE TABLE Motorista(
    idMotorista INT NOT NULL,
    temADR BOOLEAN NOT NULL DEFAULT FALSE,
    temCam BOOLEAN NOT NULL DEFAULT FALSE,
    cartaoC NUMERIC(8) NOT NULL,
    estaTrabalhar BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (idMotorista),
    CONSTRAINT idMotorista_fk1
        FOREIGN KEY (idMotorista)
            REFERENCES Utilizador (idUtilizador)
);

CREATE TABLE Fatura(
    idFatura SERIAL NOT NULL,
    precoSIva NUMERIC(9,2) NOT NULL CHECK(precoSiva > 0),
    precoIva NUMERIC(9,2) NOT NULL CHECK(precoSiva > 0),
    dataEmissao DATE NOT NULl DEFAULT now(),
    dataPagam DATE DEFAULT NULL,
    PRIMARY KEY (idFatura)
);

CREATE TABLE Combustivel(
    idCombustivel SERIAL NOT NULL,
    nome VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (idCombustivel)
);

CREATE TABLE Marca(
    idMarca SERIAL NOT NULL,
    nome VARCHAR(50) NOT NULL UNIQUE,
    logotipo bytea DEFAULT NULL,
    PRIMARY KEY (idMarca)
);

CREATE TABLE Modelo(
    idModelo SERIAL NOT NULL,
    nome VARCHAR(50) NOT NULL UNIQUE,
    dataLanc DATE NOT NULL,
    idMarca INT NOT NULL,
    PRIMARY KEY (idModelo),
    CONSTRAINT idMarca_fk1
        FOREIGN KEY (idMarca)
            REFERENCES Marca (idMarca) 
);

CREATE TABLE Tipo(
    idTipo SERIAL NOT NULL,
    nome VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (idTipo)
);

CREATE TABLE Contentor(
    matriculaContentor VARCHAR(11) NOT NULL,
    largura NUMERIC(5,2) NOT NULL CHECK(largura > 0),
    comprimento NUMERIC(5,2) NOT NULL CHECK(comprimento > 0),
    profundidade NUMERIC(5,2) NOT NULL CHECK(profundidade > 0),
    cor VARCHAR(50) NOT NULL,
    pesoMaxSuport NUMERIC(9,2) NOT NULL CHECK(pesoMaxSuport > 0),
    estaUsado BOOLEAN NOT NULL DEFAULT FALSE,
    idModelo INT NOT NULL,
    idMarca INT NOT NULL,
    idTipo INT NOT NULL,
    PRIMARY KEY (matriculaContentor),
    CONSTRAINT idModelo_fk1
        FOREIGN KEY (idModelo)
            REFERENCES Modelo (idModelo),
    CONSTRAINT idMarca_fk2
        FOREIGN KEY (idMarca)
            REFERENCES Marca (idMarca),
    CONSTRAINT idTipo_fk3
        FOREIGN KEY (idTipo)
            REFERENCES Tipo (idTipo)
);

CREATE TABLE Veiculo(
    matricula VARCHAR(8) NOT NULL,
    potencia INT NOT NULL CHECK(potencia > 0),
    cilindrada INT NOT NULL CHECK(cilindrada > 0),
    tanque NUMERIC(5,2) NOT NULL CHECK(tanque > 0),
    cor VARCHAR(50) NOT NULL,
    pesoMaxSuport NUMERIC(9,2) NOT NULL CHECK(pesoMaxSuport > 0),
    estaUsado BOOLEAN NOT NULL DEFAULT FALSE,
    idMarca INT NOT NULL,
    idModelo INT NOT NULL,
    idCombustivel INT NOT NULL,
    PRIMARY KEY (matricula),
    CONSTRAINT idMarca_fk1
        FOREIGN KEY (idMarca)
            REFERENCES Marca (idMarca),
    CONSTRAINT idModelo_fk2
        FOREIGN KEY (idModelo)
            REFERENCES Modelo (idModelo),
    CONSTRAINT idCombustivel_fk3
        FOREIGN KEY (idCombustivel)
            REFERENCES Combustivel (idCombustivel)
);

CREATE TABLE Pedido(
    idPedido SERIAL NOT NULL,
    dispCamiao BOOLEAN NOT NULL DEFAULT FALSE,
    dispContentor BOOLEAN NOT NULL DEFAULT FALSE,
    pesoCarga NUMERIC(9,2) NOT NULL CHECK(pesoCarga > 0),
    dataLimite DATE NOT NULL,
    nPortaDest INT NOT NULL,
    cPostalDest VARCHAR(8) NOT NULL,
    ruaDest VARCHAR(100) NOT NULL,
    cPostalOri VARCHAR(8) NOT NULL,
    nPortaOri INT NOT NULL,
    ruaOri VARCHAR(100) NOT NULL,
    precoEntrega NUMERIC(9,2) NOT NULL CHECK(precoEntrega > 0),
    matriculaContentor VARCHAR(11) NOT NULL,
    matriculaSegContentor VARCHAR(11) DEFAULT NULL,
    matricula VARCHAR(8) NOT NULL,
    idCliente INT NOT NULL,
    idFatura INT NOT NULL,
    PRIMARY KEY (idPedido),
    CONSTRAINT cPostalDest_fk1
            FOREIGN KEY (cPostalDest)
                REFERENCES CodigoPostal (cPostal),
    CONSTRAINT cPostalOri_fk2
            FOREIGN KEY (cPostalOri)
                REFERENCES CodigoPostal (cPostal),
    CONSTRAINT matriculaContentor_fk3
            FOREIGN KEY (matriculaContentor)
                REFERENCES Contentor (matriculaContentor),
    CONSTRAINT matricula2Contentor_fk4
            FOREIGN KEY (matriculaSegContentor)
                REFERENCES Contentor (matriculaContentor),
    CONSTRAINT matriculaVeiculo_fk5
            FOREIGN KEY (matricula)
                REFERENCES Veiculo (matricula),
    CONSTRAINT idCliente_fk6
            FOREIGN KEY (idCliente)
                REFERENCES Utilizador (idUtilizador),
    CONSTRAINT idFatura_fk7
            FOREIGN KEY (idFatura)
                REFERENCES Fatura (idFatura)
);

CREATE TABLE GrupoMotorista(
    idPedido INT NOT NULL,
    idMotorista INT NOT NULL,
    quilometros NUMERIC(9,2) NOT NULL CHECK(quilometros > 0),
    tipo CHAR NOT NULL DEFAULT 'p',
    PRIMARY KEY (idPedido, idMotorista),
    CONSTRAINT idPedido_fk1
            FOREIGN KEY (idPedido)
                REFERENCES Pedido (idPedido),
    CONSTRAINT idMotorista_fk2
            FOREIGN KEY (idMotorista)
                REFERENCES Motorista (idMotorista)
);

CREATE TABLE Estado(
    idEstado SERIAL NOT NULL,
    nome VARCHAR(50) NOT NULL,
    PRIMARY KEY (idEstado)
);

CREATE TABLE HistoricoEstados(
    idHist SERIAL NOT NULL,
    dataInicioEstado DATE NOT NULL DEFAULT now(),
    idPedido INT NOT NULL,
    idEstado INT NOT NULL,
    idUtilizador INT NOT NULL,
    PRIMARY KEY (idHist),
    CONSTRAINT idPedido_fk1
            FOREIGN KEY (idPedido)
                REFERENCES Pedido (idPedido),
    CONSTRAINT idEstado_fk2
            FOREIGN KEY (idEstado)
                REFERENCES Estado (idEstado),
    CONSTRAINT idUtilizador_fk3
            FOREIGN KEY (idUtilizador)
                REFERENCES Utilizador (idUtilizador)
);


create unique index indexPedidos
on pedido (idPedido);

create unique index indexContentor
on contentor (matriculaContentor);

create unique index indexVeiculo
on veiculo (matricula);

create or replace function log_alterar_tipo_motorista()
  returns trigger
  language plpgsql
  as
$$
declare
    _motoristas int;
begin

    select count(*)
    from grupomotorista
    where idPedido = new.idPedido
    into _motoristas;

	if _motoristas > 1 then
        update grupomotorista
        set tipo = 'c'
        where idPedido = new.idPedido and idMotorista = new.idMotorista;
    else
        update grupomotorista
        set tipo = 'p'
        where idPedido = new.idPedido and idMotorista = new.idMotorista;
	end if;

	return new;
end;
$$;

create or replace trigger alterar_tipo_motorista
  after insert
  on grupomotorista
  for each ROW
  execute procedure log_alterar_tipo_motorista();

INSERT INTO pais (pais) VALUES ('Portugal');
INSERT INTO pais (pais) VALUES ('Austria');
INSERT INTO pais (pais) VALUES ('Belgica');
INSERT INTO pais (pais) VALUES ('Bulgaria');
INSERT INTO pais (pais) VALUES ('Chequia');
INSERT INTO pais (pais) VALUES ('Chipre');
INSERT INTO pais (pais) VALUES ('Croacia');
INSERT INTO pais (pais) VALUES ('Dinamarca');
INSERT INTO pais (pais) VALUES ('Eslovaquia');
INSERT INTO pais (pais) VALUES ('Eslovenia');
INSERT INTO pais (pais) VALUES ('Espanha');
INSERT INTO pais (pais) VALUES ('Estonia');
INSERT INTO pais (pais) VALUES ('Finlandia');
INSERT INTO pais (pais) VALUES ('Franca');
INSERT INTO pais (pais) VALUES ('Grecia');
INSERT INTO pais (pais) VALUES ('Hungria');
INSERT INTO pais (pais) VALUES ('Irlanda');
INSERT INTO pais (pais) VALUES ('Italia');
INSERT INTO pais (pais) VALUES ('Letonia');
INSERT INTO pais (pais) VALUES ('Lituania');
INSERT INTO pais (pais) VALUES ('Luxemburgo');
INSERT INTO pais (pais) VALUES ('Malta');
INSERT INTO pais (pais) VALUES ('Paises Baixos');
INSERT INTO pais (pais) VALUES ('Polonia');
INSERT INTO pais (pais) VALUES ('Alemanha');
INSERT INTO pais (pais) VALUES ('Romenia');
INSERT INTO pais (pais) VALUES ('Suecia');

INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('4490-666', 'Povoa de Varzim', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('1000-139', 'Lisboa', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('3360-139', 'Cantanhede', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('2205-025', 'Abrantes', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('4705-480', 'Braga', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('4905-067', 'Barcelos', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('3040-474', 'Coimbra', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('3360-032', 'Penacova', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('3420-177', 'Tabua', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('4200-014', 'Porto', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('4475-045', 'Maia', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('4795-894', 'Santo Tirso', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('4480-330', 'Vila do Conde', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('4900-281', 'Viana do Castelo', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('4940-027', 'Paredes de Coura', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('2645-539', 'Cascais', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('3520-039', 'Nelas', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('7150-123', 'Borba', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('2610-181', 'Amadora', 1);
INSERT INTO codigopostal (cPostal, localidade, codPais) VALUES ('4490-251', 'Povoa de Varzim', 1);

INSERT INTO tipoutilizador (nome) VALUES ('Cliente');
INSERT INTO tipoutilizador (nome) VALUES ('Rececionista');
INSERT INTO tipoutilizador (nome) VALUES ('Gestor');
INSERT INTO tipoutilizador (nome) VALUES ('Motorista');
INSERT INTO tipoutilizador (nome) VALUES ('Admin');

INSERT INTO utilizador (nomeIni, nomeApelido, dataNasc, nif, rua, nPorta, dataElim, estaElim, cPostal, telefone, email, passwd, idTipoUt) VALUES 
('Francisco', 'La Ventura', '1997-10-02', 940196036, 'Rua Ventura', 107, null, false, '4200-014', 914794541, 'franciscoventure@gmail.com', 'portomaior2', 1);
INSERT INTO utilizador (nomeIni, nomeApelido, dataNasc, nif, rua, nPorta, dataElim, estaElim, cPostal, telefone, email, passwd, idTipoUt) VALUES 
('Ricardo', 'Machado', '1991-06-15', 323316608, 'Rua Dr. Andre Tomas', 7, null, false, '3520-039', 961123321, 'ricardinho@gmail.com', 'ric4rde25', 4);
INSERT INTO utilizador (nomeIni, nomeApelido, dataNasc, nif, rua, nPorta, dataElim, estaElim, cPostal, telefone, email, passwd, idTipoUt) VALUES 
('Joao', 'Oliveira', '1968-08-14', 222837141, 'Avenida Nova Esperanca', 17, null, false, '4490-251', 931457891, 'oliveira@gmail.com', 'jonas?!100', 4);
INSERT INTO utilizador (nomeIni, nomeApelido, dataNasc, nif, rua, nPorta, dataElim, estaElim, cPostal, telefone, email, passwd, idTipoUt) VALUES 
('Sofia', 'Ferreira', '1990-06-27', 851642243, 'Rua Diogo Cao', 5, null, false, '4475-045', 914789123, 'sofiaferreira@gmail.com', 'sofiferr!?191', 3);
INSERT INTO utilizador (nomeIni, nomeApelido, dataNasc, nif, rua, nPorta, dataElim, estaElim, cPostal, telefone, email, passwd, idTipoUt) VALUES 
('Gabriel', 'Machado', '1972-07-20', 433492058, 'Rua da flor dourada', 45, null, false, '4900-281', 965741963, 'gabimachado@gmail.com', 'gabrielmachado101', 2);
INSERT INTO utilizador (nomeIni, nomeApelido, dataNasc, nif, rua, nPorta, dataElim, estaElim, cPostal, telefone, email, passwd, idTipoUt) VALUES 
('Rui', 'Alexandre', '1977-04-04', 243497058, 'Rua da alavanca', 106, null, false, '4900-281', 914651278, 'ruialex@gmail.com', 'supersecurepassword', 5);
INSERT INTO utilizador (nomeIni, nomeApelido, dataNasc, nif, rua, nPorta, dataElim, estaElim, cPostal, telefone, email, passwd, idTipoUt) VALUES 
('Joaquim', 'Silva', '2000-11-20', 123462731, 'Rua da Esperanca', 40, null, false, '4905-067', 934756280, 'joaquim@gmail.com', '?bl4sfemiafoicontada!#', 1);

INSERT INTO motorista (idmotorista, temADR, temCam, cartaoC, estaTrabalhar) VALUES (2, false, false, 78912345, false);
INSERT INTO motorista (idmotorista, temADR, temCam, cartaoC, estaTrabalhar) VALUES (3, true, true, 45612378, false);


INSERT INTO fatura(precoSIva, precoIva, dataPagam) VALUES (16260.16, 20000, null);
INSERT INTO fatura(precoSIva, precoIva, dataPagam) VALUES (32520.32, 40000, null);
INSERT INTO fatura(precoSIva, precoIva, dataPagam) VALUES (12195.12, 15000, null);
INSERT INTO fatura(precoSIva, precoIva, dataPagam) VALUES (37009.13, 45521.23, null);
INSERT INTO fatura(precoSIva, precoIva, dataPagam) VALUES (73170.73, 90000, null);

INSERT INTO combustivel (nome) VALUES ('Diesel');
INSERT INTO combustivel (nome) VALUES ('Gasolina');
INSERT INTO combustivel (nome) VALUES ('Eletrico');
INSERT INTO combustivel (nome) VALUES ('Gas');

INSERT INTO marca (nome) VALUES ('Iveco');
INSERT INTO marca (nome) VALUES ('Scania');
INSERT INTO marca (nome) VALUES ('Man');
INSERT INTO marca (nome) VALUES ('Volvo');
INSERT INTO marca (nome) VALUES ('Renault');
INSERT INTO marca (nome) VALUES ('Ford');
INSERT INTO marca (nome) VALUES ('Mercedes');
INSERT INTO marca (nome) VALUES ('EduCargas');

INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('Actros L', '2021-07-01', 7);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('Actros F', '2021-01-01', 7);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('Actros', '1996-05-21', 7);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('S-WAY', '2022-11-26', 1);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('S-WAY Gas', '2022-11-30', 1);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('V8', '2010-04-12', 2);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('Linha S', '2014-07-25', 2);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('Linha R', '2005-08-15', 2);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('TGX', '2022-03-11', 3);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('TGS', '2022-03-11', 3);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('TGM', '2022-03-11', 3);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('Volvo FH', '1993-03-15', 4);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('Volvo FM', '1998-08-11', 4);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('T High', '2013-06-13', 5);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('F-Max', '2018-04-17', 6);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('Standard', '2000-04-17', 8);
INSERT INTO modelo (nome, dataLanc, idMarca) VALUES ('Open Top', '2000-04-17', 8);

INSERT INTO tipo (nome) VALUES ('Explosivo');
INSERT INTO tipo (nome) VALUES ('Gases');
INSERT INTO tipo (nome) VALUES ('LiquidosInflamaveis');
INSERT INTO tipo (nome) VALUES ('SolidasInflamaveis');
INSERT INTO tipo (nome) VALUES ('Maquinaria');
INSERT INTO tipo (nome) VALUES ('Seca');
INSERT INTO tipo (nome) VALUES ('Granel');
INSERT INTO tipo (nome) VALUES ('Gaiola');

INSERT INTO contentor (matriculaContentor, largura, comprimento, profundidade, cor, pesoMaxSuport, estaUsado, idModelo, idMarca, idTipo) VALUES 
('XA-43-21', 2.35, 5.90, 33.20, 'Preto', 21.77, false, 16, 8, 7);
INSERT INTO contentor (matriculaContentor, largura, comprimento, profundidade, cor, pesoMaxSuport, estaUsado, idModelo, idMarca, idTipo) VALUES 
('RK-ST-FG', 2.35, 12.04, 67.70, 'Amarelo', 26.78, true, 16, 8, 7);
INSERT INTO contentor (matriculaContentor, largura, comprimento, profundidade, cor, pesoMaxSuport, estaUsado, idModelo, idMarca, idTipo) VALUES 
('YU-EF-AS', 2.35, 5.90, 33.20, 'Branco', 21.77, false, 16, 8, 7);
INSERT INTO contentor (matriculaContentor, largura, comprimento, profundidade, cor, pesoMaxSuport, estaUsado, idModelo, idMarca, idTipo) VALUES 
('QA-CV-ZA', 2.35, 12.04, 67.70, 'Castanho', 26.78, true, 16, 8, 7);
INSERT INTO contentor (matriculaContentor, largura, comprimento, profundidade, cor, pesoMaxSuport, estaUsado, idModelo, idMarca, idTipo) VALUES 
('PO-LK-JN', 2.31, 5.89, 32.23, 'Preto', 21.60, false, 17, 8, 6);
INSERT INTO contentor (matriculaContentor, largura, comprimento, profundidade, cor, pesoMaxSuport, estaUsado, idModelo, idMarca, idTipo) VALUES 
('AF-GH-ZC', 2.35,  12.02, 65.50, 'Branco', 26.63, false, 17, 8, 6);
INSERT INTO contentor (matriculaContentor, largura, comprimento, profundidade, cor, pesoMaxSuport, estaUsado, idModelo, idMarca, idTipo) VALUES 
('12-FG-AB', 2.31, 5.89, 32.23, 'Castanho', 21.60, false, 17, 8, 6);
INSERT INTO contentor (matriculaContentor, largura, comprimento, profundidade, cor, pesoMaxSuport, estaUsado, idModelo, idMarca, idTipo) VALUES 
('19-FG-24', 2.35,  12.02, 65.50, 'Verde', 26.63, false, 17, 8, 6);
INSERT INTO contentor (matriculaContentor, largura, comprimento, profundidade, cor, pesoMaxSuport, estaUsado, idModelo, idMarca, idTipo) VALUES 
('FT-ZX-12', 2.44,  6.06, 2.75, 'Verde', 24, false, 17, 8, 5);

INSERT INTO veiculo (matricula, potencia, cilindrada, tanque, cor, pesoMaxSuport, estaUsado, idMarca, idModelo, idCombustivel) VALUES 
('QP-HP-12', 2600, 10.4, 720, 'Amarelo', 45, true, 7, 1, 1);
INSERT INTO veiculo (matricula, potencia, cilindrada, tanque, cor, pesoMaxSuport, estaUsado, idMarca, idModelo, idCombustivel) VALUES 
('AS-US-12', 1600, 12.8, 720, 'Vermelho', 34.2, true, 7, 1, 1);
INSERT INTO veiculo (matricula, potencia, cilindrada, tanque, cor, pesoMaxSuport, estaUsado, idMarca, idModelo, idCombustivel) VALUES 
('ZR-IP-IV', 2600, 390, 720, 'Preto', 32.7, true, 2, 6, 1);
INSERT INTO veiculo (matricula, potencia, cilindrada, tanque, cor, pesoMaxSuport, estaUsado, idMarca, idModelo, idCombustivel) VALUES 
('VB-24-AQ', 2600, 390, 720, 'Verde', 38.19, true, 1, 5, 4);

INSERT INTO pedido (dispCamiao, dispContentor, pesoCarga, dataLimite, nPortaDest, cPostalDest, ruaDest, cPostalOri, nPortaOri, ruaOri, precoEntrega, matriculaContentor, matriculaSegContentor, matricula, idCliente, idFatura) VALUES 
(false, false, 3, '2022-12-5', 7, '4480-330', 'Rua Rui Fonceca', '4795-894', 186, 'Rua das flores', 4000, 'XA-43-21', null, 'QP-HP-12', 1, 1);
INSERT INTO pedido (dispCamiao, dispContentor, pesoCarga, dataLimite, nPortaDest, cPostalDest, ruaDest, cPostalOri, nPortaOri, ruaOri, precoEntrega, matriculaContentor, matriculaSegContentor, matricula, idCliente, idFatura) VALUES 
(true, true, 4.5, '2023-01-15', 15, '3360-032', 'Rua Dr. David Braga', '2645-539', 48, 'Rua Cargas e Descargas', 5700.53, 'AF-GH-ZC', null, 'VB-24-AQ', 1, 2);
INSERT INTO pedido (dispCamiao, dispContentor, pesoCarga, dataLimite, nPortaDest, cPostalDest, ruaDest, cPostalOri, nPortaOri, ruaOri, precoEntrega, matriculaContentor, matriculaSegContentor, matricula, idCliente, idFatura) VALUES 
(false, false, 10.5, '2024-04-04', 89, '4940-027', 'Rua Ze Beto', '2610-181', 12, 'Rua Sao Patricio', 10000.99, 'AF-GH-ZC', null, 'AS-US-12', 1, 4);
INSERT INTO pedido (dispCamiao, dispContentor, pesoCarga, dataLimite, nPortaDest, cPostalDest, ruaDest, cPostalOri, nPortaOri, ruaOri, precoEntrega, matriculaContentor, matriculaSegContentor, matricula, idCliente, idFatura) VALUES 
(false, true, 5.4, '2023-03-13', 19, '4490-666', 'Rua Da Junqueira', '2205-025', 172, 'Rua Dr. Rodrigo Lisboa', 15473.46, 'QA-CV-ZA', null, 'ZR-IP-IV', 1, 5);

INSERT INTO grupomotorista (idPedido, idMotorista, quilometros, tipo) VALUES 
(1, 2, 70, 'p');
INSERT INTO grupomotorista (idPedido, idMotorista, quilometros, tipo) VALUES 
(2, 3, 150, 'p');
INSERT INTO grupomotorista (idPedido, idMotorista, quilometros, tipo) VALUES 
(2, 2, 30, 'c');
INSERT INTO grupomotorista (idPedido, idMotorista, quilometros, tipo) VALUES 
(3, 3, 700, 'p');
INSERT INTO grupomotorista (idPedido, idMotorista, quilometros, tipo) VALUES 
(3, 2, 560, 'c');
INSERT INTO grupomotorista (idPedido, idMotorista, quilometros, tipo) VALUES 
(4, 3, 200, 'p');
INSERT INTO grupomotorista (idPedido, idMotorista, quilometros, tipo) VALUES 
(4, 2, 150, 'c');

INSERT INTO estado (nome) VALUES ('Execucao');
INSERT INTO estado (nome) VALUES ('Suspenso');
INSERT INTO estado (nome) VALUES ('Anulado');
INSERT INTO estado (nome) VALUES ('Concluido');
INSERT INTO estado (nome) VALUES ('Agendado');
INSERT INTO estado (nome) VALUES ('Pago');

INSERT INTO HistoricoEstados (idPedido, idEstado, idUtilizador) VALUES 
(1, 5, 4);
INSERT INTO HistoricoEstados (idPedido, idEstado, idUtilizador) VALUES 
(1, 4, 4);
INSERT INTO HistoricoEstados (idPedido, idEstado, idUtilizador) VALUES 
(1, 6, 1);
INSERT INTO HistoricoEstados (idPedido, idEstado, idUtilizador) VALUES 
(2, 3, 1);

create view pedidoInfo
(
    idPedido,
    disponibilidadeCamiao,
    disponibilidadeContentor,
    pesoCarga,
    dataLimite,
    precoEntrega,
    nPortDest,
    ruaDest,
    codigopostaldestino, 
    localidadeDestino,
    paisDestino,
    nPortaOri,
    ruaOri,
    codigopostalorigem,
    localidadeOrigem,
    paisOrigem,
    contentorMatricula,
    contentorSecundarioMatricula,
    camiaoMatricula,
    cliente,
    precoCIva,
    dataEmissao,
    dataPagamento
)
as select
    p.idPedido,
    p.dispCamiao,
    p.dispContentor,
    p.pesoCarga,
    p.datalimite,
    p.precoEntrega,
    p.nPortaDest,
    p.ruaDest,
    cpDest.cPostal as codigopostaldestino,
    cpDest.localidade as localidadeDestino,
    paisDest.pais as paisDestino,
    p.nPortaOri,
    p.ruaOri,
    cpOri.cPostal as codigopostalorigem, 
    cpOri.localidade as localidadeOrigem,
    paisOri.pais as paisOrigem,
    contP.matriculaContentor as contentorMatricula,
    contS.matriculaContentor as contentorSecundarioMatricula,
    camiao.matricula as camiaoMatricula,
    ut.nomeIni as cliente,
    fat.precoiva as precoCIva,
    fat.dataEmissao as dataEmissao,
    fat.dataPagam as dataPagamento
from pedido p
inner join codigopostal cpDest
    on p.cPostalDest = cpDest.cPostal
inner join pais as paisDest
    on paisDest.codPais = cpDest.codPais
inner join codigopostal cpOri
    on p.cPostalOri = cpOri.cPostal
inner join pais as paisOri
    on paisOri.codPais = cpOri.codPais
inner join contentor contP
    on contP.matriculaContentor = p.matriculaContentor
left join contentor contS
    on contS.matriculaContentor = p.matriculaSegContentor
inner join veiculo camiao
    on camiao.matricula = p.matricula
inner join fatura fat
    on fat.idFatura = p.idFatura
inner join utilizador ut
    on ut.idUtilizador = p.idCliente
inner join tipoutilizador tpUt
    on tpUt.idTipoUt = ut.idTipoUt
where tpUt.nome = 'Cliente'
;

create view pedidoMotorista
(
    idPedido,
    motorista,
    adr,
    cam,
    cc,
    estaTrabalhar,
    tipo,
    quilometros
)
as select
    pi.idPedido,
    ut.nomeIni || ' ' || ut.nomeApelido as motorista,
    m.temADR as adr,
    m.temCam as cam,
    m.cartaoC as cc,
    m.estaTrabalhar,
    case
        when gm.tipo = 'p' then 'Principal'
        when gm.tipo = 'c' then 'Co-Piloto'
    end as tipo,
    gm.quilometros
from pedidoInfo pi
inner join grupomotorista gm
    on pi.idPedido = gm.idPedido
inner join motorista m
    on m.idMotorista = gm.idMotorista
inner join utilizador ut
    on ut.idUtilizador = m.idMotorista
;