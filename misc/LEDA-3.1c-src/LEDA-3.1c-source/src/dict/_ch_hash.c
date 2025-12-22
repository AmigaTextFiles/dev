/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _ch_hash.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/impl/ch_hash.h>

//------------------------------------------------------------------------------
//
//  hashing with chaining
//
//  S. Naeher (1994)
//
//------------------------------------------------------------------------------


ch_hash_elem ch_hash::STOP;


int ch_hash::next_pow(int x) const
{ // return next power of 2
  int result = 1;    
  while ((x>>=1) > 0) result <<= 1;
  return result;
 }
 

ch_hash_item ch_hash::search(GenPtr x, ch_hash_item& pred) const
{ register ch_hash_item p;

  STOP.k = x;

  if (int_type())
  { p = table + (int(x) & table_size_1);  // table_size = power of 2
    while (p->succ->k != x) p = p->succ;
   }
  else
  { p = table + (hash_fct(x) & table_size_1);
    while (cmp(p->succ->k,x) != 0) p = p->succ;
   }

  pred = p;

  return p->succ;
}


ch_hash_item ch_hash::lookup(GenPtr x) const
{ register ch_hash_item q;

  STOP.k = x;

  if (int_type())
  { q = table[int(x) & table_size_1].succ;  // table_size = power of 2
    while (q->k != x) q = q->succ;
   }
  else
  { q = table[hash_fct(x) & table_size_1].succ;
    while (cmp(q->k,x)) q = q->succ;
   }

  return (q == &STOP) ? 0 : q;
}


void ch_hash::change_inf(ch_hash_item p, GenPtr x)
{ clear_inf(p->i);
  p->i = x;
  copy_inf(p->i);
 }

void ch_hash::del(GenPtr x)
{ ch_hash_item p;
  ch_hash_item q = search(x,p);

  if (q==&STOP) return;

  clear_key(q->k);
  clear_inf(q->i);

  p->succ = q->succ;
  delete q;
  count--;
  if (count == low_table) rehash(low_table);
 }


void ch_hash::del_item(ch_hash_item q)
{ register ch_hash_item p = table + (hash_fct(q->k) & table_size_1);
  while(p->succ != q) p = p->succ;
  clear_key(q->k);
  clear_inf(q->i);
  p->succ = q->succ;
  delete q;
  count--;
  if (count == low_table) rehash(low_table);
 }
  
  
  

ch_hash_item ch_hash::insert(GenPtr x, GenPtr y)
{ ch_hash_item p;
  ch_hash_item q = search(x,p);

  if (q != &STOP)
  { clear_inf(q->i);
    q->i = y;
    copy_inf(q->i);
    return q;
   }

   copy_key(x);
   copy_inf(y);

   q = new ch_hash_elem(x,y,&STOP);
   q->succ = &STOP;
   p->succ = q;

   count++;

   if (count == high_table) rehash(high_table);

   return q;

}



void ch_hash::destroy()
{ 
  for(int i=0; i < table_size; i++) 
  { ch_hash_item p = table[i].succ;
    ch_hash_item q = p;
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


void ch_hash::init(int T)
{ register int i;

  table_size   = T;
  table_size_1 = T-1;

  low_table  = (table_size > 1024) ? table_size >> 1 : -1;
  high_table = table_size << 1;


  //table = new ch_hash_elem[table_size];
  table = (ch_hash_elem*)malloc(table_size*sizeof(ch_hash_elem));

  for(i=0; i<table_size; i++) table[i].succ = &STOP;

  count = 0;
}


void ch_hash::rehash(int T)
{ 
  if (T == table_size) return;

  register ch_hash_item p;
  register ch_hash_item q;
  register ch_hash_item r;

  ch_hash_item old_table = table;
  int old_table_size = table_size;
  int old_count = count;

  init(T);

  if (int_type())
   { for (int i=0; i<old_table_size; i++)
     { p = old_table[i].succ;
       while(p != &STOP)
       { r = p->succ;
         q = table + (int(p->k) & table_size_1);
         p->succ = q->succ;
         q->succ = p;
         p = r;
        }
      }
    }
  else
   { for (int i=0; i<old_table_size; i++)
     { p = old_table[i].succ;
       while(p != &STOP)
       { r = p->succ;
         q = table + (hash_fct(p->k) & table_size_1);
         p->succ = q->succ;
         q->succ = p;
         p = r;
        }
      }
    }

  count = old_count;

  //delete[] old_table;
  free(old_table);
}


ch_hash::ch_hash(const ch_hash& D)
{ ch_hash_item p;
  init(D.table_size);
  for (int i=0; i<table_size; i++)
  { p = D.table[i].succ;
    while(p != &STOP)
    { insert(p->k,p->i);
      D.copy_key(p->k);
      D.copy_inf(p->i);
      p = p->succ;
    }
  }
}


ch_hash& ch_hash::operator=(const ch_hash& D)
{ ch_hash_item p;
  clear();
  for (int i=0; i<D.table_size; i++)
  { p = D.table[i].succ;
    while(p != &STOP)
    { insert(p->k,p->i);
      p = p->succ;
     }
   }
  return *this;
}

