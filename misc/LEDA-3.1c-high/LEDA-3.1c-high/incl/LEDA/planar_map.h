/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  planar_map.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#ifndef LEDA_PLANAR_MAP_H
#define LEDA_PLANAR_MAP_H

#include <LEDA/graph.h>

class i_face;

typedef i_face* face;

class i_face {

friend class planar_map;

 edge      head;     // first edge of face
 list_item loc;      // location in F_list
 GenPtr    inf;      // user defined information

 planar_map*  g;     // face of (*g)


 i_face(GenPtr x, planar_map* G) 
 { 
   inf = x ; 
   head = nil; 
   loc = nil; 
   g = G;
  }


  LEDA_MEMORY(i_face)

FRIEND_INLINE planar_map* graph_of(face);

};

inline planar_map* graph_of(face f) { return f->g; }





extern int STRAIGHT_LINE_EMBEDDING(graph& G, node_array<int>& xcoord,
                                            node_array<int>& ycoord);

class planar_map : public graph {

list<face>       F_list;

face  new_face(GenPtr i=0);
void  del_face(face f) { F_list.del(f->loc); delete f; }

face& FACE(edge e) { return (face&)(e->data[0]);  }

virtual void copy_face_entry(GenPtr&)  const {}
virtual void init_face_entry(GenPtr&)        {}
virtual void clear_face_entry(GenPtr&) const {}

/* inherited from graph:
virtual void copy_node_entry(GenPtr&)  const {}
virtual void init_node_entry(GenPtr&)        {}
virtual void clear_node_entry(GenPtr&) const {}
*/

virtual void print_face_entry(GenPtr&) const {}

public:


planar_map(const graph&);

planar_map() {}

virtual ~planar_map() { clear(); }

void       clear();

void       init_entries();


list<node> adj_nodes(face)   const;
list<node> adj_nodes(node v) const { return graph::adj_nodes(v); }

list<edge> adj_edges(face)   const;
list<edge> adj_edges(node v) const { return graph::adj_edges(v); }

const list<face>& all_faces()       const { return F_list; }

list<face> adj_faces(node)   const;

face       adj_face(edge e)  const { return face(e->data[0]); }

list<edge> triangulate();

edge reverse(edge e)         const { return edge(e->rev); }

edge first_face_edge(face f) const { return f->head; }
edge succ_face_edge(edge e)  const { return cyclic_adj_succ(reverse(e)); } 
edge pred_face_edge(edge e)  const { return reverse(cyclic_adj_pred(e)); } 

edge next_face_edge(edge e)  const  
{ e = succ_face_edge(e);
  return (e==adj_face(e)->head) ? nil : e;
}

face first_face() const { return F_list.head(); }

face next_face(face f) const
{ list_item it = F_list.succ(f->loc);
  return (it) ? F_list.contents(it) : nil;
}


edge    new_edge(edge,edge,GenPtr=0);
void    del_edge(edge,GenPtr=0);

edge    split_edge(edge,GenPtr=0);

node    new_node(const list<edge>&, GenPtr=0);
node    new_node(face, GenPtr=0);

GenPtr& entry(face f)         { return f->inf; }
GenPtr& entry(node v)         { return graph::entry(v); }

GenPtr  inf(face f)     const { return f->inf; }
GenPtr  inf(node v)     const { return graph::inf(v); }

int     straight_line_embedding(node_array<int>& x, node_array<int>& y)
                              { return STRAIGHT_LINE_EMBEDDING(*this,x,y); }


};


//------------------------------------------------------------------------------
// PLANAR_MAP: generic planar map
//------------------------------------------------------------------------------


template <class vtype, class ftype>

class _CLASSTYPE PLANAR_MAP : public planar_map {

vtype X;
ftype Y;

void init_node_entry(GenPtr& x)  { Init(X); x=Copy(X); }
void init_face_entry(GenPtr& x)  { Init(Y); x=Copy(Y); }

void copy_node_entry(GenPtr& x)  const { x=Copy(ACCESS(vtype,x)); }
void copy_face_entry(GenPtr& x)  const { x=Copy(ACCESS(ftype,x)); }

void clear_node_entry(GenPtr& x) const { Clear(ACCESS(vtype,x)); }
void clear_face_entry(GenPtr& x) const { Clear(ACCESS(ftype,x)); }

void print_node_entry(ostream& o, GenPtr& x)  const
{ o << "("; Print(ACCESS(vtype,x),o); o << ")"; }

void print_edge_entry(ostream& o, GenPtr& x)  const
{ o << "(" << int(x) << ")"; }

public:

   vtype  inf(node v)    const   { return ACCESS(vtype,planar_map::inf(v)); }
   ftype  inf(face f)    const   { return ACCESS(ftype,planar_map::inf(f)); }
   vtype& entry(node v)          { return ACCESS(vtype,planar_map::entry(v)); }
   ftype& entry(face f)          { return ACCESS(ftype,planar_map::entry(f)); }
   vtype& operator[] (node v)    { return entry(v); }
   ftype& operator[] (face f)    { return entry(f); }
   void   assign(node v,vtype a) { planar_map::entry(v) = Copy(a); }
   void   assign(face f,ftype a) { planar_map::entry(f) = Copy(a); }

   edge   new_edge(edge e1, edge e2)
                          { return planar_map::new_edge(e1,e2,0); }
   edge   new_edge(edge e1, edge e2, ftype a)
                          { return planar_map::new_edge(e1,e2,Convert(a)); }

   edge   split_edge(edge e, vtype a)
                          { return planar_map::split_edge(e,Convert(a)); }

   node   new_node(list<edge> el,vtype a)
                          { return planar_map::new_node(el,Convert(a)); }

   node   new_node(face f,vtype a)
                          { return planar_map::new_node(f,Convert(a)); }

   void print_node(node v) const { cout << "["; Print(inf(v)); cout << "]";}

   PLANAR_MAP(const GRAPH<vtype,ftype>& G) : planar_map((graph&)G)   {}
   PLANAR_MAP() {}
  ~PLANAR_MAP() { clear(); }

};


#define forall_face_edges(e,F)\
for(e=graph_of(F)->first_face_edge(F); e; e=graph_of(F)->next_face_edge(e)) 

#define forall_faces(f,G)\
for(f=G.first_face(); f; f=G.next_face(f)) 


#endif
