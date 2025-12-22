#include <LEDA/sweep_segments.h>

#include <LEDA/segment.h>
#include <LEDA/graph.h>
#include <LEDA/prio.h>

#include <LEDA/sortseq.h>
#include <LEDA/impl/skiplist.h>
#include <LEDA/impl/ab_tree.h>

#include <math.h>


#define EPS  0.00001
#define EPS2 0.0000000001

class sw_POINT;
class sw_SEGMENT;
typedef sw_POINT* sw_point;
typedef sw_SEGMENT* sw_segment;

enum sw_point_type {Cross=0,Rightend=1,Leftend=2}; 

class sw_POINT
{
  friend class sw_SEGMENT;

  sw_segment seg;
  int     kind;
  double  x;
  double  y;

  public:

  sw_POINT(double a,double b)  
  { 
    x=a; y=b; seg=0; kind=Cross;
   }



  sw_POINT(point p)         
  { 
    x=p.xcoord();y=p.ycoord();seg=0;kind=Cross;
   }


  LEDA_MEMORY(sw_POINT);

  friend double     get_x(sw_point p);
  friend double     get_y(sw_point p);
  friend int        get_kind(sw_point p);
  friend sw_segment get_seg(sw_point p);

  friend bool intersection(sw_segment, sw_segment, sw_point&);
};

inline double     get_x(sw_point p)    { return p->x; }
inline double     get_y(sw_point p)    { return p->y; }
inline int        get_kind(sw_point p) { return p->kind; }
inline sw_segment get_seg(sw_point p)  { return p->seg; }   



static int compare(sw_point& p1,sw_point& p2)
{ if (p1==p2) return 0;

  double diffx = get_x(p1) - get_x(p2);
  if (fabs(diffx) > EPS2 ) return (diffx > 0.0) ? 1 : -1;

  int    diffk = get_kind(p1)-get_kind(p2);
  if (diffk != 0) return diffk;

  double diffy = get_y(p1) - get_y(p2);
  if (fabs(diffy) > EPS2 ) return (diffy > 0.0) ? 1 : -1;

  return 0;

}


class sw_SEGMENT
{
  sw_point startpoint;
  sw_point endpoint;
  double  slope;
  double  yshift;
  node  left_node;
  int   orient;
  int   color;
  int   name;


  public:

  sw_SEGMENT(sw_point, sw_point,int,int);     

 ~sw_SEGMENT() { delete startpoint; delete endpoint; }     

  LEDA_MEMORY(sw_SEGMENT);

  friend sw_point get_startpoint(sw_segment seg);
  friend sw_point get_endpoint(sw_segment seg);
  friend double get_slope(sw_segment seg);
  friend double get_yshift(sw_segment seg);
  friend int  get_orient(sw_segment seg);
  friend int  get_color(sw_segment seg);
  friend int  get_name(sw_segment seg);
  friend node get_left_node(sw_segment seg);
  friend void set_left_node(sw_segment seg, node v);

  friend bool intersection(sw_segment, sw_segment, sw_point&);
};

inline sw_point get_startpoint(sw_segment seg)    { return seg->startpoint; }
inline sw_point get_endpoint(sw_segment seg)      { return seg->endpoint; }
inline double get_slope(sw_segment seg)           { return seg->slope; }
inline double get_yshift(sw_segment seg)          { return seg->yshift; }
inline int  get_orient(sw_segment seg)            { return seg->orient; }
inline int  get_color(sw_segment seg)             { return seg->color; }
inline int  get_name(sw_segment seg)              { return seg->name; }
inline node get_left_node(sw_segment seg)         { return seg->left_node; }
inline void set_left_node(sw_segment seg, node v) { seg->left_node = v; }


sw_SEGMENT::sw_SEGMENT(sw_point p1,sw_point p2,int c, int n)    
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


