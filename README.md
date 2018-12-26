# MATFCasopis
## Cilj:
Projektovanje baze za MATF Elektronski časopis
## Opis problema

Za korisnika se prati id, ime, prezime, email, sifra, telefon, adresa, postanski broj, vreme poslednjeg logina. Korisnik može da upravlja svojim sopstvenim podacima.

Korisnik drugim korisnicima može slati šablone za koje se prati id i tekst šablona.

Korisnik ima barem jednu ulogu za koju se prati id i naziv, pri čemu za sve uloge mora postojati barem jedan korisnik koji je na njih raspoređen.Uloge mogu biti: glavni urednik, urednik, autor, recenzent, administrator. Prilikom priljavljivanja na sistem svi korisnici su autori (sem administratora), a glavni urednik (i samo on) im kasnije dodeljuje uloge. Uloga obezbeđuje dodatne prievilegije korisnicima sistema, za koje se prati id i naziv. Uloga korisniku obezbeđuje barem jednu privilegiju, a svaka od privilegija mora biti dodeljena barem jednom Privilegije mogu biti: pisanje rada, prijavljivanje rada, menjanje podataka časopisu, menjanje podataka izdanju časopisa, dodeljivanje uloga korisnicima, ostavljanje komentara na rad, ostavljanje recenzije na rad, odobravanje rada, odbijanje rada.

Administrator može da menja podatke ostalim korisnicima, i časopisu za koji se prati naziv, adresa, ISSN maska, web stranica.

Rad za koji se prati id, naslov, link ka pdf verziji, status, da li je objavljen, piše više korisnika, ali može da ga prijavi samo jedan autor. Korisnik može imati ulogu autora, ali da nije još uvek prijavio, ni učestvovao u pisanju ni jednog rada. Rad može imati jednu ili više verzija, za koju se prati i njen id, link, datum pravljenja verzije.


Recenzent može da objavljuje recenzije na verziju rada za koju se prati id, komentar i za tu objavu se čuvaju vreme i datum. Za verziju na rad ne mora da postoji ni jedna verzija, a može da postoji i više.

Glavni urednik, kao i ostali urednici mogu da ostavljaju komentare na radove, s tim što ostavljanje komentara na rad nije obavezno.

Glavni urednik i samo on uređuje izdanja časopisa za koje se prati issn broj, datum objave izdanja, naslov, napomena, minimalan i maksimalan broj radova, da li je letnje izdanje, kao i prihvaćeni radovi koji se u okviru tog izdanja objavljuju. Časopis objavljuje dva izdanja u toku godine i jedno od njih je letnje.

Radovi objavljeni u letnjem izdanju mogu da učestvuju na najviše jednoj konferenciji za koju se prati id, naziv, datum početka, datum završetka. Na samoj konferenciji može da učestvuje više radova iz letnjih izdanja (ne nužno iz iste godine u kojoj se održava i konferencija), ali ne mora ni jedno. Konferencija se održava u barem jednoj sali, a u samoj sali može da se održava i više konferencija.

Radove u sali određenog datuma u određeno vreme može da izlaže neki od njegovih autora.


## Zadovoljivost uslova
* Nezavisni entiteti
  * Korisnički nalog
  * Uloga
  * Privilegija
  * Šablon
  * Rad
  * Recenzija
  * Konferencija
  * Sala
  * Časopis
  * Izdanje časopisa
* Agregirani entiteti
  * Ima
  * Piše
  * Obezbeđuje
  * Prijavljuje
  * Ostavlja komentar
  * Učestvuje
  * Izlaže
  * Održava se
  * Poslata poruka
* Rekurzivni odnos
  * Promena sopstvenih podataka
* Slab entitet ili odnos specijalizacija/generalizacija:
  * Zavisni entitet: Verzija
* Trigeri kojima se menja stanje baze
  * Triger1 - Prilikom pravljenja nove verzije rada, link rada se postavlja na link verzije
  * Triger2 - Prilikom pravljenja nove verzije rada se automatski postavljaju datum i vreme na trenutan datum i vreme
  * Triger3 - Prilikom prijave rada se automatski pravi i njegova prva verzija
  * Triger4 - Prilikom prijave novog korisnika automatski mu se dodeljuje i status autora
