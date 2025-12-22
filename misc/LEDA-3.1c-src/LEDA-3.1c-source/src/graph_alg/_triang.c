/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _triang.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



/******************************************************************************
*                                                                              *
*  TRIANGULATE_PLANAR_MAP  (triangulation)                                     *
*                                                                              *
*******************************************************************************/

#include <LEDA/graph_alg.h>

#define NEXT_FACE_EDGE(e) G.cyclic_adj_pred(REV[e]) 

list<edge> TRIANGULATE_PLANAR_MAP(graph& G)
{ 

/* G is a planar map. This procedure triangulates all faces of G
   without introducing multiple edges. The algorithm was suggested by 
   Christian Uhrig and Torben Hagerup. 

   Description:

   Triangulating a planar graph G, i.e., adding edges
   to G to obtain a chordal planar graph, in linear time:
   
   1) Compute a (combinatorial) embedding of G.
   
   2) Step through the vertices of G. For each vertex u,
   triangulate those faces incident on u that have not
   already been triangulated. For each vertex u, this
   consists of the following:
   
     a) Mark the neighbours of u. During the processing
   of u, a vertex will be marked exactly if it is a
   neighbour of u.
   
     b) Process in any order those faces incident on u
   that have not already been triangulated. For each such
   face with boundary vertices u=x_1,...,x_n,
        I)   If n=3, do nothing; otherwise
        II)  If x_3 is not marked, add an edge {x_1,x_3},
             mark x_3 and continue triangulating the face
             with boundary vertices x_1,x_3,x_4,...,x_n.
        III) If x_3 is marked, add an edge {x_2,x_4} and
             continue triangulating the face with boundary
             vertices x_1,x_2,x_4,x_5,...,x_n.
   
     c) Unmark the neighbours of x_1.
   
   Proof of correctness:
   
   A) All faces are triangulated.
   This is rather obvious.
   
   B) There will be no multiple edges.
   During the processing of a vertex u, the marks on
   neighbours of u clearly prevent us from adding a multiple
   edge with endpoint u. After the processing of u, such an
   edge is not added because all faces incident on u have
   been triangulated. This takes care of edges added in
   step II).
   Whenever an edge {x_2,x_4} is added in step III), the
   presence of an edge {x_1,x_3} implies, by a topological
   argument, that x_2 and x_4 are incident on exactly one
   common face, namely the face currently being processed.
   Hence we never add another edge {x_2,x_4}.
*/
   
  node v;
  edge x;
  list<edge> L;

  node_array<int>  marked(G,0);

  edge_array<edge> REV(G, 3*G.number_of_edges(), nil);

  if ( !compute_correspondence(G,REV)) 
  error_handler(1,"TRIANGULATE_PLANAR_MAP: graph is not symmetric");

  forall_nodes(v,G)
  {
    list<edge> El = G.adj_edges(v);
    edge e,e1,e2,e3;
 
    forall(e,El) marked[target(e)]=1;

    forall(e,El)
    { 
      e1 = e;
      e2 = NEXT_FACE_EDGE(e1);
      e3 = NEXT_FACE_EDGE(e2);

      while (target(e3) != v)
      // e1,e2 and e3 are the first three edges in a clockwise 
      // traversal of a face incident to v and t(e3) is not equal
      // to v.
       if ( !marked[target(e2)] )
        { // we mark w and add the edge {v,w} inside F, i.e., after
          // dart e1 at v and after dart e3 at w.
 
          marked[target(e2)] = 1;
          L.append(x  = G.new_edge(e3,source(e1)));
          L.append(e1 = G.new_edge(e1,source(e3)));
          REV[x] = e1;
          REV[e1] = x;
          e2 = e3;
          e3 = NEXT_FACE_EDGE(e2);
        }
        else
        { // we add the edge {source(e2),target(e3)} inside F, i.e.,
          // after dart e2 at source(e2) and before dart 
          // reversal_of[e3] at target(e3).

          e3 = NEXT_FACE_EDGE(e3); 
          L.append(x  = G.new_edge(e3,source(e2)));
          L.append(e2 = G.new_edge(e2,source(e3)));
          REV[x] = e2;
          REV[e2] = x;
        }
     //end of while

    } //end of stepping through incident faces

   node w; forall_adj_nodes(w,v) marked[w] = 0;

  } // end of stepping through nodes

return L;

}
