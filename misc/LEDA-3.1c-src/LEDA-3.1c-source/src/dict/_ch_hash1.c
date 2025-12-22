/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _ch_hash1.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/impl/ch_hash1.h>

//------------------------------------------------------------------------------
//
//  hashing with chaining and table doubling
//
//  S. Naeher (1994)
//
//------------------------------------------------------------------------------


ch_hash1_elem ch_hash1::STOP;

#define NIL  GenPtr(this)

int ch_hash1::next_pow(int x) const
{ // return next power of 2
  int result = 1;    
  while ((x>>=1) > 0) result <<= 1;
  return result;
 }
 

ch_hash1_item ch_hash1::lookup(GenPtr x) const
{ register ch_hash1_item q = table;

  STOP.k = x;

  if (int_type())
  { q += (int(x) & table_size_1);  // table_size = power of 2
    while (q->k != x) q = q->succ;
   }
  else
  { q += (hash_fct(x) & table_size_1);
    while (cmp(q->k,x)) q = q->succ;
   }

  return (q == &STOP) ? 0 : q;
}


void ch_hash1::change_inf(ch_hash1_item p, GenPtr x)
{ clear_inf(p->i);
  p->i = x;
  copy_inf(p->i);
 }

void ch_hash1::del(GenPtr x)
{ 
  ch_hash1_item p = table + (int(x) & table_size_1);

  if (p->k == x)
  { clear_key(p->k);
    clear_inf(p->i);
    p->k = NIL;
    count--;
    if (count == low_table) rehash(low_table);
    return;
  }

  STOP.k = x;

  if (int_type())
     while (p->succ->k != x) p = p->succ;
  else
     while (cmp(p->succ->k,x)) p = p->succ;

  ch_hash1_item q = p->succ;

  if (q==&STOP) return;

  clear_key(q->k);
  clear_inf(q->i);

  p->succ = q->succ;
  delete q;
  count--;
  if (count == low_table) rehash(low_table);
 }


void ch_hash1::del_item(ch_hash1_item q)
{ register ch_hash1_item p = table + (hash_fct(q->k) & table_size_1);
  clear_key(q->k);
  clear_inf(q->i);
  if (p==q) 
     p->k = NIL;
  else
    { while(p->succ != q) p = p->succ;
      p->succ = q->succ;
      delete q;
     }
  count--;
  if (count == low_table) rehash(low_table);
 }
  
  
  

ch_hash1_item ch_hash1::insert(GenPtr x, GenPtr y)
{ 
  ch_hash1_item p = table + (int(x) & table_size_1);
  ch_hash1_item q = p;

  STOP.k = x;

  if (int_type())
     while (p->k != x) p = p->succ;
  else
     while (cmp(p->k,x)) p = p->succ;

  if (p != &STOP)
  { clear_inf(p->i);
    p->i = y;
    copy_inf(p->i);
    return p;
   }

  count++;
  copy_key(x);
  copy_inf(y);

  if (q->k == NIL) 
    { q->k = x;
      q->i = y;
     }
  else
    { q->succ = new ch_hash1_elem(x,y,q->succ);
      q = q->succ;
     }

  if (count == high_table) rehash(high_table);

  return q;
}



void ch_hash1::destroy()
{ 
  for(int i=0; i < table_size; i++) 
  { ch_hash1_item p = table[i].succ;
    ch_hash1_item q = p;
    while (p != &STOP)
    { clear_key(p->k);
      clear_inf(p->i);
      q = p;
      p = p->succ;
      delete q;
    }
   }
  //delete[] table;
  free(table);
}


void ch_hash1::init(int T)
{ 
  register ch_hash1_item p;
  register ch_hash1_item stop;

  table_size = T;
  table_size_1 = T-1;

  low_table  = (T > 1024) ? T/2 : -1;
  high_table = 2*T;

  //table = new ch_hash1_elem[table_size];
  table = (ch_hash1_elem*)malloc(table_size*sizeof(ch_hash1_elem));

  stop = table + table_size;
  for(p=table; p<stop; p++) 
  { p->succ = &STOP;
    p->k = NIL;
  }

  count = 0;
}


void ch_hash1::rehash(int T)
{ 

  register ch_hash1_item p;
  register ch_hash1_item q;
  register ch_hash1_item r;
  int i;

  ch_hash1_item old_table = table;
  int old_table_size = table_size;
  int old_count = count;

  init(T);

  if (int_type())
     for (i=0; i<old_table_size; i++)
     { p = old_table[i].succ;
       while(p != &STOP)
       { r = p->succ;
         q = table + (int(p->k) & table_size_1);
         p->succ = q->succ;
         q->succ = p;
         p = r;
        }
      }
  else
     for (i=0; i<old_table_size; i++)
     { p = old_table[i].succ;
       while(p != &STOP)
       { r = p->succ;
         q = table + (hash_fct(p->k) & table_size_1);
         p->succ = q->succ;
         q->succ = p;
         p = r;
        }
      }

  ch_hash1_item stop = old_table+old_table_size;
  for (p=old_table; p<stop; p++)
    if (p->k != NIL) 
    {  q = table + (int(p->k) & table_size_1);
       if (q->k == NIL)
        { q->k = p->k;
          q->i = p->i;
         }
       else
         q->succ = new ch_hash1_elem(p->k,p->i,q->succ);
    }
   
  count = old_count;

  //delete[] old_table;
  free(old_table);
}


ch_hash1::ch_hash1(const ch_hash1& D)
{ ch_hash1_item p;
  init(D.table_size);
  for (int i=0; i<table_size; i++)
  { p = D.table[i].succ;
    while(p != &(D.STOP))
    { insert(p->k,p->i);
      D.copy_key(p->k);
      D.copy_inf(p->i);
      p = p->succ;
    }
  }
}


ch_hash1& ch_hash1::operator=(const ch_hash1& D)
{ ch_hash1_item p;
  clear();
  for (int i=0; i<D.table_size; i++)
  { p = D.table[i].succ;
    while(p != &(D.STOP))
    { insert(p->k,p->i);
      p = p->succ;
     }
   }
  return *this;
}

