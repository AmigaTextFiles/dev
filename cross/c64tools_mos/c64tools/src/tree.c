#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <ctype.h>
#include "tree.h"
#include "codegen.h"
#include "symbol.h"
#include "types.h"

#define MAXSWITCH 16
#define MAXCASE 256
#define MAXFUNCTDATA 4096

extern int chunkin[];
extern int maxchunknum;
extern FILE *yyout;
extern FILE *yyextern;
extern int lineno;
extern int errors;
extern int debug;
extern int asmcode;
extern char *filename;

extern int pass;
extern int previn;
extern int tl; /* Temporary label */
extern int pc; /* Program counter */
extern int in; /* Instruction number */

extern int vars;
extern int varend;
extern int varstart;
extern int lastopcode;
extern imcode *instr;

int params;
int fdata;
int swn = -1;

functnode *functptr;
functnode *currentfunctptr = NULL;

treenode *functdatanode[MAXFUNCTDATA];
char *functdatalabel[MAXFUNCTDATA];

treenode *casenode[MAXSWITCH][MAXCASE];
char *caselabel[MAXSWITCH][MAXCASE];
int cases[MAXSWITCH];

void yyerror(char *str);

treenode *node(int type)
{
  treenode *this = (treenode *)malloc(sizeof(treenode));
  this->lineno = lineno;
  this->filename = filename;
  this->type = type;
  this->name = NULL;
  this->label = NULL;
  this->index = NULL;

  this->sn1 = NULL;
  this->sn2 = NULL;
  this->sn3 = NULL;
  this->sn4 = NULL;

  return this;
}

treenode *node1(int type, treenode *n1)
{
  treenode *this = (treenode *)malloc(sizeof(treenode));
  this->lineno = lineno;
  this->filename = filename;
  this->type = type;
  this->name = NULL;
  this->label = NULL;
  this->index = NULL;
  this->sn1 = n1;
  this->sn2 = NULL;
  this->sn3 = NULL;
  this->sn4 = NULL;

  return this;
}

treenode *node2(int type, treenode *n1, treenode *n2)
{
  treenode *this = (treenode *)malloc(sizeof(treenode));
  this->lineno = lineno;
  this->filename = filename;
  this->type = type;
  this->name = NULL;
  this->label = NULL;
  this->index = NULL;
  this->sn1 = n1;
  this->sn2 = n2;
  this->sn3 = NULL;
  this->sn4 = NULL;

  return this;
}

treenode *node3(int type, treenode *n1, treenode *n2, treenode *n3)
{
  treenode *this = (treenode *)malloc(sizeof(treenode));
  this->lineno = lineno;
  this->filename = filename;
  this->type = type;
  this->name = NULL;
  this->label = NULL;
  this->index = NULL;
  this->sn1 = n1;
  this->sn2 = n2;
  this->sn3 = n3;
  this->sn4 = NULL;

  return this;
}

treenode *node4(int type, treenode *n1, treenode *n2, treenode *n3, treenode *n4)
{
  treenode *this = malloc(sizeof(treenode));
  this->lineno = lineno;
  this->filename = filename;
  this->type = type;
  this->name = NULL;
  this->label = NULL;
  this->index = NULL;
  this->sn1 = n1;
  this->sn2 = n2;
  this->sn3 = n3;
  this->sn4 = n4;

  return this;
}

