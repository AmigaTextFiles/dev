#include <LEDA/plane.h>
#include <LEDA/window.h>

window W;

list<point> C_HULL(list<point> L)
{ 
  if (L.length() < 3) return L;

  list<point> CH;
  list_item last;
  point p;

  L.sort();  // sort points lexicographically


  // initialize convex hull with first two points

  p = L.pop();
  CH.append(p);
  while (L.head() == p) L.pop();
  last = CH.append(L.pop());


  // scan remaining points

  forall(p,L)
  {
    if (p == CH[last]) continue;  // multiple point

    // compute upper tangent (p,up)

    list_item up = last;
    list_item it = CH.cyclic_succ(up);

    while (left_turn(CH[it],CH[up],p))
    { up = it;
      it = CH.cyclic_succ(up);
     }


    // compute lower tangent (p,low)

    list_item low = last;
    it = CH.cyclic_pred(low);

    while (right_turn(CH[it],CH[low],p))
    { low = it;
      it = CH.cyclic_pred(low);
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

  return CH;
}
     


main()
{
  //window W;
  W.init(-100,100,-100);
  W.set_node_width(5);

  int N = 500;

  panel P("convex hull");

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
  
    list<point> C = C_HULL(L);
  
    p = C.tail();
  
    forall(q,C) 
    { W.draw_segment(p,q,violet);
      W.draw_filled_node(q,violet);
      p = q;
     }
  }
   
 return 0;
}

