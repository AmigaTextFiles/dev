/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  graph2.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_GRAPH1_H
#define LEDA_GRAPH1_H

//------------------------------------------------------------------------------
//   directed graphs
//------------------------------------------------------------------------------


#include <LEDA/basic.h>
#include <LEDA/list.h>
#include <LEDA/impl/olist.h>


class node_struct;
typedef node_struct* node;

class edge_struct;
typedef edge_struct* edge;


class node_link_struct : public obj_link {};
typedef node_link_struct* node_link;

class edge_link_struct : public obj_link {};
typedef edge_link_struct* edge_link;

class aux_link_struct : public obj_link {};
typedef aux_link_struct* aux_link;


typedef int  (*cmp_graph_node) (node&, node&);
typedef int  (*cmp_graph_edge) (edge&, edge&);


//------------------------------------------------------------------------------
// class node_struct: internal representation of nodes
//------------------------------------------------------------------------------

class node_struct : public aux_link_struct, 
                    public node_link_struct
{  
   friend class graph;
   friend class ugraph;
   friend class planar_map;
   friend class node_data;
   friend class node_stack;
   friend class node_queue;
   friend class node_list;
   friend class node_pq;
   friend class node_bucket_pq;

   
   graph*   g;            // pointer to graph of node 
   int      name;         // internal name (index)  
   obj_list adj_edges;    // lists of adjacent edges
   int      indegree;

public:

   GenPtr data[3];      // data[0] used by GRAPH
                        // data[1] in node_stack, node_queue, node_pq, etc.
                        // data[2] used by node_data


node_struct(GenPtr i=0) { data[0] = i; name = -1; g = 0; indegree=0; }

LEDA_MEMORY(node_struct)

FRIEND_INLINE graph* graph_of(node);
FRIEND_INLINE graph* graph_of(edge);
FRIEND_INLINE int    indeg(node);
FRIEND_INLINE int    outdeg(node);
FRIEND_INLINE int    degree(node);
FRIEND_INLINE int    index(node);

FRIEND_INLINE edge First_Adj_Edge(node);
FRIEND_INLINE edge Last_Adj_Edge(node);

FRIEND_INLINE void start_adj_iteration(node);
FRIEND_INLINE void move_to_adj_succ(node);
FRIEND_INLINE bool read_adj_node(node&,node);
FRIEND_INLINE bool read_adj_edge(edge&,node);

friend void init_node_data1(const graph&,GenPtr);
friend void init_node_data2(const graph&,GenPtr);

};



//------------------------------------------------------------------------------
// class edge_struct: internal representation of edges
//------------------------------------------------------------------------------

class adj_link_struct1 : public obj_link 
{
   friend class graph;
   friend class ugraph;
   friend class planar_map;

 protected:

   int  name;          // internal name (index)  
   node s;             // source node 
   node t;             // target node

   LEDA_MEMORY(adj_link_struct1)

   adj_link_struct1() { name = -1; }

 };

typedef adj_link_struct1* adj_link1;


class edge_struct : public adj_link_struct1, 
                    public edge_link_struct
{ 
   
   friend class graph;
   friend class ugraph;
   friend class planar_map;
   friend class edge_data;

   edge rev;     // reverse edge (for ugraph/planar_map)

public:

   GenPtr data[1];     // space for data data[0] used by GRAPH!)
                       //                data[1] by edge_data


edge_struct(node v, node w, GenPtr i=0)
{ data[0] = i;
  name = -1;
  s = v;
  t = w;
  rev = nil;
}

LEDA_MEMORY(edge_struct)

FRIEND_INLINE graph* graph_of(edge);
FRIEND_INLINE node   source(edge);
FRIEND_INLINE node   target(edge);
FRIEND_INLINE int    index(edge);

FRIEND_INLINE bool read_adj_node(node&,node);

FRIEND_INLINE void init_edge_data(const graph&,int,GenPtr);

};


inline int    outdeg(node v) { return v->adj_edges.length(); }
inline int    indeg(node v)  { return v->indegree; }
inline int    degree(node v) { return outdeg(v); }