void walktree(treenode *this, int mode, char *breaklabel, treenode *sw)
{
  lineno = this->lineno;
  filename = this->filename;
  if (this->label)
  {
    makelabel(this->label);
  }

  if (mode == M_CASE)
  {
    if ((this->type != DEFAULTCASE_STMT) && (this->type != CASE_STMT) && (this->type != STMT_SEQ)) return;
  }

  switch(this->type)
  {
    case EMPTY_STMT:
    break;

    case FLUSH_STMT:
    {
      int c;
      for (c = 0; c < fdata; c++)
      {
        makelabel(functdatalabel[c]);
        walktree(functdatanode[c], M_NONE, NULL, NULL);
      }
      fdata = 0;
    }
    break;

    case FUNCT_BODY:
    if (pass == 1)
    {
      functptr = newfunct(this->label, -1);
      functptr->params = 0;

      if (this->index)
      {
        functptr->retval = findsymbol(this->index);
        if (functptr->retval == -1)
        {
          yyerror("undefined symbol as function return value");
        }
        if (functptr->retval == S_PTR)
        {
          yyerror("pointer as function return value");
        }
        if (functptr->retval >= FIRSTLABEL)
        {
          yyerror("script data as function return value");
        }
        functptr->retval -= FIRSTVARIABLE;
        if (functptr->retval < 0)
        {
          yyerror("constant used as function return value");
        }
      }
      else
      {
        functptr->retval = -1;
      }
      walktree(this->sn1, M_DEFPARAMS, NULL, NULL); /* Define the parameters */
    }
    if (this->label) currentfunctptr = findfunct(this->label);
    if (!currentfunctptr)
    {
      /* Should not happen */
      yyerror("function not defined before function body (compiler bug?)");
    }
    lastopcode = 0;
    walktree(this->sn2, M_NONE, NULL, NULL); /* Generate function code */
    switch(lastopcode)
    {
      case I_STOP:
      case I_RETURN:
      break;

      default:
      outputinstr(I_RETURN, -1);
      break;
    }
    break;

    case FUNCT_DEF:
    break;

    case EXTFUNCT_DEF:
    if (pass == 1)
    {
      int address = findextern(this->name);
      if (address != -1)
      {
        functptr = newfunct(this->name, address);
        functptr->params = 0;
        walktree(this->sn1, M_DEFPARAMS, NULL, NULL); /* Define the parameters */
        if (this->index)
        {
          functptr->retval = findsymbol(this->index);
          if (functptr->retval == -1)
          {
            yyerror("undefined symbol as function return value");
          }
          if (functptr->retval == S_PTR)
          {
            yyerror("pointer as function return value");
          }
          if (functptr->retval >= FIRSTLABEL)
          {
            yyerror("script data as function return value");
          }
          functptr->retval -= FIRSTVARIABLE;
          if (functptr->retval < 0)
          {
            yyerror("constant used as function return value");
          }
        }
        else
        {
          functptr->retval = -1;
        }
      }
      else
      {
        char buf[80];
        sprintf(buf, "unresolved external function %s", this->name);
        yyerror(buf);
      }
    }
    break;

    case EXTERN_DEF:
    if (pass == 1)
    {
      int value = findextern(this->name);
      if (value != -1)
      {
        newsymbol(this->name, value + FIRSTVARIABLE);
      }
      else
      {
        char buf[80];
        sprintf(buf, "unresolved external %s", this->name);
        yyerror(buf);
      }
    }
    break;

    case CONSTANT_DEF:
    {
      if (pass == 1)
      {
        int number;

        walktree(this->sn1, M_SRC, NULL, NULL);
        if (((treenode *)this->sn1)->type != IMM_EXPR)
        {
          yyerror("constant definition couldn't be resolved");
        }
        number = ((treenode *)this->sn1)->number;
        if (number < 0)
        {
          if (number < -128)
          {
            yyerror("negative constant below -128");
          }
          else
          {
            number &= 255;
            newsymbol(this->name, number);
          }
        }
        else
        {
          if (number > 255)
          {
            yyerror("constant over 255");
          }
          else newsymbol(this->name, number);
        }
      }
    }
    break;

    case ALIAS_STMT:
    {
      if (findsymbol(this->index) == -1)
      {
        if (findsymbol(this->name) != -1)
        {
          newsymbol(this->index, findsymbol(this->name));
        }
      }
    }
    break;

    case GLOBAL_DEF:
    {
      if (pass == 1)
      {
        if (vars >= varend)
        {
          yyerror("variable space exceeded");
        }
        else
        {
          newsymbol(this->name, vars+FIRSTVARIABLE);
          vars++;
        }
      }
    }
    break;

    case GLOBALARRAY_DEF:
    {
      if (pass == 1)
      {
        int number;
        walktree(this->sn1, M_SRC, NULL, NULL);
        if ((((treenode *)this->sn1)->type != IMM_EXPR))
        {
          yyerror("array size couldn't be resolved");
        }
        number = ((treenode *)this->sn1)->number;
        if (!number)
        {
          yyerror("zero size array");
        }

        newsymbol(this->name, vars+FIRSTVARIABLE);
        vars += number;
        if (vars > varend)
        {
          yyerror("variable space exceeded");
        }
      }
    }
    break;

    case DATA_STMT:
    if (mode != M_PASSPARAMS)
    {
      walktree(this->sn1, M_DATA, NULL, NULL);
    }
    else
    {
      if (functptr->param[params] == S_PTR)
      {
        if (fdata == MAXFUNCTDATA)
        {
          yyerror("too many data statements in a function");
        }
        else
        {
          char textbuf[40];

          templabel(textbuf);
          functdatalabel[fdata] = strdup(textbuf);
          functdatanode[fdata] = this;
          outputinstr3(I_LOADPTR, 0, 0, 0, findlabel(textbuf));
          fdata++;
        }
      }
      else
      {
        yyerror("data definition for a non-pointer parameter");
      }
    }
    break;

    case ASSIGN_STMT:
    {
      walktree(this->sn2, M_SRC, NULL, NULL); /* Generate code for the expression */
      walktree(this->sn1, M_DEST, NULL, NULL); /* Generate code for the destination */
    }
    break;

    case INCASSIGN_STMT:
    {
      walktree(this->sn1, M_INC, NULL, NULL); /* Generate code for the expression */
    }
    break;

    case DECASSIGN_STMT:
    {
      walktree(this->sn1, M_DEC, NULL, NULL); /* Generate code for the expression */
    }
    break;

    case IF_STMT:
    {
      char textbuf[40];
      if (((treenode *)this->sn1)->type != NOT_EXPR)
        walktree(this->sn1, M_SRC, NULL, NULL); /* Generate code for the expression */
      else
        walktree(this->sn1, M_SRCIF, NULL, NULL);

      /* Optimize goto-if, break-if etc. */
      switch(((treenode *)this->sn2)->type)
      {
        case BREAK_STMT:
        if (((treenode *)this->sn1)->type != NOT_EXPR)
          outputinstr3(I_JUMPTRUEL, 0, 0, 0, findlabel(breaklabel));
        else
          outputinstr3(I_JUMPFALSEL, 0, 0, 0, findlabel(breaklabel));
        break;

        case GOTO_STMT:
        if (((treenode *)this->sn1)->type != NOT_EXPR)
          outputinstr3(I_JUMPTRUEL, 0, 0, 0, findlabel(((treenode *)this->sn2)->name));
        else
          outputinstr3(I_JUMPFALSEL, 0, 0, 0, findlabel(((treenode *)this->sn2)->name));
        break;

        default:
        templabel(textbuf);
        if (((treenode *)this->sn1)->type != NOT_EXPR)
          outputinstr3(I_JUMPFALSEL, 0, 0, 0, findlabel(textbuf));
        else
          outputinstr3(I_JUMPTRUEL, 0, 0, 0, findlabel(textbuf));
        walktree(this->sn2, M_NONE, breaklabel, NULL); /* Generate code for the statements */
        makelabel(textbuf); /* Label to jump to if check failed */
        break;
      }
    }
    break;

    case IFELSE_STMT:
    {
      char textbuf[40];
      char textbuf2[40];
      templabel(textbuf);
      templabel(textbuf2);
      if (((treenode *)this->sn1)->type != NOT_EXPR)
        walktree(this->sn1, M_SRC, NULL, NULL); /* Generate code for the expression */
      else
        walktree(this->sn1, M_SRCIF, NULL, NULL);

      if (((treenode *)this->sn1)->type != NOT_EXPR)
        outputinstr3(I_JUMPFALSEL, 0, 0, 0, findlabel(textbuf));
      else
        outputinstr3(I_JUMPTRUEL, 0, 0, 0, findlabel(textbuf));
      walktree(this->sn2, M_NONE, breaklabel, NULL); /* Generate code for the statements */
      outputinstr3(I_JUMPL, 0, 0, 0, findlabel(textbuf2)); /* Label to jump after endif */
      makelabel(textbuf); /* Label of else part */
      walktree(this->sn3, M_NONE, breaklabel, NULL); /* Generate code for the elsepart statements */
      makelabel(textbuf2);
    }
    break;

    case REPWHILE_STMT:
    {
      char textbuf[40];
      char textbuf2[40];
      templabel(textbuf);
      templabel(textbuf2);
      makelabel(textbuf); /* Beginning of the loop */
      walktree(this->sn1, M_NONE, textbuf2, NULL); /* Generate code for the statements */

      if (((treenode *)this->sn2)->type != NOT_EXPR)
        walktree(this->sn2, M_SRC, NULL, NULL); /* Generate code for the expression */
      else
        walktree(this->sn2, M_SRCIF, NULL, NULL);

      if (((treenode *)this->sn2)->type != NOT_EXPR)
        outputinstr3(I_JUMPTRUEL, 0, 0, 0, findlabel(textbuf));
      else
        outputinstr3(I_JUMPFALSEL, 0, 0, 0, findlabel(textbuf));
      makelabel(textbuf2); /* Jump out of the loop */
    }
    break;

    case WHILE_STMT:
    {
      char textbuf[40];
      char textbuf2[40];
      templabel(textbuf);
      templabel(textbuf2);
      makelabel(textbuf); /* Beginning of the loop */

      if (((treenode *)this->sn1)->type != NOT_EXPR)
        walktree(this->sn1, M_SRC, NULL, NULL); /* Generate code for expression */
      else
        walktree(this->sn1, M_SRCIF, NULL, NULL);

      if (((treenode *)this->sn1)->type != NOT_EXPR)
        outputinstr3(I_JUMPFALSEL, 0, 0, 0, findlabel(textbuf2));
      else
        outputinstr3(I_JUMPTRUEL, 0, 0, 0, findlabel(textbuf2));
      walktree(this->sn2, M_NONE, textbuf2, NULL); /* Generate code for the statements */
      outputinstr3(I_JUMPL, 0, 0, 0, findlabel(textbuf)); /* Jump back to start */
      makelabel(textbuf2); /* End of the loop */
    }
    break;

    case FORNEXT_STMT:
    {
      char textbuf[40];
      char textbuf2[40];

      walktree(this->sn1, M_NONE, NULL, NULL); /* Generate code for the initial assignment */

      templabel(textbuf);
      templabel(textbuf2);
      makelabel(textbuf); /* Beginning of the loop */
      if (((treenode *)this->sn2)->type != EMPTY_STMT)
      {
        if (((treenode *)this->sn2)->type != NOT_EXPR)
          walktree(this->sn2, M_SRC, NULL, NULL); /* Generate code for exit expression */
        else
          walktree(this->sn2, M_SRCIF, NULL, NULL);

        if (((treenode *)this->sn2)->type != NOT_EXPR)
          outputinstr3(I_JUMPFALSEL, 0, 0, 0, findlabel(textbuf2));
        else
          outputinstr3(I_JUMPTRUEL, 0, 0, 0, findlabel(textbuf2));
      }
      walktree(this->sn4, M_NONE, textbuf2, NULL); /* Generate code for the statements */
      walktree(this->sn3, M_NONE, NULL, NULL); /* Generate code for the increment */
      outputinstr3(I_JUMPL, 0, 0, 0, findlabel(textbuf));
      makelabel(textbuf2); /* End of the loop */
    }
    break;

    case SWITCH_STMT:
    {
      int c, defaultcase = -1;
      treenode *s = ((treenode *)this->sn1);

      char textbuf[40];
      templabel(textbuf);

      swn++;
      if (swn == MAXSWITCH)
      {
        yyerror("maximum switch nesting depth exceeded");
        break;
      }

      if (s->type != ABS_IDENT)
      {
        walktree(s, M_SRC, NULL, NULL); /* Generate switch expression */
        /* Use flags variable for storing result of switch expression */
        this->name = "flags";
        outputinstr2(I_STOREMEM, getvaraddr(this->name)&0xff,
                                 getvaraddr(this->name)>>8, -1);
      }
      cases[swn] = 0;
      walktree(this->sn2, M_CASE, textbuf, this->sn1); /* Check cases */
      for (c = 0; c < cases[swn]; c++)
      {
        if (casenode[swn][c] != NULL)
        {
          if (s->type != ABS_IDENT)
          {
            this->name = "flags";
            outputinstr2(I_PUSHMEM, getvaraddr(this->name)&0xff,
                                    getvaraddr(this->name)>>8, -1);
          }
          else walktree(s, M_SRC, NULL, NULL);
          walktree(casenode[swn][c], M_SRC, NULL, NULL);
          outputinstr(I_ISEQ, -1);
          outputinstr3(I_JUMPTRUEL, 0, 0, 0, findlabel(caselabel[swn][c]));
        }
        else
        {
          if (defaultcase < 0) defaultcase = c;
          else
          {
            yyerror("multiple default cases");
          }
        }
      }
      if (defaultcase < 0)
      {
        outputinstr3(I_JUMPL, 0, 0, 0, findlabel(textbuf));
      }
      else
      {
        /* If default case is first, no jump needed */
        if (defaultcase)
        {
          yyerror("please put default case first (compiler bug)");
          // outputinstr3(I_JUMPL, 0, 0, 0, findlabel(caselabel[swn][defaultcase]));
        }
      }
      cases[swn] = 0;
      walktree(this->sn2, M_NONE, textbuf, this->sn1); /* Generate case labels & code */
      /* Break label */
      makelabel(textbuf);
      swn--;
    }
    break;

    case CASE_STMT:
    if (!sw)
    {
      yyerror("misplaced case");
    }
    else
    {
      char textbuf[40];

      if (cases[swn] == MAXCASE)
      {
        yyerror("maximum cases exceeded");
        break;
      }
      if (mode == M_CASE)
      {
        templabel(textbuf);
        caselabel[swn][cases[swn]] = strdup(textbuf);
        casenode[swn][cases[swn]] = this->sn1;
      }
      else
      {
        makelabel(caselabel[swn][cases[swn]]);
      }
      cases[swn]++;
    }
    break;

    case DEFAULTCASE_STMT:
    if (!sw)
    {
      yyerror("misplaced default case");
    }
    else
    {
      char textbuf[40];

      if (cases[swn] == MAXCASE)
      {
        yyerror("maximum cases exceeded");
        break;
      }
      if (mode == M_CASE)
      {
        casenode[swn][cases[swn]] = NULL;
      }
      else
      {
        templabel(textbuf);
        makelabel(textbuf);
        caselabel[swn][cases[swn]] = strdup(textbuf);
      }
      cases[swn]++;
    }
    break;

    case FUNCT_EXPR:
    case FUNCT_STMT:
    {
      if (pass > 1)
      {
        functptr = findfunct(this->name);
        if (!functptr)
        {
          char buf[80];
          sprintf(buf, "unresolved function %s", this->name);
          yyerror(buf);
          break;
        }
        if (this->type == FUNCT_EXPR)
        {
          if (functptr->retval < 0)
          {
            yyerror("function does not return a value");
          }
          switch(mode)
          {
            case M_SRC:
            case M_SRCIF:
            break;

            default:
            yyerror("misplaced function call");
            break;
          }
        }
        /* Generate code for parameter passing */
        params = 0;
        if (!functptr->params)
        {
          if (((treenode *)this->sn1)->type != EMPTY_STMT)
          {
            yyerror("function does not expect parameters");
          }
        }

        walktree(this->sn1, M_PASSPARAMS, NULL, NULL);
        /* Generate last param here */
        if (functptr->params)
        {
          if (functptr->param[params] < S_PTR)
          {
            outputinstr2(I_STOREMEM, functptr->param[params]&0xff,
                                     functptr->param[params]>>8, -1);
          }
          params++;
        }
        if ((params) && (params != functptr->params))
        {
          yyerror("unmatching number of parameters");
        }

        /* Internal or external? */
        if (functptr->value >= 0)
        {
          int rbits = 0;
          if (functptr->retval == varstart+0) rbits = 1;
          if (functptr->retval == varstart+1) rbits = 2;
          if (functptr->retval == varstart+2) rbits = 4;

          outputinstr2(I_EXTERNCALL+rbits, functptr->value & 0xff,
                                     functptr->value >> 8, -1);
        }
        else
        {
          outputinstr3(I_JUMPSUBL, 0, 0, 0, findlabel(this->name));
        }
        if (this->type == FUNCT_EXPR)
        {
          outputinstr2(I_PUSHMEM, functptr->retval & 0xff,
                                  functptr->retval >> 8, -1);
        }
      }
      else
      {
        /* Walk the tree just to convert constants */
        walktree(this->sn1, M_SRC, NULL, NULL);
      }

    }
    break;

    case GOTO_STMT:
    {
      outputinstr3(I_JUMPL, 0, 0, 0, findlabel(this->name));
    }
    break;

    case RETURN_STMT:
    {
      outputinstr(I_RETURN, -1);
    }
    break;

    case RETURNEXPR_STMT:
    {
      if (pass > 1)
      {
        int retval;
        if (!currentfunctptr)
        {
          /* Should not happen */
          yyerror("not within a function");
        }
        else
        {
          retval = currentfunctptr->retval;
          if (retval < 0)
          {
            yyerror("function doesn't have a return value");
          }
          /* Generate return expression on stack */
          walktree(this->sn1, M_SRC, NULL, NULL);
          /* Pop into the return variable */
          outputinstr2(I_STOREMEM, retval & 0xff, retval >> 8, -1);
        }
      }
      outputinstr(I_RETURN, -1);
    }
    break;

    case STOP_STMT:
    {
      outputinstr(I_STOP, -1);
    }
    break;

    case BREAK_STMT:
    {
      if (breaklabel)
      {
        outputinstr3(I_JUMPL, 0, 0, 0, findlabel(breaklabel));
      }
      else
      {
        yyerror("misplaced break");
      }
    }
    break;

    case LOADPTR_STMT:
    if (((treenode *)this->sn1)->type == ABS_IDENT)
    {
      outputinstr3(I_LOADPTR, 0, 0, 0, findlabel(((treenode *)this->sn1)->name));
    }
    else
    {
      yyerror("not a label as loadptr parameter");
    }

    break;

    case CHUNK_STMT:
    {
      int chunknum;

      if (pass == 1) walktree(this->sn1, M_SRC, NULL, NULL); /* Chunk number */
      if (((treenode *)this->sn1)->type != IMM_EXPR)
      {
        yyerror("chunk number couldn't be resolved");
      }

      chunknum = ((treenode *)this->sn1)->number;
      if (chunknum > MAX_CHUNKS)
      {
        yyerror("maximum chunk number exceeded");
      }
      else
      {
        chunkin[chunknum] = in;
        if (maxchunknum < chunknum) maxchunknum = chunknum;
      }
      walktree(this->sn2, M_DATA, NULL, NULL); /* Chunk data */
    }
    break;

    case STMT_SEQ:
    walktree(this->sn1, mode, breaklabel, sw);
    walktree(this->sn2, mode, breaklabel, sw);
    break;

    case UNIT_SEQ:
    walktree(this->sn1, M_NONE, NULL, NULL);
    walktree(this->sn2, M_NONE, NULL, NULL);
    break;

    case EXPR_SEQ:
    walktree(this->sn1, mode, NULL, NULL);
    if (mode == M_PASSPARAMS)
    {
      if (functptr->param[params] < S_PTR)
      {
         outputinstr2(I_STOREMEM, functptr->param[params]&0xff,
                                  functptr->param[params]>>8, -1);
      }
      params++;
    }
    walktree(this->sn2, mode, NULL, NULL);
    break;

    case IDENT_SEQ:
    walktree(this->sn1, mode, NULL, NULL);
    walktree(this->sn2, mode, NULL, NULL);
    break;

    case ABS_IDENT:
    {
      if (isconstant(this->name))
      {
        if (pass == 1)
        {
          this->type = IMM_EXPR;
          this->number = findsymbol(this->name);
        }
        else
        {
          /* We can't afford changing the tree after pass 1 */
          yyerror("constant not defined before use");
        }
      }

      if ((isdata(this->name)) && ((mode == M_DEST) || (mode == M_INC) || (mode == M_DEC)))
      {
        yyerror("attempt to modify script data");
      }

      switch (mode)
      {
        case M_DATA:
        if (isdata(this->name))
        {
          outputinstr3(I_PTR, 0, 0, 0, findlabel(this->name));
        }
        else
        {
          outputinstr2(I_PTR, (findlabel(this->name)-FIRSTVARIABLE) & 0xff,
                              (findlabel(this->name)-FIRSTVARIABLE) >> 8, -1);
        }
        break;

        case M_DEFPARAMS:
        functptr->param[functptr->params] = findsymbol(this->name);
        if (functptr->param[functptr->params] == -1)
        {
          yyerror("undefined symbol as parameter");
        }
        if (functptr->param[functptr->params] < S_PTR)
          functptr->param[functptr->params] -= FIRSTVARIABLE;
        if (functptr->param[functptr->params] < 0)
        {
          yyerror("constant used as function parameter");
        }
        if ((functptr->param[functptr->params] >= FIRSTLABEL) &&
          (functptr->param[functptr->params] != S_PTR))
        {
          yyerror("script data used as function parameter");
        }
        if (functptr->param[functptr->params] == -1)
        {
          yyerror("undefined variable used as function parameter");
        }

        functptr->params++;
        if (debug) printf("Symbol %s defined as parameter %d for function %s\n", this->name, functptr->params, functptr->string);
        break;

        case M_INC:
        outputinstr2(I_INCMEM, getvaraddr(this->name)&0xff,
                               getvaraddr(this->name)>>8, -1);
        break;

        case M_DEC:
        outputinstr2(I_DECMEM, getvaraddr(this->name)&0xff,
                               getvaraddr(this->name)>>8, -1);
        break;

        case M_SRC:
        case M_SRCIF:
        if (!isdata(this->name))
        {
          outputinstr2(I_PUSHMEM, getvaraddr(this->name)&0xff,
                                 getvaraddr(this->name)>>8, -1);
        }
        else
        {
          outputinstr3(I_PUSHDAT, 0, 0, 0, findlabel(this->name));
        }
        break;

        case M_DEST:
        outputinstr2(I_STOREMEM, getvaraddr(this->name)&0xff,
                                 getvaraddr(this->name)>>8, -1);
        break;

        case M_PASSPARAMS:
        switch (functptr->param[params])
        {
          case S_PTR:
          outputinstr3(I_LOADPTR, 0, 0, 0, findlabel(this->name));
          break;

          default:
          if (!isdata(this->name))
          {
            outputinstr2(I_PUSHMEM, getvaraddr(this->name)&0xff,
                                   getvaraddr(this->name)>>8, -1);
          }
          else
          {
            outputinstr3(I_PUSHDAT, 0, 0, 0, findlabel(this->name));
          }
          break;
        }

        case M_GOTO:
        break;

        case M_SUBSCRIPT:
        break;

        default:
        yyerror("misplaced memory reference");
        return;
      }
    }
    break;

    case SUB_IDENT:
    {
      int csub;

      if (isconstant(this->name))
      {
        yyerror("subscripting a constant");
      }

      if (pass == 1) walktree(this->sn1, M_SUBSCRIPT, NULL, NULL); /* Resolve the expression */
      switch(((treenode *)this->sn1)->type)
      {
        case IMM_EXPR:
        csub = 1;
        this->number = ((treenode *)this->sn1)->number;
        break;

        default:
        csub = 0;
        walktree(this->sn1, M_SRC, NULL, NULL);
        break;
      }

      if ((isdata(this->name)) && ((mode == M_DEST) || (mode == M_INC) || (mode == M_DEC)))
      {
        yyerror("attempt to modify script data");
      }

      switch (mode)
      {
        case M_DATA:
        yyerror("subscripting in a data statement");
        break;

        case M_DEFPARAMS:
        yyerror("subscripting in function parameters");
        break;

        case M_INC:
        if (!csub)
        {
          outputinstr2(I_INCMEMIND, getvaraddr(this->name)&0xff,
                                    getvaraddr(this->name)>>8, -1);
        }
        else
        {
          outputinstr2(I_INCMEM, (getvaraddr(this->name)+this->number)&0xff,
                                 (getvaraddr(this->name)+this->number)>>8, -1);
        }
        break;

        case M_DEC:
        if (!csub)
        {
          outputinstr2(I_DECMEMIND, getvaraddr(this->name)&0xff,
                                    getvaraddr(this->name)>>8, -1);
        }
        else
        {
          outputinstr2(I_DECMEM, (getvaraddr(this->name)+this->number)&0xff,
                                 (getvaraddr(this->name)+this->number)>>8, -1);
        }
        break;

        case M_SUBSCRIPT:
        case M_SRC:
        case M_SRCIF:
        if (!isdata(this->name))
        {
          if (!csub)
          {
            outputinstr2(I_PUSHMEMIND, getvaraddr(this->name)&0xff,
                                      getvaraddr(this->name)>>8, -1);
          }
          else
          {
            outputinstr2(I_PUSHMEM, (getvaraddr(this->name)+this->number)&0xff,
                                   (getvaraddr(this->name)+this->number)>>8, -1);
          }
        }
        else
        {
          if (!csub)
          {
            outputinstr3(I_PUSHDATIND, 0, 0, 0, findlabel(this->name));
          }
          else
          {
            outputinstr3(I_PUSHDAT, this->number, 0, 0, findlabel(this->name));
          }
        }
        break;

        case M_DEST:
        if (!csub)
        {
          outputinstr2(I_STOREMEMIND, getvaraddr(this->name)&0xff,
                                    getvaraddr(this->name)>>8, -1);
        }
        else
        {
          outputinstr2(I_STOREMEM, (getvaraddr(this->name)+this->number)&0xff,
                                 (getvaraddr(this->name)+this->number)>>8, -1);
        }
        break;

        case M_PASSPARAMS:
        switch (functptr->param[params])
        {
          case S_PTR:
          if ((pass > 1) && (!isdata(this->name)))
          {
            yyerror("not a pointer to script data");
          }
          else
          {
            if (csub)
            {
              outputinstr3(I_PTR, this->number, 0, 0, findlabel(this->name));
            }
            else
            {
              yyerror("pointer parameter can't be variable-subscripted");
            }
          }
          break;

          default:
          if (!isdata(this->name))
          {
            if (!csub)
            {
              outputinstr2(I_PUSHMEMIND, getvaraddr(this->name)&0xff,
                                      getvaraddr(this->name)>>8, -1);
            }
            else
            {
              outputinstr2(I_PUSHMEM, (getvaraddr(this->name)+this->number)&0xff,
                                     (getvaraddr(this->name)+this->number)>>8, -1);
            }
          }
          else
          {
            if (!csub)
            {
              outputinstr3(I_PUSHDATIND, 0, 0, 0, findlabel(this->name));
            }
            else
            {
              outputinstr3(I_PUSHDAT, this->number, 0, 0, findlabel(this->name));
            }
          }
          break;
        }
        break;

        case M_GOTO:
        break;

        default:
        yyerror("misplaced memory reference");
        return;
      }
    }
    break;

    case STRINGDEF_SEQ:
    walktree(this->sn1, mode, NULL, NULL);
    walktree(this->sn2, mode, NULL, NULL);
    break;

    case STRINGDEF:
    if (pass > 1)
    {
      unsigned c;
      switch(mode)
      {
        case M_DATA:
        for (c = 1; c < strlen(this->name)-1; c++)
        {
          outputinstr1(I_DATA, toupper(this->name[c])&0x3f, -1);
        }
        break;

        default:
        yyerror("misplaced string definition");
        break;
      }
    }
    break;


    case EQ_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be compared */
      walktree(this->sn1, mode, NULL, NULL);
      outputinstr(I_ISEQ, -1);
    }
    break;

    case NE_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be compared */
      walktree(this->sn1, mode, NULL, NULL);
      outputinstr(I_ISNE, -1);
    }
    break;

    case GT_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be compared */
      walktree(this->sn1, mode, NULL, NULL);
      outputinstr(I_ISGT, -1);
    }
    break;

    case LT_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be compared */
      walktree(this->sn1, mode, NULL, NULL);
      outputinstr(I_ISLT, -1);
    }
    break;

    case GTE_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be compared */
      walktree(this->sn1, mode, NULL, NULL);
      outputinstr(I_ISGTE, -1);
    }
    break;

    case LTE_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be compared */
      walktree(this->sn1, mode, NULL, NULL);
      outputinstr(I_ISLTE, -1);
    }
    break;

    case AND_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be operated on */
      walktree(this->sn1, mode, NULL, NULL);
      if ((((treenode *)this->sn1)->type == IMM_EXPR) && (((treenode *)this->sn2)->type == IMM_EXPR))
      {
        this->type = IMM_EXPR;
        this->number = (((treenode *)this->sn1)->number & ((treenode *)this->sn2)->number);
      }
      else
      {
        outputinstr(I_AND, -1);
      }
    }
    break;

    case OR_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be operated on */
      walktree(this->sn1, mode, NULL, NULL);
      if ((((treenode *)this->sn1)->type == IMM_EXPR) && (((treenode *)this->sn2)->type == IMM_EXPR))
      {
        this->type = IMM_EXPR;
        this->number = (((treenode *)this->sn1)->number | ((treenode *)this->sn2)->number);
      }
      else
      {
        outputinstr(I_OR, -1);
      }
    }
    break;

    case ADD_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be operated on */
      walktree(this->sn1, mode, NULL, NULL);
      if ((((treenode *)this->sn1)->type == IMM_EXPR) && (((treenode *)this->sn2)->type == IMM_EXPR))
      {
        this->type = IMM_EXPR;
        this->number = (((treenode *)this->sn1)->number + ((treenode *)this->sn2)->number);
      }
      else
      {
        outputinstr(I_ADD, -1);
      }
    }
    break;

    case SUB_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be operated on */
      walktree(this->sn1, mode, NULL, NULL);
      if ((((treenode *)this->sn1)->type == IMM_EXPR) && (((treenode *)this->sn2)->type == IMM_EXPR))
      {
        this->type = IMM_EXPR;
        this->number = (((treenode *)this->sn1)->number - ((treenode *)this->sn2)->number);
      }
      else
      {
        outputinstr(I_SUB, -1);
      }
    }
    break;

    case SHIFTL_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be operated on */
      walktree(this->sn1, mode, NULL, NULL);
      if ((((treenode *)this->sn1)->type == IMM_EXPR) && (((treenode *)this->sn2)->type == IMM_EXPR))
      {
        this->type = IMM_EXPR;
        this->number = (((treenode *)this->sn1)->number << ((treenode *)this->sn2)->number);
      }
      else
      {
        outputinstr(I_SHIFTL, -1);
      }
    }
    break;

    case SHIFTR_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be operated on */
      walktree(this->sn1, mode, NULL, NULL);
      if ((((treenode *)this->sn1)->type == IMM_EXPR) && (((treenode *)this->sn2)->type == IMM_EXPR))
      {
        this->type = IMM_EXPR;
        this->number = (((treenode *)this->sn1)->number >> ((treenode *)this->sn2)->number);
      }
      else
      {
        outputinstr(I_SHIFTR, -1);
      }
    }
    break;

    case MUL_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be operated on */
      walktree(this->sn1, mode, NULL, NULL);
      if ((((treenode *)this->sn1)->type == IMM_EXPR) && (((treenode *)this->sn2)->type == IMM_EXPR))
      {
        this->type = IMM_EXPR;
        this->number = (((treenode *)this->sn1)->number * ((treenode *)this->sn2)->number);
      }
      else
      {
        outputinstr(I_MUL, -1);
      }
    }
    break;

    case DIV_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be operated on */
      walktree(this->sn1, mode, NULL, NULL);
      if ((((treenode *)this->sn1)->type == IMM_EXPR) && (((treenode *)this->sn2)->type == IMM_EXPR))
      {
        if (((treenode *)this->sn2)->number == 0)
        {
          yyerror("divide by zero");
          return;
        }
        this->type = IMM_EXPR;
        this->number = (((treenode *)this->sn1)->number / ((treenode *)this->sn2)->number);
      }
      else
      {
        outputinstr(I_DIV, -1);
      }
    }
    break;

    case MOD_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be operated on */
      walktree(this->sn1, mode, NULL, NULL);
      if ((((treenode *)this->sn1)->type == IMM_EXPR) && (((treenode *)this->sn2)->type == IMM_EXPR))
      {
        if (((treenode *)this->sn2)->number == 0)
        {
          yyerror("divide by zero");
          return;
        }
        this->type = IMM_EXPR;
        this->number = (((treenode *)this->sn1)->number % ((treenode *)this->sn2)->number);
      }
      else
      {
        outputinstr(I_MOD,-1);
      }
    }
    break;

    case EOR_EXPR:
    {
      walktree(this->sn2, mode, NULL, NULL); /* Generate the values to be operated on */
      walktree(this->sn1, mode, NULL, NULL);
      if ((((treenode *)this->sn1)->type == IMM_EXPR) && (((treenode *)this->sn2)->type == IMM_EXPR))
      {
        this->type = IMM_EXPR;
        this->number = (((treenode *)this->sn1)->number ^ ((treenode *)this->sn2)->number);
      }
      else
      {
        outputinstr(I_EOR,-1);
      }
    }
    break;

    case NEG_EXPR:
    {
      walktree(this->sn1, mode, NULL, NULL); /* Generate the value to be negated */
      if (((treenode *)this->sn1)->type == IMM_EXPR)
      {
        this->type = IMM_EXPR;
        this->number = -(((treenode *)this->sn1)->number);
      }
      else
      {
        outputinstr(I_2COMPL,-1);
      }
    }
    break;

    case NOT_EXPR:
    {
      if (mode != M_SRCIF)
      {
        walktree(this->sn1, mode, NULL, NULL); /* Generate the value to be negated */
        if (((treenode *)this->sn1)->type == IMM_EXPR)
        {
          this->type = IMM_EXPR;
          this->number = ((treenode *)this->sn1)->number ^ 0xff;
        }
        else
        {
          outputinstr(I_NEG,-1);
        }
      }
      else
      {
        walktree(this->sn1, mode, NULL, NULL); /* Generate the value to be negated */
      }
    }
    break;

    case IMM_EXPR:
    {
      if (pass == 2)
      {
        if (this->number < 0)
        {
          if (this->number < -128)
          {
            yyerror("negative constant below -128");
          }
          else this->number &= 255;
        }
        else
        {
          if (this->number > 255)
          {
            yyerror("constant over 255");
          }
        }
      }

      switch(mode)
      {
        case M_DATA:
        outputinstr1(I_DATA, this->number, -1);
        break;

        case M_PASSPARAMS:
        case M_SRC:
        case M_SRCIF:
        outputinstr1(I_PUSHIMM, this->number, -1);
        break;

        case M_INC:
        case M_DEC:
        yyerror("attempt to increase/decrease a constant");
        break;

        case M_DEST:
        yyerror("constant as assignment destination");
        return;
      }
    }
    break;

    default:
    yyerror("undefined node in parse tree");
    break;
  }
  return;
}

