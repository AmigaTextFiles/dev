/*

Programm für den Tröpfel-Algorithmus von PI

Algorithmus aus: Spektrum der Wissenschaft 12/1995, Mathematische Unterhaltungen

Originalversion von: Martin Knapmeyer, 03.01.1996

Umsetzung nach StormC: HAAGE & PARTNER GmbH, 16.02.1996

Mit 32 bit Integers kann man auch sehr viele Dezimalen berechnen, mit 16 bit
Integers wäre 10000 Dezimalen etwa die Grenze.

Allerdings hat der Algorithmus quadratische Ordnung: doppelte Anzahl Stellen,
vierfache Zeit. Schon 10000 Stellen brauchen auf einem A3000 etwa 2 Stunden.

*/

#include <stdlib.h>
#include <stormamiga.h>

int n; // Anzahl der Nachkommastellen
int klen;

int *result; // Zeiger auf ein Feld mit n int
int *chain;  // Zeiger auf ein Feld mit klen == 10 * n / 3 int
int *temp;   // Zeiger auf ein Feld mit n int

#ifndef NDEBUG
void write_chain(void)
{
  int i;
  for (i = 0; i < klen; i++)
    printf_("%ld ",chain[i]);
  printf_("\n");
}
#endif

void write_result(void)
{
  int i;
  printf_("PI:\n");
  for (i = 1; i < n; i++)
  {
    printf_("%ld",result[i]);
    if (i % 50 == 0)
      printf_("\n");
  };
  printf_("\n");
}

void init_chain(void)
{
  int i;
  for (i = 0; i < klen; i++)
    chain[i] = 2;
}

void drop(void)
{
  int vcnt = 0, ecnt = 0;
  int i,j;
  div_t qr;
  for (i = 0; i < n; i++)
  {
    for (j = 0; j < klen; j++)
      chain[j] *= 10;
    for (j = klen - 1; j >= 1; j--)
    {
      qr = div(chain[j],(2*j + 1));
      chain[j] = qr.rem;
      chain[j - 1] += qr.quot*j;
    };
    qr = div(chain[0],10);
    chain[0] = qr.rem;
    if (qr.quot != 9 && qr.quot != 10)
    {
      for (j = 0; j <= vcnt; j++)
      {
	#ifndef NDEBUG
	  printf_("%ld. Stelle: %ld\n",ecnt-1,temp[j]);
	#endif
	result[ecnt] = temp[j];
	ecnt++;
	temp[j] = 0;
      };
      vcnt = 0;
      temp[vcnt] = qr.quot;
    }
    else
    {
      if (qr.quot == 9)
      {
	vcnt++;
	temp[vcnt] = qr.quot;
      }
      else // if (qr.quot == 10)
      {
	qr.quot = 1;
	for (j = vcnt; j >= 0; j--)
	{
	  temp[j] += qr.quot;
	  qr = div(temp[j],10);
	  temp[j] = qr.rem;
	};
	for (j = 0; j <= vcnt; j++)
	{
	  #ifndef NDEBUG
	    printf_("%ld. Stelle: %ld\n",ecnt-1,temp[j]);
	  #endif
	  result[ecnt] = temp[j];
	  ecnt++;
	  temp[j] = 0;
	};
	vcnt = 0;
	temp[0] = 0;
      }
    };
  };
}

int main__ (void)
{
  clock_t timestart,timeend;
  printf_("Berechnung von PI\n");
  for (;;)
  {
    printf_("Stellenanzahl (0 für Ende):");
    scanf_("%ld",&n);
    if (n < 1)
      exit(0);
    klen = (n * 10) / 3;
    result = (int *) malloc(n*sizeof(int));
    chain = (int *) malloc(klen*sizeof(int));
    temp = (int *) malloc(n*sizeof(int));
    if (result == NULL || chain == NULL || temp == NULL)
    {
      printf_("no memory, no pi.\n");
      exit(100);
    };
    init_chain();
    timestart = clock();
    drop();
    timeend = clock();
    printf_("Zeitbedarf für %ld Stellen: %lds\n",n,(timeend-timestart) / CLOCKS_PER_SEC);
    write_result();
    free(result);
    free(chain);
    free(temp);
  };
return NULL;
}
