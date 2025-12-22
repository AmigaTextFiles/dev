#include <math.h>
#include <LEDA/graph.h>
#include <LEDA/graph_alg.h>
#include <LEDA/window.h>
#include <LEDA/graph_edit.h>


void draw_graph(const GRAPH<point,int>& G, window& W, bool numbering=false)
{ node v;
  edge e;

  if (numbering)
     { int i = 0;
       forall_nodes(v,G) W.draw_int_node(G[v],i++,red);
      }
  else
     forall_nodes(v,G) W.draw_filled_node(G[v],red);

  forall_edges(e,G)
    W.draw_edge(G[source(e)],G[target(e)],blue);
}


main()
{

panel P("LEDA Planarity Test Demo");

P.text_item("");
P.text_item("This demo illustrates planarity testing and straight-line");
P.text_item("embedding. You have two ways to construct a graph: either");
P.text_item("interactively by using the LEDA graph editor or by calling");
P.text_item("one of two graph generators. The first generator constructs");
P.text_item("a random graph with a certain number of nodes and edges and");
P.text_item("the second constructs a planar graph with a certain number");
P.text_item("of nodes by intersecting random lines in the unit square");
P.text_item("");
P.text_item("The graph is displayed and then tested for planarity. If it");
P.text_item("is planar a straight-line drawing is produced, otherwise, a");
P.text_item("Kuratowski subgraph is highlighted.");
P.button("continue");

P.open();

window W;

GRAPH<point,int>G;
node v,w;
edge e;

int n = 250;
int m = 250;
int embed = 0;


const double pi= 3.14;

panel P1("PLANARITY TEST");

P1.text_item("The first slider asks for the number n of nodes and the second");
P1.text_item("slider asks for the number m of edges. If you select the random");
P1.text_item("button then a graph with n nodes and m edges is constructed, if");
P1.text_item("you select the planar button then a set of random line segments");
P1.text_item("is chosen and intersected to yield a planar graph with about n");
P1.text_item("n nodes, and if you select the edit button the graph editor is");
P1.text_item("called.");
P1.text_item(" ");

P1.int_item("n = ",n,0,1000);
P1.int_item("m = ",m,0,1000);
P1.choice_item("embedding",embed,"FARY","SCHNYDER");

P1.button("random");
P1.button("planar");
P1.button("triang");
P1.button("edit");
P1.button("quit");

for(;;) 
{
  int inp = P1.open(W);

  if (inp == 4) break;   // quit button pressed

  W.init(0,1000,0);
  W.set_node_width(4);

  switch(inp){

  case 0: { G.clear();
            random_graph(G,n,m);
            eliminate_parallel_edges(G);
            
            list<edge>Del= G.all_edges();
            forall(e,Del) 
               if (G.source(e)==G.target(e)) G.del_edge(e);
  
            float ang = 0;
  
            forall_nodes(v,G)
            { G[v] = point(500+400*sin(ang),500+400*cos(ang));
              ang += 2*pi/n;
             }
  
             draw_graph(G,W);
             break;
           }
  
  case 1: { node_array<double> xcoord(G);
            node_array<double> ycoord(G);
            G.clear();
            random_planar_graph(G,xcoord,ycoord,n);
            forall_nodes(v,G)
               G[v] = point(1000*xcoord[v], 900*ycoord[v]);
  
            draw_graph(G,W);
            break;
           }

  case 2: { node_array<double> xcoord(G);
            node_array<double> ycoord(G);
            G.clear();
            triangulated_planar_graph(G,xcoord,ycoord,n);
            forall_nodes(v,G)
               G[v] = point(1000*xcoord[v], 900*ycoord[v]);
  
            draw_graph(G,W);
            break;
           }

  case 3: { W.set_node_width(12);
            G.clear();
            graph_edit(W,G,false);
            break;
           }
  
   }
  
  
  
  if (PLANAR(G,false))
  { 
    if(G.number_of_nodes()<4)
        W.message("That's an insult: Every graph with |V| <= 4 is planar");
    else
      { W.message("G is planar. I compute a straight-line embedding ...");
  
        bool Gin_is_bidirected;
  
        node_array<int>nr(G);
        edge_array<int>cost(G);
        int cur_nr= 0;
        int n = G.number_of_nodes();
        node v;
        edge e;
        
        forall_nodes(v,G)nr[v]= cur_nr++;
        
        forall_edges(e,G)cost[e]= ((nr[source(e)]<nr[target(e)])?
        n*nr[source(e)]+nr[target(e)]:
        n*nr[target(e)]+nr[source(e)]);
        
        G.sort_edges(cost);
        
        list<edge> L= G.all_edges();
  
        list<edge> n_edges;
  
        while(!L.empty())
        { e= L.pop();
  
          if( ! L.empty() && source(e)==target(L.head())   
                          && target(e)==source(L.head()))
             L.pop();
          else
            { n_edges.append(G.new_edge(target(e),source(e)));
              Gin_is_bidirected= false;
             }
         }
  
          make_biconnected_graph(G);
  
          PLANAR(G,true);
  
          node_array<int> xcoord(G),ycoord(G);

          float fx = 900.0/G.number_of_nodes();
          float fy = 900.0/G.number_of_nodes();
  
          if (embed == 0)
          { STRAIGHT_LINE_EMBEDDING(G,xcoord,ycoord);
            fx = 900.0/(2*G.number_of_nodes());
            fy = 900.0/G.number_of_nodes();
            forall(e,n_edges) G.del_edge(e);
            forall_nodes(v,G) G[v] = point(fx*xcoord[v]+30,fy*ycoord[v]+30);
            W.clear();
            if (inp == 0) 
               draw_graph(G,W,true); // with node numbering
            else
               draw_graph(G,W);
            }
          else
          { node a,b,c;
            STRAIGHT_LINE_EMBEDDING2(G,a,b,c,xcoord,ycoord);
            forall(e,n_edges) G.del_edge(e);

            int mx = 0;
            forall_nodes(v,G) 
            if (v != a && xcoord[v] > mx) mx = xcoord[v];
     
            mx += 2;
     
            list<node> A = G.adj_nodes(a);
     
            G.del_node(a);
     
            fx = 900.0/mx;
     
            W.clear();
            forall_nodes(v,G) G[v] = point(fx*xcoord[v]+30,fy*ycoord[v]+30);
     
            draw_graph(G,W);
     
            a = G.new_node(point(fx*mx+30,500));
     
            W.draw_filled_node(G[a],red);
     
            node v;
            forall(v,A)
            { point p(G[a].xcoord(),G[v].ycoord());
              W.draw_filled_node(p,black);
              W.draw_edge(G[v],p,blue);
              W.draw_edge(p,G[a],blue);
             }
          }

        }
     }
  else
    { W.message("Graph is not planar. I compute the Kuratowski subgraph ...");

      list<edge> L;
      edge e;

      PLANAR(G,L,false);

      edge_array<bool> marked(G,false);
      node_array<int> side(G,0);

      forall(e,L) marked[e] = true;

      list<edge> el = G.all_edges();

      forall(e,el) 
        if (!marked[e]) 
          { //W.draw_edge(G[source(e)],G[target(e)],yellow);
            G.del_edge(e);
           }

      int lw = W.set_line_width(3);

      forall_edges(e,G) W.draw_edge(G[source(e)],G[target(e)]);

      node v;
      forall_nodes(v,G) if (G.degree(v) == 3) break; 

      if (G.degree(v) == 3)
        forall_inout_edges(e,v)
        { marked[e] = false;
          node w = G.opposite(v,e);
          while (G.degree(w) == 2)
          { edge x,y;
            forall_inout_edges(x,w) 
               if (marked[x]) y=x;
             marked[y] = false;
             w = G.opposite(w,y);
           }
          side[w] = 1;
         }
        

      int i = 1;
      int j = 4;

      forall_nodes(v,G) 
      { 
        if (G.degree(v)==2) W.draw_filled_node(G[v],black);

        if (G.degree(v) > 2)
        { int nw = W.set_node_width(10);
          if (side[v]==0)
             W.draw_int_node(G[v],i++,green);
          else
             if (W.mono())
                W.draw_int_node(G[v],j++,black);
             else
                W.draw_int_node(G[v],j++,violet);

          W.set_node_width(nw);
         }
      }
      W.set_line_width(lw);
   }

   W.set_show_coordinates(false);
   W.set_frame_label("click any button to continue");
   W.read_mouse(); // wait for a click
   W.reset_frame_label();
   W.set_show_coordinates(true);

 } // for(;;)

return 0;

}
