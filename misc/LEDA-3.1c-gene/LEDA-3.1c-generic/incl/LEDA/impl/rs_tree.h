/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  rs_tree.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_RS_TREE_H
#define LEDA_RS_TREE_H

//------------------------------------------------------------------------------
//
// rs_tree:  
//
//           derived from class "bin_tree"
//
// Ijon Tichy (1993)
//
//------------------------------------------------------------------------------


#include <LEDA/basic.h>
#include <LEDA/impl/bin_tree.h>

 
typedef bin_tree_node* rs_tree_item;

 
// ----------------------------------------------------------------
// class rs_tree
// ----------------------------------------------------------------

class rs_tree : public virtual bin_tree
{ 
  int root_balance() { return random(); }
  int node_balance() { return random(); }
  int leaf_balance() { return 0; }

  void insert_rebal(rs_tree_item);
  void del_rebal(rs_tree_item, rs_tree_item);


public:

 rs_tree() {}
~rs_tree() {}
 rs_tree(const rs_tree& T) : bin_tree(T) {}
 rs_tree& operator=(const rs_tree& T) { bin_tree::operator=(T); return *this; }

};

#endif


