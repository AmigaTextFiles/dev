/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  bb_tree1.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/




#ifndef LEDA_BB_TREE_H
#define LEDA_BB_TREE_H

//--------------------------------------------------------------------
//  
//  BB[alpha] Trees
//
//  Michael Wenzel   (1989)
//
// Implementation follows
// Kurt Mehlhorn: Data Structures and Algorithms 1, section III.5.1
//
// Aenderungen:
//   - virtuelle compare-Funktion   (M. Wenzel, Nov. 1989)
//--------------------------------------------------------------------


#include <LEDA/b_stack.h>


// -----------------------------------------------------
// declarations and definitions
// -------------------------------------------------------

const int BSTACKSIZE = 32 ; // according to tree.size and alpha

const float SQRT1_2 = 0.70710678;

class bb_node;
class bb_tree;

typedef bb_node* bb_item;

typedef bb_node* bb_tree_item;

typedef b_stack<bb_item> bb_tree_stack;


typedef void (*DRAW_BB_NODE_FCT)(double,double,void*);
typedef void (*DRAW_BB_EDGE_FCT)(double,double,double,double);

class bb_node {

  GenPtr ke;
  GenPtr inf;
  int gr;
  bb_item sohn[2];

  friend class bb_tree;
  friend class range_tree;
  friend class Segment_Tree;
  friend class seg_node_tree;

public:

  GenPtr key()           { return ke; }
  GenPtr info()          { return inf; }

  int blatt()         { return (gr==1); }
  int groesse()       { return gr; }

  float bal()
	{ if (blatt()) return 0.5 ;
	  else return float(float(sohn[0]->groesse())/float(gr));
        }

  bb_node(GenPtr k=0,GenPtr i=0,int leaf=0,bb_item ls=0,bb_item rs=0)
    { ke = k;
      inf = i;
      sohn[0] = ls;
      sohn[1] = rs;
      if (leaf==0)
	gr=1;
      else gr = ls->groesse()+rs->groesse();
    }

  bb_node(bb_item p)
    { 
      ke = p->key();
      inf = p->info();
      gr = p->groesse();
      sohn[0] = p->sohn[0];
      sohn[1] = p->sohn[1];
    }
      
  LEDA_MEMORY(bb_node)

}; 



class bb_tree {

  bb_item root;
  bb_item first;
  bb_item iterator;
  int   anzahl; 
  float alpha;
  float d;
  bb_tree_stack st;

  friend class bb_node;
  friend class range_tree;
  friend class seg_node_tree;
  friend class Segment_Tree;

  int   blatt(bb_item it)
	{ return (it) ? it->blatt() : 0; }

  void  lrot(bb_item , bb_item ); 
  void  rrot(bb_item , bb_item ); 
  void  ldrot(bb_item , bb_item ); 
  void  rdrot(bb_item , bb_item ); 

  void  deltree(bb_item);
  bb_item copytree(bb_item , bb_item , bb_item& );
  bb_item search(GenPtr);
  bb_item sinsert(GenPtr , GenPtr );
  bb_item sdel(GenPtr );

protected:
 bb_tree_item item(void* p) const { return bb_tree_item(p); }


public:

  virtual int cmp(GenPtr x, GenPtr y) const { return compare(x,y); }
  virtual void clear_key(GenPtr&) const {}
  virtual void clear_inf(GenPtr&) const {}
  virtual void copy_key(GenPtr&)  const {}
  virtual void copy_inf(GenPtr&)  const {}

  GenPtr     key(bb_item it)  const   { return it->ke;  }
  GenPtr&    info(bb_item it)         { return it->inf; }
  GenPtr     inf(bb_item it)  const   { return it->inf; }
  GenPtr     translate(GenPtr y);

  bb_item insert(GenPtr ,GenPtr );
  bb_item change_obj(GenPtr ,GenPtr );
  bb_item change_inf(bb_item it,GenPtr y) { if (it)  
  	                                 { it->inf = y;
                                           return it; }
                                         else return 0;
                                        }

  bb_item del(GenPtr);

  void del_item(bb_item it) { if (it) del(it->key()); }
  void del_min() { if (first) del(first->key()); } 
  void decrease_key(bb_item p, GenPtr k) { GenPtr i = p->info(); 
                                            del(p->key());
                                            insert(k,i);
                                           }

  bb_item locate(GenPtr)  const;
  bb_item located(GenPtr) const;
  bb_item lookup(GenPtr)  const;

  bb_item cyclic_succ(bb_item it)  const
  	  { return it ? it->sohn[1] : 0 ; }
  bb_item cyclic_pred(bb_item it)  const
	  { return it ? it->sohn[0] : 0 ; }
  bb_item succ(bb_item it) const
          { return ( it && it->sohn[1] != first ) ? it->sohn[1] : 0 ; }
  bb_item pred(bb_item it) const
          { return ( it && it != first ) ? it->sohn[0] : 0 ; }

  bb_item ord(int k);
  bb_item min()       const    { return (first) ? first : 0; }
  bb_item find_min()  const    { return (first) ? first : 0; }
  bb_item max()       const    { return (first) ? first->sohn[0] : 0 ; }

  bb_item first_item() const         { return (first) ? first : 0; }
  bb_item next_item(bb_item x) const { return succ(x); }

  bb_item move_iterator() ;

  int current_item(bb_item& x) 
     { if (!iterator) return 0;
       else { x = iterator; return 1; }
     }


  void init_iterator()          { iterator = 0; }
  void  lbreak()                { iterator = 0; }


  void  clear();
  int   size()    const        { return anzahl; }
  int   empty()   const        { return (anzahl==0) ? true : false; }

  int   member(GenPtr );
  bb_tree& operator=(const bb_tree& w);

  void  set_alpha(float a) 
        { if (anzahl>=3)
             error_handler(4,"aenderung von alpha nicht erlaubt");
          if ((a<0.25) || (a>1-SQRT1_2))
             error_handler(3,"alpha not in range");
          alpha=a;
          d = 1/(2-alpha) ;
        }

  float get_alpha() { return alpha; }

  bb_tree() : st(BSTACKSIZE)
  { 
    root = first = iterator = 0;
    anzahl = 0;
    alpha=0.28;
    d=1/(2-alpha);
  }

  bb_tree(float);
  bb_tree(const bb_tree&);


// virtual  // if the destructor is declared virtual range/segment trees crash

  ~bb_tree()  { clear(); }



  void draw(DRAW_BB_NODE_FCT, DRAW_BB_EDGE_FCT, bb_node*,
            double, double, double, double, double);

  void draw(DRAW_BB_NODE_FCT, DRAW_BB_EDGE_FCT, 
            double, double, double, double);

};


#endif
