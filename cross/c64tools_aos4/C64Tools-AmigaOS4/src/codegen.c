#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "tree.h"
#include "ctype.h"
#include "codegen.h"
#include "symbol.h"
#include "types.h"

extern char *srcname;
extern FILE *yyextern;
extern FILE *yyout;
extern FILE *yyasm;
extern FILE *yylist;
extern int lineno;
extern int errors;
extern int debug;
extern tablenode *symboltable;
extern functnode *functtable;

void yyerror(char *str);

int onefile = 0;
int header = 0;
int pages = 0;
int labels = 0;
int bytes;
int pass;
int previn;
int lastopcode;
int tl; /* Temporary label */
int pc; /* Program counter */
int in; /* Instruction number */

int vars = 0x0334;
int varsize = 0x100;
int pagesize = 0x400;
int varstart;
int varend;
int noconstants = 0;
int debug = 0;
imcode *instr;
int maxchunknum = -1;
int chunkin[MAX_CHUNKS];

opcodename optbl[] = {
{"pushis  ",I_PUSHIMMSMALL},
{"pushis  ",I_PUSHIMMSMALL+1},
{"pushis  ",I_PUSHIMMSMALL+2},
{"pushis  ",I_PUSHIMMSMALL+3},
{"pushis  ",I_PUSHIMMSMALL+4},
{"pushis  ",I_PUSHIMMSMALL+5},
{"pushis  ",I_PUSHIMMSMALL+6},
{"pushis  ",I_PUSHIMMSMALL+7},
{"pushis  ",I_PUSHIMMSMALL+8},
{"pushis  ",I_PUSHIMMSMALL+9},
{"pushis  ",I_PUSHIMMSMALL+10},
{"pushis  ",I_PUSHIMMSMALL+11},
{"pushis  ",I_PUSHIMMSMALL+12},
{"pushis  ",I_PUSHIMMSMALL+13},
{"pushis  ",I_PUSHIMMSMALL+14},
{"pushis  ",I_PUSHIMMSMALL+15},
{"pushi   ",I_PUSHIMM},

{"pushv   ",I_PUSHVAR},
{"pushm   ",I_PUSHMEM},
{"pushd   ",I_PUSHDAT},
{"pushvi  ",I_PUSHVARIND},
{"pushmi  ",I_PUSHMEMIND},
{"pushdi  ",I_PUSHDATIND},

{"storev  ",I_STOREVAR},
{"storem  ",I_STOREMEM},
{"storevi ",I_STOREVARIND},
{"storemi ",I_STOREMEMIND},

{"incv    ",I_INCVAR},
{"incm    ",I_INCMEM},
{"incvi   ",I_INCVARIND},
{"incmi   ",I_INCMEMIND},

{"decv    ",I_DECVAR},
{"decm    ",I_DECMEM},
{"decvi   ",I_DECVARIND},
{"decmi   ",I_DECMEMIND},

{"loadvs  ",I_LOADVARSMALL},
{"loadvs  ",I_LOADVARSMALL+1},
{"loadvs  ",I_LOADVARSMALL+2},
{"loadvs  ",I_LOADVARSMALL+3},
{"loadvs  ",I_LOADVARSMALL+4},
{"loadvs  ",I_LOADVARSMALL+5},
{"loadvs  ",I_LOADVARSMALL+6},
{"loadvs  ",I_LOADVARSMALL+7},
{"loadvs  ",I_LOADVARSMALL+8},
{"loadvs  ",I_LOADVARSMALL+9},
{"loadvs  ",I_LOADVARSMALL+10},
{"loadvs  ",I_LOADVARSMALL+11},
{"loadvs  ",I_LOADVARSMALL+12},
{"loadvs  ",I_LOADVARSMALL+13},
{"loadvs  ",I_LOADVARSMALL+14},
{"loadvs  ",I_LOADVARSMALL+15},

{"loadv   ",I_LOADVAR},
{"loadm   ",I_LOADMEM},
{"loadvi  ",I_LOADVARIND},
{"loadmi  ",I_LOADMEMIND},

{"loadptr ",I_LOADPTR},

{"add     ",I_ADD},
{"sub     ",I_SUB},
{"mul     ",I_MUL},
{"div     ",I_DIV},
{"mod     ",I_MOD},
{"neg     ",I_NEG},
{"2compl  ",I_2COMPL},
{"shiftl  ",I_SHIFTL},
{"shiftr  ",I_SHIFTR},
{"and     ",I_AND},
{"or      ",I_OR},
{"eor     ",I_EOR},

{"iseq    ",I_ISEQ},
{"isne    ",I_ISNE},
{"islt    ",I_ISLT},
{"isgt    ",I_ISGT},
{"islte   ",I_ISLTE},
{"isgte   ",I_ISGTE},

{"jump    ",I_JUMP},
{"jsr     ",I_JUMPSUB},
{"jtrue   ",I_JUMPTRUE},
{"jfalse  ",I_JUMPFALSE},

{"jumpl   ",I_JUMPL},
{"jsrl    ",I_JUMPSUBL},
{"jtruel  ",I_JUMPTRUEL},
{"jfalsel ",I_JUMPFALSEL},

{"ext     ",I_EXTERNCALL},
{"exta    ",I_EXTERNCALL+1},
{"extx    ",I_EXTERNCALL+2},
{"extax   ",I_EXTERNCALL+3},
{"exty    ",I_EXTERNCALL+4},
{"extay   ",I_EXTERNCALL+5},
{"extxy   ",I_EXTERNCALL+6},
{"extaxy  ",I_EXTERNCALL+7},
{"return  ",I_RETURN},
{"stop    ",I_STOP},

{"end     ",0x100}};

