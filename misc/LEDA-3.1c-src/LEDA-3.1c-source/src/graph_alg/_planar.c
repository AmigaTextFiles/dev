/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _planar.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/



#include <LEDA/stack.h>
#include <LEDA/graph.h>
#include <LEDA/graph_alg.h>

static void dfs_in_make_biconnected_graph(graph & G, node v, int &dfs_count,
  node_array < bool > &reached,
  node_array < int >&dfsnum, node_array < int >&lowpt,
  node_array < node > &parent);

const int left = 1;
const int right = 2;

static void dfs_in_reorder(list < edge > &Del, node v, int &dfs_count,
  node_array < bool > &reached,
  node_array < int >&dfsnum,
  node_array < int >&lowpt1, node_array < int >&lowpt2,
  node_array < node > &parent);

class block
{
  private:
  list < int >Latt, Ratt;	/* list of attachments */
   list < edge > Lseg, Rseg;	/* list of segments represented by their *
				 * defining edges */

   public:

   block(edge e, list < int >&A) {
    Lseg.append(e);
    Latt.conc(A);
/* the other two lists are empty */
  } ~block() {
  }

  void flip() {
    list < int >ha;
     list < edge > he;
/* we first interchange |Latt| and |Ratt| and then |Lseg| and |Rseg| */
     ha.conc(Ratt);
     Ratt.conc(Latt);
     Latt.conc(ha);
     he.conc(Rseg);
     Rseg.conc(Lseg);
     Lseg.conc(he);
  } int head_of_Latt() {
    return Latt.head();
  }
  bool empty_Latt() {
    return Latt.empty();
  }
  int head_of_Ratt() {
    return Ratt.head();
  }
  bool empty_Ratt() {
    return Ratt.empty();
  }
  bool left_interlace(stack < block * >&S) {
/* check for interlacing with the left side of the topmost block of
 * |S| */
    if (Latt.empty())
      error_handler(1, "Latt is never empty");

    if (!S.empty() && !((S.top())->empty_Latt()) &&
      Latt.tail() < (S.top())->head_of_Latt())
      return true;
    else
      return false;
  }
  bool right_interlace(stack < block * >&S) {
/* check for interlacing with the right side of the topmost block of
 * |S| */
    if (Latt.empty())
      error_handler(1, "Latt is never empty");

    if (!S.empty() && !((S.top())->empty_Ratt()) &&
      Latt.tail() < (S.top())->head_of_Ratt())
      return true;
    else
      return false;
  }
  void combine(block * Bprime) {
/* add block Bprime to the rear of |this| block */
    Latt.conc(Bprime->Latt);
    Ratt.conc(Bprime->Ratt);
    Lseg.conc(Bprime->Lseg);
    Rseg.conc(Bprime->Rseg);
    delete(Bprime);
  } bool clean(int dfsnum_w, edge_array < int >&alpha) {
/* remove all attachments to |w|; there may be several */
    while (!Latt.empty() && Latt.head() == dfsnum_w)
      Latt.pop();
    while (!Ratt.empty() && Ratt.head() == dfsnum_w)
      Ratt.pop();

    if (!Latt.empty() || !Ratt.empty())
      return false;

/*|Latt| and |Ratt| are empty; we record the placement of the subsegments
 * in |alpha|. */

    edge e;
     forall(e, Lseg) alpha[e] = left;

     forall(e, Rseg) alpha[e] = right;

     return true;
  }
  void add_to_Att(list < int >&Att, int dfsnum_w0, edge_array < int >&alpha) {
/* add the block to the rear of |Att|. Flip if necessary */
    if (!Ratt.empty() && head_of_Ratt() > dfsnum_w0)
      flip();

    Att.conc(Latt);
    Att.conc(Ratt);
/* This needs some explanation. Note that |Ratt| is either empty
 * or $\{w0\}$. Also if |Ratt| is non-empty then all subsequent sets are contained
 * in $\{w0\}$. So we indeed compute an ordered set of attachments. */

    edge e;
     forall(e, Lseg) alpha[e] = left;

     forall(e, Rseg) alpha[e] = right;
  }
};

