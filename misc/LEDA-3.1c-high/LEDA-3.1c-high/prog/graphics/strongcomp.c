#include <LEDA/graph_alg.h>
#include <LEDA/graph_edit.h>
#include <LEDA/array.h>


int STRONG(graph& G, node_array<int>& compnum)
{ 
  node v,w;
  int n = G.number_of_nodes();
  int count = 0;

  array<node> V(1,n);
  list<node>  S;

  node_array<int>  dfs_num(G);
  node_array<int>  compl_num(G);
  node_array<bool> reached(G,false);

  DFS_NUM(G,dfs_num,compl_num);

  forall_nodes(v,G) V[compl_num[v]] = v;

  G.rev();

  for(int i = n; i > 0; i--)
   { if ( ! reached[V[i]] ) 
     { S = DFS(G,V[i],reached);
       forall(w,S) compnum[w] = count;
       count++;
      }
    }

 return count;
   
}



main()
{
  GRAPH<point,int>  G;

  window W;


  for(;;)
  { 
    graph_edit(W,G);

    node_array<int> comp_num(G);

    STRONG(G,comp_num);

    node v;
    forall_nodes(v,G)
    { int i = comp_num[v];
       W.draw_int_node(G[v],i,i%16);
     }

   if (W.read_mouse() == 3) break;

  }

  return 0;

}

