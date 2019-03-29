SELECT id, podwladni, podlega, emp FROM pracownicy JOIN dane USING(id) ORDER BY id;
