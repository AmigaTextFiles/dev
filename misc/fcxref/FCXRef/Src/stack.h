/* :ts=4			stack.h
*/
#ifndef STACK_H
#define STACK_H

struct sitem {
	struct sitem *below;
	long val;
};

struct stack {
	struct sitem *top;
};

struct stack *newstack(void);
int top(struct stack *s, long *r);
int push(struct stack *s,long v);
int pop(struct stack *s, long *r);
void freestack(struct stack *s);

#endif