inline int     index(node v)  { return v->name;    }
inline graph*  graph_of(node v) { return v->g; }

inline graph* graph_of(edge e) { return e->s->g;   }
inline node   source(edge e)   { return e->s;      }
inline node   target(edge e)   { return e->t;      }
inline int    index(edge e)    { return e->name;    }


inline edge First_Adj_Edge(node v)  
{ return edge(adj_link1(v->adj_edges.first())); }

inline edge Last_Adj_Edge(node v)  
{ return edge(adj_link1(v->adj_edges.last())); }

inline edge Succ_Adj_Edge(edge e) 
{ return edge(adj_link1(adj_link1(e)->succ_item()));}

inline edge Pred_Adj_Edge(edge e) 
{ return edge(adj_link1(adj_link1(e)->pred_item()));}

inline void start_adj_iteration(node v) { v->adj_edges.start_iteration(); }

inline void move_to_adj_succ(node v) { v->adj_edges.move_to_succ(); }

inline bool read_adj_edge(edge& e, node v)
{ obj_link* p = v->adj_edges.read_iterator();
  if (p) { e = edge(adj_link1(p)); return true; }
  else return false;
 }

inline bool read_adj_node(node& u, node v)
{ obj_link* p = v->adj_edges.read_iterator();
  if (p) { u = edge(adj_link1(p))->t; return true; }
  else return false;
 }



//------------------------------------------------------------------------------
// graph_array<node/edge>
//
// base class for node and edge arrays
//
//------------------------------------------------------------------------------

template <class itype>

class _CLASSTYPE graph_array {

graph* g;     // array is declared for graph *g 

int mx_i;    // maximal node index in g at time of creation

protected:

GenPtr* arr;  

virtual void clear_entry(GenPtr&) const {}
virtual void copy_entry(GenPtr&)  const {}

public:

virtual int cmp_entry(itype,itype) const  { return 0; }

 GenPtr& entry(itype x)
 { if (g != graph_of(x) || index(x) > mx_i)
          error_handler(102,"(node/edge)_array[x]: not defined for x");
  return arr[index(x)];
 }

 GenPtr  inf(itype x) const
 { if (g != graph_of(x) || index(x) > mx_i)
          error_handler(102,"(node/edge)_array[x]: not defined for x");
  return arr[index(x)];
 }

 GenPtr& entry(int i) { return arr[i]; }

 void init(const graph&, int, GenPtr);
 void init(const graph_array<itype>&);

 void clear();
 int  size() const     { return mx_i+1;}

 graph_array() { g = 0; mx_i = -1; arr = 0;}

 virtual ~graph_array() { clear(); }

};


//------------------------------------------------------------------------------
// graph: base class for all graphs
//------------------------------------------------------------------------------

class graph {

friend class ugraph;
friend class planar_map;
friend class graph_array<node>; 
friend class graph_array<edge>; 

//list<node> V;              /* list of all nodes */
obj_list V;

//list<edge> E;              /* list of all edges */
obj_list E;

int max_n_index;      // maximal node index 
int max_e_index;      // maximal edge index

bool   undirected;       // true iff graph undirected


/* space: 2 lists + 4 words + "virtual" = 2*20 + 5*4 bytes = 60 bytes */

virtual void init_node_entry(GenPtr& x)  { x=0; }
virtual void init_edge_entry(GenPtr& x)  { x=0; }

virtual void copy_node_entry(GenPtr&) const {}
virtual void copy_edge_entry(GenPtr&) const {}

virtual void clear_node_entry(GenPtr& x) const { x=0; }
virtual void clear_edge_entry(GenPtr& x) const { x=0; }

virtual void read_node_entry(istream& in, GenPtr& x)  { Read(x,in); }
virtual void read_edge_entry(istream& in, GenPtr& x)  { Read(x,in); }

virtual void write_node_entry(ostream& o, GenPtr& x)  const { Print(x,o); }
virtual void write_edge_entry(ostream& o, GenPtr& x)  const { Print(x,o); }

virtual void print_node_entry(ostream&, GenPtr&)  const {}
virtual void print_edge_entry(ostream&, GenPtr&)  const {}

virtual char* node_type()  const { return "void"; }
virtual char* edge_type()  const { return "void"; }

protected:

graph* parent;           // for subgraphs

void copy_all_entries() const;
void clear_all_entries() const;

public:

virtual int cmp_node_entry(node, node) const { return 0; }
virtual int cmp_edge_entry(edge, edge) const { return 0; }

