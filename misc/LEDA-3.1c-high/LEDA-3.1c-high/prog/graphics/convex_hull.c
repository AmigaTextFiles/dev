#include <LEDA/plane.h>
#include <LEDA/graph.h>
#include <LEDA/window.h>


struct p_edge {

segment   s;
list_item it;

};

typedef p_edge* p_edge_ptr;




GRAPH<p_edge_ptr,int> DAG;
list<node>            POL;



node NEW_NODE(segment s)
{ p_edge_ptr p = new p_edge;
  p->s =s;
  return DAG.new_node(p);
 }




node next_segment(segment s, node v )
{ node u = nil;
  node w;
  point Q;
  forall_adj_nodes(w,v)
    if (s.intersection(DAG[w]->s,Q)) 
    { u = w;
      break;
     }
  DAG.init_adj_iterator(v);
  return u;
}



main()
{ 

  window W;

  W.init(0,1000,0);


  point A,B,C;

  W >> A; W << A;
  W >> B; W << B;
  W >> C; W << C;

  // we start with a triangle

  segment sa(A,B);
  segment sb(B,C);
  segment sc(C,A);

  W << sa << sb << sc;

  if (sa.angle(sb) < 0) 
  { sa = segment(A,C);
    sb = segment(C,B);
    sc = segment(B,A);
   }

  node root = NEW_NODE(segment(A,A));
  node    a = NEW_NODE(sa);
  node    b = NEW_NODE(sb);
  node    c = NEW_NODE(sc);

  //DAG edges

  DAG.new_edge(root,a,0);
  DAG.new_edge(root,b,0);
  DAG.new_edge(root,c,0);

  //POL is initialized to triangle (A,B,C);

  DAG[a]->it = POL.append(a);
  DAG[b]->it = POL.append(b);
  DAG[c]->it = POL.append(c);

  double x = (A.xcoord() + B.xcoord() + C.xcoord())/3;
  double y = (A.ycoord() + B.ycoord() + C.ycoord())/3;

  point I(x,y);

  point P;

  while (W>>P)
  { W << P;

    point   Q;

    segment S(P,I);

    node v = root;

    while (v!=nil && DAG.outdeg(v)!=0) v = next_segment(S,v);

    if (v==nil) continue;

     list_item it;


     point   rtouch  = DAG[v]->s.start();
     segment rtangent(P,rtouch);
     node    w = v;

     it = DAG[w]->it;
     while (rtangent.angle(DAG[w]->s) <= 0) 
     { 
       it = POL.cyclic_succ(it);
       w = POL[it];
       rtouch   = DAG[w]->s.start();
       rtangent = segment(P,rtouch);
      }

     point   ltouch   = DAG[v]->s.end();
     segment ltangent(ltouch,P);
     node    u = v;

     it = DAG[u]->it;
     while (ltangent.angle(DAG[u]->s) >= 0) 
     { it = POL.cyclic_pred(it);
       u = POL[it];
       ltouch   = DAG[u]->s.end();
       ltangent = segment(ltouch,P);
      }


     node x = NEW_NODE(ltangent);
     node y = NEW_NODE(rtangent);

     // draw tangents

     W << ltangent << rtangent;


     it = POL.cyclic_succ(DAG[u]->it);
     
     while (it != DAG[w]->it)
     { list_item i = it;
       it = POL.cyclic_succ(it);
       DAG.new_edge(POL[i],x);
       DAG.new_edge(POL[i],y);
       POL.del(i);
      }
     
     DAG[x]->it = POL.insert(x,it,before);
     DAG[y]->it = POL.insert(y,it,before);


   }

  W.clear();
  W.set_line_width(3);

  node v;

  forall(v,POL) W << DAG[v]->s;

  W.read_mouse();

 return 0;
}

