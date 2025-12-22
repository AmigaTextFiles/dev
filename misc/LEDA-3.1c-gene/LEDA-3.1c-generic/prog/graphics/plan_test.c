#include <LEDA/window.h>
#include <LEDA/graph_alg.h>
#include <LEDA/graph_edit.h>


main()
{
  window W;
  panel P;
  
  GRAPH<point,int>G;
  node v,w;
  edge e;
  
  int N = 1000;
  int input= 0;
  
  P.choice_item("input",input,"edit","random");
  P.int_item("|V| = ",N,0,2000);
  
  for(;;)
  {
    G.clear();

    P.open(5,5);
    W.init(0,100,0);
    
    if(input == 1)
      { W.set_node_width(3);
        node_array<double> xcoord;
        node_array<double> ycoord;
        random_planar_graph(G,xcoord,ycoord,N);
        node v;
        forall_nodes(v,G) 
           { xcoord[v] *= 100;
             ycoord[v] *= 100;
             W.draw_node(xcoord[v],ycoord[v]);
            }
    
        edge e;
        forall_edges(e,G)
           W.draw_edge(xcoord[source(e)],ycoord[source(e)],
                       xcoord[target(e)],ycoord[target(e)]);
       }
    else
      { W.set_node_width(12);
        graph_edit(W,G,false);
       }
    
    
    
    W.del_message();
    W.message(string("PLANARITY TEST  |V| = %d",G.number_of_nodes()));
    
    list<edge>L;
    
    if(Eplanar(G,L))
    { 
      if(G.number_of_nodes() < 4)
        { W.clear();
          W.message("That's an insult: Every graph with less than 4 nodes is planar");
         }
      else 
        {
          W.message("Graph is planar. I compute an embedding for you ... ");

    
          node_array<int>nr(G);
          edge_array<int>cost(G);
          int cur_nr= 0;
          int n= G.number_of_nodes();
          node v;
          edge e;
          
          forall_nodes(v,G)nr[v]= cur_nr++;
          
          forall_edges(e,G)cost[e]= ((nr[source(e)]<nr[target(e)])?
          n*nr[source(e)]+nr[target(e)]:
          n*nr[target(e)]+nr[source(e)]);
          
          G.sort_edges(cost);
          
          list<edge>L= G.all_edges();
          
          while(!L.empty())
          { e= L.pop();
    
           if(!L.empty()&&(source(e)==target(L.head()))&&(source(L.head())==target(e)))
               L.pop();
           else 
               G.new_edge(target(e),source(e));
           }
    
     
          make_biconnected(G);
    
          Planar(G);
    
          node_array<int> xcoord(G);
          node_array<int> ycoord(G);

          STRAIGHT_LINE_EMBEDDING(G,xcoord,ycoord);
    
          forall_nodes(v,G) ycoord[v] *= 2;

          W.init(-1,2*G.number_of_nodes()+1,-1);
    
          if (input == 1)
             forall_nodes(v,G) W.draw_node(xcoord[v],ycoord[v]);
          else
             { int i = 0;
               forall_nodes(v,G) W.draw_int_node(xcoord[v],ycoord[v],i++);
              }
    
          forall_edges(e,G)
          W.draw_edge(xcoord[source(e)],ycoord[source(e)],
                      xcoord[target(e)],ycoord[target(e)]);
         }
       }
    else
      {
        W.message("Graph is not planar. I show you the Kuratowski subgraph");
        W.set_line_width(5);
        edge e;
        forall(e,L)W.draw_edge(G[source(e)],G[target(e)]);
        W.set_line_width(1);
       }
    
   } //for(;;)
  
  
  return 0;
  
}
        
