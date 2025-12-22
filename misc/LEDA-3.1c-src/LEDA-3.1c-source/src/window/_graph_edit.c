/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _graph_edit.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/graph_edit.h>
#include <LEDA/graph_alg.h>
#include <LEDA/node_matrix.h>


static window*           Wp;
static GRAPH<point,int>* Gp;
static node_matrix<int>  M;


static color node_color = green;
static color edge_color = black;
static bool  directed;

static int x_min, x_max, y_min, y_max;
static double node_radius;

static list<point> cursor_in_edges;
static list<point> cursor_out_edges;


static void draw_node_cursor(double x, double y)
{
  point q(x,y);
  point p;
  forall(p,cursor_in_edges) Wp->draw_edge(p,q);
  forall(p,cursor_out_edges) Wp->draw_edge(q,p);
  Wp->draw_node(q); 
}



static void draw_node(node v)
{ Wp->draw_text_node((*Gp)[v],string("%d",index(v)),node_color); }




static void draw_edge(node v, node w)
{ 
  // M(v,w) = number of edges from v to w (defines thickness of drawn edge)

  if (v == w) return; // still cannot draw self-loops 

  if (M(v,w) == 0) return;  // there is no edge (v,w)

  int lw_save = Wp->set_line_width(M(v,w));

  segment s(Gp->inf(v),Gp->inf(w));

  if (directed) 
    if (M(w,v) == 0)
       Wp->draw_edge_arrow(s,edge_color);
    else
       Wp->draw_arc_edge_arrow(s,0.7*s.length(),edge_color);
  else 
    if (M(w,v) == 0)
       Wp->draw_edge(s,edge_color); 
    else
       Wp->draw_arc_edge(s,0.7*s.length(),edge_color);

  Wp->set_line_width(lw_save);
}


static void message(window& W, string s)
{ W.del_message();
  W.message(s + "                              ");
 }

static edge find_edge(node v, node w)
{ edge e = Gp->first_adj_edge(v);
  while (e != nil && target(e) != w) e = Gp->adj_succ(e);
  return e;
 }


static node V(point p)  // returns node at position p
{ node v;
  forall_nodes(v,*Gp)
    if (p.distance(Gp->inf(v)) < node_radius) return v;
  return nil;
 }

void init_matrix(const graph& g)
{ edge e;
  int n = 100;
  if (g.number_of_nodes() > n) n = 2*g.number_of_nodes();
  M.init(g,n,0);
  forall_edges(e,g) M(source(e),target(e))++;
 }


static void read_graph(window& W, GRAPH<point,int>& G,string s,bool clear=false)
{
  if (s=="") 
  { message(W,"No file.");
    return;
   }

  message(W,string("Reading file %s.",~s));

  GRAPH<point,int> X;
  node v;
  node w;

  int x = X.read(s);

  if (x == 1) 
  { message(W,string("Cannot open file %s.",~s));
    return;
   }

  if (x == 2)
  { message(W,"File is not written by graph_edit (random embedding).");
    int max = int(W.xmax())-3;
    int min = 2;
    forall_nodes(v,X)
      X[v] = point(random(min,max), random(min,max));
   }

  if (clear) 
  { G.clear(); 
    W.clear(); 
   }

  node_array<node> corr(X);

  forall_nodes(v,X) 
  { node u = G.new_node(X[v]);
    corr[v] = u;
    draw_node(u);
   }

  edge e;
  forall_edges(e,X) 
  { v = corr[source(e)];
    w = corr[target(e)];
    G.new_edge(v,w);
    M(v,w)++;
   }

  if (clear) init_matrix(G);

  forall_nodes(v,G)
     forall_nodes(w,G) 
        draw_edge(v,w);

}



static void save_graph(window& W, GRAPH<point,int>& G,string s)
{ if (s=="") 
  { message(W,"Cannot open file.");
    return;
   }
  message(W,string("writing to file %s",~s));
  G.write(s);
 }


