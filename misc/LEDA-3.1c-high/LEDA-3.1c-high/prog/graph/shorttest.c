#include <LEDA/stream.h>
#include <LEDA/ugraph.h>
#include <LEDA/node_pq.h>
#include <LEDA/b_node_pq.h>

int  dijkstra1(UGRAPH<int,int>& g, node source, node target) 
{
  // use a linear list priority queue  (node_list)
  // and node_data<int> for dist values

  node_data<int> dist(g,MAXINT); // initialize labels
  node_list      labeled;        // candidate nodes
  node v;

  dist[source] = 0;

  labeled.push(source);

  while ( ! labeled.empty() )
  {
    // find node v with minimal dist[v] by linear search

    v = labeled.first();
    int dv = dist[v];
    node u = labeled.succ(v);
    while (u)
    { if (dist[u] < dv)  { v = u; dv = dist[v]; }
       u = labeled.succ(u);
     }
      

    if (v == target) break;

    edge e;

    forall_adj_edges(e,v) 
    { node w = g.opposite(v,e);
      int  d = dist[v] + g.inf(e);
      if (dist[w] > d) 
      { if (dist[w] == MAXINT) labeled.append(w); // first time touched
	dist[w] = d;
       }
      }

    labeled.del(v);
  } 

  return dist[v];
}

int  dijkstra2(UGRAPH<int,int>& g, node source, node target) 
{
  // use a node priority queue (node_pq)
  // and node_data<int> for dist values

  node_data<int> dist(g,MAXINT); // initialize labels
  dist[source] = 0;

  node_pq<int> PQ(g);             // candidate nodes
  PQ.insert(source,0);

  while (! PQ.empty())
  { 
    node v = PQ.del_min();
    int dv = dist[v];

    if (v == target) break;

    edge e;
    forall_adj_edges(e,v)
    { node w = g.opposite(v,e);
      int d = dv + g.inf(e);
      if (d < dist[w]) 
      { if (dist[w] == MAXINT)
           PQ.insert(w,d);
        else
           PQ.decrease_inf(w,d);
        dist[w] = d;
       }
    }

  }

  return dist[target];
}




int dijkstra3(UGRAPH<int,int>& g, node s, node t) 
{
  // use a bounded node priority queue (b_node_pq)
  // and a node_array<int> for dist values

  node_array<int> dist(g,MAXINT);

  b_node_pq<101> PQ(t);  // on empty queue del_min returns t 

  dist[s] = 0;

  for (node v = s;  v != t; v = PQ.del_min() )
  { 
    int dv = dist[v];

    edge e;
    forall_adj_edges(e,v) 
    { node w = g.opposite(v,e);
      int d = dv + g.inf(e);
      if (d < dist[w])
      { if (dist[w] != MAXINT) PQ.del(w);
	dist[w] = d;
        PQ.insert(w,d);
       }
     }
   }

  return dist[t];
}


int dijkstra4(UGRAPH<int,int>& g, node s, node t) 
{
  // use a bounded node priority queue (b_node_pq)
  // and node_data<int> for dist values

  node_data<int> dist(g,MAXINT);

  b_node_pq<101> PQ(t);  // on empty queue del_min returns t 

  dist.set(s,0);

  for (node v = s;  v != t; v = PQ.del_min() )
  { 
    int dv = dist(v);

    edge e;
    forall_adj_edges(e,v) 
    { node w = g.opposite(v,e);
      int d = dv + g.int_inf(e);
      if (d < dist(w))
      { if (dist(w) != MAXINT) PQ.del(w);
	dist.set(w,d);
        PQ.insert(w,d);
       }
     }
   }

  return dist(t);
}


int  moore1(UGRAPH<int,int>& g, node source, node target)
{
  // use a queue of candidate nodes (node_list)
  // and node_data<int> for dist values

  node_data<int> dist(g,MAXINT);   // initialize labels
  dist[source] = 0;

  node_list labeled;               // queue of candidate nodes
  labeled.append(source);

  while (! labeled.empty()) 
  { node v = labeled.pop();
    int dv = dist[v];

    if (dv >= dist[target]) continue;

    edge e;
    forall_adj_edges(e,v) 
    { node w = g.opposite(v,e);
      int d = dv + g.inf(e);
      if (d < dist[w]) 
      { if (!labeled(w)) labeled.append(w);
	dist[w] = d;
       }
     }

   }

  return dist[target];

}


