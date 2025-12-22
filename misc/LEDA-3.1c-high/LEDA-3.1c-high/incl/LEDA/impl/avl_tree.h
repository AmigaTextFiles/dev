/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  avl_tree.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_AVL_TREE1_H
#define LEDA_AVL_TREE1_H

//------------------------------------------------------------------------------
//
// avl_tree  
//
//           derived from "bin_tree"
//
// Ijon Tichy (1993)
//
//------------------------------------------------------------------------------



#include <LEDA/basic.h>
#include <LEDA/impl/bin_tree.h>
 
typedef bin_tree_node* avl_tree_item;

 
class avl_tree : public virtual bin_tree
{ 
  // balance of node v with right (left) subtree R (L)
  // bal(v) =  height(R) - height(L) in [-1 ... +1]
  //
  // all created nodes have balance 0

  int root_balance() { return 0; }
  int leaf_balance() { return 0; }
  int node_balance() { return 0; }

  void insert_rebal(avl_tree_item);
  void del_rebal(avl_tree_item, avl_tree_item);


public:

  avl_tree() {}
 ~avl_tree() {}

  avl_tree(const avl_tree& T) : bin_tree(T) {}

  avl_tree& operator=(const avl_tree& T) 
  { bin_tree::operator=(T); return *this; }

};

#endif


