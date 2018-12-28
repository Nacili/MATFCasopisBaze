#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mysql.h>
#include <stdarg.h>
#include <errno.h>

#define QUERY_SIZE 256
#define BUFFER_SIZE 80

MYSQL *konekcija;	/* Promenljiva za konekciju. */
MYSQL_RES *rezultat;	/* Promenljiva za rezultat. */
MYSQL_ROW red;	/* Promenljiva za jedan red rezultata. */
MYSQL_FIELD *polje;	/* Promenljiva za nazive kolona. */
int broj_kolona;		/* Pomocna promenljiva za broj kolona. */	

char query[QUERY_SIZE];	/* Promenljiva za formuaciju upita. */

static void error_fatal (char *format, ...){
	/* Lista argumenata funkcije. */
	va_list arguments;

	/* Stampa se string predstavljen argumentima funkcije. */
	va_start (arguments, format);
	vfprintf (stderr, format, arguments);
	va_end (arguments);

	/* Prekida se program. */
	exit (EXIT_FAILURE);
}


void promena_sopstvenih_podataka(int idKorisnickiNalog){
	printf("Unesite redni broj podatka koji zelite da menjate:\n");
	printf("\t1. Ime\n");
	printf("\t2. Prezime\n");
	printf("\t3. Email\n");
	printf("\t4. Telefon\n");
	printf("\t5. Postanski broj\n");
	printf("\t6. Adresa\n");
	printf("\t7. Lozinka\n");
	
	int rb_podatka;
	scanf("%d", &rb_podatka);
	
	printf("Unesite izmenu:\n");
	
	char izmena[45];
	int line_size = 45;
	char c = getc(stdin);
	fgets(izmena, line_size, stdin);
	size_t length = strlen(izmena);
	izmena[length-1] = '\0';

	switch(rb_podatka){
		case 1: sprintf(query, "update KorisnickiNalog set ime = \"%s\" where idKorisnickiNalog = \"%d\"", izmena, idKorisnickiNalog); break;
		case 2: sprintf(query, "update KorisnickiNalog set prezime = \"%s\" where idKorisnickiNalog = \"%d\"", izmena, idKorisnickiNalog); break;
		case 3: sprintf(query, "update KorisnickiNalog set email = \"%s\" where idKorisnickiNalog = \"%d\"", izmena, idKorisnickiNalog); break;
		case 4: sprintf(query, "update KorisnickiNalog set telefon = \"%s\" where idKorisnickiNalog = \"%d\"", izmena, idKorisnickiNalog); break;
		case 5: sprintf(query, "update KorisnickiNalog set ptt = \"%s\" where idKorisnickiNalog = \"%d\"", izmena, idKorisnickiNalog); break;
		case 6: sprintf(query, "update KorisnickiNalog set adresa = \"%s\" where idKorisnickiNalog = \"%d\"", izmena, idKorisnickiNalog); break;
		case 7: sprintf(query, "update KorisnickiNalog set sifra = \"%s\" where idKorisnickiNalog = \"%d\"", izmena, idKorisnickiNalog); break;
		default: printf("Pogresan broj akcije!\n"); return; break;
	}
	
	if(mysql_query(konekcija, query) != 0){
		error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
}

void prijavljivanje_rada(int idKorisnickiNalog){

	
	char naslov[200];
	char link[200];
	int line_size = 200;
	
	printf("Unesite naslov rada\n");
	char c = getc(stdin);
	fgets(naslov, line_size, stdin);
	printf("Unesite link ka radu\n");
	fgets(link, line_size, stdin);
	size_t length = strlen(naslov);
	naslov[length-1] = '\0';
	length = strlen(link);
	link[length-1] = '\0';
	
	
	// proveriti da li već postoji
	// ako postoji, onda to znači da se prijavljuje nova verzija istog rada
	sprintf(query,"select idRada from Rad where naslov = \'%s\'", naslov);
	if(mysql_query(konekcija, query) != 0){
		error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
	rezultat = mysql_use_result (konekcija);
	red = mysql_fetch_row(rezultat);
	if(red != NULL){
		int id = atoi(red[0]);
		mysql_free_result(rezultat);
		// provera da li je to autor koji je odgovoran za rad: ne može se menjati tuđi rad
		sprintf(query, "select * from Prijavljuje where IDRadKorisnik = %d", idKorisnickiNalog);
		if(mysql_query(konekcija, query) != 0){
			error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
		}
		rezultat = mysql_use_result (konekcija);
		red = mysql_fetch_row(rezultat);
		if(red != NULL){
			printf("Ne mozete menjati rad koji niste prijavili!\n");
			mysql_free_result(rezultat);
			return;
		}
		mysql_free_result(rezultat);
		printf("Rad vec postoji i bice prijavljena njegova verzija!\n");
		sprintf(query,"select brojVerzije from Verzija where idRada = %d", id);
		if(mysql_query(konekcija, query) != 0){
			error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
		}
		rezultat = mysql_use_result (konekcija);
		red = mysql_fetch_row(rezultat);
		// mora da postoji prva verzija
		int idVerzija = atoi(red[0]);
		mysql_free_result(rezultat);
		sprintf(query,"insert into Verzija(idRada, pdfStorageLinkId, brojVerzije) values(%d, \'%s\',  %d)", id, link, idVerzija+1);
		if(mysql_query(konekcija, query) != 0){
			error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
		}
		return;
	}
	
// 	mysql_free_result(rezultat);
	
	// rad ne postoji i dodaje se u bazu
	sprintf (query, "insert into Rad(naslov, pdfStorageLinkId, status, objavljen) values(\"%s\", \"%s\", \"prijavljen\", false)", naslov, link);
	
	if(mysql_query(konekcija, query) != 0){
			error_fatal("Gresk1a u upitu %s\n", mysql_error (konekcija));
	}
	
	sprintf(query, "select last_insert_id()");
	if(mysql_query(konekcija, query) != 0){
		error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
	rezultat = mysql_use_result (konekcija);
	red = mysql_fetch_row(rezultat);
	int poslednji_rad = atoi(red[0]);
	
	mysql_free_result(rezultat);
	
// 	printf("ID: %d\n", poslednji_rad);
	
	sprintf (query, "insert into Pise(IDRadKorisnickiNalog, IDKorisnickiNalogRad) values(%d, %d)", poslednji_rad, idKorisnickiNalog);
	
	if(mysql_query(konekcija, query) != 0){
		error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
	
	
	printf("Navedite ukupan broj autora rada ne racunajuci sebe\n");
	int n;	// ukupan broj autora
	scanf("%d", &n);
	
	printf("Navedite ime i prezime svakog autora i njegovu mejl adresu, a zatim pritisnite ENTER\n");
	int i;
	for(i=0; i<n; i++){
		char ime[45];
		char prezime[45];
		char email[45];
		
		scanf("%s %s %s", ime, prezime, email);
		printf("Korisnik: %s %s %s\n", ime, prezime, email);
		
		sprintf(query, "select idKorisnickiNalog from KorisnickiNalog where ime = \'%s\' and prezime = \'%s\' and email = \'%s\'", ime, prezime, email);
// 		printf("%s\n", query);
		
		if(mysql_query(konekcija, query) != 0){
			error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
		}
	
		rezultat = mysql_use_result (konekcija);
		red = mysql_fetch_row(rezultat);
	
		int poslednji_korisnik;
		if(red == NULL){
			printf("Korisnik ne postoji i bice dodat u sistem\n");
			mysql_free_result(rezultat);
			sprintf(query, "insert into KorisnickiNalog(ime, prezime, email, sifra) values(\"%s\", \"%s\", \"%s\", 'sifra')", ime, prezime, email);
			if(mysql_query(konekcija, query) != 0){
				error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
			}
			sprintf(query, "select last_insert_id()");
			if(mysql_query(konekcija, query) != 0){
				error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
			}
			rezultat = mysql_use_result (konekcija);
			red = mysql_fetch_row(rezultat);
			poslednji_korisnik = atoi(red[0]);
		}
		else{
// 			printf("Korisnik postoji\n");
			poslednji_korisnik = atoi(red[0]);
		}
		
		mysql_free_result(rezultat);
		
// 		ubaci u pise
		sprintf (query, "insert into Pise(IDRadKorisnickiNalog, IDKorisnickiNalogRad) values(%d, %d)", poslednji_rad, poslednji_korisnik);
		if(mysql_query(konekcija, query) != 0){
			error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
		}
	}
}


void dodeljivanje_uloga_korisnicima(){
	
	// Izlistavanje korisnika
	printf("Spisak korisnika:\n");
	sprintf(query, "select ime, prezime from KorisnickiNalog");
	if(mysql_query(konekcija, query) != 0){
		error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
	rezultat = mysql_use_result(konekcija);
	int i = 0;
	while((red = mysql_fetch_row(rezultat)) != 0){
		printf("\t%d. %s %s\n", i+1, red[0], red[1]);
		i++;
	}
	mysql_free_result(rezultat);
	
	// Odabir rednog broja korisnika - posto je njegov redni broj ujedno i njegov id, dovoljno je pretraziti po rednom broju korisnika
	// Ovako je uredjeno samo zbog lakse simulacije, inace jako lose u pogledu bezbednosti!!!
	printf("Odaberite redni broj korisnika kojem zelite da dodelite ulogu\n");
	scanf("%d", &i);

	// Izlistavanje uloga koje je moguce dodeliti
	printf("Spisak uloga:\n");
// 	sprintf(query, "select naziv from Uloga where idUloga not in (1, 2, 5)");
// 	if(mysql_query(konekcija, query) != 0){
// 		error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
// 	}
// 	rezultat = mysql_use_result(konekcija);
// 	int j = 0;
// 	while((red = mysql_fetch_row(rezultat)) != 0){
// 		printf("\t%d. %s\n", j+1, red[0]);
// 		j++;
// 	}
// 	mysql_free_result(rezultat);
	
	// Ovo bi bio pametan nacin
	// Medjutim, uloga ima samo 5:
	// 1 i 2 su Administrator i Glavni urednik i moze postojati samo 1 u sistemu
	// 5 je Autor, a ta je uloga trigerom automatski dodata prilikom registracije i upit bi izbacio gresku
	// Ostaju samo 3 i 4 sto je lakse i efikasnije odraditi obicnim if-om nego povlaciti upit iz baze
	
	printf("\t1. Urednik\n\t2. Recenzent\n");
	
	// Odabir uloge
	int j = 0;
	printf("Odaberite redni broj uloge koju zelite da dodelite korisniku\n");
	scanf("%d", &j);
	
	// Ubacivanje u bazu
	if(j == 1){
		sprintf(query, "insert into Ima(IDKorisnickiNalogUloga,IDUlogaKorisnickiNalog,  vremeDobijanjaUloge) values(%d, 3, now())", i);
	}
	else if(j == 2){
		sprintf(query, "insert into Ima(IDKorisnickiNalogUloga,IDUlogaKorisnickiNalog,  vremeDobijanjaUloge) values(%d, 4, now())", i);
	}
	else{
		printf("Odabrali ste nepostojecu ulogu\n");
		return;
	}
	if(mysql_query(konekcija, query) != 0){
		error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
}

void ostavljanje_recenzije_na_rad(int idKorisnickiNalog){
	
	printf("Unesite naslov rada na koji ostavljate recenziju:\n");
	int line_size = 200;
	char naslov[200];
	char c = getc(stdin);
	fgets(naslov, line_size, stdin);
	size_t length = strlen(naslov);
	naslov[length-1] = '\0';
	
	sprintf(query, "select idRada from Rad where naslov = \"%s\"", naslov);
	if(mysql_query(konekcija, query) != 0){
			error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
	
	rezultat = mysql_use_result(konekcija);
	
	red = mysql_fetch_row(rezultat);
	if(red == NULL){
		printf("Ne postoji takav rad\n");
		return;
	}
	
	int idRada = atoi(red[0]);
	
	
	mysql_free_result(rezultat);
	
	printf("Unesite deo za autora:\n");
	
	line_size = 65535;
	char autor[65535];
	fgets(autor, line_size, stdin);
	length = strlen(autor);
	autor[length-1] = '\0';
	
	printf("Unesite deo za urednika:\n");
	line_size = 65535;
	char urednik[65535];
	fgets(urednik, line_size, stdin);
	length = strlen(urednik);
	urednik[length-1] = '\0';
	
	printf("Unesite broj verzije rada na koju ostavljate recenziju:\n");
	int br_verzije;
	scanf("%d", &br_verzije);
	
// 	printf("%s\n%s\n%s\n%s\n", naslov, autor, urednik, br_verzije);
	
	sprintf(query, "insert into Recenzija(komentarZaAutora, komentarZaUrednika, idKorisnik, Verzija_idRada, Verzija_brojVerzije) values(\"%s\", \"%s\", \"%d\", %d, %d)", autor, urednik, idKorisnickiNalog, idRada, br_verzije);
	
	if(mysql_query(konekcija, query) != 0){
			error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
	
	
}

void odobravanje_odbijanje_rada(int odobren){ //odobren = 1, odbijen = 0
	 
	printf("Unesite naslov rada:\n");
	
	int line_size = 200;
	char naslov[200];
	
	char c = getc(stdin);
	fgets(naslov, line_size, stdin);
	size_t length = strlen(naslov);
	naslov[length-1] = '\0';
	
	if(odobren){
		sprintf(query, "update Rad set status = \"prihvacen\" where naslov = \"%s\"", naslov);
	}
	else{
		sprintf(query, "update Rad set status = \"odbijen\" where naslov = \"%s\"", naslov);
	}
	if(mysql_query(konekcija, query) != 0){
		error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
	
}

void izlistavanje_autora_rada(){
	
	printf("Unesite naslov rada:\n");
	
	int line_size = 200;
	char naslov[200];
	
	char c = getc(stdin);
	fgets(naslov, line_size, stdin);
	size_t length = strlen(naslov);
	naslov[length-1] = '\0';
	
	sprintf(query, "select ime, prezime from KorisnickiNalog where idKorisnickiNalog in (select IDKorisnickiNalogRad from Pise where IDRadKorisnickiNalog = (select idRada from Rad where naslov = \"%s\"))", naslov);
	
	if(mysql_query(konekcija, query) != 0){
			error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
	
	rezultat = mysql_use_result (konekcija);
	
	
	while ((red = mysql_fetch_row (rezultat)) != 0){
		 printf ("%s %s\n", red[0], red[1]);
	}
	
	mysql_free_result(rezultat);
}
 

void izlistavanje_radova_koji_ucestvuju_na_konferenciji(){
	
	sprintf(query, "select naslov from Rad where idRada in (select idRada from Ucestvuje where status = \'prihvacen\')");
	if(mysql_query(konekcija, query) != 0){
			error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
	rezultat = mysql_use_result (konekcija);
	red = mysql_fetch_row(rezultat);
	if(red == NULL){
		printf("Trenutno nema radova koji ucestvuju na konferenciji\n");
	}
	else{
		// dodati za vise autora
		printf("Naslov: %s\n", red[0]);
		while((red = mysql_fetch_row(rezultat)) != 0){
			printf("Naslov: %s\n", red[0]);
		}
	}
	mysql_free_result(rezultat);
	
}

void postavljanje_upita(){
	
}


int main(int argc, char**argv){
	
	// Konektovanje na bazu
	konekcija = mysql_init (NULL);
	if (mysql_real_connect(konekcija, "localhost", "root", "12kasper12", "matfCasopis", 0, NULL, 0) == NULL){
		error_fatal ("Greska u konekciji. %s\n", mysql_error (konekcija));
	}
	
	
	char email[BUFFER_SIZE];
	char lozinka[BUFFER_SIZE];

	// Logovanje: uspesno i neuspesno 
	printf("Postovani, dobrodosli! Unesite svoj email, a zatim lozinku\n");
	
	scanf("%s", email);
	scanf("%s", lozinka);
	
	sprintf (query, "select idKorisnickiNalog from KorisnickiNalog where email = \"%s\" and sifra = \"%s\"", email, lozinka);
	
	if(mysql_query(konekcija, query) != 0){
		error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
	
	rezultat = mysql_use_result (konekcija);
	red = mysql_fetch_row(rezultat);
	
	
	
	if(red == NULL){
		printf("Ne postoji takvo korisnicko ime ili lozinka\n");
		mysql_free_result (rezultat);
		exit(EXIT_SUCCESS);
	}
	
	printf("Uspesno ste ulogovani!\n");
	
	int idKorisnickiNalog = atoi(red[0]);
// 	printf("%d\n", idKorisnickiNalog);
	
	mysql_free_result (rezultat);
	
	
	printf("Spisak Vasih dozvoljenih akcija na sistemu:\n");
	
	
	// Spisak radnji koje moze da obavi se izlistava i onda korisnik bira radnju pod rednim brojem
	// Radnje su privilegije koje se izvlače iz tabele Privilegija i njihovi id-jevi se smeštaju u niz akcije
	// Najvise moze biti njih 10, ako neko ima sve privilegije
	// Ali ih ne mora biti nuzno toliko
	// Zato se mysql fjom hvata koliko redova (n) je vratio rezultat i po tom broju se vrti petlja
	int akcije[15];
	sprintf (query, "select idPrivilegija from Obezbedjuje where idUlogaPrivilegija in (select IDUlogaKorisnickiNalog from Ima where IDKorisnickiNalogUloga = \"%d\")", idKorisnickiNalog); // da li proveru privilegija da radim preko uloga ili da dohvatam privilegije
	if(mysql_query(konekcija, query) != 0){
		error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
	// Ovaj upit ce, ako uspe, tj ako nema greske, uvek vratitit rezultat, jer prijavljivanjem na sistem
	// korisnik ima automatski privilegije autora
	rezultat = mysql_use_result (konekcija);
	
	// dohvatanje broja redova u rezultatu
	int n = 0;
	while((red = mysql_fetch_row(rezultat)) != 0){
		akcije[n] = atoi(red[0]);
		n++;
	}
	
	mysql_free_result (rezultat);
	
	
	while(1){
		// Stampanje mogucih akcija korisnika
		int i=0;
		printf("\t 0. Odjava\n");
		for(; i<n; i++){
			switch(akcije[i]){
				case 1:  printf("\t %d. Promena sopstvenih podataka\n", i+1);  break;
				case 2:  printf("\t %d. Prijavljivanje rada\n", i+1);  break;
				case 3:  printf("\t %d. Menjanje podataka casopisu\n", i+1); break;
				case 4:  printf("\t %d. Menjanje podataka izdanju casopisa\n", i+1);  break;
				case 5:  printf("\t %d. Dodeljivanje uloga korisnicima\n", i+1);  break;
				case 6:  printf("\t %d. Ostavljanje komentara na rad\n", i+1); break;
				case 7:  printf("\t %d. Ostavljanje recenzije na rad\n", i+1); break;
				case 8:  printf("\t %d. Odobravanje rada\n", i+1);  break;
				case 9:  printf("\t %d. Odbijanje rada\n", i+1);  break;
				case 10: printf("\t %d. Izlistavanje autora rada\n", i+1);  break;
				case 11: printf("\t %d. Izlistavanje radova u izdanju casopisa\n", i+1);  break;
				case 12: printf("\t %d. Izlistavanje zauzetih sala\n", i+1);  break;
				case 13: printf("\t %d. Izlistavanje radova koji ucestvuju na konferenciji\n", i+1);  break;
				case 14: printf("\t %d. Promena podataka ostalim korisnicima\n", i+1);  break;
				case 15: printf("\t %d. Postavljanje upita direktno nad bazom\n", i+1);
				default: break;
			}
		}
		
		
		printf("Odabrite svoju akciju: Pritisnite redni broj akcije i zatim ENTER\n");
		scanf("%d", &i);
		
		if(i<=n){
			if(i == 0){
			printf("Uspesna odjava!\n");
			mysql_close(konekcija);
			exit(EXIT_SUCCESS);
			}
		
		
			switch(akcije[i-1]){
				case 1: promena_sopstvenih_podataka(idKorisnickiNalog); break;
				case 2: prijavljivanje_rada(idKorisnickiNalog); break;
				case 3: printf("Promena podatka je uspesna!\n"); break;
				case 4: printf("Promena podataka je uspesna!\n"); break;
				case 5: dodeljivanje_uloga_korisnicima(idKorisnickiNalog); break;
				case 6: printf("Komentar je uspesno ostavljen!\n"); break;
				case 7: ostavljanje_recenzije_na_rad(idKorisnickiNalog); break;
				case 8: odobravanje_odbijanje_rada(1); break;
				case 9: odobravanje_odbijanje_rada(0); break;
				case 10: izlistavanje_autora_rada(); break;
				case 11: printf("Radovi su izlistani\n"); break;
				case 12: printf("Uspesno ste izlistali zauzete sale\n"); break;
				case 13: izlistavanje_radova_koji_ucestvuju_na_konferenciji(); break;
				case 14: printf("Uspesno ste promenili podatke ostalim korisnicima\n"); break;
				case 15: postavljanje_upita(); break;
				default:printf("Uneli ste pogresan broj akcje!\n"); break;
			}
		}
		
		printf("------------------------------------------------------------------------\n\n\n");
	}
	

	// Zatvaranje konekcije
	mysql_close(konekcija);
	exit(EXIT_SUCCESS);
}
