/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _bicomponents.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



/*******************************************************************************
*                                                                              *
*  BICONNECTED COMPONENTS                                                      *
*                                                                              *
*  Michael Meiser (1991)                                                       *
*                                                                              *
*******************************************************************************/

#include <LEDA/graph_alg.h>
#include <LEDA/stack.h>



static void bcc_dfs(const ugraph& G,node v,edge_array<int>& compnum,
                    node_array<int>& dfsnum,node_array<int>& lowpt,
                    node_array<node>& father,stack<node>& current,
                    int& count1,int& count2);


int BICONNECTED_COMPONENTS(const ugraph& G, edge_array<int>& compnum)
{
  // computes the biconnected components of an undirected graph G
  // returns m = number of biconnected components
  // returns in edge_array<int> compnum for each edge an integer with
  // compnum[x] = compnum[y] iff edges x and y belong to the same component 
  // and 0 <= compnum[e] <= m-1 for all edges e
  //  running time : O(|V|+|E|)
  //
  // (problem  with self-loops ? )

  stack<node> current;
  node_array<int> dfsnum(G,-1);
  node_array<int> lowpt(G,0);
  node_array<node> father(G,nil);
  int count1 = 0; 
  int count2 = 0;
  node v;

  forall_nodes(v,G)
   if (dfsnum[v] == -1)
    {
     dfsnum[v] = ++count1;
     current.push(v);
     bcc_dfs(G,v,compnum,dfsnum,lowpt,father,current,count1,count2);
    }

  return(count2);

 } // BI_COMPONENTS



static void bcc_dfs(const ugraph& G,node v,edge_array<int>& compnum,
                    node_array<int>& dfsnum,node_array<int>& lowpt,
                    node_array<node>& father,stack<node>& current,
                    int& count1,int& count2)
 {
  node w;

  lowpt[v] = dfsnum[v];

  forall_adj_nodes(w,v)
   if (dfsnum[w] == -1)
    {
     dfsnum[w] = ++count1;
     current.push(w);
     father[w] = v;
     bcc_dfs(G,w,compnum,dfsnum,lowpt,father,current,count1,count2);
     lowpt[v] = Min(lowpt[v],lowpt[w]);
    }
   else
    lowpt[v] = Min(lowpt[v],dfsnum[w]);

  if (father[v] && (lowpt[v] == dfsnum[father[v]]))
   // 1.Bedingung nur von Bedeutung fuer Graphen,die nicht zusammen-
   // haengend sind sowie fuer den ersten besuchten Knoten
   {
    edge e;

    do
     {
      w = current.pop();
      forall_adj_edges(e,w)
       if (dfsnum[w] > dfsnum[G.opposite(w,e)])
        compnum[e] = count2;
     }
    while (w != v);

    count2++;
   }

 } // bcc_dfs