static int compare(sw_segment& s1,sw_segment& s2)
{
  double y1 = get_slope(s1)*x_sweep+get_yshift(s1);
  double y2 = get_slope(s2)*x_sweep+get_yshift(s2);

  double diff = y1-y2;

  if (fabs(diff) > EPS2) return (diff > 0.0) ? 1 : -1;

  if (get_slope(s1) == get_slope(s2)) 
        return compare(get_x(get_startpoint(s1)), get_x(get_startpoint(s2)));

  if (y1 <= y_sweep+EPS2)
        return compare(get_slope(s1),get_slope(s2));
  else
        return compare(get_slope(s2),get_slope(s1));

}


void Print(sw_segment& x) 
{ sw_point s = get_startpoint(x);
  sw_point e = get_endpoint(x);
  cout << 
    string("[(%f,%f)----(%f,%f)]",get_x(s),get_y(s), get_x(e),get_y(e));
}


static priority_queue<seq_item,sw_point>* X_structure;

static sortseq<sw_segment,pq_item>* Y_structure;



bool intersection(sw_segment seg1,sw_segment seg2, sw_point& inter)
{
  if (seg1->slope == seg2->slope)
    return false;
  else
  {
    //x-coordinate  of the intersection
    double Cross_x = (seg2->yshift - seg1->yshift) / (seg1->slope - seg2->slope);
 
    if (Cross_x <= x_sweep) return false;

    double s1 = seg1->startpoint->x;
    double s2 = seg2->startpoint->x;
    double e1 = seg1->endpoint->x;
    double e2 = seg2->endpoint->x;

    if (s2>Cross_x || s1>Cross_x || Cross_x>e1 || Cross_x>e2) return false;

    //y-coordinate of the intersection
    double Cross_y = (seg1->slope * Cross_x + seg1->yshift);
    inter =  new sw_POINT(Cross_x,Cross_y);

    return true;
  }
}


static pq_item Xinsert(seq_item i, sw_point p) 
{ 
  return X_structure->insert(i,p);
}

static sw_point Xdelete(pq_item i) 
{
  sw_point p = X_structure->inf(i);
  X_structure->del_item(i);
  return p;
}


static node New_Node(GRAPH<point,int>& G,double x, double y )
{ return G.new_node(point(x,y)); }

static void New_Edge(GRAPH<point,int>& G,node v, node w, sw_segment l )
{ if (get_orient(l)==0)
       G.new_edge(v,w,get_color(l));
  else G.new_edge(w,v,get_color(l));
}


