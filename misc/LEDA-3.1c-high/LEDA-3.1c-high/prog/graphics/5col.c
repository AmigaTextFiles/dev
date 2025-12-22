#include <LEDA/graph_edit.h>
#include <LEDA/ugraph.h>
#include <LEDA/stack.h>
#include <LEDA/array.h>

window win;

bool trace;
bool step;

#if !defined(__TEMPLATE_FUNCTIONS__)
int compare(list<node>&, list<node>&) { return 0; }
LEDA_TYPE_PARAMETER(list<node>)
#endif


void FIND_INDEPENDENT_NEIGHBORS(const ugraph& G, const node_array<int>&, 
                                node v, node& u, node& w);

int  UNUSED_ADJ_COLOR(node v, const node_array<int>& col);


void FIVE_COLOR(const GRAPH<point,int>& G, node_array<int>& C)
{
  // G is a planar graph

  UGRAPH<point,int> G1;



  G1 = G;

  //we have to avoid parallel edges


  node_array<int>  C1(G1,0);       // C1[v] = color of node v in G1
  node_array<bool> mark(G1,false);
  node_array<int>  deg(G1);        // deg[v] = current degree of v

  list<node> small_deg;            // list of nodes with deg[v] <= 5
  node_array<list_item> I(G1,nil); // I[v] = location of v in small_deg

  node_array<list<node> > L(G1);   // L[v] = list of nodes of G represented by v

  stack<node>  removed;            // stack of (conceptually) removed nodes

  int N;                           // current number of valid nodes of G1


  // Initialization

  N = G1.number_of_nodes();

  node u,v,w,x;

  u = G.first_node();

  forall_nodes(v,G1)
  { deg[v] = G1.degree(v);
    if(deg[v] <= 5) I[v] = small_deg.append(v);
    L[v].append(u);
    u = G.succ_node(u);
   }

  // shrinking G1

if (trace) win.message("shrinking graph G ---> G1");

  while (N > 0)
  {
    forall_nodes(v,G1)
    { int d = 0;
      forall_adj_nodes(x,v) if (C1[x] != -1) d++;
      if (C1[v] != -1 && deg[v] != d) 
      { win.draw_filled_node(G1[v]); 
        error_handler(1,string("N = %d  deg = %d   d = %d",N,deg[v],d));
       }
     }

    if (small_deg.empty())
       error_handler(1,"smalldeg is empty");

    v = small_deg.pop();

    I[v] = nil;

    if (trace) 
    { win.set_mode(xor_mode);
      win.draw_text_node(G1[v],"?");
      win.draw_filled_node(G1[v]);
      win.set_mode(src_mode);
     }

    if (deg[v] == 5)
    {
      FIND_INDEPENDENT_NEIGHBORS(G1,C1,v,u,w);

      if (w == u) error_handler(1,"merging identical nodes"); //parallel edges

      if(trace)
      { win.set_mode(xor_mode);
        win.draw_text_node(G1[w],"?");
        win.draw_filled_node(G1[w]);
        win.draw_filled_node(G1[u]);
        win.draw_edge(G1[v],G1[u]);
        win.draw_edge(G1[v],G1[w]);
        win.set_line_width(2);
        win.draw_edge(G1[v],G1[u]);
        win.draw_edge(G1[v],G1[w]);
        if (step) win.read_mouse();
        win.draw_edge(G1[v],G1[u]);
        win.draw_edge(G1[v],G1[w]);
        win.set_line_width(1);
        win.draw_edge(G1[v],G1[u]);
        win.draw_edge(G1[v],G1[w]);
        win.draw_filled_node(G1[v]);
        win.draw_node(G1[v]);
       }

      { forall_adj_nodes(x,u) mark[x] = true; }

      forall_adj_nodes(x,w)
      { if (x == u) error_handler(1,"merging adjacent nodes");
        if (mark[x]) 
           { deg[x]--;
             if (deg[x] == 5) 
                I[x] = small_deg.append(x);
            }
        else
           { G1.new_edge(u,x,0);
             if (C1[x] != -1) deg[u]++;  
             if(trace) win.draw_edge(G1[u],G1[x]);
            }
       }

      { forall_adj_nodes(x,u) mark[x] = false; }

      deg[v]--;


      if (deg[u] > 5 && I[u] != nil)
      { small_deg.del(I[u]);
        I[u] = nil;
       }

      L[u].conc(L[w]);
     
      if (I[w] != nil) small_deg.del(I[w]);


      if (trace)
      { forall_adj_nodes(x,w) win.draw_edge(G1[w],G1[x]);
        win.draw_filled_node(G1[w]);
        win.draw_filled_node(G1[u]);
        win.set_mode(src_mode);
       }

      G1.del_node(w);

      N--;

    }

    if (step)  win.read_mouse();

    //  now deg[v] <= 4

    C1[v] = -1;
    removed.push(v);

    forall_adj_nodes(x,v)
       if ( --deg[x] == 5) 
         I[x] = small_deg.append(x);

    N--;
   }

if (trace)
{ win.read_mouse();
  win.del_message();
  win.message("coloring G1");
}


   // now color the nodes in "removed" from top to bottom

   while ( ! removed.empty() )
   { v = removed.pop();

     int c = UNUSED_ADJ_COLOR(v,C1);

     if (c == 5) error_handler(1,"more than 5 different adjacent colors");

     C1[v] = c;
     forall(x,L[v]) C[x] = c;

     if (trace) win.draw_int_node(G1[v],c);
     if (step)  win.read_mouse();

    }


    if (trace) 
    { edge e;
      win.read_mouse();
      win.del_message();
      win.message("coloring G");
      win.set_mode(xor_mode);
      forall_edges(e,G1) win.draw_edge(G1[source(e)],G1[target(e)]);
      win.set_mode(src_mode);
     }
}


     
void  FIND_INDEPENDENT_NEIGHBORS(const ugraph& G, const node_array<int>& col,
                                 node v, node& u, node& w)
{ node x;
  list<node> L;

  forall_adj_nodes(x,v)
      if (col[x] != -1) L.append(x);

  for (list_item it1 = L.first(); it1 != nil; it1 = L.succ(it1))
    { u = L[it1];
      for (list_item it2 = L.succ(it1); it2 != nil; it2 = L.succ(it2))
        { w = L[it2];
          forall_adj_nodes(x,w) if (x == u) break;
          G.init_adj_iterator(w);
          if (x != u) return;
         }
     }

  error_handler(1,"no independent neighbors found!");
  return;
 }