   int  space() const;
   void reset() const;


   int  indeg(node v)     const;
   int  outdeg(node v)    const;
   int  degree(node v)    const;
   node source(edge e)    const;
   node target(edge e)    const;

   graph* super()        const;

   int max_i(node)       const;
   int max_i(edge)       const;
   int max_node_index()  const;
   int max_edge_index()  const;

   int  number_of_nodes() const;
   int  number_of_edges() const;

   list<edge> all_edges()     const;
   list<node> all_nodes()     const;
   list<edge> adj_edges(node) const;
   list<node> adj_nodes(node) const;

   GenPtr& entry(node v);
   GenPtr& entry(edge e);
   GenPtr  inf(node v) const;
   GenPtr  inf(edge e) const;

int int_inf(edge e) { return int(e->data[0]); }


   edge first_adj_edge(node v) const;
   //edge first_in_edge(node v)  const;
   edge last_adj_edge(node v)  const;
   //edge last_in_edge(node v)   const;

   void init_adj_iterator(node v)        const;
   edge next_adj_edge(edge& e,node v)    const;
   bool current_adj_edge(edge& e,node v) const;
   bool next_adj_node(node& w,node v)    const;
   bool current_adj_node(node& w,node v) const;

   void init_node_iterator() const {}
   void init_edge_iterator() const {}
   
   node first_node()      const;
   edge first_edge()      const;
   node last_node()       const;
   edge last_edge()       const;
   node choose_node()     const;
   edge choose_edge()     const;
   node succ_node(node v) const;
   node pred_node(node v) const;
   edge succ_edge(edge e) const;
   edge pred_edge(edge e) const;
   edge adj_succ(edge e)  const;
   edge adj_pred(edge e)  const;
   edge cyclic_adj_succ(edge e) const;
   edge cyclic_adj_pred(edge e) const;

protected:

   node new_node(GenPtr);
   edge new_edge(node, node, GenPtr);
   edge new_edge(edge, node, GenPtr, int dir);

   void assign(node v,GenPtr x);
   void assign(edge e,GenPtr x);

public:

   node new_node()   { GenPtr x; init_node_entry(x);  
                       return new_node(x); }

   edge new_edge(node v, node w) 
   { GenPtr x; init_edge_entry(x);
     return new_edge(v,w,x);}

   edge new_edge(edge e, node w, int dir=0) 
   { GenPtr x; init_edge_entry(x);
     return new_edge(e,w,x,dir); }

   void del_node(node);
   void del_edge(edge);
   void del_all_nodes(); 
   void del_all_edges(); 

   list<edge> insert_reverse_edges();

   void sort_nodes(cmp_graph_node);
   void sort_edges(cmp_graph_edge);

   void sort_nodes(const graph_array<node>&);
   void sort_edges(const graph_array<edge>&);

   void sort_edges();
   void sort_nodes();

   edge rev_edge(edge);
   graph& rev();

   void make_directed();
   void make_undirected();

   void write(ostream& = cout) const;
   void write(string) const;

   int  read(istream& = cin);
   int  read(string);

   void print_node(node,ostream& = cout)  const;

virtual void print_edge(edge,ostream& = cout)  const;  //different for ugraph's

   void print(string s, ostream& = cout) const;

   void print()           const { print("");   }
   void print(ostream& o) const { print("",o); }

   void clear();

   graph();
   graph(const graph&);
   graph& operator=(const graph&); 

  virtual ~graph(){ clear(); }


   //subgraph constructors

