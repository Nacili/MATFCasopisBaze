# MATFCasopis
## Cilj:
Projektovanje baze za MATF Elektronski časopis
## Opis problema

Za **Korisnika** se prati id, ime, prezime, email, sifra, telefon, adresa, postanski broj, vreme poslednjeg logina. Korisnik _Upravlja_ svojim sopstvenim podešavanjima - može upravljati samo svojim podacima, ali i ne mora. Način komunikacije između dva korisnika se ostvaruje tako što korisnik drugom korisniku _Šalje_ šablon za koji se prati id i tekst šablona - korisnik može slati više šablona, ali ne mora slati ni jedan. Šablon može biti poslat od strane više korisnika, ali ne mora ni jedan.

Korisnik _**Ima ulogu**_ u sistemu, i za tu **Ulogu** se prati id i naziv. Mora imati jednu ulogu, ali može i više, a ulogu mora imati bar jedan korisnik, ali može i više. Uloge mogu biti: glavni urednik, urednik, autor, recenzent, administrator. Prilikom priljavljivanja na sistem svi korisnici su autori (sem administratora), a glavni urednik (i samo on) im kasnije _Dodeljuje_ uloge, a on sam može dodeliti više uloga. Uloga _**Obezbeđuje**_ dodatne **Privilegije** korisnicima sistema, za koje se prati id i naziv. Uloga obezbeđuje barem jednu, a može i više privilegija, privilegije moraju biti dodeljene barem jednoj ulazi, ali mogu i više.

Administrator može da _Menja podatke- ostalih korisnika, kao i da _Menja podešavanja_ samog časopisa. Podešavanja samo jednog časopisa menja samo administrator, koji jedini može menjati podatke ostalih korisnika i to više njih, ali ni ne mora.

Autor _**Prijavljuje**_ **Rad**, za koji se prati id, naslov, link ka pdf verziji, status, da li je objavljen. On može prijaviti više radova, a ne mora ni jedan, ali samo jedan autor može prijaviti rad. Samo onaj ko je prijavio rad može i da ga povuče, a onaj ko je prijavio radove može da povuče i više svojih radova, ali ne mora ni jedan.

Rad može imati jednu ili više **Verzija**, a sama verzija može biti verzija samo jednog rada.


Recenzent _**Objavljuje**_ **Recenziju** za koju se prati id, komentar, rad na koji je ostavljena, koji recenzent je objavio  i za tu objavu se čuvaju vreme i datum. Recenzent može objaviti više recenzija, ali ne mora ni jednu, a recenziju mora objaviti barem jedan recenzent, ali može i više.

(Glavni) urednik može a ne mora da  _**Ostavlja komentar**_ na rad, i to na njih više, a rad može komentarisati i njih više, ali ne mora niko.

Glavni urednik i samo on može da _Uređuje_ **Izdanje časopisa** za koje se prati issn broj, naslov, napomena, minimalan i maksimalan broj radova, i to barem jedno, a može i njih više.

Izdanje časopisa može biti **Zimsko** i **Letnje**.

Letnje izdanje se prijavljuje _**Učestvuje**_ određenog datuma na **Konferenciji** za koju se prati id, naziv, datum početka, datum završetka. Letnje izdanje može da učestvuje na barem jednoj konferenciji i može i na više, a na samoj konferenciji može da učestvuje više letnjih izdanja, ali ne mora ni jedno. Konferencija se _**Održava**_ u **Sali** i to mora u bar jednoj, a može i u više, a u samoj sali se može održavati više konferencija, ali ne mora ni jedna.

U sali radove određenog datuma u određeno vreme _**Izlaže**_ onaj koji je taj rad i prijavio i to on ne mora izlagati ni u jednoj sali, a može i u više, a u sali ne mora niko da izlaže, ali ako izlaže onda je to samo jedan autor.


## Zadovoljivost uslova
* Nezavisni entiteti
  * Korisnik
  * Uloga
  * Privilegije
  * Šablon
  * Rad
  * Recenzija
  * Konferencija
  * Sala
* Agregirani entiteti
  * Ima ulogu
  * Obezbeđuje
  * Prijavljuje
  * Ostavlja komentar
  * Objavljuje
  * Učestvuje
  * Izlaže
  * Održava se
* Rekurzivni odnos
  * Upravlja
* Slab entitet ili odnos specijalizacija/generalizacija
  * Generalizacija specijalizacija: Izdanje časopisa -> Letnje, Izdanje časopisa -> Zimsko
  * Zavisni entitet: Verzija
* Trigeri kojima se menja stanje baze
  * Triger1 - Prilikom prijave rada, koautori se automatski dodaju u spisak autora ako već ne postoje
  * Triger2 - Na osnovu datuma izdanja čaopisa se automatski određuje da li je izdanje časopisa letnje ili zimsko
  * Triger3 - Prilikom nove prijave istog rada se automatski pravi nova verzija
  * Triger4 - Prilikom objave recenzije se automatski postavljaju datum i vreme na trenutan datum i vreme
