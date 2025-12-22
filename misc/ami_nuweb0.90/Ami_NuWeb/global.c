#ifdef _AMIGA
#define STRINGARRAY 1
#endif
#include "global.h"
int tex_flag = TRUE;
int html_flag = FALSE;
int output_flag = TRUE;
int compare_flag = TRUE;
int verbose_flag = FALSE;
int number_flag = FALSE;
char *command_name = NULL;
char *source_name = NULL;
int source_line = 0;
int already_warned = 0;
Name *file_names = NULL;
Name *macro_names = NULL;
Name *user_names = NULL;
#ifdef _AMIGA
struct Library *LocaleBase; /* pointer to the locale library */
struct Catalog *catalog; /* pointer to the external catalog, when present */
int i; /* global counter for list of strings */
#endif

#ifdef _AMIGA
void CloseSystemResources(void) {
  if(LocaleBase) {
    CloseCatalog(catalog);
    CloseLibrary(LocaleBase);
  }
}
#endif
#ifdef _AMIGA
void catch_break(int dummy) {
  exit(EXIT_FAILURE);
}
#endif
