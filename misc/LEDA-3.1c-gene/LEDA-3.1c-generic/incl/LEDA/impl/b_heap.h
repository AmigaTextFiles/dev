/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  b_heap.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_BHEAP_H
#define LEDA_BHEAP_H

//------------------------------------------------------------------------------
// b_heap: bounded heaps with integer keys in [a..b]
//------------------------------------------------------------------------------

#include <LEDA/basic.h>
#include <LEDA/list.h>
#include <LEDA/array.h>

class b_heap_node {

friend class b_heap;
friend void print_b_heap_item(b_heap_node*);

int key;
GenPtr info;
list_item loc;

b_heap_node(int k, GenPtr i ) 
{ 
  key = k; info = i; loc = 0; }

  LEDA_MEMORY(b_heap_node)

};

typedef b_heap_node* b_heap_item;

typedef list<b_heap_item>* b_heap_bucket;


class b_heap {

    int min;
    int max;
    int low;
    int high;
    
    array<b_heap_bucket>  T;


public:

b_heap(int a, int b);
~b_heap() { clear(); }
b_heap_item insert(int key, GenPtr info) ;

b_heap_item find_min();
b_heap_item find_max();
GenPtr del_min();
GenPtr del_max();
b_heap_item decrease_key(b_heap_item it, int k);
b_heap_item increase_key(b_heap_item it, int k);

void delete_item(b_heap_item it);
void clear();

GenPtr info(b_heap_item it) { return it->info; }
int key(b_heap_item it)  { return it->key; }
int empty()              { return (find_min()==0) ? true : false; }

void print();

};

#endif

