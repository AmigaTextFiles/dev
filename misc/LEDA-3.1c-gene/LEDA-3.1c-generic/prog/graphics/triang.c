#include <LEDA/plane.h>
#include <LEDA/d_array.h>
#include <LEDA/graph.h>
#include <LEDA/window.h>

window W;

void TRIANG(list<point> L, GRAPH<point,int>& G)
{ 
  if (L.length() < 3) return;

  list<point> CH;
  list_item last;

  L.sort();  // sort points lexicographically

  d_array<point,node> V(nil);



  // initialize convex hull with first two points

  point p = L.pop();
  V[p] = G.new_node(p);
  CH.append(p);

  while (L.head() == p) L.pop();
  point q = L.pop();
  last = CH.append(q);
  V[q] = G.new_node(q);

  G.new_edge(V[p],V[q]);


  // scan remaining points

  forall(p,L)
  {
    if (p == CH[last]) continue;  // multiple point

    node v = G.new_node(p);

    V[p] = v;

    G.new_edge(v,V[CH[last]]);

    // compute upper tangent (p,up)

    list_item up = last;
    list_item it = CH.cyclic_succ(up);

    while (left_turn(CH[it],CH[up],p))
    { up = it;
      it = CH.cyclic_succ(up);
      G.new_edge(v,V[CH[up]]);
     }


    // compute lower tangent (p,low)

    list_item low = last;
    it = CH.cyclic_pred(low);

    while (right_turn(CH[it],CH[low],p))
    { low = it;
      it = CH.cyclic_pred(low);
      G.new_edge(v,V[CH[low]]);
     }


    // remove all points between up and low

    if (up != low)
    { it = CH.cyclic_succ(low);

      while (it != up)
      { CH.del(it);
        it = CH.cyclic_succ(low);
       }
     }

    // insert new point

    last = CH.insert(p,low);

   }

}
     


main()
{
  //window W;
  W.init(-100,100,-100);
  W.set_node_width(5);

  int N = 500;

  panel P("triangulation");

  P.int_item("# points",N,1,2000);
  int b1 = P.button("mouse");
  int b2 = P.button("random");
  int b3 = P.button("quit");

  for(;;)
  { 
    list<point> L;
    point p,q;

    int but = P.open();

    W.clear();

    if (but == b1)
      while (W >> p)
      { W.draw_point(p,blue);
        L.append(p);
       }

    if (but == b2)
      for(int i = 0; i<N; i++) 
      { point p(random(-90,90),random(-90,90));
        W.draw_point(p,blue);
        L.append(p);
       }

    if (but == b3) break;
  
    GRAPH<point,int> G;
    TRIANG(L,G);
  
    edge e;
    forall_edges(e,G)
       W.draw_segment(G[source(e)],G[target(e)],violet);
  }
   
 return 0;
}

