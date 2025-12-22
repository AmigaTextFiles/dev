/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  bb_tree.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#ifndef LEDA_BB_TREE_H
#define LEDA_BB_TREE_H

//------------------------------------------------------------------------------
//
// bb_tree:  
//
//           derived from class "bin_tree"
//
// Ijon Tichy (1993)
//
//------------------------------------------------------------------------------


#include <LEDA/basic.h>
#include <LEDA/impl/bin_tree.h>

 
typedef bin_tree_node* bb_tree_item;

 
// ----------------------------------------------------------------
// class bb_tree
// ----------------------------------------------------------------

// const float alpha = 0.28;
// const float d     = 0.58;

// we multiply alpha, d, and all balances by 64 to make them integers

  const int alpha = 18; // 0.28 * 64
  const int d = 37;     // 0.58 * 64

class bb_tree : public virtual bin_tree
{ 

  int root_balance() { return 2; }
  int node_balance() { return 2; }
  int leaf_balance() { return 1; }

  void rebal(bb_tree_item,int);
  void insert_rebal(bb_tree_item);
  void del_rebal(bb_tree_item, bb_tree_item);


  float balance(bb_tree_item p)
  { if (p->is_leaf()) 
       return 0.5 ;
    else 
       return float(p->child[left]->get_bal())/p->get_bal();
   }

public:

  bb_tree() {}
 ~bb_tree() {}

  bb_tree(const bb_tree& T) : bin_tree(T) {}

  bb_tree& operator=(const bb_tree& T) 
  { bin_tree::operator=(T); return *this; }

};

#endif
