#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#ifdef _AMIGA
#include <proto/exec.h>
#include <proto/locale.h>

#define get_string(n) AppStrings[n].as_Str /* reference string n */

#include "catalogs/nuweb.h"

#ifndef STRINGARRAY
struct AppString
{
  LONG   as_ID;
  STRPTR as_Str;
};

extern struct AppString AppStrings[];
#endif
#endif
#ifdef _AMIGA
#include <signal.h>
#endif

#ifndef FALSE
#define FALSE 0
#endif
#ifndef TRUE
#define TRUE 1
#endif
typedef struct scrap_node {
  struct scrap_node *next;
  int scrap;
} Scrap_Node;
typedef struct name {
  char *spelling;
  struct name *llink;
  struct name *rlink;
  Scrap_Node *defs;
  Scrap_Node *uses;
  int mark;
  char tab_flag;
  char indent_flag;
  char debug_flag;
} Name;

extern int tex_flag;      /* if FALSE, don't emit the documentation file */
extern int html_flag;     /* if TRUE, emit HTML instead of LaTeX scraps. */
extern int output_flag;   /* if FALSE, don't emit the output files */
extern int compare_flag;  /* if FALSE, overwrite without comparison */
extern int verbose_flag;  /* if TRUE, write progress information */
extern int number_flag;   /* if TRUE, use a sequential numbering scheme */
extern char *command_name;
extern char *source_name;  /* name of the current file */
extern int source_line;    /* current line in the source file */
extern int already_warned;
extern Name *file_names;
extern Name *macro_names;
extern Name *user_names;
extern struct Library *LocaleBase;
  /* pointer to the locale library */
extern struct Catalog *catalog;
  /* pointer to the external catalog, when present */
extern int i;
  /* global counter for list of strings */

extern void pass1(char *);
extern void write_tex(char *, char *);
extern void write_html(char *, char *);
extern void write_files(Name *);
extern void source_open(char *);
  /* pass in the name of the source file */
extern int source_get(void);
  /* no args; returns the next char or EOF */
extern int source_last;   /* what last source_get() returned. */
extern void init_scraps(void);
extern int collect_scrap(void);
extern int write_scraps(FILE *, Scrap_Node *, int, char *, char, char, char);
extern void write_scrap_ref(FILE *, int, int, int *);
extern void write_single_scrap_ref(FILE *, int);
extern void collect_numbers(char *);
extern Name *collect_file_name(void);
extern Name *collect_macro_name(void);
extern Name *collect_scrap_name(void);
extern Name *name_add(Name **, char *);
extern Name *prefix_add(Name **, char *);
extern char *save_string(char *);
extern void reverse_lists(Name *);
extern void search(void);
extern void *arena_getmem(size_t);
extern void arena_free(void);
#ifdef _AMIGA
extern void CloseSystemResources(void);
#endif
#ifdef _AMIGA
extern void catch_break(int);
#endif

