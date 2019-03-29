SELECT imie, nazwisko, data FROM uzytkownik 
	JOIN wybor    	       USING(kod_uz)
	JOIN grupa    	       USING(kod_grupy)
	JOIN przedmiot_semestr USING(kod_przed_sem)
	JOIN przedmiot         USING(kod_przed)
	JOIN semestr 	       USING(semestr_id)
WHERE semestr.nazwa      = 'Semestr zimowy 2010/2011'
AND   przedmiot.nazwa    = 'Matematyka dyskretna (M)'
AND   grupa.rodzaj_zajec = 'w'

ORDER BY wybor.data ASC;

