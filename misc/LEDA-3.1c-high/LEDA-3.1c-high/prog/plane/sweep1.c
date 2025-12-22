#include <LEDA/sweep_segments.h>
#include <LEDA/plane.h>
#include <LEDA/sortseq.h>
#include <LEDA/prio.h>

#include <LEDA/impl/bin_heap.h>
#include <LEDA/impl/p_heap.h>

#include <LEDA/impl/skiplist.h>
#include <LEDA/impl/bin_tree.h>
#include <LEDA/impl/avl_tree.h>
#include <LEDA/impl/rb_tree.h>
#include <LEDA/impl/rs_tree.h>

#include <math.h>

#define EPS 1e-10

double x_sweep;
double y_sweep;

int compare(segment& s1, segment& s2)  
{
  // compare vertical distance at x = x_sweep
  // compare slopes in case of intersection

  double y1 = s1.y_proj(x_sweep);
  double dy = y1 - s2.y_proj(x_sweep);

  if (dy >  EPS ) return  1;
  if (dy < -EPS ) return -1;

  if (y1 <= y_sweep)
        return compare(s1.slope(),s2.slope());  // below current y-coordinate
  else
        return compare(s2.slope(),s1.slope());  // above current y-coordinate
 }


int cmp_seg(const segment& s1, const segment& s2) // compare by left endpoint
{ return compare(s1.start(),s2.start()); }


void SWEEP(priority_queue<seq_item,point>& X_structure,
           sortseq<segment,pq_item>&       Y_structure,
           const list<segment>&            L, 
           list<point>&                    result)
{
  // The Sweep

  list<segment>  segment_queue;

  pq_item  pqit;
  seq_item sit,sit_pred,sit_succ;
  segment  seg,seg_pred,seg_succ;
  point    p,q;

  result.clear();

  Y_structure.insert(segment(-MAXINT, MAXINT,MAXINT, MAXINT),nil);
  Y_structure.insert(segment(-MAXINT,-MAXINT,MAXINT,-MAXINT),nil);


  // initialization of the X-structure and segment queue

  forall(seg,L) 
  { if (seg.xcoord1() > seg.xcoord2()) seg = segment(seg.end(),seg.start());
    segment_queue.append(seg);
    X_structure.insert(nil,seg.start());
   }

  segment_queue.sort(cmp_seg);   // sort segments by first x-coord


  x_sweep = -MAXINT;
  y_sweep = -MAXINT;

  while( ! X_structure.empty() )
  { 

    pqit = X_structure.find_min();
    sit  = X_structure.key(pqit);
    p    = X_structure.inf(pqit);

    X_structure.del_item(pqit);

    if (sit == nil)   // left end of segment (enter event)
    { 
      seg = segment_queue.pop();   // next segment to enter the Y-structure

      x_sweep = p.xcoord();
      y_sweep = p.ycoord();

      if (p.xcoord() == seg.xcoord2())
           error_handler(1,"plane sweep: sorry, vertical segment");

      if (Y_structure.lookup(seg) != nil)
           error_handler(1,"plane sweep: sorry, overlapping segments");


      sit = Y_structure.insert(seg,nil);

      X_structure.insert(sit,seg.end());

      sit_pred = Y_structure.pred(sit);
      sit_succ = Y_structure.succ(sit);

      // delete possible intersection between sit_pred and sitsucc

      if ((pqit = Y_structure.inf(sit_pred)) != nil) 
      { X_structure.del_item(pqit);
        Y_structure.change_inf(sit_pred,nil);
       }

      seg_pred = Y_structure.key(sit_pred);

      if (seg_pred.slope() > seg.slope() && seg.intersection(seg_pred,q))
         Y_structure.change_inf(sit_pred,X_structure.insert(sit_pred,q));


      seg_succ = Y_structure.key(sit_succ);

      if (seg.slope() > seg_succ.slope() && seg.intersection(seg_succ,q))
         Y_structure.change_inf(sit,X_structure.insert(sit,q));


    }
   else  // right end point or intersection 
   { 
     seg = Y_structure.key(sit);

     if (p == seg.end())  // right end point  (leave event)
     { 
       x_sweep = p.xcoord();
       y_sweep = p.ycoord();
 
       sit_pred = Y_structure.pred(sit);
       sit_succ = Y_structure.succ(sit);

       Y_structure.del_item(sit);

       seg_pred = Y_structure.key(sit_pred);
       seg_succ = Y_structure.key(sit_succ);

       if (seg_pred.slope() > seg_succ.slope()
            && seg_pred.intersection(seg_succ,q))
          Y_structure.change_inf(sit_pred,X_structure.insert(sit_pred,q));

      }
     else   // intersection event
     { 
       result.append(p);

       Y_structure.change_inf(sit,nil);

       /* Let L be the list of all segments intersecting in p 
          we compute sit0 = L.head(), sit_pred = predecessor of sit0,
          sit1 = L.tail(), and sit_succ = successor of sit1
          by scanning the Y_structure in both directions 
          starting at sit;

                                 | --->
                                 |
          sit_succ---------------|---------------- sit_succ
                                 |
          sit1   ______________  |  ______________ sit0
                 ______________\ | /______________
                                \|/
          sit    ================+================ sit
                 _______________/|\_______________
          sit0   ______________/ | \______________ sit1
                                 |
          sit_pred---------------|---------------- seg_pred
                                 |
                                 |
       */

       // search for sit1 & sit_succ upwards starting at sit:

       seq_item sit1 = Y_structure.succ(sit);

       while ((pqit=Y_structure.inf(sit1)))
       { if (p != X_structure.inf(pqit)) break;
         X_structure.del_item(pqit);
         Y_structure.change_inf(sit1,nil);
         sit1 = Y_structure.succ(sit1);
        }

       if (pqit) 
       { X_structure.del_item(pqit);
         Y_structure.change_inf(sit1,nil);
        }

       sit_succ = Y_structure.succ(sit1);



       // search for sit_pred downwards starting at sit:

       seq_item sit_pred = Y_structure.pred(sit);

       while ((pqit=Y_structure.inf(sit_pred)))
       { if (p != X_structure.inf(pqit)) break;
         X_structure.del_item(pqit);
         Y_structure.change_inf(sit_pred,nil);
         sit_pred = Y_structure.pred(sit_pred);
        }

       if (pqit) 
       { X_structure.del_item(pqit);
         Y_structure.change_inf(sit_pred,nil);
        }

       seq_item sit0 = Y_structure.succ(sit_pred);


       segment seg0 = Y_structure.key(sit0);
       segment seg1 = Y_structure.key(sit1);

       segment seg_succ = Y_structure.key(sit_succ);
       segment seg_pred = Y_structure.key(sit_pred);

       // check for intersection between seg_pred and seg1

       if (seg_pred.slope() > seg1.slope() && seg_pred.intersection(seg1,q))
          Y_structure.change_inf(sit_pred, X_structure.insert(sit_pred,q));

       // check for intersection between seg0 and seg_succ

       if (seg0.slope() > seg_succ.slope() && seg_succ.intersection(seg0,q))
          Y_structure.change_inf(sit0,X_structure.insert(sit0,q));


       // move sweep line into intersection point and reverse the subsequence 
       // of items sit0, ... ,sit1 in the Y-structure

       x_sweep = p.xcoord();
       y_sweep = p.ycoord();

       Y_structure.reverse_items(sit0,sit1);

     } // intersection
   }
  } // Main Loop
} 


