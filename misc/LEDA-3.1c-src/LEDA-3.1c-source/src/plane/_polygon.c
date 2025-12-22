/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _polygon.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/polygon.h>
#include <LEDA/sweep_segments.h>
#include <math.h>


//------------------------------------------------------------------------------
// polygons
//------------------------------------------------------------------------------


polygon::polygon()  { PTR = new polygon_rep; }


ostream& operator<<(ostream& out, const polygon& p) 
{ p.vertices().print(out);
  return out;
 } 

istream& operator>>(istream& in,  polygon& p) 
{ list<point> L; 
  L.read(in); 
  p = polygon(L); 
  return in;
}


static void polygon_check(const list<segment>&);

polygon::polygon(const list<point>& pl, bool check)
{ PTR = new polygon_rep;

  list_item it,it1;

  forall_list_items(it,pl)
  { it1 = pl.cyclic_succ(it);
    ptr()->seg_list.append(segment(pl[it],pl[it1]));
   }

  if (check) polygon_check(ptr()->seg_list);
}

list<point> polygon::vertices() const
{ list<point> result;
  segment s;
  forall(s,ptr()->seg_list) result.append(s.start());
  return result;
}




static void polygon_check(const list<segment>& seg_list)
{  if (seg_list.length() < 3) 
     error_handler(1,"polygon: must be simple");

   list<point> L;
   SWEEP_SEGMENTS(seg_list,L);

  if (L.length() != seg_list.length())
   error_handler(1,"polygon: must be simple");

  list_item it;

  double angle = 0;

  forall_list_items(it,seg_list)
  { list_item succ = seg_list.cyclic_succ(it);
    segment s1 = seg_list[it];
    segment s2 = seg_list[succ];
    angle += s1.angle(s2);
   }

  if (angle > 0)
   error_handler(1,"polygon: point list must be clockwise oriented.");
}

polygon polygon::translate(double alpha, double d) const
{ list<point> L;
  segment s;
  forall(s,ptr()->seg_list) L.append(s.start().translate(alpha,d));
  return polygon(L,false);
}

polygon polygon::translate(const vector& v) const
{ list<point> L;
  segment s;
  forall(s,ptr()->seg_list) L.append(s.start().translate(v));
  return polygon(L,false);
}

polygon polygon::rotate(const point& origin, double alpha) const
{ list<point> L;
  segment s;
  forall(s,ptr()->seg_list) L.append(s.start().rotate(origin,alpha));
  return polygon(L,false);
}

polygon polygon::rotate(double alpha) const
{ return rotate(point(0,0),alpha);
 }



bool polygon::inside(const point& p) const
{
  line l(p,M_PI_2);  // vertical line through p

  int count = 0;

  segment s;
  forall(s,ptr()->seg_list)
  { point q;
    if (!l.intersection(s,q)) continue;
    if (q.ycoord() < p.ycoord()) continue;
    if (q == s.start())  continue;
    if (q == s.end())  continue;
    count++ ;
   }

  list<point> plist = vertices();

  list_item i0 = plist.first();

  while (plist[i0].xcoord() == p.xcoord())  i0 = plist.cyclic_pred(i0);

  list_item i = plist.cyclic_succ(i0);

  for(;;)
  { 
    while ( i != i0 && (plist[i].xcoord() != p.xcoord() || 
                        plist[i].ycoord() < p.ycoord()    )  )
       i = plist.cyclic_succ(i);

    if (i==i0) break;

    point q  = plist[i];
    point q0 = plist[plist.cyclic_pred(i)];

    while ((plist[i].xcoord()==p.xcoord()) && (plist[i].ycoord() >= p.ycoord()))
    { if (plist[i]==p) return true;
      i = plist.cyclic_succ(i);
     }

    point q1 = plist[i];

     if (q0.xcoord() < p.xcoord() && q1.xcoord() > p.xcoord()) count++;
      if (q0.xcoord() > p.xcoord() && q1.xcoord() < p.xcoord()) count++;

   }

   return count%2;

}



bool polygon::outside(const point& p) const { return !inside(p); }



list<point> polygon::intersection(const segment& s) const
{ list<point> result;
  segment t;
  point p;

  forall(t,ptr()->seg_list) 
    if (s.intersection(t,p))
     if (result.empty()) result.append(p);
     else if (p != result.tail() ) result.append(p);

  return result;
}


list<point> polygon::intersection(const line& l) const
{ list<point> result;
  segment t;
  point p;

  forall(t,ptr()->seg_list) 
    if (l.intersection(t,p))
     if (result.empty()) result.append(p);
     else if (p != result.tail() ) result.append(p);

  return result;
}


// intersection with polygon

static bool polygon_test_edge(GRAPH<point,int>& G,edge& i1)
{ node v = G.target(i1);

  edge e,i2=nil,o1=nil,o2=nil;

  forall_adj_edges(e,v)
    if (e != i1)
    { if (v==target(e)) i2 = e;
      else if (G[e]== G[i1]) o1 = e;
           else o2 = e;
     }

  if (i2==nil) return false;

  segment si1(G[source(i1)],G[v]);
  segment si2(G[v],G[source(i2)]);
  segment so2(G[v],G[target(o2)]);

  double alpha = si1.angle(si2);
  double beta  = si1.angle(so2);

  return (alpha > beta);

}



static edge polygon_switch_edge(GRAPH<point,int>& G,edge i1)
{ node v = G.target(i1);

  edge e,i2=nil,o1=nil,o2=nil;

  forall_adj_edges(e,v)
    if (e != i1)
    { if (v==target(e)) i2 = e;
      else if (G[e]== G[i1]) o1 = e;
           else o2 = e;
     }

  if (i2==nil) return  o1;

  segment si1(G[source(i1)],G[v]);
  segment si2(G[v],G[source(i2)]);
  segment so1(G[v],G[target(o1)]);
  segment so2(G[v],G[target(o2)]);

  double alpha = si1.angle(si2);
  double beta  = si1.angle(so2);
  double gamma = si1.angle(so1);

  if (alpha < beta) cout << "error: alpa < beta!!\n";

  if (gamma >= beta) return o2;
  else return o1;

}


list_polygon_ polygon::intersection(const polygon& P) const
{

  list<polygon> result;

  GRAPH<point,int> SUB;

  SWEEP_SEGMENTS(segments(),P.segments(),SUB);

  int N = SUB.number_of_nodes();

  if (N < size() + P.size())
   error_handler(1,"polygon: sorry, internal error in intersection");

  if (N == size() + P.size())
  { // no intersections between edges of (*this) and P
    // check for inclusion

    segment s1 = ptr()->seg_list.head();
    segment s2 = P.ptr()->seg_list.head();
    point   p1 = s1.start();
    point   p2 = s2.start();

    if (P.inside(p1))                     // (*this) is conained in P
      result.append(*this);
    else
      if (inside(p2))                     // P is conained in (*this)
        result.append(P);                   


    return result;

   }

  SUB.make_undirected();

  edge e;

  list<point> PL;

  edge_array<bool> marked(SUB,false);

  forall_edges(e,SUB) 
  { edge f;
    if (!marked[e]  && SUB.outdeg(target(e))>1) 
      if (polygon_test_edge(SUB,e))
      { // new polygon found
       marked[e] = true;
       PL.append(SUB[source(e)]);
       f = polygon_switch_edge(SUB,e);
       while (f!=e)
       { marked[f] = true;
         PL.append(SUB[source(f)]);
         f = polygon_switch_edge(SUB,f);
        }
       result.append(polygon(PL,false));
       PL.clear();
      }
  }

 SUB.make_directed();

 return result;

}
