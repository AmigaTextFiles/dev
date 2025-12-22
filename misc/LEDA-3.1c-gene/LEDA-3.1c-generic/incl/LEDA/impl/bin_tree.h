/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  bin_tree.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#ifndef LEDA_BIN_TREE_H
#define LEDA_BIN_TREE_H

//------------------------------------------------------------------------------
//
// bin_tree  
//
//     base class for all leaf oriented binary trees in LEDA
//
// Ijon Tichy  (1993)
//
//------------------------------------------------------------------------------


#include <LEDA/basic.h>

 
class bin_tree;
class bin_tree_node;

typedef bin_tree_node* bin_tree_item;

typedef void (*DRAW_BIN_NODE_FCT)(double,double,void*,int);
typedef void (*DRAW_BIN_EDGE_FCT)(double,double,double,double);


//------------------------------------------------------------------------------
// class bin_tree_node 
//------------------------------------------------------------------------------

class bin_tree_node
{  
   friend class bin_tree;
   friend class avl_tree;
   friend class bb_tree;
   friend class rb_tree;
   friend class rs_tree;


   GenPtr   k;              // key
   GenPtr   i;              // info

   bin_tree_node* child[2]; // node: left and right child
                            // leaf: successor and predecessor

   bin_tree_node* parent;   // pointer to parent

   bin_tree_node* corr;     // leaf: pointer to corresponding inner node
                            // node: nil

   int   bal;               // rebalancing data
 

   public:


   bin_tree_node(GenPtr key, GenPtr inf, int b)
   { k = key;
     i = inf; 
     bal = b;
    }         

   bin_tree_node() { }         

   bin_tree_node(bin_tree_node* p)
   { k = p->k;
     i = p->i ;
     bal = p->bal;
    }         

   bool is_node()   { return (corr == nil);  }
   bool is_leaf()   { return (corr != nil); }

   void set_bal(int x) { bal = x; }
   int  get_bal()      { return bal; }


   LEDA_MEMORY(bin_tree_node)

};


 
//------------------------------------------------------------------------------
// class bin_tree
//------------------------------------------------------------------------------

class bin_tree
{ 
  protected:

  enum { left=0, right=1 };

  bin_tree_node ROOT;      // "super root" to avoid special cases in rotations
                           // ROOT.child[left] points to real root node
                           // ROOT.child[right] points to leftmost leaf
  int count;            


  // functions depending on used rebalancing method
  // will be defined in derived classes (rb_tree, avl_tree, ...)

  virtual int leaf_balance() { return 0; }  // default balance value for leaves
  virtual int node_balance() { return 0; }  // inner nodes
  virtual int root_balance() { return 0; }  // root node

  virtual void insert_rebal(bin_tree_node*)   {}
  virtual void del_rebal(bin_tree_node*, bin_tree_node*) {}




  // other protected member functions

  bin_tree_node*& min_ptr() const 
                           { return (bin_tree_node*&)ROOT.child[right];}

  void rotation(bin_tree_node*, bin_tree_node*, int);
  void double_rotation(bin_tree_node*, bin_tree_node*, bin_tree_node*, int);

  void del_tree(bin_tree_node*);

  bin_tree_node* int_search(GenPtr) const;
  bin_tree_node* search(GenPtr) const;
  bin_tree_node* copy_tree(bin_tree_node*,bin_tree_item&) const;



  // functions depending on actual key type
  // will be defined in dictionary and sortseq templates

  virtual int cmp(GenPtr x, GenPtr y) const { return compare(x,y); }

  virtual void clear_key(GenPtr&) const { }
  virtual void clear_inf(GenPtr&) const { }
  virtual void clear_iinf(GenPtr&)const { }

  virtual void copy_key(GenPtr&)  const { }
  virtual void copy_inf(GenPtr&)  const { }

  virtual void print_key(GenPtr) const { }
  virtual void print_inf(GenPtr) const { }

  virtual int  int_type() const { return 0; }

  //bin_tree_node* item(void* p) const { return (bin_tree_node*)p; }


public:

  bin_tree_node* item(void* p) const { return (bin_tree_node*)p; }

  bin_tree_node*& root() const 
                           { return (bin_tree_node*&)ROOT.child[left]; }


  bin_tree_node* cyclic_succ(bin_tree_node* p) const { return p->child[right]; }
  bin_tree_node* cyclic_pred(bin_tree_node* p) const { return p->child[left]; }

  bin_tree_node* succ(bin_tree_node* p) const
  { return (p->child[right] == min_ptr()) ? 0 : p->child[right]; }

