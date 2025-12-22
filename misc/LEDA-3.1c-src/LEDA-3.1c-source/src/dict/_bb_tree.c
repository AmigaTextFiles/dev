/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _bb_tree.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/impl/bb_tree.h>


void bb_tree::rebal(bb_tree_item v, int delta)
{
  while ( v != root() )
  { 
    bb_tree_item u = v->parent;
    bb_tree_item l = u->child[left];
    bb_tree_item r = u->child[right];

    int bu  = u->get_bal() + delta;      // increase/decrease weight of u
    int bl  = l->get_bal();
    int br  = r->get_bal();

    u->set_bal(bu);

    if (64*bl < bu*alpha)
       { int brl = r->child[left]->get_bal();
         if (64*brl <=  d * br) 
            { rotation(u,r,right);
              r->set_bal(bu);
              u->set_bal(bl + brl);
              v = r;
             }
         else 
            { bb_tree_item w = r->child[left];
              int bwl = w->child[left]->get_bal();
              double_rotation(u,r,w,right);
              w->set_bal(bu);
              u->set_bal(bl + bwl);
              r->set_bal(br - bwl);
              v = w;
             }
        }
    else 
       if (64*br < bu*alpha) 
       { int bll = l->child[left]->get_bal();
         if (64*bll >  d * bl) 
              { rotation(u,l,left);
                l->set_bal(bu);
                u->set_bal(bu - bll);
                v = l;
               }
	   else 
              { bb_tree_item w = l->child[right];
                int bwr = w->child[right]->get_bal();
                double_rotation(u,l,w,left);
                w->set_bal(bu);
                u->set_bal(br + bwr);
                l->set_bal(bl - bwr);
                v = w;
               }
        }

        else v = u;
       
   }

}



void bb_tree::insert_rebal(bb_tree_item v) { rebal(v,1); }

void bb_tree::del_rebal(bb_tree_item v, bb_tree_item) { rebal(v,-1); }


