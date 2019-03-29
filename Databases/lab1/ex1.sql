SELECT 	nazwisko FROM uzytkownik
	JOIN grupa 	       USING(kod_uz)
	JOIN przedmiot_semestr USING(kod_przed_sem)
	JOIN semestr 	       USING(semestr_id)
	JOIN przedmiot         USING(kod_przed)
WHERE przedmiot.nazwa    = 'Matematyka dyskretna (M)' 
AND   semestr.nazwa      = 'Semestr zimowy 2010/2011'
AND   grupa.rodzaj_zajec = 'c';

