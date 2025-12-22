/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  b_node_pq.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_B_NODE_PQ_H
#define LEDA_B_NODE_PQ_H


//------------------------------------------------------------------------------
// bounded node priority queue
//
// S. Naeher (1993)
//------------------------------------------------------------------------------


template <int DELTA> 
class b_node_pq 
{
  node_list bucket[DELTA+1];

  node_struct stop_item;
  node_list*  stop;
  node_list*  minptr;  // pointer to bucket of nodes with minimal dist value
  int         val0;    // current dist value of nodes in bucket[0]

  node nil_node;       // node to be returned by del_min if queue is empty


public:

b_node_pq(node v = nil)
{ minptr = bucket; 
  stop = bucket+DELTA; 
  val0 = 0; 
  stop->append(&stop_item);
  nil_node = v;
 }

node del_min()
{ while (minptr->empty()) minptr++;

  if (minptr == stop) 
  { val0 += DELTA;
    minptr = bucket;
    while (minptr->empty()) minptr++;
   }

  return (minptr==stop) ? nil_node : minptr->pop();
 }


void insert(node w, int d) 
{ if ((d-=val0) >= DELTA) d -= DELTA;
  bucket[d].push(w); 
 }

void del(node w) { node_list::del_node(w); }


};

#endif
