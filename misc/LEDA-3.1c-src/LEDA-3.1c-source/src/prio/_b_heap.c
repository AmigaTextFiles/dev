/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _b_heap.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/impl/b_heap.h>

b_heap::b_heap(int a, int b) : T(a,b)
{ if (b<a) error_handler(1,"constructor: illegal size\n");
  low = a;
  high = b;
  min = high+1;
  max = low-1;
  int i;
  for(i=a;i<=b;i++) T[i] = new list<b_heap_item>;
}

void b_heap::clear()
{ int i;
  for (i=low;i<=high;i++) T[i]->clear();
  min = high+1;
  max = low-1;
} 

b_heap_item b_heap::insert(int key, GenPtr info) 
{ if (key<low || key>high) 
  error_handler(1,string("insert: illegal key %d\n",key));
  if (key<min) min = key;
  if (key>max) max = key;
  b_heap_item it = new  b_heap_node(key,info);
  it->loc = T[key]->append(it); 
  return it;
}

b_heap_item b_heap::find_min()
{ if (min>high) return 0;
  return T[min]->head();
}

b_heap_item b_heap::find_max()
{ if (max<low) return 0;
  return T[max]->head();
}

GenPtr b_heap::del_min()
{ if (min>high) 
       error_handler(1,"b_heap del_min: heap is empty");
  b_heap_item p = T[min]->pop();
  GenPtr res = p->info;
  delete p;
  while ((min <= high) && (T[min]->empty())) min++;
  if (min>high) max = low-1;
  return res;
}

GenPtr b_heap::del_max()
{ if (max<0) error_handler(1,"b_heap del_max: heap is empty");
  b_heap_item p = T[max]->pop();
  GenPtr res = p->info;
  delete p;
  while ((max>=low) && (T[max]->empty())) max--;
  if (max<low) min = high+1;
  return res;
}

b_heap_item b_heap::decrease_key(b_heap_item it, int k)
{ if (it==0) error_handler(1,"decrease_key: item = nil\n");
  if (k<low || k>high) error_handler(1,"decrease_key: illegal key\n");
  if (it->loc==0) error_handler(1,"decrease_key: item not found\n");
  T[it->key]->del(it->loc);
  while ((max >= low) && (T[max]->empty())) max--;
  it->key = k;
  it->loc = T[k]->append(it); 
  if (k<min) min = k;
  return it;
}

b_heap_item b_heap::increase_key(b_heap_item it, int k)
{ if (it==0) error_handler(1,"increase_key: item = nil\n");
  if (k<low || k>high) error_handler(1,"increase_key:illegal key\n");
  if (it->loc==0) error_handler(1,"increase_key: item not found\n");
  T[it->key]->del(it->loc);
  while ((min <= high) && (T[min]->empty())) min++;
  it->key = k;
  it->loc = T[k]->append(it); 
  if (k>max) max = k;
  return it;
}


void b_heap::delete_item(b_heap_item it) 
{ if (it==0) error_handler(1,"delete_item: item = nil\n");
  if (it->loc==0) error_handler(1,"delete_item: item not found\n");
  T[it->key]->del(it->loc); 
  while ((min <= high) && (T[min]->empty())) min++;
  while ((max >= low) && (T[max]->empty())) max--;
  delete it;
}

void b_heap::print()
{ for (int i=low;i<=high;i++) 
  { cout << i << ": ";
    T[i]->print();
    cout << "\n";
   }
 }