   graph(graph&, const list<node>&, const list<edge>&);
   graph(graph&, const list<edge>&);

};

inline int  graph::outdeg(node v) const { return v->adj_edges.length(); }
inline int  graph::indeg(node v)  const { return v->indegree; }
inline int  graph::degree(node v) const { return outdeg(v); }

inline node graph::source(edge e)    const   { return e->s; }
inline node graph::target(edge e)    const   { return e->t; }

inline graph* graph::super()       const   { return parent; }
inline int graph::max_i(node)      const   { return max_n_index; }
inline int graph::max_i(edge)      const   { return max_e_index; }
inline int graph::max_node_index() const   { return max_n_index; }
inline int graph::max_edge_index() const   { return max_e_index; }

inline int  graph::number_of_nodes() const   { return V.length(); }
inline int  graph::number_of_edges() const   { return E.length(); }

inline GenPtr& graph::entry(node v)        { return v->data[0]; }
inline GenPtr& graph::entry(edge e)        { return e->data[0]; }
inline void graph::assign(node v,GenPtr x) { v->data[0] = x; }
inline void graph::assign(edge e,GenPtr x) { e->data[0] = x; }

inline GenPtr  graph::inf(node v) const { return v->data[0]; }
inline GenPtr  graph::inf(edge e) const { return e->data[0]; }

inline edge graph::first_adj_edge(node v) const
{ return edge(adj_link1(v->adj_edges.first())); }

inline edge graph::last_adj_edge(node v)  const
{ return edge(adj_link1(v->adj_edges.last())); }


inline void graph::init_adj_iterator(node v) const 
{ v->adj_edges.set_iterator(nil); }

inline bool  graph::current_adj_edge(edge& e,node v) const 
{ return (e = edge(adj_link1(v->adj_edges.read_iterator()))) != nil;}

inline edge  graph::next_adj_edge(edge& e,node v) const 
{ obj_link* it = v->adj_edges.read_iterator(); 
  obj_link* p =  it ? v->adj_edges.move_to_succ() 
                 : v->adj_edges.start_iteration(); 
  return  e = edge(adj_link1(p));
 }

inline bool graph::next_adj_node(node& w,node v)  const
{ edge e;
  if (next_adj_edge(e,v))
  { //w = (v==e->s) ? e->t : e->s;  // ugraph
    w = e->t;
    return true; 
   }
  else return false;
 }
   
inline bool graph::current_adj_node(node& w,node v)  const
{ edge e;
  if (current_adj_edge(e,v))
  { //w = (v==e->s) ? e->t : e->s;  // ugraph
    w = e->t;
    return true; 
   }
  else return false;
}
   

inline node graph::first_node()   const { return node(node_link(V.first())); }
inline node graph::last_node()    const { return node(node_link(V.last())); }
inline node graph::choose_node()  const { return first_node(); }

inline edge graph::first_edge()   const { return edge(edge_link(E.first())); }
inline edge graph::last_edge()    const { return edge(edge_link(E.last())); }
inline edge graph::choose_edge()  const { return first_edge(); }

inline node graph::succ_node(node v)  const  
{ return node(node_link(V.succ(node_link(v)))); }

inline node graph::pred_node(node v)  const  
{ return node(node_link(E.pred(node_link(v)))); }

inline edge graph::succ_edge(edge e)  const  
{ return edge(edge_link(E.succ(edge_link(e)))); }

inline edge graph::pred_edge(edge e)  const  
{ return edge(edge_link(E.pred(edge_link(e)))); }

inline edge graph::adj_succ(edge e)  const
{ return edge(adj_link1(adj_link1(e)->succ_item())); }

inline edge graph::adj_pred(edge e)  const
{ return edge(adj_link1(adj_link1(e)->pred_item())); }

inline edge graph::cyclic_adj_succ(edge e) const 
{ return (e = adj_succ(e)) ? e : first_adj_edge(e->s); }

inline edge graph::cyclic_adj_pred(edge e) const 
{ return (e = adj_pred(e)) ? e : last_adj_edge(e->s); }

