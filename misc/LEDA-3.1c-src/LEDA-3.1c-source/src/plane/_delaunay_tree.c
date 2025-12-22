/*******************************************************************************
+
+  LEDA  3.1c
+
+
+  _delaunay_tree.c
+
+
+  Copyright (c) 1994  by  Max-Planck-Institut fuer Informatik
+  Im Stadtwald, 6600 Saarbruecken, FRG     
+  All rights reserved.
+ 
*******************************************************************************/


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
+
******************************************************************************/


#include <LEDA/impl/delaunay_tree.h>


#define Fini		0
#define Infini1 	1		/* 1 point a l'infini */
#define Infini2		2		/* 2 points a l'infini */
#define Infini3		3		/* 3 points a l'infini, c'est la racine */
#define Impossible	99		/* Le voisin du precedent */
#define U 0				/* indices pour les trois sommets */
#define V 1
#define W 2


/*****************************************************************************

			Declarations de type

******************************************************************************/


struct LISTENOEUD{
	NOEUD *item;
	LISTENOEUD *next;
};



struct REINSERER {
	DT_item	x;				/* a point devant etre reinserer */
	NOEUD   *detruit1,			/* triangles a detruire si ils existent */
		*detruit2;			/* NULL sinon xpx1 est direct et xpx2 indirect*/
	listenoeud
		decroches;			/* triangles decroches */
	REINSERER
		*finf,*fsup;		/* pour l'arbre binaire */
};



struct STAR{
	STAR
			*next,*previous;/*arete suivante et precedente sur le polygone*/
	NOEUD
			*triangle;		/* triangle adjacent */
	int		n,p,arete;		/*point suivant, precedent, arete dans le triangle*/
};




struct NOEUD{

	int		type;	/* le triangle est Fini ou Infini[123] 
				   dans le cas d'un triangle infini, les sommets
				   infinis sont la direction a` l'infini */
	
	int		degenere;  /* booleen, 3 pts alignes ? */
	int		direct;	   /* booleen, le triangle est-il direct ? */
        int             stacked;
	int		visite;	   /* triangle marque visite si ce flag
			              est le flag courant.
				      pour la suppression le triangle est
	                              marque si il appartient ou a
	                              appartenu a A 
	                            */
	
	int		detruire;   /* le triangle est a detruire si ce flag
				       est le flag courant */
	coord 	cx,cy;		    /* centre du cercle 
	                                      (uniqu^t pour tracer voronoi)*/
	coord	a2,b2,a3,b3,c1,z0,z1,z2; /* pour les tests de conflit */
	
	DT_item	meurtrier; /* NULL si le triangle n'est pas mort */
	DT_item	s[3];	   /* sommets du triangle */
				   /* U est le createur */
				   /* si Infini1 alors W est a l'infini */
				   /* si Infini2 alors V et W sont a l'infini */
				   /* si Infini3 alors U,V et W sont a l'infini*/
	NOEUD
			*pere,		/* pere */
			*bpere,		/* beau-pere */
			*fils[3];	/* fils */
	listenoeud
			bfils;		/* liste des beaux-fils */
	NOEUD
			*voisin[3],	/* 3 voisins (courant ou a la mort) */
			*creation[3],	/* 3 voisins a la creation */
			*special[3];	/* 3 voisins speciaux! */
	star	Star[3];		/* pointeur reciproque vers Star */


};

/*****************************************************************************

			Allocation memoire

******************************************************************************/

#define SIZEALLOC 100


char* delaunay_tree::alloc_block(int size)
{
   char* p =  (char*)malloc( size + sizeof(double) ); 

   if (!p) error_handler(1,"out of memory");

   *((char**)p) = used_blocks;
   used_blocks = p;

   return (used_blocks+sizeof(double)) ; 
 }


void delaunay_tree::free_blocks()
{
  char* p;
  while (used_blocks)
  { p = used_blocks;
    used_blocks = *((char**)used_blocks);
    free(p);
   }
}

void delaunay_tree::poubelle_point(DT_item p)
{ p->cree = (noeud) Poubelle_point;
  Poubelle_point = p;
}

DT_item delaunay_tree::vrai_alloc_point()
{
 if ( ! item_nombre ) {
		item_next = (DT_item) alloc_block( (item_nombre = SIZEALLOC) * sizeof(DT_POINT) ) ; 
	}
	item_nombre--;
	return item_next++;
}

DT_item delaunay_tree::alloc_point()
{
	if ( Poubelle_point ) { DT_item p = Poubelle_point;
				Poubelle_point = (DT_item) Poubelle_point->cree;
				return p;  }
	return vrai_alloc_point();
}


void delaunay_tree::poubelle_listenoeud(listenoeud p)
{
  p->next =  Poubelle_listenoeud;
  Poubelle_listenoeud = p;
}

listenoeud delaunay_tree::vrai_alloc_listenoeud()
{
 if ( ! listenoeud_nombre ) {
		listenoeud_next = (listenoeud) alloc_block((listenoeud_nombre = SIZEALLOC) * sizeof(LISTENOEUD) ) ; 
	}
	listenoeud_nombre--;
	return listenoeud_next++;
}

listenoeud delaunay_tree::alloc_listenoeud()
{
	if ( Poubelle_listenoeud ) 
                              { listenoeud p = Poubelle_listenoeud;
			        Poubelle_listenoeud = Poubelle_listenoeud->next;
				return p;  }
	return vrai_alloc_listenoeud();
}


void delaunay_tree::poubelle_noeud(noeud p)
/* on ne se resert que des noeud dont le champs detruire n'est pas flag */
{ 
  p->fils[0] =  Poubelle_noeud;
  Poubelle_noeud = p;
  if (fl != p->detruire ) { fl = p->detruire; Libre_noeud = Poubelle_noeud ;}
}

noeud delaunay_tree::vrai_alloc_noeud()
{
 if ( ! noeud_nombre ) {
		noeud_next = (noeud) alloc_block((noeud_nombre = SIZEALLOC) * sizeof(NOEUD) ) ; 
	}
	noeud_nombre--;
	return noeud_next++;
}

noeud delaunay_tree::alloc_noeud()
/* on ne se resert que des noeud dont le champs detruire n'est pas flag */
{	
	if (Libre_noeud && Libre_noeud->fils[0] )
			{ noeud p = Libre_noeud->fils[0];
			  Libre_noeud->fils[0] = Libre_noeud->fils[0]->fils[0];
			  return p;  }
	return vrai_alloc_noeud();
}


void delaunay_tree::poubelle_star(star p)
{
  p->next =  Poubelle_star;
  Poubelle_star = p;
}

star delaunay_tree::vrai_alloc_star()
{
 if ( ! star_nombre ) {
		star_next = (star) alloc_block((unsigned int) (star_nombre = SIZEALLOC) * sizeof(STAR) ) ; 
	}
	star_nombre--;
	return star_next++;
}