void make_biconnected_graph(graph & G)
{
  node v;
  node_array < bool > reached(G, false);
  node u = G.first_node();

  forall_nodes(v, G) {
    if (!reached[v]) {		/* explore the connected component with root
				 * * |v| */
      DFS(G, v, reached);
      if (u != v) {		/* link |v|'s component to the first *
				 * component */
	G.new_edge(u, v);
	G.new_edge(v, u);
      }				/* end if */
    }				/* end not reached */
  }				/* end forall */

/* |G| is now connected. We next make it biconnected. */

  forall_nodes(v, G) reached[v] = false;
  node_array < int >dfsnum(G);
  node_array < node > parent(G, nil);
  int dfs_count = 0;
  node_array < int >lowpt(G);

  dfs_in_make_biconnected_graph(G, G.first_node(), dfs_count, reached, dfsnum, lowpt, parent);

}				/* end |make_biconnected_graph| */

static void dfs_in_make_biconnected_graph(graph & G, node v, int &dfs_count,
  node_array < bool > &reached,
  node_array < int >&dfsnum, node_array < int >&lowpt,
  node_array < node > &parent)
{

  node w;
  edge e;

  dfsnum[v] = dfs_count++;
  lowpt[v] = dfsnum[v];
  reached[v] = true;

  if (!G.first_adj_edge(v))
    return;			/* no children */

  node u = target(G.first_adj_edge(v));		/* first child */

  forall_adj_edges(e, v) {
    w = target(e);
    if (!reached[w]) {		/* e is a tree edge */
      parent[w] = v;
      dfs_in_make_biconnected_graph(G, w, dfs_count, reached, dfsnum, lowpt, parent);
      if (lowpt[w] == dfsnum[v]) {	/* |v| is an articulation point. We * 
					 * now add an edge. If |w| is the *
					 * first child and |v| has a parent * 
					 * then we connect |w| and *
					 * |parent[v]|, if |w| is a first *
					 * child and |v| has no parent then * 
					 * we do nothing. If |w| is not the * 
					 * first child then we connect |w| to 
					 * 
					 * * the first child. The net effect
					 * of  * all of this is to link all * 
					 * children of an articulation point
					 * * to the first child and the first
					 * * child to the parent (if it
					 * exists)  */
	if (w == u && parent[v]) {
	  G.new_edge(w, parent[v]);
	  G.new_edge(parent[v], w);
	}
	if (w != u) {
	  G.new_edge(u, w);
	  G.new_edge(w, u);
	}
      }				/* end if lowpt = dfsnum */
      lowpt[v] = Min(lowpt[v], lowpt[w]);
    }				/* end tree edge */
    else
      lowpt[v] = Min(lowpt[v], dfsnum[w]);	/* non tree edge */
  }				/* end forall */
}				/* end dfs */

static void reorder(graph & G, node_array < int >&dfsnum,
  node_array < node > &parent)
{
  node v;
  node_array < bool > reached(G, false);
  int dfs_count = 0;
  list < edge > Del;
  node_array < int >lowpt1(G), lowpt2(G);

  dfs_in_reorder(Del, G.first_node(), dfs_count, reached, dfsnum, lowpt1, lowpt2, parent);

/* remove forward and reversals of tree edges */

  edge e;
  forall(e, Del) G.del_edge(e);

/* we now reorder adjacency lists as described in \cite[page 101]{Me:book} */

  node w;
  edge_array < int >cost(G);
  forall_edges(e, G) {
    v = source(e);
    w = target(e);
    cost[e] = ((dfsnum[w] < dfsnum[v]) ?
      2 * dfsnum[w] :
      ((lowpt2[w] >= dfsnum[v]) ?
	2 * lowpt1[w] : 2 * lowpt1[w] + 1));
  }

  G.sort_edges(cost);

}

