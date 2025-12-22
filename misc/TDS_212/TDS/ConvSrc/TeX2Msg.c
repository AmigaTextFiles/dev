/* TeX2Msg.c */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

static char version[] = "$VER: TeX2Msg 1.00 (28.01.94)";

#define WARNING_NUMBER 5
char *WarningsArray[WARNING_NUMBER] =
{"Overfull", "Tight", "Loose", "Underfull", "LaTeX Warning:"};

void 
PrintMessageToTED(char *filename, int line, char *type, char *message)
{
  printf("<%s> %d %s <%s>\n", filename, line, type, message);
}

/* il messaggio puo' essere globale: risparmio stack. Tanto sono
   sicuro che viene impiegato all'interno dello stesso ramo      */

char message[90];

void 
ReadMessage(void)
{
  char filename[80];
  char buffer[90];		/* per TeX basterebbero 80 caratteri */
  int c, i;

  /* per prima cosa costruisci il nome del file */

  for (i = 0, c = 0; (!isspace(c)) && (i < 79) && (c != ')'); c = filename[i++] = getchar());
  filename[--i] = 0;
  ungetc(c, stdin);

  i = 0;
  buffer[0] = 0;

  while ((c = getchar()) != EOF) {
    if (c == '(')		/* nuovo file, nuovo livello di ricorsione */
      ReadMessage();
    else if (c == ')') {
      return;			/* fine ricorsione */
    }
    else if (c == '\n') {
      buffer[i] = 0;
      i = 0;
      if (buffer[0] == '!') {
        /* errore */
        char *pos;

        strcpy(message, &buffer[2]);

        while (gets(buffer))
          if ((pos = strstr(buffer, "l.")) != 0)
            break;
        PrintMessageToTED(filename, atoi(pos + 2), "E", message);
      }
      /* Warning del TeX */
      else {
        int j;
        char *pos;

        for (j = 0; j < WARNING_NUMBER; j++)
          if (!strncmp(buffer, WarningsArray[j], strlen(WarningsArray[j]))) {
            pos = strstr(buffer, " at lines ");
            pos[0] = 0;
            pos += strlen(" at lines ");
            PrintMessageToTED(filename, atoi(pos), "W", buffer);
          }
      }
    }
    else
      buffer[i++] = c;
  }
}

int
main(int argc, char **argv)
{
  int c;

  while ((c = getchar()) != EOF) {
    if (c == '\n')		/* nuovo file, nuovo livello di ricorsione */
      if ((c = getchar()) == '(') {
        ReadMessage();
        break;
      }
  }
  return(0);
}

