/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _g_misc.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/graph.h>
#include <LEDA/ugraph.h>




node_array<int>* num_ptr;
  
int epe_source_num(const edge& e) { return (*num_ptr)[source(e)]; }
int epe_target_num(const edge& e) { return (*num_ptr)[target(e)]; }


bool Is_Simple(graph& G)  
{ 
  // return true iff G is simple, i.e, has no parallel edges
 
  list<edge>el= G.all_edges();
  node v;
  
  edge e;
  int n= 0;
  
  node_array<int> num(G);
  forall_nodes(v,G) num[v]= n++;
  
  num_ptr= &num;
  
  el.bucket_sort(0,n-1,&epe_source_num);
  el.bucket_sort(0,n-1,&epe_target_num);
  
  int i= -1;
  int j= -1;
  
  forall(e,el)
  { if(j==num[source(e)]&&i==num[target(e)])
    return false;
    else
    { j= num[source(e)];
      i= num[target(e)];
    }
  }
  return true;
  
}
  
  
  

void Make_Simple(graph& G)
{ 
  //use bucket sort to find and eliminate parallel edges
  
  list<edge> el = G.all_edges();
  node v;
  edge e;
  int  n = 0;

  node_array<int> num(G);
  forall_nodes(v,G) num[v] = n++;
  
  num_ptr = &num;

  el.bucket_sort(0,n-1,&epe_source_num);
  el.bucket_sort(0,n-1,&epe_target_num);
  
  int i = -1;
  int j = -1; 
  forall(e,el)  
    { if (j==num[source(e)] && i==num[target(e)]) 
        G.del_edge(e);
      else 
        { j=num[source(e)];
          i=num[target(e)];
         }
     }
  
 }




static int edge_ord1(const edge& e) { return index(source(e)); }
static int edge_ord2(const edge& e) { return index(target(e)); }

bool Is_Bidirected(const graph& G, edge_array<edge>& reversal)     
{
 // computes for every edge e = (v,w) in G its reversal reversal[e] = (w,v)
 // in G ( nil if not present). Returns true if every edge has a
 // reversal and false otherwise.

  int n = G.max_node_index();
  int count = 0;

  edge e,r;

  forall_edges(e,G) reversal[e] = 0;

  list<edge> El = G.all_edges();
  El.bucket_sort(0,n,&edge_ord2);
  El.bucket_sort(0,n,&edge_ord1);
  
  list<edge> El1 = G.all_edges();
  El1.bucket_sort(0,n,&edge_ord1);
  El1.bucket_sort(0,n,&edge_ord2);


  // merge El and El1 to find corresponding edges

  while (! El.empty() && ! El1.empty())
  { e = El.head();
    r = El1.head();

    if (target(r) == source(e))
      if (source(r) == target(e))
         { reversal[e] = r;
           El1.pop();
           El.pop();
           count++;
          }
      else
         if (index(source(r)) < index(target(e)))
             El1.pop();
         else
             El.pop();

    else
      if (index(target(r)) < index(source(e)))
          El1.pop();
      else
          El.pop();

    }

  return (count == G.number_of_edges()) ? true : false;

}


