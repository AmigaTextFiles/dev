/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _sweep_segments.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


//------------------------------------------------------------------------------
//
// SWEEP_SEGMENTS
//
// a plane sweep algorithm for computing line segment intersections
//
// SWEEP_SEGMENTS(list<segment>& L1, list<segment>& L2, GRAPH<point,int> G);
//
// computes the planar subdivision created by the (directed) straight
// line segments of L1 and L2
// 
// G = (V,E) with
//
// 1. each node v in V contains a point of intersectoin between two segments
//    (from L1 or L2)
//
// 2. each edge e = (v,w) corresponds to a
//
//
//------------------------------------------------------------------------------


#include <LEDA/sweep_segments.h>
#include <LEDA/sortseq.h>
#include <LEDA/prio.h>
#include <math.h>


#define EPS  0.00001
#define EPS2 0.0000000001

class S_POINT;
class S_SEGMENT;
typedef S_POINT* S_point;
typedef S_SEGMENT* S_segment;

enum S_point_type {Cross=0,Rightend=1,Leftend=2}; 

class S_POINT
{
  friend class S_SEGMENT;

  S_segment seg;
  int     kind;
  double  x;
  double  y;

  public:

  S_POINT(double a,double b)  
  { 
    x=a; y=b; seg=0; kind=Cross;
   }



  S_POINT(point p)         
  { 
    x=p.xcoord();y=p.ycoord();seg=0;kind=Cross;
   }


  LEDA_MEMORY(S_POINT);

  friend double    get_x(S_point);
  friend double    get_y(S_point);
  friend int       get_kind(S_point);
  friend S_segment get_seg(S_point);

  friend bool intersection(S_segment, S_segment, S_point&);
};

inline double    get_x(S_point p)    { return p->x; }
inline double    get_y(S_point p)    { return p->y; }
inline int       get_kind(S_point p) { return p->kind; }
inline S_segment get_seg(S_point p)  { return p->seg; }   



static int compare(const S_point& p1, const S_point& p2)
{ if (p1==p2) return 0;

  double diffx = get_x(p1) - get_x(p2);
  if (diffx >  EPS2 ) return  1;
  if (diffx < -EPS2 ) return -1;

  int    diffk = get_kind(p1)-get_kind(p2);
  if (diffk != 0) return diffk;

  double diffy = get_y(p1) - get_y(p2);
  if (diffy >  EPS2 ) return  1;
  if (diffy < -EPS2 ) return -1;

  return 0;

}


class S_SEGMENT
{
  S_point startpoint;
  S_point endpoint;
  double  slope;
  double  yshift;
  node  left_node;
  int   orient;
  int   color;
  int   name;


  public:

  S_SEGMENT(S_point, S_point,int,int);     

 ~S_SEGMENT() { delete startpoint; delete endpoint; }     

  LEDA_MEMORY(S_SEGMENT);

  friend S_point get_startpoint(S_segment);
  friend S_point get_endpoint(S_segment);
  friend double get_slope(S_segment);
  friend double get_yshift(S_segment);
  friend int  get_orient(S_segment);
  friend int  get_color(S_segment);
  friend int  get_name(S_segment);
  friend node get_left_node(S_segment);
  friend void set_left_node(S_segment, node);

  friend bool intersection(S_segment, S_segment, S_point&);
};


inline S_point get_startpoint(S_segment seg)     { return seg->startpoint; }
inline S_point get_endpoint(S_segment seg)       { return seg->endpoint; }
inline double get_slope(S_segment seg)           { return seg->slope; }
inline double get_yshift(S_segment seg)          { return seg->yshift; }
inline int  get_orient(S_segment seg)            { return seg->orient; }
inline int  get_color(S_segment seg)             { return seg->color; }
inline int  get_name(S_segment seg)              { return seg->name; }
inline node get_left_node(S_segment seg)         { return seg->left_node; }
inline void set_left_node(S_segment seg, node v) { seg->left_node = v; }