  bin_tree_node* pred(bin_tree_node* p) const
  { return (p == min_ptr())  ?  0 : p->child[left] ; }

  bin_tree_node* first_item()  const               { return min_ptr(); }
  bin_tree_node* next_item(bin_tree_node* p) const { return succ(p); }

  bin_tree_node* min() const { return min_ptr(); }
  bin_tree_node* max() const { return (count>0) ? min_ptr()->child[left] : 0; }


  bin_tree& conc(bin_tree&);
  void split_at_item(bin_tree_node*,bin_tree&,bin_tree&);
  void reverse_items(bin_tree_node*,bin_tree_node*);


  bin_tree_node* insert(GenPtr,GenPtr,GenPtr=0);
  bin_tree_node* insert_at_item(bin_tree_node*,GenPtr,GenPtr,GenPtr=0);
  bin_tree_node* lookup(GenPtr) const;
  bin_tree_node* locate(GenPtr) const;
  bin_tree_node* locate_succ(GenPtr) const; 
  bin_tree_node* locate_pred(GenPtr) const; 

  GenPtr   key(bin_tree_node* p)  const { return  p->k; }
  GenPtr   inf(bin_tree_node* p)  const { return  p->i; }
  GenPtr&  info(bin_tree_node* p) const { return  p->i; }

  void del(GenPtr);
  void del_item(bin_tree_node* p);
  void change_inf(bin_tree_node*,GenPtr);

  void clear();

  int size()   const { return count; } 
  int empty()  const { return root() ? false : true ; }



  // construction, assignment, destruction

  bin_tree() {  count = 0; root() = nil; min_ptr() = nil; }

  bin_tree(const bin_tree&);
  bin_tree& operator=(const bin_tree&);

  virtual ~bin_tree() { clear(); }



  // additional operations used by range and segment trees

  virtual void propagate_modification(int, GenPtr, GenPtr) {}

  bin_tree_node* l_child(bin_tree_node* p) const
  { return p->is_leaf() ? 0 : p->child[left]; }

  bin_tree_node* r_child(bin_tree_node* p) const
  { return p->is_leaf() ? 0 : p->child[right]; }

  int is_inner(bin_tree_node* p)  const
  { return p->corr == 0; }

  bin_tree_node* parent(bin_tree_node* p)  const
  { return (p==root()) ? 0 : p->parent; }


  // miscellaneous

  void draw(DRAW_BIN_NODE_FCT, DRAW_BIN_NODE_FCT, DRAW_BIN_EDGE_FCT, 
            bin_tree_node*, double, double, double, double, double);

  void draw(DRAW_BIN_NODE_FCT, DRAW_BIN_NODE_FCT, DRAW_BIN_EDGE_FCT, 
            double, double, double, double);

  void print() const;
  void print_tree(bin_tree_node*,int) const;

};



inline void bin_tree::rotation(bin_tree_node* p,bin_tree_node* q, int dir)
{ bin_tree_node* r = q->child[1-dir];
  bin_tree_node* x = p->parent;
  p->child[dir] = r;
  q->child[1-dir] = p;
  p->parent = q;
  r->parent = p;
  if (p == x->child[left])
     x->child[left] = q;
  else
     x->child[right] = q;
  q->parent = x;

  propagate_modification(4,p,r);
  propagate_modification(5,q,p);
  if( x!=&ROOT )
    propagate_modification(6,x,q);
 }


inline void bin_tree::double_rotation(bin_tree_node* p, bin_tree_node* q, 
                                      bin_tree_node* r, int dir1)
{ int dir2 = 1-dir1;
  bin_tree_node* s = r->child[dir1];
  bin_tree_node* t = r->child[dir2];
  bin_tree_node* x = p->parent;
  p->child[dir1] = t;
  q->child[dir2] = s;
  r->child[dir1] = q;
  r->child[dir2] = p;
  p->parent = r;
  q->parent = r;
  s->parent = q;
  t->parent = p;

  if (p == x->child[left])
     x->child[left] = r;
  else
     x->child[right] = r;

  r->parent = x;

  propagate_modification(7,p,t);
  propagate_modification(8,q,s);
  propagate_modification(9,r,p);
  propagate_modification(10,r,q);
  if( x!=&ROOT )
    propagate_modification(11,x,r);
}



// dummy I/O and cmp functions

inline void Print(const bin_tree&,ostream&) { }
inline void Read(bin_tree&, istream&) { }
inline int  compare(const bin_tree&,const bin_tree&) { return 0; }

#endif
