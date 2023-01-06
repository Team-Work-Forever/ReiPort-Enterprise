
-- Obtem-se as informações do Pedido

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


-- Obtem-se as informações dos motoristas de um Pedido
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