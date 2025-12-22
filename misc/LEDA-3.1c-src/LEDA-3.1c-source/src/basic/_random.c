/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _random.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#if defined(__MSDOS__) || defined(__ZTC__)
#include <stdlib.h>
inline int  random()  { return int(rand()); }
inline void srandom(int x) { srand(x); }
#else
extern "C" int random();
extern "C" void srandom(int);
#endif

int leda_random() { return random(); }
void leda_srandom(int s) { srandom(s); }