//------------------------------------------------------------------------------
// Iteration   (macros)
//------------------------------------------------------------------------------

#define forall_nodes(v,g) for (v=(g).first_node(); v; v=(g).succ_node(v) )
#define forall_edges(e,g) for (e=(g).first_edge(); e; e=(g).succ_edge(e) )

#define Forall_nodes(v,g) for (v=(g).last_node(); v; v=(g).pred_node(v) )
#define Forall_edges(e,g) for (e=(g).last_edge(); e; e=(g).pred_edge(e) )


#define forall_adj_edges(e,v) for(e = First_Adj_Edge(v);e;e = Succ_Adj_Edge(e))

#define forall_out_edges(e,v) forall_adj_edges(e,v)

#define forall_in_edges(e,v) while(false)


#define forall_adj_nodes(u,v)\
for(start_adj_iteration(v); read_adj_node(u,v); move_to_adj_succ(v))



//------------------------------------------------------------------------------
// GRAPH<vtype,etype> : parameterized directed graphs
//------------------------------------------------------------------------------


template<class vtype, class etype> 

class _CLASSTYPE GRAPH : public graph {

vtype X;
etype Y;

void copy_node_entry(GenPtr& x) const  { x=Copy(ACCESS(vtype,x)); }
void copy_edge_entry(GenPtr& x) const  { x=Copy(ACCESS(etype,x)); }

void clear_node_entry(GenPtr& x) const { Clear(ACCESS(vtype,x)); }
void clear_edge_entry(GenPtr& x) const { Clear(ACCESS(etype,x)); }

void write_node_entry(ostream& o, GenPtr& x) const {Print(ACCESS(vtype,x),o);}
void write_edge_entry(ostream& o, GenPtr& x) const {Print(ACCESS(etype,x),o);}

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

vtype  inf(node v)    const   { return ACCESS(vtype,graph::inf(v)); }
etype  inf(edge e)    const   { return ACCESS(etype,graph::inf(e)); }

vtype& operator[] (node v)    { return ACCESS(vtype,entry(v)); }
etype& operator[] (edge e)    { return ACCESS(etype,entry(e)); }
vtype  operator[] (node v) const   { return ACCESS(vtype,graph::inf(v)); }
etype  operator[] (edge e) const   { return ACCESS(etype,graph::inf(e)); }

void   assign(node v,vtype x) { operator[](v) = x; }
void   assign(edge e,etype x) { operator[](e) = x; }

node   new_node()               { return graph::new_node(); }
node   new_node(vtype a)        { return graph::new_node(Copy(a)); }

edge   new_edge(node v, node w) { return graph::new_edge(v,w); }
edge   new_edge(node v, node w, etype a)
                                { return graph::new_edge(v,w,Copy(a)); }
edge   new_edge(edge e, node w) { return graph::new_edge(e,w); }
edge   new_edge(edge e, node w, etype a)
                                { return graph::new_edge(e,w,Copy(a),0); }
edge   new_edge(edge e, node w, etype a, int dir)
                                { return graph::new_edge(e,w,Copy(a),dir); }

void   clear()                  { clear_all_entries(); graph::clear(); }

GRAPH<vtype,etype>& operator=(const GRAPH<vtype,etype>& a)
{ clear_all_entries();graph::operator=(a);copy_all_entries();return *this; }

GRAPH()  {}
GRAPH(const GRAPH<vtype,etype>& a) : graph(a) { a.copy_all_entries(); } 

/* subgraphs */
GRAPH(GRAPH<vtype,etype>& a, const list<node>& b, const list<edge>& c) 
                                                  : graph(a,b,c) {}

GRAPH(GRAPH<vtype,etype>& a, const list<edge>& c) : graph(a,c) {}

virtual ~GRAPH()   { if (parent==0) clear_all_entries(); }

};



//------------------------------------------------------------------------------
// node_list
//------------------------------------------------------------------------------

class node_list : public c_obj_list
{
  node iterator;

public:

  static void del_node(node v) { aux_link(v)->del_item(); }

