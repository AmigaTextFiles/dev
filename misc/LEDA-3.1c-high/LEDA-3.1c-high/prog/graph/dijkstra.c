#define LEDA_CHECKING_OFF


#include <LEDA/graph_alg.h>
#include <LEDA/prio.h>




void dijkstra(graph& G, 
              node s, 
              edge_array<int>&  cost, 
              node_array<int>&  dist,
              node_array<edge>& pred,
              priority_queue<node,int>&   PQ)
{
  node_array<pq_item> I(G);
  node v;
                                                                               
  forall_nodes(v,G)
  { pred[v] = nil;
    dist[v] = MAXINT;
   }

  dist[s] = 0;
  I[s] = PQ.insert(s,0);

  while (! PQ.empty())
  { pq_item it = PQ.find_min();
    node u = PQ.key(it);
    int du = dist[u];
    edge e;
    forall_adj_edges(e,u)
    { v = G.target(e);
      int c = du + cost[e];
      if (c < dist[v])
      { if (dist[v] == MAXINT)
          I[v] = PQ.insert(v,c);
        else
          PQ.decrease_inf(I[v],c);
        dist[v] = c;
        pred[v] = e;
       }                                                                 
     }
    PQ.del_item(it);
   }
}


#include <LEDA/impl/k_heap.h>
#include <LEDA/impl/bin_heap.h>
#include <LEDA/impl/m_heap.h>
#include <LEDA/impl/p_heap.h>
#include <LEDA/impl/list_pq.h>

#if !defined(__TEMPLATE_ARGS_AS_BASE__)
declare3(_priority_queue,node,int,k_heap)
declare3(_priority_queue,node,int,bin_heap)
declare3(_priority_queue,node,int,m_heap)
declare3(_priority_queue,node,int,p_heap)
declare3(_priority_queue,node,int,list_pq)
#endif


main()
{
  GRAPH<int,int> G;

  for(;;)
  {

  int n = read_int("# nodes = ");
  int m = read_int("# edges = ");

  if (n==0) break;

  random_graph(G,n,m);

  edge_array<int>  cost(G);
  node_array<int>  dist0(G);
  node_array<int>  dist(G);
  node_array<edge> pred(G);

  int M = read_int("max edge cost = ");

  node s = G.choose_node();

  edge e;
  forall_edges(e,G) G[e] = cost[e] = random(0,M);

  priority_queue<node,int>* PQ[6];

  PQ[0] = new priority_queue<node,int>;

#if defined(__TEMPLATE_ARGS_AS_BASE__)
  PQ[1] = new _priority_queue<node,int,k_heap>(n);
  PQ[2] = new _priority_queue<node,int,m_heap>(M);
  PQ[3] = new _priority_queue<node,int,list_pq>;
  PQ[4] = new _priority_queue<node,int,p_heap>;
  PQ[5] = new _priority_queue<node,int,bin_heap>(n);
#else
  PQ[1] = new _priority_queue(node,int,k_heap)(n);
  PQ[2] = new _priority_queue(node,int,m_heap)(M);
  PQ[3] = new _priority_queue(node,int,list_pq);
  PQ[4] = new _priority_queue(node,int,p_heap);
  PQ[5] = new _priority_queue(node,int,bin_heap)(n);
#endif

  float T  = used_time();
  cout << "DIJKSTRA: ";
  cout.flush();
  DIJKSTRA(G,s,cost,dist0,pred);
  cout << string(" %6.2f sec\n",used_time(T));
  newline;

  for(;;)
  { int i = 
    read_int("0:f_heap 1:k_heap 2:m_heap 3:list_pq 4:p_heap 5:bin_heap --> ");

    if (i>5) break;

    float T  = used_time();
    dijkstra(G,s,cost,dist,pred,*(PQ[i]));

    cout << string("time: %6.2f sec\n",used_time(T));
    newline;

    node v;
    forall_nodes(v,G)
       if( dist[v] != dist0[v]) 
       { G.print_node(v);
         cout << string("   dist =  %d   dist0 = %d\n",dist[v],dist0[v]);
        }

   }

 }

 return 0;
}
