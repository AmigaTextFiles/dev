struct ACode{char *Opcode;
						 char *Operand;
						 char *Code;
						 char *Flag;
						};

struct DStack{ struct DStack *Last;
							 char *Data;
							 FILE *Handle;
							 long Line;
};

struct Labels{
               struct Labels *Last;
               char *Label;
               int  Address;
               char Flag;
               char *Macro;
};
