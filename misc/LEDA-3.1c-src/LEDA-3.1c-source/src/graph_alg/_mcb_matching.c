/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _mcb_matching.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/*******************************************************************************
*                              
*  MAX_CARD_BIPARTITE_MATCHING  
*
*  Maximum Cardinality Bipartite Matching
*
*  Implementation of the Hopcroft/Karp algorithm
*
*  J.E. Hopcrof and R.M. Karp 
*  An n^2.5 Algorithm for Maximum Matchings in Bipartite Graphs, 
*  SIAM Journal of Computing, Vol. 2, No. 4, 1973, 225-231
*
*  running time: O(|E|*sqrt(|V|))
*                             
*******************************************************************************/


#include <LEDA/graph_alg.h>
#include <LEDA/b_queue.h>



static int mark;


static edge find_next_augmenting_path(graph& G, node s, node t,
                                      node_array<edge>& pred,
                                      edge_array<int>& layered)
{ node w;
  edge e;
  edge f=0;

  while (f==0 && G.next_adj_edge(e,s))
    if (layered[e]==mark)               // e is edge of layered network
      if ((w=target(e))==t) f=e;        // t is reached
      else  if (pred[w]==0)             // w not reached before 
            { pred[w] = e;
              f = find_next_augmenting_path(G,w,t,pred,layered);
             }
  return f;
} 



static bool bfs(graph& G, node s,node t,edge_array<int>& layered)
{ 
  node_array<int> dist(G,-1);
  b_queue<node> Q(G.number_of_nodes());
  node v,w;
  edge e;

  Q.append(s);
  dist[s] = 0;

  while (!Q.empty())
  { v = Q.pop();
    if (v==t) return true;
    int dv = dist[v];
    forall_adj_edges(e,v)
    { w = target(e);
      if (dist[w] < 0) 
      { Q.append(w); 
        dist[w] = dv+1;
       }
      if (dist[w] == dv+1) layered[e] = mark;
     }
   }
  return false;
}

  
  
list<edge> MAX_CARD_BIPARTITE_MATCHING(graph& G)
{ list<node> A,B;
  node v;

  forall_nodes(v,G)
  if (G.outdeg(v) > 0) 
     A.append(v);
  else 
     if (G.indeg(v) > 0) B.append(v);

  return MAX_CARD_BIPARTITE_MATCHING(G,A,B); 
}

list<edge> MAX_CARD_BIPARTITE_MATCHING(graph& G, const list<node>& A, 
                                                 const list<node>& B )
{ // G is a bipartite graph with sides A and B, all edges must be directed 
  // from A to B. We compute a matching of maximum cardinality using the 
  // algorithm of Hopcroft and Karp. The running time is O(sqrt(n)*m).

node v;
edge e;

forall(v,B) 
 { forall_adj_edges(e,v) 
      error_handler(1,"mcb_matching: edge from B to A.");
  }



// heuristic for initial matching
forall_edges(e,G)
  if (G.indeg(source(e))==0 && G.outdeg(target(e)) ==0) G.rev_edge(e);

list<edge> EL;

node s = G.new_node();
node t = G.new_node();

node_array<edge> pred(G,0); 

forall(v,A) if (G.indeg(v)==0) G.new_edge(s,v);
forall(v,B) if (G.outdeg(v)==0) G.new_edge(v,t);

edge_array<int> layered(G,0);
mark = 1;

G.reset();

for(;;)
{ forall_nodes(v,G) pred[v] = 0;
  mark++;


  if (bfs(G,s,t,layered))  
  {
    // there is at least one augmenting path

    while (e = find_next_augmenting_path(G,s,t,pred,layered)) EL.append(e); 

    G.reset();
    while (!EL.empty())
    { edge e=EL.pop();
      edge x = pred[source(e)];
      while (source(x) != s)
      { G.rev_edge(x);
        x=pred[target(x)];
       }
      G.del_edge(e);  // edge into t
      G.del_edge(x);  // edge out of s
     } 
   }
  else break;
} 

list<edge> result;

forall(v,B) 
{ forall_adj_edges(e,v) 
     if (target(e) != t) 
        result.append(e);
     else
        EL.append(e);
 }

//restore graph:
forall(e,EL) G.del_edge(e);
forall(e,result) G.rev_edge(e);
G.del_node(s);
G.del_node(t);

return result;
}

