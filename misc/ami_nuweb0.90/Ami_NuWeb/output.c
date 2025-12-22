#include "global.h"
void write_files(Name *files)
{
  while (files) {
    write_files(files->llink);
    {
  char indent_chars[500];
  FILE *temp_file;
  char temp_name[]="NUWEB.TMP";
  void (*old_signal_handler)(int);

  old_signal_handler=signal(SIGINT,SIG_IGN);
  temp_file = fopen(temp_name, "w");
  if (!temp_file) {
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_ERROR_38),
            command_name, temp_name);
    exit(EXIT_FAILURE);
#else
    fprintf(stderr, "%s: can't create %s for a temporary file\n",
            command_name, temp_name);
    exit(-1);
#endif
  }
  if (verbose_flag)
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_VERBOSE_17A), files->spelling);
#else
    fprintf(stderr, "writing %s\n", files->spelling);
#endif
  write_scraps(temp_file, files->defs, 0, indent_chars,
               files->debug_flag, files->tab_flag, files->indent_flag);
  fclose(temp_file);
  if (compare_flag)
    {
  FILE *old_file = fopen(files->spelling, "r");
  if (old_file) {
    char x[BUFSIZ], y[BUFSIZ];
    int x_size, y_size;
    temp_file = fopen(temp_name, "r");
    do {
      x_size = fread(x, 1, BUFSIZ, old_file);
      y_size = fread(y, 1, BUFSIZ, temp_file);
    } while ((x_size == y_size) && !memcmp(x, y, x_size) &&
             !feof(old_file) && !feof(temp_file));
    if ((x_size != y_size) || memcmp(x, y , x_size)) {
      fclose(old_file);
      fclose(temp_file);
      remove(files->spelling);
      rename(temp_name, files->spelling);
    } else {
      fclose(old_file);
      fclose(temp_file);
      remove(temp_name);
    }
  }
  else
    rename(temp_name, files->spelling);
}
  else {
    remove(files->spelling);
    rename(temp_name, files->spelling);
  }
  signal(SIGINT,old_signal_handler);
}
    files = files->rlink;
  }
}