  void append(node v) { c_obj_list::append(aux_link(v)); }
  void push(node v)   { c_obj_list::push(aux_link(v)); }
  void insert(node v, node w) 
                      { c_obj_list::insert(aux_link(v),aux_link(w)); }
  node pop()          { return node(aux_link(c_obj_list::pop())); }
  void del(node v)    { c_obj_list::del(aux_link(v)); }

  bool member(node v)  const { return aux_link(v)->succ_link != nil; }
  bool operator()(node v) const { return member(v); }

  node first()const { return node(aux_link(c_obj_list::first())); }
  node last() const { return node(aux_link(c_obj_list::last()));  }
  node head() const { return node(aux_link(c_obj_list::first())); }
  node tail() const { return node(aux_link(c_obj_list::last()));  }

  node succ(node v) const
  { return node(aux_link(c_obj_list::succ(aux_link(v)))); }

  node pred(node v) const
  { return node(aux_link(c_obj_list::pred(aux_link(v)))); }

  node cyclic_succ(node v) const
  { return node(aux_link(c_obj_list::cyclic_succ(aux_link(v)))); }

  node cyclic_pred(node v) const
  { return node(aux_link(c_obj_list::cyclic_pred(aux_link(v)))); }

  void start_iteration() const { (*(node*)&iterator)=first(); }
  void move_to_succ() const { (*(node*)&iterator) = succ(iterator);}

  bool read_iterator(node& x) const { x = iterator; return x ? true : false; }

};



//------------------------------------------------------------------------------
// node_stack 
//------------------------------------------------------------------------------

class node_stack {

node head;

public:

node_stack() { head = nil; }

void push(node v) { v->data[1] = head; head = v; }
node pop()        { node v = head; head = node(v->data[1]); return v; }
bool empty()      { return (head==nil) ? true : false; }  
void clear()      { head = nil; }  

};


//------------------------------------------------------------------------------
// node_queue 
//------------------------------------------------------------------------------

class node_queue {

node head;
node tail;

public:

node_queue() { head = nil; }

void append(node v) 
{ v->data[1] = nil; 
  if (head == nil) 
     head = v;
  else
     tail->data[1] = v; 
  tail = v; 
 }

node pop()   { node v = head; head = node(v->data[1]); return v; }
bool empty() { return (head==nil) ? true : false; }  
void clear() { head = nil; }  

};



//------------------------------------------------------------------------------
// node_data 
//------------------------------------------------------------------------------


template <class T> class node_data {

public:

T& operator[](node v) { return (T&)v->data[2]; }

node_data(const graph& G, T x) { init_node_data2(G,GenPtr(x)); }

};


class int_node_data {

public:

int& operator[](node v) { return (int&)v->data[2]; }
int  operator()(node v) { return (int)v->data[2]; }

int  get(node v) { return (int)v->data[2]; }
void set(node v,int i) { v->data[2] = GenPtr(i); }

int_node_data(const graph& G, int x) { init_node_data2(G,GenPtr(x)); }

};





//------------------------------------------------------------------------------
// edge_data 
//------------------------------------------------------------------------------


template <class T> class edge_data {

public:

T& operator[](edge e) { return (T&)e->data[1]; }

edge_data(const graph& G, T x) { init_edge_data(G,1,GenPtr(x)); }

};




//------------------------------------------------------------------------------
// node and edge arrays
//------------------------------------------------------------------------------


#if defined(LEDA_CHECKING_OFF)
#define GRAPH_ARRAY_ACCESS(I,type)\
type& operator[](I x)       { return ACCESS(type,arr[index(x)]); }\
type  operator[](I x) const { return ACCESS(type,arr[index(x)]); }
#else
#define GRAPH_ARRAY_ACCESS(I,type)\
type& operator[](I x)       { return ACCESS(type,entry(x));}\
type  operator[](I x) const { return ACCESS(type,inf(x));}
#endif

//------------------------------------------------------------------------------
// node arrays
//------------------------------------------------------------------------------



template<class type>

