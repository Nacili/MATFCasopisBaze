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
	printf("\t6. Lozinka\n");
	
	int rb_podatka;
	scanf("%d", &rb_podatka);
	
	printf("Unesite izmenu:");
	char izmena[45];
	scanf("%s", izmena);
	
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

	printf("Navedite ukupan broj autora rada\n");
	int n;	// ukupan broj autora
	scanf("%d", &n);
	
	printf("Navedite ime i prezime svakog autora i njegovu mejl adresu, a zatim pritisnite ENTER\n");
	int i;
	for(i=0; i<n; i++){
		char ime[45];
		char prezime[45];
		char email[45];
		
		scanf("%s %s %s", ime, prezime, email);
		
		sprintf(query, "select idKorisnickiNalog from KorisnickiNalog where ime = \"%s\" and prezime = \"%s\" and email = \"%s\"", ime, prezime, email);
		
		if(mysql_query(konekcija, query) != 0){
			error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
		}
	
		rezultat = mysql_use_result (konekcija);
		red = mysql_fetch_row(rezultat);
	
		if(red == NULL){
			mysql_free_result(rezultat);
			sprintf(query, "insert into KorisnickiNalog(ime, prezime, email) values(\"%s\", \"%s\", \"%s\")", ime, prezime, email);
		}
		
		mysql_free_result(rezultat);
		
		// ubaci u pise
// 		sprintf (query, "insert into Pise(IDRadKorisnickiNalog, IDKorisnickiNalogRad) values()");
// 		if(mysql_query(konekcija, query) != 0){
// 			error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
// 		}

		
	}
	
	char naslov[200];
	char link[200];
	printf("Unesite naslov rada\n");
	scanf("%s", naslov);
	printf("Unesite link ka radu\n");
	scanf("%s", link);
	
	sprintf (query, "insert into Rad(naslov, pdfStorageLinkId, status, objavljen) values(\"%s\", \"%s\", \"prijavljen\", false)", naslov, link);
	
	if(mysql_query(konekcija, query) != 0){
			error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
	
	// nije pokriveno prijavljivanje verzija
	
}

void menjanje_podataka_casopisu(int idKorisnickiNalog){
	
}

void dodeljivanje_uloga_korisnicima(int idKorisnickiNalog){
	
}

void menjanje_podataka_izdanju(int idKorisnickiNalog){
	
}

void ostavljanje_komentara_na_rad(int idKorisnickiNalog){
	
}

void ostavljanje_recenzije_na_rad(int idKorisnickiNalog){
	
	printf("Unesite naslov rada na koji ostavljate recenziju:\n");
	char naslov[200];
	scanf("%s", naslov);
	
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
	char autor[65535];
	scanf("%s", autor);
	printf("Unesite deo za urednika:\n");
	char urednik[65535];
	scanf("%s", urednik);
	printf("Unesite broj verzije rada na koju ostavljate recenziju:\n");
	int br_verzije;
	scanf("%d", &br_verzije);
	
	
	sprintf(query, "insert into Recenzija(komentarZaAutora, komentarZaUrednika, idKorisnik, Verzija_idRada, Verzija_brojVerzije) values(\"%s\", \"%s\", \"%d\", \"%d\", \"%d\")",
		autor, urednik, idKorisnickiNalog, idRada, br_verzije);
	
	if(mysql_query(konekcija, query) != 0){
			error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
	
	
}

void odobravanje_odbijanje_rada(int idKorisnickiNalog, int odobren){ //odobren = 1, odbijen = 0
	 
	char naslov[200];
	printf("Unesite naslov rada:");
	scanf("%s", naslov);
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

void izlistavanje_autora_rada(int idKorisnickiNalog){
	char naslov[200];
	printf("Unesite naslov rada:");
	scanf("%s", naslov);
	sprintf(query, "select ime from KorisnickiNalog where idKorisnickiNalog = (select IDKorisnickiNalogRad from Pise where IDRadKorisnickiNalog = (select idRada from Rad where naslov = \"%s\"))", naslov);
	
	if(mysql_query(konekcija, query) != 0){
			error_fatal("Greska u upitu %s\n", mysql_error (konekcija));
	}
	
	rezultat = mysql_use_result (konekcija);
	
	
	while ((red = mysql_fetch_row (rezultat)) != 0){
		 printf ("%s\n", red[0]);
	}
	
	mysql_free_result(rezultat);
}
 
void izlistavanje_radova_u_casopisu(int idKorisnickiNalog){
	
}
 
void izlistavanje_zauzetih_sala(int idKorisnickiNalog){
	
}

void izlistavanje_radova_koji_ucestvuju_na_konferenciji(int idKorisnickiNalog){
	
}


int main(int argc, char**argv){
	
	// Konektovanje na bazu
	konekcija = mysql_init (NULL);
	if (mysql_real_connect(konekcija, "localhost", "root", "12kasper12", "mydb", 0, NULL, 0) == NULL){
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
	int akcije[10];
	sprintf (query, "select idPrivilegija from Obezbedjuje where idUlogaPrivilegija = (select IDUlogaKorisnickiNalog from Ima where IDKorisnickiNalogUloga = \"%d\")", idKorisnickiNalog); // da li proveru privilegija da radim preko uloga ili da dohvatam privilegije
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
				case 1: printf("\t %d. Promena sopstvenih podataka\n", i+1); break;
				case 2: printf("\t %d. Prijavljivanje rada\n", i+1); break;
				case 3: printf("\t %d. Menjanje podataka casopisu\n", i+1); break;
				case 4: printf("\t %d. Menjanje podataka izdanju casopisa\n", i+1); break;
				case 5: printf("\t %d. Dodeljivanje uloga korisnicima\n", i+1); break;
				case 6: printf("\t %d. Ostavljanje komentara na rad", i+1); break;
				case 7: printf("\t %d. Ostavljanje recenzije na rad", i+1); break;
				case 8: printf("\t %d. Odobravanje rada", i+1); break;
				case 9: printf("\t %d. Odbijanje rada", i+1); break;
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
				case 3: menjanje_podataka_casopisu(idKorisnickiNalog); break;
				case 4: menjanje_podataka_izdanju(idKorisnickiNalog); break;
				case 5: dodeljivanje_uloga_korisnicima(idKorisnickiNalog); break;
				case 6: ostavljanje_komentara_na_rad(idKorisnickiNalog); break;
				case 7: ostavljanje_recenzije_na_rad(idKorisnickiNalog); break;
				case 8: odobravanje_odbijanje_rada(idKorisnickiNalog, 1); break;
				case 9: odobravanje_odbijanje_rada(idKorisnickiNalog, 0); break;
				case 10: izlistavanje_autora_rada(idKorisnickiNalog); break;
				case 11: izlistavanje_radova_u_casopisu(idKorisnickiNalog); break;
				case 12: izlistavanje_zauzetih_sala(idKorisnickiNalog); break;
				case 13: izlistavanje_radova_koji_ucestvuju_na_konferenciji(idKorisnickiNalog); break;
				default:printf("Uneli ste pogresan broj akcje!\n"); break;
			}
		}
		
		
	}
	

	// Zatvaranje konekcije
	mysql_close(konekcija);
	exit(EXIT_SUCCESS);
}
