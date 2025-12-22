#include <LEDA/planar_map.h>
#include <LEDA/graph_alg.h>



main()

{  GRAPH<int,int> G;
   node v;
   edge e;

   test_graph(G);

   edge_array<edge> rev(G);
   Is_Bidirected(G,rev);

   list<edge> L;
   forall_edges(e,G) if (rev[e] == nil) L.append(e);

   forall(e,L) G.new_edge(target(e),source(e));

   if (!PLANAR(G))
   { cerr << "G is not planar!\n";
     exit(1);
    }

   int count = 0;
   forall_nodes(v,G) G[v] = count++;
   count = 0;
   forall_edges(e,G) G[e] = count++;

   G.print("G = ");

   PLANAR_MAP<int,int>  M(G);

   M.print();


   face f;

   count = 0;

   list<face> FL = M.all_faces();
   forall(f,FL) 
   { cout << string("F%d (%d): ",count++,M.inf(f));
     list<node> L1 = M.adj_nodes(f);
     forall(v,L1) M.print_node(v);
     newline;
     newline;
    }

/*
   M.triangulate();


   count = 0;
   FL= M.all_faces();
   forall(f,FL) 
   { cout << string("F%d (%d): ",count++,M.inf(f));
     list<node> L1 = M.adj_nodes(f);
     forall(v,L1) M.print_node(v);
     newline;
     newline;
    }
*/

while( Yes("split faces ? ") )
{
   FL= M.all_faces();
   count = 0;
   forall(f,FL)  M.new_node(f,--count);

   count = 0;
   FL= M.all_faces();
   forall(f,FL) 
   { cout << string("F%d (%d): ",count++,M.inf(f));
     list<node> L1 = M.adj_nodes(f);
     forall(v,L1) M.print_node(v);
     newline;
     newline;
    }
}


   list<edge> E;
   edge_array<bool> marked(M,false);

   forall_edges(e,M)
    if (!marked[e])
    { E.append(e);
      marked[M.reverse(e)] = true;
     } 


   forall(e,E)
   { Yes("del_edge ");
     M.del_edge(e);
     count = 0;
     FL= M.all_faces();
     forall(f,FL) 
     { cout << string("F%d (%d): ",count++,M.inf(f));
       list<node> L1 = M.adj_nodes(f);
       forall(v,L1) M.print_node(v);
       newline;
       newline;
      }

  }

}
