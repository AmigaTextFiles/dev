/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _g_random.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/graph.h>
#include <LEDA/ugraph.h>


void random_graph(graph& G, int n, int m)
{ /* random graph with n nodes and m edges */ 

 int i;
 node* V = new node[n];
 G.clear();
 for(i=0;i<n;i++) V[i] = G.new_node();

 while (m--) G.new_edge(V[random(0,n-1)],V[random(0,n-1)]);

/*
 int deg = m/n;
 int r = m%n;
 int k;
 for(i=0;i<n;i++)
   for(k=0;k<deg;k++)
      G.new_edge(V[i],V[random(0,n-1)]);
 while (r--) G.new_edge(V[random(0,n-1)],V[random(0,n-1)]);
*/

}

void random_ugraph(ugraph& G, int n, int m)
{ int i;
 node* V = new node[n];
 G.clear();
 for(i=0;i<n;i++) V[i] = G.new_node();
 while (m--) G.new_edge(V[random(0,n-1)],V[random(0,n-1)]);
}

void random_bigraph(graph& G,int n1,int n2,int m,list<node>& A,list<node>& B)
{
   int  d = m/n1; 
   int  r = m%n1; 

   node* AV = new node[n1];
   node* BV = new node[n2];

   A.clear();
   B.clear();
   G.clear();

   for(int a = 0; a < n1; a++)  A.append(AV[a] = G.new_node());
   for(int b = 0; b < n2; b++)  B.append(BV[b] = G.new_node());

   node v;
   int i;

   forall(v,A)
     for(i=0;i<d;i++)
       G.new_edge(v,BV[random(0,n2-1)]);

   while (r--) G.new_edge(AV[random(0,n1-1)], BV[random(0,n2-1)]);

}




//------------------------------------------------------------------------------
// random planar graph
//------------------------------------------------------------------------------

#include <LEDA/sortseq.h>
#include <LEDA/prio.h>
#include <math.h>


#define EPS  0.00001
#define EPS2 0.0000000001

class POINT;
class SEGMENT;
typedef POINT* point;
typedef SEGMENT* segment;

enum point_type {Intersection=0,Rightend=1,Leftend=2}; 

class POINT
{
  friend class SEGMENT;

  segment seg;
  int     kind;
  double  x;
  double  y;

  public:

  POINT(double a,double b)  
  { 
    x=a; y=b; seg=0; kind=Intersection;
   }


  LEDA_MEMORY(POINT);

  friend double    get_x(point);
  friend double    get_y(point);
  friend int       get_kind(point);
  friend segment get_seg(point);

  friend bool intersection(segment, segment, point&);
};

inline double    get_x(point p)    { return p->x; }
inline double    get_y(point p)    { return p->y; }
inline int       get_kind(point p) { return p->kind; }
inline segment get_seg(point p)  { return p->seg; }   



static int compare(point& p1,point& p2)
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


class SEGMENT
{
  point startpoint;
  point endpoint;
  double  slope;
  double  yshift;
  node  left_node;
  int   orient;
  int   color;
  int   name;


  public:

  SEGMENT(point, point,int,int);     

 ~SEGMENT() { delete startpoint; delete endpoint; }     

  LEDA_MEMORY(SEGMENT);

  friend point get_startpoint(segment);
  friend point get_endpoint(segment);
  friend double get_slope(segment);
  friend double get_yshift(segment);
  friend int  get_orient(segment);
  friend int  get_color(segment);
  friend int  get_name(segment);
  friend node get_left_node(segment);
  friend void set_left_node(segment, node);

  friend bool intersection(segment, segment, point&);
};


inline point get_startpoint(segment seg)     { return seg->startpoint; }
inline point get_endpoint(segment seg)       { return seg->endpoint; }
inline double get_slope(segment seg)           { return seg->slope; }
inline double get_yshift(segment seg)          { return seg->yshift; }
inline int  get_orient(segment seg)            { return seg->orient; }
inline int  get_color(segment seg)             { return seg->color; }
inline int  get_name(segment seg)              { return seg->name; }
inline node get_left_node(segment seg)         { return seg->left_node; }
inline void set_left_node(segment seg, node v) { seg->left_node = v; }



