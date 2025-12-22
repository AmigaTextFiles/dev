#include <LEDA/graph_alg.h>
#include <LEDA/graph_edit.h>
#include <math.h>



window W;
//window w1(440,440,0,125);

void bold_edge(GRAPH<point,int>& G, edge e)
{ point p = G[source(e)];
  point q = G[target(e)];
  W.set_mode(xor_mode);
  W.draw_edge_arrow(p,q,blue);
  int save = W.set_line_width(5);
  W.draw_edge(p,q,blue);
  W.set_line_width(save);
  W.set_mode(src_mode);
}

void unbold_edge(GRAPH<point,int>& G, edge e)
{ int save = W.set_line_width(5);
  point p = G[source(e)];
  point q = G[target(e)];
  W.set_mode(xor_mode);
  W.draw_edge(p,q,blue);
  W.set_line_width(save);
  W.draw_edge_arrow(p,q,blue);
  W.set_mode(src_mode);
}

void show_edge_inf(GRAPH<point,int>& G, edge_array<int>& edge_num)
{ edge e;
  W.set_mode(xor_mode);
  forall_edges(e,G)
  { point p = G[source(e)];
    point q = G[target(e)];
    W.draw_text((p.xcoord()+q.xcoord())/2, (p.ycoord()+q.ycoord())/2,
                  string("%d", edge_num[e]));
   }
  W.set_mode(src_mode);
 }

void show_edge_inf(UGRAPH<point,int>& G, edge_array<int>& edge_num)
{ edge e;
  W.set_mode(xor_mode);
  forall_edges(e,G)
  { point p = G[source(e)];
    point q = G[target(e)];
    W.draw_text((p.xcoord()+q.xcoord())/2, (p.ycoord()+q.ycoord())/2,
                  string("%d", edge_num[e]));
   }
  W.set_mode(src_mode);
 }


void show_node_inf(UGRAPH<point,int>& G, node_array<int>& node_num)
{ node v;
  forall_nodes(v,G)
    W.draw_int_node(G[v],node_num[v],violet);
}

void show_node_inf(GRAPH<point,int>& G, node_array<int>& node_num)
{ node v;
  forall_nodes(v,G)
     W.draw_int_node(G[v],node_num[v],violet);
}

void show_two_node_inf(GRAPH<point,int>& G, node_array<int>& node_num1,
                                            node_array<int>& node_num2)
{ node v;
  forall_nodes(v,G)
  { string s("%d|%d",node_num1[v],node_num2[v]);
    W.draw_text_node(G[v],s);
   }
}

void draw_graph(GRAPH<point,int>& G) 
{ node v,w;
  int i = 0;
  forall_nodes(v,G)
   { W.draw_int_node(G[v],i++,yellow);
     forall_adj_nodes(w,v)
        W.draw_edge_arrow(G[v],G[w],blue);
    }
}

void draw_graph(UGRAPH<point,int>& G) 
{ node v,w;
  int i = 0;
  forall_nodes(v,G)
   { W.draw_int_node(G[v],i++,yellow);
     forall_adj_nodes(w,v)
        W.draw_edge(G[v],G[w],blue);
    }
}


void generate_graph(GRAPH<point,int>& G)
{
  panel P_gen;

  int n = 0;
  int m = 0;

  P_gen.int_item("# nodes", n);
  P_gen.int_item("# edges", m);

  P_gen.button("random");
  P_gen.button("complete");
  P_gen.button("bi_random");
  P_gen.button("bi_complete");

  list<node> A,B;
  node v;

  int xmin = (int)W.xmin();
  int ymin = (int)W.ymin();
  int xmax = (int)W.xmax();
  int ymax = (int)W.ymax();

  int i = P_gen.open();

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
   }

   if (i > 1)
      { double dy = (ymax-ymin)/(n+1);
        double y = ymin + dy;
        forall(v,A) 
        { G[v] = point(xmin + (xmax-xmin)/4,y);
          y += dy;
         }
        y = ymin + dy;
        forall(v,B) 
        { G[v] = point(xmax - (xmax-xmin)/4,y);
          y += dy;
         }
        }
    else // circular embedding 
       { double R  = (xmax-xmin)/2.5;
         double x0 = (xmax-xmin)/2;
         double y0 = (ymax-ymin)/2;
         point  M(x0,y0);
         double alpha = 0;
         double step  = 2*M_PI/n;
         forall_nodes(v,G)  
         { G[v] = M.translate(alpha,R);
           alpha+=step;
          }
        }

}


