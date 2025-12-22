/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _new_embed.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/graph_alg.h>


static void compute_labelling(const graph&G, node a, node b, node c, 
                              list<node>& L)
{
   node_array<bool> marked(G,false);  // marked[v] == true iff v adjacent to a
   node_array<int>  deg(G,0);         // deg[v] = # nodes adjacent to a and v

   list<node> cand;    // candidate list:  marked nodes  with deg <= 2

   int N = G.number_of_nodes();

   L.clear();

   marked[a] = true;
   marked[b] = true;
   marked[c] = true;

   deg[a] = N;
   deg[b] = N;
   deg[c] = N;
   
   node v,w;

   forall_adj_nodes(v,a)
   { marked[v] = true;
     forall_adj_nodes(w,v) deg[w]++;
    }

   forall_adj_nodes(v,a)
     if (deg[v] <= 2) cand.append(v);

   while (!cand.empty())
   { node u = cand.pop();
     if (deg[u] > 2) continue;
     L.push(u);
     deg[u] = N;
     forall_adj_nodes(v,u)
     { deg[v]--;
       if (!marked[v])  // v is new neighbor of a
       { marked[v] = true;
         if (deg[v] <= 2) cand.append(v);
         forall_adj_nodes(w,v) deg[w]++;
        }
       else            // v has been adjacent to a before
         if (deg[v] == 2) cand.append(v);
      }
    }
}



static void compute_realizer(const graph& G, node a, node b, node c,
                             list<node>& L, 
                             GRAPH<node,int>& T, node_array<node>& n)
{ node v;
  edge e,e_1,e_r;
  node_array<int> ord(G,0); 
  
  forall_nodes(v,G) n[v] = T.new_node(v);

   ord[b] = 0;
   ord[c] = 1;

   int i = 2;
   forall(v,L) ord[v] = i++;

   ord[a] = i;


  forall(v,L)
  { node vt = n[v];
    forall_adj_edges(e,v)
    { if (target(e) == a) T.new_edge(n[a],vt,1);
      if (ord[target(e)] > ord[v]) e_1 = e_r = e;
     }

    while (ord[target(e_1)] > ord[v]) e_1 = G.cyclic_adj_succ(e_1);
    while (ord[target(e_r)] > ord[v]) e_r = G.cyclic_adj_pred(e_r);

    T.new_edge(n[target(e_1)],vt,2);
    T.new_edge(n[target(e_r)],vt,3);

    for(e=G.cyclic_adj_succ(e_1); e != e_r; e = G.cyclic_adj_succ(e))
       T.new_edge(vt,n[target(e)],1);
   }
}


static void compute_subtree_sizes(const GRAPH<node,int>& T, int i, node r, 
                                  node_array<int>& s)
{ 
  // computes the size s[w] of all subtrees rooted at some node w in the
  // the subtree of $T_i$ rooted at node v

  int sum = 0;
  edge e;

  forall_adj_edges(e,r)
    if (T[e] == i)
    { node w = target(e);
      compute_subtree_sizes(T,i,w,s);
      sum += s[w];
     }
   s[r] = sum + 1;
}


void tree_prefix_sum(const GRAPH<node,int>& T, int i, node r, 
                     const node_array<int>& val,
                     node_array<int>& sum)
{
  // computes for every node $w$ in the subtree of $T_i$ rooted at node $r$
  // sum[w] = $\sum_{v\in P_i(w)} val[v]$, where $P_i$ is the path from $w$
  // to $r$ in $T_i$.

  list<node> Q(r);

  sum[r] = val[r];

  while (!Q.empty())
  { node v = Q.pop();
    edge e;
    forall_adj_edges(e,v)
      if (T[e] == i)
      { node w = target(e);
        Q.append(w);
        sum[w] = sum[v] + val[w];
       }
   }
}
  

int STRAIGHT_LINE_EMBEDDING2(graph& G,
                             node& a, node& b, node& c,
                             node_array<int>& xcoord,
                             node_array<int>& ycoord)
{
   int N = G.number_of_nodes();

   node u,v;
   edge e,r;

   list<edge> TL = TRIANGULATE_PLANAR_MAP(G);

   a = G.first_node();
   e = G.first_adj_edge(a);
   b = G.target(e);

   forall_adj_edges(r,b)
      if (G.target(r) == a) break;

   c = G.target(G.cyclic_adj_succ(r));


   list<node> L;

   compute_labelling(G,a,b,c,L);


   GRAPH<node,int> T;
   node_array<node> n(G);

   compute_realizer(G,a,b,c,L,T,n);

   node ta = n[a];
   node tb = n[b];
   node tc = n[c];

   node_array<int> t1(T);
   node_array<int> t2(T);
 //node_array<int> t3(T);

   node_array<int> p1(T);
 //node_array<int> p2(T);
   node_array<int> p3(T);

   node_array<int> r1(T);
   node_array<int> r2(T);
 //node_array<int> r3(T);


   compute_subtree_sizes(T,1,ta,t1);
   compute_subtree_sizes(T,2,tb,t2);
 //compute_subtree_sizes(T,3,tc,t3);

   node_array<int> val(T,1);

   tree_prefix_sum(T,1,ta,val,p1);
 //tree_prefix_sum(T,2,tb,val,p2);
   tree_prefix_sum(T,3,tc,val,p3);

   val.init(T,0);

   tree_prefix_sum(T,2,tb,t1,r1);
   tree_prefix_sum(T,3,tc,t1,val);
   forall_nodes(v,T) r1[v] += val[v] - t1[v] - p3[v] + 1;

   tree_prefix_sum(T,3,tc,t2,r2);
   tree_prefix_sum(T,1,ta,t2,val);
   forall_nodes(v,T) r2[v] += val[v] - t2[v] - p1[v] + 1;

 //tree_prefix_sum(T,1,ta,t3,r3);
 //tree_prefix_sum(T,2,tb,t3,val);
 //forall_nodes(v,T) r3[v] += val[v] - t3[v] - p2[v] + 1;

   
   forall_nodes(v,G)  
   { xcoord[v] = r1[n[v]];
     ycoord[v] = r2[n[v]];
    }

   xcoord[a] = N-1;
   ycoord[a] = 0;

   xcoord[b] = 0;
   ycoord[b] = N-1;

   xcoord[c] = 0;
   ycoord[c] = 0;


   // delete triangulation edges

   forall(e,TL) G.del_edge(e);

   return N-1; // maxcoord
}



int STRAIGHT_LINE_EMBEDDING2(graph& G,node_array<double>& x, node_array<double>& y)
{ node v;
  node_array<int> x0(G), y0(G);

  int result = STRAIGHT_LINE_EMBEDDING(G,x0,y0);

  forall_nodes(v,G) { x[v] = x0[v];
                      y[v] = y0[v]; }
  return result;
}