S_SEGMENT::S_SEGMENT(S_point p1,S_point p2,int c, int n)    
  {
    left_node  = nil;
    color      = c;
    name       = n;

    if (compare(p1,p2) < 0)
     { startpoint = p1; 
       endpoint = p2; 
       orient = 0;
      }
    else
     { startpoint = p2; 
       endpoint = p1; 
       orient = 1;
      }

    startpoint->kind = Leftend; 
    endpoint->kind = Rightend; 
    startpoint->seg = this; 
    endpoint->seg = this;

    if (endpoint->x != startpoint->x)
    {
      slope = (endpoint->y - startpoint->y)/(endpoint->x - startpoint->x);
      yshift = startpoint->y - slope * startpoint->x;

      startpoint->x -= EPS;
      startpoint->y -= EPS * slope;
      endpoint->x += EPS;
      endpoint->y += EPS * slope;
    }
    else //vertical segment
    { startpoint->y -= EPS;
      endpoint->y   += EPS;
     }
  }


static double x_sweep;
static double y_sweep;


static int compare(const S_segment& s1, const S_segment& s2)
{
  double y1 = get_slope(s1)*x_sweep+get_yshift(s1);
  double y2 = get_slope(s2)*x_sweep+get_yshift(s2);

  double diff = y1-y2;
  if (diff >  EPS2 ) return  1;
  if (diff < -EPS2 ) return -1;

  if (get_slope(s1) == get_slope(s2)) 
        return compare(get_x(get_startpoint(s1)), get_x(get_startpoint(s2)));

  if (y1 <= y_sweep+EPS2)
        return compare(get_slope(s1),get_slope(s2));
  else
        return compare(get_slope(s2),get_slope(s1));

}


void Print(S_segment& x) 
{ S_point s = get_startpoint(x);
  S_point e = get_endpoint(x);
  cout << 
    string("[(%f,%f)----(%f,%f)]",get_x(s),get_y(s), get_x(e),get_y(e));
}


static priority_queue<seq_item,S_point> X_structure;

static sortseq<S_segment,pq_item> Y_structure;


bool intersection(S_segment seg1,S_segment seg2, S_point& inter)
{
  if (seg1->slope == seg2->slope)
    return false;
  else
  { 
    double cx = (seg2->yshift - seg1->yshift) / (seg1->slope - seg2->slope);
 
    if (cx <= x_sweep) return false;

    if (seg1->startpoint->x > cx || seg2->startpoint->x > cx ||
        seg1->endpoint->x < cx || seg2->endpoint->x < cx ) return false;

    inter = new S_POINT(cx,seg1->slope * cx + seg1->yshift);

    return true;
  }
}


static pq_item Xinsert(seq_item i, S_point p) 
{ 
  return X_structure.insert(i,p);
}

static S_point Xdelete(pq_item i) 
{
  S_point p = X_structure.inf(i);
  X_structure.del_item(i);
  return p;
}


static node New_Node(GRAPH<point,int>& G,double x, double y )
{ return G.new_node(point(x,y)); }

static void New_Edge(GRAPH<point,int>& G,node v, node w, S_segment l )
{ if (get_orient(l)==0)
       G.new_edge(v,w,get_color(l));
  else G.new_edge(w,v,get_color(l));
}


