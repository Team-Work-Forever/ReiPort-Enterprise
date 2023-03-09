create database reiport;

\c reiport;

CREATE TABLE Country(
    id SERIAL NOT NULL,
    country VARCHAR(100) NOT NULL UNIQUE,
    created_at DATE DEFAULT now(),
    updated_at DATE DEFAULT NULL,
    deleted_at DATE DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE PostalCode(
    id VARCHAR(8) NOT NULL,
    description VARCHAR(200) DEFAULT NULL,
    locality VARCHAR(100) NOT NULL,
    country INT NOT NULL,
    created_at DATE DEFAULT now(),
    updated_at DATE DEFAULT NULL,
    deleted_at DATE DEFAULT NULL,
    PRIMARY KEY (id),
    CONSTRAINT country_fk1
        FOREIGN KEY (country)
            REFERENCES Country (id)
);

CREATE TABLE GuestType(
    id SERIAL NOT NULL,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(100) DEFAULT NULL,
    created_at DATE DEFAULT now(),
    updated_at DATE DEFAULT NULL,
    deleted_at DATE DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE Guest(
    id SERIAL NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    passwd VARCHAR(100) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    nif VARCHAR(9) NOT NULL UNIQUE,
    street VARCHAR(100) NOT NULL,
    port INT NOT NULL,
    postal_code VARCHAR(8) NOT NULL,
    telephone VARCHAR(9) NOT NULL,
    guest_type INT NOT NULL,
    created_at DATE DEFAULT now(),
    updated_at DATE DEFAULT NULL,
    deleted_at DATE DEFAULT NULL,
    PRIMARY KEY (id),
    CONSTRAINT codPostal_fk1
        FOREIGN KEY (postal_code)
            REFERENCES PostalCode (id),
    CONSTRAINT guest_type_fk1
        FOREIGN KEY (guest_type)
            REFERENCES guestType (id)
);

CREATE TABLE Driver(
    id INT NOT NULL,
    has_adr BOOLEAN NOT NULL DEFAULT FALSE,
    has_cam BOOLEAN NOT NULL DEFAULT FALSE,
    cc VARCHAR(8) NOT NULL,
    is_working BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATE DEFAULT now(),
    updated_at DATE DEFAULT NULL,
    deleted_at DATE DEFAULT NULL,
    PRIMARY KEY (id),
    CONSTRAINT driver_fk1
        FOREIGN KEY (id)
            REFERENCES guest (id)
);

CREATE TABLE Invoice(
    id SERIAL NOT NULL,
    price_without_vat NUMERIC(9,2) NOT NULL CHECK(price_without_vat > 0),
    price_with_vat NUMERIC(9,2) NOT NULL CHECK(price_with_vat > 0),
    date_issue DATE NOT NULl DEFAULT now(),
    payment_date DATE DEFAULT NULL,
    nif VARCHAR(9) DEFAULT NULL UNIQUE,
    street VARCHAR(100) DEFAULT NULL,
    port INT DEFAULT NULL,
    postal_code VARCHAR(8) DEFAULT NULL,
    payment_method INT DEFAULT NULL,
    created_at DATE DEFAULT now(),
    updated_at DATE DEFAULT NULL,
    deleted_at DATE DEFAULT NULL,
    PRIMARY KEY (id),
    CONSTRAINT codPostal_fk1
    FOREIGN KEY (postal_code)
        REFERENCES PostalCode (id)
);

CREATE TABLE Brand(
    id SERIAL NOT NULL,
    name VARCHAR(50) NOT NULL UNIQUE,
    logo bytea DEFAULT NULL,
    created_at DATE DEFAULT now(),
    updated_at DATE DEFAULT NULL,
    deleted_at DATE DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE Model(
    id SERIAL NOT NULL,
    name VARCHAR(50) NOT NULL UNIQUE,
    launch_date DATE NOT NULL,
    brand INT NOT NULL,
    created_at DATE DEFAULT now(),
    updated_at DATE DEFAULT NULL,
    deleted_at DATE DEFAULT NULL,
    PRIMARY KEY (id),
    CONSTRAINT brand_fk1
        FOREIGN KEY (brand)
            REFERENCES Brand (id) 
);

CREATE TABLE Container(
    license VARCHAR(11) NOT NULL,
    width NUMERIC(5,2) NOT NULL CHECK(width > 0),
    length NUMERIC(5,2) NOT NULL CHECK(length > 0),
    depth NUMERIC(5,2) NOT NULL CHECK(depth > 0),
    color VARCHAR(50) NOT NULL,
    max_supported_weight NUMERIC(9,2) NOT NULL CHECK(max_supported_weight > 0),
    is_in_use BOOLEAN NOT NULL DEFAULT FALSE,
    model INT NOT NULL,
    type INT NOT NULL,
    created_at DATE DEFAULT now(),
    updated_at DATE DEFAULT NULL,
    deleted_at DATE DEFAULT NULL,
    PRIMARY KEY (license),
    CONSTRAINT model_fk1
        FOREIGN KEY (model)
            REFERENCES Model (id)
);

CREATE TABLE Vehicle(
    license VARCHAR(8) NOT NULL,
    power INT NOT NULL CHECK(power > 0),
    displacement INT NOT NULL CHECK(displacement > 0),
    tank NUMERIC(6,2) NOT NULL CHECK(tank > 0),
    color VARCHAR(50) NOT NULL,
    max_supported_weight NUMERIC(9,2) NOT NULL CHECK(max_supported_weight > 0),
    is_in_use BOOLEAN NOT NULL DEFAULT FALSE,
    model INT NOT NULL,
    fuel INT DEFAULT NULL,
    created_at DATE DEFAULT now(),
    updated_at DATE DEFAULT NULL,
    deleted_at DATE DEFAULT NULL,
    PRIMARY KEY (license),
    CONSTRAINT model_fk2
        FOREIGN KEY (model)
            REFERENCES Model (id)
);

CREATE TABLE Request(
    id SERIAL NOT NULL,
    truck_availability BOOLEAN NOT NULL DEFAULT FALSE,
    container_availability BOOLEAN NOT NULL DEFAULT FALSE,
    cargo_weight NUMERIC(9,2) NOT NULL CHECK(cargo_weight > 0),
    deadline DATE NOT NULL,
    port_dest INT NOT NULL,
    postal_code_dest VARCHAR(8) NOT NULL,
    street_dest VARCHAR(100) NOT NULL,
    postal_code_ori VARCHAR(8) NOT NULL,
    port_ori INT NOT NULL,
    street_ori VARCHAR(100) NOT NULL,
    delivery_price NUMERIC(9,2) NOT NULL CHECK(delivery_price > 0),
    container_license VARCHAR(11) NOT NULL,
    container_license_second VARCHAR(11) DEFAULT NULL,
    license VARCHAR(8) NOT NULL,
    client INT NOT NULL,
    invoice INT DEFAULT NULL,
    created_at DATE DEFAULT now(),
    updated_at DATE DEFAULT NULL,
    deleted_at DATE DEFAULT NULL,
    PRIMARY KEY (id),
    CONSTRAINT postal_code_dest_fk1
            FOREIGN KEY (postal_code_dest)
                REFERENCES PostalCode (id),
    CONSTRAINT postal_code_ori_fk2
            FOREIGN KEY (postal_code_ori)
                REFERENCES PostalCode (id),
    CONSTRAINT container_license_fk3
            FOREIGN KEY (container_license)
                REFERENCES Container (license),
    CONSTRAINT container_license_second_fk4
            FOREIGN KEY (container_license_second)
                REFERENCES Container (license),
    CONSTRAINT license_fk5
            FOREIGN KEY (license)
                REFERENCES Vehicle (license),
    CONSTRAINT client_fk6
            FOREIGN KEY (client)
                REFERENCES guest (id),
    CONSTRAINT invoice_fk7
            FOREIGN KEY (invoice)
                REFERENCES Invoice (id)
);

CREATE TABLE DriverGroup(
    request INT NOT NULL,
    driver INT NOT NULL,
    kilometers NUMERIC(9,2) NOT NULL CHECK(kilometers > 0),
    type CHAR NOT NULL DEFAULT 'p',
    created_at DATE DEFAULT now(),
    updated_at DATE DEFAULT NULL,
    deleted_at DATE DEFAULT NULL,
    PRIMARY KEY (request, driver),
    CONSTRAINT request_fk1
            FOREIGN KEY (request)
                REFERENCES request (id),
    CONSTRAINT driver_fk2
            FOREIGN KEY (driver)
                REFERENCES Driver (id)
);

CREATE TABLE HistoricState(
    id SERIAL NOT NULL,
    start_date DATE NOT NULL DEFAULT now(),
    request INT NOT NULL,
    state INT NOT NULL,
    guest INT NOT NULL,
    created_at DATE DEFAULT now(),
    updated_at DATE DEFAULT NULL,
    deleted_at DATE DEFAULT NULL,
    PRIMARY KEY (id),
    CONSTRAINT request_fk1
            FOREIGN KEY (request)
                REFERENCES request (id),
    CONSTRAINT guest_fk3
            FOREIGN KEY (guest)
                REFERENCES guest (id)
);

create table GuestGroup(
    request INT NOT NULL,
    guest INT NOT NULL,
    begin_date DATE DEFAULT now(),
    exit_date DATE DEFAULT NULL,
    created_at DATE DEFAULT now(),
    updated_at DATE DEFAULT NULL,
    deleted_at DATE DEFAULT NULL,
    PRIMARY KEY (request, guest),
    CONSTRAINT request_fk1
        FOREIGN KEY (request)
            REFERENCES request (id),
    CONSTRAINT guest_fk2
            FOREIGN KEY (guest)
                REFERENCES guest (id)
);

create unique index indexRequest
on request (id);

create unique index indexContainer
on container (license);

create unique index indexVehicle
on Vehicle (license);


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

-- Inserts

insert into Country (country) values ('Russia');
insert into Country (country) values ('Philippines');
insert into Country (country) values ('Japan');
insert into Country (country) values ('Morocco');
insert into Country (country) values ('China');
insert into Country (country) values ('Indonesia');
insert into Country (country) values ('Argentina');
insert into Country (country) values ('Madagascar');
insert into Country (country) values ('France');
insert into Country (country) values ('Greece');
insert into Country (country) values ('Peru');
insert into Country (country) values ('United States');
insert into Country (country) values ('Poland');
insert into Country (country) values ('Palestinian Territory');
insert into Country (country) values ('South Korea');
insert into Country (country) values ('Albania');
insert into Country (country) values ('Portugal');
insert into Country (country) values ('Sweden');
insert into Country (country) values ('Ethiopia');
insert into Country (country) values ('Finland');
insert into Country (country) values ('Serbia');
insert into Country (country) values ('Belarus');
insert into Country (country) values ('Canada');
insert into Country (country) values ('Lithuania');
insert into Country (country) values ('Vietnam');
insert into Country (country) values ('Malaysia');
insert into Country (country) values ('Chile');
insert into Country (country) values ('Colombia');
insert into Country (country) values ('Bulgaria');
insert into Country (country) values ('Croatia');
insert into Country (country) values ('Brazil');
insert into Country (country) values ('Venezuela');
insert into Country (country) values ('Tanzania');
insert into Country (country) values ('North Korea');
insert into Country (country) values ('Moldova');
insert into Country (country) values ('Czech Republic');
insert into Country (country) values ('Guatemala');
insert into Country (country) values ('Panama');
insert into Country (country) values ('Democratic Republic of the Congo');
insert into Country (country) values ('Estonia');
insert into Country (country) values ('Paraguay');
insert into Country (country) values ('Nicaragua');
insert into Country (country) values ('Nigeria');
insert into Country (country) values ('Cambodia');
insert into Country (country) values ('Hungary');
insert into Country (country) values ('Germany');
insert into Country (country) values ('Iran');
insert into Country (country) values ('Egypt');
insert into Country (country) values ('Yemen');
insert into Country (country) values ('Ukraine');
insert into Country (country) values ('Azerbaijan');
insert into Country (country) values ('Burkina Faso');
insert into Country (country) values ('Thailand');

INSERT INTO PostalCode (id, locality, country) VALUES ('4490-666', 'Povoa de Varzim', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('1000-139', 'Lisboa', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('3360-139', 'Cantanhede', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('2205-025', 'Abrantes', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('4705-480', 'Braga', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('4905-067', 'Barcelos', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('3040-474', 'Coimbra', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('3360-032', 'Penacova', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('3420-177', 'Tabua', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('4200-014', 'Porto', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('4475-045', 'Maia', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('4795-894', 'Santo Tirso', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('4480-330', 'Vila do Conde', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('4900-281', 'Viana do Castelo', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('4940-027', 'Paredes de Coura', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('2645-539', 'Cascais', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('3520-039', 'Nelas', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('7150-123', 'Borba', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('2610-181', 'Amadora', 17);
INSERT INTO PostalCode (id, locality, country) VALUES ('4490-251', 'Povoa de Varzim', 17);

INSERT INTO guestType (name) VALUES ('Cliente');
INSERT INTO guestType (name) VALUES ('Rececionista');
INSERT INTO guestType (name) VALUES ('Gestor');
INSERT INTO guestType (name) VALUES ('Motorista');
INSERT INTO guestType (name) VALUES ('Admin');

insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rmcelwee0@domainmarket.com', 'cDljC7xm7', 'Rudyard', 'McElwee', '2002-12-25', 264620567, 'Gulseth', '36492', '3520-039', 286315192, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kredmile1@psu.edu', 'CzslLV4iScF', 'Kippie', 'Redmile', '2009-07-22', 826161141, 'Garrison', '50890', '1000-139', 104547699, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('nchishull2@chronoengine.com', 'tFrFjQEUiL', 'Naoma', 'Chishull', '1977-12-20', 259290654, 'Bluejay', '12122', '3420-177', 284883167, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bduffan3@xing.com', 'Vay9kdyrv', 'Bo', 'Duffan', '1987-05-29', 485383577, 'David', '4', '7150-123', 850461106, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('stimewell4@thetimes.co.uk', 'o6Wjo2sn7', 'Skipp', 'Timewell', '1968-07-20', 129335414, 'Stoughton', '97719', '4490-666', 928042769, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lkarslake5@hexun.com', 'nWKOqqmSRXvF', 'Lanie', 'Karslake', '1925-09-17', 614762132, 'Logan', '15641', '4705-480', 402161575, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rlekeux6@wsj.com', 'ZxCjxoSXmD', 'Ronny', 'le Keux', '2007-09-07', 997046544, 'Tomscot', '0', '2645-539', 640536707, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mhuntingford7@uiuc.edu', 'JegpPewBLj', 'Marchelle', 'Huntingford', '1998-12-21', 654211380, 'Everett', '6', '1000-139', 578566003, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cpachmann8@yahoo.co.jp', 'KNXYjLy53O1', 'Consolata', 'Pachmann', '2007-05-15', 609870703, 'Barby', '377', '3040-474', 551607424, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cgawkes9@arizona.edu', 'IUYeZ05or', 'Cindra', 'Gawkes', '1999-05-29', 825265789, 'Express', '52304', '4480-330', 723201479, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lgrevelb@shareasale.com', 'stDF3k', 'Lloyd', 'Grevel', '1923-06-12', 154691136, 'Utah', '2488', '4475-045', 105464327, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kfarbrotherc@si.edu', '6Rk7fvg1i', 'Kaspar', 'Farbrother', '1948-12-15', 930428522, 'Mallard', '6179', '4940-027', 899298685, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('iabelovd@twitter.com', 'AVcbML', 'Inger', 'Abelov', '1953-12-14', 276712986, 'Northview', '02626', '7150-123', 226144007, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tmccoshe@storify.com', '7m7Jnvv', 'Tiertza', 'McCosh', '2011-09-25', 578279906, 'Hanover', '485', '2645-539', 895340081, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lmccaddenf@163.com', 'UL8Fq7c', 'Lionel', 'McCadden', '2011-03-26', 588156017, 'Coleman', '97428', '4705-480', 746727935, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('sstiggerg@hc360.com', 'nlDM4UR39SV0', 'Sharity', 'Stigger', '1994-07-31', 522442481, 'Anhalt', '627', '4795-894', 700944832, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bmortelh@myspace.com', 'lmuEfUEqRiGG', 'Babb', 'Mortel', '1974-03-15', 708285192, 'Mallard', '6375', '7150-123', 653466526, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('vroycrafti@nymag.com', 'm4czfAo', 'Virge', 'Roycraft', '1926-03-13', 170553895, 'Commercial', '1571', '4475-045', 797772633, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('acreykej@usatoday.com', 'z65dOJI', 'Alie', 'Creyke', '1975-11-02', 757089317, 'Stephen', '22', '4490-666', 304161241, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('crowberryk@usnews.com', 'fWv1hSpBEZ', 'Christina', 'Rowberry', '1932-10-31', 748570441, 'Fremont', '2', '4475-045', 330225386, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ccrutchfieldl@japanpost.jp', 'SA3yktNzmE7t', 'Calypso', 'Crutchfield', '1955-11-12', 616921545, 'Hoffman', '9', '4200-014', 799904040, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('dhuddlestonem@miitbeian.gov.cn', 'qiZaAIQ9b', 'Doy', 'Huddlestone', '1932-05-03', 524744060, 'Aberg', '0292', '3420-177', 718207221, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('veasterbyn@ed.gov', '8FCukrC7Z', 'Vincent', 'Easterby', '1925-11-28', 765100467, 'Carioca', '670', '4480-330', 302550459, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jdecourcyo@1und1.de', 'Tdk2YX3RK0r', 'Jorry', 'de Courcy', '1989-10-28', 442075774, 'Lakeland', '69109', '4490-251', 929611747, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('frannerp@amazon.co.uk', '7rm8UTeDt', 'Frederico', 'Ranner', '1973-03-04', 488240321, 'Everett', '41593', '4905-067', 909789046, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lclayhillq@qq.com', 'awLD0B0RNOB', 'Lucinda', 'Clayhill', '2001-10-28', 608838048, 'Briar Crest', '48', '3360-032', 227051170, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ncowlasr@unc.edu', 'lunT4VPctF', 'Nevsa', 'Cowlas', '1966-09-01', 126074364, 'Dixon', '55', '1000-139', 698053152, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('agittenss@dell.com', 'E1JvkSDNsKZy', 'Allen', 'Gittens', '1996-12-02', 835925404, 'Ronald Regan', '44', '2610-181', 628890209, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('hconnuet@wikipedia.org', 'heEOuSyaR', 'Hermon', 'Connue', '1955-07-13', 771486563, 'Scoville', '736', '3360-139', 357894791, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tgoldu@howstuffworks.com', '9aUaSnxa8', 'Tucky', 'Gold', '1998-10-07', 706904055, 'Hansons', '13351', '4475-045', 607992119, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('asheberv@dion.ne.jp', 'Fq8vn4LBCxb', 'Ange', 'Sheber', '1958-07-16', 826569987, 'Lighthouse Bay', '395', '3360-139', 968573185, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('aravilusw@cbc.ca', 'kaz1aCz0j', 'Anne-corinne', 'Ravilus', '2001-08-12', 636932572, 'Valley Edge', '68879', '4905-067', 790372230, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('oramshawx@barnesandnoble.com', 'nFrv4uMAV', 'Ogden', 'Ramshaw', '1945-10-26', 309918651, 'Debs', '03871', '3520-039', 583067769, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jchadburny@google.com.br', 'KbOsvrvYa', 'Justen', 'Chadburn', '1959-03-21', 359874810, 'Boyd', '71', '7150-123', 842394567, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lbuickz@economist.com', 'SiJ3S8Wnr', 'Lennie', 'Buick', '1930-01-15', 119048328, 'Eastwood', '9', '1000-139', 445212561, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bsoper10@zdnet.com', 'TZDUg5', 'Byrann', 'Soper', '1928-03-18', 482030620, 'Sommers', '42', '4490-666', 500345759, 5);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mdelacroix11@home.pl', 'QDxG63', 'Mandel', 'Delacroix', '1960-01-23', 262286429, 'West', '74533', '3360-032', 481861870, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lkyteley12@icq.com', '7AJR4ed', 'Lenee', 'Kyteley', '2021-09-15', 715277279, 'Orin', '19736', '4480-330', 975632151, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kclausson13@amazon.co.jp', 'Z371424', 'Keefe', 'Clausson', '1989-03-02', 821987080, 'Surrey', '65', '3420-177', 940433574, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('amardle14@amazon.com', 'KO1OIAg', 'Annaliese', 'Mardle', '2020-07-31', 733144957, 'Northridge', '34', '4490-666', 182459070, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('iryde16@shareasale.com', 'bJmous', 'Ibby', 'Ryde', '1977-02-13', 751797677, 'Arkansas', '425', '4940-027', 251478257, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bgrieswood17@hao123.com', 'Nfr8kxg4G', 'Beltran', 'Grieswood', '1994-12-09', 118005138, 'Mendota', '04', '4795-894', 798308771, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bedney18@dot.gov', 'LFCAFCrRDH', 'Bren', 'Edney', '2006-08-05', 928685632, 'Artisan', '380', '4705-480', 125409599, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bdoudney19@ow.ly', 'HJwWpjdm', 'Bennie', 'Doudney', '1933-01-03', 558833956, 'Burrows', '52', '4490-251', 253547528, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rmulbery1a@fotki.com', 'o1L7cjU', 'Richart', 'Mulbery', '1940-02-24', 174948438, 'Walton', '90456', '4490-666', 864413803, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('gbentsen1b@howstuffworks.com', 'JlXeyRci3IlH', 'Gail', 'Bentsen', '2004-05-26', 787454199, 'Spaight', '3', '3360-139', 692275527, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('edolden1c@issuu.com', 'OlA3LrxCR', 'Evyn', 'Dolden', '1938-11-12', 594478075, 'Ryan', '47812', '4905-067', 180568173, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cbertomier1d@php.net', 'Yv3gNnu7', 'Cyndia', 'Bertomier', '2006-06-06', 697542381, 'Sachs', '310', '4900-281', 162415139, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('hfeeham1e@chron.com', 'ybkDNCbz0', 'Huntington', 'Feeham', '2014-01-22', 971231623, 'Autumn Leaf', '631', '4490-251', 685437267, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('fyegorshin1f@goo.gl', '8yyB20Mt', 'Farrell', 'Yegorshin', '1998-10-27', 122041842, 'Lindbergh', '4968', '4905-067', 326883557, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('pwyllt1g@yellowpages.com', '2Z9Wow94', 'Pattie', 'Wyllt', '2015-12-04', 434999211, 'Florence', '481', '3520-039', 784881488, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('hhollow1h@ibm.com', '0BP60sV5ebX', 'Hetty', 'Hollow', '1994-02-23', 456947855, 'Shoshone', '2', '3040-474', 941878780, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tchristensen1i@patch.com', 'hmBNJqSTWUGS', 'Torrey', 'Christensen', '1956-10-13', 257025105, 'Mccormick', '12', '3420-177', 315938741, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('agoldfinch1j@ted.com', '3f8fwFpch9PU', 'Anselma', 'Goldfinch', '1968-06-11', 569255352, 'Kensington', '342', '4475-045', 283249866, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('epawels1k@hatena.ne.jp', '3QK0zyrJ', 'Elie', 'Pawels', '2006-09-27', 455104181, 'Chinook', '5263', '4200-014', 978126551, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bmotte1l@unicef.org', 'fTPdZxxaVw', 'Britte', 'Motte', '2019-07-03', 428280787, 'Dakota', '8410', '4705-480', 400801817, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cfishbie1m@cbslocal.com', '9wpc2QyOt2t', 'Care', 'Fishbie', '1935-11-28', 866506234, 'Sullivan', '7307', '4940-027', 756619496, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lhalegarth1n@jiathis.com', 'hcp1eE', 'Lewie', 'Halegarth', '2004-04-28', 516187512, 'Maple Wood', '67723', '4940-027', 378715372, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('aniccolls1o@businessweek.com', 'AizqcnIH', 'Ambur', 'Niccolls', '2003-07-09', 715373426, 'Walton', '7', '4940-027', 716875338, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('scapnerhurst1p@amazon.com', 'MrA43mqtI', 'Sheree', 'Capnerhurst', '2012-02-11', 762227078, 'Erie', '7', '1000-139', 423850503, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mavramovich1r@google.nl', 'bjPst3qe5', 'Modestine', 'Avramovich', '1941-05-23', 314328166, 'Hoffman', '64', '4490-251', 383396330, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rcritoph1s@wufoo.com', 'iE2OhkYwDsF', 'Ryun', 'Critoph', '1941-05-27', 247579884, 'Crescent Oaks', '108', '4490-251', 356124422, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tnatalie1t@smh.com.au', 'kyrBrYsQucbn', 'Temple', 'Natalie', '1969-05-06', 648703328, 'Londonderry', '24430', '3360-139', 785170408, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jcollum1u@washingtonpost.com', '2xXypu', 'Jaclin', 'Collum', '2002-03-01', 710278621, 'Morningstar', '7', '4480-330', 537136810, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tbezants1v@constantcontact.com', '8ISX09grP', 'Tracie', 'Bezants', '2020-08-17', 577934296, 'Summit', '238', '1000-139', 987443248, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bwainman1w@webs.com', 'vLdrcrmIHx', 'Bryan', 'Wainman', '1935-06-02', 797927414, 'Amoth', '80633', '4795-894', 506993721, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('hpeppard1x@un.org', 'Hto99pvB', 'Harriott', 'Peppard', '1995-01-18', 424773977, 'Mayer', '9', '4900-281', 531762826, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mnealey1z@weebly.com', 'Bjsl9QNVspCX', 'Mart', 'Nealey', '2006-06-26', 246706782, 'Oriole', '5313', '3360-139', 989578002, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tdoggrell20@exblog.jp', 'eiWBem', 'Tessi', 'Doggrell', '1983-07-28', 698888995, 'Northridge', '64108', '4900-281', 345064762, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lwilprecht21@chicagotribune.com', 'Dra8YLrK', 'Lucas', 'Wilprecht', '1985-01-16', 599752506, 'Portage', '290', '4480-330', 669654998, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('fmurfett22@umn.edu', 'QBC9X6sUOHQ', 'Franny', 'Murfett', '1928-06-29', 492212376, 'Hoepker', '92275', '4200-014', 513945335, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jregglar23@blogtalkradio.com', 'X2g9vPbT', 'Jennee', 'Regglar', '1985-04-02', 694672377, 'Waxwing', '1681', '3420-177', 787287945, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ghazleton24@ifeng.com', 'Jm0vsuIj', 'Guinna', 'Hazleton', '1928-01-07', 693414557, 'Eastlawn', '50570', '4795-894', 554627317, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mbrownsea25@nytimes.com', 'S3fk3X', 'Mitchel', 'Brownsea', '1947-03-09', 802962872, 'Lyons', '9', '4480-330', 485398950, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('solivier26@simplemachines.org', 'pNUwIC6', 'Shayne', 'Olivier', '1942-12-20', 893319278, 'Kinsman', '3713', '4705-480', 338482575, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cmaitland27@redcross.org', 'VZTshcK', 'Clerkclaude', 'Maitland', '1926-07-13', 781781686, 'Mosinee', '268', '7150-123', 817640633, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('edreghorn28@cloudflare.com', '2IW9VF7', 'Edmund', 'Dreghorn', '1967-08-29', 812973946, 'Manley', '04', '4705-480', 644900900, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ttrunks29@prweb.com', 'L4QrrFbqZfq', 'Timmie', 'Trunks', '1958-09-10', 835376870, 'Nevada', '4065', '4900-281', 332998624, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kkarpenko2a@dell.com', 'BQdgXQk', 'Krissie', 'Karpenko', '1959-04-05', 456707531, 'Crowley', '575', '3420-177', 222586132, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('sepiscopio2b@barnesandnoble.com', 'yZKIWPg', 'Sampson', 'Episcopio', '1987-09-29', 668207085, 'Florence', '3', '1000-139', 908662848, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('hnovis2c@hhs.gov', '6L6JlM1He', 'Hansiain', 'Novis', '1947-02-22', 640171060, 'Prairie Rose', '6', '4490-251', 766091244, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('csmissen2d@elegantthemes.com', 'L9CioQQrNC', 'Coleen', 'Smissen', '1979-07-28', 820108477, 'Mifflin', '9737', '4940-027', 827759274, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('pnotton2e@behance.net', 'HNtd1IzB', 'Pip', 'Notton', '1971-08-15', 161259875, 'Everett', '5', '4480-330', 772439147, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bredsell2g@mayoclinic.com', 'h62aUw', 'Bunni', 'Redsell', '1960-02-23', 396012129, 'Jay', '46', '4795-894', 116703854, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cblyde2h@abc.net.au', '0im6Q1VKloS', 'Catie', 'Blyde', '1982-01-06', 643614731, 'Magdeline', '84', '4940-027', 824709366, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('sreeme2i@blog.com', 'OBxcegj', 'Shawn', 'Reeme', '2006-02-12', 247338510, 'Oak', '2', '4490-251', 242449909, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kstrong2j@163.com', 'do5VnOnz6IE', 'Karil', 'Strong', '1943-03-11', 934847321, 'Del Sol', '44117', '4475-045', 907744908, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('chaton2k@wufoo.com', '4bPlwfj3a', 'Cyril', 'Haton', '1944-10-12', 795769532, 'Fordem', '07880', '4490-251', 225986899, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('gkleinhandler2l@bloglovin.com', 'F5tebOuV', 'Georg', 'Kleinhandler', '1946-12-13', 281578004, 'Heffernan', '7', '4705-480', 183532842, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('carmall2m@slashdot.org', 'ngQY1LCKvb', 'Catrina', 'Armall', '1933-04-11', 114413677, 'Manufacturers', '8', '4905-067', 813841704, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('sdiment2n@buzzfeed.com', 'FoqD5jsVkZb', 'Sharlene', 'Diment', '1970-12-08', 903048892, 'Bobwhite', '379', '2205-025', 317204058, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lamdohr2o@aboutads.info', 'FE69SGJUQ', 'Linus', 'Amdohr', '1935-03-13', 317548749, 'Summit', '11149', '4900-281', 464196618, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jbarajas2p@photobucket.com', 'POl783E', 'Joellen', 'Barajas', '1931-08-20', 376879755, 'Pepper Wood', '7', '4705-480', 517404174, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('gminico2q@cdc.gov', 'URoJTRVI', 'Gertie', 'Minico', '2006-05-17', 820449576, 'La Follette', '3', '4480-330', 788684026, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rluciani2r@theglobeandmail.com', 'SOr0gCep', 'Ruddy', 'Luciani', '1957-04-26', 558178576, 'Kim', '87919', '3360-032', 433190044, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('pcudmore2s@chicagotribune.com', 'zIJ4fmuvm', 'Perice', 'Cudmore', '1993-06-04', 711949422, 'Sheridan', '753', '4795-894', 391811205, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('dhinks2t@wired.com', 'gYt2Gtaxkl', 'Derrick', 'Hinks', '1973-05-11', 731672311, 'Loeprich', '4822', '2645-539', 357266160, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cbeattie2u@oracle.com', 'Couye1R', 'Chloette', 'Beattie', '2017-01-07', 186050361, 'Esker', '41706', '3520-039', 934094865, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('emenloe2v@skyrock.com', 'JGSQvoj', 'Erda', 'Menloe', '1979-04-16', 151349800, 'Sherman', '8823', '4940-027', 232874481, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('dpencott2x@engadget.com', 'inSJhtj', 'Dionysus', 'Pencott', '1950-09-13', 593662604, 'Golf Course', '44', '3420-177', 778993753, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bjachimczak2y@cbslocal.com', '3Nz2tnVxFz', 'Barb', 'Jachimczak', '1950-04-04', 157165618, 'Burning Wood', '02', '4940-027', 142017925, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('krobe2z@gizmodo.com', 'pgoZrN146R', 'Katlin', 'Robe', '1993-05-16', 610921837, 'Golf Course', '1', '4905-067', 950059621, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rmurfin30@ox.ac.uk', '5aB8PQ', 'Rodina', 'Murfin', '1991-07-26', 923080467, 'Rockefeller', '307', '4200-014', 785281002, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lmoscon31@statcounter.com', 'yJSinQmOdWJQ', 'Lela', 'Moscon', '1960-08-15', 778117686, 'Dottie', '1', '4795-894', 960597533, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cdegoy32@washington.edu', '6I0q723oZc17', 'Carleen', 'Degoy', '1948-05-16', 303676304, 'Eagle Crest', '4205', '4490-666', 746595713, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ehalmkin33@blogspot.com', 'NVCe3Tkx5', 'Eadith', 'Halmkin', '1963-05-01', 315885462, 'Kinsman', '16063', '4795-894', 675470081, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('nskellern34@cyberchimps.com', '3SAB53p7j', 'Nicholas', 'Skellern', '1989-09-03', 105657347, '4th', '1', '4490-666', 476775921, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mfellenor35@mozilla.com', '1OGgsbrU', 'Moshe', 'Fellenor', '1947-05-02', 858653181, 'Judy', '35', '4795-894', 730171041, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jpaolillo36@nyu.edu', '1H0sTw', 'Jody', 'Paolillo', '2006-06-26', 437415771, 'Moland', '427', '2610-181', 189164261, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tfoakes37@canalblog.com', '2SurG01o3VM2', 'Torey', 'Foakes', '1993-01-03', 280124607, 'Meadow Ridge', '49', '1000-139', 337719907, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jsmalridge38@cbsnews.com', 'aPSDtI', 'Jacklin', 'Smalridge', '1982-10-09', 938107030, 'Montana', '57901', '4480-330', 590631456, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jtracey39@google.ru', '09c1x0eKHz', 'Jeremias', 'Tracey', '2000-04-03', 972808415, 'Carpenter', '572', '4900-281', 588809029, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('carber3a@rakuten.co.jp', 'xJXC75fbf1xf', 'Carri', 'Arber', '2008-04-14', 557156585, 'Hansons', '892', '4490-251', 300534644, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lmatysik3b@plala.or.jp', 'aGNi2A', 'Logan', 'Matysik', '2003-11-06', 676327913, 'Surrey', '34', '2645-539', 828417822, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lcroote3c@360.cn', '6JuZNXYvIznK', 'Lawrence', 'Croote', '1959-07-15', 460742108, 'Dahle', '959', '3420-177', 930956948, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kmahady3d@bigcartel.com', 'LuzMUk', 'Katha', 'Mahady', '1925-01-03', 436650497, 'Dayton', '98', '4490-666', 156427593, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('fcarlin3e@mit.edu', 'PhB8FV3w', 'Freddy', 'Carlin', '1949-12-20', 950844060, 'Upham', '6', '2610-181', 400569708, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cdaintith3f@constantcontact.com', 'hq5iSuqDbOF', 'Clint', 'Daintith', '1971-06-28', 736433182, 'Kim', '963', '4200-014', 257885138, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jtomaszewicz3g@xrea.com', 'nFvEK4PQYuh', 'Jammal', 'Tomaszewicz', '1924-07-21', 618167243, 'Golf Course', '7493', '1000-139', 247027819, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tgethyn3h@posterous.com', 'C5vgUUPSk', 'Tymon', 'Gethyn', '1950-07-30', 495459415, 'Morrow', '9960', '2610-181', 202215707, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jyegorovnin3i@edublogs.org', 'jToW8kyD', 'Josephina', 'Yegorovnin', '1958-09-25', 270832728, 'Parkside', '8', '7150-123', 223760674, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('glawless3j@noaa.gov', 'i8CWHmxQoS', 'Ginny', 'Lawless', '1961-04-18', 271983681, 'Montana', '57060', '4490-666', 687313541, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('dnorthen3k@ow.ly', '4ZUTJGA', 'Dunstan', 'Northen', '1946-10-27', 764159529, 'Westridge', '60', '1000-139', 741275050, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('hkem3m@blogs.com', 'V7MSdUVr6O8q', 'Herbie', 'Kem', '1980-03-25', 359022457, 'Crowley', '249', '4490-666', 49521117, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ajersh3n@msn.com', 'chnW3J', 'Austina', 'Jersh', '1992-09-18', 218175629, 'Thompson', '13906', '4940-027', 211070348, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lecclesall3o@springer.com', 'qIevwtZ', 'Leena', 'Ecclesall', '1998-06-04', 316217228, 'Upham', '62', '4905-067', 867515396, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('abraemer3p@vimeo.com', 'fyKBO8owa', 'Ainslee', 'Braemer', '1937-10-25', 826796067, 'Briar Crest', '1525', '4480-330', 561836478, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jdaens3q@dedecms.com', 'Ii5SQcuu', 'Jacquetta', 'Daens', '1969-09-16', 175650953, 'Fieldstone', '752', '4480-330', 358896881, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('sagius3s@hao123.com', 'JObkEflysP', 'Sarina', 'Agius', '1996-04-02', 127825511, 'Ridgeway', '6952', '4490-666', 145422545, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('idemange3t@whitehouse.gov', 'W6SYXZ2C', 'Ignaz', 'Demange', '1970-02-24', 667352774, 'Harbort', '535', '4200-014', 873460165, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ngeerdts3u@scribd.com', 'f39CH8', 'Nelli', 'Geerdts', '1964-10-07', 841379863, 'Autumn Leaf', '17', '2645-539', 881930362, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('sauguste3v@webs.com', 'equX7UZkcr2', 'Saidee', 'Auguste', '1929-09-02', 886896630, 'Sunfield', '348', '3360-139', 444773229, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('twaywell3w@tmall.com', 'f17oqVjGEKaG', 'Tad', 'Waywell', '1970-10-11', 194897213, 'Bartelt', '25', '7150-123', 890813672, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('alapthorne3x@buzzfeed.com', 'vw36yUKgsN', 'Axe', 'Lapthorne', '2006-09-06', 571959030, 'Mandrake', '3831', '3420-177', 311101771, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('silson3y@stumbleupon.com', 'c8oBEcZvu', 'Sheila', 'Ilson', '1965-09-05', 847730293, 'Chive', '070', '2645-539', 609580028, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jbrando3z@goo.ne.jp', 'en1DEDt', 'Jamie', 'Brando', '1979-09-11', 662214214, 'Merry', '9', '4795-894', 298827098, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kschutze40@jiathis.com', 'jv7ARG', 'Krisha', 'Schutze', '1923-03-31', 133524440, 'Del Mar', '39381', '4795-894', 626022800, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rflattman41@acquirethisname.com', 'WRe56A', 'Rickey', 'Flattman', '1949-03-09', 158872933, 'Tennessee', '945', '3420-177', 219508673, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('wsieghart42@tinypic.com', 'VILIOH00', 'Warden', 'Sieghart', '1999-07-30', 248818494, 'Basil', '9', '4905-067', 933856826, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mwetherby43@over-blog.com', 'Wu1Pxh', 'Madalena', 'Wetherby', '2013-09-16', 249225898, 'Vermont', '0315', '4905-067', 970192963, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('btyght44@cornell.edu', '4kspQ5ZX0fzS', 'Braden', 'Tyght', '2000-07-26', 340866998, 'Westport', '4289', '7150-123', 625713063, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rlackmann45@dagondesign.com', 'dOaYyF3WKTn', 'Rosella', 'Lackmann', '1931-05-22', 464904343, 'Spenser', '7826', '3360-032', 268825068, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mbambury46@pagesperso-orange.fr', 'bgUuQyyxj26X', 'Moore', 'Bambury', '1942-02-08', 784145475, 'Mcbride', '08', '7150-123', 543600667, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('nternouth47@acquirethisname.com', 'NSFgneams45', 'Nye', 'Ternouth', '2017-01-28', 711109179, 'Dapin', '865', '4490-666', 986227786, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('pguerrin48@timesonline.co.uk', 'TRycPj', 'Palmer', 'Guerrin', '1964-10-20', 413404289, 'Caliangt', '96', '4705-480', 908424885, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bbrundrett49@posterous.com', '4MLNud9VMqL', 'Brennen', 'Brundrett', '1979-08-26', 530383392, 'Gateway', '49', '1000-139', 892564428, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('nlemoucheux4a@dmoz.org', 'JydyOXP', 'Nanci', 'Le Moucheux', '1940-12-28', 639745793, 'Parkside', '70291', '1000-139', 969047551, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('scree4b@youku.com', 'nXTLLf', 'Sarajane', 'Cree', '1955-08-09', 323283160, 'Alpine', '413', '4705-480', 680692971, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('gmatiewe4c@businessinsider.com', 'bGLXQm', 'Gaby', 'Matiewe', '1936-12-17', 192142027, 'Debra', '62', '4905-067', 940803251, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('oizon4d@gizmodo.com', 'OALZBYtZp', 'Odette', 'Izon', '1932-10-04', 671502551, 'Eagle Crest', '1', '3360-139', 946822109, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('uburren4e@nyu.edu', '4gUe9LIz', 'Uta', 'Burren', '1984-10-04', 871131438, 'Corry', '05', '4490-251', 782473850, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('wbucher4f@yale.edu', '7gvtXCPMQov', 'Wash', 'Bucher', '1942-06-16', 518278363, 'Elgar', '628', '4705-480', 892587048, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('achoppen4g@army.mil', 'bHz7GcXS6', 'Angie', 'Choppen', '1981-08-31', 909339900, 'Dovetail', '3', '3520-039', 384504892, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bmacieja4i@twitter.com', 'N8BueEL5DKGd', 'Bartlett', 'Macieja', '2007-08-22', 647435444, 'Monterey', '1596', '7150-123', 646209954, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('iolliver4j@arizona.edu', 'aEwoa7DG', 'Ilario', 'Olliver', '1968-04-10', 455742149, 'Boyd', '1', '3360-139', 719725325, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('egian4k@google.com', 'WZZMECv', 'Elke', 'Gian', '1936-01-23', 578888833, 'Arapahoe', '13', '3420-177', 117148753, 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jniblett4l@devhub.com', 'BuZyqQ1Tsd7', 'Jamie', 'Niblett', '1969-11-26', 334635454, 'Carey', '82456', '4905-067', 611562011, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lanear4m@earthlink.net', 'ocDBzdRQJ9', 'Lil', 'Anear', '1926-06-23', 640509303, 'Pankratz', '7517', '3420-177', 614628466, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('edeclerc4n@psu.edu', 'y5OJp7Gx', 'Erin', 'de Clerc', '1924-09-24', 313090351, 'Beilfuss', '07197', '4795-894', 617409542, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('hgingle4o@multiply.com', 'msDS3T4xG48', 'Hale', 'Gingle', '1976-03-23', 959084788, 'Brentwood', '58', '4795-894', 617951847, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rcant4p@chronoengine.com', 'H2ekTQGBaZbh', 'Rooney', 'Cant', '1977-05-05', 719945681, 'Lighthouse Bay', '41177', '4705-480', 193811557, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cgouny4q@ocn.ne.jp', '5vlq8IX', 'Cole', 'Gouny', '1932-01-23', 212083050, 'Gerald', '520', '4940-027', 128087605, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ldevaan4r@list-manage.com', '2yZ04Pmn', 'Louis', 'De Vaan', '1960-12-13', 238013732, 'Talmadge', '90557', '3360-032', 305002803, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lkensy4s@behance.net', 'cRmzObfIOxNq', 'Lida', 'Kensy', '1961-10-16', 112760745, 'Fallview', '19046', '7150-123', 199093933, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('selan4t@sciencedirect.com', 'zo1IeF1ck', 'Starlin', 'Elan', '2005-08-10', 189419459, 'Butternut', '2', '4905-067', 653291369, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('vfenne4u@fc2.com', 'SIV4f0', 'Viola', 'Fenne', '1946-12-28', 758777394, 'Northport', '6', '4475-045', 16961702, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('fguitonneau4v@cyberchimps.com', 'YSX3T8NA', 'Fernande', 'Guitonneau', '1966-04-15', 478378800, 'Holmberg', '637', '4940-027', 163856336, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('karthy4x@newsvine.com', '3S4E6nJqJ', 'Kathlin', 'Arthy', '1926-03-04', 970268007, 'Schmedeman', '8', '2610-181', 510492962, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jseago4y@geocities.jp', 'fhp31y9s', 'Janene', 'Seago', '1999-03-23', 978540943, 'Helena', '9369', '1000-139', 171128138, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kbattram4z@nih.gov', 'JTdVAfdkGj', 'Kaylil', 'Battram', '2000-10-02', 870356010, 'Menomonie', '997', '1000-139', 167956830, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cstarzaker50@fastcompany.com', 'N0Wc6oHm23p', 'Curr', 'Starzaker', '1968-08-18', 198329335, 'Butternut', '811', '4795-894', 334757180, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('dquye51@dot.gov', 'a6vxCV', 'Dion', 'Quye', '1984-04-26', 859137697, 'Golf Course', '8766', '4705-480', 681936757, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jstreater52@shareasale.com', 'BkEz7lun', 'Jami', 'Streater', '1947-05-01', 373702898, 'Rockefeller', '740', '4490-666', 728046851, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('apeiser53@smh.com.au', 'eor42B', 'Andi', 'Peiser', '1982-07-08', 403634077, 'West', '997', '4480-330', 346187119, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('aagutter54@paginegialle.it', 'IPusak15P3lA', 'Abbot', 'Agutter', '1973-12-13', 349555650, 'Buena Vista', '92', '4940-027', 302606900, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ckirkhouse55@webs.com', 'g4iTtP', 'Clementius', 'Kirkhouse', '1950-10-03', 479064247, 'Carioca', '79412', '3040-474', 538069474, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bgrossier56@reddit.com', 'j7AIdanwS', 'Barth', 'Grossier', '2015-11-08', 255649335, 'Westridge', '2', '7150-123', 365642237, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('estanyon57@china.com.cn', '63SiS14D', 'Ezechiel', 'Stanyon', '2003-05-27', 688184674, 'Independence', '124', '4490-666', 571204746, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mgrindall58@xinhuanet.com', 'WqglVWD', 'Montague', 'Grindall', '1961-09-21', 643313571, 'Oxford', '8', '1000-139', 524924830, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('sgarred59@buzzfeed.com', 'cBAC1l', 'Sanders', 'Garred', '1999-05-19', 918403000, 'Dayton', '73', '3360-032', 956983833, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('gspurden5a@yellowpages.com', 'Orr1AI5ljAD', 'Gram', 'Spurden', '1945-10-05', 274940858, 'Dorton', '5', '4200-014', 412621223, 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('huebel5b@g.co', 'scvVpwImsITO', 'Hillier', 'Uebel', '1953-12-16', 502051250, 'Waxwing', '6', '3360-139', 279204383, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lloveridge5d@engadget.com', 'aJGVI6HWQ', 'Lynnet', 'Loveridge', '1946-08-04', 123086779, 'Nelson', '8395', '2610-181', 123281924, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('pcaneo5f@nytimes.com', 'lgnfC1', 'Philippe', 'Caneo', '2012-07-25', 888731376, 'Hollow Ridge', '2710', '2205-025', 491117111, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mskedgell5g@yellowpages.com', 'a7v4PYxdiE', 'Marlyn', 'Skedgell', '2019-02-02', 439236686, 'Continental', '81135', '2205-025', 737149715, 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jkosiada5h@freewebs.com', 'zVMO2mp3uH', 'Jacquelin', 'Kosiada', '1933-07-13', 487064513, 'School', '57', '3360-139', 781024876, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kbillborough5i@engadget.com', 'ISdZrT', 'Kai', 'Billborough', '1933-10-13', 128047992, 'Fairfield', '603', '2645-539', 540030825, 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bpeyto5j@opensource.org', 'wv5Q5VRC', 'Barbara-anne', 'Peyto', '1956-08-06', 429319530, 'Hoffman', '1', '4200-014', 533907927, 3);

insert into Driver (id, has_adr, has_cam, cc, is_working) values (1, false, false, 89045186, false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (2, true, false, 54414452, true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (3, true, true, 84114731, false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (4, false, false, 83140382, false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (5, true, true, 69864970, false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (6, false, true, 12522769, true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (7, false, false, 14679470, true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (8, false, true, 25765122, false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (9, false, true, 71094986, false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (10, false, false, 35262875, true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (11, true, true, 21268753, false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (12, false, true, 75791320, true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (13, false, false, 25453804, true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (14, true, true, 95577104, false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (15, false, true, 73227330, true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (16, true, false, 59633937, false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (17, true, false, 81622565, true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (18, false, true, 50033224, true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (19, false, false, 52058087, false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (20, false, true, 41675874, true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (21, false, true, 54194947, false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (22, true, true, 74998897, true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (23, false, true, 69219872, true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (24, false, true, 67734477, false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (25, true, false, 38382875, true);

insert into Invoice (price_without_vat, price_with_vat, payment_date, nif, street, port, payment_method, postal_code) VALUES (9000.50, 11070.62, NULL, '119048328', 'Eastwood', '9', NULL, '1000-139');
insert into Invoice (price_without_vat, price_with_vat, payment_date, nif, street, port, payment_method, postal_code) VALUES (1200.50, 1476.62, '2024-05-11', '715277279', 'Orin', '19736', 1, '4480-330');
insert into Invoice (price_without_vat, price_with_vat, payment_date, nif, street, port, payment_method, postal_code) VALUES (15000.00, 18450.00, NULL, 715373426, 'Walton', '7', NULL, '4940-027');
insert into Invoice (price_without_vat, price_with_vat, payment_date, nif, street, port, payment_method, postal_code) VALUES (6500.75, 7995.92, NULL, '455104181', 'Chinook', '5263', NULL, '4200-014');

INSERT INTO Brand (name) VALUES ('Iveco');
INSERT INTO Brand (name) VALUES ('Scania');
INSERT INTO Brand (name) VALUES ('Man');
INSERT INTO Brand (name) VALUES ('Volvo');
INSERT INTO Brand (name) VALUES ('Renault');
INSERT INTO Brand (name) VALUES ('Ford');
INSERT INTO Brand (name) VALUES ('Mercedes');
INSERT INTO Brand (name) VALUES ('EduCargas');

INSERT INTO Model (name, launch_date, brand) VALUES ('Actros L', '2021-07-01', 7);
INSERT INTO Model (name, launch_date, brand) VALUES ('Actros F', '2021-01-01', 7);
INSERT INTO Model (name, launch_date, brand) VALUES ('Actros', '1996-05-21', 7);
INSERT INTO Model (name, launch_date, brand) VALUES ('S-WAY', '2022-11-26', 1);
INSERT INTO Model (name, launch_date, brand) VALUES ('S-WAY Gas', '2022-11-30', 1);
INSERT INTO Model (name, launch_date, brand) VALUES ('V8', '2010-04-12', 2);
INSERT INTO Model (name, launch_date, brand) VALUES ('Linha S', '2014-07-25', 2);
INSERT INTO Model (name, launch_date, brand) VALUES ('Linha R', '2005-08-15', 2);
INSERT INTO Model (name, launch_date, brand) VALUES ('TGX', '2022-03-11', 3);
INSERT INTO Model (name, launch_date, brand) VALUES ('TGS', '2022-03-11', 3);
INSERT INTO Model (name, launch_date, brand) VALUES ('Tdg', '2022-03-11', 3);
INSERT INTO Model (name, launch_date, brand) VALUES ('Volvo FH', '1993-03-15', 4);
INSERT INTO Model (name, launch_date, brand) VALUES ('Volvo FM', '1998-08-11', 4);
INSERT INTO Model (name, launch_date, brand) VALUES ('T High', '2013-06-13', 5);
INSERT INTO Model (name, launch_date, brand) VALUES ('F-Max', '2018-04-17', 6);
INSERT INTO Model (name, launch_date, brand) VALUES ('Standard', '2000-04-17', 8);
INSERT INTO Model (name, launch_date, brand) VALUES ('Open Top', '2000-04-17', 8);

insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('R2-73-Z9', 961.22, 300, 882, 'Maroon', 9017979.0, true, 15, 4);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('N2-13-W8', 527.87, 476, 271, 'Fuscia', 6934303.64, true, 15, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('K2-83-L5', 128.2, 229, 845, 'Goldenrod', 4355397.0, false, 8, 7);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('T2-93-P5', 307.55, 486, 321, 'Green', 8237932.0, false, 5, 1);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('B2-83-T4', 868.43, 808, 401, 'Teal', 4083162.85, true, 7, 3);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('N2-23-N9', 543.36, 230, 481, 'Red', 2465837.0, true, 14, 7);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('X2-33-F6', 597.54, 698, 654, 'Red', 3127583.46, true, 6, 7);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('V2-23-V4', 928.06, 370, 402, 'Maroon', 8936434.0, true, 2, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('Y2-53-K9', 530.61, 414, 167, 'Crimson', 3056864.0, false, 10, 7);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('Y2-03-T7', 990.39, 853, 461, 'Purple', 2412497.52, true, 11, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('X2-63-U5', 367.34, 208, 805, 'Fuscia', 8952230.0, true, 3, 2);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('L2-73-R0', 574.09, 278, 155, 'Green', 2629561.8, false, 2, 3);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('R2-23-R9', 598.07, 839, 943, 'Blue', 7412737.15, false, 4, 3);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('S2-33-P4', 338.25, 939, 116, 'Puce', 1112285.4, true, 5, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('K2-23-H5', 746.91, 819, 917, 'Maroon', 4120410.43, true, 11, 4);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('I2-93-J7', 860.75, 599, 294, 'Violet', 2161733.42, true, 13, 5);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('U2-03-I8', 510.76, 936, 851, 'Mauv', 5233755.7, true, 10, 1);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('J2-23-L7', 418.48, 797, 423, 'Pink', 2599367.8, true, 5, 1);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('Y2-43-U9', 473.6, 193, 738, 'Teal', 7122557.0, true, 12, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('R2-23-K2', 856.64, 275, 147, 'Khaki', 6751510.0, true, 17, 2);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('U2-83-R7', 130.15, 544, 933, 'Orange', 3730531.0, true, 4, 6);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('W2-03-Q2', 461.81, 396, 357, 'Green', 5034399.0, false, 15, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('W2-83-I6', 653.64, 522, 939, 'Green', 5390037.0, false, 2, 7);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('J2-63-V8', 505.67, 863, 248, 'Maroon', 3524214.46, false, 13, 4);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('I2-33-M5', 832.49, 240, 558, 'Red', 7166072.0, false, 5, 7);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('Q2-53-O3', 823.78, 625, 578, 'Puce', 6179331.0, true, 11, 7);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('P2-43-N7', 416.75, 330, 836, 'Yellow', 2360439.22, true, 7, 1);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('F2-63-Y0', 850.18, 590, 454, 'Goldenrod', 1319116.59, true, 12, 3);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('N2-23-R0', 895.5, 436, 865, 'Goldenrod', 1916732.46, false, 6, 1);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('M2-93-D1', 312.56, 867, 925, 'Aquamarine', 9361372.0, true, 6, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('W2-43-Q4', 326.28, 893, 963, 'Aquamarine', 6990412.0, false, 7, 3);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('E2-83-K9', 994.5, 815, 576, 'Puce', 1168175.0, false, 1, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('K2-13-Y3', 969.05, 705, 373, 'Teal', 7192109.45, false, 6, 7);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('O2-43-C0', 823.94, 700, 738, 'Red', 6210781.51, true, 14, 5);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('U2-33-W4', 957.99, 707, 873, 'Crimson', 4665429.0, true, 14, 7);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('I2-23-C3', 401.17, 566, 395, 'Green', 7985527.56, false, 9, 2);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('F2-23-G5', 436.23, 924, 503, 'Blue', 6035765.0, false, 10, 3);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('J2-23-S0', 772.57, 468, 649, 'Puce', 6614175.63, true, 1, 2);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('M2-53-R1', 253.68, 406, 901, 'Purple', 9466556.0, true, 1, 2);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('E2-83-H2', 703.24, 727, 744, 'Maroon', 3876982.78, true, 1, 3);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('O2-83-U1', 406.85, 699, 454, 'Pink', 1380384.42, false, 1, 6);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('S2-03-J4', 407.71, 240, 990, 'Goldenrod', 6208515.55, true, 16, 6);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('I2-53-Y5', 845.93, 561, 689, 'Green', 4462376.51, true, 9, 4);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('M2-33-Z9', 968.61, 849, 755, 'Yellow', 6375884.23, false, 16, 1);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('I2-53-Z4', 295.88, 969, 767, 'Indigo', 1047448.0, true, 11, 7);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('Y2-33-P6', 787.92, 425, 320, 'Indigo', 1348134.87, false, 11, 6);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('Y2-73-G7', 276.07, 860, 770, 'Pink', 7673029.0, true, 9, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('N2-43-H9', 846.88, 179, 722, 'Pink', 3387025.67, false, 9, 2);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('S2-93-S2', 893.56, 710, 618, 'Teal', 9874138.0, true, 4, 6);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('X2-83-C2', 218.92, 346, 428, 'Orange', 6149784.0, false, 1, 5);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('Z2-33-U5', 395.36, 832, 115, 'Blue', 3032613.93, false, 4, 4);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('Y2-93-S7', 874.75, 193, 323, 'Violet', 5308712.37, false, 5, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('A2-83-Z8', 670.53, 788, 466, 'Maroon', 1289394.64, true, 12, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('N2-33-Z8', 282.37, 455, 270, 'Indigo', 9103412.0, false, 8, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('M2-33-Y0', 948.54, 118, 743, 'Violet', 3334156.98, true, 4, 1);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('Y2-93-Y5', 685.9, 243, 482, 'Khaki', 9595699.0, true, 15, 1);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('A2-13-L3', 881.8, 564, 208, 'Purple', 5741175.22, true, 5, 5);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('P2-73-P3', 754.2, 535, 359, 'Pink', 2444647.0, false, 6, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('I2-83-V8', 118.65, 344, 133, 'Yellow', 1726443.69, true, 5, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('Y2-93-F7', 936.85, 974, 629, 'Crimson', 5423987.0, false, 14, 3);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('V2-43-H4', 996.96, 936, 643, 'Khaki', 3077120.64, false, 9, 4);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('D2-33-C8', 766.27, 493, 426, 'Orange', 5406779.0, false, 13, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('B2-33-S2', 766.61, 347, 460, 'Blue', 7891200.0, true, 5, 3);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('M2-33-M7', 255.48, 643, 123, 'Puce', 3730737.4, false, 13, 7);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('D2-13-T6', 421.34, 137, 949, 'Crimson', 3053793.03, true, 7, 1);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('W2-43-O5', 628.55, 989, 379, 'Teal', 4540731.0, true, 11, 1);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('K2-03-T6', 112.51, 946, 664, 'Purple', 5255942.11, true, 4, 4);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('G2-93-I1', 351.93, 210, 992, 'Teal', 3969969.0, true, 3, 6);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('F2-53-T0', 191.72, 672, 474, 'Blue', 7355553.41, true, 11, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('S2-53-J0', 922.61, 292, 863, 'Indigo', 4220843.0, false, 17, 2);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('Q2-53-I9', 695.32, 584, 902, 'Pink', 1252168.7, false, 12, 8);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('H2-53-E8', 702.34, 926, 841, 'Mauv', 3047800.64, true, 14, 4);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('F2-13-I4', 910.03, 304, 926, 'Turquoise', 8237260.0, false, 13, 5);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('Z2-03-L1', 981.25, 360, 277, 'Teal', 9761528.0, false, 7, 7);
insert into Container (license, width, length, depth, color, max_supported_weight, is_in_use, model, type) values ('T2-53-G4', 122.76, 445, 860, 'Indigo', 5332231.88, false, 8, 1);

insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('G2-73-O1', 980, 675, 'Turquoise', 16543.84, false, 10, 54, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('C2-43-H1', 640, 400, 'Fuscia', 5725.39, true, 7, 67, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('V2-03-N1', 553, 467, 'Puce', 34714.8, false, 16, 193, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('C2-03-D1', 203, 885, 'Teal', 6459.39, true, 10, 22, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('L2-53-R1', 757, 388, 'Crimson', 17487.81, false, 1, 143, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('C2-33-Y1', 689, 725, 'Indigo', 36747.46, false, 2, 152, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('S2-03-Z1', 411, 436, 'Indigo', 12173.26, false, 11, 60, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('Z2-63-L1', 942, 353, 'Pink', 10416.74, true, 12, 91, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('P2-03-K1', 493, 630, 'Red', 17359.8, true, 12, 206, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('E2-03-V1', 773, 812, 'Yellow', 32376.6, false, 17, 123, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('D2-33-C1', 852, 880, 'Violet', 31871.67, true, 17, 90, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('S2-93-E1', 927, 566, 'Yellow', 28129.45, true, 4, 115, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('V2-53-V1', 107, 970, 'Crimson', 545.39, false, 13, 141, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('M2-63-F1', 317, 162, 'Khaki', 36721.23, false, 16, 157, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('M2-63-G1', 812, 711, 'Goldenrod', 10166.45, false, 1, 131, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('V2-43-W1', 220, 687, 'Puce', 30281.58, false, 4, 69, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('S2-13-C1', 199, 974, 'Indigo', 14391.73, false, 10, 89, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('B2-13-U1', 300, 120, 'Puce', 41506.74, false, 8, 180, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('T2-03-S1', 524, 591, 'Yellow', 7059.31, false, 1, 200, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('Z2-43-M1', 396, 886, 'Aquamarine', 46673.41, true, 4, 135, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('K2-33-M1', 419, 832, 'Orange', 38854.96, true, 11, 102, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('S2-33-H1', 378, 240, 'Purple', 48033.52, false, 10, 233, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('M2-63-M1', 450, 958, 'Maroon', 38038.51, false, 6, 41, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('C2-53-T1', 493, 398, 'Pink', 32883.47, true, 11, 61, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('W2-23-W1', 260, 178, 'Maroon', 11495.96, true, 1, 71, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('P2-43-R1', 394, 329, 'Goldenrod', 21795.0, false, 3, 177, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('Y2-83-W1', 897, 610, 'Teal', 21011.16, false, 17, 62, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('Z2-93-P1', 490, 678, 'Violet', 42054.7, false, 1, 132, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('Q2-03-G1', 866, 642, 'Teal', 12442.34, false, 3, 130, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('C2-93-P1', 647, 619, 'Crimson', 17306.45, true, 7, 106, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('V2-83-J1', 642, 236, 'Purple', 19072.59, true, 12, 186, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('P2-43-Y1', 370, 941, 'Teal', 19386.71, false, 6, 123, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('H2-53-E1', 133, 145, 'Orange', 34906.39, true, 9, 61, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('S2-53-C1', 353, 133, 'Orange', 37062.25, false, 9, 215, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('A2-53-A1', 281, 779, 'Indigo', 29157.9, false, 11, 81, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('Y2-23-P1', 279, 459, 'Yellow', 13657.8, true, 16, 223, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('H2-33-T1', 130, 461, 'Khaki', 48665.13, true, 6, 12, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('R2-63-A1', 741, 748, 'Orange', 4992.13, true, 7, 82, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('G2-53-L1', 477, 891, 'Violet', 47185.61, true, 11, 129, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('Q2-93-Z1', 188, 479, 'Orange', 24976.55, false, 14, 152, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('B2-33-L1', 506, 522, 'Khaki', 45986.24, true, 14, 240, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('J2-83-H1', 631, 361, 'Yellow', 1551.22, true, 12, 200, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('T2-03-P1', 453, 197, 'Aquamarine', 34572.18, false, 6, 2, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('D2-73-M1', 675, 176, 'Violet', 17001.02, true, 14, 214, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('E2-63-R1', 908, 524, 'Red', 21330.36, true, 13, 237, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('D2-33-Q1', 996, 359, 'Green', 15384.51, true, 17, 195, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('S2-83-P1', 254, 243, 'Pink', 35936.31, true, 15, 144, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('Z2-33-E1', 704, 427, 'Maroon', 12717.71, false, 4, 222, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('R2-63-C1', 974, 975, 'Yellow', 28196.47, true, 14, 117, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('T2-63-X1', 225, 319, 'Turquoise', 27777.04, true, 17, 179, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('W2-23-H1', 369, 304, 'Fuscia', 26037.6, true, 1, 2, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('D2-43-B1', 445, 693, 'Turquoise', 4485.15, false, 13, 52, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('K2-73-V1', 653, 264, 'Blue', 25740.35, true, 10, 25, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('E2-23-Q1', 898, 914, 'Fuscia', 48239.0, false, 11,  88, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('P2-83-N1', 817, 114, 'Yellow', 21499.89, true, 16, 70, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('A2-03-D1', 369, 314, 'Orange', 48366.32, true, 13,  12, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('W2-73-J1', 376, 157, 'Green', 12060.83, false, 2, 50, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('B2-43-P1', 892, 222, 'Green', 30027.73, true, 4, 31, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('Z2-13-O1', 616, 676, 'Turquoise', 40701.91, true, 3, 9, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('A2-83-J1', 842, 349, 'Pink', 4439.66, true, 14, 216, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('H2-73-U1', 409, 211, 'Turquoise', 3941.96, false, 4, 3, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('G2-13-G1', 846, 662, 'Crimson', 7602.1, false, 1, 82, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('G2-83-D1', 793, 885, 'Green', 29724.5, false,  1, 86, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('E2-23-L1', 166, 810, 'Orange', 43932.98, true, 15, 134, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('V2-03-W1', 598, 734, 'Maroon', 30417.93, true, 13, 104, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('O2-73-J1', 752, 881, 'Mauv', 21901.55, false, 3, 159, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('X2-43-M1', 987, 906, 'Purple', 18818.53, true, 9, 119, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('X2-93-R1', 393, 177, 'Goldenrod', 47341.67, true, 7, 12, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('I2-73-U1', 323, 337, 'Indigo', 41533.26, true, 17, 54, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('L2-73-F1', 169, 509, 'Mauv', 4792.6, true, 4, 32, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('M2-63-U1', 833, 516, 'Khaki', 46955.55, true, 2, 188, 3);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('Q2-93-R1', 189, 802, 'Goldenrod', 49648.9, true, 9, 17, 2);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('S2-63-P1', 797, 727, 'Teal', 36825.31, true, 1, 193, 4);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('P2-03-P1', 297, 353, 'Teal', 30762.21, true, 8, 172, 1);
insert into Vehicle (license, power, displacement, color, max_supported_weight, is_in_use, model, tank, fuel) values ('J2-73-M1', 118, 565, 'Red', 47825.73, false, 17, 122, 3);

insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (false, false, 6864424, '1/3/2025', '32138', '4200-014', 'Rieder', '30', 'Clyde Gallagher', 188645.72, 'J2-23-L7', 'I2-53-Y5', 'Z2-63-L1', 64, NULL, '4900-281');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (false, false, 8478072, '11/29/2025', '411', '3420-177', 'Morningstar', '1', 'Canary', 139717.17, 'Z2-33-U5', 'K2-83-L5', 'A2-83-J1', 35, 1, '4940-027');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (false, true, 2318309, '8/13/2024', '95121', '4490-251', 'Stuart', '5', 'Fair Oaks', 194567.71, 'N2-43-H9', 'Y2-53-K9', 'T2-03-S1', 38, 2, '2610-181');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (false, false, 2875034, '2/7/2026', '52', '4705-480', 'Trailsway', '58', 'Continental', 124905.81, 'F2-63-Y0', 'I2-83-V8', 'E2-23-L1', 59, NULL, '4200-014');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (false, false, 6280363, '8/10/2025', '79', '7150-123', 'Southridge', '10', 'Warrior', 66088.15, 'U2-03-I8', 'L2-73-R0', 'G2-73-O1', 55, NULL, '4705-480');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (true, false, 6120764, '6/29/2024', '59', '4900-281', 'Kingsford', '22664', 'Straubel', 165150.55, 'B2-33-S2', 'Y2-53-K9', 'X2-43-M1', 58, NULL, '3420-177');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (false, true, 9207649, '6/20/2024', '305', '4475-045', 'Northwestern', '236', 'Messerschmidt', 152754.14, 'W2-43-Q4', 'R2-23-K2', 'S2-13-C1', 68, NULL, '4475-045');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (true, true, 5430160, '6/5/2025', '64148', '4490-251', 'Haas', '6921', 'Killdeer', 170719.99, 'R2-73-Z9', 'Y2-73-G7', 'B2-13-U1', 32, NULL, '3420-177');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (false, false, 3457818, '1/9/2026', '80', '4475-045', 'Buhler', '23527', 'Warbler', 88729.78, 'W2-43-Q4', 'B2-83-T4', 'S2-63-P1', 59, 3, '4940-027');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (false, false, 7276042, '3/14/2025', '396', '4200-014', 'Crownhardt', '670', 'Messerschmidt', 124479.68, 'D2-33-C8', 'W2-43-O5', 'V2-03-N1', 75, NULL, '1000-139');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (true, true, 1038671, '10/26/2024', '74', '3040-474', 'Village Green', '6', 'Ryan', 192723.18, 'H2-53-E8', 'W2-43-Q4', 'A2-03-D1', 36, NULL, '4900-281');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (true, false, 6330370, '10/3/2024', '38310', '2610-181', 'Hooker', '33399', 'Cottonwood', 188790.44, 'D2-33-C8', 'Y2-93-F7', 'W2-23-H1', 38, NULL, '4905-067');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (true, false, 1843130, '1/30/2026', '0', '3040-474', 'Ridge Oak', '38', 'Hauk', 121160.77, 'Y2-43-U9', 'R2-73-Z9', 'P2-83-N1', 55, NULL, '4475-045');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (false, true, 7730196, '8/19/2024', '2', '4900-281', 'Manitowish', '2790', 'Victoria', 90704.04, 'R2-23-R9', 'W2-03-Q2', 'B2-33-L1', 68, NULL, '4705-480');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (true, false, 7688895, '5/18/2025', '1', '2205-025', 'Bellgrove', '406', 'Pond', 85234.12, 'I2-33-M5', 'I2-93-J7', 'S2-83-P1', 55, NULL, '4900-281');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (true, true, 8639081, '11/10/2024', '5117', '3360-032', 'Trailsway', '1744', 'Hintze', 182129.05, 'Q2-53-O3', 'Z2-03-L1', 'P2-03-K1', 55, 4, '4900-281');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (false, false, 9554025, '10/14/2025', '071', '1000-139', 'Coleman', '9', 'Porter', 167884.88, 'I2-83-V8', 'A2-13-L3', 'O2-73-J1', 50, NULL, '4475-045');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (false, true, 9362522, '7/7/2025', '9528', '1000-139', 'Carey', '2', 'Fremont', 96364.42, 'P2-73-P3', 'N2-33-Z8', 'O2-73-J1', 54, NULL, '3420-177');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (true, false, 9515452, '8/19/2025', '68219', '2645-539', 'Melrose', '94', 'Erie', 23687.24, 'N2-43-H9', 'N2-23-N9', 'S2-03-Z1', 26, NULL, '4475-045');
insert into Request (truck_availability, container_availability, cargo_weight, deadline, port_dest, postal_code_dest, street_dest, port_ori, street_ori, delivery_price, container_license, container_license_second, license, client, invoice, postal_code_ori) values (true, true, 9016718, '4/7/2024', '82511', '4490-666', 'Homewood', '601', 'Montana', 109557.63, 'A2-13-L3', 'I2-93-J7', 'H2-53-E1', 68, NULL, '4905-067');

insert into DriverGroup (request, driver, kilometers) values (20, 14, 1241594);
insert into DriverGroup (request, driver, kilometers) values (3, 21, 6362356);
insert into DriverGroup (request, driver, kilometers) values (1, 11, 8834998);
insert into DriverGroup (request, driver, kilometers) values (6, 21, 3130463);
insert into DriverGroup (request, driver, kilometers) values (1, 2, 1221144);
insert into DriverGroup (request, driver, kilometers) values (4, 3, 4321103);
insert into DriverGroup (request, driver, kilometers) values (8, 16, 2232875);
insert into DriverGroup (request, driver, kilometers) values (1, 6, 7899696);
insert into DriverGroup (request, driver, kilometers) values (6, 5, 4594762);
insert into DriverGroup (request, driver, kilometers) values (19, 5, 3224492);
insert into DriverGroup (request, driver, kilometers) values (18, 1, 6233086);
insert into DriverGroup (request, driver, kilometers) values (5, 12, 2757319);
insert into DriverGroup (request, driver, kilometers) values (2, 3, 3772751);
insert into DriverGroup (request, driver, kilometers) values (5, 25, 9893794);
insert into DriverGroup (request, driver, kilometers) values (11, 17, 3467741);
insert into DriverGroup (request, driver, kilometers) values (16, 10, 3320824);
insert into DriverGroup (request, driver, kilometers) values (4, 10, 4178506);
insert into DriverGroup (request, driver, kilometers) values (19, 15, 5777494);
insert into DriverGroup (request, driver, kilometers) values (12, 14, 7248777);
insert into DriverGroup (request, driver, kilometers) values (7, 25, 8177975);

insert into HistoricState (start_date, state, request, guest) values ('2025-05-20', 5, 2, 29);
insert into HistoricState (start_date, state, request, guest) values ('2023-10-24', 1, 3, 26);
insert into HistoricState (start_date, state, request, guest) values ('2023-03-13', 5, 14, 66);
insert into HistoricState (start_date, state, request, guest) values ('2023-11-02', 2, 3, 75);
insert into HistoricState (start_date, state, request, guest) values ('2023-10-01', 5, 10, 28);
insert into HistoricState (start_date, state, request, guest) values ('2025-06-25', 5, 5, 72);
insert into HistoricState (start_date, state, request, guest) values ('2023-12-17', 1, 3, 36);
insert into HistoricState (start_date, state, request, guest) values ('2023-02-28', 5, 6, 40);
insert into HistoricState (start_date, state, request, guest) values ('2025-06-10', 5, 20, 71);
insert into HistoricState (start_date, state, request, guest) values ('2022-05-11', 5, 16, 34);
insert into HistoricState (start_date, state, request, guest) values ('2025-02-09', 1, 16, 27);
insert into HistoricState (start_date, state, request, guest) values ('2022-12-24', 5, 9, 55);
insert into HistoricState (start_date, state, request, guest) values ('2023-07-23', 5, 7, 42);
insert into HistoricState (start_date, state, request, guest) values ('2024-03-17', 1, 12, 26);
insert into HistoricState (start_date, state, request, guest) values ('2024-10-04', 2, 16, 61);
insert into HistoricState (start_date, state, request, guest) values ('2025-07-31', 1, 6, 40);
insert into HistoricState (start_date, state, request, guest) values ('2022-11-08', 4, 3, 45);
insert into HistoricState (start_date, state, request, guest) values ('2024-06-05', 5, 8, 33);
insert into HistoricState (start_date, state, request, guest) values ('2024-12-23', 1, 10, 48);
insert into HistoricState (start_date, state, request, guest) values ('2025-05-09', 5, 13, 49);
insert into HistoricState (start_date, state, request, guest) values ('2022-03-08', 1, 16, 64);
insert into HistoricState (start_date, state, request, guest) values ('2025-07-17', 3, 10, 67);
insert into HistoricState (start_date, state, request, guest) values ('2024-09-17', 1, 9, 48);
insert into HistoricState (start_date, state, request, guest) values ('2022-08-24', 1, 6, 69);
insert into HistoricState (start_date, state, request, guest) values ('2025-07-20', 1, 6, 54);
insert into HistoricState (start_date, state, request, guest) values ('2024-06-29', 1, 7, 26);
insert into HistoricState (start_date, state, request, guest) values ('2023-04-14', 5, 19, 29);
insert into HistoricState (start_date, state, request, guest) values ('2025-05-12', 1, 2, 38);
insert into HistoricState (start_date, state, request, guest) values ('2024-10-06', 4, 16, 34);
insert into HistoricState (start_date, state, request, guest) values ('2025-03-15', 4, 9, 47);
insert into HistoricState (start_date, state, request, guest) values ('2023-12-09', 6, 3, 48);
insert into HistoricState (start_date, state, request, guest) values ('2023-08-23', 1, 6, 65);
insert into HistoricState (start_date, state, request, guest) values ('2024-05-11', 4, 2, 25);
insert into HistoricState (start_date, state, request, guest) values ('2025-09-25', 1, 5, 46);
insert into HistoricState (start_date, state, request, guest) values ('2023-10-22', 1, 20, 72);

insert into GuestGroup (request, guest, begin_date, exit_date) values (1, 66, '2022-11-17', '2025-10-01');
insert into GuestGroup (request, guest, begin_date, exit_date) values (17, 73, '2022-04-17', '2023-08-24');
insert into GuestGroup (request, guest, begin_date, exit_date) values (8, 58, '2023-01-13', '2025-02-05');
insert into GuestGroup (request, guest, begin_date, exit_date) values (1, 74, '2022-11-28', '2025-09-27');
insert into GuestGroup (request, guest, begin_date, exit_date) values (14, 73, '2022-05-24', '2024-06-11');
insert into GuestGroup (request, guest, begin_date, exit_date) values (2, 70, '2022-04-30', '2022-04-29');
insert into GuestGroup (request, guest, begin_date, exit_date) values (11, 72, '2022-10-09', '2022-08-15');
insert into GuestGroup (request, guest, begin_date, exit_date) values (6, 54, '2022-03-24', '2022-04-21');
insert into GuestGroup (request, guest, begin_date, exit_date) values (7, 64, '2023-01-30', '2025-07-07');
insert into GuestGroup (request, guest, begin_date, exit_date) values (17, 48, '2022-10-03', '2024-09-14');
insert into GuestGroup (request, guest, begin_date, exit_date) values (15, 32, '2022-03-31', '2025-12-12');
insert into GuestGroup (request, guest, begin_date, exit_date) values (19, 49, '2023-01-05', '2025-07-27');
insert into GuestGroup (request, guest, begin_date, exit_date) values (9, 46, '2022-09-12', '2024-03-26');
insert into GuestGroup (request, guest, begin_date, exit_date) values (5, 26, '2022-07-18', '2023-07-04');
insert into GuestGroup (request, guest, begin_date, exit_date) values (8, 55, '2022-08-18', '2023-10-19');
insert into GuestGroup (request, guest, begin_date, exit_date) values (1, 49, '2022-10-02', '2022-08-21');
insert into GuestGroup (request, guest, begin_date, exit_date) values (5, 57, '2022-03-05', '2025-09-23');
insert into GuestGroup (request, guest, begin_date, exit_date) values (20, 49, '2022-11-06', '2025-08-03');
insert into GuestGroup (request, guest, begin_date, exit_date) values (18, 67, '2022-05-18', '2023-11-13');
insert into GuestGroup (request, guest, begin_date, exit_date) values (10, 45, '2022-05-14', '2024-04-11');
insert into GuestGroup (request, guest, begin_date, exit_date) values (13, 67, '2022-07-15', '2022-05-29');
insert into GuestGroup (request, guest, begin_date, exit_date) values (12, 43, '2022-10-13', '2025-02-26');
insert into GuestGroup (request, guest, begin_date, exit_date) values (5, 52, '2022-05-24', '2022-05-27');
insert into GuestGroup (request, guest, begin_date, exit_date) values (5, 49, '2022-05-30', '2023-05-21');
insert into GuestGroup (request, guest, begin_date, exit_date) values (12, 73, '2022-12-20', '2024-06-21');
insert into GuestGroup (request, guest, begin_date, exit_date) values (11, 62, '2022-04-07', '2024-07-27');
insert into GuestGroup (request, guest, begin_date, exit_date) values (8, 26, '2022-03-07', '2024-04-09');
insert into GuestGroup (request, guest, begin_date, exit_date) values (4, 57, '2022-08-22', '2025-02-05');
insert into GuestGroup (request, guest, begin_date, exit_date) values (14, 57, '2022-07-28', '2024-06-19');
insert into GuestGroup (request, guest, begin_date, exit_date) values (10, 54, '2022-05-17', '2023-07-14');
insert into GuestGroup (request, guest, begin_date, exit_date) values (17, 49, '2022-08-11', '2023-12-20');
insert into GuestGroup (request, guest, begin_date, exit_date) values (14, 27, '2023-01-01', '2023-02-16');
insert into GuestGroup (request, guest, begin_date, exit_date) values (2, 28, '2022-08-17', '2025-07-10');
insert into GuestGroup (request, guest, begin_date, exit_date) values (5, 59, '2022-03-16', '2023-12-03');
insert into GuestGroup (request, guest, begin_date, exit_date) values (3, 29, '2023-01-08', '2024-10-07');

-- Sp to Add Client to the system
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

-- Triggers 

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
