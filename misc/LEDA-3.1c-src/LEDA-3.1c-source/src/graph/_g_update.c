/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _g_update.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/graph.h>


list<edge> graph::insert_reverse_edges()
{ list<edge> L;
  edge e = first_edge();

  if (e != nil)
  { L.append(new_edge(e->t,e->s,e->data[0]));
    copy_edge_entry(e->data[0]);
    e = succ_edge(e);
   }

  edge stop = last_edge();

  while (e != stop);
  { L.append(new_edge(e->t,e->s,e->data[0]));
    copy_edge_entry(e->data[0]);
    e = succ_edge(e);
   } 

  return L;
}


void graph::reset()  const   // reset all iterators
{ node v;
  forall_nodes(v,*this) v->adj_iterator=nil;
}

node graph::new_node(GenPtr i)
{ 
  node v = new node_struct(i); 
  v->g = this;
  v->name = ++max_n_index;
  aux_link(v)->succ_link = nil;
  V.append(node_link(v));
  return v;
}

void graph::del_node(node v)
{ if (v->g != this) error_handler(4,"del_node: v is not in G");


  // delete adjacent edges
  while (outdeg(v) != 0) del_edge(first_adj_edge(v));
  while (indeg(v) != 0) del_edge(first_in_edge(v));


  V.del(node_link(v));

  if (parent==0)   // no subgraph
    clear_node_entry(v->data[0]);
 
  delete v;
}

edge graph::new_edge(node v, node w, GenPtr i)
{ if ((v->g!=this) || (w->g!=this)) 
      error_handler(6, "G.new_edge(v,w): v or w not in G");
  edge e = new edge_struct(v,w,i);
  e->name = ++max_e_index;
  E.append(edge_link(e));
  v->adj_edges[0].append(adj_link1(e));
  w->adj_edges[1].append(adj_link2(e));
  return e ; 
}

edge graph::new_edge(edge e1, node w, GenPtr i, int dir)  
{ //add edge (source(e1),w) after/before e1 to adjacency list of source(e1)

  node v  = e1->s;

  if ((v->g!=this) || (w->g!=this)) 
     error_handler(9,"G.new_edge(e,w): e or w not in G");

  edge e = new edge_struct(v,w,i);

  e->name = ++max_e_index;
  E.append(edge_link(e));
  v->adj_edges[0].insert(adj_link1(e),adj_link1(e1),dir);
  w->adj_edges[1].append(adj_link2(e));
  return e ; 
}

edge graph::new_edge(edge e1, edge e2, GenPtr i, int dir1, int dir2)  
{ //add edge (source(e1),target(e2)) 
  //after(dir=0)/before(dir=1) e1 to out-list of source(e1)
  //after(dir=1)/before(dir=1) e2 to in-list of target(e2)

  node v  = e1->s;
  node w  = e2->t;

  if ((v->g!=this) || (w->g!=this)) 
     error_handler(9,"G.new_edge(e,w): e or w not in G");

  edge e = new edge_struct(v,w,i);

  e->name = ++max_e_index;
  E.append(edge_link(e));
  v->adj_edges[0].insert(adj_link1(e),adj_link1(e1),dir1);
  w->adj_edges[1].insert(adj_link2(e),adj_link1(e2),dir2);
  return e ; 
}


void graph::del_edge(edge e)
{ node v = e->s;
  node w = e->t;

  if (v->g != this) error_handler(10,"del_edge: e is not in G");
     
  E.del(edge_link(e));

  v->adj_edges[0].del(adj_link1(e));
  w->adj_edges[1].del(adj_link2(e));

  if (parent == 0)  // no subgraph
     clear_edge_entry(e->data[0]);

  delete e; 
}

 
void graph::hide_edge(edge e)
{ adj_link1 l1 = adj_link1(e);
  if (l1->succ_link != l1)
  { e->s->adj_edges[0].del(l1);
    e->t->adj_edges[1].del(adj_link2(e));
    l1->succ_link = l1;
   }

 }

void graph::restore_edge(edge e)
{ adj_link1 l1 = adj_link1(e);
  if (l1->succ_link == l1) 
  { e->s->adj_edges[0].append(l1);
    e->t->adj_edges[1].append(adj_link2(e));
   }
 }


edge graph::rev_edge(edge e)
{ node v = e->s;
  node w = e->t;
  if (v->g != this) error_handler(11,"rev_edge: e is not in G");

  v->adj_edges[0].del(adj_link1(e));
  w->adj_edges[1].del(adj_link2(e));

  w->adj_edges[0].append(adj_link1(e));
  v->adj_edges[1].append(adj_link2(e));

  e->s = w;
  e->t = v;
  return e; 
}

graph& graph::rev()              
{ edge e;
  forall_edges(e,*this) rev_edge(e);
  return *this; 
}

void graph::del_all_nodes() { clear(); }

void graph::del_all_edges()
{ node v;
  forall_nodes(v,*this) 
  { v->adj_edges[0].clear();
    v->adj_edges[1].clear();
   }
  while (!E.empty()) delete edge(edge_link(E.pop()));
  max_e_index = -1;
}

