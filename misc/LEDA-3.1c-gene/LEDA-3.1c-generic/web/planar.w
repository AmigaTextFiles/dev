\documentstyle[comments,a4,psfig]{cweb}

\input{/KM/usr/schirra/styles/transfig}

\voffset=-0.5cm
\textwidth		14cm
\oddsidemargin          0.4cm
\evensidemargin         1.4cm
\marginparwidth		1.9cm
\marginparsep		0.4cm
\marginparpush		0.4cm
\topmargin		0cm
\headsep		1.5cm
\textheight		21.5cm
\footskip		2.2cm



\begin{document}

@i /KM/usr/mehlhorn/Programs/typnamen

\thispagestyle{empty}

\renewcommand{\thefootnote}{\fnsymbol{footnote}}

        \title{An Implementation of the\\
 Hopcroft and Tarjan\\
 Planarity Test and Embedding Algorithm}\thanks{This work was supported in part by the German Ministry for Research and Technology (Bundesministerium f\"ur Forschung und Technologie) under grant ITS 9103 and by the ESPRIT Basic Research Actions Program under contract No. 7141 (project ALCOM II).}

\author{Kurt Mehlhorn\\
        {\footnotesize  Max-Planck-Institut f\"ur Informatik,}\\[-0.7ex]
   	{\footnotesize 66123 Saarbr\"ucken, Germany}\\[0.7ex]
	\and Petra Mutzel\\
        {\footnotesize  Institut f\"ur Informatik,}\\[-0.7ex]
	{footnotesize Universit\"at zu K\"oln, 50969 K\"oln}\\[0.7ex]
	\and Stefan N\"aher\\
        {\footnotesize  Max-Planck-Institut f\"ur Informatik,}\\[-0.7ex]
   	{\footnotesize 66123 Saarbr\"ucken, Germany}\\[0.7ex]}

 
        \date{} 
        \maketitle


\setcounter{page}{0}
\thispagestyle{empty}

%%%%%%% Abstract %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\vspace*{2.2cm}

\begin{abstract}
We describe an implementation of the Hopcroft and Tarjan planarity test and
embedding algorithm. The program tests the planarity of the input
graph and either constructs a combinatorial embedding (if the graph
is planar) or exhibits a Kuratowski subgraph (if the graph is non-planar).

\end{abstract}

\tableofcontents

@* Introduction.

We descibe two procedures to test the planarity of a graph |G|:
 
\begin{center}
|bool planar (graph& G, bool embed = false)|
\end{center}

and

\begin{center}
|bool planar (graph& G, list <edge>& P, bool embed = false)|.
\end{center}

Both take a directed graph |G| and test it for planarity.
If the graph is planar and bidirected, i.e., for every edge of |G| its
reversal is also in |G|, and the argument |embed| is true, then they
also compute a combinatorial embedding of |G| (by suitably reordering
its adjacency lists). If the graph |G| is
non-planar then the first version of |planar| only records that fact.
The second version in addition returns a subgraph of |G| homeomorphic
to $K_{3,3}$ or $K_5$ (as a list |P| of edges). For a planar graph
|G| the running time of
both versions is linear (cf.\ section \ref{Efficiency} for more
detailed information). For non-planar graphs |G| the
first version runs in linear time but the second version runs in 
quadratic time.
We are aware of the linear time algorithm of Williamson
\cite{Williamson:Kuratowski} to find Kuratowski subgraphs but have
not implemented it. 

The implementation of |planar| is based on the LEDA platform of combinatorial
and geometric computing \cite{LEDA-Manual,Mehlhorn-Naeher:LEDA}. It is part of
the LEDA-distribution (available through anonymous ftp at cs.uni-sb.de). In
this document we describe the implementation of both versions of |planar| and a demo, and report on our experimental experience.

Procedure |planar| is based on the
Hopcroft and Tarjan linear time planarity testing algorithm as 
described in \cite[section IV.10]{Me:book}. For the sequel we assume
knowledge of section IV.10 of \cite{Me:book}. A revised version of that section
is included in this document (see section \ref{reprint}) for the convenience
of the reader. Our procedure |planar| differs from \cite[section IV.10]{Me:book}
in two respects: Firstly, it works for arbitrary directed graphs and 
not only for biconnected
undirected graphs. To this end we augment the input graph by additional edges
to make it biconnected and bidirected. The augmentation does not destroy 
planarity. Secondly, the embedding 
phase follows the
presentation in \cite{Mehlhorn-Mutzel:embedding}. We want to remark that the
description of the embedding phase given 
in \cite[section IV.10]{Me:book} is false.
The essential part of \cite{Mehlhorn-Mutzel:embedding} is reprinted in
section \ref{embedding}.


This document defines the files |planar.h|, |planar.c|, and |demo.c|.
|planar.c| contains the code for procedure |planar|, |demo.c|
contains the code for a demo, and |planar.h| consists of the 
declarations of procedure |planar|. 
The third file is defined in section \ref{demo}, the structure of the first two files
is as follows:

@(planar.h@>=
bool	planar (graph& G, bool embed = false);
bool	planar (graph& G, list <edge>& P, bool embed = false);
void 	Make_biconnected_graph(graph& G);

@

@(planar.c@>=
@<includes@>;
@<typedefs, global variables and class declarations@>;
@<auxiliary functions@>;
@<first version of |planar|@>;
@<second version of |planar|@>;


@ We include parts of LEDA (who would want to 
work without it) \cite{LEDA-Manual,Mehlhorn-Naeher:LEDA}.
We need stacks, graphs, and graph algorithms.

@<includes@>=
#include <LEDA/stack.h>
#include <LEDA/graph.h>
#include <LEDA/graph_alg.h>
#include "planar.h"

@ The second version of |planar| is easy to describe. We first test the
planarity of |G| using the first version.
If |G| is planar then we are done. If |G| is 
non-planar then we cycle through the edges of |G|. For every edge |e| of 
|G| we test the planarity of |G-e|. If |G-e| is planar we add |e| back in. 
In this way we determine a minimal (with respect to set inclusion)
non-planar subgraph of |G|, i.e., either a $K_5$ or a $K_{3,3}$.

@<second version...@>=
bool planar (graph& G, list <edge>& P, bool embed = false)
{ 
if (planar(G, embed)) return true;

/* We work on a copy |H| of |G| since the procedure alters |G|; we link every 
vertex and edge of |H| with its original. For the vertices we also have the
reverse links. */


GRAPH<node,edge> H; 
node_array<node> link(G);
node v;
forall_nodes(v,G) link[v] = H.new_node(v);
/* This requires some explanation. |H.new_node(v)| adds a new node to
|H|, returns the new node, and makes |v| the information associated
with the new node. So the statement creates a copy of |v| and
bidirectionally links it with |v| */

edge e;
forall_edges(e,G) H.new_edge(link[source(e)],link[target(e)],e);
/* |link[source(e)]| and |link[target(e)]| are the copies of |source(e)|
and |target(e)| in |H|. The operation |H.new_edge| creates a new edge
with these endpoints, returns it, and makes |e| the information of that
edge. So the effect of the loop is to make the edge set of |H| a copy
of the edge set of |G| and to let every edge of |H| know its original.
We can now determine a minimal non-planar subgraph of |H| */
list<edge> L = H.all_edges();

edge eh;

forall(eh,L)
   {e = H[eh]; // the edge in |G| corresponding to |eh|
    node x = source(eh); node y = target(eh);
    H.del_edge(eh);
    if (planar(H)) 
       H.new_edge(x,y,e);  //put a new version of |eh| back in and establish the correspondence
      
    }

/* |H| is now a homeomorph of either $K_5$ or $K_{3,3}$. We still need 
to translate back to |G|. */

P.clear();

forall_edges(eh,H) P.append(H[eh]);

return false;


}

@ The first version of |planar| is also quite simple to describe.
Graphs with at most three
vertices are always planar. So assume that |G| has more than three
vertices. We first add edges to |G| to make it bidirected
and then add some more edges to make
it biconnected (of course, without destroying planarity). Then we test
the planarity of the extended graph and construct an embedding. 
Since |planar| alters the input graph, it works on a copy of it.



@<first version ...@>=
bool planar(graph& Gin, bool embed = false)
/* |Gin| is a directed graph. |planar| decides whether |Gin| is planar.
If it is and |embed == true| then it also computes a 
 combinatorial embedding of |Gin| by suitably reordering 
its adjacency lists.
|Gin| must be bidirected in that case. */

{int n = Gin.number_of_nodes();

if (n <= 3) return true;

if (Gin.number_of_edges() > 6*n - 12) return false;

/* An undirected planar graph has at most $3n-6$ edges; a directed graph may
have twice as many */

cout << "number of nodes and edges  " << n << "  " << Gin.number_of_edges();
newline;


float T = used_time();

@<make |G| a copy of |Gin| and add edges to make |G| bidirected@>;
@<make |G| biconnected@>;

cout << "time to copy and to make bidirected and connected  " << used_time(T);
newline;


@<test planarity@>;

cout << "time to test planarity   " << used_time(T);
newline;

if (embed) {
  if (Gin_is_bidirected) @<construct embedding@>
  else error_handler(2,"sorry: can only embed bidirected graphs");
  cout << "time to construct embedding   " << used_time(T);
  newline;
}
return true;
}


@ We make |G| a copy of |Gin| and bidirectionally link all vertices and
edges. Then we add edges to |G| to make it bidirected. In
|Gin_is_bidirected| we record whether we needed to add edges.

@<make |G| a copy ...@>=

GRAPH<node,edge> G;

edge_array<edge> companion_in_G(Gin);
 
node_array<node> link(Gin);

bool Gin_is_bidirected = true;

{node v;
forall_nodes(v,Gin) link[v] = G.new_node(v); //bidirectional links
edge e;
forall_edges(e,Gin) companion_in_G[e] =   
                      G.new_edge(link[source(e)],link[target(e)],e);

}


@<bidirect G@>;


@ We bidirect G. We first assign numbers to nodes and edges. We make sure that
the two versions of the same undirected edge get the same number but versions
of distinct undirected edges get different numbers. Then we sort the edges 
according to numbers. Finally we step through the sorted list of edges 
and add
missing edges.


@<bidirect G@>= 



{node_array<int> nr(G);
edge_array<int> cost(G);
int cur_nr = 0;
int n = G.number_of_nodes();
node v;
edge e;

forall_nodes(v,G) nr[v] = cur_nr++;

forall_edges(e,G) cost[e] = ((nr[source(e)] < nr[target(e)]) ?
                              n*nr[source(e)] + nr[target(e)] :
                              n*nr[target(e)] + nr[source(e)]);

G.sort_edges(cost);



list<edge> L = G.all_edges();

while (! L.empty())
{e = L.pop();
/* check whether the first edge on |L| is equal to the reversal of |e|. If so,
delete it from |L|, if not, add the reversal to |G| */
if (!L.empty() && (source(e) == target(L.head())) && (source(L.head()) == target(e)))
L.pop();
else {
   G.new_edge(target(e),source(e));
   Gin_is_bidirected = false;
}
}

}


@* Making the Graph Biconnected.

We make |G| biconnected. We first make it connected by linking all
roots. Assume that is done. Let $a$ be any articulation 
point and let $u$ and $v$ be neighbors of $a$ belonging to different
biconnected components. Then there are embeddings of the two components
with the edges $\{u,a\}$ and $\{v,a\}$ on the boundary of the unbounded
face. Hence we may add the edge $\{u,v\}$ without destroying planarity.
Proceeding in this way we make |G| 
biconnected.

In |Make_biconnected_graph| we change the graph while working on it. But we modify only
those adjacency lists that will not be touched later.

We need the biconnected version of |G| (|G| will be further modified
during the planarity test) in order to construct the planar embedding. So we
store it as a graph |H|. For every edge of |Gin| and |G| we store a link to
its copy in |H|. In addition every edge of |H| is made to know its reversal.

@<make |G| biconnected@>=

Make_biconnected_graph(G);

@<make |H| a copy of |G|@>;

@ We give the details of the procedure |Make_biconnected_graph|. We first make |G|
connected by linking all roots of the DFS-forest. In a second step we make
|G| biconnected. 

@<auxiliary ...@>=
void Make_biconnected_graph(graph& G)
{
node v;
node_array<bool> reached(G,false);
node u = G.first_node();


forall_nodes(v,G)
  {
    if( !reached[v] )
      {/* explore the connected component with root |v| */ 
       DFS(G,v,reached);
       if ( u != v) 
         {/* link |v|'s component to the first component */
          G.new_edge(u,v); G.new_edge(v,u);  
         } //end if       
      } // end not reached
  } //end forall

/* |G| is now connected. We next make it biconnected. */

forall_nodes(v,G) reached[v] = false;
node_array<int> dfsnum(G);
node_array<node> parent(G,nil);
int dfs_count = 0;
node_array<int> lowpt(G);

dfs_in_make_biconnected_graph(G,G.first_node(),dfs_count,reached,dfsnum,lowpt,parent);

} // end |Make_biconnected_graph|


@ We still have to give the procedure |dfs_in_make_biconnected_graph|. It determines
articulation points and adds appropriate edges whenever it discovers one.
For a proof of correctness we refer the reader to
\cite[section IV.6]{Me:book}.

@<auxiliary ...@>+= 


void dfs_in_make_biconnected_graph(graph& G, node v, int & dfs_count, 
	 node_array<bool>& reached, @|
	 node_array<int> & dfsnum, node_array<int>& lowpt, 
         node_array<node>& parent)
{

node w;
edge e;


  dfsnum[v] = dfs_count ++;
  lowpt[v] = dfsnum[v];
  reached[v] = true;

  if ( !G.first_adj_edge(v) ) return; //no children

  node u = target(G.first_adj_edge(v)); //first child

  forall_adj_edges(e,v)
    {
     w = target(e);
     if( !reached[w] )
        {/* e is a tree edge */
         parent[w] = v;
         dfs_in_make_biconnected_graph(G,w,dfs_count,reached,dfsnum,lowpt,parent);
         if (lowpt[w] == dfsnum[v])
         { /* |v| is an articulation point. We now add an edge. If |w|
is the first child and |v| has a parent then we connect |w| and |parent[v]|,
if |w| is a first child and |v| has no parent then we do nothing. If |w|
is not the first child then we connect |w| to the first child. The net 
effect of all of this is to link all children of an articulation 
point to the first child and the first child to the parent
(if it exists) */
         if (w == u && parent[v]) 
              {G.new_edge(w,parent[v]);
               G.new_edge(parent[v],w);
              } 
         if ( w !=u ) {G.new_edge(u,w); G.new_edge(w,u);}
         } // end if lowpt = dfsnum
         lowpt[v] = Min(lowpt[v],lowpt[w]);
        } //end tree edge
     else lowpt[v] = Min(lowpt[v],dfsnum[w]); //non tree edge
    } // end forall
} //end dfs

@ Because we use the function |dfs_in_make_biconnected_graph| before its declaration,
let's add it to the global declarations.

@<typedefs, ...@>=
void dfs_in_make_biconnected_graph(graph& G, node v, int & dfs_count, 
	 node_array<bool>& reached, @|
	 node_array<int> & dfsnum, node_array<int>& lowpt, 
         node_array<node>& parent);

@ We make |H| a copy of |G| and create bidirectional links between the
vertices and edges of |G| and |H|. 
Also, each edge in |Gin| gets a link to its copy in |H| and every edge
of |H| gets to know its reversal. More precisely, |H[G[v]]=v| for every
node |v| of |G| and |H[G[e]]=e| for every edge |e| of |G|, and
|companion_in_H[ein]| is the edge in |H| corresponding to the edge
|ein| of |Gin| for every edge |ein| of |Gin|. Finally, if |e=(u,v)| is
an edge of |H| then |reversal[e]=(v,u)|.



@<make |H| ...@>=

GRAPH<node,edge> H;
edge_array<edge> companion_in_H(Gin);

{node v;
forall_nodes(v,G) G.assign(v,H.new_node(v));

edge e;
forall_edges(e,G) G.assign(e,H.new_edge(G[source(e)],G[target(e)],e));

edge ein;
forall_edges(ein,Gin) companion_in_H[ein] = G[companion_in_G[ein]];
}

edge_array<edge> reversal(H);

compute_correspondence(H,reversal);




@* The Planarity Test.

We are now ready for the planarity test proper. We follow 
\cite[page 95]{Me:book}. We first compute |dfsnumber|s and |parent|s, we
delete all forward edges and all reversals of tree edges, and we
reorder the adjaceny lists as described in \cite[page 101]{Me:book}.
We then test the strong planarity.
The array |alpha| is needed for the embedding process. It
records the placement of the subsegments. 



@<test planarity@>=

node_array<int> dfsnum(G);
node_array<node> parent(G,nil);

reorder(G,dfsnum,parent);


edge_array<int> alpha(G,0);

{list<int> Att;

alpha[G.first_adj_edge(G.first_node())] = left; 


if (!strongly_planar(G.first_adj_edge(G.first_node()),G,Att,alpha,dfsnum,parent))
return false;
}

@ We need two global constants |left| and |right|.

@<typedefs...@>+=
const int left = 1;
const int right = 2;


@ We give the details of the procedure |reorder|. It first performs DFS
to compute |dfsnum|, |parent|, |lowpt1| and |lowpt2|, and the list |Del|
of all forward edges and all reversals of tree edges.
It then deletes the edges in |Del| and finally it
reorders the edges.

@<auxiliary ...@>+=

void reorder(graph& G,node_array<int>& dfsnum, 
	 node_array<node>& parent)
{
node v;
node_array<bool> reached(G,false);
int dfs_count = 0;
list<edge> Del;
node_array<int> lowpt1(G), lowpt2(G);

       
dfs_in_reorder(Del,G.first_node(),dfs_count,reached,dfsnum,lowpt1,lowpt2,parent);
      


/* remove forward and reversals of tree edges */

edge e;
forall(e,Del)   G.del_edge(e);

/* we now reorder adjacency lists as described in \cite[page 101]{Me:book} */

node w;
edge_array<int> cost(G);
forall_edges(e,G)
{v = source(e); w = target(e);
cost[e] = ((dfsnum[w] < dfsnum[v]) ?
           2*dfsnum[w]  : 
          ( (lowpt2[w] >= dfsnum[v]) ?
             2*lowpt1[w] : 2*lowpt1[w] + 1));
}

G.sort_edges(cost);

}

@ We still have to give the procedure |dfs_in_reorder|. It's a bit long but standard.

@<auxiliary ...@>+= 


void dfs_in_reorder(list<edge>& Del, node v, int& dfs_count,
	 node_array<bool>& reached, @| 
	 node_array<int>& dfsnum,
	 node_array<int>& lowpt1, node_array<int>& lowpt2, @|
	 node_array<node>& parent)
{
node w;
edge e;


  dfsnum[v] =  dfs_count++;
  lowpt1[v] = lowpt2[v] = dfsnum[v];
  reached[v] = true;
  forall_adj_edges(e,v)
    {
     w = target(e);
     if( !reached[w] )
      {/* e is a tree edge */
       parent[w] = v;
       dfs_in_reorder(Del,w,dfs_count,reached,dfsnum,lowpt1,lowpt2,
           parent);
       lowpt1[v] = Min(lowpt1[v],lowpt1[w]);
      } //end tree edge
     else {lowpt1[v] = Min(lowpt1[v],dfsnum[w]); // no effect for forward edges
          if(( dfsnum[w] >= dfsnum[v])  || w == parent[v] ) 
               /* forward edge or reversal of tree edge */
               Del.append(e) ; 
          } //end non-tree edge
          
               
     } // end forall

  /* we know |lowpt1[v]| at this point and now make a second pass over all
     adjacent edges of |v| to compute |lowpt2| */
  
  forall_adj_edges(e,v)
    {w = target(e);
     if (parent[w] ==v)
     { /* tree edge */
       if (lowpt1[w] != lowpt1[v]) lowpt2[v] = Min(lowpt2[v],lowpt1[w]);
       lowpt2[v] = Min(lowpt2[v],lowpt2[w]);
     } //end tree edge
     else // all other edges 
          if (lowpt1[v] != dfsnum[w]) lowpt2[v] = Min(lowpt2[v],dfsnum[w]);
     } //end forall
} //end dfs

@ Because we use the function |dfs_in_reorder| before its declaration,
let's add it to the global declarations.

@<typedefs, ...@>+=
void dfs_in_reorder(list<edge>& Del, node v, int& dfs_count,
	 node_array<bool>& reached, @| 
	 node_array<int>& dfsnum,
	 node_array<int>& lowpt1, node_array<int>& lowpt2, @|
	 node_array<node>& parent);


@ We now come to the heart of the planarity test: procedure |strongly_planar|.
It takes a tree edge $e0 = (x,y)$ and tests whether  
the segment $S(e0)$ is strongly planar. If  successful it returns  (in |Att|) the
ordered list of attachments of $S(e0)$ (excluding $x$); high DFS-numbers are
at the front of the list. In |alpha| it
records the placement of the subsegments.

|strongly_planar| operates in three phases. It first constructs the cycle $C(e0)$
underlying the segment $S(e0)$. It then constructs the interlacing graph for the
segments emanating from the spine of the cycle. If this graph is non-bipartite
then the segment $S(e0)$ is non-planar. If it is bipartite then the segment is
planar. In this case the third phase checks whether the segment is strongly 
planar and, if so, computes its list of attachments.


@<auxiliary ...@>+=
bool strongly_planar(edge e0, graph& G, list<int>& Att, 
	 edge_array<int>& alpha, @|
	 node_array<int>& dfsnum,
	 node_array<node>& parent)
{
@<determine the cycle $C(e0)$@>;
@<process all edges leaving the spine@>;
@<test strong planarity and compute |Att|@>;
return true;
}



@ We determine the cycle $C(e0)$ by following first edges until a back 
edge is encountered. |wk| will be the last node on the tree path and |w0|
is the destination of the back edge. This agrees with the
notation of \cite{Me:book}. 


@<determine the cycle ...@>=

node x = source(e0);

node y = target(e0);

edge e = G.first_adj_edge(y);

node wk = y;

while (dfsnum[target(e)] > dfsnum[wk])  // e is a tree edge
{ wk = target(e);
  e= G. first_adj_edge(wk);
}

node w0 = target(e);


@ The second phase of |strongly_planar| constructs the connected components of
the interlacing graph of the segments emananating from the the spine of the 
cycle $C(e0)$. We call a connected component a {\em block}. For each block
we store the segments comprising its left and right side (lists
|Lseg| and |Rseg| contain the edges
defining these segments) and the ordered list of attachments of the segments
in the block; lists |Latt| and |Ratt| contain the DFS-numbers of the
attachments; high DFS-numbers are at the front of the list. Blocks are
so important that we make them a class.

We need the following operations on blocks.

The constructor takes an edge and a list of attachments and creates 
a block having the edge as the only segment in its left side.

|flip| interchanges the two sides of a block.

|head_of_Latt| and |head_of_Ratt| return the first elements on |Latt| and |Ratt| respectively 
and |Latt_empty| and |Ratt_empty| check these lists for emptyness.

|left_interlace| checks whether the block interlaces with the left side of the topmost block of
stack |S|. |right_interlace| does the same for the right side.

|combine| combines the block with another block |Bprime| by simply concatenating all
lists.

|clean| removes the attachment |w| from the block |B| (it is guaranteed to be the 
first attachment of |B|). If the block becomes empty then it records the 
placement of all segments in the block in the array |alpha| and returns true.
Otherwise it returns false.

|add_to_Att| first makes sure that the right side has no attachment above |w0| 
(by 
flipping); when |add_to_Att| is called at least one side has no
attachment above |w0|.
 |add_to_Att| then adds the lists |Ratt| and |Latt| to the output list |Att|
and records the placement of all segments in the block in |alpha|.
We advise the reader to only skim the rest of the section at this
point and to come back to it when the procedures are first used.


@<typedefs...@>+=
class block
{ 
private:
list<int> Latt, Ratt; //list of attachments
list<edge> Lseg,Rseg; //list of segments represented by their defining edges

public:

block(edge e, list<int>& A)
{
Lseg.append(e);
Latt.conc(A);
// the other two lists are empty
}

~block() @+ {}

void flip()
{
list<int> ha;
list<edge> he;
/* we first interchange |Latt| and |Ratt| and then |Lseg| and |Rseg| */
ha.conc(Ratt); @+ Ratt.conc(Latt); @+ Latt.conc(ha);
he.conc(Rseg); @+ Rseg.conc(Lseg); @+ Lseg.conc(he);
}

int head_of_Latt() @+ { @+ return Latt.head(); @+ }

bool empty_Latt() @+ { @+ return Latt.empty(); @+ }

int head_of_Ratt() @+ { @+ return Ratt.head(); @+ }

bool empty_Ratt() @+ { @+ return Ratt.empty(); @+ }

bool left_interlace(stack<block*>& S)
{
/* check for interlacing with the left side of the topmost block of
|S| */
if (Latt.empty()) error_handler(1,"Latt is never empty");

if (!S.empty() && !((S.top())->empty_Latt()) && 
Latt.tail() < (S.top())->head_of_Latt())
return true;
else return false;
}

bool right_interlace(stack<block*>& S)
{
/* check for interlacing with the right side of the topmost block of
|S| */
if (Latt.empty()) error_handler(1,"Latt is never empty");

if (!S.empty() && !((S.top())->empty_Ratt()) && 
Latt.tail() < (S.top())->head_of_Ratt())
return true;
else return false;
}

void combine(block* & Bprime)
{
/* add block Bprime to the rear of |this| block */
Latt.conc(Bprime -> Latt);
Ratt.conc(Bprime -> Ratt);
Lseg.conc(Bprime -> Lseg);
Rseg.conc(Bprime -> Rseg);
delete(Bprime);
}


bool clean(int dfsnum_w, edge_array<int>& alpha,
	 node_array<int>& dfsnum)
{
/* remove all attachments to |w|; there may be several */
while (!Latt.empty() && Latt.head() == dfsnum_w) Latt.pop();
while (!Ratt.empty() && Ratt.head() == dfsnum_w) Ratt.pop();

if (!Latt.empty() || !Ratt.empty()) return false;

/*|Latt| and |Ratt| are empty; we record the placement of the subsegments
in |alpha|. */

edge e;
forall(e,Lseg) alpha[e] = left; 

forall(e,Rseg) alpha[e] = right; 

return true;}

void add_to_Att(list<int>& Att, int dfsnum_w0,
	 edge_array<int>& alpha, @| 
	 node_array<int>& dfsnum)
{ 
/* add the block to the rear of |Att|. Flip if necessary */
if (!Ratt.empty() && head_of_Ratt() > dfsnum_w0) flip();

Att.conc(Latt);
Att.conc(Ratt); 
/* This needs some explanation. Note that |Ratt| is either empty
or $\{w0\}$. Also if |Ratt| is non-empty then all subsequent sets are contained
in $\{w0\}$. So we indeed compute an ordered set of attachments. */

edge e;
forall(e,Lseg) alpha[e] = left;

forall(e,Rseg) alpha[e] = right;
}

};



@ We process the edges leaving the spine of $S(e0)$ starting at node |wk|
and working backwards. The interlacing graph of the segments emanating from
the cycle is represented as a stack |S| of blocks. 

@<process all edges leaving the spine@>=

node w = wk;

stack<block*> S;


while (w != x)
{ int count = 0;
  forall_adj_edges(e,w)
  {count++;
   if (count != 1) //no action for first edge
	{@<test recursively@>;
	@<update stack |S| of attachments@>;
	} // end if
   } //end forall
@<prepare for next iteration@>;
w = parent[w];
} //end while

@ Let $e$ be any edge leaving the spine. We need to test whether
$S(e)$ is strongly planar and if so compute its list |A| of attachments.
If $e$ is a tree edge we call our procedure recursively and if $e$ is a 
back edge then $S(e)$ is certainly strongly planar and |target(e)| is
the only attachment. If we detect non-planarity we return flase and free
the storage allocated for the blocks of stack |S|.


@<test recursively@>=
list<int> A;

if (dfsnum[w] < dfsnum[target(e)])
	{ /* tree edge */
	if (!strongly_planar(e,G,A,alpha,dfsnum,parent)) 
		{while (!S.empty()) delete(S.pop());
		return false;
		}
	
	}
else A.append(dfsnum[target(e)]);  // a back edge
	






@ The list |A| contains the ordered list of attachments of segment
$S(e)$. We create an new block consisting only of segment $S(e)$ (in its 
$L$-part) and then combine this block with the topmost block of stack |S| as
long as 
there is interlacing. We check for interlacing with the $L$-part. If there
is interlacing then we flip the two sides of the topmost block. If there
is still interlacing with the left side then the interlacing graph is non-bipartite and 
we declare the graph non-planar (and also free the storage allocated
for the blocks). Otherwise we check for interlacing with
the R-part. If there is interlacing then we combine |B| with the topmost
block and repeat the process with the new topmost block. If there is no
interlacing then we push block |B| onto |S|.



@<update stack ...@>=

block* B = new block(e,A);

while (true)
{
if (B->left_interlace(S)) (S.top())->flip();

if (B->left_interlace(S)) 
	{delete(B);
	while (!S.empty()) delete(S.pop()); 
	return false;
	};


if (B->right_interlace(S)) B->combine(S.pop());
else break;
} //end while

S.push(B);

@ We have now processed all edges emanating from vertex |w|. Before starting to 
process edges emanating from vertex |parent[w]| we remove |parent[w]| from 
the list of attachments of the topmost block of stack |S|. If this block
becomes empty then we pop it from the stack and record the placement for all
segments in the block in array |alpha|.

@<prepare for ...@>=

while (!S.empty() && (S.top())->clean(dfsnum[parent[w]],alpha,dfsnum)) delete(S.pop());


@ We test the strong planarity of the segment $S(e0)$. 

We know at this point that the 
interlacing graph is bipartite. Also for each of its connected components the
corresponding block on stack |S| contains the list of attachments below |x|. 
Let |B| be the topmost block of |S|. If both sides of |B| have an attachment 
above |w0| then $S(e0)$ is not strongly planar. We free the storage allocated for
the blocks and return false. Otherwise (cf. procedure
|add_to_Att|) we first make sure that the right side of |B| attaches only to |w0| 
(if at all) and then add the two sides of |B| to the output list |Att|. We also
record the placements of the subsegments in |alpha|.

@<test strong planarity and ...@>=

Att.clear();
while(! S.empty())
{
block* B = S.pop();

if (!(B->empty_Latt()) && !(B->empty_Ratt()) &&
(B->head_of_Latt()>dfsnum[w0]) && (B->head_of_Ratt() > dfsnum[w0]))
{delete(B);while (!S.empty()) delete(S.pop()); return false;}


B->add_to_Att(Att,dfsnum[w0],alpha,dfsnum);

delete(B);
} //end while

/* Let's not forget (as the book does) that $w0$ is an attachment of $S(e0)$
except if $w0 = x$. */

if (w0 != x) Att.append(dfsnum[w0]);

@* Constructing the Embedding.    \label{embedding}



%%%%%%%%%%%%%%%%%% einbinden von bildern mit Unterschrift %%%%%%%%%%%%%

\newcommand{\bild}[2]{
\begin{figure}[htb]
\begin{center}
\input{#1.tex}
\end{center}
\caption{{#2}\label{#1}}   
\end{figure}
} 

%%%%%  wird so benutzt: \bild{<label>}{<caption>}  %%%%%%%%%%%%%%%%%%%%
%%%%%  z.B. \bild{part}{A part of the augmented segment tree structure}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



\newtheorem{theorem}{Theorem}

We now discuss how the planarity testing algorithm can be extended
so that it also computes a planar map.
Consider a segment $S(e_0)=C+S(e_1)+\ldots +S(e_m)$ consisting of
cycle $C$ and emanating segments $S(e_1),\ldots ,S(e_m)$ and
recall that the proofs of Lemmas 8 and 9 describe how
the embeddings of the $S(e_i)$'s have to be combined to yield a
canonical embedding of $S(e_0)$.
Our goal is to turn these proofs into an efficient algorithm.

The proofs of Lemmas 8 and 9 demonstrate two things:
\begin{itemize}
\item How to test whether $IG(C)$ is bipartite and how to construct
  a partition $\{L,R\}$ of its vertex set, and
\item how to construct an embedding of $S(e_0)$ from the embeddings of
  the $S(e_i)$'s. This involves flipping of embeddings as we
  incrementally construct the embedding of $S(e_0)$.
\end{itemize}

Suppose now that some benign agent told us that $IG(C)$ were bipartite
and gave us an appropriate partition $\{L,R\}$ of its vertex set,
i.e., a partition $\{L,R\}$ such that no
two segments in $L$ and no two segments in $R$ interlace and such that
$A(e_i)\cap \{w_1,\ldots ,w_{r-1}\}=\emptyset$ for any segment
$S(e_i)\in R$.
Here, as before, $w_0,\ldots ,w_r$ denotes the stem of $C$.
Then no flipping would ever be necessary;
we can simply combine the embeddings of the $S(e_i)$'s as prescribed
by the partition $\{L,R\}$.
More precisely, to construct a canonical embedding of $S(e_0)$ draw
the path $w_0,\ldots ,w_k$ (consisting of stem $w_0,\ldots ,w_r$,
edge $e_0 = (w_r,w_{r+1})$ and spine $w_{r+1},\ldots ,w_k$) as a
vertical upwards directed path, add edge $(w_k,w_0)$, and then for $i$,
$1\leq i\leq m$, and $S(e_i)\in L$ extend the embedding of
$C+S(e_1)+\ldots S(e_{i-1})$ by glueing a canonical embedding of
$S(e_i)$ onto the left side of the vertical path, and for $i$,
$1\leq i\leq m$, and $S(e_i)\in R$ extend the embedding of
$C+S(e_1)+\ldots +S(e_{i-1})$ by glueing a reversed canonical 
embedding of $S(e_i)$ onto the right side of the vertical path.
Similarly, if the goal is to construct a reversed canonical embedding
of $S(e_0)$ then, if $S(e_i)\in L$, a reversed canonical embedding of
$S(e_i)$ is glued onto the right side of the vertical path, and if
$S(e_i) \in R$, then a canonical embedding of $S(e_i)$ is glued onto the
left side of the vertical path.

Who is the benign agent which tells us that $IG(C)$ is bipartite and
gives us the appropriate partition $\{L,R\}$ of the segments emanating
from $C=C(e_0)$?
It's the call {\em stronglyplanar}($e_0$).
After all, it tests whether $IG(C)$ is bipartite and computes a
bipartition of its vertex set.
Let $S(e)$ be a segment emanating from $C$ and let $B$ be the connected
component of $IG(C)$ containing $S(e)$.
The call {\em stronglyplanar}($e_0$) computes $B$ iteratively.
The construction of $B$ is certainly completed when $B$ is popped from
stack $S$.
Put $S(e)$ into $R$ when $S(e)\in RB$ at that moment and put $S(e)$
into $L$ otherwise.
With this extension, algorithm {\em stronglyplanar} computes the
partition $\{L,R\}$ of the segments emanating from $C$ in linear time.
We assume for notational convenience that the partition (more precisely,
the union of all partitions for all cycles $C(e_0)$ encountered in the
algorithm) is given as a function $\alpha :S\to \{L,R\}$ where $S$ is
the set of edges for which {\em stronglyplanar} is called.

We next give the algorithmic details of the embedding process.
We first use procedure {\em stronglyplanar} to compute the mapping
$\alpha$.
We then use a procedure {\em embedding} to actually compute an
embedding.
The procedure {\em embedding} takes two parameters: an edge $e_0$ and
a flag $t\in \{L,R\}$.
A call {\em embedding}($e_0,L$) computes a canonical embedding of 
$S(e_0)$ and a call {\em embedding}($e_0,R$) computes a reversed
canonical embedding of $S(e_0)$.
The call {\em embedding}($(1,2),L$) embeds the entire graph.

The embedding of $S(e_0)$ computed by {\em embedding}$(e_0,t)$ is
represented in the following non-standard way:
\begin{enumerate}
\item For the vertices $v\in V(e_0)$ we use the standard
  representation, i.e., the cyclic list of the incident
  edges corresponding to the clockwise ordering of the edges
  in the embedding.
\item For the vertices in the stem we use a non-standard representation.
  For each vertex $w_i\in\{w_0,\ldots,w_{r}\}$ let the lists
  $AL(w_i)$ and $AR(w_i)$ be such that the catenation of
  $(w_i,w_{i+1})$, $AR(w_i)$, $(w_i,w_{i-1})$, and
  $AL(w_i)$ corresponds to the clockwise ordering of the edges
  incident to $w_i$ in the embedding. Here, $w_{-1}=w_k$.
  Note that $AR(w_i)=\emptyset$ for $1\leq i<r$ if $t=L$, and
  $AL(w_i)=\emptyset$ for $1\leq i<r$, if $t=R$.
  The lists $AL(w_i)$, $AR(w_i)$, $0\leq i\leq r$, are returned in an
  implicit way: $AL(w_r)$ and $AR(w_r)$ are returned as the list
  $T=AL(w_r),(w_r,w_{r+1})$, $AR(w_r)$ and the other lists
  are returned as the list $A=$ $AR(w_{r-1}),\ldots,$
  $AR(w_0),(w_0,w_k),AL(w_0),\ldots ,AL(w_{r-1})$,
  cf.\ Figure~\ref{result-embedding.pstex_t}.
\end{enumerate}

\bild{result-embedding.pstex_t}{A call {\em embedding} $(e_0,t)$ returns lists $T$ and $A$.}


The procedure {\em embedding} has the same structure as the procedure
{\em stronglyplanar} and is given in Program 1 on page \pageref{program}. 
It first constructs the stem and the spine (line (1)) of cycle $C(e_0)$,
then walks down the spine (lines (3) to (14)), and finally computes
the lists $T$ and $A$ it wants to return (lines (15) and (16)).

We first discuss the walk down the spine.
Suppose that the walk has reached vertex $w_j$.
We first recursively process the edges emanating from $w_j$
(lines (4) to (10)), and then compute the cyclic adjacency list of vertex
$w_j$ and prepare for the next iteration (lines (11) to (13)).

We discuss lines (4) to (10) first.
In general, some number of edges emanating from $w_j$ and all edges
incident to vertices $w_l$ with $l>j$ will have been processed already.
In agreement with our previous notation call the processed edges
$e_1,\ldots ,e_{i-1}$.
We claim that the following statement is an invariant of the loop (4) to (10):
$T$ concatenated with $(w_j,w_{j-1})$ is the cyclic adjacency list of
vertex $w_j$ in the embedding of $C+S(e_1)+\ldots +S(e_{i-1})$, and
$AL$ and $AR$ are the catenation of lists $AL(w_0),\ldots ,AL(w_{j-1})$
and $AR(w_{j-1}),\ldots ,AR(w_0)$ respectively where $(w_l,w_{l+1})$,
$AR(w_l), (w_l,w_{l-1}), AL(w_l)$ is the cyclic adjacency
list of vertex $w_l$, $0\leq l\leq j-1$, in the embedding of 
$C+S(e_0)+\ldots +S(e_{i-1})$.
The lists $T$, $AL$, and $AR$ are certainly initialized correctly in
line (2).
Assume now that we process edge $e'=e_i$ emanating from $w_j$.
The flag $\alpha(e')$ indicates what kind of embedding of $S(e_i)$ is
needed to build a canonical embedding of $S(e_0)$; the opposite kind of
embedding of $S(e_i)$ is needed to build a reversed canonical embedding
of $S(e_0)$.
So the required kind is given by $t\oplus\alpha(e')$, where 
$L\oplus L=R\oplus R=L$ and $L\oplus R=R\oplus L=R$.
The call {\em embedding}$(e',t\oplus\alpha(e'))$ computes the cyclic
adjacency lists of the vertices in $V(e')$ and returns lists $T'$ and
$A'$ as defined above.
If $S(e_i)$ has to be glued to the left side of the vertical path
$w_0,\ldots ,w_k$, i.e., if  $t=\alpha(e')$ then we append $T'$ to the front of $T$ and $A'$ to
the end of $AL$, cf.\ Figure~\ref{glueing}.
Analogously, if $S(e_i)$ has to be glued to the right side of the
path $w_0,\ldots ,w_k$, i.e., if $t\not=\alpha(e')$, then we append $T'$
to the end of $T$ and $A'$ to the front of $AR$.
This clearly maintains the invariant.

Suppose now that we have processed all edges emanating from $w_j$.
Then $(w_j,w_{j-1})$ concatenated with $T$ is the cyclic adjacency list
of vertex $w_j$ (line (11)).

\begin{figure}[htb]
\begin{center}
\input{glueing.pstex_t}
\end{center}
\caption{\label{glueing}
Glueing $S(e')$ to the left or right side of the path
$w_0,\ldots ,w_k$ respectively.}
\end{figure}

We next prepare for the treatment of vertex $w_{j-1}$.
Let $T'$ and $T''$ be the list of darts incident to $w_{j-1}$ from
the left and from the right respectively and having their other
endpoint in an already embedded segment.
List $T'$ is a suffix of $AL$ and list $T''$ is a prefix of $AR$.
The catenation of $T',(w_{j-1},w_j)$, $T''$, and
$(w_{j-1},w_{j-2})$ is the current clockwise adjacency list of
vertex $w_{j-1}$.
Thus lines (12) and (13) correctly initialize $AL$, $AR$, and $T$ for
the next iteration.

Suppose now that all edges emanating from the spine of $C(e_0)$ have
been processed, i.e., control reaches line (15).
At this point, list $T$ is the ordered list of darts incident to $w_r$
(except $(w_r,w_{r-1})$) and the two lists $AL$ and $AR$ are the
ordered list of darts incident to the two sides of the stem of $C(e_0)$.
Thus $T$ and the catenation of $AR,(w_0,w_k)$, and
$AL$ are the two components of the output of {\em embedding}$(e_0,t)$.
We summarize in

\begin{theorem}
Let $G=(V,E)$ be a planar graph.
Then $G$ can be turned into a planar map $(G,\sigma)$ in linear time.
\end{theorem}
\begin{table}
~\hrulefill

\begin{tabbing}
\qquad \= {\bf do} \= {\bf do} \= \kill
\> (0) \' {\bf procedure} {\em embedding}($e_0$: edge, $t$: $\{L,R\}$)\+\\
         ($*$ computes an embedding of $S(e_0)$, $e_0=(x,y)$, as described in the text; \\
         \> it returns the lists $T$ and $A$ defined in the text $*$)\-\\
\> (1) \' find the spine of segment $S(e_0)$ by starting in node $y$ and always\+\\
       \> take the first edge of every adjacency list until a back edge is \\
       \> encountered. This back edge leads to node $w_0=lowpt[y]$. \\
       \> Let $w_0,\ldots,w_r$ be the tree path from $w_0$ to $x=w_r$ and \\
       \> let $w_{r+1}=y,\ldots,w_k$ be the spine constructed above. \-\\
\> (2) \' $AL \gets AR \gets$ empty list of darts;\\
\>     \> $T \gets (w_k,w_0)$; \` ($*$ a list of darts $*$)\\
\> (3) \' {\bf for} $j$ {\bf from} $k$ {\bf downto} $r+1$ \\
\> (4) \' {\bf do} {\bf for} all edges $e'$ (except the first) emanating from $w_j$ \\
\> (5) \' \> {\bf do} $(T',A') \gets$ {\em embedding}$(e',t\oplus\alpha(e'))$\\
\> (6) \' \> \> {\bf if} $t=\alpha(e')$\\
\> (7) \' \> \> {\bf then} $T \gets T'$ {\bf conc} $T$; $AL \gets AL$ {\bf conc} $A'$\\
\> (8) \' \> \> {\bf else} $T \gets T$ {\bf conc} $T'$; $AR \gets A'$ {\bf conc}  $AR$\\
\> (9) \' \> \> {\bf fi}\\
\>(10) \' \> {\bf od}\\
\>(11) \' \> {\bf output} $(w_j,w_{j-1})$ {\bf conc} $T$; 
\` ($*$ the cyclic adjacency list of vertex $w_j$ $*$) \\
\>(12) \' \> {\bf let} $AL=AL'$ {\bf conc} $T'$ and $AR=T''$ 
{\bf conc} $AR'$\\
\>     \> \> where $T'$ and $T''$ contain all darts incident 
to $w_{j-1}$;\\
\>(13) \' \> $AL\gets AL'$; $AR\gets AR'$; $T\gets 
T'$ {\bf conc} $(w_{j-1},w_j)$ {\bf conc} $T''$\\
\>(14) \' {\bf od}\\
\>(15) \' $A\gets$ $AR$ {\bf conc} $(w_0,w_k)$ {\bf conc} $AL$;\\
\>(16) \' {\bf return} $T$ and $A$\\
\>(17) \' {\bf end}
\end{tabbing}

~\hrulefill Program 1 \label{program} \hrulefill 

\end{table}






In our implementation we follow the book except in three minor points. |G| has only one directed
version of each edge but |H| has both. In the embedding 
phase we need both 
directions and therefore construct the embedding of 
|H| and later translate it back to |Gin|. Secondly, we do not construct the embedding
of |H| vertex by vertex but in one shot. To that effect we compute a labelling
|sort_num| of the edges of |H| and later sort the edges.
Thirdly, the book makes reference to edges $(w_{i-1},w_i)$
and their reversals. To make these edges available we compute an array |tree_edge_into|
that contains for each node the incoming tree edge. 


We finally want to remark on our convention for drawing lists. 
In Figures \ref{result-embedding.pstex_t}
and \ref{glueing} the arrows indicate the end (!!!) of the lists.

\clearpage



@<construct embedding@>=

{list<edge> T,A;  //lists of edges of |H|

int cur_nr = 0;
edge_array<int> sort_num(H);
node_array<edge> tree_edge_into(G);



embedding(G.first_adj_edge(G.first_node()),left,G,alpha,dfsnum,T,A,
cur_nr,sort_num,tree_edge_into,parent,reversal);

/* |T| contains all edges incident to the first node except the cycle edge into it. 
That edge comprises |A| */

T.conc(A);
edge e;

forall(e,T) sort_num[e] = cur_nr ++;

edge_array<int> sort_Gin(Gin);

{edge ein;
forall_edges(ein,Gin) sort_Gin[ein] = sort_num[companion_in_H[ein]];
}

Gin.sort_edges(sort_Gin);
}

@ It remains to describe procedure |embedding|.

@<auxiliary ...@>+=
void embedding(edge e0, int t, GRAPH<node,edge>& G,
	 edge_array<int>& alpha, @| 
	 node_array<int>& dfsnum, 
	 list<edge>& T, list<edge>& A, int& cur_nr, @| 
	 edge_array<int>& sort_num, node_array<edge> & tree_edge_into, @|
	 node_array<node>& parent, edge_array<edge>& reversal)

{@<embed: determine the cycle $C(e0)$@>; 
@<process the subsegments@>;
@<prepare the output@>;
}


@ We start by determining the spine cycle. This is precisley as in |strongly_planar|. 
We also record for the vertices $w_{r+1}$, $\ldots$, $w_k$, and $w_0$ the 
incoming cycle edge either in |tree_edge_into| or in the local
variable |back_edge_into_w0|. This is line (1) of Program1.

@<embed: determine ...@>=

node x = source(e0);

node y = target(e0);

tree_edge_into[y] = e0;

edge e = G.first_adj_edge(y);


node wk = y;

while (dfsnum[target(e)] > dfsnum[wk])  // e is a tree edge
{ wk = target(e);
  tree_edge_into[wk] = e;
  e= G. first_adj_edge(wk);
}

node w0 = target(e);
edge back_edge_into_w0 = e;


@ Lines (2) to (14).

@<process the subsegments@>=

node w = wk;

list<edge> Al, Ar;
list<edge> Tprime, Aprime;


T.clear(); 
T.append(G[e]);    // |e = (wk,w0)| at this point, line (2)

while (w != x)
{ int count = 0;
  forall_adj_edges(e,w)
  {count++;
   if (count != 1) //no action for first edge
	{@<embed recursively@>;
	@<update lists |T|, |Al|, and |Ar|@>;
	} // end if
   } //end forall

@<compute |w|'s adjacency list and prepare for next iteration@>;
w = parent[w];
} //end while

@ Line (5). The book does not distinguish between tree and back edges but we do
here.

@<embed recursively@>=
	

if (dfsnum[w] < dfsnum[target(e)])
	{ /* tree edge */
	int tprime = ((t == alpha[e]) ? left : right);
	embedding(e,tprime,G,alpha,dfsnum,Tprime,Aprime,cur_nr,sort_num,tree_edge_into,parent,reversal);

	}
else 	{/* back edge */
	Tprime.append(G[e]); //$e$
	Aprime.append(reversal[G[e]]);      //reversal of $e$
	}

@ Lines (6) to (9).

@<update lists |T|, ...@>=

if (t == alpha[e])
	{Tprime.conc(T);
	T.conc(Tprime);    //$T = Tprime\ conc\ T$
	
	Al.conc(Aprime);  //$Al = Al\ conc\ Aprime$
	
	}
else	{T.conc(Tprime);  // $ T\ = T\ conc\ Tprime $

	Aprime.conc(Ar);
	Ar.conc(Aprime);  // $ Ar\ = Aprime\ conc\ Ar$
	
	}

@ Lines (11) to (13).

@<compute |w|'s ...@>=

T.append(reversal[G[tree_edge_into[w]]]);    // $(w_{j-1},w_j)$



forall(e,T) sort_num[e] = cur_nr ++;

/* |w|'s adjacency list is now computed; we clear |T| and prepare for the 
next iteration by moving all darts incident to |parent[w]| from |Al| and
|Ar| to |T|. These darts are at the rear end of |Al| and at the front end
of |Ar| */

T.clear();



while (!Al.empty() && source(Al.tail()) == G[parent[w]])   
// |parent[w]| is in |G|, |Al.tail| in |H|
	{T.push(Al.Pop());   //Pop removes from the rear
	}

T.append(G[tree_edge_into[w]]);    // push would be equivalent

while (!Ar.empty() && source(Ar.head()) == G[parent[w]])   // 
	{T.append(Ar.pop());  // pop removes from the front
	}






@ Line (15). Concatenate |Ar|, $(w_0,w_r)$, and |Al|.

@<prepare the output@>=

A.clear();

A.conc(Ar);
A.append(reversal[G[back_edge_into_w0]]);
A.conc(Al);

@* Efficiency. \label{Efficiency}

Under LEDA 3.0 the space requirement of the first version of |planar| is approximately
$160 (n+m) +100 \alpha m$ Bytes, where $n$ and $m$ denote the number of nodes 
and edges respectively and $\alpha$ is the fraction of edges in the input graph
that do not have their reversal in the input graph. For the pseudo-random
planar graphs generated in the demo we have $\alpha = 0$ and $m = 4n$ and hence the
space requirement is about $800 n$ Bytes. The second version needs an additional
$54n + 66m$ Bytes.

The running time of |planar| is about $50$ times the running 
time of |STRONG_COMPONENTS|. On a 50 MIPS SPARC10 workstation 
the planarity of a
planar graph with 16000 nodes and 30000 edges ($\alpha = 0$) is tested in 
about 10 seconds. It takes 5.4 seconds to make the graph bidirected and 
biconnected, about 3.9 seconds to test its planarity, and 
another 6.1 seconds to
construct an embedding. The space requirement is about 15 MByte.



@* A Demo. \label{demo}

The demo allows the user to either interactively construct a graph 
using 
LEDA's graph editor or to construct a random graph, or to 
construct a ``pseudo-random'' planar graph 
(the graph defined by an arrangement of random line segments). The graph is 
then tested for
planarity. If the graph is planar a straight-line embedding is output. If the
graph is non-planar a Kuratowski subgraph is highlighted.

The demo proceeds in cycles. In each cycle we first clear the graphics window |W| and
the graph |G| and then give the user the choice of a new input graph.


@(demo.c@>=

@<includes@>;
@<procedure to draw graphs@>;
main(){
@<initiation and declarations@>;
while (true){
@<select graph@>;
@<test graph for planarity and show output@>
@<reset window@>;
}
return 0;
}

@ We need to include |planar.h| and various parts of LEDA.

@<includes@>=
#include "planar.h"
#include <LEDA/graph.h>
#include <LEDA/graph_alg.h>
#include <LEDA/window.h>
#include <LEDA/graph_edit.h>

@ We need a simple procedure to draw a graph in a graphics window. The
numbering of the nodes is optional.

@<procedure to draw graphs@>=


void draw_graph(const GRAPH<point,int>& G, window& W, bool numbering=false)
{ node v;
  edge e;
  int i = 0;

  forall_edges(e,G)
    W.draw_edge(G[source(e)],G[target(e)],blue);

  if (numbering)
     forall_nodes(v,G) W.draw_int_node(G[v],i++,red);
  else
     forall_nodes(v,G) W.draw_filled_node(G[v],red);

}

@ We give the user a short explanation of the demo and declare some variables.


@<initiation and declarations@>=

panel P;

P.text_item("This demo illustrates planarity testing and planar straight-line");
P.text_item("embedding. You have two ways to construct a graph: either interactively");
P.text_item("using the LEDA graph editor or by calling one of two graph generators.");
P.text_item("The first generator constructs a random graph with a certain");
P.text_item("number of nodes and edges (you will be asked how many) and the ");
P.text_item("second generator constructs a planar graph  by intersecting a certain");
P.text_item("number of random line segments in the unit square (you will be asked how many)."); 
P.text_item(" ");

P.text_item("The graph is displayed and then tested for planarity.");
P.text_item("If the graph is non-planar a Kuratowski subgraph is highlighted.");
P.text_item("If the graph is planar, a straight-line drawing is produced.");

P.button("continue");

P.open();


window W;


GRAPH<point,int> G;
node v,w;
edge e;
int n = 250;
int m = 250;


const double pi= 3.14;

panel P1("PLANARITY TEST");
P1.int_item("|V| = ",n,0,500);
P1.int_item("|E| = ",m,0,500);
P1.button("edit");
P1.button("random");
P1.button("planar");
P1.button("quit");
P1.text_item(" ");
P1.text_item("The first slider asks for the number n of nodes and");
P1.text_item("the second slider asks for the number m of edges.");
P1.text_item("If you select the random input button then a graph with");
P1.text_item("that number of nodes and edges is constructed, if you");
P1.text_item("select the planar input button then 2.5 times square-root of n");
P1.text_item("random line segments are chosen and intersected to yield");
P1.text_item("a planar graph with about n nodes, and if you select the");
P1.text_item("edit button then the graph editor is called.");
P1.text_item(" ");



@ We display the panel |P1| until the user makes his choice. Then we construct
the appropriate graph.

@<select graph@>= 

  int inp = P1.open(W);   // P1 is displayed until a button is pressed

  if (inp == 3) break;   // quit button pressed

  W.init(0,1000,0);
  W.set_node_width(5);

  switch(inp){

  case 0: { // graph editor
	    W.set_node_width(10);
            G.clear();
            graph_edit(W,G,false);
            break;
           }
  
  case 1: { // random graph
            G.clear();
            random_graph(G,n,m);
            /* eliminate parallel edges and self-loops */
            eliminate_parallel_edges(G);
            
            list<edge>Del= G.all_edges();
            forall(e,Del) 
               if (G.source(e)==G.target(e)) G.del_edge(e);
            /* draw the graph with its nodes on a circle*/
            float ang = 0;
  
            forall_nodes(v,G)
            { G[v] = point(500+400*sin(ang),500+400*cos(ang));
              ang += 2*pi/n;
             }
  
             draw_graph(G,W);
  
             break;
           }
  
  case 2: { // pseudo-random planar graph
	    node_array<double> xcoord(G);
            node_array<double> ycoord(G);
            G.clear();
            random_planar_graph(G,xcoord,ycoord,n);
            forall_nodes(v,G)
               G[v] = point(1000*xcoord[v], 900*ycoord[v]);
  
             draw_graph(G,W);
  
            break;
           }
  
    }
  
  


@ We test the planarity of our graph |G| using our procedure |planar|.

@<test graph for planarity and ...@>=

  if (PLANAR(G,false))
  { 
    if(G.number_of_nodes()<4)
        W.message("That's an insult: Every graph with |V| <= 4 is planar");
    else
      { W.message("G is planar. I compute a straight-line embedding ...");
  
        /* we first make |G| bidirected. We remember the edges added in |n_edges| */
        node_array<int>nr(G);
        edge_array<int>cost(G);
        int cur_nr= 0;
        int n = G.number_of_nodes();
        node v;
        edge e;
        
        forall_nodes(v,G)nr[v]= cur_nr++;
        
        forall_edges(e,G)cost[e]= ((nr[source(e)]<nr[target(e)])?
        n*nr[source(e)]+nr[target(e)]:
        n*nr[target(e)]+nr[source(e)]);
        
        G.sort_edges(cost);
        
        list<edge> L= G.all_edges();
  
        list<edge> n_edges;
  
        while(!L.empty())
        { e= L.pop();
  
          if( ! L.empty() && source(e)==target(L.head())   
                          && target(e)==source(L.head()))
             L.pop();
          else
            { n_edges.append(G.new_edge(target(e),source(e)));
             }
         }
  
          Make_biconnected_graph(G);
  
          PLANAR(G,true);
  
          node_array<int> xcoord(G),ycoord(G);
  
          STRAIGHT_LINE_EMBEDDING(G,xcoord,ycoord);
  
          float f = 900.0/(2*G.number_of_nodes());
  
          forall_nodes(v,G) G[v] = point(f*xcoord[v]+30,2*f*ycoord[v]+30);
  
          forall(e,n_edges) G.del_edge(e);
  
          W.clear();
          if (inp == 0) 
             draw_graph(G,W,true); // with node numbering
          else
             draw_graph(G,W);
  
        }
     }
  else
    { W.message("Graph is not planar. I compute the Kuratowski subgraph ...");
      list<edge>L;
      PLANAR(G,L,false);
      node_array<int> deg(G,0);
      int lw = W.set_line_width(3);
      edge e;
      forall(e,L) 
      { node v = source(e);
        node w = target(e);
        deg[v]++;
        deg[w]++;
        W.draw_edge(G[v],G[w]);
       }
      int i = 1;
      /* We highlight the Kuratowski subgraph. Nodes with degree are drawn black.
The nodes with larger degree are shown green and numbered from 1 to 6 */
      forall_nodes(v,G) 
      { 
        if (deg[v]==2) W.draw_filled_node(G[v],black);

        if (deg[v] > 2)
        { int nw = W.set_node_width(10);
          W.draw_int_node(G[v],i++,green);
          W.set_node_width(nw);
         }
      }
      W.set_line_width(lw);
   }


@ We reset the graphics window.

@<reset ...@>=

   W.set_show_coordinates(false);
   W.set_frame_label("click any button to continue");
   W.read_mouse(); // wait for a click
   W.reset_frame_label();
   W.set_show_coordinates(true);



@* Some Theory.    \label{reprint}

We give the theory underlying the planarity test as described in
\cite[section IV.10]{Me:book}.
%Our next ...

\bibliography{/KM/usr/mehlhorn/tex/my}
\bibliographystyle{alpha}
\end{document}
