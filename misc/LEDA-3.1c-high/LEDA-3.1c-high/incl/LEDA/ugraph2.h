/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  ugraph2.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_UGRAPH_H
#define LEDA_UGRAPH_H

#include <LEDA/graph.h>


//-----------------------------------------------------------------------------
// ugraph: base class for all undirected graphs
//-----------------------------------------------------------------------------

class ugraph : public graph{

private:

edge sym_edge(edge e) const { return e->rev; }


public:


edge new_edge(node v,node w,GenPtr i);
edge new_edge(node v,node w,edge e1,edge e2,GenPtr i,int d1,int d2) ;

edge new_edge(node v,node w)
{ GenPtr x; init_edge_entry(x);
  return new_edge(v,w,x);
 }

edge new_edge(node v, node w, edge e1 ,edge e2, int dir1=0,int dir2=0)
{ GenPtr x; init_edge_entry(x);
  return new_edge(v,w,e1,e2,x,dir1,dir2);
 }

void del_edge(edge);

void rev_edge(edge) {}

node opposite(node v, edge e)  const { return (v==e->s) ? e->t : e->s; }

list<node> adj_nodes(node) const;

edge adj_succ(edge e,node v)  const
{ if (v==e->t) e = sym_edge(e);
  return graph::adj_succ(e);
 }

edge adj_pred(edge e,node v)  const
{ if (v==e->t) e = sym_edge(e);
  return graph::adj_pred(e);
 }

edge cyclic_adj_succ(edge e,node v)  const
{ if (v==e->t) e = sym_edge(e);
  return graph::cyclic_adj_succ(e);
 }

edge cyclic_adj_pred(edge e,node v)  const
{ if (v==e->t) e = sym_edge(e);
  return graph::cyclic_adj_pred(e);
 }


void print_edge(edge, ostream& = cout) const;

void read(string s)    { graph::read(s);  make_undirected(); } 
void read(istream& in) { graph::read(in); make_undirected(); } 

ugraph()  { undirected = true; }

ugraph(const graph& a): graph(a) { undirected = true;  make_undirected(); }

ugraph(const ugraph& a) : graph(a)  { undirected = true;  }

~ugraph() { /* ~graph does the job */ }

//subgraph constructors
ugraph(ugraph&, const list<node>&, const list<edge>&);
ugraph(ugraph&, const list<edge>&);

ugraph& operator=(const ugraph& a) { graph::operator=(a); return *this; }

ugraph& operator=(const graph& a)  { graph::operator=(a); 
                                     make_undirected(); 
                                     return *this;
                                    }

};



//------------------------------------------------------------------------------
// UGRAPH: generic ugraphs
//------------------------------------------------------------------------------


template<class vtype, class etype>

class _CLASSTYPE UGRAPH : public ugraph {

vtype X;
etype Y;

void copy_node_entry(GenPtr& x) const { x=Copy(ACCESS(vtype,x)); }
void copy_edge_entry(GenPtr& x) const { x=Copy(ACCESS(etype,x)); }

void clear_node_entry(GenPtr& x) const { Clear(ACCESS(vtype,x)); }
void clear_edge_entry(GenPtr& x) const { Clear(ACCESS(etype,x)); }

void write_node_entry(ostream& o, GenPtr& x) const{ Print(ACCESS(vtype,x),o);}
void write_edge_entry(ostream& o, GenPtr& x) const{ Print(ACCESS(etype,x),o);}

void read_node_entry(istream& i, GenPtr& x) { Read(X,i); x=Copy(X); }
void read_edge_entry(istream& i, GenPtr& x) { Read(Y,i); x=Copy(Y); }

void init_node_entry(GenPtr& x) { Init(X); x = Copy(X); }
void init_edge_entry(GenPtr& x) { Init(Y); x = Copy(Y); }

void print_node_entry(ostream& o, GenPtr& x)  const
     { o << "("; Print(ACCESS(vtype,x),o); o << ")"; }
void print_edge_entry(ostream& o, GenPtr& x)  const
     { o << "("; Print(ACCESS(etype,x),o); o << ")"; }

char* node_type()  const { return TYPE_NAME(vtype); }
char* edge_type()  const { return TYPE_NAME(etype); }

public:

int cmp_node_entry(node x, node y) const { return compare(inf(x),inf(y)); }
int cmp_edge_entry(edge x, edge y) const { return compare(inf(x),inf(y)); }

vtype  inf(node v)         const { return ACCESS(vtype,ugraph::inf(v)); }
etype  inf(edge e)         const { return ACCESS(etype,ugraph::inf(e)); }
vtype& operator[] (node v)       { return ACCESS(vtype,entry(v)); }
vtype  operator[] (node v) const { return ACCESS(vtype,ugraph::inf(v)); }
etype& operator[] (edge e)       { return ACCESS(etype,entry(e)); }
etype  operator[] (edge e) const { return ACCESS(etype,ugraph::inf(e)); }
void   assign(node v,vtype x)    { graph::assign(v,Convert(x)); }
void   assign(edge e,etype x)    { graph::assign(e,Convert(x)); }

node   new_node()        { return ugraph::new_node(); }
node   new_node(vtype a) { return graph::new_node(Copy(a)); }

edge   new_edge(node v, node w) 
                   { return ugraph::new_edge(v,w); }

edge   new_edge(node v, node w, etype a) 
                   { return ugraph::new_edge(v,w,Copy(a)); }
edge   new_edge(node v,node w,edge e1,edge e2,etype a,int dir1=0,int dir2=0)
                   { return ugraph::new_edge(v,w,e1,e2,Copy(a),dir1,dir2); }

void   clear()     { clear_all_entries(); ugraph::clear(); }

UGRAPH<vtype,etype>& operator=(const UGRAPH<vtype,etype>& a)
{ clear_all_entries();
  ugraph::operator=(*(ugraph*)&a);
  copy_all_entries();
  return *this;}

UGRAPH<vtype,etype>& operator=(const graph& a)
{ clear_all_entries();
  ugraph::operator=(a);
  copy_all_entries();
  return *this;
 }

UGRAPH() {}

UGRAPH(const UGRAPH<vtype,etype>& a): ugraph(*(ugraph*)&a) 
{ copy_all_entries(); }

UGRAPH(const graph& a) : ugraph(a)            
{ copy_all_entries(); }

~UGRAPH() 
{ if (parent==0) clear_all_entries(); }

};



extern void complete_ugraph(ugraph&,int);
extern void random_ugraph(ugraph&,int,int);
extern void test_ugraph(ugraph&);

#ifndef __ZTC__
inline void complete_graph(ugraph& U,int n)     { complete_ugraph(U,n); }
inline void random_graph(ugraph& U,int n,int m) { random_ugraph(U,n,m); }
inline void test_graph(ugraph& U)               { test_ugraph(U); }
#endif


#endif
