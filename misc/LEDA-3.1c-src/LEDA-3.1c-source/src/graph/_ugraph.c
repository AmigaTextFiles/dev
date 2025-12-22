/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _ugraph.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/ugraph.h>


//------------------------------------------------------------------------------
// undirected graphs 
//------------------------------------------------------------------------------

void  ugraph::print_edge(edge e,ostream& o) const
{ o <<   "[" << e->s->name << "]==";
  print_edge_entry(o,e->data[0]);
  o << "==[" << e->t->name << "]";
 }

// ugraph subgraph constructors:

ugraph::ugraph(ugraph& G, const list<node>& nl, const list<edge>& el)
{ // construct subugraph (nl,el) of ugraph G

  parent = &G;
  node v,w;
  edge e;

  node* N = new node[G.max_n_index+1];

  forall(v,nl)
   { if (graph_of(v) != parent) 
      error_handler(1,"ugraph: illegal node in subgraph constructor");
     N[v->name] = new_node(v);
    }

  forall(e,el)
   { v = source(e);
     w = target(e);
     if ( graph_of(e)!= parent || N[v->name]==0 || N[w->name]==0 ) 
      error_handler(1,"ugraph: illegal edge in subgraph constructor");
     new_edge(N[v->name],N[w->name],e);
    }

  delete N;

 }

ugraph::ugraph(ugraph& G, const list<edge>& el)
{ // construct subgraph of ugraph G with edgelist el 

  node  v,w;
  edge  e;
  node* N = new node[G.max_n_index+1];

  forall_nodes(v,G) N[v->name] = 0;

  parent = &G;

  forall(e,el)
   { v = source(e);
     w = target(e);
     if (N[v->name] == 0) N[v->name] = new_node(v);
     if (N[w->name] == 0) N[w->name] = new_node(w);
     if ( graph_of(e) != parent )
       error_handler(1,"ugraph: illegal edge in subgraph constructor");
     new_edge(N[v->name],N[w->name],e);
    }

  delete N;

 }
