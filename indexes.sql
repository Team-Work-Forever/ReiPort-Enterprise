-- Index para identificar mais rapidamente pedidos
create unique index indexPedidos
on pedido (idPedido);

-- Index para identificar mais rapidamente contentores
create unique index indexContentor
on contentor (matriculaContentor);

-- Index para identificar mais rapidamente veiculos
create unique index indexVeiculo
on veiculo (matricula);