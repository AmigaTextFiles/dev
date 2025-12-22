/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _mc_matching.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


/*******************************************************************************
*
*  MAX_CARD_MATCHING  (maximum cardinality matching)
*
*  An implementation of Edmonds' algorithm 
*
*
*  J. Edmonds:  Paths, trees, and flowers 
*               Canad. J. Math., Vol. 17, 1965, 449-467
*
*  R.E. Tarjan: Data Structures and Network Algorithms,
*               CBMS-NFS Regional Conference Series in Applied Mathematics,
*               Vol. 44, 1983
*
*
*  running time: O(n*m*alpha(n))
*
*
*  S. Naeher (October 1991)
*
*******************************************************************************/


#include <LEDA/graph_alg.h>
#include <LEDA/node_partition.h>


enum LABEL {ODD, EVEN, UNREACHED};

static int cmp_degree(const node& v,const node& w)  // compare indeg of v and w
{ return indeg(v) - indeg(w); }


static int greedy( graph &G, node_data<node>& mate )   // greedy heuristic
{ node v;
  int count = 0;
  forall_nodes(v,G)
    if (mate[v] == nil)
    { edge e;
      forall_adj_edges(e,v)
      { node w = target(e);
        if (v != w && mate[w] == nil) 
        { mate[v] = w;
          mate[w] = v;
          count++;
          break;
         }
       }
     }
   return count;
 }



static void heuristic( graph &G, node_data<node>& mate )
{
 // Heuristic (Markus Paul):
 // finds almost all augmenting paths of length <=3 with two passes over
 // the adjacency lists
 // ("almost": discovery of a blossom {v,w,x,v} leads to a skip of the
 // edge (x,v), even if the base v stays unmatched - it's not worth while
 // to fix this problem)
 // if all adjacent nodes w of v are matched, try to find an other 
 // partner for mate[x], and match v and w on success

  node u,v;
  bool found;
  node_data<int> all_matched(G,false);

  forall_nodes( v, G )
  {
    edge e = G.first_adj_edge(v);

    if( mate[v]==nil )
    {
        while(e != nil && mate[target(e)]!=nil) e = G.adj_succ(e);

        if( e != nil ) 
          { mate[v] = target(e);  
            mate[target(e)] = v ;  
           }
        else // second pass
          {
	    all_matched[v] = true;

            forall_adj_edges(e,v)
            {
              node w = target(e);
              node x = mate[w];
    
              if( ! all_matched[x] ) 
              {
                while((found=G.next_adj_node(u,x)) && (u==v || mate[u]!=nil));
    
                if( found ) 
                  { mate[u] = x;  mate[x] = u ;
                    mate[v] = w;  mate[w] = v ;
                    G.init_adj_iterator(x);
                    break;
    	           }
	        else
                   all_matched[x] = true;
               }
             }
           }
        } 
    }

}




static void find_path(list<node>& L, node_array<int>&  label,
                                     node_array<node>& pred,
                                     node_data<node>& mate,
                                     node_array<edge>& bridge,
                                     node x, node y)
{
  /* computes an even length alternating path from x to y begining with a 
     matching edge (Tarjan: Data Structures and Network Algorithms, page 122)
     Preconditions: 
     a) x and y are even or shrinked
     b) when x was made part of a blossom for the first time, y was a base 
        and predecessor of the base of that blossom
   */

 if (x==y) 
 { // [ x ]
   L.append(x);
   return;
  }

 if (label[x] == EVEN) 
 { // [ x --> mate[x] --> path(pred[mate[x]],y) ]
   find_path(L,label,pred,mate,bridge,pred[mate[x]],y);
   L.push(mate[x]);
   L.push(x);
   return;
 }

 if (label[x] == ODD) 
 { // [ x --> REV(path(source(bridge),mate[x])) --> path(target(bridge),y)) ]
   node v;
   list<node> L1;
   find_path(L,label,pred,mate,bridge,target(bridge[x]),y);
   find_path(L1,label,pred,mate,bridge,source(bridge[x]),mate[x]);
   forall(v,L1) L.push(v);
   L.push(x);
   return;
  }
}




