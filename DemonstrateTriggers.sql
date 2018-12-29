-- 0 Registrovanje
select * from KorisnickiNalog;
select * from Ima;

-- 1 Promena sopstvenih podataka
select * from KorisnickiNalog where idKorisnickiNalog=5;
select * from PromenaSopstvenihPodataka;

-- 2 Prijava rada
select * from Rad;
select * from Verzija;
select * from Prijavljuje;
select * from Pise;

-- 3 Prijava verzije
select * from Rad where naslov = 'Naslov';
select * from Verzija where idRada=20;

-- 4 OStavljanje recenzije
select * from Recenzija;

-- 5 Odobravanje rada
select * from Rad where naslov = 'Naslov';

-- 6 Dodeljivanje uloga korisnicima
select * from Ima where IDKorisnickiNalogUloga=5;