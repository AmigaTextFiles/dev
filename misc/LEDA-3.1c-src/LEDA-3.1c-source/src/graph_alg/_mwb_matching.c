/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _mwb_matching.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



/*******************************************************************************
*                                                                              *
*  MAX_WEIGHT_BIPARTITE_MATCHING  (maximum weight bipartite matching)          *
*									       *
*  modified 01/94, M.Paul						       *
*                                                                              *
*******************************************************************************/


#include <LEDA/graph_alg.h>
#include <LEDA/node_pq.h>

static list<edge> compute_MWBM( graph& G,
                         	const list<node>& A, const list<node>& B,
                         	const edge_array<num_type>& weight );



list<edge> MAX_WEIGHT_BIPARTITE_MATCHING( graph& G,
                		const list<node>& A, const list<node>& B,
                		const edge_array<num_type>& weight )
{
  if( A.size()==0 || B.size()==0 ) 
    return 0;

  /* change the graph such that A becomes the node set with
     smaller cardinality (if necessary)
   */
  if( B.size() < A.size() ) {
    G.rev();
    list<edge> mwm = compute_MWBM( G, B, A, weight );
    G.rev();
    return mwm;
  }
  else
    return compute_MWBM( G, A, B, weight );
}



/* return the list of possible endpoints of augmenting paths which
   only need a minimal change of the dual function u
 */
static list<node> dijkstra( const graph& G, 
			    const node_list& free,
                            const node_array<num_type>& u,
                            const edge_array<num_type>& weight,
                                  num_type maxval,
                                  node_array<num_type>& dist,
                                  node_array<edge>& pred,
                            const node_array<int>& side)
{ 
  node_pq<num_type> PQ(G);
  num_type a_min = maxval,	// minimal distance to an endpoint of 
  	   b_min = maxval,	// an augmenting path in A resp. B
           dv, dw, c, uv;
  list<node> alist, blist;	// the lists of minimal endpoints
  node v, w;
  edge e;

  forall(v,free) { 		// initialize distances and PQ
    dist[v] = 0;
    PQ.insert(v,0);
    if( u[v]<=a_min ) {		// compute initial nodelist for A
      if( u[v]<a_min ) {
        alist.clear(); 
        a_min = u[v]; 
      }
      alist.append(v);
    }
  }

  while( !PQ.empty() ) { 
    v = PQ.del_min();		// dist[v] is the final distance of v

    dv = dist[v];
    uv = u[v];

    /* if v is in A, update the nodelist for A
     */
    if( !side[v] && uv+dv<=a_min ) {	
      if( uv+dv<a_min ) {
        alist.clear(); 
        a_min = uv+dv;
      }
      alist.append(v);
    }

    /* stop if the actual distance becomes greater than the 
       distance to an endpoint of an augmenting path already seen
     */
    if( a_min<dv || b_min<dv ) 
      break;
      	
    /* if v is in B, update the nodelist for B
     */
    if( side[v] && !G.outdeg(v) ) {
      b_min = dv;
      blist.append(v);
    }

    /* perform one step of Dijkstra's algorithm
     */
    forall_adj_edges( e, v ) { 		
      w = G.target(e);	
      dw = dist[w];
      c = dv + uv + u[w] - weight[e];

      if (c < dv) c = dv;  /* rounding errors: u[v]+u[w]-weight[e]
                                               might become negative */
      if( c < dw ) { 
        if( dw == maxval )
           PQ.insert(w,c);
        else
           PQ.decrease_inf(w,c);
        dist[w] = c;
        pred[w] = e;
      }
    }
  }

  /* return the appropriate list of nodes
   */
  if( a_min==b_min )
    alist.conc( blist );
  
  return a_min<=b_min ? alist : blist;
}



/* augment matching in one pass along paths of length 1 and 3 
*/
static int mwbm_heuristic( graph& G, 
		           const list<node>& A,
		           const edge_array<num_type>& weight, 
		           node_array<num_type>& u)
{ 
  node v, w;
  edge e, e2, eb;
  int n = 0;
  num_type max, max2, we;
  node_array<edge> sec_edge(G,0);

  forall( v, A ) {			// for all nodes in A ...
    max2 = 0; max = 0; eb = 0;
    forall_adj_edges( e, v ) {		// compute edges with largest
      we = weight[e]-u[target(e)];	// and second largest slack
      if( we >= max2 ) {
        if( we >= max ) {
	  max2 = max;  e2 = eb;
          max = we;  eb = e;
        }
	else {
	  max2 = we;  e2 = e;
	}
      }
    }

    if( eb ) {
      w = target(eb);
      if( !G.outdeg(w) ) {		// match eb and change u[] such
        sec_edge[v] = e2;		// that e2 also gets slack 0
        u[v] = max2;
        u[w] = max-max2;
        G.rev_edge(eb);
        n++;
      }
      else {				// try to augment matching along
        u[v] = max;			// path of length 3 given by sec_edge[]
	e2 = G.first_adj_edge(w);
	e = sec_edge[target(e2)];
	if( e && !G.outdeg(target(e)) ) {
	  G.rev_edge(e); G.rev_edge(e2); G.rev_edge(eb);
	  n++;
	}
      }
    }
  }

  return n;
}



/* compute a maximum weight matching in G
 */
static list<edge> compute_MWBM( graph& G, 
				const list<node>& A,
				const list<node>& B,
				const edge_array<num_type>& weight )
{
  num_type MAX, MIN;
  Max_Value(MAX); Min_Value(MIN);
  
  num_type d_min;
  node v, v_min;
  edge e;
  node_array<edge>     pred(G,nil);
  node_array<num_type> dist(G,MAX), u(G,0);
  node_array<int>      side(G,1), used(G,0);
  int mark=0;			// nodes v with used[v]<mark are unused
  node_list free;
  list<node> vlist;
  mwbm_heuristic(G,A,weight,u);

  forall(v,A) {
     if( G.indeg(v)==0 && G.outdeg(v) ) {
       free.append(v);
       dist[v] = 0;
      }
      side[v]=0;
  }
  
  while( !free.empty() ) {
    mark++;			// mark all nodes as unused

    /* compute the list of possible endpoints
     */
    vlist = dijkstra(G,free,u,weight,MAX,dist,pred,side);

    forall( v_min, vlist ) {
      v=v_min; 

      /* if v_min is not the first node of the list, check if the
         augmenting path to v_min contains an used node
       */
      if( v_min!=vlist.head() ) {
        e=pred[v];
        while( e && used[v]<mark ) { 
          v = source(e);
          e = pred[v];
        }
      }

      /* if all nodes are unused, augment the matching along the path
       */
      if( used[v]<mark ) {
        v = v_min; e = pred[v];
        while( e ) { 
          used[v]=mark;
          v = source(e);
          G.rev_edge(e);
          e = pred[v];
        }
        free.del(v);
        used[v]=mark;
      }
    }

    /* change the dual function
     */
    v_min = vlist.head();
    d_min = side[v_min] ? dist[v_min] : u[v_min]+dist[v_min];
    
    forall(v,A) { 
      if (d_min > dist[v]) 
        u[v] -= d_min-dist[v];
      dist[v] = MAX;
    }
  
    forall(v,B) { 
      if (d_min > dist[v]) 
        u[v] += d_min-dist[v];
      dist[v] = MAX;
    }
  }

  /* compute the result
   */
  list<edge> result;
  forall(v,B) 
    forall_adj_edges(e,v) result.append(e);
  forall(e,result) G.rev_edge(e);
  
  return result;
}
