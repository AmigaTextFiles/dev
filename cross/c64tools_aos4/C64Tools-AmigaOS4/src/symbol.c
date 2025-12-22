#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "symbol.h"

void yyerror(char *str);

extern int debug;

tablenode *externtable = NULL;
tablenode *symboltable = NULL;
functnode *functtable = NULL;

int findsymbol(char *string)
{
  tablenode *ptr = symboltable;

  while (ptr)
  {
    if (!strcmp(string, ptr->string)) return ptr->value;
    ptr = ptr->next;
  }
  return -1;
}

void newsymbol(char *string, int value)
{
  tablenode *ptr = symboltable;

  if (findsymbol(string) != -1)
  {
    char buf[80];
    sprintf(buf, "symbol %s defined twice", string);
    yyerror(buf);
  }

  if (debug) printf("symbol %s defined as %08x\n", string, value);

  if (!symboltable)
  {
    symboltable = (tablenode *)malloc(sizeof (tablenode));
    ptr = symboltable;
    ptr->string = strdup(string);
    ptr->value = value;
    ptr->next = NULL;
    return;
  }

  while (ptr->next)
  {
    ptr = ptr->next;
  }

  ptr->next = (tablenode *)malloc(sizeof (tablenode));
  ptr = ptr->next;
  ptr->string = strdup(string);
  ptr->value = value;
  ptr->next = NULL;
}

functnode *findfunct(char *string)
{
  functnode *ptr = functtable;

  while (ptr)
  {
    if (!strcmp(string, ptr->string)) return ptr;
    ptr = ptr->next;
  }
  return 0;
}

functnode *newfunct(char *string, int value)
{
  functnode *ptr = functtable;

  if (findsymbol(string) != -1)
  {
    char buf[80];
    sprintf(buf, "function %s defined twice", string);
    yyerror(buf);
    return ptr;
  }

  if (debug)
  {
    if (value >= 0)
    {
      printf("external function %s defined at $%04x\n", string, value);
    }
    else
    {
      printf("internal function %s defined\n", string);
    }
  }
  if (!functtable)
  {
    functtable = (functnode *)malloc(sizeof (functnode));
    ptr = functtable;
    ptr->string = strdup(string);
    ptr->value = value;
    ptr->next = NULL;
    return ptr;
  }

  while (ptr->next)
  {
    ptr = ptr->next;
  }

  ptr->next = (functnode *)malloc(sizeof (functnode));
  ptr = ptr->next;
  ptr->string = strdup(string);
  ptr->value = value;
  ptr->next = NULL;
  return ptr;
}


int findextern(char *string)
{
  tablenode *ptr = externtable;

  while (ptr)
  {
    if (!strcmp(string, ptr->string)) return ptr->value;
    ptr = ptr->next;
  }
  return -1;
}

void newextern(char *string, int value)
{
  tablenode *ptr = externtable;

  if (findextern(string) != -1)
  {
    char buf[80];
    sprintf(buf, "extern %s defined twice", string);
    yyerror(buf);
  }

  if (!externtable)
  {
    externtable = (tablenode *)malloc(sizeof (tablenode));
    ptr = externtable;
    ptr->string = strdup(string);
    ptr->value = value;
    ptr->next = NULL;
    return;
  }

  while (ptr->next)
  {
    ptr = ptr->next;
  }

  ptr->next = (tablenode *)malloc(sizeof (tablenode));
  ptr = ptr->next;
  ptr->string = strdup(string);
  ptr->value = value;
  ptr->next = NULL;
}

