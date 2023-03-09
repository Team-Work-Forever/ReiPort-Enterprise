-- Index para identificar mais rapidamente pedidos
create unique index indexRequest
on request (id);

-- Index para identificar mais rapidamente contentores
create unique index indexContainer
on container (license);

-- Index para identificar mais rapidamente veiculos
create unique index indexVehicle
on Vehicle (license);