void yyerror(char *str);

void beginpass(treenode *tree, int p)
{
  pass = p;
  tl = 0;
  pc = 0;
  in = 0;
  if (debug) printf("\nPass %d started\n\n", p);
  walktree(tree, M_NONE, NULL, NULL);
}

void compile(treenode *tree)
{
  int c;
  for (c = 0; c < MAX_CHUNKS; c++) chunkin[c] = -1;

  varstart = vars;
  varend = vars+varsize;

  /* Reserved symbols */
  newsymbol("ptr", S_PTR);
  newsymbol("a", vars+FIRSTVARIABLE);
  newsymbol("x", vars+FIRSTVARIABLE+1);
  newsymbol("y", vars+FIRSTVARIABLE+2);
  newsymbol("flags", vars+FIRSTVARIABLE+3);
  newsymbol("act", vars+FIRSTVARIABLE+4);
  vars += 5;

  readexterns();

  instr = malloc(MAX_INSTR * sizeof(imcode));
  beginpass(tree, 1);
  if (errors) return;
  beginpass(tree, 2);
  if (errors) return;
  beginpass(tree, 3);
  if (errors) return;
  if (!in)
  {
    yyerror("script contains no instructions");
    return;
  }
  instr[in-1].next = 0; /* Mark last instruction */
  if (debug) printf("Optimizing addressing\n");
  optimizeaddressing();
  if (debug) printf("Optimizing\n");
  optimize();
  if (debug) printf("Optimizing jumps\n");
  optimizejumps();
  if (debug) printf("Setting instruction locations\n");
  setinstrpcs();
  if (errors) return;
  if (debug) printf("Setting data references\n");
  datareferences();
  if (errors) return;
  printf("Bytecode size %d bytes\n", pc);
  if (header)
  {
    if (!onefile)
    {
      yyerror("-o (one-file output) required for generating chunk-datafiles");
      return;
    }
    fputc(maxchunknum+1, yyout); /* Object count */
    fputc((pc+(maxchunknum+1)*2) >> 8, yyout); /* Chunk datasize highbyte */
    fputc((pc+(maxchunknum+1)*2) & 0xff, yyout); /* Chunk datasize lowbyte */

    if (maxchunknum >= 0)
    {
    for (c = 0; c <= maxchunknum; c++)
    {
      if (chunkin[c] == -1)
      {
        yyerror("all chunks from 0 to n not defined");
      }
      else
      {
        int address;

        address = instr[chunkin[c]].pc + (maxchunknum+1)*2;
        fputc(address & 0xff, yyout);
        fputc(address >> 8, yyout);
      }
    }
    }
  }

  generatecode();
}

void readexterns(void)
{
  /* Parse the extern definition file */
  if (yyextern)
  {
    char buf[80];
    char name[80];
    int address;

    while (fgets(buf, 80, yyextern))
    {
      sscanf(buf, "%s = $%x", name, &address);
      if ((!noconstants) && (isupper(name[0])) && (address < 256))
      {
        newsymbol(name, address);
      }
      newextern(name, address);
    }
    fclose(yyextern);
  }
}

