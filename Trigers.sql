delimiter |

-- CASOPIS:
drop trigger if exists Casopis_insert |
-- insert: podaci mogu biti samo o jednom casopisu, ne sme se dodavati novi red
create trigger Casopis_insert before insert on Casopis
for each row
begin
	signal sqlstate '45000' set message_text = 'Greska: Ne moze se dodavati novi red u tabelu Casopis';
end |

drop trigger if exists Casopis_update |
-- update
create trigger Casopis_update before update on Casopis
for each row
begin
	-- samo administrator može da menja ove podatke
    declare idUloge integer;
    set idUloge = (select IDUlogaKorisnickiNalog from Ima where IDKorisnickiNalogUloga = new.IDKorisnickiNalogCasopis);
	if(idUloge != 1) then
		signal sqlstate '45000' set message_text = 'Samo administrator moze da vrsi promene na tabeli Casopis';
    end if;
end |

drop trigger if exists Casopis_delete |
-- delete: podaci o casopisu moraju postojati, ne sme se brisati vec postojeci red
create trigger Casopis_delete before delete on Casopis
for each row
begin
	signal sqlstate '45000' set message_text = 'Greska: Ne moze se brisati iz tabele Casopis';
end |

-- END CASOPIS
-- ------------------------------------------------------------------------------------------------------------------------

-- IMA:
drop trigger if exists Ima_update |
-- update -> ne sme da se radi update
create trigger Ima_update before update on Ima
for each row
begin
	signal sqlstate '45000' set message_text = 'Greska: Ne moze se update-ovati ova tabela';
end |

-- KORISNICKINALOG:
drop trigger if exists KorisnickiNalog_insert_before |
-- insert -> proveriti da li vec postoji korisnik sa tim email-om
create trigger KorisnickiNalog_insert_before before insert on KorisnickiNalog
for each row
begin
	declare em varchar(45);
    set em = (select email from KorisnickiNalog where email = new.email);
    if(em is not null) then
		signal sqlstate '45000' set message_text = 'Greska: Korisnik sa ovom email adresom je vec registrovan';
    -- else
    --    insert into Ima values (new.idKorisnickiNalog,now(),5);
    end if;
end |

drop trigger if exists KorisnickiNalog_insert_after |
create trigger KorisnickiNalog_insert_after after insert on KorisnickiNalog
for each row
begin
        insert into Ima values (new.idKorisnickiNalog,now(),5);
end |

drop trigger if exists KorisnickiNalog_update |
-- update -> ?
create trigger KorisnickiNalog_update before update on KorisnickiNalog
for each row
begin
	declare em varchar(45);
    set em = (select email from KorisnickiNalog where email = new.email and idKorisnickiNalog != old.idKorisnickiNalog);
    if(em is not null) then
		signal sqlstate '45000' set message_text = 'greska: Korisnik sa ovom email adresom je vec registrovan';
    end if;
    if(new.sifra is not null and new.sifra like '') then 
        signal sqlstate '45000' set message_text = 'greska: Sifra mora sadrzati karaktere';
    end if;
end |

-- END KORISNICKINALOG:
-- ------------------------------------------------------------------------------------------------------------------------

-- OBEZBEDJUJE:

drop trigger if exists Obezbedjuje_insert |
-- insert -> ne mogu da se dodaju nove privilegije ulozi
create trigger Obezbedjuje_insert before insert on Obezbedjuje
for each row
begin
	signal sqlstate '45000' set message_text = 'Greska: Nove privilegije se ne mogu dodavati';
end |

drop trigger if exists Obezbedjuje_update |
-- update -> ne mogu da se menjati privilegije ulozi
create trigger Obezbedjuje_update before update on Obezbedjuje
for each row
begin
	signal sqlstate '45000' set message_text = 'Greska: Nove privilegije se ne mogu dodavati';
end |

drop trigger if exists Obezbedjuje_delete |
-- delete -> ne mogu da se brisu dodeljene privilegije ulozi
create trigger Obezbedjuje_delete before delete on Obezbedjuje
for each row
begin
	signal sqlstate '45000' set message_text = 'Greska: Privilegije se ne mogu oduzimati';
end |
-- END OBEZBEDJUJE:
-- ------------------------------------------------------------------------------------------------------------------------
-- OSTAVLJAKOMENTAR:
drop trigger if exists OstavljaKomentar_insert |
-- insert -> Glavni urednik/urednik
create trigger OstavljaKomentar_insert before insert on OstavljaKomentar
for each row
begin
    declare idUloge integer;
    set idUloge = (select IDUlogaKorisnickiNalog from Ima where IDKorisnickiNalogUloga = new.KorisnickiNalog_idKorisnick);
    if(idUloge != 2 and idUloge != 3) then
	    signal sqlstate '45000' set message_text = 'Greska: Komentar mogu ostavljati samo urednik i glavni urednik';
    end if;
end |

drop trigger if exists OstavljaKomentar_update |
-- update -> Glavni urednik/urednik
create trigger OstavljaKomentar_update before update on OstavljaKomentar
for each row
begin
    declare idUloge integer;
    set idUloge = (select IDUlogaKorisnickiNalog from Ima where IDKorisnickiNalogUloga = new.KorisnickiNalog_idKorisnick);
    if(idUloge != 2 and idUloge != 3) then
	    signal sqlstate '45000' set message_text = 'Greska: Komentar mogu ostavljati samo urednik i glavni urednik';
    end if;
end |

-- END OSTAVLJAKOMENTAR:
-- ------------------------------------------------------------------------------------------------------------------------

-- PRIJAVLJUJE:
drop trigger if exists Prijavljuje_insert |
-- insert -> automatski postavlja vreme i status rada
create trigger Prijavljuje_insert before insert on Prijavljuje
for each row
begin
    set new.vremePrijave = now();
    update Rad set status = 'prijavljen' where new.IDRadKorisnik = idRada;
end |

drop trigger if exists Prijavljuje_update |
-- update -> ne moze
create trigger Prijavljuje_update before update on Prijavljuje
for each row
begin
	signal sqlstate '45000' set message_text = 'Greska: Ne moze da se radi update nad tabelom Prijavljuje';
end |

-- END PRIJAVLJUJE:
-- ------------------------------------------------------------------------------------------------------------------------

-- PROMENASOPSTVENIHPODATAKA:
drop trigger if exists PromenaSopstvenihPosataka_insert |
-- insert -> automatski postavlja vreme
create trigger PromenaSopstvenihPosataka_insert before insert on PromenaSopstvenihPodataka
for each row
begin
	set new.vremePromene = now();
end |
drop trigger if exists PromenaSopstvenihPosataka_update |
-- update -> automatski postavlja vreme
create trigger PromenaSopstvenihPosataka_update before update on PromenaSopstvenihPodataka
for each row
begin
	set new.vremePromene = now();
end |

-- END PROMENASOPSTVENIHPODATAKA:
-- ------------------------------------------------------------------------------------------------------------------------

