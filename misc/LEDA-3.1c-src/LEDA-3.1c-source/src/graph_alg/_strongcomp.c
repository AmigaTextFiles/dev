/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _strongcomp.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



/*******************************************************************************
*                                                                              *
*  STRONG_COMPONENTS (strong connected components)                             *
*                                                                              *
*******************************************************************************/


#include <LEDA/graph_alg.h>

static void scc_dfs(const graph& G, node v, node_array<int>& compnum,
                                            node_data<int>& dfsnum,
                                            node_list& unfinished,
                                            list<node>& roots,
                                            int& count1, int& count2 );


int STRONG_COMPONENTS(const graph& G, node_array<int>& compnum)
{
  // int STRONG_COMPONENTS(graph& G, node_array<int>& compnum)
  // computes strong connected components (scc) of digraph G
  // returns m = number of scc 
  // returns in node_array<int> compnum for each node an integer with
  // compnum[v] = compnum[w] iff v and w belong to the same scc
  // 0 <= compnum[v] <= m-1 for all nodes v

  list<node>     roots;
  node_list      unfinished;
  node_data<int> dfsnum(G,-1);

  int count1 = 0; 
  int count2 = 0;

  node v;

  forall_nodes(v,G) 
      if (dfsnum[v] == -1) 
       scc_dfs(G,v,compnum,dfsnum,unfinished,roots,count1,count2);

  return count2;
}


static void scc_dfs(const graph& G, node v, node_array<int>& compnum,
                                            node_data<int>& dfsnum,
                                            node_list& unfinished,
                                            list<node>& roots,
                                            int& count1, int& count2 )
{
  node w;

  dfsnum[v] = ++count1;
  unfinished.push(v);
  roots.push(v);

  forall_adj_nodes(w,v)
    { if (dfsnum[w]==-1) 
       scc_dfs(G,w,compnum,dfsnum,unfinished,roots,count1,count2);
      else 
       if (unfinished(w))
        while (dfsnum[roots.head()]>dfsnum[w])  roots.pop();
     }

  if (v==roots.head()) 
   { do { w=unfinished.pop();
          /* w is an element of the scc with root v */
          compnum[w] = count2;
         } while (v!=w);
     count2++;
     roots.pop(); 
    }
}



int STRONG_COMPONENTS1(graph& G, node_array<int>& compnum)
{ 
  node v,w;
  int n = G.number_of_nodes();
  int count = 0;

  node* V = new node[n+1];

  list<node> S;
  node_array<int> dfs_num(G);
  node_array<int> compl_num(G);
  node_array<bool> reached(G,false);

  DFS_NUM(G,dfs_num,compl_num);

  forall_nodes(v,G) V[compl_num[v]] = v;

  G.rev();

  for(int i=n; i>0; i--)
   { if ( !reached[V[i]] ) 
      { S = DFS(G,V[i],reached);
        forall(w,S) compnum[w] = count;
        count++;
       }
    }

 delete V;

 return count;
   
 }