void handle_vertical_segment(GRAPH<point,int>& SUB, S_segment l)
{ 
  S_point p = new S_POINT(get_x(get_startpoint(l)),get_y(get_startpoint(l)));
  S_point q = new S_POINT(get_x(get_endpoint(l)),get_y(get_endpoint(l)));

  S_point r = new S_POINT(get_x(p)+1,get_y(p));
  S_point s = new S_POINT(get_x(q)+1,get_y(q));

  S_segment bot = new S_SEGMENT(p,r,0,0);
  S_segment top = new S_SEGMENT(q,s,0,0);

  seq_item bot_it = Y_structure.insert(bot,nil);
  seq_item top_it = Y_structure.insert(top,nil);
  seq_item sit;

  node u,v,w;
  S_segment seg;
  

  for(sit=Y_structure.succ(bot_it); sit != top_it; sit=Y_structure.succ(sit))
  { seg = Y_structure.key(sit);

    double cross_y = (get_slope(seg) * get_x(p) + get_yshift(seg));

    v = get_left_node(seg);
    if (v==nil)
    { w = New_Node(SUB,get_x(p),cross_y);
      set_left_node(seg,w);
     }
    else
    { double vx = SUB[v].xcoord();
      if ( vx < get_x(p)-EPS2) 
      { w = New_Node(SUB,get_x(p),cross_y);
        New_Edge(SUB,v,w,seg);
        set_left_node(seg,w);
       }
      else w = v;
     }

    u = get_left_node(l);
    if (u!=nil && u!=w) New_Edge(SUB,u,w,l);
    set_left_node(l,w);

   }
  
  delete l;
  delete top;
  delete bot;
    
  Y_structure.del_item(bot_it);
  Y_structure.del_item(top_it);

 }


void SWEEP_SEGMENTS(const list<segment>& S, list<point>& P)
{ GRAPH<point,int> G;
  list<segment> S0;

  SWEEP_SEGMENTS(S,S0,G);

  node v;
  forall_nodes(v,G) P.append(G[v]);

}

