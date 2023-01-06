-- Inserir cliente
Create OR replace PROCEDURE addCliente (
    c_nomeIni VARCHAR(50),
    c_nomeApelido VARCHAR(50),
    c_dataNasc DATE,
    c_nif NUMERIC(9),
    c_rua VARCHAR(100),
    c_nPorta INT,
    c_cPostal VARCHAR(8),
    c_telefone NUMERIC(9),
    c_email VARCHAR(200),
    c_passwd VARCHAR(100)
)
LANGUAGE plpgsql AS
$$ BEGIN

    INSERT INTO utilizador (nomeIni, nomeApelido, dataNasc, nif, rua, nPorta, cPostal, telefone, email, passwd, idTipoUt) VALUES 
    (c_nomeIni, c_nomeApelido, c_dataNasc, c_nif, c_rua, c_nPorta, c_cPostal, c_telefone, c_email, c_passwd, 1);

END $$;

call addCliente('Maia', 'Maria', '1985-02-07', 837502849, 'Rua Cesario Verde', 220, '3420-177', 917503249, 'maiaMaria@gmail.com', 'noonewillfindout12?!');

-- Pagar, Adiciona estado de pedido
Create OR replace PROCEDURE addHistorico (
    c_idUtilizador int,
    c_idFatura int
)
LANGUAGE plpgsql AS
$$
DECLARE
    _pedido int;
BEGIN

    update fatura
    set dataPagam = now()::date
    where idFatura = c_idFatura;

    select 
        p.idPedido
    from fatura f
    inner join pedido p
        on p.idFatura = f.idFatura
    into _pedido; 

    insert into historicoestados
    (idPedido, idEstado, idUtilizador)
    values (1, 6, c_idUtilizador);

END $$;

call addHistorico(2, 1);