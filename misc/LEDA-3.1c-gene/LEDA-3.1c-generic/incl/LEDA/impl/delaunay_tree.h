/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  delaunay_tree.h
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


#ifndef LEDA_DELAUNAY_H
#define LEDA_DELAUNAY_H

/*****************************************************************************
+
+	Delaunay tree    by Olivier Devillers
+
+		Fully dynamic construction of the Delaunay triangulation with
+		good randomized complexity
+
+	Copyright (c) 1990
+	INRIA, 2004 route des Lucioles, 06 565 Valbonne Cedex, France
+
+	for LEDA
+	Copyright (c) 1990  by  Max Planck Institut f"ur Informatik
+	Im Stadtwald, 6600 Saarbruecken, FRG
+ 	All rights reserved.
+
******************************************************************************/

#include <LEDA/point.h>

typedef double coord;

struct NOEUD;
typedef NOEUD* noeud;

struct STAR;
typedef STAR* star;

struct REINSERER;
typedef REINSERER* reinserer;

struct LISTENOEUD;
typedef LISTENOEUD* listenoeud;


struct DT_POINT{
	coord x,y;
        void* i;
	int  n;		           /* un flag dont l'ordre est compatible avec
			              l'ordre d'insertion */
	int  visite;		   /* un flag de visite */
	NOEUD* cree;    /*un noeud cree par l'insertion de ce point*/
}; 

typedef DT_POINT* DT_item;



typedef void delaunay_f2(double,double);
typedef void delaunay_f4(double,double,double,double);
typedef void delaunay_f6(double,double,double,double,double,double);
typedef void delaunay_F6(double,double,double,double,double*,double*);



class delaunay_tree{

        int flag;		/* numero de l'operation en cours */
        noeud nouveau;		/* dernier noeud cree */
        
        star Star;		/* pour la suppression */
        reinserer Reinsert;

	NOEUD * arbre ;		/* la racinne du Delaunay tree */
	NOEUD * last ;		/* dernier noeud cree */

        int counter;            /* total number of items (s.n.) */



char*      used_blocks;
DT_item    Poubelle_point;
listenoeud Poubelle_listenoeud;
noeud      Poubelle_noeud;
noeud      Libre_noeud;
star       Poubelle_star;
reinserer  Poubelle_reinserer;

int fl;

int item_nombre;
DT_item item_next;

int listenoeud_nombre;
listenoeud listenoeud_next;

int noeud_nombre;
noeud noeud_next;

int star_nombre;
star star_next;

int reinserer_nombre;
reinserer reinserer_next;

star first_star;



char*      alloc_block(int size);
void       free_blocks();
void       poubelle_point(DT_item p);
DT_item    vrai_alloc_point();
DT_item    alloc_point();
void       poubelle_listenoeud(listenoeud p);
listenoeud vrai_alloc_listenoeud();
listenoeud alloc_listenoeud();
void       poubelle_noeud(noeud p);
noeud      vrai_alloc_noeud();
noeud      alloc_noeud();
void       poubelle_star(star p);
star       vrai_alloc_star();
star       alloc_star();
void       poubelle_reinserer( reinserer p);
reinserer  vrai_alloc_reinserer();
reinserer  alloc_reinserer();

void  beaufils( noeud bf, noeud bp);
void  plusbeaufils( noeud bf, noeud bp);
void  demiplan( noeud t);
void  cercle( noeud t);
int   confondu( DT_item a, DT_item b);
int   direct( noeud n);
int   conflit( noeud n, DT_item p);
noeud Insert( noeud n, DT_item p);
noeud creenoeud( noeud pere, int i, DT_item p);
int   creation( noeud detruit, DT_item p);
DT_item localise( noeud detecte, DT_item p);
void  add_x1x2( reinserer r, noeud v, DT_item p);
void  add_decroche( reinserer r, noeud v);
void  destroy( noeud u, DT_item p);
void  recherche( DT_item p);
void  reinsertion( reinserer n, DT_item p);
void  parcours( reinserer n, DT_item p);
void  trace_items(noeud, delaunay_f2*);
void  list_items(noeud n, list<DT_item>& L);
void  clear_items(noeud n);
void  del_noeud( noeud n, delaunay_f4* trace_segment,int both);
void  vor( noeud n, delaunay_f6* trace_segment, delaunay_F6* pt_infi, int both);

virtual void copy_inf(GenPtr& p)  { p=p; }
virtual void clear_inf(GenPtr& p) { p=0; }

public:

delaunay_tree();
virtual ~delaunay_tree();

reinserer locate( reinserer n, DT_item x);
void clear_Reinsert( reinserer n);
void clear_Star();
void init_Star( noeud n, int i, int j, int k);
star loc_Star( DT_item xx);
void split_Star( star n1,star n2);

DT_item insert(double, double, void*);

DT_item insert(point p, void* inf) { return insert(p.xcoord(),p.ycoord(),inf); }

DT_item neighbor(double, double);
DT_item neighbor(point p)          { return neighbor(p.xcoord(),p.ycoord()); }
void    del(double, double);
void    del(point p)               { del(p.xcoord(),p.ycoord()); }
void    del_item( DT_item);

point    key(DT_item p)  { return point(p->x,p->y); } 
void*    inf(DT_item p)  { return p->i; } 

void     change_inf(DT_item p, void* i)  { copy_inf(i);  
                                           clear_inf(p->i); 
                                           p->i = i; } 

void     trace_voronoi_sites( delaunay_f2*);
void     trace_voronoi_edges( delaunay_f6*, delaunay_F6*, int both = 0);
void     trace_triang_edges( delaunay_f4* , int both = 0);

void     all_items(list<DT_item>&);

void     convex_hull(list<DT_item>&);

void     clear();
void     init();

};




template<class itype>

class _CLASSTYPE DELAUNAY_TREE : public delaunay_tree {

void copy_inf(GenPtr& p)  { Copy(*(itype*)&p); }
void clear_inf(GenPtr& p) { Clear(*(itype*)&p); }

public:

DT_item insert(point site, itype i)
                          { return delaunay_tree::insert(site,Convert(i)); }

itype  inf(DT_item p)    { return itype(delaunay_tree::inf(p)); } 

 DELAUNAY_TREE() {}
~DELAUNAY_TREE() {}

};

#endif