void SWEEP_SEGMENTS(const list<segment>& L1, 
                    const list<segment>& L2, GRAPH<point,int>& SUB)
{
  S_point    p,inter;
  S_segment  seg, l,lsit,lpred,lsucc,lpredpred;
  pq_item  pqit,pxmin;
  seq_item sitmin,sit,sitpred,sitsucc,sitpredpred;


  int count=1;
 
  //initialization of the X-structure

  segment s;

  forall(s,L1) 
   { S_point p = new S_POINT(s.start());
     S_point q = new S_POINT(s.end());
     seg = new S_SEGMENT(p,q,0,count++);
     Xinsert(nil,get_startpoint(seg));
   }

  count = -1;

  forall(s,L2) 
   { S_point p = new S_POINT(s.start());
     S_point q = new S_POINT(s.end());
     seg = new S_SEGMENT(p,q,1,count--);
     Xinsert(nil,get_startpoint(seg));
   }


  count = 0;

  x_sweep = -MAXINT;
  y_sweep = -MAXINT;


  while(!X_structure.empty())
  {
    pxmin = X_structure.find_min();
    p = X_structure.inf(pxmin);

    sitmin = X_structure.key(pxmin);

    Xdelete(pxmin);



    if (sitmin == nil) //left endpoint
    { 

      l = get_seg(p); 

      x_sweep = get_x(p);
      y_sweep = get_y(p);


      if (get_x(p) == get_x(get_endpoint(l)))
        handle_vertical_segment(SUB,l);
      else
      {

/*
      sit = Y_structure.lookup(l);
      if (sit!=nil)  
           error_handler(1,"plane sweep: sorry, overlapping segments");
*/


      sit = Y_structure.insert(l,nil);

      Xinsert(sit,get_endpoint(l));

      sitpred = Y_structure.pred(sit);
      sitsucc = Y_structure.succ(sit);

      if (sitpred != nil) 
      { if ((pqit = Y_structure.inf(sitpred)) != nil)
          delete Xdelete(pqit);

        lpred = Y_structure.key(sitpred);

        Y_structure.change_inf(sitpred,nil);

        if (intersection(lpred,l,inter))
            Y_structure.change_inf(sitpred,Xinsert(sitpred,inter));
      }


      if (sitsucc != nil)
      { lsucc = Y_structure.key(sitsucc);
        if (intersection(lsucc,l,inter))
           Y_structure.change_inf(sit,Xinsert(sit,inter));
      }
     } /* else if vertical */

    }
    else if (get_kind(p) == Rightend)
         //right endpoint
         { 
           x_sweep = get_x(p);
           y_sweep = get_y(p);

           sit = sitmin;

           sitpred = Y_structure.pred(sit);
           sitsucc = Y_structure.succ(sit);

           S_segment seg = Y_structure.key(sit);

           Y_structure.del_item(sit);

           delete seg;

           if((sitpred != nil)&&(sitsucc != nil))
           {
             lpred = Y_structure.key(sitpred);
             lsucc = Y_structure.key(sitsucc);
             if (intersection(lsucc,lpred,inter))
                Y_structure.change_inf(sitpred,Xinsert(sitpred,inter));
           }
         }
         else // point of intersection
         { 
           node w = New_Node(SUB,get_x(p),get_y(p));

           count++;

           /* Let L = list of all lines intersecting in p 
 
              we compute sit     = L.head();
              and        sitpred = L.tail();

              by scanning the Y_structure in both directions 
              starting at sitmin;

           */

           /* search for sitpred upwards from sitmin: */

           Y_structure.change_inf(sitmin,nil);

           sitpred = Y_structure.succ(sitmin);


           while ((pqit=Y_structure.inf(sitpred)) != nil)
           { S_point q = X_structure.inf(pqit);
             if (compare(p,q) != 0) break; 
             X_structure.del_item(pqit);
             Y_structure.change_inf(sitpred,nil);
             sitpred = Y_structure.succ(sitpred);
            }


           /* search for sit downwards from sitmin: */

           sit = sitmin;

           seq_item sit1;
           
           while ((sit1=Y_structure.pred(sit)) != nil)
           { pqit = Y_structure.inf(sit1);
             if (pqit == nil) break;
             S_point q = X_structure.inf(pqit);
             if (compare(p,q) != 0) break; 
             X_structure.del_item(pqit);
             Y_structure.change_inf(sit1,nil);
             sit = sit1;
            }



           // insert edges to p for all S_segments in sit, ..., sitpred into SUB
           // and set left node to w 

           lsit = Y_structure.key(sitpred);

           node v = get_left_node(lsit);
           if (v!=nil) New_Edge(SUB,v,w,lsit);
           set_left_node(lsit,w);

           for(sit1=sit; sit1!=sitpred; sit1 = Y_structure.succ(sit1))
           { lsit = Y_structure.key(sit1);

             v = get_left_node(lsit);
             if (v!=nil) New_Edge(SUB,v,w,lsit);
             set_left_node(lsit,w);
            }

           lsit = Y_structure.key(sit);
           lpred=Y_structure.key(sitpred);
           sitpredpred = Y_structure.pred(sit);
           sitsucc=Y_structure.succ(sitpred);


           if (sitpredpred != nil)
            { 
              lpredpred=Y_structure.key(sitpredpred);

              if ((pqit = Y_structure.inf(sitpredpred)) != nil)
                delete Xdelete(pqit);

              Y_structure.change_inf(sitpredpred,nil);


              if (intersection(lpred,lpredpred,inter))
                Y_structure.change_inf(sitpredpred,
                                       Xinsert(sitpredpred,inter));
             }


           if (sitsucc != nil)
            {
              lsucc=Y_structure.key(sitsucc);

              if ((pqit = Y_structure.inf(sitpred)) != nil)
                delete Xdelete(pqit);
                 
              Y_structure.change_inf(sitpred,nil);

              if (intersection(lsucc,lsit,inter))
                  Y_structure.change_inf(sit,Xinsert(sit,inter));
             }


// reverse the subsequence sit, ... ,sitpred  in the Y_structure

           x_sweep = get_x(p);
           y_sweep = get_y(p);

           Y_structure.reverse_items(sit,sitpred);

          delete p;

         } // intersection

  }

  X_structure.clear();

}
