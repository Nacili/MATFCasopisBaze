-- Initital queries called before triggers

-- insert into KORISNICKINALOG:
insert into KorisnickiNalog(ime, prezime, email, sifra) values('Administrator', 'Administrator', 'admin@admin', 'admin');
insert into KorisnickiNalog(ime, prezime, email, sifra) values('Gurednik', 'Gurednik', 'gurednik@gurednik', 'gurednik');
insert into KorisnickiNalog(ime, prezime, email, sifra) values('Urednik', 'Urednik', 'urednik@urednik', 'urednik');
insert into KorisnickiNalog(ime, prezime, email, sifra) values('Recenzent', 'Recenzent', 'recenzent@recenzent', 'recenzent');
insert into KorisnickiNalog(ime, prezime, email, sifra) values('Autor', 'Autor', 'autor@autor', 'autor');

-- insert into CASOPIS
insert into Casopis(idCasopis, ime, adresa, issnMaska)
values (1, 'MATFCasopis', 'Studentski trg 16', 'mjau');

-- insert into ULOGA:
insert into Uloga (naziv) values('Administrator');
insert into Uloga (naziv) values('Glavni urednik');
insert into Uloga (naziv) values('Urednik');
insert into Uloga (naziv) values('Recenzent');
insert into Uloga (naziv) values('Autor');

-- insert into Ima 
insert into Ima(IDKorisnickiNalogUloga,IDUlogaKorisnickiNalog,  vremeDobijanjaUloge)
values(1, 1, now());

insert into Ima(IDKorisnickiNalogUloga,IDUlogaKorisnickiNalog,  vremeDobijanjaUloge)
values(2, 2, now());
insert into Ima(IDKorisnickiNalogUloga,IDUlogaKorisnickiNalog,  vremeDobijanjaUloge)
values(2, 3, now());
insert into Ima(IDKorisnickiNalogUloga,IDUlogaKorisnickiNalog,  vremeDobijanjaUloge)
values(2, 4, now());
insert into Ima(IDKorisnickiNalogUloga,IDUlogaKorisnickiNalog,  vremeDobijanjaUloge)
values(2, 5, now());

insert into Ima(IDKorisnickiNalogUloga,IDUlogaKorisnickiNalog,  vremeDobijanjaUloge)
values(3, 3, now());
insert into Ima(IDKorisnickiNalogUloga,IDUlogaKorisnickiNalog,  vremeDobijanjaUloge)
values(3, 4, now());
insert into Ima(IDKorisnickiNalogUloga,IDUlogaKorisnickiNalog,  vremeDobijanjaUloge)
values(3, 5, now());

insert into Ima(IDKorisnickiNalogUloga,IDUlogaKorisnickiNalog,  vremeDobijanjaUloge)
values(4, 4, now());
insert into Ima(IDKorisnickiNalogUloga,IDUlogaKorisnickiNalog,  vremeDobijanjaUloge)
values(4, 5, now());

insert into Ima(IDKorisnickiNalogUloga,IDUlogaKorisnickiNalog,  vremeDobijanjaUloge)
values(5, 5, now());

-- insert into Privilegija:
insert into Privilegija(naziv) values('promena sopstvenih podataka');
insert into Privilegija(naziv) values('prijavljivanje rada');
insert into Privilegija(naziv) values('menjanje podatataka casopisu');
insert into Privilegija(naziv) values('menjanje podataka izdanju casopisa');
insert into Privilegija(naziv) values('dodeljivanje uloga korisnicima');
insert into Privilegija(naziv) values('ostavljanje komentara na rad');
insert into Privilegija(naziv) values('ostavljanje recenzije na rad');
insert into Privilegija(naziv) values('odobravanje rada');
insert into Privilegija(naziv) values('odbijanje rada');
insert into Privilegija(naziv) values('izlistavanje autora rada');
insert into Privilegija(naziv) values('izlistavanje radova u izdanju casopisa');
insert into Privilegija(naziv) values('izlistavanje zauzetih sala');
insert into Privilegija(naziv) values('izlistavanje radova na konferenciji');
insert into Privilegija(naziv) values('promena podataka ostalim korisnicima');
insert into Privilegija(naziv) values('postavljanje upita direktno nad bazom');


-- insert into Obezbedjuje

-- administrator
insert into Obezbedjuje(IDUlogaPrivilegija, idPrivilegija) values (1, 3);
insert into Obezbedjuje(IDUlogaPrivilegija, idPrivilegija) values (1, 14);
insert into Obezbedjuje(IDUlogaPrivilegija, idPrivilegija) values (1, 15);

-- glavni urednik
insert into Obezbedjuje(IDUlogaPrivilegija, idPrivilegija) values (2, 4);
insert into Obezbedjuje(IDUlogaPrivilegija, idPrivilegija) values (2, 5);

-- urednik
insert into Obezbedjuje(IDUlogaPrivilegija, idPrivilegija) values (3, 6);
insert into Obezbedjuje(IDUlogaPrivilegija, idPrivilegija) values (3, 8);
insert into Obezbedjuje(IDUlogaPrivilegija, idPrivilegija) values (3, 9);

-- recenzet
insert into Obezbedjuje(IDUlogaPrivilegija, idPrivilegija) values (4, 7);

-- autor
insert into Obezbedjuje(IDUlogaPrivilegija, idPrivilegija) values (5, 1);
insert into Obezbedjuje(IDUlogaPrivilegija, idPrivilegija) values (5, 2);
insert into Obezbedjuje(IDUlogaPrivilegija, idPrivilegija) values (5, 10);
insert into Obezbedjuje(IDUlogaPrivilegija, idPrivilegija) values (5, 11);
insert into Obezbedjuje(IDUlogaPrivilegija, idPrivilegija) values (5, 12);
insert into Obezbedjuje(IDUlogaPrivilegija, idPrivilegija) values (5, 13);


-- insert into Sala
insert into Sala(idSala, adresa, kapacitet) values (706, 'Studentski trg 16', 200);
insert into Sala(idSala, adresa, kapacitet) values (830, 'Studentski trg 16', 100);


-- insert into Sablon
insert into Sablon(naziv, sadrzaj) values('Uspesno registrovanje', 'Uspesno ste se reistrovali');
insert into Sablon(naziv, sadrzaj) values('Uspesna promena podataka', 'Vasi podaci su uspesno poslati');
insert into Sablon(naziv, sadrzaj) values('Obavestenje o novopristiglom radu', 'Postovani urednice, vasoj oblasti dodeljen je jos jedan rad');
insert into Sablon(naziv, sadrzaj) values('Brisanje korisnika', 'Postovani, zelim da obrisem korisnika iz sistema. Ime: Prezime');
insert into Sablon(naziv, sadrzaj) values('Predlog za recenziranje', 'Postovani, da li ste u mogucnosti da
recenzirate rad pod nazivom: ');
insert into Sablon(naziv, sadrzaj) values('Odbijanje', 'Postovani, ne zelim da recenziram rad sa nazivom: ');
insert into Sablon(naziv, sadrzaj) values('Rad je prihvacen', 'Postovani, cestitamo! Vas rad je prihvacen.');
insert into Sablon(naziv, sadrzaj) values('Rad je odbijen', 'Postovani, Vas rad je odbijen jer....');
insert into Sablon(naziv, sadrzaj) values('Komentarisanje rada', 'Postovani, na Vas rad je ostavljen komentar.');
