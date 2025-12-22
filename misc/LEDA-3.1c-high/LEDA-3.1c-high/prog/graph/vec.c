#include <LEDA/ugraph.h>
#include <LEDA/vector.h>
#include <LEDA/matrix.h>





main()
{  
   UGRAPH<matrix,vector> G;
   node v;
   edge e;
   int i = 0;

   test_ugraph(G);

   matrix mat(2,7);

   G.new_node(mat);

   G.print("G = ");
   newline;


  vector vec(-1,2.7,3.14);

  node_array<matrix> M(G);

  edge_array<vector> V(G,vec);

   forall_nodes(v,G) 
   { M[v] = G[v] = matrix(i,i);
     i++;
    }

   forall_edges(e,G)  G[e] = V[e];


   G.print("G = ");
   newline;
   G.write();

   return 0;
}

