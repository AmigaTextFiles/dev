/*
 * picasm -- symtab.c
 *
 * symbol table handling
 *
 * Timo Rossi <trossi@iki.fi>
 * 
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "picasm.h"

#define HASH_TABLE_SIZE 127

typedef struct symbol *symtable[HASH_TABLE_SIZE];

/* structure for list of local symbol tables */
struct localtab {
  struct localtab *next;
  struct patch *patch_list;
  symtable table;
};

static symtable global_symbol_table;
static struct localtab *local_table_list;

/*
 * Compute a hash value from a string
 */
static unsigned int
hash(char *str)
{
  unsigned int h, a;

  h = 0;
  while((a = *str++) != '\0') {
    h = 17*h + a;
  }
  return h % HASH_TABLE_SIZE;
}

/*
 * Initialize global and local symbol tables
 */
void
init_symtab(void)
{
  struct symbol **sym;
  int n;

  for(sym = global_symbol_table, n = HASH_TABLE_SIZE;
      n-- > 0; *sym++ = NULL)
    ;

  local_table_list = NULL;
}

/*
 * Add a new local symbol table
 */
void add_local_symtab(void)
{
  struct localtab *tab;
  struct symbol **symp;
  int n;

  tab = mem_alloc(sizeof(struct localtab));

  for(symp = &tab->table[0], n = HASH_TABLE_SIZE;
      n-- > 0; *symp++ = NULL)
    ;

  tab->patch_list = NULL;
  local_patch_list_ptr = &tab->patch_list;
  tab->next = local_table_list;
  local_table_list = tab;
  local_level++;
}

/*
 * Remove a local symbol table.
 * The caller should check that local_level > 0 before calling this
 */
void remove_local_symtab(void)
{
  int i;
  struct localtab *tab;
  struct symbol *sym, *sym2;

  tab = local_table_list;

  for(i = 0; i < HASH_TABLE_SIZE; i++) {
    for(sym = tab->table[i]; sym != NULL; sym = sym2) {
      sym2 = sym->next;
      mem_free(sym);
    }
  }

  local_table_list = tab->next;
  if(local_table_list != NULL)
    local_patch_list_ptr = &local_table_list->patch_list;

  mem_free(tab);
  local_level--;
}

/*
 * Add a new symbol to the symbol table
 */
struct symbol *
add_symbol(char *name, int tab)
{
  struct symbol *sym;
  symtable *table;
  int i;

  table = (tab == SYMTAB_LOCAL ? &local_table_list->table :
	    &global_symbol_table);

  if((sym = mem_alloc(sizeof(struct symbol) + strlen(name))) == NULL)
    return NULL;

  i = hash(name);
  sym->next = (*table)[i];
  (*table)[i] = sym;

  strcpy(sym->name, name);

/* the caller must fill the value, type and flags fields */

  return sym;
}

/*
 * Try to find a symbol from the symbol table
 */
struct symbol *
lookup_symbol(char *name, int tab)
{
  symtable *table;
  struct symbol *sym;
  int i;

  table = (tab == SYMTAB_LOCAL ? &local_table_list->table :
	    &global_symbol_table);

  i = hash(name);

  for(sym = (*table)[i]; sym != NULL; sym = sym->next) {
    if(strcmp(sym->name, name) == 0)
      return sym;
  }

  return NULL;
}

/*
 * symbol table output for listing (global symbols only)
 */
void dump_symtab(FILE *fp)
{
  int i;
  struct symbol *sym, *nsym, *s0, *s1;
  struct symbol *syms = NULL;
  
  for(i = 0; i < HASH_TABLE_SIZE; i++) {
    for(sym = global_symbol_table[i]; sym != NULL; sym = nsym) {
      nsym = sym->next;
      
      for(s0 = NULL, s1 = syms; s1 != NULL; s0 = s1, s1 = s1->next) {
        if(strcmp(s1->name, sym->name) > 0)
          break;
      }
      
      if(s0 == NULL) {
        sym->next = syms;
        syms = sym;
      } else {
        sym->next = s0->next;
        s0->next = sym;
      }
    }
  }

  fputs("\n\nSymbol Table:\nname                 decimal    hex\n", fp);

  for(sym = syms; sym != NULL; sym = sym->next) {
      if(sym->type == SYM_MACRO)
        fprintf(fp, "%-20s   MACRO\n", sym->name);
      else if(sym->type == SYM_FORWARD)
        fprintf(fp, "%-20s  UNDEFINED\n", sym->name);
      else if(sym->type == SYM_DEFINED)
        fprintf(fp, "%-20s  %6ld  0x%04lx\n",
          sym->name, sym->v.value, sym->v.value);
      else
        fprintf(fp, "%-20s   ???\n", sym->name);
  }
}