void eatopcode(void)
{
  if (debug) printf("%d. opcode %s eaten\n", in, findopcodename(instr[in].opcode));
  instr[in].opcode = I_DUMMY;
  instr[in].length = 0;
  in = instr[in].next;
  instr[in].pc = pc;
}

char *findopcodename(int opcode)
{
  int c = 0;
  while (optbl[c].opcode != 0x100)
  {
    if (optbl[c].opcode == opcode) return optbl[c].name;
    c++;
  }
  return ("unknown ");
}

void opennewpage(void)
{
  char buf[80];
  char buf2[80];
  unsigned c;

  if (onefile) return;

  bytes = 0;
  strcpy(buf, srcname);
  for (c = 0; c < strlen(buf); c++)
  {
    if (buf[c] == '.')
    {
      buf[c+1] = 0;
      break;
    }
  }
  strcpy(buf2, buf);
  sprintf(buf, "%03x", pages);
  strcat(buf2, buf);
  yyout = fopen(buf2, "wb");
  if (!yyout)
  {
    yyerror("couldn't open destination file");
    return;
  }
  else
  {
    printf("Page %d written to file %s\n", pages, buf2);
  }
  pages++;
}

void emitbyte(unsigned char b)
{
  if (yyout)
  {
    fputc(b, yyout);
    bytes++;
    if ((bytes >= pagesize) && (!onefile))
    {
      fclose(yyout);
      opennewpage();
    }
  }
}

void generatecode(void)
{
  int databytes = 16;

  if (yyasm)
  {
    int prevpage = -1;
    tablenode *ptr = symboltable;
    functnode *ptr2 = functtable;
    fprintf(yyasm, "Label summary (script address map)\n"
                   "----------------------------------\n");
    while (ptr)
    {
      if ((ptr->value >= FIRSTLABEL) && (ptr->value < S_HACK))
      {
        int address = instr[ptr->value - FIRSTLABEL].pc;

        int page = address / pagesize;

        if (prevpage != page)
        {
          fprintf(yyasm, "\nPage %d (starting at $%06x)\n\n", page, page * pagesize);
          prevpage = page;
        }

        /* Don't display temp labels */
        if ((ptr->string[0] != '_') ||
           (ptr->string[1] != 't') ||
           (ptr->string[2] != 'l'))
        {
          fprintf(yyasm, "%-26s $%06x\n", ptr->string, address);
        }
      }
      ptr = ptr->next;
      if (!ptr) break;
    }
    fprintf(yyasm, "\n");

    fprintf(yyasm, "Variable summary (C64 address map)\n"
                   "----------------------------------\n\n");
    ptr = symboltable;
    while (ptr)
    {
      if ((ptr->value >= FIRSTVARIABLE) && (ptr->value < FIRSTLABEL))
      {
        int address = ptr->value - FIRSTVARIABLE;

        fprintf(yyasm, "%-28s $%04x\n", ptr->string, address);
      }
      ptr = ptr->next;
    }
    fprintf(yyasm, "\n");

    fprintf(yyasm, "External function summary\n"
                   "-------------------------\n\n");
    while (ptr2)
    {
      if (ptr2->value >= 0)
      {
        fprintf(yyasm, "%-28s $%04x\n", ptr2->string, ptr2->value);
      }
      ptr2 = ptr2->next;
    }
    fprintf(yyasm, "\n");

  }

  if (yyasm) fprintf(yyasm, "VM assembly output\n"
                            "------------------\n");
  opennewpage();
  in = 0;

  for (;;)
  {
    int c;

    if (instr[in].length)
    {
      switch(instr[in].opcode)
      {
        default:
        databytes = 16;
        emitbyte(instr[in].opcode);
        switch(instr[in].opcode & 0xf0)
        {
          default:
          if (yyasm) fprintf(yyasm, "\n$%06x %s", instr[in].pc, findopcodename(instr[in].opcode));
          break;

          case I_LOADVARSMALL:
          case I_PUSHIMMSMALL:
          if (yyasm) fprintf(yyasm, "\n$%06x %s$%02x ", instr[in].pc, findopcodename(instr[in].opcode), instr[in].opcode & 0xf);
          break;
        }
        for (c = 0; c < instr[in].length-1; c++)
        {
          emitbyte(instr[in].operand[c]);
          if (yyasm) fprintf(yyasm, "$%02x ", instr[in].operand[c]);
        }
        if (yyasm)
        {
          switch(instr[in].opcode)
          {
            case I_JUMP:
            case I_JUMPSUB:
            case I_JUMPFALSE:
            case I_JUMPTRUE:
            if (instr[in].operand[0] < 0x80)
            {
              fprintf(yyasm, "($%06x)", instr[in].operand[0]+(instr[in].pc+1));
            }
            else
            {
              fprintf(yyasm, "($%06x)", instr[in].operand[0]-0x100+(instr[in].pc+1));
            }
            break;

            case I_JUMPL:
            case I_JUMPSUBL:
            case I_JUMPFALSEL:
            case I_JUMPTRUEL:
            case I_LOADPTR:
            fprintf(yyasm, "$%02x ", instr[in].opcode & 0x0f);
            break;
          }
        }
        break;

        case I_DATA:
        if (yyasm)
        {
          if (databytes >= 16)
          {
            databytes = 0;
          }
          if (!databytes) fprintf(yyasm, "\n$%06x $%02x", instr[in].pc, instr[in].operand[0]);
          else fprintf(yyasm, " $%02x", instr[in].operand[0]);
          databytes++;
        }
        emitbyte(instr[in].operand[0]);
        break;

        case I_PTR:
        for (c = 0; c < instr[in].length; c++)
        {
          if (yyasm)
          {
            if (!c)
            {
              fprintf(yyasm, "\n$%06x $%02x", instr[in].pc+c, instr[in].operand[c]);
            }
            else
            fprintf(yyasm, " $%02x", instr[in].operand[c]);
          }
          emitbyte(instr[in].operand[c]);
        }
        break;
      }
    }
    in = instr[in].next;
    if (!in) break;
  }
  fclose(yyout);
  if (yyasm) fclose(yyasm);
}

