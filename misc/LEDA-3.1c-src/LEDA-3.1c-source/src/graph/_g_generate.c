/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _g_generate.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#include <LEDA/array.h>
#include <LEDA/graph.h>
#include <LEDA/ugraph.h>
#include <ctype.h>

// some graph generators

void complete_graph(graph& G, int n)
{ node v,w;
  G.clear();
  while (n--) G.new_node();
  forall_nodes(v,G)
     forall_nodes(w,G) 
        G.new_edge(v,w);
}

void complete_ugraph(ugraph& G, int n)
{ int i,j;
  node* V = new node[n];
  G.clear();
  for(i=0;i<n;i++) V[i] = G.new_node();
  for(i=0;i<n;i++) 
    for(j=i+1;j<n;j++) 
       G.new_edge(V[i],V[j]);
}


void grid_graph(graph& G, int n) 
{ node_array<double> xcoord; 
  node_array<double> ycoord;
  grid_graph(G,xcoord,ycoord,n);
 }

void grid_graph(graph& G, node_array<double>& xcoord, 
                          node_array<double>& ycoord, int n) 
{
  array2<node>  A(n,n);
  node v;
  int N = n*n;
  int x;
  int y;

  double d = 1.0/(n+1);

  G.clear();

  xcoord.init(G,N,0);
  ycoord.init(G,N,0);

  for(y=0; y<n; y++)
    for(x=0; x<n; x++)
      { A(x,y) = v = G.new_node();
        xcoord[v] = (x+1)*d;
        ycoord[v] = (y+1)*d;
       }

  for(x=0; x<n; x++)
    for(y=0; y<n; y++)
       { if (x < n-1) G.new_edge(A(x,y),A(x+1,y));
         if (y < n-1) G.new_edge(A(x,y),A(x,y+1));
        }
}


void complete_bigraph(graph& G, int n1, int n2, list<node>& A, list<node>& B)
{ node v,w;

  for(int a=0; a < n1; a++)  A.append(G.new_node());
  for(int b=0; b < n2; b++)  B.append(G.new_node());

  forall(v,A) 
  {  forall(w,B) 
       G.new_edge(v,w);
   }
 }

void user_graph(graph& G)
{ int  n = read_int("|V| = ");
  int  i,j;

  node* V = new node[n];
  for(j=0; j<n; j++) V[j] = G.new_node();

  for(j=0; j<n; j++) 
  { list<int> il;
    bool ok = false;
    while (!ok)
    { ok = true;
      cout << "edges from [" << j << "] to: ";
      il.read();
      forall(i,il) 
        if (i < 0 || i >= n) 
        { ok=false;
          cout << "illegal node " << i << "\n";
         }
     }
    forall(i,il) G.new_edge(V[j],V[i]);
  }
  G.print();
  if (Yes("save graph ? ")) G.write(read_string("file: "));
}



void test_graph(graph& G)
{ 
  G.clear();
  char c;

  do c = read_char("graph: f(ile) r(andom) c(omplete) p(lanar) u(ser): ");
  while (c!='f' && c!='r' && c!='c' && c!='p'&& c!='u');   

  switch (c) {

   case 'f' : { G.read(read_string("file: "));
                break;
               }

   case 'u' : { user_graph(G);
                break;
               }

   case 'c' : { complete_graph(G,read_int("|V| = "));
                break;
               }

   case 'r' : { int n = read_int("|V| = ");
                int m = read_int("|E| = ");
                random_graph(G,n,m);
                break;
               }

   case 'p' : { random_planar_graph(G,read_int("|V| = "));
                break;
               }
   }//switch

}

void test_ugraph(ugraph& G)
{ 
  G.clear();
  char c;

  do c = read_char("graph: f(ile) r(andom) c(omplete) p(lanar) u(ser): ");
  while (c!='f' && c!='r' && c!='c' && c!='p'&& c!='u');   

  int  i;
  node v;
  
  switch (c) {

  case 'f' : { G.read(read_string("file: "));
               break;
              }

   case 'u' : { int  n = read_int("|V| = ");
                int  j = 0;
                node* V = new node[n];
                loop(i,0,n-1) V[i] = G.new_node();
                forall_nodes(v,G)
                  { list<int> il;
                    cout << "edges from " << j++ << " to: ";
                    il.read();
                    forall(i,il) 
                      if (i >= 0 && i < n) G.new_edge(v,V[i]);
                      else cerr << "illegal node " << i << " (ignored)\n";
                   }
                G.print();
                if (Yes("save graph ? ")) G.write(read_string("file: "));
                break;
               }

   case 'c' : { int n = read_int("|V| = ");
                complete_graph(G,n);
                break;
               }

   case 'r' : { int n = read_int("|V| = ");
                int m = read_int("|E| = ");
                random_graph(G,n,m);
                break;
               }

   }//switch

}