void vertical_segment(GRAPH<point,int>& SUB, sw_segment l)
{ 
  sw_point p = new sw_POINT(get_x(get_startpoint(l)),get_y(get_startpoint(l)));
  sw_point q = new sw_POINT(get_x(get_endpoint(l)),get_y(get_endpoint(l)));

  sw_point r = new sw_POINT(get_x(p)+1,get_y(p));
  sw_point s = new sw_POINT(get_x(q)+1,get_y(q));

  sw_segment bot = new sw_SEGMENT(p,r,0,0);
  sw_segment top = new sw_SEGMENT(q,s,0,0);

  seq_item bot_it = Y_structure->insert(bot,nil);
  seq_item top_it = Y_structure->insert(top,nil);
  seq_item sit;

  node u,v,w;
  sw_segment seg;
  

  for(sit=Y_structure->succ(bot_it); sit != top_it; sit=Y_structure->succ(sit))
  { seg = Y_structure->key(sit);

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
    
  Y_structure->del_item(bot_it);
  Y_structure->del_item(top_it);

 }


void Sweep_Segments(const list<segment>& L1, const list<segment>& L2, 
                    GRAPH<point,int>& SUB,
                    priority_queue<seq_item,sw_point>& Q,
                    sortseq<sw_segment,pq_item>& S)
{
  sw_point    p,inter;
  sw_segment  seg, l,lsit,lpred,lsucc,lpredpred;
  pq_item  pqit,pxmin;
  seq_item sitmin,sit,sitpred,sitsucc,sitpredpred;

  X_structure = &Q;
  Y_structure = &S;

  int count=1;
 
  //initialization of the X-structure

  segment s;

  forall(s,L1) 
   { sw_point p = new sw_POINT(s.start());
     sw_point q = new sw_POINT(s.end());
     seg = new sw_SEGMENT(p,q,0,count++);
     Xinsert(nil,get_startpoint(seg));
   }

  count = -1;

  forall(s,L2) 
   { sw_point p = new sw_POINT(s.start());
     sw_point q = new sw_POINT(s.end());
     seg = new sw_SEGMENT(p,q,1,count--);
     Xinsert(nil,get_startpoint(seg));
   }


  count = 0;

  x_sweep = -MAXINT;
  y_sweep = -MAXINT;


  while(!X_structure->empty())
  {
    pxmin = X_structure->find_min();
    p = X_structure->inf(pxmin);

    sitmin = X_structure->key(pxmin);

    Xdelete(pxmin);



    if (get_kind(p) == Leftend)

    //left endpoint
    { 

      l = get_seg(p); 

      x_sweep = get_x(p);
      y_sweep = get_y(p);


      if (get_x(p) == get_x(get_endpoint(l)))
        vertical_segment(SUB,l);
      else
      {

/*
      sit = Y_structure->lookup(l);
      if (sit!=nil)  
           error_handler(1,"plane sweep: sorry, overlapping segments");
*/


      sit = Y_structure->insert(l,nil);

      Xinsert(sit,get_endpoint(l));

      sitpred = Y_structure->pred(sit);
      sitsucc = Y_structure->succ(sit);

      if (sitpred != nil) 
      { if ((pqit = Y_structure->inf(sitpred)) != nil)
          delete Xdelete(pqit);

        lpred = Y_structure->key(sitpred);

        Y_structure->change_inf(sitpred,nil);

        if (intersection(lpred,l,inter))
            Y_structure->change_inf(sitpred,Xinsert(sitpred,inter));
      }


      if (sitsucc != nil)
      { lsucc = Y_structure->key(sitsucc);
        if (intersection(lsucc,l,inter))
           Y_structure->change_inf(sit,Xinsert(sit,inter));
      }
     } /* else if vertical */

    }
    else if (get_kind(p) == Rightend)
         //right endpoint
         { 
           x_sweep = get_x(p);
           y_sweep = get_y(p);

           sit = sitmin;

           sitpred = Y_structure->pred(sit);
           sitsucc = Y_structure->succ(sit);

           sw_segment seg = Y_structure->key(sit);

           Y_structure->del_item(sit);

           delete seg;

           if((sitpred != nil)&&(sitsucc != nil))
           {
             lpred = Y_structure->key(sitpred);
             lsucc = Y_structure->key(sitsucc);
             if (intersection(lsucc,lpred,inter))
                Y_structure->change_inf(sitpred,Xinsert(sitpred,inter));
           }
         }
         else
         /*point of intersection*/
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

           Y_structure->change_inf(sitmin,nil);

           sitpred = Y_structure->succ(sitmin);


           while ((pqit=Y_structure->inf(sitpred)) != nil)
           { sw_point q = X_structure->inf(pqit);
             if (compare(p,q) != 0) break; 
             X_structure->del_item(pqit);
             Y_structure->change_inf(sitpred,nil);
             sitpred = Y_structure->succ(sitpred);
            }


           /* search for sit downwards from sitmin: */

           sit = sitmin;

           seq_item sit1;
           
           while ((sit1=Y_structure->pred(sit)) != nil)
           { pqit = Y_structure->inf(sit1);
             if (pqit == nil) break;
             sw_point q = X_structure->inf(pqit);
             if (compare(p,q) != 0) break; 
             X_structure->del_item(pqit);
             Y_structure->change_inf(sit1,nil);
             sit = sit1;
            }



           // insert edges to p for all sw_segments in sit, ..., sitpred into SUB
           // and set left node to w 

           lsit = Y_structure->key(sitpred);

           node v = get_left_node(lsit);
           if (v!=nil) New_Edge(SUB,v,w,lsit);
           set_left_node(lsit,w);

           for(sit1=sit; sit1!=sitpred; sit1 = Y_structure->succ(sit1))
           { lsit = Y_structure->key(sit1);

             v = get_left_node(lsit);
             if (v!=nil) New_Edge(SUB,v,w,lsit);
             set_left_node(lsit,w);
            }

           lsit = Y_structure->key(sit);
           lpred=Y_structure->key(sitpred);
           sitpredpred = Y_structure->pred(sit);
           sitsucc=Y_structure->succ(sitpred);


           if (sitpredpred != nil)
            { 
              lpredpred=Y_structure->key(sitpredpred);

              if ((pqit = Y_structure->inf(sitpredpred)) != nil)
                delete Xdelete(pqit);

              Y_structure->change_inf(sitpredpred,nil);


              if (intersection(lpred,lpredpred,inter))
                Y_structure->change_inf(sitpredpred,
                                       Xinsert(sitpredpred,inter));
             }


           if (sitsucc != nil)
            {
              lsucc=Y_structure->key(sitsucc);

              if ((pqit = Y_structure->inf(sitpred)) != nil)
                delete Xdelete(pqit);
                 
              Y_structure->change_inf(sitpred,nil);

              if (intersection(lsucc,lsit,inter))
                  Y_structure->change_inf(sit,Xinsert(sit,inter));
             }


// reverse the subsequence sit, ... ,sitpred  in the Y_structure

           x_sweep = get_x(p);
           y_sweep = get_y(p);

           Y_structure->reverse_items(sit,sitpred);

          delete p;

         } // intersection

  }

  X_structure->clear();

}