void datareferences(void)
{
  in = 0;

  for (;;)
  {
    if (instr[in].target != -1)
    {
      if (instr[in].length == 2)
      {
        if (debug) printf("Rel. memory reference from %d to %d\n", instr[in].pc, instr[instr[in].target-FIRSTLABEL].pc);

        instr[in].operand[0] = instr[instr[in].target-FIRSTLABEL].pc - (instr[in].pc+1);
      }
      else
      {
        int base = instr[in].operand[0] | (instr[in].operand[1]<<8) | (instr[in].operand[2]<<16);
        base += instr[instr[in].target-FIRSTLABEL].pc;

        if (debug) printf("Memory reference to %d\n", base);

        switch(instr[in].opcode)
        {
          case I_LOADPTR:
          case I_JUMPL:
          case I_JUMPSUBL:
          case I_JUMPFALSEL:
          case I_JUMPTRUEL:
          instr[in].operand[0] = base & 0xff;
          instr[in].operand[1] = base >> 8;
          instr[in].opcode |= (base >> 16) & 0xf;
          break;

          default:
          instr[in].operand[0] = base & 0xff;
          instr[in].operand[1] = base >> 8;
          instr[in].operand[2] = base >> 16;
          break;
        }
      }
    }

    in = instr[in].next;
    if (!in) break;
  }
}

void optimizeaddressing(void)
{
  pc = 0;
  in = 0;
  previn = -1;

  for (;;)
  {
    switch(instr[in].opcode & 0xf0)
    {
      case I_PUSH:
      case I_STORE:
      case I_LOAD:
      case I_INC:
      case I_DEC:
      {
        unsigned char addressing = instr[in].opcode & 15;
        int address;

        switch (addressing)
        {
          /* Convert memory addressing to variable addressing if applicable */
          case A_MEM:
          case A_MEMIND:
          address = instr[in].operand[0] | (instr[in].operand[1]<<8);
          if ((address >= varstart) && (address < varstart + 0x100))
          {
            instr[in].opcode -= 2;
            instr[in].operand[0] = address - varstart;
            instr[in].length = 2;
            if (debug) printf("%d. mem access converted to var\n", in);
          }
          break;
        }
      }
      break;
    }
    instr[in].pc = pc;
    pc += instr[in].length;
    previn = in;
    in = instr[in].next;
    if (!in) break;
  }
}

