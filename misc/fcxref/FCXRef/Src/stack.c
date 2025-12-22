/* :ts=4			stack.c
 */
#include <stdio.h>
#include <stdlib.h>

#include "stack.h"

struct stack *newstack(void) {
	struct stack *ns;
	ns=malloc(sizeof(struct stack));
	if(ns!=NULL) ns->top=NULL;
	return(ns);
}

int top(struct stack *s, long *r) {
	if(s==NULL||s->top==NULL||r==NULL) return(-1);
	*r=s->top->val;
	return(0);
}

int push(struct stack *s,long v) {
	struct sitem *ni;
	if(s==NULL) return(-1);
	if(NULL==(ni=malloc(sizeof(struct sitem)))) return(-1);
	ni->below=s->top;
	ni->val=v;
	s->top=ni;
	return(0);
}

int pop(struct stack *s, long *r) {
	struct sitem *i;
	if(s==NULL||r==NULL||s->top==NULL) return(-1);
	i=s->top;
	s->top=i->below;
	*r=i->val;
	free(i);
	return(0);
}

void freestack(struct stack *s) {
	long r;
	if(s==NULL) return;
	while(s->top!=NULL) pop(s,&r);
}
