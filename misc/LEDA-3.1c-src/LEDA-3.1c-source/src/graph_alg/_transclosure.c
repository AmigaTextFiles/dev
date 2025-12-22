/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _transclosure.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



/*******************************************************************************
*                                                                              *
*  TRANSITIVE_CLOSURE (transitive closure)                                     *
*                                                                              *
*******************************************************************************/

#include <LEDA/graph_alg.h>

typedef list<node>* nodelist_ptr;




static void acyclic_transitive_closure(graph& G)
{ // computes transitive closure of acyclic graph G

node v,w;

int i,j,k,h;
int n = G.number_of_nodes();

TOPSORT1(G); 

node_array<int> marked(G);
node_array<int> top_ord(G);   // topologic order
node_array<int> chain(G);     // chain[v] = i  iff  v in C[i]

node_list* C = new node_list[n+1];  // chains C[0], C[1], ...

node*      N = new node[n];         // N[i] = i-th node in topological order

int**      reach = new int*[n];     // reach[h][i] = min { j ; N[j] in C[h] and
                                    // there is a path from N[i] to N[j] }


for(i=0; i<n; i++) reach[i] = new int[n];

i=0;
forall_nodes(v,G) { marked[v]=1; top_ord[v] = i; N[i]=v; i++; }

// compute chain decomposition C[0], C[1], ..., C[k]

k=0;
forall_nodes(v,G) 
 { node v0 = v;
   if (marked[v0])
    {  C[k].append(v0);  
       chain[v0]=k;
       while (v0 != nil)
       { node u = nil;
         forall_adj_nodes(w,v0) 
           if (marked[w]) 
           {  u = w;
              break; 
            }

         if (u != nil) 
         { marked[u]=0;
           chain[u]=k;
           C[k].append(u);
          }
         v0=u;
        }
       k++;
    }
  }
k--;


for(h=0; h<n; h++)
  for(i=0; i<n; i++)
    reach[h][i] = n+1;

Forall_nodes(v,G)       //decreasing order
{ i=top_ord[v];
  forall_adj_nodes(w,v) //increasing order
  { j=top_ord[w];
    if (j <= reach[chain[w]][j])
     for(h=0; h<=k; h++)
       if (reach[h][j] < reach[h][i]) reach[h][i] = reach[h][j];
  }
  reach[chain[v]][i] = i;
}


G.del_all_edges();

forall_nodes(v,G)
  for(i=0; i<=k; i++)
    { j = reach[i][top_ord[v]];
      if ( j < n+1 )
        for(w = N[j]; w != nil; w = C[i].succ(w)) G.new_edge(v,w);
     }


for(i=0; i<=k; i++) C[i].clear();
delete[] C;

for(i=0; i<n; i++) delete reach[i];
delete reach;

delete N;

}


graph TRANSITIVE_CLOSURE(const graph& G0)
{
  node v,w;
  edge e;
  int i,j;

  graph G = G0;

  node_array<int> compnum(G);
  int k = STRONG_COMPONENTS(G,compnum);

/* reduce graph G to graph G1 = (V',E') 
   with V' = { V[0],V[1],...,V[k] } = set of scc's of G
   and (V[i],V[j]) in E' iff there is an edge from V[i] to V[j] in G

   G1.inf(V[i]) = set of nodes v in G with v in scc i (i.e. compum[v] = i)
*/

  GRAPH<nodelist_ptr,int> G1;

  node*  V = new node[k];

  for(j=0; j < k; j++) V[j] = G1.new_node(new list<node>);

  forall_nodes(v,G) 
  { int i = compnum[v];
    G1[V[i]]->append(v);
   }
  
  forall_edges(e,G)
  { i = compnum[source(e)];
    j = compnum[target(e)];
    if (i!=j) G1.new_edge(V[i],V[j]);
   }

  eliminate_parallel_edges(G1);
  
  // compute transitive closure of acyclic graph G1

  acyclic_transitive_closure(G1);

  G.del_all_edges();
  
  list_item x,y;

  forall_nodes(v,G1)
  { list<node>* plv = G1[v];
    forall_adj_nodes(w,v)
       forall_items(x,*plv)
          forall_items(y,*(G1[w])) G.new_edge(plv->inf(x),G1[w]->inf(y));
   }
  
   forall_nodes(v,G1) delete G1[v];
  
   delete V;

   return G;
}