void optimize(void)
{
  pc = 0;
  in = 0;
  previn = -1;

  for (;;)
  {
    instr[in].pc = pc;
    switch(instr[in].opcode & 0xf0)
    {
      case I_PUSHIMMSMALL:
      if (instr[in].next)
      {
        if (instr[instr[in].next].opcode == I_STOREVAR)
        {
          unsigned char value = instr[in].opcode & 15;
          eatopcode();
          instr[in].opcode = I_LOADVARSMALL | value;
          instr[in].length = 2;
          if (debug) printf("%d. push+store converted to load\n", in);
        }
        else
        {
          if ((instr[instr[in].next].opcode & 0xf0) == I_STORE)
          {
            unsigned char addressing = instr[instr[in].next].opcode & 15;
            unsigned char value = instr[in].operand[0];
            eatopcode();
            instr[in].opcode = I_LOAD + addressing;
            instr[in].length++;
            instr[in].operand[4] = instr[in].operand[3];
            instr[in].operand[3] = instr[in].operand[2];
            instr[in].operand[2] = instr[in].operand[1];
            instr[in].operand[1] = instr[in].operand[0];
            instr[in].operand[0] = value;
            if (debug) printf("%d. push+store converted to load\n", in);
          }
        }

      }
      break;
    }
    switch(instr[in].opcode)
    {
      case I_NEG:
      if (instr[in].next)
      {
        if (instr[instr[in].next].opcode == I_NEG)
        {
          eatopcode();
          eatopcode();
        }
      }
      break;

      case I_2COMPL:
      if (instr[in].next)
      {
        if (instr[instr[in].next].opcode == I_2COMPL)
        {
          eatopcode();
          eatopcode();
        }
      }
      break;

      case I_PUSHIMM:
      if (instr[in].next)
      {
        if ((instr[instr[in].next].opcode & 0xf0) == I_STORE)
        {
          unsigned char addressing = instr[instr[in].next].opcode & 15;
          unsigned char value = instr[in].operand[0];
          eatopcode();
          instr[in].opcode = I_LOAD + addressing;
          instr[in].length++;
          instr[in].operand[4] = instr[in].operand[3];
          instr[in].operand[3] = instr[in].operand[2];
          instr[in].operand[2] = instr[in].operand[1];
          instr[in].operand[1] = instr[in].operand[0];
          instr[in].operand[0] = value;
          if (debug) printf("%d. push+store converted to load\n", in);
        }
      }
      break;
    }
    pc += instr[in].length;

    previn = in;
    in = instr[in].next;
    if (!in) break;
  }
}

void optimizejumps(void)
{
  in = 0;
  previn = -1;

  for (;;)
  {
    switch(instr[in].opcode)
    {
      case I_LOADPTR:
      case I_PTR:
      instr[in].length--;
      break;

      case I_JUMPL:
      case I_JUMPSUBL:
      case I_JUMPTRUEL:
      case I_JUMPFALSEL:
      {
        int target = instr[in].target-FIRSTLABEL;
        int distance = (instr[in].pc+1) - instr[target].pc;

        if ((distance >= -128) && (distance <= 127))
        {
          if (debug) printf("%d. jump converted to short\n", in);
          if (instr[in].opcode == I_JUMPL) instr[in].opcode = I_JUMP;
          if (instr[in].opcode == I_JUMPSUBL) instr[in].opcode = I_JUMPSUB;
          if (instr[in].opcode == I_JUMPTRUEL) instr[in].opcode = I_JUMPTRUE;
          if (instr[in].opcode == I_JUMPFALSEL) instr[in].opcode = I_JUMPFALSE;
          instr[in].length = 2;
        }
        else
        {
          instr[in].length = 3;
        }
      }
      break;
    }

    previn = in;
    in = instr[in].next;
    if (!in)
      break;
  }
}

void setinstrpcs(void)
{
  pc = 0;
  in = 0;
  previn = -1;

  for (;;)
  {
    instr[in].pc = pc;
    pc += instr[in].length;

    previn = in;
    in = instr[in].next;
    if (!in)
      break;
  }
}


void outputinstr(unsigned char byte, int target)
{
  lastopcode = byte;
  if (pass > 2)
  {
    instr[in].opcode = byte;
    instr[in].length = 1;
    instr[in].target = target;
    instr[in].next = in+1;
    instr[in].pc = pc;
    pc += instr[in].length;
    in++;
  }
  else in++;
}

