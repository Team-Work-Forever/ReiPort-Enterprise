-- Inserir cliente
Create OR replace PROCEDURE addClient (
    g_email VARCHAR(200),
    g_passwd VARCHAR(100),
    g_first_name VARCHAR(50),
    g_last_name VARCHAR(50),
    g_birth_date DATE,
    g_nif VARCHAR(9),
    g_street VARCHAR(100),
    g_port INT,
    g_postal_code VARCHAR(8),
    g_telephone VARCHAR(9),
    g_guest_type INT
)
LANGUAGE plpgsql AS
$$ BEGIN

    INSERT INTO Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) VALUES 
    (g_email, g_passwd, g_first_name, g_last_name, g_birth_date, g_nif, g_street, g_port, g_postal_code, g_telephone, 1);

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