star delaunay_tree::alloc_star()
{
	if ( Poubelle_star ) { star p = Poubelle_star;
			       Poubelle_star = Poubelle_star->next;
			       return p;  }
	return vrai_alloc_star();
}


void delaunay_tree::poubelle_reinserer( reinserer p)
{
  p->finf =  Poubelle_reinserer;
  Poubelle_reinserer = p;
}
 
reinserer delaunay_tree::vrai_alloc_reinserer()
{
 if ( ! reinserer_nombre ) {
		reinserer_next = (reinserer) alloc_block((reinserer_nombre = SIZEALLOC) * sizeof(REINSERER) ) ; 
	}
	reinserer_nombre--;
	return reinserer_next++;
}


reinserer delaunay_tree::alloc_reinserer()
{
	if ( Poubelle_reinserer ) {reinserer p = Poubelle_reinserer;
			   	   Poubelle_reinserer = Poubelle_reinserer->finf;
				   return p;  }

	return vrai_alloc_reinserer();
}

/*****************************************************************************

			Structure Reinsert

******************************************************************************/

reinserer delaunay_tree::locate( reinserer n, DT_item x)
{
	reinserer nn;

	if ( ! Reinsert ) {
		nn = alloc_reinserer();
		nn->x = x;
		nn->decroches = NULL;
		nn->detruit1 = NULL;
		nn->detruit2 = NULL;
		nn->finf = NULL;
		nn->fsup = NULL;
		Reinsert = nn;
	 return nn;
	}
	if ( n->x == x) return n;
	if ( x->n < n->x->n ) {
		if (n->finf) return locate(n->finf,x);
		nn = alloc_reinserer();
		nn->x = x;
		nn->decroches = NULL;
		nn->detruit1 = NULL;
		nn->detruit2 = NULL;
		nn->finf = NULL;
		nn->fsup = NULL;
		n->finf = nn;
	} else {
		if (n->fsup) return locate(n->fsup,x);
		nn = alloc_reinserer();
		nn->x = x;
		nn->decroches = NULL;
		nn->detruit1 = NULL;
		nn->detruit2 = NULL;
		nn->finf = NULL;
		nn->fsup = NULL;
		n->fsup = nn;
	}
	return nn;
}

void delaunay_tree::clear_Reinsert( reinserer n)
{	listenoeud l,ll;
	if ( ! Reinsert ) return;
	if (n->finf) clear_Reinsert(n->finf);
	if (n->fsup) clear_Reinsert(n->fsup);
	for ( l = n->decroches; l; l = ll ) {ll = l->next; poubelle_listenoeud(l);}
	poubelle_reinserer(n);
	if ( n == Reinsert ) Reinsert = NULL;
}

/*****************************************************************************

			Structure Star

******************************************************************************/

void delaunay_tree::clear_Star()
{
	star s;

	if ( ! Star ) return;
	for ( s = Star->next ; s != Star ;)
				{s = s->next; poubelle_star(s->previous);}
	poubelle_star(Star);
	Star = NULL;
}

void delaunay_tree::init_Star( noeud n, int i, int j, int k)
/* l'arete i,j de n est sur le bord de star */
{
	star s;

	if (! n) {
		Star->next = first_star;
		first_star->previous = Star;
		first_star = NULL;
		return;
	}
	s = alloc_star();
	s->triangle = n;
	s->p = i;
	s->n = j;
	s->arete = k;
	n->Star[k] = s ;
	s->previous = Star;
	if (! Star ) first_star = s;
	else		 Star->next = s;
	Star = s;
}

star delaunay_tree::loc_Star( DT_item xx)
/* trouve l'arete telle que xx soit le point precedent */
{
	star s;

	s = Star;
	while ( s->triangle->s[s->p] != xx ) s = s->next ;
	return s;
}

void delaunay_tree::split_Star( star n1,star n2)
/* raccroche les n1 a n2 en viarant la partie intermediare */
{
	star s,ss;

	if (n1==n2) {
		s = alloc_star();
		s->previous = n1;
		s->next = n1->next;
		n1->next = s;
		s->next->previous = s;
		return;
	}
	for ( s = n1->next; s != n2 ; ){ss=s->next; poubelle_star(s); s=ss; }
	n1->next = n2;
	Star = n2->previous = n1;
}

/*****************************************************************************

			Procedures

******************************************************************************/

void delaunay_tree::beaufils( noeud bf, noeud bp)
/* ajoute bf a la liste des beaufils de bp */
{
	listenoeud nov;

	nov = alloc_listenoeud();
	nov->next = bp->bfils;
	nov->item = bf;
	bp->bfils = nov;
}

void delaunay_tree::plusbeaufils( noeud bf, noeud bp)
/* enleve bf a la liste des beaufils de bp */
{
	listenoeud n,nn;

	if ( bp->bfils->item == bf ) {
		nn = bp->bfils;
		bp->bfils = bp->bfils->next ;
		poubelle_listenoeud(nn);
		return;
	}
	for ( n = bp->bfils; n->next->item != bf; n = n->next );
	nn = n->next ;
	n->next = n->next->next ;
	poubelle_listenoeud(nn);
}

void delaunay_tree::demiplan( noeud t)
/* calcul de la normale */
{
	t->type = Infini1;
	t->degenere = 0;
	if ( t->direct ) {
			t->cx= t->s[U]->y - t->s[V]->y ;
			t->cy= t->s[V]->x - t->s[U]->x ;
	} else {
			t->cx= t->s[V]->y - t->s[U]->y ;
			t->cy= t->s[U]->x - t->s[V]->x ;
	}
}

void delaunay_tree::cercle( noeud t)
{
	register double a,b,c,d;
/* calcul pour les tests de conflits */
   	t->a2 = t->s[1]->x - t->s[0]->x ;
   	t->b2 = t->s[1]->y - t->s[0]->y ;
   	t->a3 = t->s[2]->x - t->s[0]->x ;
   	t->b3 = t->s[2]->y - t->s[0]->y ;
 
   	t->c1 = t->a2 * t->b3 - t->a3 * t->b2 ;
   	t->z1 = t->a2 * (t->s[1]->x + t->s[0]->x) + t->b2 * (t->s[1]->y+t->s[0]->y);
   	t->z2 = t->a3 * (t->s[2]->x + t->s[0]->x) + t->b3 * (t->s[2]->y+t->s[0]->y);
/* calcul du centre et du rayon du cercle  */
	a = t->s[U]->x * t->s[U]->x + t->s[U]->y * t->s[U]->y ;
	b = t->s[V]->x * t->s[V]->x + t->s[V]->y * t->s[V]->y - a ;
	c = t->s[W]->x * t->s[W]->x + t->s[W]->y * t->s[W]->y - a ;
	d = 2*( (t->s[V]->x - t->s[U]->x) * (t->s[W]->y - t->s[U]->y)
				- (t->s[W]->x - t->s[U]->x) * (t->s[V]->y - t->s[U]->y));
	if ( (t->degenere = (d==0) ) ) { 
						t->cx= t->pere->cx ;
						t->cy= t->pere->cy ;
					return;
				}
	t->cx=(b*(t->s[W]->y - t->s[U]->y)-c*(t->s[V]->y - t->s[U]->y))/d;
	t->cy=(c*(t->s[V]->x - t->s[U]->x)-b*(t->s[W]->x - t->s[U]->x))/d;
}

