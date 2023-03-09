
-- Obtem-se as informações do Pedido

create view requestInfo
as select
    r.id as request_id,
    r.truck_availability,
    r.container_availability,
    r.cargo_weight,
    r.deadline,
    r.delivery_price,
    r.port_dest,
    r.street_dest,
    postal_dest.id as postal_code_dest,
    postal_dest.locality as locality_dest,
    country_dest.country as country_dest,
    r.port_ori,
    r.street_ori,
    postal_ori.id as postal_code_ori, 
    postal_ori.locality as locality_ori,
    countryOri.country as country_ori,
    container_first.license as container_first,
    container_second.license as container_second,
    truck.license as truck_license,
    guest.first_name as client,
    inv.price_with_vat,
    inv.date_issue,
    inv.payment_date
from request r
inner join PostalCode postal_dest
    on r.postal_code_dest = postal_dest.id
inner join country as country_dest
    on country_dest.id = postal_dest.country
inner join PostalCode postal_ori
    on r.postal_code_ori = postal_ori.id
inner join country as countryOri
    on countryOri.id = postal_ori.country
inner join container container_first
    on container_first.license = r.container_license
left join container container_second
    on container_second.license = r.container_license_second
inner join vehicle truck
    on truck.license = r.license
inner join invoice inv
    on inv.id = r.invoice
inner join guest guest
    on guest.id = r.client
inner join guestType guest_type
    on guest_type.id = guest.guest_type
where guest_type.name = 'Cliente'
;


-- Obtem-se as informações dos motoristas de um Pedido

create view requestDriver
as select
    ri.request_id,
    guest.first_name || ' ' || guest.last_name as driver_full_name,
    d.has_adr as adr,
    d.has_cam as cam,
    d.cc as cc,
    d.is_working,
    case
        when dg.type = 'p' then 'Principal'
        when dg.type = 'c' then 'Co-Piloto'
    end as type,
    dg.kilometers
from requestInfo ri
inner join DriverGroup dg
    on ri.request_id = dg.request
inner join driver d
    on d.id = dg.driver
inner join guest guest
    on guest.id = d.id
;