static void dfs_in_reorder(list < edge > &Del, node v, int &dfs_count,
  node_array < bool > &reached,
  node_array < int >&dfsnum,
  node_array < int >&lowpt1, node_array < int >&lowpt2,
  node_array < node > &parent)
{
  node w;
  edge e;

  dfsnum[v] = dfs_count++;
  lowpt1[v] = lowpt2[v] = dfsnum[v];
  reached[v] = true;
  forall_adj_edges(e, v) {
    w = target(e);
    if (!reached[w]) {		/* e is a tree edge */
      parent[w] = v;
      dfs_in_reorder(Del, w, dfs_count, reached, dfsnum, lowpt1, lowpt2,
	parent);
      lowpt1[v] = Min(lowpt1[v], lowpt1[w]);
    }				/* end tree edge */
    else {
      lowpt1[v] = Min(lowpt1[v], dfsnum[w]);	/* no effect for forward *
						 * edges */
      if ((dfsnum[w] >= dfsnum[v]) || w == parent[v])
/* forward edge or reversal of tree edge */
	Del.append(e);
    }				/* end non-tree edge */

  }				/* end forall */

/* we know |lowpt1[v]| at this point and now make a second pass over all
 * adjacent edges of |v| to compute |lowpt2| */

  {
    forall_adj_edges(e, v) {
      w = target(e);
      if (parent[w] == v) {	/* tree edge */
	if (lowpt1[w] != lowpt1[v])
	  lowpt2[v] = Min(lowpt2[v], lowpt1[w]);
	lowpt2[v] = Min(lowpt2[v], lowpt2[w]);
      }				/* end tree edge */
      else
      /* all other edges */ if (lowpt1[v] != dfsnum[w])
	lowpt2[v] = Min(lowpt2[v], dfsnum[w]);
    }				/* end forall */
  }
}				/* end dfs */

static bool strongly_planar(edge e0, graph & G, list < int >&Att,
  edge_array < int >&alpha,
  node_array < int >&dfsnum,
  node_array < node > &parent)
{

  node x = source(e0);

  node y = target(e0);

  edge e = G.first_adj_edge(y);

  node wk = y;

  while (dfsnum[target(e)] > dfsnum[wk]) {	/* e is a tree edge */
    wk = target(e);
    e = G.first_adj_edge(wk);
  }

  node w0 = target(e);

  node w = wk;

  stack < block * >S;

  while (w != x) {
    int count = 0;
    forall_adj_edges(e, w) {
      count++;
      if (count != 1) {		/* no action for first edge */
	list < int >A;

	if (dfsnum[w] < dfsnum[target(e)]) {	/* tree edge */
	  if (!strongly_planar(e, G, A, alpha, dfsnum, parent)) {
	    while (!S.empty())
	      delete(S.pop());
	    return false;
	  }

	}
	else
	  A.append(dfsnum[target(e)]);	/* a back edge */

	block *B = new block(e, A);

	while (true) {
	  if (B->left_interlace(S))
	    (S.top())->flip();

	  if (B->left_interlace(S)) {
	    delete(B);
	    while (!S.empty())
	      delete(S.pop());
	    return false;
	  };

	  if (B->right_interlace(S))
	    B->combine(S.pop());
	  else
	    break;
	}			/* end while */

	S.push(B);

      }				/* end if */
    }				/* end forall */

    while (!S.empty() && (S.top())->clean(dfsnum[parent[w]], alpha))
      delete(S.pop());

    w = parent[w];
  }				/* end while */

  Att.clear();
  while (!S.empty()) {
    block *B = S.pop();

    if (!(B->empty_Latt()) && !(B->empty_Ratt()) &&
      (B->head_of_Latt() > dfsnum[w0]) && (B->head_of_Ratt() > dfsnum[w0])) {
      delete(B);
      while (!S.empty())
	delete(S.pop());
      return false;
    }

    B->add_to_Att(Att, dfsnum[w0], alpha);

    delete(B);
  }				/* end while */

/* Let's not forget (as the book does) that $w0$ is an attachment of $S(e0)$
 * except if $w0 = x$. */

  if (w0 != x)
    Att.append(dfsnum[w0]);

  return true;
}

