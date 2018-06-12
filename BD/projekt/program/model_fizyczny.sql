/* utworzenie tabeli pracownicy, id jest sekwencyjnie zwiekszane */
CREATE TABLE pracownicy(
    id         BIGSERIAL PRIMARY KEY,
    podwladni  varchar(20)[],
    podlega    varchar(20)[],
    haslo      text NOT NULL
);
/* utworzenie tabeli dane, klucz opcy id*/
CREATE TABLE dane(
    id         BIGINT references pracownicy(id) ON DELETE CASCADE,
    emp        varchar(20) NOT NULL UNIQUE,
    dane       text
);
/* utworzenie tablicy prezesa */
CREATE TABLE prezes(
    id         BIGINT references pracownicy(id)
);
/* tworzenie użytkownika i nadawanie praw */
CREATE USER app;
ALTER USER app WITH PASSWORD 'qwerty'; /* domyślnie */
GRANT ALL ON pracownicy TO app;
GRANT ALL ON dane TO app;
GRANT SELECT ON prezes TO app;
GRANT ALL ON pracownicy_id_seq TO app;
/* utworzenie indeksu dla pola emp -> jest to pole typu varchar, więc czas wyszukiwania O(1)*/
CREATE INDEX h_dane_emp_index ON dane USING hash(emp);
