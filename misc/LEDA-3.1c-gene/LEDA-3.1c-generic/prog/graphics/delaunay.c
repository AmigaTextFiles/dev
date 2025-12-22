#include <LEDA/impl/delaunay_tree.h>
#include <LEDA/plane.h>
#include <LEDA/window.h>


window* Wp;

const double R = 1000;  // "length of inifinite rays"

int ymax;

int segment_to_points(segment s, list<point>& out, double dist)
{ 
  int n = int(s.length()/dist) + 2;

  double dx = (s.xcoord2() - s.xcoord1())/n;
  double dy = (s.ycoord2() - s.ycoord1())/n;
  double x  = s.xcoord1();
  double y  = s.ycoord1();

  out.append(s.start());

  for(int i = 0; i<n; i++)
  { x += dx + double(random(-100,100))/1000000;
    y += dy + double(random(-100,100))/1000000;
    out.append(point(x,y));
   }

  return n;

}

int circle_to_points(circle C, list<point>& out, double dist)
{ 
  point c = C.center();
  double r = C.radius();
  int n = int(6.283 * r/dist);

  double alpha = 0;
  double d = 6.283/n;

  for(int i = 0; i<n; i++)
  { out.append(c.translate(alpha,r+double(random(-100,100))/1000000));
    alpha += d;
   }

  out.permute();

 return n;

}




void draw_vor_site(double x, double y)
{ Wp->draw_point(x,y,blue); }

void draw_vor_seg(double x1, double y1, double x2, double y2,double,double)
{ Wp->draw_segment(x1,y1,x2,y2,red); }


void draw_triang_seg(double x1, double y1, double x2, double y2)
{ Wp->draw_segment(x1,y1,x2,y2,green); 
 }

void infi_pt(double x1, double y1, double x2, double y2, double *x, double* y)
/* retourne le point a l'infini dans la direction x2 y2 depuis x1 y1*/
{
  vector v(x2,y2);

  v = v.norm();

  *x = x1 + R * v[0];
  *y = y1 + R * v[1];
  
}



DELAUNAY_TREE<int> DT;

int display = 0;
DT_item near_it = nil;
bool vor = false;
bool triang = false;
list<segment> CH;


void insert_point(point p)
{ Wp->draw_point(p,blue);
  DT.insert(p,0);
 }

void insert_segment(segment s)
{ list<point> pl;
  segment_to_points(s,pl,10/Wp->scale());
  point p;
  forall(p,pl) insert_point(p);
}

void insert_circle(circle c)
{ list<point> pl;
  circle_to_points(c,pl,10/Wp->scale());
  point p;
  forall(p,pl) insert_point(p);
}
            


void draw()
{ segment s;
  switch(display) {

  case 0: DT.trace_voronoi_edges(draw_vor_seg,infi_pt);
          break;

  case 1: DT.trace_triang_edges(draw_triang_seg);
          break;

  case 2: { list<DT_item> L;
            DT.convex_hull(L);
            list_item it;
            Wp->set_line_width(2);
            forall_items(it,L) 
            { point p = DT.key(L[it]);
              point q = DT.key(L[L.cyclic_succ(it)]);
              Wp->draw_segment(p,q,violet);
             }
            Wp->set_line_width(1);
            break;
           }
  }
}


void redraw()
{ DT.trace_voronoi_sites(draw_vor_site);
  draw();
}


void interactive(window& W)
{
  W.set_redraw(redraw);
  W.set_mode(xor_mode);
  W.set_node_width(4);

  panel P("DYNAMIC VORONOI DIAGRAMS");

  P.text_item("            based on Delaunay Trees           ");
  P.text_item("             by Olivier Devillers             ");
  P.text_item("                                              ");

  int but = -1;

  int N = 500;
  int grid_width = 0;

  P.choice_item("show",display,"voronoi","triang","c-hull");
  P.int_item("grid", grid_width,0,40);
  P.int_item("rand sites ",N);

  P.button("random");
  P.button("point");
  P.button("segment");
  P.button("circle");
  P.button("delete");
  P.button("neighbor");
  P.button("clear");
  P.button("quit");

for(;;)
{
  draw();  // draw picture

  but=P.open(0,0);

  if (but == 7) break;

  draw();  // delete previous drawing

  W.set_grid_mode(grid_width);

  switch (but) { 

    case 0: { for(int i=0; i<N; i++)
                insert_point(point(random(10,500),random(10,ymax)));
              break;
             }

    case 1: { point p;
              while (W >> p)  insert_point(p);
              break;
             }

    case 2: { segment s;
              while (W >> s) insert_segment(s);
              break;
             }

    case 3: { circle c;
              while (W >> c) insert_circle(c);
              break;
             }

    case 4: { point p;
              while (W >> p)
              { DT_item it = DT.neighbor(p); 
                if (it) 
                { W.draw_point(DT.key(it),blue);
                  DT.del_item(it); 
                 }
               }
              break;
             }

    case 5: { point p;
              while (W >> p)
              { if (near_it) W.draw_filled_node(DT.key(near_it));
                near_it = DT.neighbor(p); 
                if (near_it) W.draw_filled_node(DT.key(near_it));
              }
              if (near_it) W.draw_filled_node(DT.key(near_it));
              near_it = nil;
              break;
             }

    case 6: { DT.clear();
              W.clear();
              CH.clear();
              near_it = nil;
             }
    }  // switch

 } // for(;;)

}



void demo(int N, int sec)
{ int i;

  while(Wp->get_button() == 0)
  {
    DT.clear();
    Wp->clear();
    Wp->message(string("%d sites",N));
    Wp->flush();

    for (i=0; i<N ; i++)
    { point p(random(10,500),random(10,ymax));
      DT.insert(p,i);
      *Wp << p;
     }


    //DT.trace_voronoi_sites( draw_vor_site);

    DT.trace_voronoi_edges( draw_vor_seg,infi_pt);
    Wp->flush();
    wait(sec);

    Wp->clear();

    DT.trace_triang_edges( draw_triang_seg);
    Wp->flush();
    wait(sec);
  }

}


/*
#include <LEDA/stream.h>
*/


main(int argc, char** argv)
{

/*

#define SCREEN_WIDTH  1152
#define SCREEN_HEIGHT  900

  string_istream arguments(argc-1,argv+1);

  int   N=0;

  float f1=1; 
  float f2=1;

  float w,h,xpos,ypos;

  int   position=0;

  arguments >> f1;
  arguments >> f2;

  if (f1 == 0 && f2 == 0) 
   { f1 = 0.75;
     f2 = 0.95;
    }
  else 
   if (f2 == 0) 
     f2 = f1;
   else
     { arguments >> position;
       arguments >> N;
      }


  w = SCREEN_WIDTH*f1;
  h = SCREEN_HEIGHT*f2;

  switch(position) {

  case 0: xpos = SCREEN_WIDTH - w;    // upper right corner
          ypos = 0;
          break; 

  case 1: xpos = 0;                   // upper left corner
          ypos = 0;
          break; 

  case 2: xpos = 0;
          ypos = SCREEN_HEIGHT - h;   // lower left corner
          break; 

  case 3: xpos = SCREEN_WIDTH - w;    // lower right corner
          ypos = SCREEN_HEIGHT - h;
          break; 
}


  window W(w,h,xpos,ypos);

*/


  int N = (argc > 1) ? atoi(argv[1]) : 0;

  window W;

  W.set_flush(false);

  W.init(0,512,0);

  Wp = &W;

  ymax = int(W.ymax()-10);

  if (N==0) 
     interactive(W);
  else
     demo(N,2);

 return 0;
}
