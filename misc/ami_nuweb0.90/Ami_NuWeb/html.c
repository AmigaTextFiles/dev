#include "global.h"
static void copy_scrap(FILE *);
  /* formats the body of a scrap */
static void display_scrap_ref(FILE *, int);
  /* formats a scrap reference */
static void display_scrap_numbers(FILE *, Scrap_Node *);
  /* formats a list of scrap numbers */
static void print_scrap_numbers(FILE *, Scrap_Node *);
  /* pluralizes scrap formats list */
static void format_entry(Name *name, FILE *html_file, int file_flag);
  /* formats an index entry */
static void format_user_entry(Name *, FILE *);
void write_html(char *file_name, char *html_name)
{
  FILE *html_file = fopen(html_name, "w");
  if (html_file) {
    if (verbose_flag)
#ifdef _AMIGA
      fprintf(stderr, get_string(MSG_VERBOSE_17A), html_name);
#else
      fprintf(stderr, "writing %s\n", html_name);
#endif
    source_open(file_name);
    {
  int scraps = 1;
  int c = source_get();
  while (c != EOF) {
    if (c == '@')
      {
  c = source_get();
  switch (c) {
    case 'O':
    case 'o': {
  Name *name = collect_file_name();
  {
  fputs("\\begin{rawhtml}\n", html_file);
  fputs("<pre>\n", html_file);
}
    fputs("<a name=\"nuweb", html_file);
  write_single_scrap_ref(html_file, scraps);
  fprintf(html_file, "\"><code>\"%s\"</code> ", name->spelling);
  write_single_scrap_ref(html_file, scraps);
  fputs("</a> =\n", html_file);

  scraps++;
  {
  copy_scrap(html_file);
  fputs("&lt;&gt;</pre>\n", html_file);
}
  {
  if (name->defs->next) {
#ifdef _AMIGA
    fputs(get_string(MSG_HTML_31C), html_file);
#else
    fputs("File defined by ", html_file);
#endif
    print_scrap_numbers(html_file, name->defs);
    fputs("<br>\n", html_file);
  }
}
  {
  fputs("\\end{rawhtml}\n", html_file);
  c = source_get(); /* Get rid of current at command. */
}
}
              break;
    case 'D':
    case 'd': {
  Name *name = collect_macro_name();
  {
  fputs("\\begin{rawhtml}\n", html_file);
  fputs("<pre>\n", html_file);
}
    fputs("<a name=\"nuweb", html_file);
  write_single_scrap_ref(html_file, scraps);
  fprintf(html_file, "\">&lt;%s ", name->spelling);
  write_single_scrap_ref(html_file, scraps);
  fputs("&gt;</a> =\n", html_file);

  scraps++;
  {
  copy_scrap(html_file);
  fputs("&lt;&gt;</pre>\n", html_file);
}
  {
  if (name->defs->next) {
#ifdef _AMIGA
    fputs(get_string(MSG_HTML_31D), html_file);
#else
    fputs("Macro defined by ", html_file);
#endif
    print_scrap_numbers(html_file, name->defs);
    fputs("<br>\n", html_file);
  }
}
  {
  if (name->uses) {
#ifdef _AMIGA
    fputs(get_string(MSG_HTML_31E1), html_file);
#else
    fputs("Macro referenced in ", html_file);
#endif
    print_scrap_numbers(html_file, name->uses);
  }
  else {
#ifdef _AMIGA
    fputs(get_string(MSG_HTML_31E2), html_file);
    fprintf(stderr, get_string(MSG_WARNING_21A),
#else
    fputs("Macro never referenced.\n", html_file);
    fprintf(stderr, "%s: <%s> never referenced.\n",
#endif
            command_name, name->spelling);
  }
  fputs("<br>\n", html_file);
}
  {
  fputs("\\end{rawhtml}\n", html_file);
  c = source_get(); /* Get rid of current at command. */
}
}
              break;
    case 'f': {
  if (file_names) {
    fputs("\\begin{rawhtml}\n", html_file);
    fputs("<dl compact>\n", html_file);
    format_entry(file_names, html_file, TRUE);
    fputs("</dl>\n", html_file);
    fputs("\\end{rawhtml}\n", html_file);
  }
  c = source_get();
}
              break;
    case 'm': {
  if (macro_names) {
    fputs("\\begin{rawhtml}\n", html_file);
    fputs("<dl compact>\n", html_file);
    format_entry(macro_names, html_file, FALSE);
    fputs("</dl>\n", html_file);
    fputs("\\end{rawhtml}\n", html_file);
  }
  c = source_get();
}
              break;
    case 'u': {
  if (user_names) {
    fputs("\\begin{rawhtml}\n", html_file);
    fputs("<dl compact>\n", html_file);
    format_user_entry(user_names, html_file);
    fputs("</dl>\n", html_file);
    fputs("\\end{rawhtml}\n", html_file);
  }
  c = source_get();
}
              break;
    case '@': putc(c, html_file);
    default:  c = source_get();
              break;
  }
}
    else {
      putc(c, html_file);
      c = source_get();
    }
  }
}
    fclose(html_file);
  }
  else
#ifdef _AMIGA
    fprintf(stderr, get_string(MSG_WARNING_17A), command_name, html_name);
#else
    fprintf(stderr, "%s: can't open %s\n", command_name, html_name);
#endif
}
static void display_scrap_ref(FILE *html_file, int num)
{
  fputs("<a href=\"#nuweb", html_file);
  write_single_scrap_ref(html_file, num);
  fputs("\">", html_file);
  write_single_scrap_ref(html_file, num);
  fputs("</a>", html_file);
}
static void display_scrap_numbers(FILE *html_file, Scrap_Node *scraps)
{
  display_scrap_ref(html_file, scraps->scrap);
  scraps = scraps->next;
  while (scraps) {
    fputs(", ", html_file);
    display_scrap_ref(html_file, scraps->scrap);
    scraps = scraps->next;
  }
}
static void print_scrap_numbers(FILE *html_file, Scrap_Node *scraps)
{
#ifdef _AMIGA
  if (scraps->next) fputs(get_string(MSG_HTML_32C1), html_file);
  else fputs(get_string(MSG_HTML_32C2), html_file);
#else
  fputs("scrap", html_file);
  if (scraps->next) fputc('s', html_file);
#endif
  fputc(' ', html_file);
  display_scrap_numbers(html_file, scraps);
  fputs(".\n", html_file);
}
static void copy_scrap(FILE *file)
{
  int indent = 0;
  int c = source_get();
  while (1) {
    switch (c) {
      case '@':  {
  c = source_get();
  switch (c) {
    case '@': fputc(c, file);
              break;
    case '|': {
  do {
    do
      c = source_get();
    while (c != '@');
    c = source_get();
  } while (c != '}' && c != ']' && c != ')' );
}
    case '}':
    case ']':
    case ')': return;
    case '<': {
  Name *name = collect_scrap_name();
  fprintf(file, "&lt;%s ", name->spelling);
  if (name->defs)
    {
  Scrap_Node *p = name->defs;
  display_scrap_ref(file, p->scrap);
  if (p->next)
    fputs(", ... ", file);
}
  else {
    putc('?', file);
    fprintf(stderr, "%s: scrap never defined <%s>\n",
            command_name, name->spelling);
  }
  fputs("&gt;", file);
}
              break;
    default:  /* ignore these since pass1 will have warned about them */
              break;
  }
}
                 break;
      case '<' : fputs("&lt;", file);
                 indent++;
                 break;
      case '>' : fputs("&gt;", file);
                 indent++;
                 break;
      case '&' : fputs("&amp;", file);
                 indent++;
                 break;
      case '\n': fputc(c, file);
                 indent = 0;
                 break;
      case '\t': {
  int delta = 8 - (indent % 8);
  indent += delta;
  while (delta > 0) {
    putc(' ', file);
    delta--;
  }
}
                 break;
      default:   putc(c, file);
                 indent++;
                 break;
    }
    c = source_get();
  }
}
static void format_entry(Name *name, FILE *html_file, int file_flag)
{
  while (name) {
    format_entry(name->llink, html_file, file_flag);
    {
  fputs("<dt> ", html_file);
  if (file_flag) {
    fprintf(html_file, "<code>\"%s\"</code>\n<dd> ", name->spelling);
    {
#ifdef _AMIGA
  fputs(get_string(MSG_HTML_35C), html_file);
#else
  fputs("Defined by ", html_file);
#endif
  print_scrap_numbers(html_file, name->defs);
}
  }
  else {
    fprintf(html_file, "&lt;%s ", name->spelling);
    {
  if (name->defs)
    display_scrap_numbers(html_file, name->defs);
  else
    putc('?', html_file);
}
    fputs("&gt;\n<dd> ", html_file);
    {
  Scrap_Node *p = name->uses;
  if (p) {
#ifdef _AMIGA
    fputs(get_string(MSG_HTML_35E1), html_file);
#else
    fputs("Referenced in ", html_file);
#endif
    print_scrap_numbers(html_file, p);
  }
  else
#ifdef _AMIGA
    fputs(get_string(MSG_HTML_35E2), html_file);
#else
    fputs("Not referenced.\n", html_file);
#endif
}
  }
  putc('\n', html_file);
}
    name = name->rlink;
  }
}
static void format_user_entry(Name *name, FILE *html_file)
{
  while (name) {
    format_user_entry(name->llink, html_file);
    {
  Scrap_Node *uses = name->uses;
  if (uses) {
    Scrap_Node *defs = name->defs;
    fprintf(html_file, "<dt><code>%s</code>:\n<dd> ", name->spelling);
    if (uses->scrap < defs->scrap) {
      display_scrap_ref(html_file, uses->scrap);
      uses = uses->next;
    }
    else {
      if (defs->scrap == uses->scrap)
        uses = uses->next;
      fputs("<strong>", html_file);
      display_scrap_ref(html_file, defs->scrap);
      fputs("</strong>", html_file);
      defs = defs->next;
    }
    while (uses || defs) {
      fputs(", ", html_file);
      if (uses && (!defs || uses->scrap < defs->scrap)) {
        display_scrap_ref(html_file, uses->scrap);
        uses = uses->next;
      }
      else {
        if (uses && defs->scrap == uses->scrap)
          uses = uses->next;
        fputs("<strong>", html_file);
        display_scrap_ref(html_file, defs->scrap);
        fputs("</strong>", html_file);
        defs = defs->next;
      }
    }
    fputs(".\n", html_file);
  }
}
    name = name->rlink;
  }
}
