#include <LEDA/graph.h>
#include <LEDA/graph_alg.h>
#include <LEDA/array.h>
#include <LEDA/stream.h>
#include <LEDA/array.h>
#include <LEDA/window.h>
#include <math.h>



typedef GRAPH<vector,int> polyhedron;

void rotate(float alpha1,float alpha2, vector& p)
{ 
  // rotate 3d-point p about the origin
  // by alpha2 in yz-plane and alpha1 in xy-plane

    double R  = hypot(p[1],p[2]);
    double phi = asin(p[1]/R);
  
    if (p[2] < 0) phi = M_PI - phi;
  
    p[1]  = ((R != 0) ? R*sin(phi+alpha2) : 0);
    p[2]  = ((R != 0) ? R*cos(phi+alpha2) : 0);

    R   = hypot(p[0],p[2]);
    phi = asin(p[0]/R);

    if (p[2] < 0) phi = M_PI - phi;
  
    p[0]  = ((R != 0) ? R*sin(phi+alpha1) : 0);
    p[2]  = ((R != 0) ? R*cos(phi+alpha1) : 0);
}


point project(vector p)   // project p into xy-plane
{
  return point(p[0],p[1]); 
 }



void draw_poly(window& W, polyhedron& poly, vector& trans)
{ node v,w;
  node_array<bool> marked(poly,false);
  forall_nodes(v,poly) 
  { forall_adj_nodes(w,v)
      if (!marked[w])
      { point a = project(poly[v]+trans);
        point b = project(poly[w]+trans);
        W.draw_segment(a,b,blue);
       }
    marked[v] = true;
   }
 }

/*
void draw_poly(window& W, polyhedron& poly, vector& trans)
{ edge e;
  forall_edges(e,poly) 
  { point a = project(poly[source(e)]+trans);
    point b = project(poly[target(e)]+trans);
    W.draw_segment(a,b,blue);
   }
 }
*/


void make_poly(polyhedron& poly, int N)
{ 
  
    node* L = new node[N];
    node* R = new node[N];
  
    float d = 2*M_PI/N;

    node v;

    poly.clear();
  
    for(int i=0; i<N; i++)
    { point origin(0,0);
      point p = origin.translate(i*d,100);
      L[i] = poly.new_node(vector(p.xcoord(),p.ycoord(), 120));
      R[i] = poly.new_node(vector(p.xcoord(),p.ycoord(),-120));
     }

    node v0 = poly.new_node(vector(0,0,-30));
  
    for(i=1; i<N; i++)
    { poly.new_edge(L[i],L[i-1]);
      poly.new_edge(L[i-1],L[i]);
      poly.new_edge(R[i],R[i-1]);
      poly.new_edge(R[i-1],R[i]);
      poly.new_edge(L[i],R[i]);
      poly.new_edge(R[i],L[i]);
      poly.new_edge(v0,R[i]);
      poly.new_edge(R[i],v0);
     }
  
    poly.new_edge(L[0],L[N-1]);
    poly.new_edge(L[N-1],L[0]);
    poly.new_edge(R[0],R[N-1]);
    poly.new_edge(R[N-1],R[0]);
    poly.new_edge(L[0],R[0]);
    poly.new_edge(R[0],L[0]);
    poly.new_edge(v0,R[0]);
    poly.new_edge(R[0],v0);

    if (!PLANAR(poly,true)) error_handler(1,"graph not planar !");

    // compute an interior point M and move the origin to this point
  
    vector M(3);
  
    forall_nodes(v,poly)
    {  M[0] += poly[v][0];
       M[1] += poly[v][1];
       M[2] += poly[v][2];
     }
  
  
    M[0] /= poly.number_of_nodes();
    M[1] /= poly.number_of_nodes();
    M[2] /= poly.number_of_nodes();
  
  
    forall_nodes(v,poly)
    { poly[v][0] -= M[0];
      poly[v][1] -= M[1];
      poly[v][2] -= M[2];
     }
  
}



