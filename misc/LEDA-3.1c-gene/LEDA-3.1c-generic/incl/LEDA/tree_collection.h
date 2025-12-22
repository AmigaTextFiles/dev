/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  tree_collection.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_DYNTREES_H
#define LEDA_DYNTREES_H

#include <LEDA/basic.h>

 /*********************************************************************
 *                                                                     *
 *  dyna_trees T; deklariert eine (vorerst leere) Menge von dyn_trees  *
 *                                                                     *
 *  d_vertex T.maketree(); Erzeugt einen Baum, der genau einen Knoten  *
 *     enthaelt (der in keinen anderem Baum enthalten ist.             *
 *                                                                     *
 *  d_vertex T.findroot(d_vertex v); Gibt die Wurzel des v enthaltenden*
 *     Baumes zurueck.                                                 *
 *                                                                     *  
 *  d_vertex T.findcost(d_vertex v, double& d); Gibt den entsprechenden*
 *     Knoten zurueck (s.o.), die Kosten werden im Argument d zurueck- *
 *     gegeben.                                                        *
 *                                                                     *
 *  void   T.addcost(d_vertex v, double x); s.o.                       *
 *                                                                     *
 *  void   T.link(d_vertex v, d_vertex w); s.o.                        *
 *                                                                     *
 *  void   T.cut(d_vertex v); s.o.                                     *
 *                                                                     *
 *                                                                     *
 * Implemented by Jan Timm                                             *
 *                                                                     *
 *********************************************************************/





class d_node;
typedef d_node *d_vertex;
typedef d_node *d_path;

class d_node {

friend class dyna_trees;

     void*    info;        // user-defined information

     d_vertex left,        // linkes Kind
              right,       // rechtes Kind
              parent,      // Elter
              successor,   // Nachfolger (fuer Pfad)
              next;        // fuer Verkettung fuer ~dyna_tree

     double dcost,
            dmin;

     d_node(void* i) { 
                       left=right=parent=successor=next=0;
                       dcost=dmin=0;
                       info = i;
                      };
   LEDA_MEMORY(d_node)

};
  
   
class dyna_trees {
     d_vertex first,
            last;  // diese beiden Zeiger fuer ~dyna_tree

     void splay(d_vertex);

     d_vertex assemble(d_vertex, d_vertex, d_vertex);
     void   disassemble(d_vertex, d_vertex&, d_vertex&);

     d_vertex makepath(void*);
     d_vertex findpath(d_vertex);
     d_vertex findpathcost(d_path, double&);
     d_vertex findtail(d_path);
     void   addpathcost(d_path, double);
     d_vertex join(d_path, d_path, d_path);
     void   split(d_vertex, d_vertex&, d_vertex&);
     
     d_path   expose(d_vertex);

virtual void copy_inf(GenPtr& x)      { x=x; }
virtual void clear_inf(GenPtr& x)     { x=0; }

public:
     dyna_trees() { first=last=0; };
     virtual ~dyna_trees();

     void*    inf(d_vertex v) { return v->info; }
       
     d_vertex maketree(void*);
     d_vertex findroot(d_vertex);
     d_vertex findcost(d_vertex, double&);
     void   addcost(d_vertex, double);
     void   link(d_vertex, d_vertex);
     void   cut(d_vertex);
};


template<class itype>

class _CLASSTYPE  tree_collection : public dyna_trees{

void copy_inf(GenPtr& x)      { x=Copy(ACCESS(itype,x)); }
void clear_inf(GenPtr& x)     { Clear(ACCESS(itype,x));  }

public:

d_vertex maketree(itype x)  { return dyna_trees::maketree(Convert(x)); }
itype    inf(d_vertex v)    { return ACCESS(itype,dyna_trees::inf(v)); }

 tree_collection() {}
~tree_collection() {}

};

#endif

