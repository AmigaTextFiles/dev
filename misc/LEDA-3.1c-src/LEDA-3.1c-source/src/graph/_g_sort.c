/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _g_sort.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/




#include <LEDA/graph.h>

//--------------------------------------------------------------------------
// sorting
//--------------------------------------------------------------------------

static const graph_array<node>*  NA;
static const graph_array<edge>*  EA;

static graph* GGG;

static int array_cmp_nodes(const node& x, const node& y) 
{ return NA->cmp_entry(x,y); }

static int array_cmp_edges(const edge& x, const edge& y) 
{ return EA->cmp_entry(x,y); }

static int graph_cmp_nodes(const node& x, const node& y)
{ return GGG->cmp_node_entry(x,y); }

static int graph_cmp_edges(const edge& x, const edge& y)
{ return GGG->cmp_edge_entry(x,y); }

static cmp_graph_node CMP_NODES;
static cmp_graph_edge CMP_EDGES;


static int CMP_ADJ_LINKS(obj_link* p, obj_link* q)
{ edge e1 = edge(adj_link1(p));
  edge e2 = edge(adj_link1(q));
  return CMP_EDGES(e1,e2);
 }

static int CMP_ADJ_LINKS1(obj_link* p, obj_link* q)
{ edge e1 = edge(adj_link2(p));
  edge e2 = edge(adj_link2(q));
  return CMP_EDGES(e1,e2);
 }

static int CMP_EDGE_LINKS(obj_link* p, obj_link* q)
{ edge e1 = edge(edge_link(p));
  edge e2 = edge(edge_link(q));
  return CMP_EDGES(e1,e2);
 }

static int CMP_NODE_LINKS(obj_link* p, obj_link* q)
{ node u = node(node_link(p));
  node v = node(node_link(q));
  return CMP_NODES(u,v);
 }
   


void graph::sort_nodes(cmp_graph_node f) 
{ CMP_NODES = f;
  V.sort(CMP_NODE_LINKS); 
 }

void graph::sort_edges(cmp_graph_edge f)
{ CMP_EDGES = f;
  E.sort(CMP_EDGE_LINKS);
  node v;
  forall_nodes(v,*this) 
  { v->adj_edges[0].sort(CMP_ADJ_LINKS);
    //v->adj_edges[1].sort(CMP_ADJ_LINKS1);
   }
 }

void graph::sort_nodes(const graph_array<node>& A) 
{ NA = &A; 
  sort_nodes(array_cmp_nodes); 
 }

void graph::sort_edges(const graph_array<edge>& A) 
{ EA = &A; 
  sort_edges(array_cmp_edges); 
 }


void graph::sort_nodes() 
{ GGG = this; 
  sort_nodes(graph_cmp_nodes); 
 }

void graph::sort_edges() 
{ GGG = this; 
  sort_edges(graph_cmp_edges); 
 }

