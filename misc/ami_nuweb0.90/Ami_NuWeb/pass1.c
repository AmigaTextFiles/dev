#include "global.h"
void pass1(char *file_name)
{
  if (verbose_flag)
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_VERBOSE_14B), file_name);
#else
    fprintf(stderr, "reading %s\n", file_name);
#endif
  source_open(file_name);
  init_scraps();
  macro_names = NULL;
  file_names = NULL;
  user_names = NULL;
  {
  int c = source_get();
  while (c != EOF) {
    if (c == '@')
      {
  c = source_get();
  switch (c) {
    case 'O':
    case 'o': {
  Name *name = collect_file_name(); /* returns a pointer to the name entry */
  int scrap = collect_scrap();      /* returns an index to the scrap */
  {
  Scrap_Node *def = (Scrap_Node *) arena_getmem(sizeof(Scrap_Node));
  def->scrap = scrap;
  def->next = name->defs;
  name->defs = def;
}
}
              break;
    case 'D':
    case 'd': {
  Name *name = collect_macro_name();
  int scrap = collect_scrap();
  {
  Scrap_Node *def = (Scrap_Node *) arena_getmem(sizeof(Scrap_Node));
  def->scrap = scrap;
  def->next = name->defs;
  name->defs = def;
}
}
              break;
    case '@':
    case 'u':
    case 'm':
    case 'f': /* ignore during this pass */
              break;
#ifdef _AMIGA
    default:  fprintf(stderr, get_string(MSG_WARNING_15A),
                      command_name, source_name, source_line);
#else
    default:  fprintf(stderr,
                      "%s: unexpected @ sequence ignored (%s, line %d)\n",
                      command_name, source_name, source_line);
#endif
              break;
  }
}
    c = source_get();
  }
}
  if (tex_flag)
    search();
  {
  reverse_lists(file_names);
  reverse_lists(macro_names);
  reverse_lists(user_names);
}
}
