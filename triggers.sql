-- Trigger para alterar se tiver dois motoristas num serviço alterar de p para c
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

create or replace trigger alterar_tipo_driver
  after insert
  on drivergroup
  for each ROW
  execute procedure log_change_driver_type();