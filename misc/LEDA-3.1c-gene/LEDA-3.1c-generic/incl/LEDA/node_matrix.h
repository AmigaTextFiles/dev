/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  node_matrix.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_NODE_MATRIX_H
#define LEDA_NODE_MATRIX_H

#include <LEDA/graph.h>

//------------------------------------------------------------------------------
// node matrices
//------------------------------------------------------------------------------


class Node_Matrix {

graph* g;
node_array<graph_array<node>*> M;
virtual void init_entry(GenPtr&)  { }
virtual void copy_entry(GenPtr&)  const { }
virtual void clear_entry(GenPtr&) const { }

public:

 graph_array<node>& row(node v)         { return *(M[v]); }
 GenPtr&      entry(node v, node w)     { return M[v]->entry(w); }
 GenPtr       inf(node v, node w) const { return M[v]->inf(w); }

 void init(const graph&, int, GenPtr);
 void init(const Node_Matrix&);

 void clear();

 Node_Matrix()  {}
virtual ~Node_Matrix()  { clear(); }
};




template<class type>

class _CLASSTYPE node_matrix: public Node_Matrix {

type X;

void copy_entry(GenPtr& x) const { x=Copy(ACCESS(type,x)); }
void clear_entry(GenPtr& x)const { Clear(ACCESS(type,x));  }
void init_entry(GenPtr& x)       { Init(X); x = Copy(X);   }

public:
node_array<type>& operator[](node v)
{ return *(node_array<type>*)&row(v); }

type& operator()(node v, node w)       { return ACCESS(type,entry(v,w));}
type  operator()(node v, node w) const { return ACCESS(type,inf(v,w));}

void  init(const graph& G, int n, type i) { Node_Matrix::init(G,n,Convert(i)); }
void  init(const graph& G, type i)        { init(G,G.max_i(node(0))+1,i); }
void  init(const graph& G)                { Init(X); init(G,X); }

void  init(const node_matrix<type>& M) { Node_Matrix::init(M); }

node_matrix() {}
node_matrix(const graph& G)                 { init(G);   }
node_matrix(const graph& G, int n, type x)  { init(G,n,x); }
node_matrix(const graph& G, type x)         { init(G,x); }

node_matrix(const node_matrix<type>& M)     { init(M); }

node_matrix<type>& operator=(const node_matrix<type>& M)
                                            { init(M); return *this;}

~node_matrix()                 { clear();   }
};


#endif