void outputinstr1(unsigned char byte, unsigned char op1, int target)
{
  lastopcode = byte;
  if (pass > 2)
  {
    instr[in].opcode = byte;
    instr[in].operand[0] = op1;
    if (byte == I_DATA)
    {
      instr[in].length = 1;
      instr[in].target = -1;
    }
    else
    {
      if ((byte == I_PUSHIMM) && (op1 < 16))
      {
        instr[in].opcode = I_PUSHIMMSMALL | op1;
        instr[in].length = 1;
        instr[in].target = target;
      }
      else
      {
        instr[in].length = 2;
        instr[in].target = target;
      }
    }
    instr[in].next = in+1;
    instr[in].pc = pc;
    pc += instr[in].length;
    in++;
  }
  else in++;
}

void outputinstr2(unsigned char byte, unsigned char op1, unsigned char op2, int target)
{
  lastopcode = byte;
  if (pass > 2)
  {
    instr[in].opcode = byte;
    instr[in].operand[0] = op1;
    instr[in].operand[1] = op2;
    instr[in].length = 3;
    instr[in].target = target;
    instr[in].next = in+1;
    instr[in].pc = pc;
    pc += instr[in].length;
    in++;
  }
  else in++;
}

void outputinstr3(unsigned char byte, unsigned char op1, unsigned char op2, unsigned char op3, int target)
{
  lastopcode = byte;
  if (pass > 2)
  {
    instr[in].opcode = byte;
    instr[in].operand[0] = op1;
    instr[in].operand[1] = op2;
    instr[in].operand[2] = op3;
    instr[in].length = 4;
    instr[in].target = target;
    instr[in].next = in+1;
    instr[in].pc = pc;
    pc += instr[in].length;
    in++;
  }
  else in++;
}

void outputinstr4(unsigned char byte, unsigned char op1, unsigned char op2, unsigned char op3, unsigned char op4, int target)
{
  lastopcode = byte;
  if (pass > 2)
  {
    instr[in].opcode = byte;
    instr[in].operand[0] = op1;
    instr[in].operand[1] = op2;
    instr[in].operand[2] = op3;
    instr[in].operand[3] = op4;
    instr[in].length = 5;
    instr[in].target = target;
    instr[in].next = in+1;
    instr[in].pc = pc;
    pc += instr[in].length;
    in++;
  }
  else in++;
}

void outputinstr5(unsigned char byte, unsigned char op1, unsigned char op2, unsigned char op3, unsigned char op4, unsigned char op5, int target)
{
  lastopcode = byte;
  if (pass > 2)
  {
    instr[in].opcode = byte;
    instr[in].operand[0] = op1;
    instr[in].operand[1] = op2;
    instr[in].operand[2] = op3;
    instr[in].operand[3] = op4;
    instr[in].operand[4] = op5;
    instr[in].length = 6;
    instr[in].target = target;
    instr[in].next = in+1;
    instr[in].pc = pc;
    pc += instr[in].length;
    in++;
  }
  else in++;
}

void templabel(char *temp)
{
  sprintf(temp, "_tl%06x", tl);
  tl++;
}

void makelabel(char *label)
{
  if (pass == 2)
  {
    /* Mark labels within script code with values 512+ */
    newsymbol(label, in+FIRSTLABEL);
    labels++;
  }
}

int getvaraddr(char *label)
{
  if (pass > 2)
  {
    int num = findsymbol(label);
    if (num == -1)
    {
      char textbuf[80];
      sprintf(textbuf, "unresolved symbol %s", label);
      /* Hack to prevent error appearing twice */
      newsymbol(label, S_HACK);
      yyerror(textbuf);
    }
    return num - FIRSTVARIABLE;
  }
  return 0;
}

int isconstant(char *label)
{
  int num = findsymbol(label);

  if ((num >= 0) && (num < FIRSTVARIABLE)) return 1;
  else return 0;
}

int isdata(char *label)
{
  int num = findsymbol(label);

  if (num >= FIRSTLABEL) return 1;
  else return 0;
}

int findlabel(char *label)
{
  if (pass > 2)
  {
    int num = findsymbol(label);
    if (num == -1)
    {
      char buf[80];
      sprintf(buf, "unresolved symbol %s", label);
      yyerror(buf);
    }
    return num;
  }
  return -1;
}