int UNUSED_ADJ_COLOR(node v, const node_array<int>& col)
{ 
  int used[6];
  int c;
  node x;

  for(c = 0; c < 6; c++) used[c] = 0;

  forall_adj_nodes(x,v)
  { c = col[x];
    if (c != -1) used[c] = 1;
   }

  c = 0; 
  while(used[c]) c++;

  return c;
 }



void grid_graph(GRAPH<point,int>& G, int n, float win_width)
{
  array2<node>  A(n,n);
  float dist = win_width/(n+3);
  int i,j;

  G.clear();

  for(i=0; i<n; i++)
    for(j=0; j<n; j++)
      A(i,j) = G.new_node(point(dist*(j+2),dist*(i+2)));


  for(i=0; i<n; i++)
    for(j=0; j<n; j++)
       { if (i < n-1) G.new_edge(A(i,j),A(i+1,j));
         if (j < n-1) G.new_edge(A(i,j),A(i
,j+1));
         if (i < n-1 && j < n-1) G.new_edge(A(i,j),A(i+1,j+1));
        }

  node north = G.new_node(point(dist*((n-1)/2.0 + 2),dist*(n+2)));
  node south = G.new_node(point(dist*((n-1)/2.0 + 2),dist));
  node west  = G.new_node(point(dist,dist*((n-1)/2.0 + 2)));
  node east  = G.new_node(point(dist*(n+2),dist*((n-1)/2.0 + 2)));

  for(i=0; i < n; i++)
  { G.new_edge(north,A(n-1,i));
    G.new_edge(south,A(0,i));
    G.new_edge(west,A(i,0));
    G.new_edge(east,A(i,n-1));
   }
  
  //G.new_edge(A(0,n-1),A(n-1,0));

/*
  list<edge> E = G.all_edges();
  edge e;
  forall(e,E) G.new_edge(target(e),source(e));
*/

}

         
char* COLOR[] = {"blue","red","green","violet","orange"};
    
main()
{
  GRAPH<point,int>  G;
  node v;
  edge e;



  int n = 8;
  int t = 0;

  win.init(0,1000,0);
  win.set_node_width(10);

  panel P("five coloring a planar graph");

  P.choice_item("trace",t,"off","step","movie");
  P.int_item("N = ",n,1,30);
  P.button("edit");
  P.button("grid");
  P.button("quit");

  for(;;)
  { 

    int inp = P.open(win);
    
    trace = (t > 0);
    step  = (t == 1);

    if (inp == 2) break;

    win.clear();

    if (inp == 0) graph_edit(win,G,false);
   
    if (inp == 1) grid_graph(G,n,1000);

    forall_nodes(v,G) win.draw_text_node(G[v],"?");
    forall_edges(e,G) win.draw_edge(G[source(e)],G[target(e)]);

    node_array<int> col(G,-1);

    FIVE_COLOR(G,col);

    forall_edges(e,G) win.draw_edge(G[source(e)],G[target(e)]);
    forall_nodes(v,G) win.draw_int_node(G[v],col[v],col[v]+2);

    win.set_frame_label("click any button to continue");
    win.read_mouse();
    win.reset_frame_label();

  }

  return 0;

}