int delaunay_tree::confondu( DT_item a, DT_item b)
{
	return ((a->x == b->x)&&(a->y==b->y));
}

int delaunay_tree::direct( noeud n)
/* teste si un triangle est direct */
{
	switch(n->type){
	case Fini       : 
		return ((n->s[V]->x - n->s[U]->x)*(n->s[W]->y - n->s[U]->y)
				- (n->s[V]->y - n->s[U]->y)*(n->s[W]->x - n->s[U]->x) > 0);
	case Infini1	 :
		return ((n->s[V]->x - n->s[U]->x)*n->s[W]->y
				- (n->s[V]->y - n->s[U]->y)*n->s[W]->x > 0);
	case Infini2     :
		return (n->s[V]->x*n->s[W]->y - n->s[V]->y*n->s[W]->x > 0);
	case Infini3     : return 1;
	case Impossible  : return 1;
	}
	return 2;
}

 
int delaunay_tree::conflit(noeud n, DT_item p)
{
  /* teste si un point est en conflit avec une region */

    register coord a1,c2,c3,z0;

    switch(n->type){
    case Fini       :
        a1 = p->x - n->s[0]->x ;
        c3 = p->y - n->s[0]->y ;

        z0 = a1 * (p->x + n->s[0]->x) + c3 * (p->y + n->s[0]->y) ;

        c2 = n->a3 * c3 - a1 * n->b3 ;
        c3 = a1 * n->b2 - n->a2 * c3 ;

            /********** Arithmetique double precision ************/
            /*      On utilise le fait que les flottants de l'accelerateur
                    flottant sont stockes avec une mantisse de 64 bits !!!
                    Pour faire du calcul entier juste, faite le en flottant !
            */

        a1=(double)z0*(double)n->c1 + (double)n->z1*(double)c2 +
                                    (double)n->z2*(double)c3;
        return (n->direct ? ( a1 <= 0.0)  : (a1 >= 0.0) );
    case Infini1    :
        if ( ( (p->x - n->s[U]->x)* (n->s[U]->y - n->s[V]->y)
                + (p->y - n->s[U]->y)* (n->s[V]->x - n->s[U]->x) ) == 0 )
        {               z0 = n->s[U]->x - p->x;
                        a1 = n->s[U]->y - p->y;
                        c2 = n->s[V]->x - p->x;
                        c3 = n->s[V]->y - p->y;
                        return ( z0*c2 + a1*c3 < 0);
        }else return (n->direct)
            ?   ( ( (p->x - n->s[U]->x)* (n->s[U]->y - n->s[V]->y)
                    + (p->y - n->s[U]->y)* (n->s[V]->x - n->s[U]->x) ) > 0 )
            :   ( ( (p->x - n->s[U]->x)* (n->s[V]->y - n->s[U]->y)
                    + (p->y - n->s[U]->y)* (n->s[U]->x - n->s[V]->x) ) > 0 ) ;
    case Infini2    :
                return ( (p->x - n->s[U]->x) * (n->s[V]->x + n->s[W]->x)
                    +(p->y - n->s[U]->y) * (n->s[V]->y + n->s[W]->y) > 0 );
    case Infini3    : return 1;
    case Impossible : return 0;
    }
    return 0;
}

//int delaunay_tree::conflit( noeud n, DT_item p)
///* teste si un point est en conflit avec une region */
//{
//	register coord a1,c2,c3,z0;
//
//	switch(n->type){
//	case Fini		:
//    	a1 = p->x - n->s[0]->x ;
//    	c3 = p->y - n->s[0]->y ;
//
//    	z0 = a1 * (p->x + n->s[0]->x) + c3 * (p->y + n->s[0]->y) ;
//	 
//    	c2 = n->a3 * c3 - a1 * n->b3 ;
//    	c3 = a1 * n->b2 - n->a2 * c3 ;
// 
//	/********** Arithmetique double precision ************/
//	/* On utilise le fait que les flottants de l'accelerateur
//	   flottant sont stockes avec une mantisse de 64 bits !!!
//           Pour faire du calcul entier juste, faite le en flottant !
//	*/
// 
//	a1=(double)z0*(double)n->c1 + (double)n->z1*(double)c2 + (double)n->z2*(double)c3;
//		return (n->direct ? ( a1 <= 0.0)  : (a1 >= 0.0) );
//
//	case Infini1    : 
//		return (n->direct)
//			?	( ( (p->x - n->s[U]->x)* (n->s[U]->y - n->s[V]->y)
//					+ (p->y - n->s[U]->y)* (n->s[V]->x - n->s[U]->x) ) >= 0 )
//			:	( ( (p->x - n->s[U]->x)* (n->s[V]->y - n->s[U]->y)
//					+ (p->y - n->s[U]->y)* (n->s[U]->x - n->s[V]->x) ) >= 0 ) ;
//	case Infini2    :
//				return ( (p->x - n->s[U]->x) * (n->s[V]->x + n->s[W]->x)
//					+(p->y - n->s[U]->y) * (n->s[V]->y + n->s[W]->y) >= 0 );
//	case Infini3    : return 1;
//	case Impossible : return 0;
//	}
//	return 0;
//}



void delaunay_tree::clear()
{
  if (arbre != nouveau)
  { flag++;
    arbre->s[U]->visite = flag;
    arbre->s[V]->visite = flag;
    arbre->s[W]->visite = flag;
    clear_items(nouveau);
   }
  free_blocks();
  init();
}

delaunay_tree::~delaunay_tree() { clear(); }

delaunay_tree::delaunay_tree()  { init(); }

