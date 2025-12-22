/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _avl_tree.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/impl/avl_tree.h>


//----------------------------------------------------------------------------
//  avl_tree:
//
//  rebalancing routines for AVL trees
//
//----------------------------------------------------------------------------


void avl_tree::insert_rebal(avl_tree_item v)
{
  // preconditions:  v is new node created by insertion
  //                 v != root
  //                 height(v) == 1, bal(v) == 0;

  // bal(v) == height(R) - height(L)           

  //                    u
  //                    |
  //                    v
  //                   / \
  //                  L   R
  //

  
  while ( v != root() )
  {
    avl_tree_item u = v->parent;

    int dir = (v == u->child[left]) ? left : right;

    int b = u->get_bal();

    if (dir==left)   // insertion in left subtree of u 
       b--;
    else             // insertion in right subtree of u
       b++; 

    u->set_bal(b);

    if (b==0)  break;   // height of u has not changed 

    if (b != 1 && b != -1)
    { 
      // u is out of balance (-2 or + 2)

      int d = (b < 0) ? -1 : +1;
  
      avl_tree_item w = u->child[dir];
  
      if (w->get_bal() == d)
      { rotation(u,w,dir);
        u->set_bal(0);
        w->set_bal(0);
       }
      else
      { avl_tree_item x = w->child[1-dir];
        double_rotation(u,w,x,dir);

        if (x->get_bal() == d)
           u->set_bal(-d);
        else
           u->set_bal(0);
  
        if (x->get_bal() == -d)
           w->set_bal(d);
        else
           w->set_bal(0);
  
        x->set_bal(0);
       }
  
      break;
    }

    v = u;

  }

}


void avl_tree::del_rebal(avl_tree_item v, avl_tree_item)
{
  // precondition:    p is removed inner node
  //                  v is remaining child of p (already linked to parent u)
  //                  v != root

  
  while ( v != root() )
  {
    avl_tree_item u = v->parent;

    int dir = (v == u->child[left]) ? left : right;

    int b = u->get_bal();

    if (dir==left)  // deletion in left  subtree of u
       b++;
    else            // deletion in right subtree of u
       b--;

    u->set_bal(b);

    if (b == 1 || b == -1) break;   // height of u has not changed

    if (b != 0)
    { 
      // u is out of balance (-2 or + 2)

      int d = (b < 0) ? -1 : +1;
  
      avl_tree_item w = u->child[1-dir];
  
      if (d * w->get_bal() >= 0)
      { rotation(u,w,1-dir);
        if (w->get_bal() == 0)
          { u->set_bal(d);
            w->set_bal(-d);
            break;
           }
        else
          { u->set_bal(0);
            w->set_bal(0);
           }
        v = w;
       }
      else
      { avl_tree_item x = w->child[dir];
        double_rotation(u,w,x,1-dir);

        if (x->get_bal() == d)
           u->set_bal(-d);
        else
           u->set_bal(0);
  
        if (x->get_bal() == -d)
           w->set_bal(d);
        else
           w->set_bal(0);
  
        x->set_bal(0);
        v = x;
       }
    }

    else v = u;

  }
}