static void embedding(edge e0, int t, GRAPH < node, edge > &G,
  edge_array < int >&alpha,
  node_array < int >&dfsnum,
  list < edge > &T, list < edge > &A, int &cur_nr,
  edge_array < int >&sort_num, node_array < edge > &tree_edge_into,
  node_array < node > &parent, edge_array < edge > &reversal)
{

  node x = source(e0);

  node y = target(e0);

  tree_edge_into[y] = e0;

  edge e = G.first_adj_edge(y);

  node wk = y;

  while (dfsnum[target(e)] > dfsnum[wk]) {	/* e is a tree edge */
    wk = target(e);
    tree_edge_into[wk] = e;
    e = G.first_adj_edge(wk);
  }

  node w0 = target(e);
  edge back_edge_into_w0 = e;

  node w = wk;

  list < edge > Al, Ar;
  list < edge > Tprime, Aprime;

  T.clear();
  T.append(G[e]);		/* |e = (wk,w0)| at this point, line (2) */

  while (w != x) {
    int count = 0;
    forall_adj_edges(e, w) {
      count++;
      if (count != 1) {		/* no action for first edge */

	if (dfsnum[w] < dfsnum[target(e)]) {	/* tree edge */
	  int tprime = ((t == alpha[e]) ? left : right);
	  embedding(e, tprime, G, alpha, dfsnum, Tprime, Aprime, cur_nr, sort_num, tree_edge_into, parent, reversal);

	}
	else {			/* back edge */
	  Tprime.append(G[e]);	/* $e$ */
	  Aprime.append(reversal[G[e]]);	/* reversal of $e$ */
	}

	if (t == alpha[e]) {
	  Tprime.conc(T);
	  T.conc(Tprime);	/* $T = Tprime\ conc\ T$ */

	  Al.conc(Aprime);	/* $Al = Al\ conc\ Aprime$ */

	}
	else {
	  T.conc(Tprime);	/* $ T\ = T\ conc\ Tprime $ */

	  Aprime.conc(Ar);
	  Ar.conc(Aprime);	/* $ Ar\ = Aprime\ conc\ Ar$ */

	}

      }				/* end if */
    }				/* end forall */

    T.append(reversal[G[tree_edge_into[w]]]);	/* $(w_{j-1},w_j)$ */

    forall(e, T) sort_num[e] = cur_nr++;

/* |w|'s adjacency list is now computed; we clear |T| and prepare for the
 * next iteration by moving all darts incident to |parent[w]| from |Al| and
 * |Ar| to |T|. These darts are at the rear end of |Al| and at the front end
 * of |Ar| */

    T.clear();

    while (!Al.empty() && source(Al.tail()) == G[parent[w]])
/* |parent[w]| is in |G|, |Al.tail| in |H| */
    {
      T.push(Al.Pop());		/* Pop removes from the rear */
    }

    T.append(G[tree_edge_into[w]]);	/* push would be equivalent */

    while (!Ar.empty() && source(Ar.head()) == G[parent[w]]) {	/* */
      T.append(Ar.pop());	/* pop removes from the front */
    }

    w = parent[w];
  }				/* end while */

  A.clear();

  A.conc(Ar);
  A.append(reversal[G[back_edge_into_w0]]);
  A.conc(Al);

}

bool PLANAR(graph & Gin, bool embed)
/* |Gin| is a directed graph. |planar| decides whether |Gin| is planar.
 * If it is and |embed == true| then it also computes a
 * combinatorial embedding of |Gin| by suitably reordering
 * its adjacency lists.
 * |Gin| must be bidirected in that case. */