void delaunay_tree::init()
/* initialisation du Delaunay tree avec les trois points a l'infini */
{
        counter = 0;
        flag=1; 
        Star = NULL; 
        Reinsert = NULL; 
        Poubelle_noeud = Libre_noeud = NULL;

        used_blocks=NULL;
        Poubelle_point=NULL;
        Poubelle_listenoeud=NULL;
        Poubelle_noeud=NULL;
        Libre_noeud=NULL;
        Poubelle_star=NULL;
        Poubelle_reinserer=NULL;
        fl = 0;
        item_nombre = 0;
        item_next = 0;
        listenoeud_nombre = 0;
        listenoeud_next = 0;
        noeud_nombre = 0;
        noeud_next = 0;
        star_nombre = 0;
        star_next = 0;
        reinserer_nombre = 0;
        reinserer_next = 0;
        first_star=NULL;


	arbre = alloc_noeud();
	nouveau = arbre;

	arbre->type = Infini3;
	arbre->degenere = 0;
	arbre->visite = 0;
	arbre->stacked = 0;
	arbre->detruire = 0;
	arbre->meurtrier = NULL;
	arbre->fils[U] = arbre->fils[V] = arbre->fils[W] = NULL ;
	arbre->bfils = NULL;
	arbre->pere = NULL;
	arbre->bpere = NULL;
	arbre->voisin[U] =
	arbre->voisin[V] =
	arbre->voisin[W] =
	arbre->creation[U] =
	arbre->creation[V] =
	arbre->creation[W] = alloc_noeud();
	arbre->direct = 1;

	arbre->voisin[W]->visite = 0;
	arbre->voisin[W]->stacked = 0;
	arbre->voisin[W]->type = Impossible ;
	arbre->voisin[W]->degenere = 0;
	arbre->voisin[W]->meurtrier = NULL ;
	arbre->voisin[W]->fils[U] = arbre->voisin[W]->fils[V] =
							arbre->voisin[W]->fils[W] = NULL ;
	arbre->voisin[W]->bfils = NULL ;
	arbre->voisin[W]->pere = NULL ;
	arbre->voisin[W]->bpere = NULL ;
	arbre->voisin[W]->voisin[U] =
	arbre->voisin[W]->voisin[V] =
	arbre->voisin[W]->voisin[W] =
	arbre->voisin[W]->creation[U] =
	arbre->voisin[W]->creation[V] =
	arbre->voisin[W]->creation[W] = arbre ;
	arbre->voisin[W]->direct = 0;

	arbre->s[U] = arbre->voisin[W]->s[U] = alloc_point();
	arbre->s[V] = arbre->voisin[W]->s[V] = alloc_point();
	arbre->s[W] = arbre->voisin[W]->s[W] = alloc_point();
	arbre->s[U]->x =  2;
	arbre->s[U]->y =  0;
	arbre->s[V]->x = -1;
	arbre->s[V]->y =  2;
	arbre->s[W]->x = -1;
	arbre->s[W]->y = -2;
	arbre->s[U]->n = 0;
	arbre->s[V]->n = 0;
	arbre->s[W]->n = 0;

}

noeud delaunay_tree::Insert( noeud n, DT_item p)
/* recherche d'un conflit */
{
	listenoeud l;
	noeud nn;
	int i;

	if ( flag != n->visite ) {
	 n->visite = flag;
	 if ( conflit(n,p)){
		if ( n->meurtrier ) {
			for (i=U; i<=W; i++) if ( n->fils[i] )
				if ( nn = Insert( n->fils[i], p) ) return nn ;
		} else return n ;
		for ( l = n->bfils; l ; l = l->next )
				if ( nn = Insert( l->item, p) ) return nn ;
	 }
	}
	return NULL ;
}

noeud delaunay_tree::creenoeud( noeud pere, int i, DT_item p)
{
				nouveau = pere->fils[i] = alloc_noeud();
				beaufils(nouveau, pere->voisin[i] );
				nouveau->visite = flag;
				nouveau->stacked = flag;
				nouveau->detruire = 0;
				nouveau->meurtrier = NULL;
				nouveau->fils[U] = nouveau->fils[V] = nouveau->fils[W] = NULL ;
				nouveau->bfils = NULL;
				nouveau->s[U]=p;					/* createur */
				switch(i){
				case U: nouveau->direct = pere->direct;
						nouveau->s[V]= pere->s[V];
						nouveau->s[W]= pere->s[W]; break;
				case V: nouveau->direct = ! pere->direct;
						nouveau->s[V]= pere->s[U];
						nouveau->s[W]= pere->s[W]; break;
				case W: nouveau->direct = pere->direct;
						nouveau->s[V]= pere->s[U];
						nouveau->s[W]= pere->s[V]; break;
				}
				nouveau->pere = pere;
				nouveau->bpere =
				nouveau->voisin[U] =
				nouveau->creation[U] = pere->voisin[i];
										/* nouveau est-il fini ou infini */
				switch ( pere->type ) {
				case Fini       :
					cercle(nouveau);
					nouveau->type = Fini; break;
				case Infini1    :
					switch (i) {
					case U: 
					case V: demiplan(nouveau); nouveau->type = Infini1;
							nouveau->degenere = 0; break;
					case W: cercle(nouveau); nouveau->type = Fini; break;
					}break;
				case Infini2    :
					switch (i) {
					case U: nouveau->type = Infini2;
							nouveau->degenere = 0;break; 
					case V:
					case W: nouveau->type = Infini1; demiplan(nouveau);
							nouveau->degenere = 0;break; 
					}break;
				case Infini3    : nouveau->type = Infini2;
									nouveau->degenere = 0;break; 
				case Impossible : break;
				}
	return nouveau;
}

