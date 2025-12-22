#include <LEDA/voronoi.h>
#include <LEDA/graph_alg.h>
#include <LEDA/d_array.h>
#include <LEDA/window.h>




static  int segments_to_points(list<segment>& in, 
                               list<point>& out, 
                               d_array<point,segment>& D, double dist)
{ 
  int count = 0;
  segment s;

  forall(s,in)
  { int n = int(s.length()/dist);
    count = count + n +1;
    double dx = (s.xcoord2() - s.xcoord1())/n;
    double dy = (s.ycoord2() - s.ycoord1())/n;
    double x  = s.xcoord1();
    double y  = s.ycoord1();

    out.append(s.start());
    D[s.start()] = s;

    for(int i = 0; i<n; i++)
    {  x += dx + 0.001 * rrandom();
       y += dy + 0.001 * rrandom();
       point p(x,y);
       D[p] = s;
       out.append(p);
     }

/*
    out.append(s.end());
    count++;
*/

   }

  out.permute();

 return count;

}

static  int polygons_to_points(list<polygon>& in, 
                              list<point>& out, 
                              d_array<point,segment>& D, int pixdist)

{ polygon p;
  int count = 0;

  forall(p,in)
  { list<segment> sl = p.segments();
    count += segments_to_points(sl,out,D,pixdist);
   }
  return count;

 }

/*

static  int circles_to_points(list<circle>& in, 
                              list<point>& out, 
                              d_array<point,circle>& D, double dist)
{ 
  int count = 0;
  circle s;

  forall(s,in)
  { point c = s.center();
    double r = s.radius();
    int n = int(6.283 * r/dist);
    count = count + n +1;
    double alpha = 0;
    double d = 6.283/n;

    for(int i = 0; i<n; i++)
    {  point p = c.translate(alpha,r + 0.0001 * rrandom());
       alpha += d;
       D[p] = s;
       out.append(p);
     }
   }

  out.permute();

 return count;

}

*/



void VORONOI_SEG(list<segment>& sites, double R,GRAPH<point,point>& G, 
                                                             int pixdist = 10)
{ 
  list<point> pl;
  d_array<point,segment> D;

  segments_to_points(sites,pl,D,pixdist);

  VORONOI(pl,R,G);


  // eliminate edges intersecting segments

  list<edge> el;
  edge e;
  point p;

  forall_edges(e,G)  
  { segment s = D[G[e]];
    if (s.intersection(segment(G[source(e)],G[target(e)]),p)) el.append(e);
   }

  forall(e,el) G.del_edge(e);


 }



main()
{

 window W;

 W.init(0,1000,0);

  segment s;
  circle  c;
  polygon p;

  double R = 1000;

  list<point>   pl;
  list<segment> sl;
  list<circle>  cl;
  list<polygon> Pl;

  while ( W >> s ) 
  { W << s;
    sl.append(s);
   }

/*
  while ( W >> c ) 
  { W << c;
    cl.append(c);
   }

  while ( W >> p ) 
  { W << p;
    Pl.append(p);
   }

*/

  int n = 10;

  cout << "Computing Voronoi diagram\n";
  newline;


  GRAPH<point,point> G;

    d_array<point,segment> D;
    d_array<point,circle> D2;
  
    int count = segments_to_points(sl,pl,D,n/W.scale());

            //+ circles_to_points(cl,pl,D2,n)
            //+ polygons_to_points(Pl,pl,D,n);

    cout << count << " points generated.\n";
    newline;


    pl.append(point(-5000,-5000));
    pl.append(point(-5000,5000));
    pl.append(point(5000,5000));
    pl.append(point(5000,-5000));

  
    VORONOI(pl,R,G);

    edge e;


/*
    forall_edges(e,G) W.draw_segment(G[source(e)], G[target(e)]);
    W.read_mouse();
*/

    // eliminate edges intersecting segments

    list<edge> el;

    edge_array<edge> rev(G);

    compute_correspondence(G,rev);

    edge_array<int> deleted(G,false);
  
    forall_edges(e,G)  
     if (!deleted[e])
     { segment s = D[G[e]];
       segment t = segment(G[source(e)], G[target(e)]);
       point p;
       if (s.intersection(t,p)) deleted[e] = deleted[rev[e]] = true;
      }

    W.set_line_width(2);

    forall_edges(e,G) 
        if (!deleted[e]) W.draw_segment(G[source(e)], G[target(e)],blue);

    W.read_mouse();

    return 0;
}