static void generate_graph(GRAPH<point,int>& G)
{
  panel P("GRAPH GENERATORS");;

  int n = 10;
  int m = 20;

  P.int_item("# nodes", n,0,500);
  P.int_item("# edges", m,0,500);

  P.button("random");
  P.button("complete");
  P.button("bi_random");
  P.button("bi_complete");
  P.button("planar");
  P.button("grid");
  P.button("triang");
  P.button("exit");

  list<node> A,B;
  node v;

  G.clear();

  node_array<double> xcoord(G);
  node_array<double> ycoord(G);

  double w = x_max - x_min;
  double h = y_max - y_min;

  double R  = (x_max-x_min)/2.5;
  double x0 = (x_max-x_min)/2;
  double y0 = (y_max-y_min)/2;

  int i = P.open(*Wp);

  switch(i)
  {
    case 0: random_graph(G,n,m);
            break;
    case 1: complete_graph(G,n);
            break;

    case 2: random_bigraph(G,n,n,m,A,B);
            break;

    case 3: complete_bigraph(G,n,n,A,B);
            break;

    case 4: { random_planar_graph(G,xcoord,ycoord,n);
              node v;
              forall_nodes(v,G)  
                 G[v] = point(x_min + w*xcoord[v], y_min + h*ycoord[v]);
              break;
             }

    case 5: { grid_graph(G,xcoord,ycoord,n);
              node v;
              forall_nodes(v,G)  
                 G[v] = point(x_min + w*xcoord[v], y_min + h*ycoord[v]);
              break;
             }

    case 6: { triangulated_planar_graph(G,xcoord,ycoord,n);
              node v;
              forall_nodes(v,G)  
                 G[v] = point(x_min + w*xcoord[v], y_min + h*ycoord[v]);
              break;
             }
   }

   if ( i==2 || i==3 )
   { double dy = (y_max-y_min)/(n+1);
     double y = y_min + dy;
     forall(v,A) 
     { G[v] = point(x_min + (x_max-x_min)/4,y);
       y += dy;
      }
     y = y_min + dy;
     forall(v,B) 
     { G[v] = point(x_max - (x_max-x_min)/4,y);
       y += dy;
      }
     }

   if (i==0 || i==1) // circular embedding 
   { double R  = (x_max-x_min)/2.5;
     double x0 = (x_max-x_min)/2;
     double y0 = (y_max-y_min)/2;
     point  M(x0,y0);
     double alpha = 0;
     double step  = 6.2832/n;
     forall_nodes(v,G)  
     { G[v] = M.translate(alpha,R);
       alpha+=step;
      }
    }

  init_matrix(G);
}


static void redraw_func()
{ Wp->set_mode(src_mode);
  node v;
  forall_nodes(v,*Gp) 
  { draw_node(v);
    node w;
    forall_nodes(w,*Gp) draw_edge(v,w);
   }
  Wp->set_mode(xor_mode);
 }



static void window_init(window& W, GRAPH<point,int>& G)
{ 
  W.init(x_min,x_max,y_min,0);

  if (W.mono()) node_color = white;

  W.set_redraw(redraw_func);
  W.set_mode(src_mode);

  node_radius = W.get_node_width()/W.scale();

  node v;
  forall_nodes(v,G) 
  { draw_node(v);
    node w;
    forall_nodes(w,G) draw_edge(v,w);
   }

  W.set_mode(xor_mode);

}