int delaunay_tree::creation( noeud detruit, DT_item p)
/* creation eventuelle des nouveaux noeuds et des liens et des voisinages*/
{
	DT_item first= NULL;
	noeud n1,father;
	int arete;		/* indice sur n1 de l'arete axe-createur */ 
	int a,b,c;		/* indice des trois sommets sur father */
	int a1,b1,c1;	/* indice des trois sommets sur le noeud precedent */
	int j;

	if ( ! detruit)
					return 0;
		for (j=U; j<= W - detruit->type; j++) if (confondu(p,detruit->s[j]))
									return 0;
		detruit->meurtrier = p;
		a = U; b = V; c = W;
		while ( detruit->voisin[c]->meurtrier
			|| conflit ( detruit->voisin[c],p) )
                {
		   detruit->voisin[c]->meurtrier = p;
		   a1 = a; b1 = b; c1 = c;
		   for (j=U; j<=W; j++)
		   if (detruit->voisin[c1]->s[j] == detruit->s[a1]) 
                       a=j;
		   else 
                      if (detruit->voisin[c1]->s[j] == detruit->s[b1]) 
                         c=j;
                      else
                         b=j;
		   detruit = detruit->voisin[c1] ;
		}
				p->cree = n1 = creenoeud(detruit,c,p);
				/* n1 remplace pere comme voisin de son beau-pere*/
				for (j=U; j<=W; j++)
					if (	(detruit->voisin[c]->s[j] != n1->s[V])
						&&	(detruit->voisin[c]->s[j] != n1->s[W])) break;
				detruit->voisin[c]->voisin[j] = n1 ;
				switch (c) {
					case U : first = detruit->s[a=(detruit->direct) ? W : V ];
									break;
					case V : first = detruit->s[a=(detruit->direct) ? U : W ];
									break;
					case W : first = detruit->s[a=(detruit->direct) ? V : U ];
									break;
				}
				b = c; c = U+V+W -b -a ;
				father = detruit;
				arete =  (n1->direct) ? V : W ;
	do {
				/* ac est l'arete par laquelle n1 est fils de father */
				/* on veut tourner autour de a en faisant bouger c vers b */
				/* i e on tourne dans le sens direct */
		while ( 	father->voisin[c]->meurtrier
				||	conflit ( father->voisin[c],p) 		){
			father->voisin[c]->meurtrier = p;
			a1 = a; b1 = b; c1 = c;
			for (j=U; j<=W; j++)
				if (father->voisin[c1]->s[j] == father->s[a1])			a=j ;
				else if (father->voisin[c1]->s[j] == father->s[b1])		c=j ;
				else													b=j;
			father = father->voisin[c1] ;
		}
		if (father->fils[c])
				n1->creation[arete] = n1->voisin[arete] = father->fils[c] ;
		else {  n1->creation[arete] = n1->voisin[arete] = creenoeud(father,c,p);
				/* le nouveau remplace pere comme voisin de son beau-pere*/
				for (j=U; j<=W; j++)
					if (	(father->voisin[c]->s[j] != father->fils[c]->s[V])
						&&	(father->voisin[c]->s[j] != father->fils[c]->s[W]))
																		break;
				father->voisin[c]->voisin[j] = father->fils[c] ;
		}
		arete =  (father->fils[c]->direct) ? V : W ;
		father->fils[c]->creation[V+W-arete] =
						father->fils[c]->voisin[V+W-arete] = n1 ;
		n1 = father->fils[c] ;
		j = a ;
		a = b ;
		b = c ;
		c = j ;
	} while ( father->s[a] != first );
	return 1;
}

DT_item delaunay_tree::localise( noeud detecte, DT_item p)
/* determination du plus proche voisin */
{
	DT_item first= NULL,trouve = NULL;
	coord dist, distance = 10000000.0;
	noeud father;
	int a,b,c;		/* indice des trois sommets sur father */
	int a1,b1,c1;	/* indice des trois sommets sur le noeud precedent */
	int j;

	if (!detecte)
					return NULL;

		for (j=U; j<= W - detecte->type; j++) if (confondu(p,detecte->s[j]))
									return detecte->s[j];
		detecte->visite = flag++ ;
		a = U; b = V; c = W;
		while ( 	( detecte->voisin[c]->visite == flag )
				||	conflit ( detecte->voisin[c],p) 		){
			detecte->voisin[c]->visite = flag;
			a1 = a; b1 = b; c1 = c;
			for (j=U; j<=W; j++)
				if (detecte->voisin[c1]->s[j] == detecte->s[a1])		a=j ;
				else if (detecte->voisin[c1]->s[j] == detecte->s[b1])	c=j ;
				else													b=j;
			detecte = detecte->voisin[c1] ;
		}
				switch (c) {
					case U : first = detecte->s[a=(detecte->direct) ? W : V ];
									break;
					case V : first = detecte->s[a=(detecte->direct) ? U : W ];
									break;
					case W : first = detecte->s[a=(detecte->direct) ? V : U ];
									break;
				}
				b = c; c = U+V+W -b -a ;
				father = detecte;
	do {
				/* on veut tourner autour de a en faisant bouger c vers b */
				/* i e on tourne dans le sens direct */
		while ( 	( father->voisin[c]->visite == flag )
				||	conflit ( father->voisin[c],p) 		){
			father->voisin[c]->visite = flag;
			a1 = a; b1 = b; c1 = c;
			for (j=U; j<=W; j++)
				if (father->voisin[c1]->s[j] == father->s[a1])			a=j ;
				else if (father->voisin[c1]->s[j] == father->s[b1])		c=j ;
				else													b=j;
			father = father->voisin[c1] ;
		}
		if (father->s[a]->n) {
			dist = (p->x - father->s[a]->x) * (p->x - father->s[a]->x) +
					(p->y - father->s[a]->y) * (p->y - father->s[a]->y)	;
			if (dist < distance) { distance = dist; trouve = father->s[a]; }
		}
		j = a ;
		a = b ;
		b = c ;
		c = j ;
	} while ( father->s[a] != first );
	return trouve;
}

void delaunay_tree::add_x1x2( reinserer r, noeud v, DT_item p)
/* ajoute v a comme triangle detruit de r */
{
	if ( v->direct )
					 if  (p==v->s[V]) r->detruit1 = v;
					 else			  r->detruit2 = v;
	else			
					 if  (p==v->s[W]) r->detruit1 = v;
					 else			  r->detruit2 = v;
}

void delaunay_tree::add_decroche( reinserer r, noeud v)
/* ajoute v a la liste des decroches de r */
{
	listenoeud nov;

	nov = alloc_listenoeud();
	nov->next = r->decroches;
	nov->item = v;
	r->decroches = nov;
}

void delaunay_tree::destroy( noeud u, DT_item p)
/* recherche recursive pour initialisation de Reinsert */
{
	int i;
	listenoeud l;
	reinserer rr;

	if ( ! u ) return;
	if (u->detruire == flag) return;
	for ( i=U ; i<=W; i++ ) if (u->s[i]==p) break;
	if ( i<=W ) {
		u->detruire = flag;
		if (u->meurtrier)
			for ( i=U ; i<=W; i++ ) if (u->fils[i]) destroy(u->fils[i], p);
		for ( l=u->bfils; l; l = l->next )      destroy(l->item   , p);
		if (u->s[U]==p) return;
		rr = locate(Reinsert,u->s[U]);
		add_x1x2(rr,u,p);
	} else {
		rr = locate(Reinsert,u->s[U]);
		add_decroche(rr,u);
		if (u->pere->detruire == flag)	u->pere		= NULL;
		else							u->bpere	= NULL;
	}
}

