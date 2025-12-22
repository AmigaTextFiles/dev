/*
 * picasm -- symtab.c
 *
 * symbol table handling
 *
 */

#include <stdio.h>
#include <string.h>

#include "picasm.h"

#define HASH_TABLE_SIZE 127

static struct symbol *symbol_table[HASH_TABLE_SIZE];

/*
 * Compute a hash value from a string
 */
static unsigned int
hash(char *str)
{
  unsigned int h, a;

  h = 0;
  while((a = *str++) != '\0')
    {
      h = 17*h + a;
    }
  return h % HASH_TABLE_SIZE;
}

/*
 * Initialize symbol table
 */
void
init_symtab(void)
{
  struct symbol **sym;
  int n;

  for(sym = symbol_table, n = HASH_TABLE_SIZE; n-- > 0; *sym++ = NULL)
    ;
}

/*
 * Add a new symbol to the symbol table
 */
struct symbol *
add_symbol(char *name)
{
  struct symbol *sym;
  int i;

  if((sym = mem_alloc(sizeof(struct symbol) + strlen(name))) == NULL)
    return NULL;

  i = hash(name);
  sym->next = symbol_table[i];
  symbol_table[i] = sym;

  strcpy(sym->name, name);

/* the caller must fill the value, type and flags fields */

  return sym;
}

/*
 * Try to find a symbol from the symbol table
 */
struct symbol *
lookup_symbol(char *name)
{
  struct symbol *sym;
  int i;

  i = hash(name);
  for(sym = symbol_table[i]; sym != NULL; sym = sym->next)
    {
      if(strcmp(sym->name, name) == 0)
	return sym;
    }

  return NULL;
}
