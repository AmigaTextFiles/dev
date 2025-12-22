/*
 *      Reverse Polish Notation calculator - integer only!
 *
 *      Nabbed from GBDK distribution, converted over to Small C+
 *      
 *      Small C+ changes:
 *
 *      - include <ctype.h>
 *      = #define for UBYTE WORD BYTE
 *      - appending \n\l to end of puts statements (must fix lib!)
 *      - Correcting gets() statement so that we give a max size
 *      - Inserting a \l after \n for the printf()
 *
 *      Added to Small C+ archive 14/3/99 djm
 *
 *      I'm guessing that Pascal Felber originally wrote this, if
 *      not, then I apologise.
 *
 *      Enjoy it: enter expressions like 1000 2342 + then 2 *
 *      or something like that, it's all a bit too much like Forth 
 *      for my liking! <grin>
 */


#include <stdio.h>
#include <ctype.h>

#define MAXOP     40
#define NUMBER    '0'
#define STACKSIZE 40

#define UBYTE unsigned char
#define WORD  int
#define BYTE  char


UBYTE sp;
WORD stack[STACKSIZE];

char s[MAXOP];
UBYTE pos;
WORD n;

void push(WORD l)
{
  if(sp < STACKSIZE)
    stack[sp++] = l;
  else
    puts("Stack full\n\l");
}

WORD pop()
{
  if(sp > 0)
    return stack[--sp];
  else
    puts("Stack empty\n\l");
  return 0;
}

WORD top()
{
  if(sp > 0)
    return stack[sp-1];
  else
    puts("Stack empty\n\l");
  return 0;
}

BYTE read_op()
{
  if(pos == 0) {
    gets(s,MAXOP);
  }

  while(s[pos] == ' ' || s[pos] == '\t')
    pos++;

  if(s[pos] == '\0') {
    pos = 0;
    return('\n');
  }

  if(!isdigit(s[pos]))
    return(s[pos++]);

  n = s[pos] - '0';
  while(isdigit(s[++pos]))
    n = 10 * n + s[pos] - '0';

  return NUMBER;
}

void main()
{
  BYTE type;
  WORD op2;

  puts("RPN Calculator\n\l");
  puts("Nabbed from GBDK archive\n\l");
  sp = 0;
  pos = 0;

  while((type = read_op(s)) != 0) {
    switch(type) {
    case NUMBER:
      push(n);
      break;
    case '+':
      push(pop() + pop());
      break;
    case '*':
      push(pop() * pop());
      break;
    case '-':
      op2 = pop();
      push(pop() - op2);
      break;
    case '/':
      op2 = pop();
      if(op2 != 0)
        push(pop() / op2);
      else
        puts("Divide by 0\n\l");
      break;
    case '\n':
      printf("==> %d\n\l", top());
      break;
    }
  }
}