void graph_edit(window& W, GRAPH<point,int>& G, bool dir, bool redraw)
{
  double x,y;
  point  p,q;
  int    key;

  Wp = &W;
  Gp = &G;

  init_matrix(G);

  x_min = (int)W.xmin();
  x_max = (int)W.xmax();
  y_min = (int)W.ymin();
  y_max = (int)W.ymax();

  directed = dir;
  node_radius = W.get_node_width()/W.scale();


  string filename = "graph.ggg";

  panel main_panel("GRAPH EDIT MAIN PANEL");
  main_panel.text_item("");
  main_panel.text_item("graph_edit: A Graph Editor For LEDA Graphs.");
  main_panel.text_item("");
  main_panel.string_item("file:",filename);
  main_panel.button("load");
  main_panel.button("read");
  main_panel.button("save");
  main_panel.button("redraw");
  main_panel.button("clear");
  main_panel.button("gen");
  main_panel.button("zoom");
  main_panel.button("params");
  main_panel.button("help");
  main_panel.button("done");



  panel help_panel("GRAPH EDIT OPERATIONS");
  help_panel.text_item("                                             ");
  help_panel.text_item("          left button        middle button    ");
  help_panel.text_item("                                             ");
  help_panel.text_item("        insert/move node      insert edge     ");
  help_panel.text_item("(shift)   delete node         delete edge     ");
  help_panel.text_item("                                             ");
  help_panel.button("continue");


  panel init_panel("SETTINGS");
  init_panel.int_item("x_min",x_min);
  init_panel.int_item("x_max",x_max);
  init_panel.int_item("y_min",y_min);
  init_panel.color_item("node color",node_color);
  init_panel.color_item("edge color",edge_color);
  init_panel.button("continue");



  main_panel.display(W,0,0);

  drawing_mode save = W.set_mode(xor_mode);


  if (redraw) window_init(W,G);

  bool done = false;

  LEDA_WINDOW* wp;

  while ( ! done )
  {
    read_mouse(wp,x,y);

    if (wp == &W || wp == &main_panel) put_back_event();


    if (wp == &main_panel)
    { int k = main_panel.read();

      switch (k) { 

      case 0 : // load 
               read_graph(W,G,filename,true);
               break;

      case 1 : // read
               read_graph(W,G,filename,false);
               break;
  
      case 2 : // save
               save_graph(W,G,filename);
               break;

      case 3:  // redraw
               window_init(W,G);
               break;

      case 4:  // clear
               W.clear();
               G.clear();
               init_matrix(G);
               break;

      case 5:  // generate
               generate_graph(G);
               window_init(W,G);
               break;


      case 6:  // zoom
               W.acknowledge("Sorry, zoom not implemented.");
               break;

 
      case 7:  // settings
               init_panel.open();
               window_init(W,G);
               break;
 
      case 8:  // help
               help_panel.open();
               break;
  
 
      case 9: done = true;
              break;
     }

     continue;
    }


     key = W.read_mouse(x,y);

     W.del_message();

     p = point(x,y);

     switch(key) {

     case 1:  { 
                node v = V(p);

                if (v == nil)        // new node
                { v  = G.new_node(p);
                  draw_node(v);
                 }
                else                    // move node
                { 
                  draw_node(v);

                  cursor_in_edges.clear();
                  cursor_out_edges.clear();
                  edge e;
                  forall_in_edges(e,v)  
                  { draw_edge(source(e),v);
                    cursor_in_edges.append(G[source(e)]); 
                   }
                  forall_out_edges(e,v)
                  { draw_edge(v,target(e));
                    cursor_out_edges.append(G[target(e)]); 
                   }
                  W.read_mouse_action(draw_node_cursor,x,y);

                  forall_in_edges(e,v)  draw_edge(source(e),v);
                  forall_out_edges(e,v) draw_edge(v,target(e));



                  point q(x,y);           // new position

                  if (V(q) != nil)        // position not free
                  { draw_node(v);
                    break;
                   }

                  node w;

                  forall_nodes(w,G)    // remove adjacent edges
                  { draw_edge(v,w);
                    draw_edge(w,v);
                   }

                  G[v] = q;
                  draw_node(v);

                  forall_nodes(w,G)    // reinsert adjacent edges
                  { draw_edge(v,w);
                    draw_edge(w,v);
                   }

                 }
                break;
               }


     case 2:  { // new edge
                
                node v = V(p);   // start node
 
                if (v != nil)            
                { p = G[v];

                  W.draw_filled_node(p);   // highlight start node

                  W.read_mouse_seg(p.xcoord(),p.ycoord(),x,y);

                  point q(x,y);
                  node w = V(q);

                  if (w == nil)      // no hit: create a new node w at q
                  { w  = G.new_node(q);
                    draw_node(w);
                   }

                  draw_edge(v,w);   // delete possible edge drawings
                  draw_edge(w,v);

                  G.new_edge(v,w);  // insert new edge
                  M(v,w)++;

                  draw_edge(w,v);   // reinsert edge drawings
                  draw_edge(v,w);

                  W.draw_filled_node(p);  // un-highlight start node
                 }

                break;
               }



     // Shift + mouse key


     case -1: { // delete node

                node v = V(p);

                if (v != nil) 
                { node w; 
                  forall_nodes(w,G)    // remove adjacent edges
                  { draw_edge(v,w);
                    draw_edge(w,v);
                    M(v,w) = M(w,v) = 0;
                   }

                  draw_node(v);

                  G.del_node(v);
                 }

                }

     case -2: { // delete edge

                node v = V(p);

                if (v != nil) 
                { p = G[v];
                  W.read_mouse_seg(p.xcoord(),p.ycoord(),x,y);
                  q = point(x,y);
                  node w = V(q);
                  if (w != nil) 
                  { edge e = find_edge(v,w);
                    if (e != nil)
                    { draw_edge(v,w);
                      draw_edge(w,v);
                      G.del_edge(e);
                      M(v,w)--;
                      draw_edge(w,v);
                      draw_edge(v,w);
                     }
                   }
                 }
                break;
               }


    } // switch

  } // for(;;)

  W.reset_frame_label();
  W.set_mode(save);
  W.set_redraw(nil);
}