void test_bigraph(graph& G, list<node>& A, list<node>& B)
{
  int  a,b,n1,n2;
  char c;

  do c = read_char("bipartite graph: f(ile) r(andom) c(omplete) u(ser): ");
  while (c!='f' && c!='r' && c!='c' && c!='u');   

  A.clear();
  B.clear();
  G.clear();

  if (c!='f') 
   { n1 = read_int("|A| = ");
     n2 = read_int("|B| = ");
    }
  
  
  switch (c) {

  case 'f' : { G.read(read_string("file: "));
               node v;
               forall_nodes(v,G) 
               if (G.outdeg(v) > 0) A.append(v);
               else B.append(v);

               break;
              }

   case 'u' : { node* AV = new node[n1+1];
                node* BV = new node[n2+1];

                loop(a,1,n1)  A.append(AV[a] = G.new_node());
                loop(b,1,n2)  B.append(BV[b] = G.new_node());

                loop(a,1,n1)
                  { list<int> il;
                    cout << "edges from " << a << " to: ";
                    il.read();
                    forall(b,il) if (b<=n2) G.new_edge(AV[a],BV[b]);
                                 else break;
                    if (b>n2) break;
                   }
                break;
               }

   case 'c' : complete_bigraph(G,n1,n2,A,B);
              break;

   case 'r' : { int m = read_int("|E| = ");
                random_bigraph(G,n1,n2,m,A,B);
                break;
               }

       } // switch

}



void cmdline_graph(graph& G, int argc, char** argv)
{ 
  // construct graph from cmdline arguments

  if (argc == 1)           // no arguments 
     { test_graph(G);
       return;
      }
  else 
     if (argc == 2)       // one argument
        { if (isdigit(argv[1][0])) 
             { cout << "complete graph |V| = " << argv[1];
               newline;
               newline;
               complete_graph(G,atoi(argv[1]));
              }
          else 
             { cout << "reading graph from file " << argv[1];
               newline;
               newline;
               G.read(argv[1]);
              }
          return;
         }
     else
        if (argc == 3 && isdigit(argv[1][0]) && isdigit(argv[1][0])) 
           { cout << "random graph |V| = " << argv[1] << "  |E| = " << argv[2];
             newline;
             newline;
             random_graph(G,atoi(argv[1]),atoi(argv[2]));
             return;
            }

  error_handler(1,"cmdline_graph: illegal arguments");
}




//------------------------------------------------------------------------------
// triangulated planar graph
//------------------------------------------------------------------------------


#include <LEDA/d_array.h>


struct triang_point {

double x,y;

LEDA_MEMORY(triang_point)

triang_point(double a=0, double b = 0) { x = a; y = b; }

bool operator==(const triang_point& p) { return x==p.x && y==p.y; }

friend int compare(const triang_point& p, const triang_point& q)
{ int c = compare(p.x,q.x);
  if (c==0) c = compare(p.y,q.y);
  return c;
 }

friend void Print(const triang_point&, ostream&) {}
friend void Read(triang_point&, istream&) {}


friend bool right_turn(const triang_point& a, const triang_point& b, const triang_point& c)
{ return (a.y-b.y)*(a.x-c.x)+(b.x-a.x)*(a.y-c.y) > 0; }

friend bool left_turn(const triang_point& a, const triang_point& b, const triang_point& c)
{ return (a.y-b.y)*(a.x-c.x)+(b.x-a.x)*(a.y-c.y) < 0; }

};



#if !defined(__TEMPLATE_FUNCTIONS__)
LEDA_TYPE_PARAMETER(triang_point)
#endif


void triangulated_planar_graph(graph& G, node_array<double>& xcoord,
                                         node_array<double>& ycoord, int n)
{ 

  list<triang_point> L;
  list<triang_point> CH;
  list_item last;
  triang_point p,q;

  for(int i = 0; i < n; i++)

  L.append(triang_point(rrandom(),rrandom()));

  L.sort();  // sort triang_points lexicographically


  // eliminate multiple triang_points

  list_item it;
  forall_items(it,L)
  { list_item it1 = L.succ(it);
    while (it1 != nil && L[it1] == L[it])
    { L.del(it1);
      it1 = L.succ(it);
     }
   }

  n = L.length();

  d_array<triang_point,node> V(nil);

  xcoord.init(G,n,0);
  ycoord.init(G,n,0);

  forall(p,L) 
  { node v = G.new_node();
    xcoord[v] = p.x;
    ycoord[v] = p.y;
    V[p] = v;
   }


  // initialize convex hull with first two points

  p = L.pop();
  CH.append(p);

  while (L.head() == p) L.pop();
  q = L.pop();
  last = CH.append(q);

  G.new_edge(V[p],V[q]);


  // scan remaining points

  forall(p,L)
  {
    node v = V[p];

    G.new_edge(v,V[CH[last]]);

    // compute upper tangent (p,up)

    list_item up = last;
    list_item it = CH.cyclic_succ(up);

    while (left_turn(CH[it],CH[up],p))
    { up = it;
      it = CH.cyclic_succ(up);
      G.new_edge(v,V[CH[up]]);
     }


    // compute lower tangent (p,low)

    list_item low = last;
    it = CH.cyclic_pred(low);

    while (right_turn(CH[it],CH[low],p))
    { low = it;
      it = CH.cyclic_pred(low);
      G.new_edge(v,V[CH[low]]);
     }


    // remove all points between up and low

    if (up != low)
    { it = CH.cyclic_succ(low);

      while (it != up)
      { CH.del(it);
        it = CH.cyclic_succ(low);
       }
     }

    // insert new point

    last = CH.insert(p,low);

   }

}

void triangulated_planar_graph(graph& G, int m)
{ node_array<double> xcoord;
  node_array<double> ycoord;
  triangulated_planar_graph(G,xcoord,ycoord,m);
 }