{
  int n = Gin.number_of_nodes();

  if (n <= 3)
    return true;

  if (Gin.number_of_edges() > 6 * n - 12)
    return false;

/* An undirected planar graph has at most $3n-6$ edges; a directed graph may
 * have twice as many */

  GRAPH < node, edge > G;

  edge_array < edge > companion_in_G(Gin);

  node_array < node > link(Gin);

  bool Gin_is_bidirected = true;

  {
    node v;
    forall_nodes(v, Gin) link[v] = G.new_node(v);	/* bidirectional *
							 * links */
    edge e;
    forall_edges(e, Gin) companion_in_G[e] =
      G.new_edge(link[source(e)], link[target(e)], e);

  }

  {
    node_array < int >nr(G);
    edge_array < int >cost(G);
    int cur_nr = 0;
    int n = G.number_of_nodes();
    node v;
    edge e;

    forall_nodes(v, G) nr[v] = cur_nr++;

    forall_edges(e, G) cost[e] = ((nr[source(e)] < nr[target(e)]) ?
      n * nr[source(e)] + nr[target(e)] :
      n * nr[target(e)] + nr[source(e)]);

    G.sort_edges(cost);

    list < edge > L = G.all_edges();

    while (!L.empty()) {
      e = L.pop();
/* check whether the first edge on |L| is equal to the reversal of |e|. If so,
 * delete it from |L|, if not, add the reversal to |G| */
      if (!L.empty() && (source(e) == target(L.head())) && (source(L.head()) == target(e)))
	L.pop();
      else {
	G.new_edge(target(e), source(e));
	Gin_is_bidirected = false;
      }
    }

  }

  make_biconnected_graph(G);

  GRAPH < node, edge > H;
  edge_array < edge > companion_in_H(Gin);

  {
    node v;
    forall_nodes(v, G) G.assign(v, H.new_node(v));

    edge e;
    forall_edges(e, G) G.assign(e, H.new_edge(G[source(e)], G[target(e)], e));

    edge ein;
    forall_edges(ein, Gin) companion_in_H[ein] = G[companion_in_G[ein]];
  }

  edge_array < edge > reversal(H);

  compute_correspondence(H, reversal);

  node_array < int >dfsnum(G);
  node_array < node > parent(G, nil);

  reorder(G, dfsnum, parent);

  edge_array < int >alpha(G, 0);

  {
    list < int >Att;

    alpha[G.first_adj_edge(G.first_node())] = left;

    if (!strongly_planar(G.first_adj_edge(G.first_node()), G, Att, alpha, dfsnum, parent))
      return false;
  }

  if (embed) {
    if (Gin_is_bidirected) {
      list < edge > T, A;	/* lists of edges of |H| */

      int cur_nr = 0;
      edge_array < int >sort_num(H);
      node_array < edge > tree_edge_into(G);

      embedding(G.first_adj_edge(G.first_node()), left, G, alpha, dfsnum, T, A,
	cur_nr, sort_num, tree_edge_into, parent, reversal);

/* |T| contains all edges incident to the first node except the cycle edge into it.
 * That edge comprises |A| */

      T.conc(A);
      edge e;

      forall(e, T) sort_num[e] = cur_nr++;

      edge_array < int >sort_Gin(Gin);

      {
	edge ein;
	forall_edges(ein, Gin) sort_Gin[ein] = sort_num[companion_in_H[ein]];
      }

      Gin.sort_edges(sort_Gin);
    }

    else
      error_handler(2, "sorry: can only embed bidirected graphs");
  }
  return true;
}

bool PLANAR(graph & G, list < edge > &P, bool embed)
{
  if (PLANAR(G, embed))
    return true;

/* We work on a copy |H| of |G| since the procedure alters |G|; we link every
 * vertex and edge of |H| with its original. For the vertices we also have the
 * reverse links. */

  GRAPH < node, edge > H;
  node_array < node > link(G);
  node v;
  forall_nodes(v, G) link[v] = H.new_node(v);
/* This requires some explanation. |H.new_node(v)| adds a new node to
 * |H|, returns the new node, and makes |v| the information associated
 * with the new node. So the statement creates a copy of |v| and
 * bidirectionally links it with |v| */

  edge e;
  forall_edges(e, G) H.new_edge(link[source(e)], link[target(e)], e);
/* |link[source(e)]| and |link[target(e)]| are the copies of |source(e)|
 * and |target(e)| in |H|. The operation |H.new_edge| creates a new edge
 * with these endpoints, returns it, and makes |e| the information of that
 * edge. So the effect of the loop is to make the edge set of |H| a copy
 * of the edge set of |G| and to let every edge of |H| know its original.
 * We can now determine a minimal non-planar subgraph of |H| */
  list < edge > L = H.all_edges();

  edge eh;

  forall(eh, L) {
    e = H[eh];			/* the edge in |G| corresponding to |eh| */
    node x = source(eh);
    node y = target(eh);
    H.del_edge(eh);
    if (PLANAR(H))
      H.new_edge(x, y, e);	/* put a new version of |eh| back in and *
				 * establish the correspondence */

  }

/* |H| is now a homeomorph of either $K_5$ or $K_{3,3}$. We still need
 * to translate back to |G|. */

  P.clear();

  forall_edges(eh, H) P.append(H[eh]);

  return false;

}
