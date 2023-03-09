
-- TODO: #Não Testado!
-- Alterar Estado de Request de Concluido para Pago se e só se todas as faturas forem pagas 
create or replace function log_payment_change_state()
  returns trigger
  language plpgsql
as $$
declare
    _total_payed int;
    _delivery_price int;
    _diff int;
begin

    -- Get Invoices
    select count(price_without_vat) into _total_payed
    from invoice
    where request = old.request;

    -- Get Delivery Price
    select delivery_price into _delivery_price
    from request
    where id = old.request;

    -- Get Diff Payed
    _diff := _delivery_price - _total_payed;

    -- Compare If Request is totally payed
    -- Alterar Estado Request
    if _diff = 0 then
        update historicstate
            set state = 6
        where request = old.request;
    end if;

    return new;
end;
$$;

create or replace trigger change_state_hist_request
  after insert
  on invoice
  for each ROW
  execute procedure log_payment_change_state();

-- Calculate price_with_vat
create or replace function log_update_vat_invoce()
  returns trigger
  language plpgsql
as $$
begin

    update invoice
        set price_with_vat = price_without_vat * 1.23
    where id = old.id;

    return new;
end;
$$;

create or replace trigger update_vat_invoce
  after insert
  on invoice
  for each ROW
  execute procedure log_payment_change_state();

-- Verify if DeadLine is greatter then today's date
create or replace function log_check_deadline()
  returns trigger
  language plpgsql
as $$
begin

    if NEW.deadline <= now() then
        RAISE EXCEPTION 'CANNOT DEFINE A DEADLINE BEFORE NOW';
    end if;

    return NEW;
end;
$$;

-- Indicates which drivers are Co-pilots and pilots
create or replace trigger check_deadline
  before insert or update
  on request
  for each ROW
  execute procedure log_check_deadline();

create or replace function log_change_driver_type()
  returns trigger
  language plpgsql
  as
$$
declare
    _drivers int;
begin

    select count(*)
    from drivergroup
    where request = new.request
    into _drivers;

	if _drivers > 1 then
        update drivergroup
        set type = 'c'
        where request = new.request and driver = new.driver;
    else
        update drivergroup
        set type = 'p'
        where request = new.request and driver = new.driver;
	end if;

	return new;
end;
$$;

create or replace trigger change_driver_type
  after insert
  on drivergroup
  for each ROW
  execute procedure log_change_driver_type();