void make_sphere(GRAPH<vector,int>& G, int n)
{
  int m = 2*n;

  array<node>  V(m);

  node north = G.new_node(vector(0,0, 1));

  int i;
  int j;
  double phi1 = 0;
  double phi2 = 0;
  double d1 = M_PI/n;
  double d2 = M_PI/n;

  for(i=0; i<m; i++) V[i] = north;

  for(phi1=d1, j=1; j<n; phi1+=d1, j++)
  { double z = cos(phi1);
    double r = sin(phi1);

    for(phi2=0, i=0; i<m; phi2+=d2, i++)
    {
      double x = r*cos(phi2);
      double y = r*sin(phi2);

      node v = G.new_node(vector(x,y,z));

      if(i==0) 
      { G.new_edge(v,V[i]);
        G.new_edge(V[i],v);
        if (j > 1)  
        { G.new_edge(V[0],V[m-1]);
          G.new_edge(V[m-1],V[0]);
         }
       }
      else
       { G.new_edge(v,V[i-1]);
         G.new_edge(V[i-1],v);
         G.new_edge(v,V[i]);
         G.new_edge(V[i],v);
        }
      V[i] = v;
     }

   }

  node south = G.new_node(vector(0,0,-1));

  G.new_edge(V[m-1],V[0]);
  G.new_edge(V[0],V[m-1]);

  for (i=0;i<m;i++) 
  { G.new_edge(south,V[i]);
    G.new_edge(V[i],south);
   }


  node v;

  forall_nodes(v,G) G[v] = G[v]*100;

  if (!PLANAR(G,true)) error_handler(1," G not planar !");

}





void read_poly(polyhedron& poly, string fname)
{
  poly.clear();

  file_istream IN(fname);

  int N;
  int i;

  IN >> N;


  array<node> V(N);

  vector v(3);

  for(i = 0; i<N; i++) 
  { IN >> v;
    V[i] = poly.new_node(v);
   }

/*
  for(i = 0; i<N; i++) 
  { int d;
    IN >> d;
    while(d--)
    { IN >> j;
      poly.new_edge(V[i], V[j])
     }
   }
*/

  for(i = 0; i<N; i++) 
  { int u,v,w;
    IN >> u >> v >> w;
    poly.new_edge(V[u], V[v]);
    poly.new_edge(V[v], V[w]);
    poly.new_edge(V[w], V[u]);
  }

}




main()
{ 
  window W(700,700);

  W.init(-250,250,-250);
  W.set_node_width(4);
  W.set_mode(xor_mode);

  node v;

  int     N = 5;
  int speed = 40;
  bool  ran = false;

 panel P("Rotate Polyhedron");

 P.text_item("");
 P.text_item("This program creates and rotates a 3-dimensional polyhedron.");
 P.text_item("Direction and duration of the rotation is controled by the");
 P.text_item("left mouse button.");
 P.text_item("");
 P.bool_item("random",ran);
 P.int_item("speed",speed,1,80);
 P.int_item("# vertices",N,3,32);



 for(;;)
 {
    P.open(W);

    W.clear();

    // define a polyhedron in 3d space
  
    polyhedron poly;

    //make_poly(poly,N);
    make_sphere(poly,N);
  
  
  
    forall_nodes(v,poly) rotate(1.5,0.7,poly[v]);

    W.draw_point(0,0);
  
  
    polyhedron poly0 = poly;

    vector dir(2);   // direction and duration of rotation
    //vector trans(50,50,50);  // translation
    vector trans(0,0,0);  // translation
    int steps;

    draw_poly(W,poly,trans);
  
    for(;;)
    {
      if (ran)
      { dir[0] += random(-10000,10000)/(5000000.0);
        dir[1] += random(-10000,10000)/(5000000.0);
        dir = dir.norm()*(speed/500.0);
        steps = 1;
        if (W.get_button() != 0) break;
       }
      else
      { int but = W.read_mouse(dir[0],dir[1]);
        steps = int(dir.length()*W.scale())/8;
        if (but == 3) break;
        dir = dir.norm()*(speed/500.0);
       }

  

      while (steps--)
      {  
        forall_nodes(v,poly) rotate(dir[0],dir[1],poly[v]);
   
        draw_poly(W,poly,trans);   // draw new position
        draw_poly(W,poly0,trans);  // erase old position  (xor_mode !!)
  
        // poly0 = poly;
  
        node w = poly.first_node();
        forall_nodes(v,poly0) 
        { poly0[v] = poly[w];
          w = poly.succ_node(w);
         }
      }
    }

  }

 return 0;
}
