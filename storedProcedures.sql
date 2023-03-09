CREATE OR replace PROCEDURE insertGuest (
    g_email VARCHAR,
    g_passwd VARCHAR,
    g_first_name VARCHAR,
    g_last_name VARCHAR,
    g_birth_date DATE,
    g_nif VARCHAR,
    g_street VARCHAR,
    g_port INT,
    g_postal_code VARCHAR,
    g_telephone VARCHAR,
    g_type int
)
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) VALUES 
    (g_email, g_passwd, g_first_name, g_last_name, g_birth_date, g_nif, g_street, g_port, g_postal_code, g_telephone, g_type);

END $$;

-- Create Drivers
-- TODO: #Não Testado
CREATE OR replace PROCEDURE createDriver (
    g_email VARCHAR,
    g_passwd VARCHAR,
    g_first_name VARCHAR,
    g_last_name VARCHAR,
    g_birth_date DATE,
    g_nif VARCHAR,
    g_street VARCHAR,
    g_port INT,
    g_postal_code VARCHAR,
    g_telephone VARCHAR,
    d_has_adr BOOLEAN,
    d_has_cam BOOLEAN,
    d_cc VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    _id_guest int;
BEGIN

    INSERT INTO Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) VALUES 
    (g_email, g_passwd, g_first_name, g_last_name, g_birth_date, g_nif, g_street, g_port, g_postal_code, g_telephone, 4);

    SELECT  
        id
    FROM guest where email = g_email
    into _id_guest;

    insert into Driver (id, has_adr, has_cam, cc) values 
    (_id_guest, d_has_adr, d_has_cam, d_cc);

END $$;

-- Create Vehicle: args vehicle, model name, fuel
CREATE OR replace PROCEDURE createVehicle (
    v_license varchar,
    v_power int,
    v_displacement int,
    v_tank numeric,
    v_color varchar,
    v_max_supported_weight numeric,
    v_is_in_use boolean,
    v_model_name int,
    v_fuel int
)
LANGUAGE plpgsql
AS $$
DECLARE
    _model_id int;
BEGIN

    -- Get ModelName
    select
        id into _model_id
    from model
    where name = v_model_name;

    -- Insert Vehicle
    insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values
     (v_licence, v_power, v_displacement, v_color, v_max_supported_weight, v_is_in_use, _model_id, v_tank, v_fuel);

END $$;
