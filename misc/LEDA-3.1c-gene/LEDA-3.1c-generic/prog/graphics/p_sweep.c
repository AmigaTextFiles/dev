#include <LEDA/plane.h>
#include <LEDA/window.h>
#include <LEDA/prio.h>
#include <LEDA/sortseq.h>
#include <LEDA/p_dictionary.h>

#include <math.h>


static double X_POS;


int compare(segment& s1,segment& s2)
{
  line l1(s1);
  line l2(s2);

  double diff = l1.y_proj(X_POS) - l2.y_proj(X_POS);

  if (fabs(diff) < 1e-10)
     return compare(l1.slope(),l2.slope());
  else 
     return compare(diff,0.0);
}

segment hor_seg(point p) { return segment(p,0,1); }



typedef priority_queue<segment,point> X_structure;


typedef p_dictionary<segment,int> Y_structure; 


typedef sortseq<double,Y_structure>  HISTORY;


void sweep(list<segment>& L, HISTORY& H)
{
  X_structure    X;
  Y_structure    Y;           
  segment s;

  forall(s,L)                     // initialize the X_structure
  { X.insert(s,s.start());
    X.insert(s,s.end());
   }


  // start sweep

  X_POS = -MAXDOUBLE;         

  H.insert(X_POS,Y);              // insert empty Y_structure at -infinity

  while( !X.empty() )
  {
    pq_item it = X.find_min();
    point   p = X.inf(it);        // p is the next transitition point
    segment l = X.key(it);        // l is a segment starting or ending in p
    X.del_item(it);

    X_POS = p.xcoord();           // move the sweep line to p

    if (l.start()==p)             // update Y_structure Y
        Y = Y.insert(l,0);        // left point
    else
        Y = Y.del(l);             // rigth point

    H.insert(X_POS,Y);            // insert Y into history sequence 

  }

  H.insert(MAXDOUBLE,Y);          // insert empty Y_structure at +infinity
  
}




segment locate(point p, HISTORY& H)
{
  X_POS = p.xcoord();

  Y_structure Y = H.inf(H.pred(X_POS));

  p_dic_item pit = Y.succ(hor_seg(p));

  if (pit != nil) 
     return Y.key(pit);
  else
     return segment(0,0,0,0);
  
}



window W;

void draw_sweep_line()
{ int save = W.set_line_width(1);
  W.draw_vline(X_POS,green);
  W.set_line_width(save);
 }

void draw_segment(segment s)
{ W.draw_segment(s,blue);
 }

void show_segment(segment s)
{ draw_segment(s);
  int save = W.set_line_width(5);
  W.draw_segment(s,red);
  W.set_line_width(save);
 }

void hide_segment(segment s)
{ int save = W.set_line_width(5);
  W.draw_segment(s,red);
  W.set_line_width(save);
  draw_segment(s);
 }


main()
{ 
  HISTORY H;
  segment s;
  point p;

  list<segment> L;

  W.set_mode(xor_mode);
  W.set_line_width(1);

  while (W >> s) 
  { draw_segment(s);
    L.append(s);
   }

 sweep(L,H);


 int key;
 double x,y;

 X_POS = W.xmin();
 L.clear();

 while ((key = W.read_mouse(x,y))!= 3 )  
 {
   forall(s,L) hide_segment(s);           
   draw_sweep_line();
   L.clear();

   switch(key) {

   case 1: L.append(locate(point(x,y),H));
           X_POS = W.xmin();
           break;

   case 2: { X_POS = x;
             draw_sweep_line();
             seq_item sit = H.pred(x);
             Y_structure Y = H.inf(sit);
             p_dic_item it;
             forall_items(it,Y) L.append(Y.key(it));
             break;
            }
   }

   forall(s,L) show_segment(s);           

  }
  
  return 0;
}
