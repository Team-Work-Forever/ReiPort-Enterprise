-- Trigger para alterar se tiver dois motoristas num serviço alterar de p para c
create or replace function log_alterar_tipo_motorista()
  returns trigger
  language plpgsql
  as
$$
declare
    _motoristas int;
begin

    select count(*)
    from grupomotorista
    where idPedido = new.idPedido
    into _motoristas;

	if _motoristas > 1 then
        update grupomotorista
        set tipo = 'c'
        where idPedido = new.idPedido and idMotorista = new.idMotorista;
    else
        update grupomotorista
        set tipo = 'p'
        where idPedido = new.idPedido and idMotorista = new.idMotorista;
	end if;

	return new;
end;
$$;

create or replace trigger alterar_tipo_motorista
  after insert
  on grupomotorista
  for each ROW
  execute procedure log_alterar_tipo_motorista();