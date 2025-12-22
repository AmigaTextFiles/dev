/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _ch_array.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/impl/ch_array.h>

//------------------------------------------------------------------------------
//
//  hashing array with chaining and table doubling
//
//  only integer/pointer keys
//  no delete operation
//
//  S. Naeher (1994)
//
//------------------------------------------------------------------------------


ch_array_elem ch_array::STOP;

#define NIL  GenPtr(this)

/* #define HASH(x) (table + (int(x) & table_size_1)) */

#define HASH(x) (table + ((int(x)>>shift) & table_size_1))


ch_array::ch_array(GenPtr i, int s, int n) 
{ init_val = i; 
  shift = 0;
  while (s/=2) shift++;
  int ts = 1;
  while (n/=2) ts *= 2;
  if (ts < 512) ts = 512;
  init_table(ts); 
}



GenPtr ch_array::lookup(GenPtr x) const
{ ch_array_item p = HASH(x);
  STOP.k = x;
  while (p->k != x) p = p->succ;
  return (p == &STOP) ? nil : p;
}


GenPtr ch_array::access(GenPtr x) const
{ ch_array_item p = HASH(x);
  STOP.k = x;
  while (p->k != x) p = p->succ;

  return (p == &STOP) ? init_val : p->i;
}


GenPtr& ch_array::access(GenPtr x)
{ ch_array_item p = HASH(x);

  if (p->k == x) return p->i;

  if (p->k == NIL)
    { p->k = x;
      p->i = init_val;
      copy_inf(p->i);
      return p->i;
     }


  STOP.k = x;
  ch_array_item q = p->succ; 
  while (q->k != x) q = q->succ;
  if (q != &STOP) return q->i;

  if (free == table_end) 
  { rehash();
    p = HASH(x);
   }

  free->k = x;
  free->i = init_val;
  copy_inf(free->i);
  free->succ = p->succ;
  p->succ = free++;

  return p->succ->i;
}




void ch_array::destroy() 
{ ch_array_item p;
  for (int i=0; i<table_size; i++)
  { p = table+i;
    if (p->k != NIL) 
      while(p != &STOP)
      { clear_inf(p->i);
        p = p->succ;
       }
   }
  delete[] table; 
}


void ch_array::init_table(int T)
{ 
  table_size = T;
  table_size_1 = T-1;

  table = new ch_array_elem[2*T];

  free      = table + table_size;
  table_end = free + T;

  for(ch_array_item p=table; p<free; p++) 
  { p->k = NIL;
    p->succ = &STOP;
   }
}


#define INSERT(x,y)\
{ ch_array_item q = HASH(x);\
  if (q->k == NIL)\
    { q->k = x;\
      q->i = y;\
     }\
  else\
   { free->k = x;\
     free->i = y;\
     free->succ = q->succ;\
     q->succ = free++;\
   }\
}


void ch_array::rehash()
{ 
  ch_array_item old_table = table;
  ch_array_item old_table_end = table_end;
  ch_array_item stop = table+table_size;

  init_table(2*table_size);

  ch_array_item p = old_table;

  while (p < stop)
  { if (p->k != NIL) INSERT(p->k,p->i);
    p++;
   }

  while (p < old_table_end)
  { INSERT(p->k,p->i);
    p++;
   }

  delete[] old_table;
}


ch_array::ch_array(const ch_array& D)
{ ch_array_item p;
  init_table(D.table_size);
  init_val = D.init_val;
  for (int i=0; i<table_size; i++)
  { p = D.table[i].succ;
    while(p != &STOP)
    { INSERT(p->k,p->i);
      D.copy_inf(p->i);
      p = p->succ;
    }
  }
}


ch_array& ch_array::operator=(const ch_array& D)
{ destroy();
  init_table(D.table_size);
  init_val = D.init_val;
  for (int i=0; i<D.table_size; i++)
  { ch_array_item p = D.table + i;
    if (p->k != NIL)
     while(p != &STOP)
     { INSERT(p->k,p->i);
       copy_inf(p->i);
       p = p->succ;
      }
   }
  return *this;
}


void ch_array::print()
{ cout << "shift = " << shift << endl;
  for (int i=0; i<table_size; i++)
  { ch_array_item p = table + i;
    if (p->k != NIL)
    { int l = 0;
      while(p != &STOP)
      { l++; 
        p = p->succ;
       }
      cout << string("L(%d) = %d",i,l) << endl;
     }
   }
}
  