#if !defined(__TEMPLATE_ARGS_AS_BASE__)
declare3(_priority_queue,seq_item,point,bin_heap)
declare3(_priority_queue,seq_item,point,p_heap)
declare3(_sortseq,segment,pq_item,skiplist)
declare3(_sortseq,segment,pq_item,bin_tree)
declare3(_sortseq,segment,pq_item,rs_tree)
declare3(_sortseq,segment,pq_item,rb_tree)
declare3(_sortseq,segment,pq_item,avl_tree)
#endif



main()
{ 
  list<segment> seglist;
  list<point>   result;

  float T;

  int N = read_int("N = ");

  init_random(N);

  for(int i=0; i < N; i++)
  { double x1 = random(-1000,-100);
    double y1 = random(-1000,1000);
    double x2 = random(100,1000);
    double y2 = random(-1000,1000);
    seglist.append(segment(x1,y1,x2,y2));
   }


  // we test the algorithm with different priority queue and sorted
  // sequence implementations

  priority_queue<seq_item,point>          f_heap_queue;    // Fibonacci heap

#if defined(__TEMPLATE_ARGS_AS_BASE__)
 _priority_queue<seq_item,point,bin_heap> bin_heap_queue;  // binary heap
 _priority_queue<seq_item,point,p_heap>   pair_heap_queue; // pairing heap
 _sortseq<segment,pq_item,skiplist>       skiplist_seq;    // skip list
 _sortseq<segment,pq_item,bin_tree>       bin_tree_seq;
 _sortseq<segment,pq_item,rs_tree>        rs_tree_seq;
 _sortseq<segment,pq_item,rb_tree>        rb_tree_seq;
 _sortseq<segment,pq_item,avl_tree>       avl_tree_seq;
#else
 _priority_queue(seq_item,point,bin_heap) bin_heap_queue;
 _priority_queue(seq_item,point,p_heap)   pair_heap_queue;
 _sortseq(segment,pq_item,skiplist)       skiplist_seq;
 _sortseq(segment,pq_item,bin_tree)       bin_tree_seq;
 _sortseq(segment,pq_item,rs_tree)        rs_tree_seq;
 _sortseq(segment,pq_item,rb_tree)        rb_tree_seq;
 _sortseq(segment,pq_item,avl_tree)       avl_tree_seq;
#endif



  cout << "sweep segments (f_heap   / skiplist)   :   ";
  cout.flush(); 
  T = used_time();
  SWEEP(f_heap_queue,skiplist_seq,seglist,result);
  cout<< string(" # = %d time = %6.2f sec",result.length(), used_time(T));
  newline;

  cout << "sweep segments (bin_heap / skiplist)   :   ";
  cout.flush(); 
  T = used_time();
  SWEEP(bin_heap_queue,skiplist_seq,seglist,result);
  cout<< string(" # = %d time = %6.2f sec",result.length(), used_time(T));
  newline;

  cout << "sweep segments (pairheap / skiplist)   :   ";
  cout.flush(); 
  T = used_time();
  SWEEP(pair_heap_queue,skiplist_seq,seglist,result);
  cout<< string(" # = %d time = %6.2f sec",result.length(), used_time(T));
  newline;
  newline;


  cout << "sweep segments (f_heap   / bin_tree)   :   ";
  cout.flush(); 
  T = used_time();
  SWEEP(f_heap_queue,bin_tree_seq,seglist,result);
  cout<< string(" # = %d time = %6.2f sec",result.length(), used_time(T));
  newline;


  cout << "sweep segments (bin_heap / bin_tree)   :   ";
  cout.flush(); 
  T = used_time();
  SWEEP(bin_heap_queue,bin_tree_seq,seglist,result);
  cout<< string(" # = %d time = %6.2f sec",result.length(), used_time(T));
  newline;


  cout << "sweep segments (pairheap / bin_tree)   :   ";
  cout.flush(); 
  T = used_time();
  SWEEP(pair_heap_queue,bin_tree_seq,seglist,result);
  cout<< string(" # = %d time = %6.2f sec",result.length(), used_time(T));
  newline;
  newline;



  cout << "sweep segments (f_heap   / rs_tree)    :   ";
  cout.flush(); 
  T = used_time();
  SWEEP(f_heap_queue,rs_tree_seq,seglist,result);
  cout<< string(" # = %d time = %6.2f sec",result.length(), used_time(T));
  newline;

  cout << "sweep segments (bin_heap / rs_tree)    :   ";
  cout.flush(); 
  T = used_time();
  SWEEP(bin_heap_queue,rs_tree_seq,seglist,result);
  cout<< string(" # = %d time = %6.2f sec",result.length(), used_time(T));
  newline;

  cout << "sweep segments (pairheap / rs_tree)    :   ";
  cout.flush(); 
  T = used_time();
  SWEEP(pair_heap_queue,rs_tree_seq,seglist,result);
  cout<< string(" # = %d time = %6.2f sec",result.length(), used_time(T));
  newline;
  newline;



  cout << "sweep segments (f_heap   / rb_tree)    :   ";
  cout.flush(); 
  T = used_time();
  SWEEP(f_heap_queue,rb_tree_seq,seglist,result);
  cout<< string(" # = %d time = %6.2f sec",result.length(), used_time(T));
  newline;

  cout << "sweep segments (bin_heap / rb_tree)    :   ";
  cout.flush(); 
  T = used_time();
  SWEEP(bin_heap_queue,rb_tree_seq,seglist,result);
  cout<< string(" # = %d time = %6.2f sec",result.length(), used_time(T));
  newline;

  cout << "sweep segments (pairheap / rb_tree)    :   ";
  cout.flush(); 
  T = used_time();
  SWEEP(pair_heap_queue,rb_tree_seq,seglist,result);
  cout<< string(" # = %d time = %6.2f sec",result.length(), used_time(T));
  newline;
  newline;




  cout << "sweep segments (f_heap   / avl_tree)   :   ";
  cout.flush(); 
  T = used_time();
  SWEEP(f_heap_queue,avl_tree_seq,seglist,result);
  cout<< string(" # = %d time = %6.2f sec",result.length(), used_time(T));
  newline;

  cout << "sweep segments (bin_heap / avl_tree)   :   ";
  cout.flush(); 
  T = used_time();
  SWEEP(bin_heap_queue,avl_tree_seq,seglist,result);
  cout<< string(" # = %d time = %6.2f sec",result.length(), used_time(T));
  newline;

  cout << "sweep segments (pairheap / avl_tree)   :   ";
  cout.flush(); 
  T = used_time();
  SWEEP(pair_heap_queue,avl_tree_seq,seglist,result);
  cout<< string(" # = %d time = %6.2f sec",result.length(), used_time(T));
  newline;
  newline;

 
  return 0;
}
