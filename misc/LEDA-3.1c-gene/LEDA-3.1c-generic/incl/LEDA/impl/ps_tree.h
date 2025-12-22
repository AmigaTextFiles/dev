/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  ps_tree.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_PSTREE_H
#define LEDA_PSTREE_H

//--------------------------------------------------------------------
//  
//  Priority Search Trees
//
//  Renate Lassen (1990)
//
// Implementation as described in
// Kurt Mehlhorn: Data Structures and Algorithms 2, section III.5.1.2
//
//--------------------------------------------------------------------

// -----------------------------------------------------
// includes
// -----------------------------------------------------

#include <LEDA/basic.h>
#include <LEDA/b_stack.h>


// -----------------------------------------------------
// declarations and definitions
// -------------------------------------------------------

const BSTACKSIZE = 70 ; // according to tree.size and alpha
 		        // here: tree.size <= 10^9
 		        //       alpha = 0.25 ( worst case )

enum children     { left = 0 , right = 1 };
enum leaf_or_node { leaf = 0 , node = 1 } ;

class ps_node;
class ps_tree;

typedef int x_typ;
typedef ps_node* ps_item;

struct pair { x_typ x_pkt;
              x_typ y_pkt;
              bool valid;
            };

typedef pair* pair_item;


// -------------------------------------------------------
// class ps_node     
// -------------------------------------------------------

class ps_node {

  x_typ x_val;
  x_typ y_val;
  x_typ split_val[2];
  int gr;
  ps_item sohn[2];

  friend class ps_tree;

public:

  x_typ x_value()           { return x_val; }
  x_typ y_value()           { return y_val; }
  x_typ split_value_x()     { return split_val[0]; }
  x_typ split_value_y()     { return split_val[1]; }

  int blatt()             { return (gr==1); }
  int groesse()           { return gr; }


  float bal()
  { if (blatt()) return 0.5;
    else return float(float(sohn[left]->groesse())/float(gr));
   }


  ps_node(x_typ x_v=0,x_typ y_v=0,x_typ split_v_0=0,x_typ split_v_1=0,leaf_or_node ln=leaf,ps_item ls=0,ps_item rs=0)
    { x_val = x_v;
      y_val = y_v;
      split_val[0] = split_v_0;
      split_val[1] = split_v_1;
      sohn[left] = ls;
      sohn[right] = rs;
      if (ln==leaf)
	gr=1;
      else gr = ls->groesse()+rs->groesse();
    }

  ps_node(ps_item p)
    { x_val = p->x_value();
      y_val = p->y_value();
      split_val[0] = p->split_value_x();
      split_val[1] = p->split_value_y();
      gr = p->groesse();
      sohn[left] = p->sohn[left];
      sohn[right] = p->sohn[right];
    }

  LEDA_MEMORY(ps_node)
      
}; 


// -------------------------------------------------------
// class ps_tree     
// -------------------------------------------------------

class ps_tree {

  ps_item root;
  int   anzahl; 
  float alpha;
  float d;
  b_stack<ps_item> st;

  friend class ps_node;

  void  lrot(ps_item , ps_item ); 
  void  rrot(ps_item , ps_item ); 
  void  ldrot(ps_item , ps_item ); 
  void  rdrot(ps_item , ps_item ); 

  ps_item sink(ps_item, x_typ , x_typ);
  void fill(ps_item);
  void delleaf(ps_item);
  void deltree(ps_item);
   
  ps_item search(x_typ, x_typ);
  ps_item locate(x_typ, x_typ);

  void enumerate(x_typ, x_typ, x_typ, ps_item);
  void pr_ps_tree(ps_item, int);
  pair_item min_x_in_rect(x_typ ,x_typ ,x_typ ,ps_item);
  pair_item max_x_in_rect(x_typ ,x_typ ,x_typ ,ps_item);
  pair_item min_y_in_xrange(x_typ ,x_typ ,ps_item);

public:

  virtual int cmp(x_typ x,x_typ y) { return int(x)-int(y); }
  virtual int cmp(x_typ x1,x_typ y1,x_typ x2,x_typ y2) 
                                   { if (int(x1)==int(x2))
                                        return int(y1)-int(y2); 
                                     else return int(x1)-int(x2); }

  x_typ   x_value(ps_item it)      { return (it) ? it->x_value() : 0 ; }
  x_typ   y_value(ps_item it)      { return (it) ? it->y_value() : 0 ; }
  x_typ   split_value_x(ps_item it)  { return (it) ? it->split_value_x() : 0 ; }
  x_typ   split_value_y(ps_item it)  { return (it) ? it->split_value_y() : 0 ; }
 
  ps_item insert(x_typ ,x_typ );
  ps_item del(x_typ ,x_typ );
     
  pair_item min_x_in_rect(x_typ x1,x_typ x2,x_typ y0) 
                         { return min_x_in_rect(x1,x2,y0,root); }
  pair_item max_x_in_rect(x_typ x1,x_typ x2,x_typ y0)
                         { return max_x_in_rect(x1,x2,y0,root); }
  pair_item min_y_in_xrange(x_typ x1,x_typ x2)
                           { return min_y_in_xrange(x1,x2,root); }

  void enumerate(x_typ x1,x_typ x2,x_typ y0) { enumerate(x1,x2,y0,root); }

  void pr_ps_tree() { pr_ps_tree(root,0); }

  ps_tree()   :  st(BSTACKSIZE) 
  { root = 0;
    anzahl = 0;
    alpha=0.28;
    d=1/(2-alpha);
   }

  virtual ~ps_tree()  
  { if (root)
    { deltree(root);
      delete(root);
     } 
    root = 0; 
    anzahl = 0;
    alpha = 0;
    d = 0;
   }

};


//------------------------------------------------------------------

#endif