#if !defined(__TEMPLATE_ARGS_AS_BASE__)
declare3(_sortseq,sw_segment,pq_item,skiplist)
declare3(_sortseq,sw_segment,pq_item,ab_tree)
#endif

main()
{ 
  int N = read_int("N = ");

  list<segment> seglist1,seglist2;
  
  while (N--) 
  { double x1 = random(-1000,-100);
    double y1 = random(-1000,1000);
    double x2 = random(100,1000);
    double y2 = random(-1000,1000);
    seglist1.append(segment(x1,y1,x2,y2));
   }

  GRAPH<point,int> SUB;

  sortseq<sw_segment,pq_item>           rst_seq;

#if defined(__TEMPLATE_ARGS_AS_BASE__)
  _sortseq<sw_segment,pq_item,ab_tree>   abt_seq;
  _sortseq<sw_segment,pq_item,skiplist>  skip_seq;
#else
  _sortseq(sw_segment,pq_item,ab_tree)   abt_seq;
  _sortseq(sw_segment,pq_item,skiplist)  skip_seq;
#endif

  priority_queue<seq_item,sw_point>     Q;


  float T;

  T = used_time();
  cout << "SWEEP_SEGMENTS: ";
  cout.flush(); 
  SWEEP_SEGMENTS(seglist1,seglist2,SUB);
  cout<< string(" # = %d time = %6.2f sec",SUB.number_of_nodes(), used_time(T));
  newline;

  SUB.clear();

  T = used_time();
  cout << "rs_tree:        ";
  cout.flush(); 
  Sweep_Segments(seglist1,seglist2,SUB,Q,rst_seq);
  cout<< string(" # = %d time = %6.2f sec",SUB.number_of_nodes(), used_time(T));
  newline;

  SUB.clear();

  T = used_time();
  cout << "ab_tree:        ";
  cout.flush(); 
  Sweep_Segments(seglist1,seglist2,SUB,Q,abt_seq);
  cout<< string(" # = %d time = %6.2f sec",SUB.number_of_nodes(), used_time(T));
  newline;

  SUB.clear();

  T = used_time();
  cout << "skiplist:       ";
  cout.flush(); 
  Sweep_Segments(seglist1,seglist2,SUB,Q,skip_seq);
  cout<< string(" # = %d time = %6.2f sec",SUB.number_of_nodes(), used_time(T));
  newline;

return 0;

}
