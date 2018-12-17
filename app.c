#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <mysql.h>
#include <stdarg.h>
#include <errno.h>

#define QUERY_SIZE 256
#define BUFFER_SIZE 80

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

int main(int argc, char**argv){
	
	
	MYSQL *konekcija;	/* Promenljiva za konekciju. */
	MYSQL_RES *rezultat;	/* Promenljiva za rezultat. */
	MYSQL_ROW red;	/* Promenljiva za jedan red rezultata. */
	MYSQL_FIELD *polje;	/* Promenljiva za nazive kolona. */
	int i;		/* Brojac u petljama. */
	int broj_kolona;		/* Pomocna promenljiva za broj kolona. */	

	char query[QUERY_SIZE];	/* Promenljiva za formuaciju upita. */
	
	
	// Konektovanje na bazu
	konekcija = mysql_init (NULL);
	if (mysql_real_connect(konekcija, "localhost", "root", "root", "StudSluzb", 0, NULL, 0) == NULL){
		error_fatal ("Greska u konekciji. %s\n", mysql_error (konekcija));
	}
	
	
	char email[BUFFER_SIZE];
	char lozinka[BUFFER_SIZE];

	// Logovanje: uspesno i neuspesno 
	printf("Postovani, dobrodosli! Unesite svoj email, a zatim lozinku\n");
	
	scanf("%s", &email);
	scanf("%s", &lozinka);
	
	sprintf (query, "select id from KorisnickiNalog where email = %s and lozinka = %s");
	
	if(mysql_query(konekcija, query) != 0){
		error_fatal("Greska u upitu %s\n", mysql_error (konekcija));	// Da li je ovo provera ili mora use result?
	}
	
	
	
	// Spisak radnji koje moze da obavi se izlistava i onda korisnik bira radnju pod rednim brojem
	
	// Promena sopstvenih podataka
	
	// Prijavljivanje rada
	
	// Izlistavanje autora rada
	
	// Izlistavanje radova u casopisu
	
	// Izlistavanje zauzetih sala
	
	// Izlistavanje radova koji ce ucestvovati na konferenciji
	
	// Nova verzija rada
	
	// Odbijanje/prihvatanje rada
	
	// Ostavljanje recenzije
	
	// Odjava
	
	
	
	
	exit(EXIT_SUCCESS);
}