main()
{
  panel P("Graph Algorithms");

  list<string> alg_menu;
  alg_menu.append(string("topsort"));
  alg_menu.append(string("dfsnum"));
  alg_menu.append(string("components"));
  alg_menu.append(string("strongcomp"));
  alg_menu.append(string("bicomp"));
  alg_menu.append(string("matching"));

  string alg = alg_menu.head();

  P.string_item("algorithm", alg, alg_menu);
  P.button("file");   // 0
  P.button("gen");    // 1
  P.button("edit");   // 2
  P.button("run");    // 3
  P.button("quit");   // 4

  P.display(0,0);

  string file      = "graph.1";

  panel file_panel("FILE PANEL");
  file_panel.string_item("file", file);
  file_panel.button("load");
  file_panel.button("save");

  GRAPH<point,int>  G;
  edge e;

  for(;;)
  { 
    W.del_message();

    int key = P.read();

    if (key == 4) break;

    switch(key) 
    {
      case 0: { int b = file_panel.open(); 
                if (b==0)  // load
                { W.message(string("loading graph from %s",~file));
                  G.clear();
                  G.read(file);
                  W.clear();
                  draw_graph(G);
                 }
                if (b==1)  // save
                { G.write(file);
                  W.message(string("writing graph to %s",~file));
                }
                break;
               }

      case 1: G.clear();
              generate_graph(G);
              W.clear();
              draw_graph(G);
              break;

      case 2: { //graph_edit(w1,G);
                //W.clear();
                //draw_graph(G);
                graph_edit(W,G);
                break;
               }

      case 3: { if (alg == "bicomp")
                { W.message("BICONNECTED COMPONENTS");
                  UGRAPH<point,int> U = G;
                  edge_array<int> edge_num(U);
                  BICONNECTED_COMPONENTS(U,edge_num);
                  show_edge_inf(U,edge_num);
                  W.read_mouse();
                  show_edge_inf(U,edge_num);
                  break;
                 }

                if (alg == "dfsnum")
                { W.message("DFS NUMBERING");
                  node_array<int> dfs_num(G);
                  node_array<int> comp_num(G);
                  DFS_NUM(G,dfs_num,comp_num);
                  show_two_node_inf(G,dfs_num,comp_num);
                  W.read_mouse();
                  draw_graph(G);
                  break;
                 }

                if (alg == "components")
                { W.message("COMPONENTS");
                  UGRAPH<point,int> U = G;
                  node_array<int> node_num(U);
                  COMPONENTS(U,node_num);
                  show_node_inf(U,node_num);
                  W.read_mouse();
                  draw_graph(G);
                  break;
                 }
          
                if (alg == "strongcomp")
                { W.message("STRONG COMPONENTS");
                  node_array<int> node_num(G);
                  STRONG_COMPONENTS(G,node_num);
                  show_node_inf(G,node_num);
                  W.read_mouse();
                  draw_graph(G);
                  break;
                 }

                if (alg == "topsort")
                { W.message("TOPSORT");
                  node_array<int> node_num(G);
                  if (TOPSORT(G,node_num)==false)
                  { W.acknowledge("Graph is cyclic, cannot sort");
                    break;
                   }
                  show_node_inf(G,node_num);
                  W.read_mouse();
                  draw_graph(G);
                  break;
                 }

                if (alg == "matching")
                { W.message("MAX_CARD_MATCHING");
                  list<edge> L = MAX_CARD_MATCHING(G);
                  forall(e,L) bold_edge(G,e);       
                  W.read_mouse();
                  forall(e,L) unbold_edge(G,e);       
                  break;
                 }

                W.acknowledge(alg + " not found");
                break;
          
              }

    } //switch

  } // for(;;)

  return 0;
}