void delaunay_tree::recherche( DT_item p)
/* init des structures Star et Reinsert */
{
	DT_item first;
	noeud father;
	int arete;		/* indice sur n1 de l'arete axe-createur */ 
	int a,b,c;		/* indice des trois sommets sur father */
	int a1,b1,c1;	/* indice des trois sommets sur le noeud precedent */
	int j;

	clear_Reinsert(Reinsert); 
	clear_Star();
		arete = (  p->cree->direct  ) ? V : W ;
		first = p->cree->s[V + W - arete ];
		father = p->cree->pere;
		for (j=U; j<=W; j++)
			if (father->s[j] == p->cree->s[V + W - arete ])		a=j ;
			else if (father->s[j] == p->cree->s[arete])			c=j ;
			else								b=j;
	do {
				/* ac est l'arete par laquelle on est fils de father */
				/* on veut tourner autour de a en faisant bouger c vers b */
				/* et que on tourne autour de a dans le sens inverse */
		while ( ( father->voisin[c]->meurtrier == p )
				|| (father->voisin[c]->visite == flag) ) {
			a1 = a; b1 = b; c1 = c;
			for (j=U; j<=W; j++)
				if (father->voisin[c1]->s[j] == father->s[a1])			a=j ;
				else if (father->voisin[c1]->s[j] == father->s[b1])		c=j ;
				else													b=j;
			father = father->voisin[c1] ;
			father->visite = flag ;
			father->meurtrier = NULL;
		}
		father->visite = flag ;
		father->meurtrier = NULL;
		a1 = a; b1 = b; c1 = c;
		for (j=U; j<=W; j++)
				if (father->voisin[c1]->s[j] == father->s[a1])			a=j ;
				else if (father->voisin[c1]->s[j] == father->s[b1])		c=j ;
				else													b=j;
		father->voisin[c1]->special[b] = father;
		if ( father->voisin[c1]->voisin[b]->s[U] == p )
								father->voisin[c1]->voisin[b] = father;
		plusbeaufils(father->fils[c1], father->voisin[c1] );
		destroy(father->fils[c1],p);
		poubelle_noeud(father->fils[c1]);
		father->fils[c1] = NULL;
		init_Star(father,a1,b1,c1);
		a = b1 ;
		b = c1 ;
		c = a1 ;
	} while ( father->s[a] != first );
	init_Star( (noeud) NULL, 0, 0, 0);
}

void delaunay_tree::reinsertion( reinserer n, DT_item p)
{
	listenoeud l;
	noeud u,v,w,ww,w1,w2;
	DT_item x1,x2;
	int i,j,k,a,b,c,a1,b1,c1;
	star s1,s2;

	/* traitement des noeuds decroches */
	for ( l=n->decroches; l; l = l->next )
		if ( l->item->pere ) {
		/* il faut trouver un nouveau beau-pere et tous les voisinages 
                   par cette arete */
			u = l->item->pere;
			for( i=U; i<=W; i++) if (u->fils[i] == l->item) break;
			l->item->bpere = u->special[i];
			l->item->creation[U] = u->special[i];
			l->item->special[U] = u->special[i];
			if ( l->item->voisin[U]->detruire == flag )
								l->item->voisin[U] = u->special[i];
			beaufils(l->item, u->special[i]);
			for( j=U; j<=W; j++)
				if (	(l->item->bpere->s[j] != l->item->s[V] )
					&&	(l->item->bpere->s[j] != l->item->s[W] ) ) break;
			l->item->bpere->voisin[j] = l->item;
		} else {
		/* il faut trouver un nouveau pere */
			u = l->item->bpere;
			for( i=U; i<=W; i++) if (u->s[i] == l->item->s[V]) break;
			for( j=U; j<=W; j++) if (u->s[j] == l->item->s[W]) break;
			i = U+V+W -i -j;
			u= l->item->pere = u->special[i];
			for( i=U; i<=W; i++) if (u->s[i] == l->item->s[V]) break;
			for( j=U; j<=W; j++) if (u->s[j] == l->item->s[W]) break;
			i = U+V+W -i -j;
			u->fils[i] = l->item;
		}
	/* traitement des noeuds detruits */
	if ( ! n->detruit1 ) return;
	x1 =  ( n->detruit1->s[V] == p ) ? n->detruit1->s[W] : n->detruit1->s[V];
	x2 =  ( n->detruit2->s[V] == p ) ? n->detruit2->s[W] : n->detruit2->s[V];
	s1 = loc_Star(x1);
	s2 = loc_Star(x2)->previous ;
	u = s1->triangle;
	/* Cas 1 (triangle x x1 x2 a creer) u n'est pas en conflit avec x */
	if ( ! conflit(u, n->x) ) {
			/* u est le beau pere de x x1 x2 a cree */
			for( i=U; i<=W; i++) if (u->s[i] == x1) break;
			for( j=U; j<=W; j++) if (u->s[j] == x2) break;
			k = U+V+W -i -j;
			u = u->voisin[k] ;
			/* u est le pere */
			for( i=U; i<=W; i++) if (u->s[i] == x1) break;
			for( j=U; j<=W; j++) if (u->s[j] == x2) break;
			i = U+V+W -i -j;
			n->x->cree =ww = creenoeud(u ,i,n->x);
		/* ww est le fils de son pere */
			u->voisin[i] = ww->bpere;		/* voisin a la mort */
		/* voisinage beau-fils beau-pere */
			ww->bpere->voisin[k] = ww;
		/* voisinage avec les "freres" du nouveau */
			i = ( ww->s[V] == x1 ) ? V : W ;
			u = n->detruit2->creation[(n->detruit2->s[V]==p)?V:W] ;
			ww->voisin[i] = ww->creation[i] = u;
			for( j=U; j<=W; j++) if ( u->creation[j] == n->detruit2 ) break;
			u->creation[j] = u->special[j] = ww ;
			if ( u->voisin[j]->detruire == flag ) u->voisin[j] = ww ;
			if ( u->voisin[j]->visite == flag ) u->voisin[j] = ww ;
			u = n->detruit1->creation[(n->detruit1->s[V]==p)?V:W] ;
			ww->voisin[V+W-i] = ww->creation[V+W-i] = u;
			for( j=U; j<=W; j++) if ( u->creation[j] == n->detruit1 ) break;
			u->creation[j] = u->special[j] = ww ;
			if ( u->voisin[j]->detruire == flag ) u->voisin[j] = ww ;
			if ( u->voisin[j]->visite == flag ) u->voisin[j] = ww ;
		/* mise a jour de Star */
			poubelle_noeud(n->detruit1);
			poubelle_noeud(n->detruit2);
			split_Star(s1,s2); s2=s1->next;
			s1->triangle = ww;
			s2->triangle = ww;
			for( i=U; i<=W; i++) if (ww->s[i] == x1)    s1->p = s2->arete = i;
						else	 if (ww->s[i] == n->x ) s1->n = s2->p = i;
						else						   s1->arete = s2->n = i;
			ww->Star[s1->arete] = s1;
			ww->Star[s2->arete] = s2;
	return;
	}
	/* Cas 2  */
	v = u; w1=NULL;
	w = n->detruit1->creation[(n->detruit1->s[V]==p)?V:W] ;
	a = s1->p ;
	c = s1->n ;
	b = s1->arete ;
	do {
	/* on tourne dans le sens inverse */
		while ( conflit( v->voisin[c], n->x ) ) {
			a1 = a; b1 = b; c1 = c;
			for (j=U; j<=W; j++) if ( v->voisin[c1]->s[j] == v->s[a1]) a = j;
						else	 if ( v->voisin[c1]->s[j] == v->s[b1]) c = j;
						else										   b = j;
			v = v->voisin[c1];
			v->meurtrier = n->x;
		}
			v->meurtrier = n->x;
			ww = creenoeud(v,c,n->x);
		/* voisinage beau-fils beau-pere */
			for (j=U; j<=W; j++)
					if (	( ww->bpere->s[j] != ww->s[V] )
						&&	( ww->bpere->s[j] != ww->s[W] ) ) break;
			if ( ww->bpere->visite == flag ){ /* le beau-pere est dans A */
				ww->bpere->voisin[j] = ww;
			} else {
				ww->bpere->special[j] = ww;
				if ( ww->bpere->voisin[j]->detruire == flag )
												ww->bpere->voisin[j] = ww ;
				if ( ww->bpere->voisin[j]->visite == flag )
												ww->bpere->voisin[j] = ww ;
			}
		/* voisinage nouvelle arete */
			for (j=U;j<=W;j++) if((ww->s[j]!=n->x)&&(ww->s[j]!=v->s[a]))break;
			ww->voisin[j] = ww->creation[j] = w ;
			if ( !w1 ) {
			  for (j=U;j<=W;j++) if((w->s[j]!=n->x)&&(w->s[j]!=v->s[a]))break;
			  w1 = w->special[j] = w->creation[j] = ww ;
			  if (w->voisin[j]->visite == flag ) w->voisin[j] = ww ;
			  if (w->voisin[j]->detruire == flag ) w->voisin[j] = ww ;
			} else {
			  for (j=U;j<=W;j++) if((w->s[j]!=n->x)&&(w->s[j]!=v->s[a]))break;
			  w->voisin[j] = w->creation[j] = ww ;
			}
			w = ww;
		/* mise a jour de Star */
			if ( ww->bpere->visite != flag ){/* le beau-pere n'est pas dans A */
				v->Star[c]->triangle = ww;
				ww->Star[U] = v->Star[c];
				ww->Star[U]->arete = U;
				ww->Star[U]->n = (v->s[a] == w->s[V] ) ? V : W ;
				ww->Star[U]->p = V+W-ww->Star[U]->n ;
			}
		j = a ; a = b ; b = c ; c = j ;
	} while ( v->s[a] != x2) ; 
		/* voisinage autour de x x2 */
			n->x->cree = w2 = w;
			ww = n->detruit2->creation[(n->detruit2->s[V]==p)?V:W] ;
			for (j=U; j<=W; j++) if((ww->s[j]!=n->x)&&(ww->s[j]!=v->s[a]))break;
			if (ww->voisin[j]->visite == flag ) ww->voisin[j] = w ;
			if (ww->voisin[j]->detruire == flag ) ww->voisin[j] = w ;
			ww->creation[j] = ww->special[j] = w ;
			for (j=U; j<=W; j++) if((w->s[j]!=n->x)&&(w->s[j]!=v->s[a]))break;
			w->voisin[j] = w->creation[j] = ww ;
	do {
	/* on tourne toujours dans le sens inverse */
		while ( conflit( v->voisin[c], n->x ) ) {
			a1 = a; b1 = b; c1 = c;
			for (j=U; j<=W; j++) if ( v->voisin[c1]->s[j] == v->s[a1]) a = j;
						else	 if ( v->voisin[c1]->s[j] == v->s[b1]) c = j;
						else										   b = j;
			v = v->voisin[c1];
			v->meurtrier = n->x;
		}
			v->meurtrier = n->x;
		j = a ; a = b ; b = c ; c = j ;
	} while ( v->s[a] != x1) ; 
		/* mise a jour de Star */
			split_Star(s1,s2); s2=s1->next;
			s1->triangle = w1;
			s2->triangle = w2;
			poubelle_noeud(n->detruit1);
			poubelle_noeud(n->detruit2);
			for( i=U; i<=W; i++) if (w1->s[i] == x1)    s1->p = i;
						else	 if (w1->s[i] == n->x ) s1->n = i;
						else						    s1->arete = i;
			w1->Star[s1->arete] = s1;
			for( i=U; i<=W; i++) if (w2->s[i] == x2)    s2->n = i;
						else	 if (w2->s[i] == n->x ) s2->p = i;
						else						    s2->arete = i;
			w2->Star[s2->arete] = s2;
}

