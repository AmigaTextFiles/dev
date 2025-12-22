#include <LEDA/point_set.h>
#include <LEDA/plane.h>
#include <LEDA/window.h>


window* Wp;

void draw_vor_seg(double x1, double y1, double x2, double y2,double,double)
{ Wp->draw_segment(x1,y1,x2,y2,blue); }

void draw_triang_seg(double x1, double y1, double x2, double y2)
{ Wp->draw_segment(x1,y1,x2,y2,red); 
 }

void infi_pt(double x1, double y1, double x2, double y2, double *x, double* y)
{ vector v(x2,y2);
  v = v.norm();
  *x = x1 + 1000 * v[0];
  *y = y1 + 1000 * v[1];
 }


void draw_polygon(window& W, point_set<string>& S, list<ps_item>& P)
{ list_item it;
  forall_items(it,P)
  { point p =  S.key(P[it]);
    point q =  S.key(P[P.cyclic_succ(it)]);
    W.draw_segment(p,q);
   }
 }

main()
{

  window W;

  Wp = &W;

  int node_width = 4;
  int line_width = 1;
  int grid_width = 0;


  W.set_mode(xor_mode);

  panel P("POINT SET");

  P.text_item("Use the left mouse button to insert points. If a shift ");
  P.text_item("key is pressed simultaneously the nearest neighbor of  ");
  P.text_item("the current mouse position is computed and displayed.  ");
  P.text_item("An iso-oriented query rectangle can by defined using   ");
  P.text_item("the middle button twice. An orthogonal range query is  ");
  P.text_item("performed and all points lying inside the rectangle    ");
  P.text_item("are deleted. Click the right button to quit.           ");

  P.int_item("line width",line_width,1,5);
  P.int_item("node width",node_width,1,10);
  P.int_item("GRID",grid_width,0,8,1);

  P.open();

  W.clear();
  W.set_node_width(node_width);
  W.set_line_width(line_width);
  W.set_grid_mode(grid_width);

  point_set<string> S;

  double        x,y,x1,y1;
  int           button=0;
  bool          voro = false;
  ps_item       nearest_it=nil;
  point         p; 
  list<ps_item> Pol;



  while (button !=3 )
  {  
     button =  W.read_mouse(x,y);

     if (nearest_it) W.draw_edge_arrow(p,S.key(nearest_it));

     if (!Pol.empty()) draw_polygon(W,S,Pol); 

     if (voro)  S.trace_voronoi_edges(draw_vor_seg,infi_pt);

     Pol.clear();
     nearest_it = nil;
     voro = false;

     p = point(x,y);

     switch(button) {

     case 1: { string s("point (%f,%f)",p.xcoord(),p.ycoord());
               S.insert(p,s);
               W.draw_filled_node(p);
               break;
              }


     case 2: { W.read_mouse_rect(x,y,x1,y1);
               list<ps_item> L = S.range_search(x,x1,y,y1);
               ps_item it;
               forall(it,L) 
               { cout << "delete " << S.inf(it) << "\n";
                 W.draw_filled_node(S.key(it));
                 S.del_item(it);
                }
               cout.flush();
               break;
              }

     case -1:  { nearest_it = S.nearest_neighbor(p);
                 if (nearest_it!=nil) 
                  { W.draw_edge_arrow(p,S.key(nearest_it));
                    cout << "Nearest " << S.inf(nearest_it) << "\n";
                   }
                 else cout << "Empty point set.\n";	
                 cout.flush();
                 break;
                }

     case -2:  { S.trace_voronoi_edges(draw_vor_seg,infi_pt);
                 voro = true;
                 break;
                }

     case -3:  { Pol = S.convex_hull();
                 draw_polygon(W,S,Pol);
                 break;
                }

     } //switch


} //for

return 0;

}