class _CLASSTYPE node_array : public graph_array<node> {

type X;

void copy_entry(GenPtr& x) const { x=Copy(ACCESS(type,x));}
void clear_entry(GenPtr& x)const { Clear(ACCESS(type,x)); }

public:

int cmp_entry(node x,node y) const 
{ return compare(ACCESS(type,arr[index(x)]),ACCESS(type,arr[index(y)])); }

GRAPH_ARRAY_ACCESS(node,type)

type& elem(int i)              { return ACCESS(type,arr[i]);}
type  elem(int i) const        { return ACCESS(type,arr[i]);}

void  init(const graph& G, int n, type i) { graph_array<node>::init(G,n,Convert(i)); }
void  init(const graph& G, type i)        { init(G,G.max_i(node(0))+1,i); }
void  init(const graph& G)                { Init(X); init(G,X); }
void  init(const node_array& A)           { graph_array<node>::init(A); }


node_array() {}
node_array(const graph& G)                 { init(G);   }
node_array(const graph& G, int n, type i)  { init(G,n,i); }
node_array(const graph& G, type i)         { init(G,i); }
node_array(const node_array& A)            { init(A);   }

node_array& operator=(const node_array& A) { init(A); return *this;}

~node_array() { graph_array<node>::clear(); }

};


//------------------------------------------------------------------------------
// edge arrays
//------------------------------------------------------------------------------


template<class type>

class _CLASSTYPE edge_array : public graph_array<edge> {

type X;

void copy_entry(GenPtr& x) const { x=Copy(ACCESS(type,x));}
void clear_entry(GenPtr& x)const { Clear(ACCESS(type,x)); }

public:

int cmp_entry(edge x,edge y) const 
{ return compare(ACCESS(type,arr[index(x)]),ACCESS(type,arr[index(y)])); }

GRAPH_ARRAY_ACCESS(edge,type)

type& elem(int i)              { return ACCESS(type,arr[i]);}
type  elem(int i) const        { return ACCESS(type,arr[i]);}

void  init(const graph& G, int n, type i) { graph_array<edge>::init(G,n,Convert(i)); }
void  init(const graph& G, type i)        { init(G,G.max_i(edge(0))+1,i); }
void  init(const graph& G)                { Init(X); init(G,X); }
void  init(const edge_array& A)           { graph_array<edge>::init(A); }

edge_array() {}
edge_array(const graph& G)                 { init(G);   }
edge_array(const graph& G, int n, type i)  { init(G,n,i); }
edge_array(const graph& G, type i)         { init(G,i); }
edge_array(const edge_array& A)            { init(A);   }

edge_array& operator=(const edge_array& A) { init(A); return *this;}

~edge_array() { graph_array<edge>::clear(); }

};





//-----------------------------------------------------------------------------
// graph generators
//-----------------------------------------------------------------------------

extern void complete_graph(graph&,int);
extern void random_graph(graph&,int,int);
extern void test_graph(graph&);

extern void complete_bigraph(graph&,int,int,list<node>&,list<node>&);
extern void random_bigraph(graph&,int,int,int,list<node>&,list<node>&);
extern void test_bigraph(graph&,list<node>&,list<node>&);


extern void random_planar_graph(graph&,node_array<double>& xcoord, 
                                       node_array<double>& ycoord, int n);

extern void random_planar_graph(graph&,int);


extern void grid_graph(graph&,node_array<double>& xcoord, 
                              node_array<double>& ycoord, int n);

extern void grid_graph(graph&,int);


extern void cmdline_graph(graph&,int,char**);



//-----------------------------------------------------------------------------
// miscellaneous  (should be members or constructors)
//-----------------------------------------------------------------------------

extern bool Is_Bidirected(const graph&, edge_array<edge>&);

extern bool Is_Simple(graph& G);

extern void Make_Simple(graph& G);



// for historical reasons:

inline bool compute_correspondence(const graph& G, edge_array<edge>& rev)
{ return Is_Bidirected(G,rev); }

inline void eliminate_parallel_edges(graph& G) 
{ Make_Simple(G); }


#endif
