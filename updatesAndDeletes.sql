-- Updates

-- Colocar Fatura paga
update fatura
set dataPagam = '2023-01-01'
where idFatura = 5
;

-- Colocar Fatura paga
update fatura
set dataPagam = '2022-12-25'
where idFatura = 4
;

-- Alterar morada de utilizador
update utilizador
set rua = 'Avenida Boa Esperanca', nPorta = 32, cPostal = '2610-181'
where idUtilizador = 5
;

-- Alterar tipo de utilizador para motorista
update utilizador
set idTipoUt = 4
where idUtilizador = 7
;


-- Deletes

-- Apagar utilizador com idUtilizador = 7
delete from utilizador where idUtilizador = 7;

-- Apagar contentor com matricula 'FT-ZX-12'
delete from contentor where matriculaContentor = 'FT-ZX-12';