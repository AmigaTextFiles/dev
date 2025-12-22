@x l.10
#include <stdio.h>
@y
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
@z

@x l.13
@<Procedures@>@;
@y
@<Predeclarations@>@;
@<Procedures@>@;
@z

@x l.379
collapse(p,q)
  node *p,*q;
@y
void collapse(p,q)
  node *p,*q;
@z

@x l.446
@* Index.
@y
@ Missing prototypes.

@<Predecl...@>=
char *save_string(char *);
node *new_node(void);
int compare(node *,node*);
void collapse(node *,node *);

@* Index.
@z
