--Todos os contentores presentes na reiport
select
    c.matriculaContentor as matricula,
    c.largura,
    c.comprimento,
    c.profundidade,
    c.cor,
    c.pesoMaxSuport,
    c.estaUsado,
    tp.nome as tipo,
    mod.nome as modelo,
    mar.nome as marca
from contentor c
inner join tipo tp
    on tp.idTipo = c.idTipo
inner join modelo mod
    on mod.idModelo = c.idModelo
inner join marca mar
    on mar.idMarca = c.idMarca 
;

--Todos os veiculos presentes na reiport
select
    v.matricula,
    v.potencia,
    v.cilindrada,
    v.tanque,
    v.cor,
    v.pesoMaxSuport,
    v.estaUsado,
    com.nome as combustivel,
    mod.nome as modelo,
    mar.nome as marca
from veiculo v
inner join combustivel com
    on com.idCombustivel = v.idCombustivel
inner join modelo mod
    on mod.idModelo = v.idModelo
inner join marca mar
    on mar.idMarca = v.idMarca
;

--Visualizar Historicos de Estados de Movimento de um pedido
select
    pd.idPedido,
    est.nome as estado,
    hist.dataInicioEstado,
    ut.nomeIni || ' ' || ut.nomeApelido as nome,
    tu.nome as tipo
from historicoestados hist
inner join pedido pd
    on hist.idPedido = pd.idPedido
inner join estado est
    on hist.idEstado = est.idEstado
inner join utilizador ut
    on hist.idUtilizador = ut.idUtilizador
inner join tipoutilizador tu
    on ut.idTipoUt = tu.idTipoUt
;

--Select para o preco total ganho com pedidos
select
    SUM(precoSiva)
from fatura
where dataPagam is not NULL
;

--Quantidade de funcionarios ao embarco da reiport
select
    count(ut.*) as quantidade
from utilizador ut
inner join tipoutilizador tu
    on ut.idTipoUt = tu.idTipoUt
where tu.nome <> 'Cliente'
;

--Selecionar Pais para que a reiport transporta
select
    pais
from pais
;

--Listar Motoristas que possuiem adr
select
    ut.nomeIni || ' ' || ut.nomeApelido as nome,
    ut.dataNasc,
    ut.nif,
    ut.rua || ' ' || ut.nPorta as morada,
    cp.cPostal,
    cp.localidade,
    ut.email,
    m.temADR,
    m.temCam,
    m.cartaoC as cc,
    m.estaTrabalhar
from motorista m
inner join utilizador ut
    on ut.idUtilizador = m.idMotorista
inner join codigopostal cp
    on cp.cPostal = ut.cPostal
where m.temADR is TRUE
;

--Listar Motoristas que possuiem cam
select
    ut.nomeIni || ' ' || ut.nomeApelido as nome,
    ut.dataNasc,
    ut.nif,
    ut.rua || ' ' || ut.nPorta as morada,
    cp.cPostal,
    cp.localidade,
    ut.email,
    m.temADR,
    m.temCam,
    m.cartaoC as cc,
    m.estaTrabalhar
from motorista m
inner join utilizador ut
    on ut.idUtilizador = m.idMotorista
inner join codigopostal cp
    on cp.cPostal = ut.cPostal
where m.temCam is TRUE
;

--Quantidade de quilometros feitos pelos motoristas num dado pedido
select
    gm.idPedido,
    sum(gm.quilometros) as quilometros
from grupomotorista gm
inner join motorista mt
    on mt.idMotorista = gm.idMotorista
inner join utilizador ut
    on ut.idUtilizador = mt.idMotorista
group by (gm.idPedido)
order by gm.idPedido
;

--Quantidade de motoristas definidos por pedido
select
    gm.idPedido,
    count(gm.idMotorista) as qtdMotoristas
from grupomotorista gm
group by gm.idPedido
order by gm.idPedido
;

--Quantos camiões disponiveis apartir de um pesomaximo
select
	count(v.*) as qtd
from veiculo v
inner join marca mar
	on v.idMarca = mar.idMarca
where v.pesoMaxSuport > 7.45
;

--Quanto cada motorista produziu para a reiport
select
	ut.nomeIni || ' ' || ut.nomeApelido as nome,
    ft.datapagam,
	sum(ft.precosiva) as total
from motorista mt
inner join utilizador ut
    on ut.idUtilizador = mt.idMotorista
inner join grupomotorista gm
	on gm.idMotorista = mt.idMotorista
inner join pedido pd
	on pd.idPedido = gm.idPedido
inner join fatura ft
	on ft.idFatura = pd.idFatura
where ft.datapagam is not null
group by (nome, ft.datapagam)
;

--TotalRecebido por cada projeto apartir do ano 2020
select
    pd.idPedido,
    sum(fat.precosiva) as totalPago
from fatura fat
inner join pedido pd
    on pd.idFatura = fat.idFatura
where extract(year from fat.dataPagam) > 2020
group by pd.idPedido
order by pd.idPedido
;