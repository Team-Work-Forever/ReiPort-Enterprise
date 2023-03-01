FROM postgres as pt

WORKDIR /usr/src/app
COPY criardb /usr/src/app/
COPY dataBase.sql /usr/src/app/

WORKDIR /usr/src/app

ENTRYPOINT [ "psql", "-h", "::1" ]