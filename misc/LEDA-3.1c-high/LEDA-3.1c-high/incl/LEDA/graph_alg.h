/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  graph_alg.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_GRAPHALG_H
#define LEDA_GRAPHALG_H

#include <LEDA/graph.h>
#include <LEDA/ugraph.h>
#include <LEDA/node_matrix.h>


//-----------------------------------------------------------------------------
// basic graph algorithms:
//-----------------------------------------------------------------------------

bool        TOPSORT(const graph& G, node_array<int>& ord);

bool        TOPSORT1(graph& G);

list<node>  DFS(const graph& G, node s, node_array<bool>& reached) ;

list<node>  BFS(const graph& G, node s, node_array<int>& dist);

list<edge>  DFS_NUM(const graph& G, node_array<int>& dfsnum, 
                                    node_array<int>& compnum);

int         COMPONENTS(const ugraph& G, node_array<int>& compnum);

int         COMPONENTS1(const ugraph& G, node_array<int>& compnum);

int         STRONG_COMPONENTS(const graph& G, node_array<int>& compnum);

int         STRONG_COMPONENTS1(const graph& G, node_array<int>& compnum);

int         BICONNECTED_COMPONENTS(const ugraph& G, edge_array<int>& compnum);

graph       TRANSITIVE_CLOSURE(const graph& G);



//-----------------------------------------------------------------------------
// shortest paths:
//-----------------------------------------------------------------------------

void DIJKSTRA(const graph& G, node s, const edge_array<int>& cost, 
                                            node_array<int>& dist, 
                                            node_array<edge>& pred);

bool BELLMAN_FORD(const graph& G, node s, const edge_array<int>& cost,
                                                node_array<int>& dist,
                                                node_array<edge>& pred);

bool ALL_PAIRS_SHORTEST_PATHS(graph& G, const edge_array<int>&  cost,
                                              node_matrix<int>& dist);




//-----------------------------------------------------------------------------
// maximum flow:
//-----------------------------------------------------------------------------


int  MAX_FLOW(graph& G, node s, node t, const edge_array<int>& cap,
                                              edge_array<int>& flow);

//-----------------------------------------------------------------------------
// min cost flow:
//-----------------------------------------------------------------------------

int MIN_COST_MAX_FLOW(graph& G, node s, node t, const edge_array<int>& cap,
                                                const edge_array<int>& cost,
                                                edge_array<int>& flow);


//-----------------------------------------------------------------------------
// matchings:
//-----------------------------------------------------------------------------

// Edmond's algorithm

list<edge> MAX_CARD_MATCHING(graph& G, int heur = 1);    


// Hopcroft/Karp

list<edge> MAX_CARD_BIPARTITE_MATCHING(graph& G, const list<node>& A, const list<node>& B);

list<edge> MAX_CARD_BIPARTITE_MATCHING(graph& G);

list<edge> MAX_CARD_BIPARTITE_MATCHING1(graph& G, const list<node>& A, const list<node>& B);

list<edge> MAX_CARD_BIPARTITE_MATCHING1(graph& G);



list<edge> MAX_WEIGHT_BIPARTITE_MATCHING(graph& G, const list<node>&A, 
                                                   const list<node>&B,
                                                   const edge_array<int>&);




//-----------------------------------------------------------------------------
// spanning trees:
//-----------------------------------------------------------------------------

list<edge> SPANNING_TREE(const graph& G);

list<edge> MIN_SPANNING_TREE(const graph& G, const edge_array<int>& cost);

list<edge> MIN_SPANNING_TREE(const ugraph& G, const edge_array<int>& cost);



//-----------------------------------------------------------------------------
// planar graphs
//-----------------------------------------------------------------------------

bool PLANAR(graph&, bool embed=false);

bool PLANAR(graph&, list<edge>&, bool embed=false);

void make_biconnected_graph(graph&G);

list<edge> TRIANGULATE_PLANAR_MAP(graph&);

int STRAIGHT_LINE_EMBEDDING(graph& G,node_array<int>& xcoord,
                                     node_array<int>& ycoord);

int STRAIGHT_LINE_EMBEDDING2(graph& G,node& a, node& b, node& c,
                             node_array<int>& xcoord,node_array<int>& ycoord);


//-----------------------------------------------------------------------------
// "REAL" versions 
//-----------------------------------------------------------------------------


void DIJKSTRA(const graph& G, node s, const edge_array<double>& cost, 
                                            node_array<double>& dist, 
                                            node_array<edge>& pred);

bool BELLMAN_FORD(const graph& G, node s, const edge_array<double>& cost,
                                                node_array<double>& dist,
                                                node_array<edge>& pred);


bool ALL_PAIRS_SHORTEST_PATHS(graph& G, const edge_array<double>&  cost,
                                              node_matrix<double>& dist);


double MAX_FLOW(graph& G, node s, node t, const edge_array<double>& cap,
                                                edge_array<double>& flow);


list<edge> MAX_WEIGHT_BIPARTITE_MATCHING(graph& G, const list<node>&, 
                                                   const list<node>&,
                                                   const edge_array<double>&);



int STRAIGHT_LINE_EMBEDDING(graph& G,node_array<double>& xcoord,
                                     node_array<double>& ycoord);

int STRAIGHT_LINE_EMBEDDING2(graph& G,node_array<double>& xcoord,
                                      node_array<double>& ycoord);


list<edge> MIN_SPANNING_TREE(const graph& G, const edge_array<double>& cost);

list<edge> MIN_SPANNING_TREE(const ugraph& G, const edge_array<double>& cost);


#endif