SEGMENT::SEGMENT(point p1,point p2,int c, int n)    
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


static int compare(segment& s1,segment& s2)
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



static priority_queue<seq_item,point> X_structure;

static sortseq<segment,pq_item> Y_structure;


bool intersection(segment seg1,segment seg2, point& inter)
{
  if (seg1->slope == seg2->slope)
    return false;
  else
  { 
    double cx = (seg2->yshift - seg1->yshift) / (seg1->slope - seg2->slope);
 
    if (cx <= x_sweep) return false;

    if (seg1->startpoint->x > cx || seg2->startpoint->x > cx ||
        seg1->endpoint->x < cx || seg2->endpoint->x < cx ) return false;

    inter = new POINT(cx,seg1->slope * cx + seg1->yshift);

    return true;
  }
}



inline pq_item Xinsert(seq_item i, point p) 
{ return X_structure.insert(i,p); }


inline point Xdelete(pq_item i) 
{ point p = X_structure.inf(i);
  X_structure.del_item(i);
  return p;
 }


void random_planar_graph(graph& G, int m)
{ node_array<double> xcoord;
  node_array<double> ycoord;
  random_planar_graph(G,xcoord,ycoord,m);
 }

void random_planar_graph(graph& G, node_array<double>& xcoord,
                                   node_array<double>& ycoord, int n)
{
  point    p,inter;
  segment  seg, l,lsit,lpred,lsucc,lpredpred;
  pq_item  pqit,pxmin;
  seq_item sitmin,sit,sitpred,sitsucc,sitpredpred;

  int MAX_X = 1000;
  int MAX_Y = 1000;

  int N = int(2.5*sqrt(n)); // number of random segments

  xcoord.init(G,n,0);
  ycoord.init(G,n,0);


  int count=1;
 
  //initialization of the X-structure

  for (int i = 0; i < N; i++)
   { point p = new POINT(random(0,MAX_X/3), random(0,MAX_Y));
     point q = new POINT(random(2*MAX_X/3,MAX_X), random(0,MAX_Y));
     seg = new SEGMENT(p,q,0,count++);
     Xinsert(nil,get_startpoint(seg));
   }

  count = 0;

  x_sweep = -MAXINT;
  y_sweep = -MAXINT;


  while( !X_structure.empty() && G.number_of_nodes() < n)
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

    }
    else if (get_kind(p) == Rightend)
         //right endpoint
         { 
           x_sweep = get_x(p);
           y_sweep = get_y(p);

           sit = sitmin;

           sitpred = Y_structure.pred(sit);
           sitsucc = Y_structure.succ(sit);

           segment seg = Y_structure.key(sit);

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
         else // intersection point p
         { 
           node w = G.new_node();

           xcoord[w] = get_x(p);
           ycoord[w] = get_y(p);

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
           { point q = X_structure.inf(pqit);
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
             point q = X_structure.inf(pqit);
             if (compare(p,q) != 0) break; 
             X_structure.del_item(pqit);
             Y_structure.change_inf(sit1,nil);
             sit = sit1;
            }



           // insert edges to p for all segments in sit, ..., sitpred into G
           // and set left node to w 

           lsit = Y_structure.key(sitpred);

           node v = get_left_node(lsit);
           if (v!=nil) G.new_edge(v,w);
           set_left_node(lsit,w);

           for(sit1=sit; sit1!=sitpred; sit1 = Y_structure.succ(sit1))
           { lsit = Y_structure.key(sit1);

             v = get_left_node(lsit);
             if (v!=nil) G.new_edge(v,w);
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
  Y_structure.clear();



  // normalize x and y coordinates 

  node v;
  forall_nodes(v,G) 
  { xcoord[v] /= (x_sweep + MAX_X/12);
    ycoord[v] /= MAX_Y;
   }

}