void delaunay_tree::parcours( reinserer n, DT_item p)
{
	if ( ! n ) return;
	parcours(n->finf,p);
	reinsertion(n,p);
	parcours(n->fsup,p);
}


void delaunay_tree::trace_items(noeud n, delaunay_f2* trace_item)
/* exploration recursive pour le trace des points */
{
  noeud* stack = new noeud[counter+10];
  int top = 0;
  stack[0] = n;
  n->stacked = flag;

  while (top >= 0)
  { n = stack[top--];   //pop
	n->visite = flag;
	for (int i=U; i<=W; i++)
	  if ( n->s[i] && n->s[i]->visite != flag )
            { n->s[i]->visite = flag ;
              trace_item(n->s[i]->x, n->s[i]->y);
             }

	for (i=W; i>=U; i--)
        { noeud v = n->voisin[i];
	  if ( v->stacked != flag )
           { stack[++top] = v;          //push
             v->stacked = flag;
            }
         }

   } // while stack not empty

 delete stack;

}

void delaunay_tree::list_items(noeud n, list<DT_item>& L)
/* exploration recursive pour le trace des points */
{
  noeud* stack = new noeud[counter+10];
  int top = 0;
  stack[0] = n;
  n->stacked = flag;

  while (top >= 0)
  { n = stack[top--];   //pop
	n->visite = flag;
	for (int i=U; i<=W; i++)
	  if ( n->s[i] && n->s[i]->visite != flag )
            { n->s[i]->visite = flag ;
              L.append(n->s[i]);
             }

	for (i=W; i>=U; i--)
        { noeud v = n->voisin[i];
	  if ( v->stacked != flag )
           { stack[++top] = v;          //push
             v->stacked = flag;
            }
         }

   } // while stack not empty

 delete stack;

}

void delaunay_tree::clear_items(noeud n)
{
  noeud* stack = new noeud[counter+10];
  int top = 0;
  stack[0] = n;
  n->stacked = flag;

  while (top >= 0)
  { n = stack[top--];   //pop
	n->visite = flag;
	for (int i=U; i<=W; i++)
	  if ( n->s[i] && n->s[i]->visite != flag )
            { n->s[i]->visite = flag ;
              clear_inf(n->s[i]->i);
             }

	for (i=W; i>=U; i--)
        { noeud v = n->voisin[i];
	  if ( v->stacked != flag )
           { stack[++top] = v;          //push
             v->stacked = flag;
            }
         }

   } // while stack not empty

 delete stack;
}