list<edge> MAX_CARD_MATCHING(graph& G, int heur)
{ 


  // input: directed graph G, we make it undirected (symmetric) by inserting
  //        reversal edges


  list<edge> R;

  int    strue = 0;
  bool   done  = false;

  node_array<int>  label(G,UNREACHED);
  node_array<node> pred(G,nil);
  node_array<int>  path1(G,0);
  node_array<int>  path2(G,0);
  node_array<edge> bridge(G,nil);

  node_data<node> mate(G,nil);


  // make graph symmetric

  edge_array<edge> rev(G,nil);
  compute_correspondence(G,rev);

  edge e = G.first_edge();

  while (e && rev[e]) e = G.succ_edge(e);

  edge last_edge = nil;
  if (e !=nil)
  { last_edge = G.new_edge(target(e),source(e));
    R.append(last_edge);
    while (e != last_edge)
    { if (rev[e] == nil)
      { edge e1 = G.new_edge(target(e),source(e));
        rev[e] = e1;
        R.append(e1);
        }
      e = G.succ_edge(e);
     }
   }

  edge_array<edge> reversal(G,nil);

  for(e = G.first_edge(); e != last_edge; e = G.succ_edge(e))
  { edge r = rev[e];
    reversal[e] = r;
    reversal[r] = e;
   }


/*
  edge_array<edge> reversal(G,nil);

  edge e = G.first_edge();
  edge last_edge = G.last_edge();

  do { edge e1 = G.new_edge(target(e),source(e));
       reversal[e] = e1;
       reversal[e1] = e;
       R.append(e1);
       e = G.succ_edge(e);
      }
  while(e != last_edge);
*/



  switch (heur) {

  case 1: { greedy(G,mate);
            break;
          }

  case 2: { G.sort_nodes(cmp_degree);  // sort nodes by degree
            heuristic(G,mate);
            break;
           }
  }


  while (! done)  /* main loop */
  {
    node_list Q;
    node v;

    node_partition base(G);    // now base(v) = v for all nodes v

    done = true;
   
    forall_nodes(v,G)
    { pred[v] = nil;
  
      if (mate[v] == nil)
      { label[v] = EVEN; 
        Q.append(v); 
       }
      else label[v] = UNREACHED;
    }
  
    while (!Q.empty())    // search for augmenting path
    {
      node v = Q.pop();
      edge e;

      forall_adj_edges(e,v)
      {
        node w = G.target(e);

        if (v == w) continue;    // ignore self-loops

        if (base(v) == base(w) || (label[w] == ODD && base(w) == w)) 
        continue;   // do nothing

        if (label[w] == UNREACHED)
        { label[w] = ODD;
          pred[w] = v;
          label[mate[w]] = EVEN;
          Q.append(mate[w]);
         }
        else  // base(v) != base(w) && (label[w] == EVEN || base(w) !=w)
        { 
          node hv = base(v);
          node hw = base(w);
  
          strue++;
          path1[hv] = path2[hw] = strue;
  
          while ((path1[hw] != strue && path2[hv] != strue) &&
                 (mate[hv] != nil || mate[hw] != nil) )
          {
            if (mate[hv] != nil)
            { hv = base(pred[mate[hv]]);
              path1[hv] = strue;
             }
  
            if (mate[hw] != nil)
            { hw = base(pred[mate[hw]]);
              path2[hw] = strue;
             }
           }
  
          if (path1[hw] == strue || path2[hv] == strue)  // Shrink Blossom
          { node x;
            node y;
            node b = (path1[hw] == strue) ? hw : hv;    // Base

#if defined(REPORT_BLOSSOMS)
  cout << "SHRINK BLOSSOM\n";
  cout << "bridge = "; 
  G.print_edge(e);
  newline;
  cout << "base   = "; 
  G.print_node(b);
  newline;
  cout << "path1  = ";
#endif

            x = base(v);
            while (x != b)
            { 

#if defined(REPORT_BLOSSOMS)
  G.print_node(x); 
  cout << " ";
#endif
              base.union_blocks(x,b);
              base.make_rep(b);

              x = mate[x];

#if defined(REPORT_BLOSSOMS)
  G.print_node(x); 
  cout << " ";
#endif
              y = base(pred[x]);
              base.union_blocks(x,b);
              base.make_rep(b);

              Q.append(x);

              bridge[x] = e;
              x = y;
             }

#if defined(REPORT_BLOSSOMS)
  G.print_node(b);
  newline;
  cout << "path2  = ";
#endif

            x = base(w);
            while (x != b)
            { 

#if defined(REPORT_BLOSSOMS)
  G.print_node(x); 
  cout << " ";
#endif
              base.union_blocks(x,b);
              base.make_rep(b);

              x = mate[x];

#if defined(REPORT_BLOSSOMS)
  G.print_node(x); 
  cout << " ";
#endif
              y = base(pred[x]);

              base.union_blocks(x,b);
              base.make_rep(b);

              Q.append(x);

              bridge[x] = reversal[e];

              x = y;
             }

#if defined(REPORT_BLOSSOMS)
  G.print_node(b);
  newline;
  newline;
#endif
          }
          else  // augment path
          {
            list<node> P[2];

            find_path(P[0],label,pred,mate,bridge,v,hv);
            P[0].push(w);
            find_path(P[1],label,pred,mate,bridge,w,hw);
            P[1].pop();

            for(int i=0; i<2; i++)
              while(! P[i].empty())
               { node a = P[i].pop();
                 node b = P[i].pop();
                 mate[a] = b;
                 mate[b] = a;
                }

             Q.clear();                /* stop search (while Q not empty) */
             done = false;             /* continue main loop              */
             G.init_adj_iterator(v);
             break;                    /* forall_adj_edges(e,v) ...       */
           }

        } // base(v) != base(w) && (label[w] == EVEN || base(w) !=w)
  
      } // for all adjacent edges
  
    } // while Q not empty

  } // while not done


 forall(e,R) G.del_edge(e);  // restore graph (only original edges in result!)

 list<edge> result;

/*
  node v;
  forall_nodes(v,G)
    if (mate[v] != nil)
    { edge e;
      forall_adj_edges(e,v)
        if (mate[target(e)] == v) 
        { result.append(e);
          break;
         }
     }
*/

 forall_edges(e,G) 
 { node v = source(e);
   node w = target(e);
   if ( v != w  &&  mate[v] == w ) 
   { result.append(e);
     mate[v] = v;
     mate[w] = w;
    }
  }

 return result;

}

