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
    is_enabled BOOLEAN DEFAULT FALSE, 
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
    logo varchar DEFAULT NULL,
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
    company_name VARCHAR(100) DEFAULT NULL,
    truck_availability BOOLEAN DEFAULT FALSE,
    container_availability BOOLEAN DEFAULT FALSE,
    cargo_weight NUMERIC(9,2) NOT NULL CHECK(cargo_weight > 0),
    deadline DATE NOT NULL,
    port_dest INT NOT NULL,
    postal_code_dest VARCHAR(8) NOT NULL,
    street_dest VARCHAR(100) NOT NULL,
    postal_code_ori VARCHAR(8) NOT NULL,
    port_ori INT NOT NULL,
    street_ori VARCHAR(100) NOT NULL,
    delivery_price NUMERIC(9,2) NOT NULL CHECK(delivery_price > 0),
    container_license VARCHAR(11) DEFAULT NULL,
    container_license_second VARCHAR(11) DEFAULT NULL,
    license VARCHAR(8) DEFAULT NULL,
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
    start_date DATE DEFAULT now(),
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
    r.id,
    hs.state,
    r.company_name,
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
    truck.license as license,
    guest.id as client,
    inv.id as invoice,
    r.created_at
from request r
inner join PostalCode postal_dest
    on r.postal_code_dest = postal_dest.id
inner join country as country_dest
    on country_dest.id = postal_dest.country
inner join PostalCode postal_ori
    on r.postal_code_ori = postal_ori.id
inner join country as countryOri
    on countryOri.id = postal_ori.country
left join container container_first
    on container_first.license = r.container_license
left join container container_second
    on container_second.license = r.container_license_second
left join vehicle truck
    on truck.license = r.license
left join invoice inv
    on inv.id = r.invoice
inner join guest guest
    on guest.id = r.client
inner join guestType guest_type
    on guest_type.id = guest.guest_type
inner join HistoricState hs
    on hs.request = r.id
;

-- create view requestDriver
-- as select
--     ri.request_id,
--     guest.first_name || ' ' || guest.last_name as driver_full_name,
--     d.has_adr as adr,
--     d.has_cam as cam,
--     d.cc as cc,
--     d.is_working,
--     case
--         when dg.type = 'p' then 'Principal'
--         when dg.type = 'c' then 'Co-Piloto'
--     end as type,
--     dg.kilometers
-- from requestInfo ri
-- inner join DriverGroup dg
--     on ri.request_id = dg.request
-- inner join driver d
--     on d.id = dg.driver
-- inner join guest guest
--     on guest.id = d.id
-- ;

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

insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cavas.callahan@reiport-entreprise.trl', '$2a$10$325Z0JxYAjQZxviCgwlChubVUrmganbEkawJxE0pwRQOlfolWDZ7G', 'Rudyard', 'McElwee', '2002-12-25', '264619567', 'Gulseth', '36492', '3520-039', '286315192', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('david.shot@reiport-entreprise.trl', '$2a$10$AH9Wgbq/MbehSfVE7uP5DuEeY1Fvnw8z925yIm1eGmjJ6FcYOKEYq', 'Rudyard', 'McElwee', '2002-12-25', '264633567', 'Gulseth', '36492', '3520-039', '286315192', 5);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('steven.cooper@reiport-entreprise.trl', '$2a$10$XW6/v9rXA205uAXBbAKrNu0F3XSyD5KDXRSNMQwTEErljzNHVni6u', 'Rudyard', 'McElwee', '2002-12-25', '264626567', 'Gulseth', '36492', '3520-039', '286315192', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('olivia.hobberts@reiport-entreprise.trl', '$2a$10$dFnU7lKYQE.sgWNONuJrIePmnAlHtjntKsdrlHAxWiT7m2zIU0jiK', 'Rudyard', 'McElwee', '2002-12-25', '264621567', 'Gulseth', '36492', '3520-039', '286315192', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rmcelwee0@domainmarket.com', '$2b$12$iYoLoV5aWgfaH/2ReX7g0OvI/C5r548eMFQuJRTnlnrXgn2OYPwpe', 'Rudyard', 'McElwee', '2002-12-25', '264620567', 'Gulseth', '36492', '3520-039', '286315192', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kredmile1@psu.edu', '$2b$12$0BvZ00VCifMhILm3ArjRrOM0k.108xOKLNRekYRyzJNpqkbE7JnPy', 'Kippie', 'Redmile', '2009-07-22', '826161141', 'Garrison', '50890', '1000-139', '104547699', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('nchishull2@chronoengine.com', '$2b$12$IATx04TNbPf0KCG72OmHbe/o32Ib2L.qMzvsB/CAViI7kR2qn8fpi', 'Naoma', 'Chishull', '1977-12-20', '259290654', 'Bluejay', '12122', '3420-177', '284883167', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bduffan3@xing.com', '$2b$12$8ALZAS5//aiWC64MQ0bLOuG8PvHEBzWLB78Rtff7enBYyuifJB7Xy', 'Bo', 'Duffan', '1987-05-29', '485383577', 'David', '4', '7150-123', '850461106', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('stimewell4@thetimes.co.uk', '$2b$12$Gbe34..xcgk/VvbsZ3rc/OaesuL//x.9zS3bCC0QP9Yxre3EHlaXC', 'Skipp', 'Timewell', '1968-07-20', '129335414', 'Stoughton', '97719', '4490-666', '928042769', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lkarslake5@hexun.com', '$2b$12$zAa5CK5NVROM21QiCZh1x.o5CJ/uMchy3M0msCHAq1ANgsdxLWkrm', 'Lanie', 'Karslake', '1925-09-17', '614762132', 'Logan', '15641', '4705-480', '402161575', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rlekeux6@wsj.com', '$2b$12$u4KjBmHctkdHwy5imnjV9evJsCBzHc3PaXYMZImabZgqEAYqpR0xu', 'Ronny', 'le Keux', '2007-09-07', '997046544', 'Tomscot', '0', '2645-539', '640536707', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mhuntingford7@uiuc.edu', '$2b$12$VnaDEiYEaSEsIXRJ20X3iuLzxH10uL0ghN02i9WAkAc5TYV7uQ0Tq', 'Marchelle', 'Huntingford', '1998-12-21', '654211380', 'Everett', '6', '1000-139', '578566003', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cpachmann8@yahoo.co.jp', '$2b$12$7kH7FDkIQ5/3jQ3PTTCcYe9/3PnPOsBUvxiAKnVP3X/P6VqD8jKPy', 'Consolata', 'Pachmann', '2007-05-15', '609870703', 'Barby', '377', '3040-474', '551607424', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cgawkes9@arizona.edu', '$2b$12$NjM8I5VGOfgdkGYJ7AqG/ukfqTVAbd5W6vcdlelgj8N5u2p59QyKG', 'Cindra', 'Gawkes', '1999-05-29', '825265789', 'Express', '52304', '4480-330', '723201479', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lgrevelb@shareasale.com', '$2b$12$ekA4ZruUFQdJo9GntrPwNuqXv4U1vC5YB5MRgVKE3LPJWpPKEMiPC', 'Lloyd', 'Grevel', '1923-06-12', '154691136', 'Utah', '2488', '4475-045', '105464327', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kfarbrotherc@si.edu', '$2b$12$4eoRc9T9j1Syw6WVSaNn.OByDrj/wfh56h6cAuw3nQhDH9M2exBFm', 'Kaspar', 'Farbrother', '1948-12-15', '930428522', 'Mallard', '6179', '4940-027', '899298685', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('iabelovd@twitter.com', '$2b$12$bE7Fct19kBZopPYrSoCV.u3Z3pYMUf8DlVZeM73hhyD8grbA1KcxW', 'Inger', 'Abelov', '1953-12-14', '276712986', 'Northview', '02626', '7150-123', '226144007', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tmccoshe@storify.com', '$2b$12$EE2bMVyBuQUmvayYSVfrYes3Z8TMfhMKAI6AHAy2rcl6R4J6hlpWm', 'Tiertza', 'McCosh', '2011-09-25', '578279906', 'Hanover', '485', '2645-539', '895340081', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lmccaddenf@163.com', '$2b$12$sJCvZD4R/jhrDX3JZ0QLJOgibKB3JXWo/UIjAJmCm0lxO.p7cgY56', 'Lionel', 'McCadden', '2011-03-26', '588156017', 'Coleman', '97428', '4705-480', '746727935', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('sstiggerg@hc360.com', '$2b$12$G85EbBtgdXytIniuMwdvS.Gg.eMpGqx8UxfmQOCFRqmhYQLdCkvhK', 'Sharity', 'Stigger', '1994-07-31', '522442481', 'Anhalt', '627', '4795-894', '700944832', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bmortelh@myspace.com', '$2b$12$ooS6dtY0yZMypJaGERrhP.k.yUK.onIxJ80AWQrKFrnH9ev0V9.rK', 'Babb', 'Mortel', '1974-03-15', '708285192', 'Mallard', '6375', '7150-123', '653466526', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('vroycrafti@nymag.com', '$2b$12$cGlsUcXKdcBg9UxrvvgyFuMe75hX5UaVOuuTtBS8c2eP2GKjjzJr6', 'Virge', 'Roycraft', '1926-03-13', '170553895', 'Commercial', '1571', '4475-045', '797772633', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('acreykej@usatoday.com', '$2b$12$6BNFX17WrqBpHHglXJJ8AeWFpMt8Yyc2g/bmHYMtp.LKr7omovelm', 'Alie', 'Creyke', '1975-11-02', '757089317', 'Stephen', '22', '4490-666', '304161241', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('crowberryk@usnews.com', '$2b$12$wv4EEOj/U.h1HcwdNElnKOebfTMsuMxwzzW9G6ipDCvha2gG89VK6', 'Christina', 'Rowberry', '1932-10-31', '748570441', 'Fremont', '2', '4475-045', '330225386', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ccrutchfieldl@japanpost.jp', '$2b$12$WndQqDi2AJG7JgNf4PRUkONyVX8rJRBKWM/d.53rFrCJEHQl8W50m', 'Calypso', 'Crutchfield', '1955-11-12', '616921545', 'Hoffman', '9', '4200-014', '799904040', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('dhuddlestonem@miitbeian.gov.cn', '$2b$12$wa12PmRqoYfMt6kWzjujHuVHuDQa0gQEY.IRssUtbh7zV6YliZhIS', 'Doy', 'Huddlestone', '1932-05-03', '524744060', 'Aberg', '0292', '3420-177', '718207221', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('veasterbyn@ed.gov', '$2b$12$vRF.gopmywPUK55wTJW/OeSU9QAMC7GZNx.PtFUymEwIYKJjpo./S', 'Vincent', 'Easterby', '1925-11-28', '765100467', 'Carioca', '670', '4480-330', '302550459', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jdecourcyo@1und1.de', '$2b$12$UFNCgslii0oRLK1arDNR/.OeWKxxn9Qt6.EUkPmPM185/vQznZ3va', 'Jorry', 'de Courcy', '1989-10-28', '442075774', 'Lakeland', '69109', '4490-251', '929611747', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('frannerp@amazon.co.uk', '$2b$12$TXLYdA1fXZkEp4Dtmb5ISeDsgVBr0LyMQpPcwLVSgxukqCY55i30S', 'Frederico', 'Ranner', '1973-03-04', '488240321', 'Everett', '41593', '4905-067', '909789046', 4);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lclayhillq@qq.com', '$2b$12$yitvojo4GnGe/kNME8Zz1.DV9GeWJXS1ejPWzNB.N4PG1NDijSiGG', 'Lucinda', 'Clayhill', '2001-10-28', '608838048', 'Briar Crest', '48', '3360-032', '227051170', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ncowlasr@unc.edu', '$2b$12$M58r.bA1zpMIls27kr1bx.lINO2XQIBJlNuxVJXmh8FVV1/mMZgDK', 'Nevsa', 'Cowlas', '1966-09-01', '126074364', 'Dixon', '55', '1000-139', '698053152', 5);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('agittenss@dell.com', '$2b$12$p8pm3WEXzhgBCLcFFcaB6eKMm882cULcpsjct6vGuLhD6vaA7aOsq', 'Allen', 'Gittens', '1996-12-02', '835925404', 'Ronald Regan', '44', '2610-181', '628890209', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('hconnuet@wikipedia.org', '$2b$12$qxS29NXSd3i704GFaFTvOe8oF5Z.gOLorOy2cMneSeHpThhPBZTG.', 'Hermon', 'Connue', '1955-07-13', '771486563', 'Scoville', '736', '3360-139', '357894791', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tgoldu@howstuffworks.com', '$2b$12$rHE0njEDFOFp6Np4UXwljeJW0PCj1xrMyUtWQ8bFn7n49izLqOYDO', 'Tucky', 'Gold', '1998-10-07', '706904055', 'Hansons', '13351', '4475-045', '607992119', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('asheberv@dion.ne.jp', '$2b$12$nFfl5F6SmlFoA48sBXLZu.EHv9Qa3PeKspb4BoCi1eC3bbclHhEGe', 'Ange', 'Sheber', '1958-07-16', '826569987', 'Lighthouse Bay', '395', '3360-139', '968573185', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('aravilusw@cbc.ca', '$2b$12$0ZvZxXds6x0iOfXN9Dg6juyQDdPgu1YjRIxjffv1GqvQSN2g/MJGS', 'Anne-corinne', 'Ravilus', '2001-08-12', '636932572', 'Valley Edge', '68879', '4905-067', '790372230', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('oramshawx@barnesandnoble.com', '$2b$12$vut6l9zvHC.fOzJ3INzeue4u/hG4ysXfRldLCeJGODky7UB1j1rWm', 'Ogden', 'Ramshaw', '1945-10-26', '309918651', 'Debs', '03871', '3520-039', '583067769', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jchadburny@google.com.br', '$2b$12$gyb.aF0fnRfB3C07l8yzjONqCLD7qSc9f8bb0j/wu28RFswO4mh0y', 'Justen', 'Chadburn', '1959-03-21', '359874810', 'Boyd', '71', '7150-123', '842394567', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lbuickz@economist.com', '$2b$12$kTb7.5tC6hQjggYXODLbjewc/QLmaBKTE4roOmxUvRe4yumviNoDK', 'Lennie', 'Buick', '1930-01-15', '119048328', 'Eastwood', '9', '1000-139', '445212561', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bsoper10@zdnet.com', '$2b$12$RnJg7eQEltCe7eVKJyBrqege4a2poacuAZAB/NFhawvaKY2AUetva', 'Byrann', 'Soper', '1928-03-18', '482030620', 'Sommers', '42', '4490-666', '500345759', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mdelacroix11@home.pl', '$2b$12$JlEZ2xICkjGOloEQgoE/EuIQAjLohS1HUa/76ghC/tv3GT1.MAlt.', 'Mandel', 'Delacroix', '1960-01-23', '262286429', 'West', '74533', '3360-032', '481861870', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lkyteley12@icq.com', '$2b$12$2A6xmuHQ3e9LyMRbEwhu8.aLbkvV1Upc7rBafY1RoCgHN2KMwDBaa', 'Lenee', 'Kyteley', '2021-09-15', '715277279', 'Orin', '19736', '4480-330', '975632151', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kclausson13@amazon.co.jp', '$2b$12$WNoIn.6mFT.e7GpicqOWHOEPOnPAZgcFPgSlVqUlIFeKYW3liXIJy', 'Keefe', 'Clausson', '1989-03-02', '821987080', 'Surrey', '65', '3420-177', '940433574', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('amardle14@amazon.com', '$2b$12$dKCr.cX5mLjdRlfQGWztEuqcYgCfi0f86Us.GVWRHREvcsGCJPQQq', 'Annaliese', 'Mardle', '2020-07-31', '733144957', 'Northridge', '34', '4490-666', '182459070', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('iryde16@shareasale.com', '$2b$12$DX84Bmge.pMNLA0Nhw41WOMx7gyoyJ9ECIbtKTFrbBiMpLuRpJKB.', 'Ibby', 'Ryde', '1977-02-13', '751797677', 'Arkansas', '425', '4940-027', '251478257', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bgrieswood17@hao123.com', '$2b$12$TXxdDnBSS0r8QfvFQrAv5eyxqpbWYgxa1/L/nhdBuqQ6IvIOl9Pte', 'Beltran', 'Grieswood', '1994-12-09', '118005138', 'Mendota', '04', '4795-894', '798308771', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bedney18@dot.gov', '$2b$12$PMyqczgXqRltm6mWobeuL.kVGRMlUYGKUk3N26dHIue8/lnJWd22y', 'Bren', 'Edney', '2006-08-05', '928685632', 'Artisan', '380', '4705-480', '125409599', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bdoudney19@ow.ly', '$2b$12$WDdFfoI16OIz.J7nI8qiweHCXlRB2JYMd3hJy6EZ5EiniieVkkbqq', 'Bennie', 'Doudney', '1933-01-03', '558833956', 'Burrows', '52', '4490-251', '253547528', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rmulbery1a@fotki.com', '$2b$12$HlH8di4RhrydTqe.UNU8rORaS7Yc7Uacj.nT/D0IsdO8iPMBkkDEi', 'Richart', 'Mulbery', '1940-02-24', '174948438', 'Walton', '90456', '4490-666', '864413803', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('gbentsen1b@howstuffworks.com', '$2b$12$HqZEdBa2NpwLPfHBWdRnc.MJfEm./FtgKGGroxCkHlD3l1oYBPlDG', 'Gail', 'Bentsen', '2004-05-26', '787454199', 'Spaight', '3', '3360-139', '692275527', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('edolden1c@issuu.com', '$2b$12$oUWwvA0T1xIBG81ZzGGHNejpOKzFl7bXbcMXKPmemquxA75X5CXSG', 'Evyn', 'Dolden', '1938-11-12', '594478075', 'Ryan', '47812', '4905-067', '180568173', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cbertomier1d@php.net', '$2b$12$1EWJhX1crFT.4uwCSyam/e5L3IULwcZ/Pq2.kIWSfZeVYEuTV455G', 'Cyndia', 'Bertomier', '2006-06-06', '697542381', 'Sachs', '310', '4900-281', '162415139', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('hfeeham1e@chron.com', '$2b$12$O/6hjVHVAnHvFaKx/iTKeeGguhDEW9j1ZBeIM0TG.JDLx7U/WT1L6', 'Huntington', 'Feeham', '2014-01-22', '971231623', 'Autumn Leaf', '631', '4490-251', '685437267', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('fyegorshin1f@goo.gl', '$2b$12$jk1iYwi7jPl1yE1RJePFfOi25zh/3nHumpqGhGhWTJxukYOpwgwEm', 'Farrell', 'Yegorshin', '1998-10-27', '122041842', 'Lindbergh', '4968', '4905-067', '326883557', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('pwyllt1g@yellowpages.com', '$2b$12$71olq7G5Hrdo/5ALMvvB1OEdOWtnuwcV1hsxFADhcGmkoCWy8WC/2', 'Pattie', 'Wyllt', '2015-12-04', '434999211', 'Florence', '481', '3520-039', '784881488', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('hhollow1h@ibm.com', '$2b$12$dapjPH0Vq57v/lzgVbDf7eC03ZfkcDNhCFC6mMuMvNZLnd5awJLMK', 'Hetty', 'Hollow', '1994-02-23', '456947855', 'Shoshone', '2', '3040-474', '941878780', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tchristensen1i@patch.com', '$2b$12$RI8bNunF5dlctnwdZjskr.QkABYJYVS6K6YtLEHv.m.bn/E6eYCN6', 'Torrey', 'Christensen', '1956-10-13', '257025105', 'Mccormick', '12', '3420-177', '315938741', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('agoldfinch1j@ted.com', '$2b$12$v9Ajme7SL7.9q0GhKObzcOVxmaCN.RcmkQZU./k0oBSZhvs6JfHrm', 'Anselma', 'Goldfinch', '1968-06-11', '569255352', 'Kensington', '342', '4475-045', '283249866', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('epawels1k@hatena.ne.jp', '$2b$12$OnpJ.Q7fgl3Xu6SurYTkjuOExtjqrwk8vz0KB5FhBruHLhVfIO9tm', 'Elie', 'Pawels', '2006-09-27', '455104181', 'Chinook', '5263', '4200-014', '978126551', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bmotte1l@unicef.org', '$2b$12$M6S.g7gNqAZWX2t4DDDPg.cSq8dP8/oy.oOcsBO/6vdcqv7lX7irm', 'Britte', 'Motte', '2019-07-03', '428280787', 'Dakota', '8410', '4705-480', '400801817', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cfishbie1m@cbslocal.com', '$2b$12$PaPBsMEVkbQegNFMHWPSFu0.f2yqkggn8ytm7fpoeawNR44vIGVli', 'Care', 'Fishbie', '1935-11-28', '866506234', 'Sullivan', '7307', '4940-027', '756619496', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lhalegarth1n@jiathis.com', '$2b$12$U.Kpejviby/1YQ4/nOgvoOD.boKv.Qy77FFvgC471ald9BZBEKMfK', 'Lewie', 'Halegarth', '2004-04-28', '516187512', 'Maple Wood', '67723', '4940-027', '378715372', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('aniccolls1o@businessweek.com', '$2b$12$qyeSGARzO4QLH4gqRZdMB.iGarO219mXYjGzrVYWJuNdxUVlDIfWi', 'Ambur', 'Niccolls', '2003-07-09', '715373426', 'Walton', '7', '4940-027', '716875338', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('scapnerhurst1p@amazon.com', '$2b$12$X2DcmSHoh0A98p4b9wEk2OoZ1DTe3V/ib2.FlM6yynLisx1YnQRe.', 'Sheree', 'Capnerhurst', '2012-02-11', '762227078', 'Erie', '7', '1000-139', '423850503', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mavramovich1r@google.nl', '$2b$12$.rPx7fRq9PdbV1LTPPsD0.Mflk5u/NxesiJTDPCCEubOtLQo4Lqle', 'Modestine', 'Avramovich', '1941-05-23', '314328166', 'Hoffman', '64', '4490-251', '383396330', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rcritoph1s@wufoo.com', '$2b$12$Fxio.TRWUyZ.05WoBEpn8O10D6N4o1zSxsfS8w0jqeASyVtfBGpkG', 'Ryun', 'Critoph', '1941-05-27', '247579884', 'Crescent Oaks', '108', '4490-251', '356124422', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tnatalie1t@smh.com.au', '$2b$12$U4yUDnTulqgNVZ6jePcudupBWfyMLWohUXIXb4SC/ItK4we/4FzVq', 'Temple', 'Natalie', '1969-05-06', '648703328', 'Londonderry', '24430', '3360-139', '785170408', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jcollum1u@washingtonpost.com', '$2b$12$n2922gjBOFUQLYyEYb/6SukYY8R1ixX22R1iypy5DwRJzvwdNmQgq', 'Jaclin', 'Collum', '2002-03-01', '710278621', 'Morningstar', '7', '4480-330', '537136810', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tbezants1v@constantcontact.com', '$2b$12$dbxr8AJA/BCBphv2vlOlnO8fzLuhmaUvDbYWerI97uI2l/koGcJtS', 'Tracie', 'Bezants', '2020-08-17', '577934296', 'Summit', '238', '1000-139', '987443248', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bwainman1w@webs.com', '$2b$12$h8x7x3jnoUuryltqxr5c4.XOkLOKqcGddJBX5VcdgWcsPDfKGD9DC', 'Bryan', 'Wainman', '1935-06-02', '797927414', 'Amoth', '80633', '4795-894', '506993721', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('hpeppard1x@un.org', '$2b$12$WDmClL256z99Yi9xRXnVge/uYo4uLEX.CyyLjk24YmdNW4GBiuA26', 'Harriott', 'Peppard', '1995-01-18', '424773977', 'Mayer', '9', '4900-281', '531762826', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mnealey1z@weebly.com', '$2b$12$1Vtnwok8X/9RwKBzN6HJUu6ce8cFVxa1j5bdfEd9oaHlbTyULfQbm', 'Mart', 'Nealey', '2006-06-26', '246706782', 'Oriole', '5313', '3360-139', '989578002', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tdoggrell20@exblog.jp', '$2b$12$ea7lBTLu4Y8tLqueA7jsx.DIVxDB8d4zyXNPU3dnRLFt1KCtLU76C', 'Tessi', 'Doggrell', '1983-07-28', '698888995', 'Northridge', '64108', '4900-281', '345064762', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lwilprecht21@chicagotribune.com', '$2b$12$PqybwBu6lAhe/x9Qmd00tu0H.j/Y/WvFi8VQ9tvMHy886SNzFLyK6', 'Lucas', 'Wilprecht', '1985-01-16', '599752506', 'Portage', '290', '4480-330', '669654998', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('fmurfett22@umn.edu', '$2b$12$QUPO6FMcsxYB1UmaePmmZ.m6yMui7XxwoW0/R9qaAxC5kyaCxtyCW', 'Franny', 'Murfett', '1928-06-29', '492212376', 'Hoepker', '92275', '4200-014', '513945335', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jregglar23@blogtalkradio.com', '$2b$12$4pLakrjgM2F6cmLTPqz6heHvPCwuDwI/v80yLabbanR0LSAuLpT9C', 'Jennee', 'Regglar', '1985-04-02', '694672377', 'Waxwing', '1681', '3420-177', '787287945', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ghazleton24@ifeng.com', '$2b$12$bdvbLE0fPXP370YVg.Z2VOPpTyQriI7/es0qodS6Y65./TVWeNa.i', 'Guinna', 'Hazleton', '1928-01-07', '693414557', 'Eastlawn', '50570', '4795-894', '554627317', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mbrownsea25@nytimes.com', '$2b$12$lS/il7AKvv9FEIJTpY31h.ASvaJrQHaE4Irk16rcOivJChldO3VSO', 'Mitchel', 'Brownsea', '1947-03-09', '802962872', 'Lyons', '9', '4480-330', '485398950', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('solivier26@simplemachines.org', '$2b$12$8ksFa2VsD60wk1R/v16QkOZDwW91ECqzqeM0zTYjQNVB/CamOlBYy', 'Shayne', 'Olivier', '1942-12-20', '893319278', 'Kinsman', '3713', '4705-480', '338482575', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cmaitland27@redcross.org', '$2b$12$nSDpNMzdY6BNQr0FKy3ODeguYP5i.Ze.kbTVkX6EjNkMo.Kui5dCO', 'Clerkclaude', 'Maitland', '1926-07-13', '781781686', 'Mosinee', '268', '7150-123', '817640633', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('edreghorn28@cloudflare.com', '$2b$12$N4gIaYW3WqAiUyWTA/DVK.2jXueDZKw9x/hFLZjoOuZcOHQ/fA4ma', 'Edmund', 'Dreghorn', '1967-08-29', '812973946', 'Manley', '04', '4705-480', '644900900', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ttrunks29@prweb.com', '$2b$12$BUrChR0UgbYx0J7/0ATZcuHmt42zZvGXK0EG02mHJGhA6QUTaK14u', 'Timmie', 'Trunks', '1958-09-10', '835376870', 'Nevada', '4065', '4900-281', '332998624', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kkarpenko2a@dell.com', '$2b$12$6OiNUGJSrq1Pp3sZ6ns9I.AB4GOs/Rn/shto.5MDbqpVnLSodkVZq', 'Krissie', 'Karpenko', '1959-04-05', '456707531', 'Crowley', '575', '3420-177', '222586132', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('sepiscopio2b@barnesandnoble.com', '$2b$12$hpGIrWEdu0H5R8aSO6XzPOUOZkx/0EikBfOAvho2hwjAGW3gcKbmu', 'Sampson', 'Episcopio', '1987-09-29', '668207085', 'Florence', '3', '1000-139', '908662848', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('hnovis2c@hhs.gov', '$2b$12$LiigVXTrf2nOyLyq4.DwueD2HSuUJ0nUs9ILWMWopOqU.1XSOzaSO', 'Hansiain', 'Novis', '1947-02-22', '640171060', 'Prairie Rose', '6', '4490-251', '766091244', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('csmissen2d@elegantthemes.com', '$2b$12$XdFP58.bkM/GIda5GjM1RezhGK9AciWlrmJ0QoL7RKwiqLIE2Zefe', 'Coleen', 'Smissen', '1979-07-28', '820108477', 'Mifflin', '9737', '4940-027', '827759274', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('pnotton2e@behance.net', '$2b$12$Mfyw4vWlkCGlqV3jqqfc5.CdYbDBI1ZtWssY6M3.v7FZfR/sc9RMK', 'Pip', 'Notton', '1971-08-15', '161259875', 'Everett', '5', '4480-330', '772439147', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bredsell2g@mayoclinic.com', '$2b$12$go45Nq/gDZ0E5eecU9VUD.9wkoiNfD7QjTZQQKijned1.P2Hio1lm', 'Bunni', 'Redsell', '1960-02-23', '396012129', 'Jay', '46', '4795-894', '116703854', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cblyde2h@abc.net.au', '$2b$12$VhG1EC3CcjxNWYAc81fnVe0lCRygZVy5Ddr6369mm3f98Ci5c4dA.', 'Catie', 'Blyde', '1982-01-06', '643614731', 'Magdeline', '84', '4940-027', '824709366', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('sreeme2i@blog.com', '$2b$12$N0z7hPNUrWSbKtMX.U/AJOxTkds7MvcTLz3QeDyuJ0.beUJSyfnlm', 'Shawn', 'Reeme', '2006-02-12', '247338510', 'Oak', '2', '4490-251', '242449909', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kstrong2j@163.com', '$2b$12$9JvF39dMSKbYW9xF8eBe5e9zbbmowjBZ93spnERZSGakpre7kAbxy', 'Karil', 'Strong', '1943-03-11', '934847321', 'Del Sol', '44117', '4475-045', '907744908', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('chaton2k@wufoo.com', '$2b$12$dVdz2emTfyIK9pSZPo03m.q.MMp1O9WxPoLhABJer9Tv48b0buACa', 'Cyril', 'Haton', '1944-10-12', '795769532', 'Fordem', '07880', '4490-251', '225986899', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('gkleinhandler2l@bloglovin.com', '$2b$12$QSH8x2d01ECmxLlmR0VrFOYnE8HBrQSXVcy.yNJ9deGgSal17Z8Qe', 'Georg', 'Kleinhandler', '1946-12-13', '281578004', 'Heffernan', '7', '4705-480', '183532842', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('carmall2m@slashdot.org', '$2b$12$YwFoGXzdGLHBhCgi9U8qkOnvwQgQmXFhp.UH/yvD7q1BA5lDOYv5.', 'Catrina', 'Armall', '1933-04-11', '114413677', 'Manufacturers', '8', '4905-067', '813841704', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('sdiment2n@buzzfeed.com', '$2b$12$hOeaHB.XW1bKBHxHd3yyh.fgvN/Kb3LYh14aBvKJUoZStdW2TDjsu', 'Sharlene', 'Diment', '1970-12-08', '903048892', 'Bobwhite', '379', '2205-025', '317204058', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lamdohr2o@aboutads.info', '$2b$12$her3c3MAhVCMMPTex/v7HOxeUaDsLpdOfEQ0khQrlwWCJbBVnogei', 'Linus', 'Amdohr', '1935-03-13', '317548749', 'Summit', '11149', '4900-281', '464196618', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jbarajas2p@photobucket.com', '$2b$12$NAetAWl7NbHpTIc3DJa6HOoliEIqq9H.y0si1MlriMjMg9yYJu9TG', 'Joellen', 'Barajas', '1931-08-20', '376879755', 'Pepper Wood', '7', '4705-480', '517404174', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('gminico2q@cdc.gov', '$2b$12$DT.RdrNNf.X20YkhaXQH2ufYzGO0xvi6KJxwhhWG5EQIhw.OD2mGW', 'Gertie', 'Minico', '2006-05-17', '820449576', 'La Follette', '3', '4480-330', '788684026', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rluciani2r@theglobeandmail.com', '$2b$12$Qsy3tgy0CjyuYGnsSTI/YeuBF9lrpCcYcPc1bYWk.e1ObaVPJgNEm', 'Ruddy', 'Luciani', '1957-04-26', '558178576', 'Kim', '87919', '3360-032', '433190044', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('pcudmore2s@chicagotribune.com', '$2b$12$41xEFGaObichsiN59CLkqOv6hvrd6Xu0ZirIsoMh.tQQhT6xg/dIq', 'Perice', 'Cudmore', '1993-06-04', '711949422', 'Sheridan', '753', '4795-894', '391811205', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('dhinks2t@wired.com', '$2b$12$zxl9Hs5HISPALuoanrnJ/uPTcUqq/f5eV5o1rymfK2KSo0yWJuKQ2', 'Derrick', 'Hinks', '1973-05-11', '731672311', 'Loeprich', '4822', '2645-539', '357266160', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cbeattie2u@oracle.com', '$2b$12$9X.clntifUNYlg0DoVoT6.Pz.o/gKaeYfwon9tr0lhA066Y87yS7.', 'Chloette', 'Beattie', '2017-01-07', '186050361', 'Esker', '41706', '3520-039', '934094865', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('emenloe2v@skyrock.com', '$2b$12$ne9CflS1aRHl8aS.3UODueU5mhiNof8pECl5EA/.p1B4UryT/RLvO', 'Erda', 'Menloe', '1979-04-16', '151349800', 'Sherman', '8823', '4940-027', '232874481', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('dpencott2x@engadget.com', '$2b$12$zNuA4/fptftfU/Uge.Zn7uZTkoWMSxbnJeWAzTyZJ2q1h864xhQHC', 'Dionysus', 'Pencott', '1950-09-13', '593662604', 'Golf Course', '44', '3420-177', '778993753', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bjachimczak2y@cbslocal.com', '$2b$12$jGY7mCBIC2qrcdWGrfi6TuB3GlmG9qfkIGIcyyY9co99GQaWgW42i', 'Barb', 'Jachimczak', '1950-04-04', '157165618', 'Burning Wood', '02', '4940-027', '142017925', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('krobe2z@gizmodo.com', '$2b$12$HMwqKKQDqOXYyMes3jeApOCepJkGnHKspI.vHS9JVUuAxqvs6aS.G', 'Katlin', 'Robe', '1993-05-16', '610921837', 'Golf Course', '1', '4905-067', '950059621', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rmurfin30@ox.ac.uk', '$2b$12$siuFJUgMJcXc52mgjSOVLuN3/zTcWtnQveOvREg5dFMOM8wWy6k7G', 'Rodina', 'Murfin', '1991-07-26', '923080467', 'Rockefeller', '307', '4200-014', '785281002', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lmoscon31@statcounter.com', '$2b$12$Ih8Q06wjoh/RhlDZzS5.0ub.cJ3iYBXorssJnnc.LyUjk.ONuRkL2', 'Lela', 'Moscon', '1960-08-15', '778117686', 'Dottie', '1', '4795-894', '960597533', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cdegoy32@washington.edu', '$2b$12$IGW.Ux3GxvYUMDxZN2QV7OTXu8WguYZZGzj5xh8du4lA5YL/iWNtm', 'Carleen', 'Degoy', '1948-05-16', '303676304', 'Eagle Crest', '4205', '4490-666', '746595713', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ehalmkin33@blogspot.com', '$2b$12$HJxztTTqDDxssJdoY5evWOyUs8aoLGwmwsdJoR8cikEskoKQLojOu', 'Eadith', 'Halmkin', '1963-05-01', '315885462', 'Kinsman', '16063', '4795-894', '675470081', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('nskellern34@cyberchimps.com', '$2b$12$1Qnq.NF090P3ZtelyGiXD.EoOWtq515E.2I/YCprqWXAAJ0zFK4CG', 'Nicholas', 'Skellern', '1989-09-03', '105657347', '4th', '1', '4490-666', '476775921', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mfellenor35@mozilla.com', '$2b$12$/LnBML0wrNpqryv4a1U.Y.B5KobbPKg9uRyfeqcoIu/3J2aZow9XW', 'Moshe', 'Fellenor', '1947-05-02', '858653181', 'Judy', '35', '4795-894', '730171041', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jpaolillo36@nyu.edu', '$2b$12$edaHglf2yKU0kHEHtjAkH.nTDa5dMXfRts.GMIYRtG5uqKOJQXDTi', 'Jody', 'Paolillo', '2006-06-26', '437415771', 'Moland', '427', '2610-181', '189164261', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tfoakes37@canalblog.com', '$2b$12$LtPr5LEj5BmX9Cg.o7cBVO7RsUMyfMU5s.dQ//a4O21voK9VyP1JK', 'Torey', 'Foakes', '1993-01-03', '280124607', 'Meadow Ridge', '49', '1000-139', '337719907', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jsmalridge38@cbsnews.com', '$2b$12$LJTVLB9cBT2iztDHGRW/aeVejkw4P0KsB3Miw5teehxa/S.C.RonG', 'Jacklin', 'Smalridge', '1982-10-09', '938107030', 'Montana', '57901', '4480-330', '590631456', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jtracey39@google.ru', '$2b$12$6xXQ9alhNX1mQcVcOOGWXukTumr2SookTCE61oa8lNgcI8wbWM7UG', 'Jeremias', 'Tracey', '2000-04-03', '972808415', 'Carpenter', '572', '4900-281', '588809029', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('carber3a@rakuten.co.jp', '$2b$12$68PpqMWw9zU3ep6VxJ19U.J0U.q/OXVaG7wp3rQZuGnZzFyJBqXri', 'Carri', 'Arber', '2008-04-14', '557156585', 'Hansons', '892', '4490-251', '300534644', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lmatysik3b@plala.or.jp', '$2b$12$bPFuAynggDpnPzGZLfyS5O3rVJSBBjhokQAmDBYQ4FlUomVrt2WJq', 'Logan', 'Matysik', '2003-11-06', '676327913', 'Surrey', '34', '2645-539', '828417822', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lcroote3c@360.cn', '$2b$12$/p7qMO2t07Pb3swleXpI6.KPya5vhUghpyDyGzkAtmIgE8FZ9Essu', 'Lawrence', 'Croote', '1959-07-15', '460742108', 'Dahle', '959', '3420-177', '930956948', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kmahady3d@bigcartel.com', '$2b$12$wHhq.W3QOMML9t4.LxG4m.ZXVJgWCFILVkmjg4pVzvha5HzNzmqhO', 'Katha', 'Mahady', '1925-01-03', '436650497', 'Dayton', '98', '4490-666', '156427593', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('fcarlin3e@mit.edu', '$2b$12$QkPJ2DGUb9fqXjlv.B4fvuoZy3R6V3dn3UhsZJBGip6mM24iGlt1G', 'Freddy', 'Carlin', '1949-12-20', '950844060', 'Upham', '6', '2610-181', '400569708', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cdaintith3f@constantcontact.com', '$2b$12$Gjeau3hgOZ24QcxmZg3reePuEv4r1.IelcmrjNpO4/nRDbQsCvr3q', 'Clint', 'Daintith', '1971-06-28', '736433182', 'Kim', '963', '4200-014', '257885138', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jtomaszewicz3g@xrea.com', '$2b$12$uN4cNFjnP7FEd2sgsfx8GO5HYmhQBsMB1d78CPWB/Z7HxejiaSwAS', 'Jammal', 'Tomaszewicz', '1924-07-21', '618167243', 'Golf Course', '7493', '1000-139', '247027819', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('tgethyn3h@posterous.com', '$2b$12$TOxryzFq6D/EEBDNxR8SVu2WIYoutYW0gCiiUxL5wbP3.8L5.QcyS', 'Tymon', 'Gethyn', '1950-07-30', '495459415', 'Morrow', '9960', '2610-181', '202215707', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jyegorovnin3i@edublogs.org', '$2b$12$udn31mLpLAIefh1Suto06O89RxKAli1q0ymk/Qd8bAzpgVF.HlYvy', 'Josephina', 'Yegorovnin', '1958-09-25', '270832728', 'Parkside', '8', '7150-123', '223760674', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('glawless3j@noaa.gov', '$2b$12$V6Afm9LVH8TBWKnE5z6WJuR5c2cMbuTfB/nPdB2LD3nYJAXkPk1LO', 'Ginny', 'Lawless', '1961-04-18', '271983681', 'Montana', '57060', '4490-666', '687313541', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('dnorthen3k@ow.ly', '$2b$12$dlLJ2QPLdikIBIio3pvyIuvqovL.NGFmlhzgpVhEgbXUJXuwz.hOq', 'Dunstan', 'Northen', '1946-10-27', '764159529', 'Westridge', '60', '1000-139', '741275050', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('hkem3m@blogs.com', '$2b$12$DRQV/HxoDTuWJ1DPaorfF.tbuB6RYhwJwDPRymjwhuuBhmlWqqRsi', 'Herbie', 'Kem', '1980-03-25', '359022457', 'Crowley', '249', '4490-666', '49521117', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ajersh3n@msn.com', '$2b$12$gOyF8AYkcbLA2tOZmB2vt.lepy7MYFs6kx5tvaOO3GcdehfMizhBu', 'Austina', 'Jersh', '1992-09-18', '218175629', 'Thompson', '13906', '4940-027', '211070348', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lecclesall3o@springer.com', '$2b$12$UXfekYR6o0ApAzoUJP8J4.bxc0QJHVQbJUt3WleoxxQVNG9xyP0Uq', 'Leena', 'Ecclesall', '1998-06-04', '316217228', 'Upham', '62', '4905-067', '867515396', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('abraemer3p@vimeo.com', '$2b$12$s7n3ujwCdN/osf/yYfJiU.R6i9..fo2Mm7vki6dhmAf6kHxe155YO', 'Ainslee', 'Braemer', '1937-10-25', '826796067', 'Briar Crest', '1525', '4480-330', '561836478', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jdaens3q@dedecms.com', '$2b$12$sQC3noKjpA5BRAt9p.R3C.0pVaMK5qP1B.VkkzWgCuuMTahK1stSm', 'Jacquetta', 'Daens', '1969-09-16', '175650953', 'Fieldstone', '752', '4480-330', '358896881', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('sagius3s@hao123.com', '$2b$12$aedvDYgPsT2BgFgTxMGkPeJLMdQMfhJUZdqcKLss/B9YpjB3qvU8O', 'Sarina', 'Agius', '1996-04-02', '127825511', 'Ridgeway', '6952', '4490-666', '145422545', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('idemange3t@whitehouse.gov', '$2b$12$7nSXn0gb0CJVR/GXExaBU.73BCMd3uiSZyg2VqAs/OjWFo1ZGDQS.', 'Ignaz', 'Demange', '1970-02-24', '667352774', 'Harbort', '535', '4200-014', '873460165', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ngeerdts3u@scribd.com', '$2b$12$NpVV0boOqWKBVQuRpe/HpubhwtYAqCaQu6YOrxHMPxCIbD96zH6Da', 'Nelli', 'Geerdts', '1964-10-07', '841379863', 'Autumn Leaf', '17', '2645-539', '881930362', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('sauguste3v@webs.com', '$2b$12$ckBHZTWIPYkwxsrr8uoR5OjQrQs3opmjmy26WjovsgNEBKHcNMaBy', 'Saidee', 'Auguste', '1929-09-02', '886896630', 'Sunfield', '348', '3360-139', '444773229', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('twaywell3w@tmall.com', '$2b$12$/rIo6fExPps3e1vOjfQIfOB1CH7tVP3VJoA.MNxV3OiAvL6UuUZVi', 'Tad', 'Waywell', '1970-10-11', '194897213', 'Bartelt', '25', '7150-123', '890813672', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('alapthorne3x@buzzfeed.com', '$2b$12$OwBIsVkEC96/6vFjm0uMYu.pmmo9xk6La7dEyK5slrgPntDBpmLxm', 'Axe', 'Lapthorne', '2006-09-06', '571959030', 'Mandrake', '3831', '3420-177', '311101771', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('silson3y@stumbleupon.com', '$2b$12$L0egmnSRHr5c.EdZ/tBo8OSp6lkv4Az95ncKqYSdtTPDNes8AIUl.', 'Sheila', 'Ilson', '1965-09-05', '847730293', 'Chive', '070', '2645-539', '609580028', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jbrando3z@goo.ne.jp', '$2b$12$hgExWSdj3zjpv.CdiEXT.Oke5iSWGiB2e1SHRW/tZl.8tdd2rBUoy', 'Jamie', 'Brando', '1979-09-11', '662214214', 'Merry', '9', '4795-894', '298827098', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kschutze40@jiathis.com', '$2b$12$1IHxHkfgatuZ41Gn0ukU2eqtrbAzLtd4OeBv5uAeoGk3qxG9qiBIu', 'Krisha', 'Schutze', '1923-03-31', '133524440', 'Del Mar', '39381', '4795-894', '626022800', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rflattman41@acquirethisname.com', '$2b$12$VbI84Bmq7G.qQFWNpoy.aec5cRrGWmjUSnioXNjf6zuUY0/cV3t4K', 'Rickey', 'Flattman', '1949-03-09', '158872933', 'Tennessee', '945', '3420-177', '219508673', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('wsieghart42@tinypic.com', '$2b$12$086XwSGw7W/CjRhYCtJp4ubeEYxnatlVQTlQU2EbXfIcjkaHaiPia', 'Warden', 'Sieghart', '1999-07-30', '248818494', 'Basil', '9', '4905-067', '933856826', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mwetherby43@over-blog.com', '$2b$12$Dg18JCCFgqeF74/qVtsrb.4jcfVfdgtnZ1Uzc2vubpS48Q5giDvAq', 'Madalena', 'Wetherby', '2013-09-16', '249225898', 'Vermont', '0315', '4905-067', '970192963', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('btyght44@cornell.edu', '$2b$12$x4dC/YyJxbv1ainKM3hLMO/rZZsVJWMJ0ImTABp5fsnC0ekVTB6s2', 'Braden', 'Tyght', '2000-07-26', '340866998', 'Westport', '4289', '7150-123', '625713063', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rlackmann45@dagondesign.com', '$2b$12$duFpGrRVzHLaWQWeOhKgP.9k4riZf6QxJBdl4umMcyEEMVYuYKkcu', 'Rosella', 'Lackmann', '1931-05-22', '464904343', 'Spenser', '7826', '3360-032', '268825068', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mbambury46@pagesperso-orange.fr', '$2b$12$YasgcnYxvreNOpsxk8gFeezJBnDgcAJElAauuY3p0smW/I8dF303e', 'Moore', 'Bambury', '1942-02-08', '784145475', 'Mcbride', '08', '7150-123', '543600667', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('nternouth47@acquirethisname.com', '$2b$12$VfNuhkFrmYtVo1rbTYb4AuOAyB/I5O6q3XvYt.A9Fbthm08ZTvEWS', 'Nye', 'Ternouth', '2017-01-28', '711109179', 'Dapin', '865', '4490-666', '986227786', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('pguerrin48@timesonline.co.uk', '$2b$12$HFtR7mOpCoVvS9H2hNKsS.tHN7upB2T6LfLOrXI8Tesz1JRc9CSUG', 'Palmer', 'Guerrin', '1964-10-20', '413404289', 'Caliangt', '96', '4705-480', '908424885', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bbrundrett49@posterous.com', '$2b$12$3b1A1qdJjjBOYe7D98Eh5OBiSWW0UPszTXltGih6Y57EXLl23f.FS', 'Brennen', 'Brundrett', '1979-08-26', '530383392', 'Gateway', '49', '1000-139', '892564428', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('nlemoucheux4a@dmoz.org', '$2b$12$rnI2iIZzTsxK216ZL80P0eB/ez5HTD7COlf7Ng80ZQW..Kl.rr2Xm', 'Nanci', 'Le Moucheux', '1940-12-28', '639745793', 'Parkside', '70291', '1000-139', '969047551', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('scree4b@youku.com', '$2b$12$nAoDAFBNq9kc5zPVjgZwQeWNgHSMUNGmN0HnIZ0SMI63r/ZrMToca', 'Sarajane', 'Cree', '1955-08-09', '323283160', 'Alpine', '413', '4705-480', '680692971', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('gmatiewe4c@businessinsider.com', '$2b$12$9gNiXWbsJY0ZOk4wmBso6uB40IfKf5BY0H1wbJ4eKmMXZU3kakOdK', 'Gaby', 'Matiewe', '1936-12-17', '192142027', 'Debra', '62', '4905-067', '940803251', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('oizon4d@gizmodo.com', '$2b$12$T8udw/z0c1DODe44Kl8SDug108qeKIoSJrnifKJqUIZ4a7DQfT69S', 'Odette', 'Izon', '1932-10-04', '671502551', 'Eagle Crest', '1', '3360-139', '946822109', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('uburren4e@nyu.edu', '$2b$12$tUTdpfqYa2MhRBtnxCXAiOzjku3uWiRAN1ggKSpzHm68D9rCGYpOm', 'Uta', 'Burren', '1984-10-04', '871131438', 'Corry', '05', '4490-251', '782473850', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('wbucher4f@yale.edu', '$2b$12$6j0Y9hV7jg5FNWO3O3UWTOUBu4h9p.a/qaaRd7h6s0b4mvj7KADSe', 'Wash', 'Bucher', '1942-06-16', '518278363', 'Elgar', '628', '4705-480', '892587048', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('achoppen4g@army.mil', '$2b$12$cGp4up/rmqVnMbztoWHzteN4etwwV45zJO95RlMdgoV35qWTHLwRK', 'Angie', 'Choppen', '1981-08-31', '909339900', 'Dovetail', '3', '3520-039', '384504892', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bmacieja4i@twitter.com', '$2b$12$yHUz86Lz1XzVGS7Jf/ytauKkmYUonihoVn5VevzuA2NWWtyLKWSqG', 'Bartlett', 'Macieja', '2007-08-22', '647435444', 'Monterey', '1596', '7150-123', '646209954', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('iolliver4j@arizona.edu', '$2b$12$lZGGPfknhpTX54rerg6UxueoZDa4tfKVCmTvU73ZLnompClvXwgoW', 'Ilario', 'Olliver', '1968-04-10', '455742149', 'Boyd', '1', '3360-139', '719725325', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('egian4k@google.com', '$2b$12$DCPrSfhFZbZokP/Mj/tXxuQYkbCz9IkqiOJSOIvIZAW5CDWwqggOO', 'Elke', 'Gian', '1936-01-23', '578888833', 'Arapahoe', '13', '3420-177', '117148753', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jniblett4l@devhub.com', '$2b$12$Mqs6qtmPcWDC8c3l7LHBo.yxFxQH7e.0u1DXj3fKDh0H0cT0Pohau', 'Jamie', 'Niblett', '1969-11-26', '334635454', 'Carey', '82456', '4905-067', '611562011', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lanear4m@earthlink.net', '$2b$12$sLlsZWggKahT30YvBpYFPexULTyPgPtT4CESCw9wMPnlMvbMVj3W2', 'Lil', 'Anear', '1926-06-23', '640509303', 'Pankratz', '7517', '3420-177', '614628466', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('edeclerc4n@psu.edu', '$2b$12$QLnGXPIAIw5Gl7hLDLGayu1KT9aom.LuFUe4Xeof2JkaTyQ.HHsoa', 'Erin', 'de Clerc', '1924-09-24', '313090351', 'Beilfuss', '07197', '4795-894', '617409542', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('hgingle4o@multiply.com', '$2b$12$tOA/o8Cwv1d5aRVz3RhCsOBKSebg4Cv./oaCCNy0VeYYamZchRSF2', 'Hale', 'Gingle', '1976-03-23', '959084788', 'Brentwood', '58', '4795-894', '617951847', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('rcant4p@chronoengine.com', '$2b$12$hP5mlh/AyyePAuHzZjSuEuH7jiEePgP/deT96nEr5f/UBlzK/gyTy', 'Rooney', 'Cant', '1977-05-05', '719945681', 'Lighthouse Bay', '41177', '4705-480', '193811557', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cgouny4q@ocn.ne.jp', '$2b$12$eNbqb9DFRCK5t9Ih4uB22OJlmxjZ4WgroAba9KwsG3LAcegAeqx3y', 'Cole', 'Gouny', '1932-01-23', '212083050', 'Gerald', '520', '4940-027', '128087605', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ldevaan4r@list-manage.com', '$2b$12$0vx5ZlOBo8XySaxLG4AiY.QLzAh8S83HxCwujz.CEVwYd6w3gd98W', 'Louis', 'De Vaan', '1960-12-13', '238013732', 'Talmadge', '90557', '3360-032', '305002803', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lkensy4s@behance.net', '$2b$12$tOCFcm25oCs0MPCf.eB1JOPW5kHI5yARkW4a5kIHkwyq38GNSfOt6', 'Lida', 'Kensy', '1961-10-16', '112760745', 'Fallview', '19046', '7150-123', '199093933', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('selan4t@sciencedirect.com', '$2b$12$sMRAP82JDLmBGDoN5Axwnu93AQ1k1wAnYlpGtf2xC7e3.YlUFfwV6', 'Starlin', 'Elan', '2005-08-10', '189419459', 'Butternut', '2', '4905-067', '653291369', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('vfenne4u@fc2.com', '$2b$12$pU7kyZxvov6LzYk3f3YaPenTcWBSYTlTSzpmuyM8tqwaDprTFuwpa', 'Viola', 'Fenne', '1946-12-28', '758777394', 'Northport', '6', '4475-045', '16961702', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('fguitonneau4v@cyberchimps.com', '$2b$12$e9wf3d0xHz7.Emz0YoYBEu7nNwftbcvRp5JsJFh4aZNMr44v8CxwK', 'Fernande', 'Guitonneau', '1966-04-15', '478378800', 'Holmberg', '637', '4940-027', '163856336', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('karthy4x@newsvine.com', '$2b$12$otgMTGQSHLcodU9bOQtkaen2G9mYLhNZnYYAOCyxgMaQxoXn48ySC', 'Kathlin', 'Arthy', '1926-03-04', '970268007', 'Schmedeman', '8', '2610-181', '510492962', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jseago4y@geocities.jp', '$2b$12$xNlrrdvXDXAVHv87BCviduoE4APUQJITZKL.o6l5KyKRG9dKYLBTG', 'Janene', 'Seago', '1999-03-23', '978540943', 'Helena', '9369', '1000-139', '171128138', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kbattram4z@nih.gov', '$2b$12$lRk6cpHw09fX2XJSNlyRcOdnVLmVbm916KcW3NrztqYyAXbasWRSe', 'Kaylil', 'Battram', '2000-10-02', '870356010', 'Menomonie', '997', '1000-139', '167956830', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('cstarzaker50@fastcompany.com', '$2b$12$VVVHgHR4RtvXhjnUxYdeTe80Krl1Xo04kLMLFL3eiAL53RdfykXu.', 'Curr', 'Starzaker', '1968-08-18', '198329335', 'Butternut', '811', '4795-894', '334757180', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('dquye51@dot.gov', '$2b$12$PmQg7abpF2bLoQYMOkYZV.APZT47fzKE.JN.W6G76ofVmXg.gw5Yq', 'Dion', 'Quye', '1984-04-26', '859137697', 'Golf Course', '8766', '4705-480', '681936757', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jstreater52@shareasale.com', '$2b$12$Zw5ovhj9rheDTh7VnygdIuHVtZ.JH1ZfiY1vIrK1k0zixLsl7Bt/W', 'Jami', 'Streater', '1947-05-01', '373702898', 'Rockefeller', '740', '4490-666', '728046851', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('apeiser53@smh.com.au', '$2b$12$bm8szbMAmjtFtBotqKXKbuqYzi1luPDvaOFYCn3b9VuXOkZ/ohJ1u', 'Andi', 'Peiser', '1982-07-08', '403634077', 'West', '997', '4480-330', '346187119', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('aagutter54@paginegialle.it', '$2b$12$R6quoFo9Yg4aYk6VuunVcOi/XxacHcoApZ25tRj4v48DGngLRFp4a', 'Abbot', 'Agutter', '1973-12-13', '349555650', 'Buena Vista', '92', '4940-027', '302606900', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('ckirkhouse55@webs.com', '$2b$12$Gq9P77qXOysnBujDlErGD.7M2mJ2KNrk0yB8ZwqqZ9pbpevY8UVZa', 'Clementius', 'Kirkhouse', '1950-10-03', '479064247', 'Carioca', '79412', '3040-474', '538069474', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bgrossier56@reddit.com', '$2b$12$aFGuz36xrN9y16KhuVrVSepP.1CP/yKe6BPLHPAW.4UWkjJtMXDLu', 'Barth', 'Grossier', '2015-11-08', '255649335', 'Westridge', '2', '7150-123', '365642237', 3);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('estanyon57@china.com.cn', '$2b$12$G6Y3DjpRUmCRTAcpN4TDxOi.QYQBfXpmxykGFXC78ppW1RaaQjaZ2', 'Ezechiel', 'Stanyon', '2003-05-27', '688184674', 'Independence', '124', '4490-666', '571204746', 2);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mgrindall58@xinhuanet.com', '$2b$12$tVKFIw/ggPRDclHm8E7oDuZ/trVsPbx0h99rxLc94QPzmbaV5SrHW', 'Montague', 'Grindall', '1961-09-21', '643313571', 'Oxford', '8', '1000-139', '524924830', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('sgarred59@buzzfeed.com', '$2b$12$89kadZRVMpORxiNq57sLhu5QgUVG2YWgfPYpYyVk4ezQB2UivSjmO', 'Sanders', 'Garred', '1999-05-19', '918403000', 'Dayton', '73', '3360-032', '956983833', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('gspurden5a@yellowpages.com', '$2b$12$MwbwSywc.yIFYuqmZ0ehS.s2jN616XkYMqlDqvjF9l0uLpiZUjnvW', 'Gram', 'Spurden', '1945-10-05', '274940858', 'Dorton', '5', '4200-014', '412621223', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('huebel5b@g.co', '$2b$12$hRpEfSm3Q5z6NnXQ19KEv.484Tu8DzxRLW4QHZdkCblCxaboB29q2', 'Hillier', 'Uebel', '1953-12-16', '502051250', 'Waxwing', '6', '3360-139', '279204383', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('lloveridge5d@engadget.com', '$2b$12$XOF5BvHuvGZiOlYZhzqJSeav9JDP2hNyGdBkLjdm7II0vvrfx3xPe', 'Lynnet', 'Loveridge', '1946-08-04', '123086779', 'Nelson', '8395', '2610-181', '123281924', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('pcaneo5f@nytimes.com', '$2b$12$lSk6o6QRnECw1R64YJp/NeZWQrUcHKT.AboSTeG/wRAVTeJgc.sy.', 'Philippe', 'Caneo', '2012-07-25', '888731376', 'Hollow Ridge', '2710', '2205-025', '491117111', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('mskedgell5g@yellowpages.com', '$2b$12$GzpTgJWUwrZi1JYXpjx3xe.vD5LLX0IiCy6KCBejloobvC17GGJqS', 'Marlyn', 'Skedgell', '2019-02-02', '439236686', 'Continental', '81135', '2205-025', '737149715', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('jkosiada5h@freewebs.com', '$2b$12$Cd7lTD9IId/EHzeZyEFVEOKvoyUeZbiB6ERQWNg2GZzdPsIvjT6l2', 'Jacquelin', 'Kosiada', '1933-07-13', '487064513', 'School', '57', '3360-139', '781024876', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('kbillborough5i@engadget.com', '$2b$12$7u94ZS9obwh6kxKY2unMbulXvlCzRhwTh477zraSYPKALtFx5M7ja', 'Kai', 'Billborough', '1933-10-13', '128047992', 'Fairfield', '603', '2645-539', '540030825', 1);
insert into Guest (email, passwd, first_name, last_name, birth_date, nif, street, port, postal_code, telephone, guest_type) values ('bpeyto5j@opensource.org', '$2b$12$SQ3ssj1nFYcf39uszgGNBuyu93SYYhqhOteLnepcT9FfkABshAyPS', 'Barbara-anne', 'Peyto', '1956-08-06', '429319530', 'Hoffman', '1', '4200-014', '533907927', 3);

insert into Driver (id, has_adr, has_cam, cc, is_working) values (1, false, false, '89045186', false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (2, true, false, '54414452', true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (3, true, true, '84114731', false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (4, false, false, '83140382', false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (5, true, true, '69864970', false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (6, false, true, '12522769', true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (7, false, false, '14679470', true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (8, false, true, '25765122', false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (9, false, true, '71094986', false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (10, false, false, '35262875', true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (11, true, true, '21268753', false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (12, false, true, '75791320', true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (13, false, false, '25453804', true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (14, true, true, '95577104', false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (15, false, true, '73227330', true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (16, true, false, '59633937', false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (17, true, false, '81622565', true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (18, false, true, '50033224', true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (19, false, false, '52058087', false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (20, false, true, '41675874', true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (21, false, true, '54194947', false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (22, true, true, '74998897', true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (23, false, true, '69219872', true);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (24, false, true, '67734477', false);
insert into Driver (id, has_adr, has_cam, cc, is_working) values (25, true, false, '38382875', true);

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

-- Stored Procedures

-- Link Worker or Client to Request
create or replace procedure link_guest (
    guest_id int,
    request_id int
)
language plpgsql
as $$
begin

    -- Get Guest
    insert into guestgroup (request, guest) values (request_id, guest_id);

return;

end $$;

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

-- Sp to Get Workers
CREATE OR replace PROCEDURE getWorkers()
LANGUAGE plpgsql
AS $$
BEGIN

    select
        guest.id,
        guest.email,
        guest.passwd,
        guest.first_name,
        guest.last_name,
        guest.birth_date,
        guest.nif,
        guest.street,
        guest.port,
        guest.postal_code,
        guest.telephone,
        guest.guest_type,
        guest.is_enabled
    from guest
    inner join guestType gt
        on guest.guest_type = gt.id
    where gt.name <> 'Cliente';

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
