/* plunge.c */
extern int skim(char *opstr, void (*testfunc)(), int dropval, int endval, int (*heir)(), LVALUE *lval);
extern void dropout(int k, void (*testfunc)(void), int exit1, LVALUE *lval);
extern int plnge1(int (*heir)(), LVALUE *lval);
extern void plnge2a(int (*heir)(), LVALUE *lval, LVALUE *lval2, void (*oper)(void), void (*uoper)(void), void (*doper)(void));
extern void plnge2b(int (*heir)(), LVALUE *lval, LVALUE *lval2, void (*oper)(void), void (*doper)(void));
