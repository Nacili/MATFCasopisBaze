delimiter |

-- CASOPIS:

-- insert: podaci mogu biti samo o jednom casopisu, ne sme se dodavati novi red
create trigger Casopis_insert before insert on Casopis
for each row
begin
	signal sqlstate '45000' set message_text = 'Greska: Ne moze se dodavati novi red u tabelu Casopis';
end |


-- update
create trigger Casopis_insert before insert on Casopis
for each row
begin
	-- samo administrator može da menja ove podatke
    declare idKorisnika integer;
    set idKorisnika = 'select idKorisnickiNalog from KorisnickiNalog';
	if(idKorisnika != 1) then
		signal sqlstate '45000' set message_text = 'Samo administrator moze da vrsi promene na tabeli Casopis';
    end if;
end |


-- delete: podaci o casopisu moraju postojati, ne sme se brisati vec postojeci red
create trigger Casopis_delete before delete on Casopis
for each row
begin
	signal sqlstate '45000' set message_text = 'Greska: Ne moze se brisati iz tabele Casopis';
end |

-- END CASOPIS
-- ------------------------------------------------------------------------------------------------------------------------

-- IMA:

-- insert -> proveri da li ulogu dodeljuje Glavni urednik

-- update -> ne sme da se radi update
create trigger Ima_update before update on Ima
for each row
begin
	signal sqlstate '45000' set message_text = 'Greska: Ne moze se update-ovati ova tabela';
end |

-- delete -> proveri da li ulogu uklanja Glavni urednik

-- END IMA:
-- ------------------------------------------------------------------------------------------------------------------------

-- IZDANJECASOPISA:

-- insert -> proveri da li unosi Glavni urednik

-- update -> proveri da li menja Glavni urednik

-- delete -> prvoeri da li briše Glavni urednik

-- END IZDANJECASOPISA:
-- ------------------------------------------------------------------------------------------------------------------------


-- IZLAZE:

-- insert -> ?

-- update -> ?

-- delete -> ?

-- END IZLAZE:
-- ------------------------------------------------------------------------------------------------------------------------


-- KONFERENCIJA:

-- insert -> ?

-- update -> ?

-- delete -> ?

-- END IKONFERENCIJA:
-- ------------------------------------------------------------------------------------------------------------------------

-- KORISNICKINALOG:

-- insert -> proveriti da li vec postoji korisnik sa tim email-om
create trigger KorisnickiNalog_insert before insert on KorisnickiNalog
for each row
begin
	declare em varchar(45);
    set em = "select email from KorisnickiNalog where email = new.email";
    if(em is not null) then
		signal sqlstate '45000' set message_text = 'Greska: Ovaj korisnik je vec registrovan';
    end if;
end |

-- update -> ?

-- delete -> ?

-- END KORISNICKINALOG:
-- ------------------------------------------------------------------------------------------------------------------------

-- OBEZBEDJUJE:

-- insert -> ne mogu da se dodaju nove privilegije ulozi

-- update -> nope

-- delete -> ne mogu da se brisu dodeljene privilegije ulozi

-- END OBEZBEDJUJE:
-- ------------------------------------------------------------------------------------------------------------------------

-- ODRZAVASE:

-- insert -> ?

-- update -> ?

-- delete -> ?

-- END ODRZAVASE:
-- ------------------------------------------------------------------------------------------------------------------------

-- OSTAVLJAKOMENTAR:

-- insert -> Glavni urednik/urednik

-- update -> Glavni urednik/urednik

-- delete -> Glavni urednik/urednik

-- END OSTAVLJAKOMENTAR:
-- ------------------------------------------------------------------------------------------------------------------------

-- PISE:

-- insert -> ?

-- update -> ?

-- delete -> ?

-- END PISE:
-- ------------------------------------------------------------------------------------------------------------------------

-- POSLATAPORUKA:

-- insert -> ?

-- update -> ?

-- delete -> ?

-- END POSLATAPORUKA:
-- ------------------------------------------------------------------------------------------------------------------------

-- PRIJAVLJUJE:

-- insert -> automatski postavlja vreme i status rada
create trigger Prijavljuje_insert before insert on Prijavljuje
for each row
begin
	set vremePrijave = now();
    set status = 'prijavljen';
end |

-- update -> ne moze
create trigger Prijavljuje_update before update on Prijavljuje
for each row
begin
	signal sqlstate '45000' set message_text = 'Greska: Ne moze da se radi update nad tabelom Prijavljuje';
end |

-- delete -> ?

-- END PRIJAVLJUJE:
-- ------------------------------------------------------------------------------------------------------------------------

-- PROMENASOPSTVENIHPODATAKA:

-- insert -> automatski postavlja vreme
create trigger PromenaSopstvenihPosataka_insert before insert on PromenaSopstvenihPodataka
for each row
begin
	set vremePromene = now();
end |

-- update -> automatski postavlja vreme
create trigger PromenaSopstvenihPosataka_update before update on PromenaSopstvenihPodataka
for each row
begin
	set new.vremePromene = now();
end |

-- delete -> ?

-- END PROMENASOPSTVENIHPODATAKA:
-- ------------------------------------------------------------------------------------------------------------------------

