/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _Int.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/* 		Int.cc			 */

/**************************************************************************
	Aufbau der Int arithmetic in C++,

	RD, IWR Uni Heidelberg, 14.12.90
*****************************************************************************/


#include <LEDA/Int0.h>
#include <ctype.h>


ostream& operator<<(ostream &out, const Int &a)
	{ 	int l=Ilog(a)+1;
		char *s=new char[l/3+2];
		Itoa(a, s);
		out<<s;
		delete s;
		return out;
	}

istream& operator>>(istream &in, Int &a)
	{	char s[IN_INT_BUF_LENGTH];
                char* p = s;
                char c;
                do {
                  in.get(c);
                  if ((c == '+') || (c == '-')) { *p++ = c; }
                } while (isspace(c) || (c == '+') || (c == '-'));
                if (!isdigit(c)) { error_handler(1,"digit expected"); }
                while (isdigit(c)) {
                  *p++ = c;
                  in.get(c);
                }
                in.putback(c);
                *p = '\0';
		atoI(s, a);
		return in;
	}