int  moore2(UGRAPH<int,int>& g, node source, node target) 
{
  // use a double ended queue of candidate nodes (node_list)
  // and a node_array<int> for dist values

  node_array<int> dist(g,MAXINT); // initialize labels
  dist[source] = 0;

  node_list labeled;             // deque of candidate nodes
  labeled.append(source);

  while (! labeled.empty()) 
  { 
    node v = labeled.pop();
    int dv = dist[v];

    if (dv > dist[target]) continue;

    edge e;
    forall_adj_edges(e,v)
    { node w = g.opposite(v,e);
      int  d = dv + g.inf(e);
      if (d < dist[w]) 
      { if ( ! labeled(w) ) 
        { if (dist[w] == MAXINT)
	       labeled.append(w);
	    else
	       labeled.push(w);
	   }
	  dist[w] = d;
       }
     }

  }

  return dist[target];
}


int  moore3(UGRAPH<int,int>& g, node source, node target) 
{
  // use a double ended queue of candidate nodes (node_list)
  // and node_data<int> for dist values

  node_data<int> dist(g,MAXINT); // initialize labels
  dist.set(source,0);

  node_list labeled;             // deque of candidate nodes
  labeled.append(source);

  while (! labeled.empty()) 
  { 
    node v = labeled.pop();
    int dv = dist(v);

    if (dv > dist(target)) continue;

    edge e;

    forall_adj_edges(e,v)
    { node w = g.opposite(v,e);
      int  d = dv + g.int_inf(e);
      if (d < dist(w)) 
      { if ( ! labeled(w) ) 
        { if (dist(w) == MAXINT)
	       labeled.append(w);
	    else
	       labeled.push(w);
	   }
	  dist.set(w,d);
       }
     }

  }

  return dist(target);
}




int main (int argc, char** argv) 
{
  UGRAPH<int,int>   g;

  int sourcename;
  int targetname;
  int len;

  string filename = "grid100";

  if (argc > 1) filename = argv[1];

  // read names of source and target from file <filename>

  file_istream  infile (filename);

  if ( ! (infile >> sourcename >> targetname) )
  { cerr << "Cannot read file " << filename << endl;
    exit(1);
   }

  cout << "Source node: " << sourcename << endl;
  cout << "Target node: " << targetname << endl;
  newline;

  // read graph from file <filename>.graph

  float t0 = used_time();

  if (g.read(filename + ".graph") != 0)
  { cerr << "Cannot read graph from file " << filename << ".graph" << endl;
    exit(1);
   }

  cout << string("Time for reading:  %5.2f",used_time(t0)) << endl;
  newline;


  // search for source and target nodes

  node source = nil;
  node target = nil;

  node v;
  forall_nodes(v,g) 
  { if (g.inf(v) == sourcename) source = v;
    if (g.inf(v) == targetname) target = v;
   }



  t0 = used_time();

  if (g.number_of_edges() < 20000)
  { len = dijkstra1(g, source, target);
    cout <<string("Time for dijkstra1: %5.3f pathlength: %d",used_time(t0),len);
    newline;
   }
  
  len = dijkstra2(g, source, target);
  cout <<string("Time for dijkstra2: %5.3f pathlength: %d",used_time(t0),len);
  newline;
  
  len = dijkstra3(g, source, target);
  cout <<string("Time for dijkstra3: %5.3f pathlength: %d",used_time(t0),len);
  newline;

  len = dijkstra4(g, source, target);
  cout <<string("Time for dijkstra4: %5.3f pathlength: %d",used_time(t0),len);
  newline;
  
  len = moore1(g, source, target);
  cout <<string("Time for moore1:    %5.3f pathlength: %d",used_time(t0),len);
  newline;
  
  len = moore2(g, source, target);
  cout <<string("Time for moore2:    %5.3f pathlength: %d",used_time(t0),len);
  newline;

  len = moore3(g, source, target);
  cout <<string("Time for moore3:    %5.3f pathlength: %d",used_time(t0),len);
  newline;

  return 0;
}
