/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _m_heap.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/impl/m_heap.h>

m_heap::m_heap(int m)
{ if (m<=0) error_handler(1,string("m_heap constructor: illegal size = %d",m));
  count = 0;
  start = 0;
  offset = 0;
  M = m+1;
  T = new list_item[M+1];
  for(int i=0; i<=M; i++) T[i] = L.append(GenPtr(MAXINT));
}

void m_heap::clear()
{ L.clear();
  for(int i=0; i<=M; i++) T[i] = L.append(GenPtr(MAXINT));
  count = 0;
  start = 0;
  offset = 0;
} 

m_heap_item m_heap::first_item() const
{ list_item it = L.first();
  while (it && L.inf(it) == GenPtr(MAXINT)) it = L.succ(it);
  return it;
 }
  
m_heap_item m_heap::next_item(m_heap_item it) const
{ it = L.succ(it);
  while (it && L.inf(it) == GenPtr(MAXINT)) it = L.succ(it);
  return it;
 }

m_heap_item m_heap::insert(GenPtr kk, GenPtr info)   // int key
{ int key = int(kk);
  int k;
  if (count)
   { find_min();
     k = key-offset; 
    }
  else 
   { start = key%M;
     k = 0;
     offset = key;
    }

  if (k<0 || k>=M) 
   error_handler(1,string("m_heap insert: illegal key %d \n",key));

  copy_inf(info);

  count++;
  return L.insert(info,T[(start+k)%M]); 
}

m_heap_item m_heap::find_min() const
{ if (count)
  { while (L.succ(T[start])==T[start+1])
    { (*(int*)&offset)++;
      (*(int*)&start)++;
      if (start == M) (*(int*)&start) = 0;
     }
    return L.succ(T[start]);
   }
 else return 0;
}

GenPtr m_heap::del_min()
{ if (count)
   { find_min();
     count--;
     m_heap_item p = L.succ(T[start]);
     GenPtr inf = L.contents(p);
     L.del(p);
     return inf;
    }
  else error_handler(1,"m_heap del_min: heap is empty");
  return 0;
}

void m_heap::del_item(m_heap_item it) 
{ GenPtr x = L.contents(it);
  clear_inf(x);
  L.del(it); 
  count--;
}

void m_heap::change_key(m_heap_item it, GenPtr kk)  // int key
{ int key = int(kk);
  find_min();
  GenPtr inf = L.contents(it);
  L.del(it); 
  int k = key - offset;
  if (k<0 || k>=M) 
   error_handler(1,string("m_heap change key: illegal key %d\n",key));
  L.insert(inf,T[(start+k)%M]);
}


void m_heap::print() const
{ m_heap_item p;
  cout << string("count = %d   start = %d   offset = %d\n",count,start,offset);
  for (int i=0;i<M;i++) 
  if (L.contents(L.succ(T[i])) != GenPtr(MAXINT))
  { cout << string("%3d: ",i);
    p = L.succ(T[i]);
    while (L.contents(p) != GenPtr(MAXINT))
     { cout << string("(%d) ",L.contents(p));
       p = L.succ(p);
      }
   cout << "\n";
   }
   cout << "\n";
}


