/*
**  $VER: indexer.c 1.0 (5.11.95)
**  Program  laczy wszystkie pliki z podanego katalogu, zapisuje je kolejno
**  do  wskazanego  pliku  oraz  tworzy  plik  indeksu,  w  ktorym  zostana
**  umieszczone informacje o nazwach, dlugosciach i polozeniach polaczonych
**  plikow.
*/

#include "indexer.h"

/* minimalna wersja systemu operacyjnego */
extern LONG __OSlibversion = 36;

void main(int argc, char *argv[])
{
  struct FileInfoBlock finfo;   /* opis otwieranego pliku */
  BPTR lock, oldlock;
  BPTR exfile, outfile, index;  /* otwierane pliki */
  UBYTE *buffer;                /* bufor roboczy */
  ULONG buffsize = 50000;       /* wielkosc bufora */
  ULONG outsize;                /* dlugosc tworzonego pliku */
  LONG buffread;                /* liczba bajtow wczytywanych do bufora */
  UBYTE i;

  /* tekst informacji o programie */
  static UBYTE *info[] =
  {
     "indexer v1.0 (c)1995 by Lukasz Szelag.",
     "This  program  was  developed with SAS/C compiler on Amiga 1200 and",
     "helps  developers  who  have  to write routines which manage lot of",
     "files (for example for disk magazines writers). It allows to reduce",
     "the  disk  space  and increase the speed of disk operations. If you",
     "have any ideas, bug reports or if you want the complete source code",
     "of this tiny program just feel free to contact with me:\n",
     "  e-mail: lszelag@panamint.ict.pwr.wroc.pl",
     "     www: sun1000.ci.pwr.wroc.pl/amiga/amiuser/luk",
     "     IRC: #amiga, #amigapl, #usa (Luk)\n"
  };

  /* tekst pomocy */
  static UBYTE *help[]=
  {
     "Usage: indexer <dir> <outfile> <index> [buffer]",
     "dir     - directory with files to process",
     "outfile - filename for final file",
     "index   - filename for data description",
     "buffer  - I/O buffer (default 50000 bytes)\n\n",
  };

  /* wyswietlenie informacji o programie */
  for (i = 0; i<10; i++) printf("\n%s", info[i]);

  /*
  Sprawdzenie  poprawnosci  skladni wywolania programu. Jezeli jest bledna,
  to wyswietlenie pomocy.
  */
  if ((argc<4) || (argc>5))
  {
    for (i = 0; i<5; i++) printf("\n%s", help[i]);
    exit(RETURN_FAIL);
  }

  /* przydzielenie pamieci na bufor I/O */
  if (argc>4) buffsize = atol(argv[4]);
  if (buffer = AllocMem(buffsize, MEMF_PUBLIC))
  {
    /* otwarcie pliku, w ktorym zostana umieszczone odczytane pliki */
    if (outfile = Open(argv[2], MODE_NEWFILE))
    {
      /* otwarcie pliku, w ktorym zostanie umieszczony indeks plikow */
      if (index = Open(argv[3], MODE_NEWFILE))
      {
        /* lock do wybranego katalogu */
        if (lock = Lock(argv[1], ACCESS_READ))
        {
          /* wejscie do katalogu */
          oldlock = CurrentDir(lock);

          /* sprawdzenie kolejnych plikow z katalogu */
          if (Examine(lock, &finfo))
          {
            do
            {
              /* sprawdzenie, czy jest to plik */
              if (finfo.fib_DirEntryType<0)
              {
                /* otwarcie pliku */
                if (exfile = Open(finfo.fib_FileName, MODE_OLDFILE))
                {
                  /*
                  Skopiowanie   danego   pliku   poprzez  bufor  na  koniec
                  tworzonego pliku.
                  */
                  outsize = 0;
                  printf("\n%s", finfo.fib_FileName);
                  do
                  {
                    buffread = Read(exfile, buffer, buffsize);
                    Write(outfile, buffer, buffread);
                    outsize += buffread;
                  }
                  while (outsize<finfo.fib_Size);
                  Close(exfile);

                  /*
                  Dopisanie  do  pliku  indeksu,  nazwy skopiowanego pliku,
                  jego  dlugosci oraz polozenia (offsetu) wzgledem poczatku
                  tworzonego pliku.
                  */
                  FPrintf(index, "%s\n%ld\n%ld\n",
                          finfo.fib_FileName,
                          finfo.fib_Size,
                          Seek(outfile, 0, OFFSET_CURRENT)-finfo.fib_Size);
                }
              }
            }
            while (ExNext(lock, &finfo));
          }
          /* odtworzenie biezacego katalogu i zwolnienie locka */
          CurrentDir(oldlock);
          UnLock(lock);
        }
        else
        {
          printf("\nCouldn't lock directory !\n\n");
          Close(index);
          Close(outfile);
          FreeMem(buffer, buffsize);
          exit(RETURN_FAIL);
        }
        Close(index);
      }
      else
      {
        printf("\nCouldn't open file %s !\n\n", argv[3]);
        Close(outfile);
        FreeMem(buffer, buffsize);
        exit(RETURN_FAIL);
      }
      Close(outfile);
    }
    else
    {
      printf("\nCouldn't open file %s !\n\n", argv[2]);
      FreeMem(buffer, buffsize);
      exit(RETURN_FAIL);
    }
    FreeMem(buffer, buffsize);
  }
  else
  {
    printf("\nNot enough memory for I/O buffer !\n\n");
    exit(RETURN_FAIL);
  }
  printf("\n\nOperation finished.\n\n");
  exit(RETURN_OK);
}