void delaunay_tree::del_noeud( noeud n, delaunay_f4* trace_segment,int both)
/* exploration recursive de delaunay_tree */
{
  noeud* stack = new noeud[counter+10];
  int top = 0;
  stack[0] = n;
  n->stacked = flag;

  int i;

  while (top >= 0)
  { n = stack[top--];   //pop

	n->visite = flag;

	for (i=U; i<=W; i++)
          if ( both || n->voisin[i]->visite != flag ) 
           { int j = (i==U) ? V : U ; 
             int k = U + V + W -i -j ;
	     if (( n->type == Fini ) || ((i == W) && (n->type==Infini1) ) )
                trace_segment(n->s[j]->x,n->s[j]->y, n->s[k]->x, n->s[k]->y);
	    }

	for (i=W; i>=U; i--)
        { noeud v = n->voisin[i];
	  if ( v->stacked != flag )
           { stack[++top] = v;          //push
             v->stacked = flag;
            }
         }

   } // while stack not empty

 delete stack;

 }


void delaunay_tree::vor( noeud n, delaunay_f6* trace_segment, delaunay_F6* pt_infi, int both)
{

  int i,j;
  coord x,y,mx,my;
  int order[3];

  int top = 0;
  noeud* stack = new noeud[counter+10];
  stack[0] = n;
  n->stacked = flag;

  while (top >= 0)
  { 
    n = stack[top--];   //pop

    n->visite = flag;

        if (n->direct)
         { order[0] = 0;
           order[1] = 1;
           order[2] = 2;
          }
        else 
         { order[0] = 2;
           order[1] = 1;
           order[2] = 0;
          }

	for (j=0; j<3; j++)
        { 
          int i = order[j];

               if (both ||  n->voisin[i]->visite != flag )
		{   int k;
                    if (n->direct)
                       k = (i==2) ? 0 : i+1; 
                    else 
                       k = (i==0) ? 2 : i-1; 

		    coord sx0 = n->s[k]->x;
                    coord sy0 = n->s[k]->y;

			switch (n->type){
			case Fini :
			if (! n->degenere ) {
				switch ( n->voisin[i]->type ){
				case Fini : if ( ! n->voisin[i]->degenere ){
trace_segment(n->cx,n->cy, n->voisin[i]->cx, n->voisin[i]->cy,sx0,sy0); 
                                            break;
				}
				case Infini1  : 
				  pt_infi(n->cx,n->cy, n->voisin[i]->cx, n->voisin[i]->cy,&x,&y);
                                  trace_segment(n->cx, n->cy,x,y,sx0,sy0);
				  break ;
				}
				break;
			}
			case Infini1  :
				if ( n->degenere &&  n->voisin[i]->degenere ) break;
				switch ( n->voisin[i]->type ){
				case Fini :
				if ( ! n->voisin[i]->degenere ) 
                                { pt_infi(n->voisin[i]->cx, 
                                          n->voisin[i]->cy, 
                                          n->cx,n->cy,&x,&y);
                                  trace_segment(x,y,
                                                n->voisin[i]->cx, 
                                                n->voisin[i]->cy,
                                                sx0,sy0);
				  break ;
				 }
				case Infini1  :
				  if (i == W)
                                  { mx = ( n->s[U]->x + n->s[V]->x )/2 ;
				    my = ( n->s[U]->y + n->s[V]->y )/2 ;
				    pt_infi(mx,my, n->cx,n->cy,&x,&y);
				    pt_infi(mx,my, n->voisin[i]->cx, 
                                                   n->voisin[i]->cy,&mx, &my);
				    trace_segment(mx,my, x,y,sx0,sy0);
				   }
				}
				break;

			} //switch

                  } //if

           }  // for

	for (i=W; i>=U; i--)
        { noeud v = n->voisin[i];
	  if ( v->stacked != flag )
           { stack[++top] = v;          //push
             v->stacked = flag;
            }
         }

   } // while stack not empty

 delete stack;

}

DT_item delaunay_tree::neighbor(double x,double y)
/* recherche du plus proche voisin de (x,y) */
{
	DT_POINT requete;
	DT_item reponse;

	flag++;
	if (arbre == nouveau) return NULL;
	requete.x = x; requete.y = y;
	reponse = localise(Insert(arbre,&requete), &requete);
	return  reponse;
}

void delaunay_tree::del(double x, double y)
{ DT_item p = neighbor(x,y);
  if (p==nil || p->x != x || p->y != y) return;
  del_item(p);
 }

void delaunay_tree::del_item( DT_item ppp)
{
	DT_item p;

	if (!ppp) return;

	flag++;
	p = (DT_item) ppp ;
	nouveau = p->cree->pere;	/* pour si on supprime le dernier */
	recherche(p);
	last = nouveau ;
	parcours(Reinsert,p);
        clear_inf(p->i);
        counter--;
	poubelle_point(p);
}

DT_item delaunay_tree::insert( coord x, coord y, void* inf)
/* procedure d'insertion d'un point dans l'arbre */
{
	DT_item p;

	flag++;
	p = alloc_point();
	p->x = x;
	p->y = y;
        p->i = inf;
	p->n = flag;
	if (! creation( Insert(arbre,p), p )) 
        { poubelle_point(p); 
          return neighbor(x,y);
         }
        copy_inf(inf);
        counter++;
	last = nouveau ;
	return p;
}

void delaunay_tree::all_items(list<DT_item>& L)
/* procedure tracant tous les points */
{
	if (arbre == nouveau) return;
	flag++;
	arbre->s[U]->visite = flag;
	arbre->s[V]->visite = flag;
	arbre->s[W]->visite = flag;
	list_items(nouveau, L);
}

void delaunay_tree::trace_triang_edges( delaunay_f4 *seg,int both)
/* procedure de trace de delaunay */
{
	if (arbre == nouveau) return;
	flag++;
	del_noeud(nouveau,seg, both);
}

void delaunay_tree::trace_voronoi_sites(delaunay_f2 *trace_item)
{
	if (arbre == nouveau) return;
	flag++;
	trace_items(nouveau,trace_item);
}

void delaunay_tree::trace_voronoi_edges(delaunay_f6 *trace_seg, delaunay_F6 *pt_infi, int both)
{
	if (arbre == nouveau) return;
	flag++;
	vor(nouveau,trace_seg,pt_infi, both);
}

void delaunay_tree::convex_hull(list<DT_item>& CH)
{ 
 CH.clear();

 if (arbre == nouveau) return;

 for (int j=2;j>=0;j--)
 { noeud v = arbre->voisin[0];

   int i = (j == 0) ? 2 : j-1;

   DT_item start = v->s[i];

   do
   { int k;
     if (v->type == Infini1) CH.append(v->s[i]);
     if (v->direct)
        k = (i == 0) ? 2 : i-1;
     else
        k = (i == 2) ? 0 : i+1;
     noeud w = v->voisin[k];
     for(i=0;w->voisin[i] != v;i++); 
     v = w;
    } while (v->s[i] != start);

  }
}

