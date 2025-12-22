#define MAX_CHUNKS 128

#define FIRSTCONSTANT 0
#define FIRSTVARIABLE 0x100
#define FIRSTLABEL 0x10100
#define S_HACK 0x7ffffffe
#define S_PTR 0x7fffffff

#define MAX_INSTR 16*65536

typedef struct
{
  unsigned char opcode;
  unsigned char operand[4];
  int pc;
  int length;
  int target;
  int next;
} imcode;

typedef struct
{
  char *name;
  int opcode;
} opcodename;

void outputinstr(unsigned char byte, int target);
void outputinstr1(unsigned char byte, unsigned char op1, int target);
void outputinstr2(unsigned char byte, unsigned char op1, unsigned char op2, int target);
void outputinstr3(unsigned char byte, unsigned char op1, unsigned char op2, unsigned char op3, int target);
void outputinstr4(unsigned char byte, unsigned char op1, unsigned char op2, unsigned char op3, unsigned char op4, int target);
void outputinstr5(unsigned char byte, unsigned char op1, unsigned char op2, unsigned char op3, unsigned char op4, unsigned char op5, int target);
void compile(treenode *tree);
void beginpass(treenode *tree, int p);
void makelabel(char *label);
int findlabel(char *label);
int findextern(char *label);
int getvaraddr(char *label);
char *findopcodename(int opcode);
int isconstant(char *label);
int isdata(char *label);
void templabel(char *temp);
void datareferences(void);
void optimize(void);
void optimizeaddressing(void);
void optimizejumps(void);
void setinstrpcs(void);
void generatecode(void);
void opennewpage(void);
void emitbyte(unsigned char b);
void readexterns(void);

