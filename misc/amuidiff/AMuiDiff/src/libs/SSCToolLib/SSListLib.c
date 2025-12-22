/********************************************************************
*      Societe                   :
*      Affaire                   :
*      Tache                     :
*
*      Nom du module             :  $RCSfile: SSListLib.c,v $
*      Version du module         :  $Revision: 1.2 $
*      Date de la version        :  $Date: 2003/05/10 10:14:18 $
*
*      Description               :
*
*
*      Auteurs                   : 
*
*      Materiels necessaires     :  
*      Systeme                   :  
*
*      Langage de programmation  :  C ansi (un peu).
*      Date debut programmation  : Thu Aug 08 10:08:28 2002
*
*      Prefixe utilise           : 
*      Taille du code (.o) en KO : 
*
*      References                : 
*
*         PGES proprietary and confidential information
*          Copyright (C) PGES - (All rights reserved)
*
*
*******************************************************************/

/*******************************************************************
 * INCLUDES
*******************************************************************/
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>


#include "SSMisc_protos.h"
#include "SSListLib.h"


/*******************************************************************
 * SIGNATURE DES FONCTIONS
*******************************************************************/


/* Gestion de listes
**--------------------------------
*/
long ss_highlst_AjouteTete(ss_list_t *pm_liste, void *pm_elt);
long ss_highlst_AjouteQueue(ss_list_t *pm_liste, void *pm_elt);
void* ss_highlst_RetireQueue(ss_list_t *pm_liste);
ss_noeud_t* ss_highlst_RetireTete(ss_list_t *pm_liste);
long ss_highlst_RetireElt(ss_list_t *pm_liste,
			    void *pm_elt);
void* ss_highlst_FindFirst(ss_list_t *pm_liste, void *pm_elt_tocmp,
			     unsigned long (*cmpCB)(void*, void*));
long 
ss_highlst_ExecForEachNode(ss_list_t *pm_liste, void *pm_userdata,
			     ss_lst_execaction_t (*execCB)(void*,void*));
long ss_highlst_SortWithCmpFunc(ss_list_t *pm_liste, void *pm_userdata,
				  unsigned long (*cmpCB)(void*,void*,void*));

ss_noeud_t* ss_lst_RetireTete(ss_list_t *pm_liste);
ss_noeud_t* ss_lst_RetireQueue(ss_list_t *pm_liste);
long ss_lst_AjouteQueue(ss_list_t *pm_liste, ss_noeud_t *pm_noeud);
long ss_lst_AjouteTete(ss_list_t *pm_liste, ss_noeud_t *pm_noeud);
void ss_lst_Init(ss_list_t *pm_liste);
ss_noeud_t* ss_lst_AlloueNoeudAvecElt(const void *pm_elt);
long ss_lst_LibereNoeud(ss_noeud_t *pm_noeud);
void ss_lst_VideEtLibereNoeuds(ss_list_t *pm_liste, void (*freeCB)(void*));
long ss_lst_RetireNoeud(ss_list_t *pm_liste,
			  ss_noeud_t *pm_noeud);
static void ss_lst_Test_VideListe(ss_list_t *pm_liste);
static void ss_lst_Test_AfficheListe(ss_list_t *pm_liste);
void ss_lst_DeconnecteNoeud(ss_list_t *pm_liste,
			      ss_noeud_t *pm_noeud);
ss_list_t* ss_lst_DupliqueListe(ss_list_t *pm_liste);
ss_list_t* ss_lst_AjouteListeAListe(ss_list_t *pm_liste_dest,
					ss_list_t *pm_liste_src);
ss_list_t* ss_lst_Concatene(ss_list_t *pm_liste_dest,
				ss_list_t *pm_liste_src);
long ss_lst_SwapNodes(ss_list_t *pm_liste,
			ss_noeud_t *pm_nd1, ss_noeud_t *pm_nd2);
unsigned long ss_lst_GetNbElt(ss_list_t *pm_liste);


/*******************************************************************
 * DEFINITION DES FONCTIONS
*******************************************************************/

/******************************************************************
 * Procedure         : ss_lst_Init
 *
 * Description       : Initialise la liste a NULL
 *
 * Parametre entree  : pm_liste liste allouee.
 *
 * Parametre sortie  : pm_liste : elements mis a NULL/0
 *
 * Valeur retournee  : -
 *
 * Date Fonction     : Mon Aug 12 11:16:50 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
void ss_lst_Init(ss_list_t *pm_liste)
{
  if(pm_liste == NULL) return;

  pm_liste->tete  = NULL;
  pm_liste->queue = NULL;
}

/******************************************************************
 * Procedure         : ss_lst_AjouteTete
 *
 * Description       : Ajoute un noeud en tete de liste
 *
 * Parametre entree  : pm_liste : liste allouee
 *                     ss_noeud_t : noeud alloue a ajouter
 *
 * Parametre sortie  : pm_liste : element ajoute...
 *
 * Valeur retournee  : -1 : erreur arguments, 0 : succes
 *
 * Date Fonction     : Mon Aug 12 11:22:01 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
long ss_lst_AjouteTete(ss_list_t *pm_liste, ss_noeud_t *pm_noeud)
{
  ss_noeud_t *noeud_tmp = NULL;

  if((pm_liste == NULL)||(pm_noeud == NULL)) return -1;
  
  if((pm_liste->queue) == NULL) pm_liste->queue = pm_noeud;
  noeud_tmp = pm_liste->tete;
  pm_liste->tete = pm_noeud;
  pm_noeud->precedent = NULL;
  pm_noeud->suivant = noeud_tmp;
  if(noeud_tmp != NULL) noeud_tmp->precedent = pm_noeud;

  return 0;
}

/******************************************************************
 * Procedure         : ss_highlst_AjouteTete
 *
 * Description       : Ajoute un elt en tete de liste
 *
 * Parametre entree  : pm_liste : liste allouee
 *                     void* : elt a ajouter
 *
 * Parametre sortie  : pm_liste : element ajoute...
 *
 * Valeur retournee  : -1 : erreur arguments, 0 : succes
 *
 * Date Fonction     : Mon Aug 12 11:22:01 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
long ss_highlst_AjouteTete(ss_list_t *pm_liste, void *pm_elt)
{
  ss_noeud_t *noeud_tmp = NULL;
  
  if(pm_liste == NULL) return -1;
  
  noeud_tmp = ss_lst_AlloueNoeudAvecElt(pm_elt);
  return ss_lst_AjouteTete(pm_liste, noeud_tmp);
}


/******************************************************************
 * Procedure         : ss_lst_AjouteQueue
 *
 * Description       : Ajoute un noeud en queue de liste
 *
 * Parametre entree  : pm_liste : liste allouee
 *                     ss_noeud_t : noeud alloue a ajouter
 *
 * Parametre sortie  : pm_liste : element ajoute...
 *
 * Valeur retournee  : -1 : erreur arguments, 0 : succes
 *
 * Date Fonction     : Mon Aug 12 11:22:01 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
long ss_lst_AjouteQueue(ss_list_t *pm_liste, ss_noeud_t *pm_noeud)
{
  ss_noeud_t *noeud_tmp = NULL;

  if((pm_liste == NULL)||(pm_noeud == NULL)) return -1;
  
  if((pm_liste->tete) == NULL) pm_liste->tete = pm_noeud;
  noeud_tmp = pm_liste->queue;
  pm_liste->queue = pm_noeud;
  pm_noeud->precedent = noeud_tmp;
  pm_noeud->suivant = NULL;
  if(noeud_tmp != NULL) noeud_tmp->suivant = pm_noeud;

  return 0;
}

/******************************************************************
 * Procedure         : ss_lst_AjouteQueue
 *
 * Description       : Ajoute un elt en queue de liste
 *
 * Parametre entree  : pm_liste : liste allouee
 *                     void* : elt alloue a ajouter
 *
 * Parametre sortie  : pm_liste : element ajoute...
 *
 * Valeur retournee  : -1 : erreur arguments, 0 : succes
 *
 * Date Fonction     : Mon Aug 12 11:22:01 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
long ss_highlst_AjouteQueue(ss_list_t *pm_liste, void *pm_elt)
{
  ss_noeud_t *noeud_tmp = NULL;

  if(pm_liste == NULL) return -1;
  
  noeud_tmp = ss_lst_AlloueNoeudAvecElt(pm_elt);

  return ss_lst_AjouteQueue(pm_liste, noeud_tmp);
}

/******************************************************************
 * Procedure         : ss_lst_RetireQueue
 *
 * Description       : Retire le noeud en queue de liste
 *
 * Parametre entree  : pm_liste : liste allouee
 *
 * Parametre sortie  : pm_liste : sans element ajoute...
 *
 * Valeur retournee  : NULL : erreur arguments, noeud sinon...
 *
 * Date Fonction     : Mon Aug 12 11:26:22 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
ss_noeud_t* ss_lst_RetireQueue(ss_list_t *pm_liste)
{
  ss_noeud_t *noeud_tmp = NULL;
  
  if((pm_liste == NULL)||((pm_liste->queue) == NULL)) return NULL;
  
  noeud_tmp = pm_liste->queue;
  pm_liste->queue = (pm_liste->queue)->precedent;
  if((pm_liste->queue) != NULL) (pm_liste->queue)->suivant = NULL;
  if((pm_liste->tete) == noeud_tmp) pm_liste->tete = NULL;
  
  return noeud_tmp;
}

/******************************************************************
 * Procedure         : ss_highlst_RetireQueue
 *
 * Description       : Retire le elt en queue de liste
 *
 * Parametre entree  : pm_liste : liste allouee
 *
 * Parametre sortie  : pm_liste : sans element ajoute...
 *
 * Valeur retournee  : NULL : erreur arguments, elt sinon...
 *
 * Date Fonction     : Mon Aug 12 11:26:22 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
void* ss_highlst_RetireQueue(ss_list_t *pm_liste)
{
  ss_noeud_t *noeud_tmp = NULL;
  void *ret_elt = NULL;
  
  noeud_tmp = ss_lst_RetireQueue(pm_liste);
  if(noeud_tmp == NULL) return NULL;
  ret_elt = SS_LST_ND_GET_CONTENU(noeud_tmp);
  ss_lst_LibereNoeud(noeud_tmp);

  return ret_elt;
}

/******************************************************************
 * Procedure         : ss_lst_RetireTete
 *
 * Description       : Retire le noeud en tete de liste
 *
 * Parametre entree  : pm_liste : liste allouee
 *
 * Parametre sortie  : pm_liste : sans element ajoute...
 *
 * Valeur retournee  : NULL : erreur arguments, noeud sinon...
 *
 * Date Fonction     : Mon Aug 12 11:26:22 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
ss_noeud_t* ss_lst_RetireTete(ss_list_t *pm_liste)
{
  ss_noeud_t *noeud_tmp = NULL;
  
  if((pm_liste == NULL)||((pm_liste->tete) == NULL)) return NULL;
  
  noeud_tmp = pm_liste->tete;
  pm_liste->tete = (pm_liste->tete)->suivant;
  if((pm_liste->tete) != NULL) (pm_liste->tete)->precedent = NULL;
  if((pm_liste->queue) == noeud_tmp) pm_liste->queue = NULL;

  return noeud_tmp;
}

/******************************************************************
 * Procedure         : ss_highlst_RetireTete
 *
 * Description       : Retire le elt en tete de liste
 *
 * Parametre entree  : pm_liste : liste allouee
 *
 * Parametre sortie  : pm_liste : sans element ajoute...
 *
 * Valeur retournee  : NULL : erreur arguments, noeud sinon...
 *
 * Date Fonction     : Mon Aug 12 11:26:22 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
ss_noeud_t* ss_highlst_RetireTete(ss_list_t *pm_liste)
{
  ss_noeud_t *noeud_tmp = NULL;
  void *ret_elt = NULL;
  
  noeud_tmp = ss_lst_RetireTete(pm_liste);
  if(noeud_tmp == NULL) return NULL;
  ret_elt = SS_LST_ND_GET_CONTENU(noeud_tmp);
  ss_lst_LibereNoeud(noeud_tmp);

  return ret_elt;
}

/******************************************************************
 * Procedure         : ss_lst_RetireNoeud
 *
 * Description       : Retire le noeud passe en parametre de la liste
 *                     passee en parametre. ATTENTION SEUL LA PREMIERE
 *                     OCCURENCE TROUVE EST RETIREE/
 *
 * Parametre entree  : meme chose que sortie.
 *
 * Parametre sortie  : ss_list_t *pm_liste : liste de travail.
 *                     ss_noeud_t *pm_noeud : noeud a retirer
 *
 * Valeur retournee  : -1 si erreur (mauvais parametres ou pas trouve
 *                     noeud dans liste), 0 sinon.
 *
 * Date Fonction     : Fri Nov 29 12:52:38 2002

 * Auteur            : SS
 *
 ******************************************************************/
long ss_lst_RetireNoeud(ss_list_t *pm_liste,
			  ss_noeud_t *pm_noeud)
{
  unsigned long noeud_trouve = FALSE;
  ss_noeud_t *noeud_tmp = NULL;
  
  /*--------------------------------
  ** Test d'integrite des parametres
  **--------------------------------
  */
  if((pm_liste == NULL)||((pm_liste->tete) == NULL)
     ||(pm_noeud == NULL))
    return -1;
  
  /*--------------------------------
  ** Test de coherence : Le noeud appartient-il vraiment a la liste ?
  **--------------------------------
  */
  noeud_tmp = SS_LST_LST_GET_TETE(pm_liste);
  while((noeud_tmp != NULL)&&(noeud_trouve == FALSE))
    {
      if(noeud_tmp == pm_noeud)
	noeud_trouve = TRUE;
      noeud_tmp = SS_LST_ND_GET_SUIVANT(noeud_tmp);
    }
  if(noeud_trouve == FALSE)	 return -1;

  /*--------------------------------
  ** Deconnexion du noeud dans la liste
  **--------------------------------
  */
  ss_lst_DeconnecteNoeud(pm_liste, pm_noeud);

  return 0;
}

/******************************************************************
 * Procedure         : ss_highlst_RetireElt
 *
 * Description       : Retire le elt passe en parametre de la liste
 *                     passee en parametre. ATTENTION SEUL LA PREMIERE
 *                     OCCURENCE TROUVE EST RETIREE/
 *
 * Parametre entree  : meme chose que sortie.
 *
 * Parametre sortie  : ss_list_t *pm_liste : liste de travail.
 *                     void *pm_elt : noeud a retirer
 *
 * Valeur retournee  : -1 si erreur (mauvais parametres ou pas trouve
 *                     noeud dans liste), 0 sinon.
 *
 * Date Fonction     : Fri Nov 29 12:52:38 2002

 * Auteur            : SS
 *
 ******************************************************************/
long ss_highlst_RetireElt(ss_list_t *pm_liste,
			    void *pm_elt)
{
  unsigned long noeud_trouve = FALSE;
  ss_noeud_t *noeud_tmp = NULL;
  
  /*--------------------------------
  ** Test d'integrite des parametres
  **--------------------------------
  */
  if((pm_liste == NULL)||((pm_liste->tete) == NULL)
     ||(pm_elt == NULL))
    return -1;
  
  /*--------------------------------
  ** Test de coherence : Le noeud appartient-il vraiment a la liste ?
  **--------------------------------
  */
  noeud_tmp = SS_LST_LST_GET_TETE(pm_liste);
  while((noeud_tmp != NULL)&&(noeud_trouve == FALSE))
    {
      if(SS_LST_ND_GET_CONTENU(noeud_tmp) == pm_elt)
	{
	  noeud_trouve = TRUE;
	  break;
	}
      noeud_tmp = SS_LST_ND_GET_SUIVANT(noeud_tmp);
    }
  if(noeud_trouve == FALSE)	 return -1;

  /*--------------------------------
  ** Deconnexion du noeud dans la liste
  **--------------------------------
  */
  ss_lst_DeconnecteNoeud(pm_liste, noeud_tmp);

  return 0;
}

/******************************************************************
 * Procedure         : ss_lst_AlloueNoeudAvecElt
 *
 * Description       : Cree un noeud et en associe un element
 *
 * Parametre entree  : pm_elt : element a associer : peut etre n'importe quoi
 *
 * Parametre sortie  : -
 *
 * Valeur retournee  : ss_noeud_t* : noeud alloue qu'il faudra liberer
 *
 * Date Fonction     : Mon Aug 12 13:26:05 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
ss_noeud_t* ss_lst_AlloueNoeudAvecElt(const void *pm_elt)
{
  ss_noeud_t *noeud_tmp = NULL;

  noeud_tmp = malloc(sizeof(ss_noeud_t));
  if(noeud_tmp == NULL) return NULL;
  
  noeud_tmp->precedent = NULL;
  noeud_tmp->suivant   = NULL;;
  noeud_tmp->element   = (void*)pm_elt;
  
  return noeud_tmp;
}

/******************************************************************
 * Procedure         : ss_lst_LibereNoeud
 *
 * Description       : Libere un noeud, ne fait rien avec son element
 *
 * Parametre entree  : pm_noeud : noeud a liberer
 *
 * Parametre sortie  : pm_noeud : libere
 *
 * Valeur retournee  : -1 : erreur de parametre, 0 : OK
 *
 * Date Fonction     : Mon Aug 12 13:27:56 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
long ss_lst_LibereNoeud(ss_noeud_t *pm_noeud)
{
  if(pm_noeud == NULL) return -1;

  free(pm_noeud);
  return 0;
}

/******************************************************************
 * Procedure         : ss_lst_VideEtLibereNoeuds
 *
 * Description       : Fonction qui vide la liste et libere tous les 
 *                     noeuds de la liste.
 *                     ATTENTION, LES CONTENUS NE SONT PAS TOUCHES.
 *                     LEUR EVENTUELLE LIBERATION N'EST PAS EFFECTUEE.
 *
 * Parametre entree  : pm_liste : liste a balayer.
 *
 * Parametre sortie  : -
 *
 * Valeur retournee  : -
 *
 * Date Fonction     : Mon Aug 12 15:21:26 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
void ss_lst_VideEtLibereNoeuds(ss_list_t *pm_liste, void (*freeCB)(void*))
{
  ss_noeud_t *noeud_tmp = NULL;
  noeud_tmp = ss_lst_RetireTete(pm_liste);
  while(noeud_tmp != NULL)
    {
	  if(freeCB != NULL)
	  {
		freeCB(SS_LST_ND_GET_CONTENU(noeud_tmp));
	  }
      ss_lst_LibereNoeud(noeud_tmp);
      noeud_tmp = ss_lst_RetireTete(pm_liste);
    }
  ss_lst_Init(pm_liste);
}

/******************************************************************
 * Procedure         : ss_lst_DeconnecteNoeud
 *
 * Description       : 
 *
 * Parametre entree  : 
 *
 * Parametre sortie  : 
 *
 * Valeur retournee  : 
 *
 * Date Fonction     : Thu Dec 19 19:09:53 2002
 *
 * Auteur            : SS
 *
 ******************************************************************/
void ss_lst_DeconnecteNoeud(ss_list_t *pm_liste,
			      ss_noeud_t *pm_noeud)
{
  if((pm_liste == NULL)||(pm_noeud == NULL))return;

  /*--------------------------------
  ** Deconnexion du noeud dans la liste
  **--------------------------------
  */
  /* Reconnexion des noeuds suivants et precedents
  **--------------------------------
  */
  if(((pm_noeud->precedent) != NULL)
     &&(((pm_noeud->precedent)->suivant) != NULL))
    {
      (pm_noeud->precedent)->suivant = pm_noeud->suivant;
    }
  if(((pm_noeud->suivant) != NULL)
     &&(((pm_noeud->suivant)->precedent) != NULL))
    {
      (pm_noeud->suivant)->precedent = pm_noeud->precedent;
    }

  /* Deconnexion du noeud dans la liste
  **--------------------------------
  */
  if((pm_liste->tete) == pm_noeud)
    {
      pm_liste->tete = pm_noeud->suivant;
    }
  if((pm_liste->queue) == pm_noeud)
    {
      pm_liste->queue = pm_noeud->precedent;
    }

  /* Deconnexion au niveau noeud
  **--------------------------------
  */
  pm_noeud->suivant   = NULL;
  pm_noeud->precedent = NULL;
}

/******************************************************************
 * Procedure         : ss_highlst_FindFirst
 *
 * Description       : Cherche et renvoie le premier elt, tel que la condition
 *                     verifiee est definie dans le callback passe en 
 *                     parametre :
 *                     unsigned long (*cmpCB)(void*, void*)
 *                     Pour chaque noeud de la liste, ce CB est appele.
 *                     Le premier argument sera l'elt courant, le second sera
 *                     l'elt de comparaison passe en parametre.
 *                     Si la condition est verifiee, le CB renvoie TRUE, FALSE
 *                     sinon.
 *
 * Parametre entree  : pm_liste, pm_elt_tocmp, cmpCB
 *
 * Parametre sortie  : -
 *
 * Valeur retournee  : Elt trouve ou NULL;
 *
 * Date Fonction     : Thu Dec 19 17:58:53 2002
 *
 * Auteur            : SS
 *
 ******************************************************************/
void* ss_highlst_FindFirst(ss_list_t *pm_liste, void *pm_elt_tocmp,
			     unsigned long (*cmpCB)(void*, void*))
{
  ss_noeud_t *noeud_tmp = NULL;

  if((cmpCB == NULL)||(pm_liste == NULL)) return NULL;

  noeud_tmp = SS_LST_LST_GET_TETE(pm_liste);
  while(noeud_tmp != NULL)
    {
      void *contenu = SS_LST_ND_GET_CONTENU(noeud_tmp);
      if(cmpCB(contenu, pm_elt_tocmp) == TRUE)
	{
	  return contenu;
	}
      noeud_tmp = SS_LST_ND_GET_SUIVANT(noeud_tmp);
    }
  return NULL;
}

/******************************************************************
 * Procedure         : ss_highlst_ExecForEachNode
 *
 * Description       : NE PAS FAIRE D'ACTION SUR LA LISTE EN COURS.
 *               ss_lst_execaction_t (*execCB)(void*, void*) :
 *               entree : elt en cours, user_data passe en parametre
 *               si return SYR7_LST_NOTHING : ne fait rien,
 *                         SYR7_LST_STOP : arrete le balayage,
 *                         SYR7_LST_REMOVENODE : retire le noeud courant.
 *
 * Parametre entree  : 
 *
 * Parametre sortie  : 
 *
 * Valeur retournee  : 
 *
 * Date Fonction     : Thu Dec 19 18:32:26 2002
 *
 * Auteur            : SS
 *
 ******************************************************************/
long ss_highlst_ExecForEachNode(ss_list_t *pm_liste, void *pm_userdata,
				  ss_lst_execaction_t (*execCB)(void*,void*))
{
  ss_noeud_t *noeud_tmp = NULL;
  ss_noeud_t *noeud_tmp2 = NULL;
  
  if((execCB == NULL)||(pm_liste == NULL)) return -1;
  
  noeud_tmp = SS_LST_LST_GET_TETE(pm_liste);
  while(noeud_tmp != NULL)
    {
      ss_lst_execaction_t ret_exec;
      
      noeud_tmp2 = noeud_tmp;
      noeud_tmp = SS_LST_ND_GET_SUIVANT(noeud_tmp);
      ret_exec = execCB(SS_LST_ND_GET_CONTENU(noeud_tmp2), pm_userdata);
	  if(ret_exec == SS_LST_STOP)
	{
	  break;
	}
	  else if(ret_exec == SS_LST_REMOVENODE)
	{
	  ss_lst_DeconnecteNoeud(pm_liste, noeud_tmp2);
	  ss_lst_LibereNoeud(noeud_tmp2);
	}
    }
  return 0;
}

/******************************************************************
 * Procedure         : ss_highlst_SortWithCmpFunc
 *
 * Description       : 
 *
 * Parametre entree  : 
 *
 * Parametre sortie  : 
 *
 * Valeur retournee  : 
 *
 * Date Fonction     : Thu Jan 09 17:05:19 2003
 *
 * Auteur            : SS
 *
 ******************************************************************/
long ss_highlst_SortWithCmpFunc(ss_list_t *pm_liste, void *pm_userdata,
				  unsigned long (*cmpCB)(void*,void*,void*))
{
  ss_noeud_t *noeud_curr = NULL;
  ss_noeud_t *noeud_suiv = NULL;
  unsigned long swap_performed;
  
  /* Test des parametres
  **--------------------------------
  */
  if((cmpCB == NULL)||(pm_liste == NULL)) return -1;
  
  /* Tri a bulles
  **--------------------------------
  */
  do
    {
      swap_performed = FALSE;
	  noeud_curr = SS_LST_LST_GET_TETE(pm_liste);
      if(noeud_curr != NULL) 
	{
	  noeud_suiv = SS_LST_ND_GET_SUIVANT(noeud_curr);
	}
      while((noeud_curr != NULL)&&(noeud_suiv != NULL))
	{
	  unsigned long ret_cmp;
      
	  ret_cmp = cmpCB(SS_LST_ND_GET_CONTENU(noeud_curr),
			  SS_LST_ND_GET_CONTENU(noeud_suiv),
			  pm_userdata);
	  if(ret_cmp == TRUE)
	    {
	      if(ss_lst_SwapNodes(pm_liste, noeud_curr, noeud_suiv) == 0)
		{
		  swap_performed = TRUE;
		}
	      else
		{
		  noeud_curr = noeud_suiv;
		}
	    }
	  else
	    {
	      noeud_curr = noeud_suiv;
	    }
	  noeud_suiv = SS_LST_ND_GET_SUIVANT(noeud_curr);
	}
    }while(swap_performed == TRUE);

  return 0;
}

/******************************************************************
 * Procedure         : ss_lst_SwapNodes
 *
 * Description       : 
 *
 * Parametre entree  : 
 *
 * Parametre sortie  : 
 *
 * Valeur retournee  : 
 *
 * Date Fonction     : Thu Jan 09 17:05:33 2003
 *
 * Auteur            : SS
 *
 ******************************************************************/
long ss_lst_SwapNodes(ss_list_t *pm_liste,
			ss_noeud_t *pm_nd1, ss_noeud_t *pm_nd2)
{
  ss_noeud_t *new_nd1_prec = NULL;
  ss_noeud_t *new_nd1_suiv = NULL;
  ss_noeud_t *new_nd2_prec = NULL;
  ss_noeud_t *new_nd2_suiv = NULL;

  if((pm_liste == NULL)||(pm_nd1 == NULL)||(pm_nd2 == NULL)) return -1;

  /* Maj des noeuds impliques
  **--------------------------------
  */
  if((pm_nd1->suivant) != pm_nd2)
    new_nd2_suiv = pm_nd1->suivant;
  else
    new_nd2_suiv = pm_nd1;
  
  if((pm_nd1->precedent) != pm_nd2)
    new_nd2_prec = pm_nd1->precedent;
  else
    new_nd2_prec = pm_nd1;

  if((pm_nd2->suivant) != pm_nd1)
    new_nd1_suiv = pm_nd2->suivant;
  else
    new_nd1_suiv = pm_nd2;
  
  if((pm_nd2->precedent) != pm_nd1)
    new_nd1_prec = pm_nd2->precedent;
  else
    new_nd1_prec = pm_nd2;

  pm_nd1->suivant   = new_nd1_suiv;
  pm_nd1->precedent = new_nd1_prec;
  pm_nd2->suivant   = new_nd2_suiv;
  pm_nd2->precedent = new_nd2_prec;

  /* Maj des noeuds connectes aux noeuds impliques
  **--------------------------------
  */
  if(new_nd1_suiv != NULL) new_nd1_suiv->precedent = pm_nd1;
  if(new_nd1_prec != NULL) new_nd1_prec->suivant   = pm_nd1;
  if(new_nd2_suiv != NULL) new_nd2_suiv->precedent = pm_nd2;
  if(new_nd2_prec != NULL) new_nd2_prec->suivant   = pm_nd2;

  /* Maj de la liste
  **--------------------------------
  */
  if((pm_liste->tete) == pm_nd1)
    pm_liste->tete = pm_nd2;
  else if((pm_liste->tete) == pm_nd2)
    pm_liste->tete = pm_nd1;
  if((pm_liste->queue) == pm_nd1)
    pm_liste->queue = pm_nd2;
  else if((pm_liste->queue) == pm_nd2)
    pm_liste->queue = pm_nd1;

  return 0;
}

/******************************************************************
 * Procedure         : ss_lst_DupliqueListe
 *
 * Description       : Construit une liste contenant les memes elements 
 *                     (les noeuds sont des nouveaux noeuds).
 *
 * Parametre entree  : pm_liste : liste a dupliquer.
 *
 * Parametre sortie  : - 
 *
 * Valeur retournee  : ss_list_t* nouvelle liste, NULL si erreur
 *
 * Date Fonction     : Mon Aug 12 15:21:26 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
ss_list_t* ss_lst_DupliqueListe(ss_list_t *pm_liste)
{
  ss_noeud_t *noeud_tmp = NULL;
  ss_noeud_t *noeud_newlst = NULL;
  ss_list_t *lst_tmp = NULL;
  
  if(pm_liste == NULL)return NULL;

  lst_tmp = malloc(sizeof(ss_list_t));
  if(lst_tmp == NULL)return NULL;

  ss_lst_Init(lst_tmp);

  noeud_tmp = SS_LST_LST_GET_TETE(pm_liste);
  while(noeud_tmp != NULL)
    {
      noeud_newlst = 
	ss_lst_AlloueNoeudAvecElt(SS_LST_ND_GET_CONTENU(noeud_tmp));
      ss_lst_AjouteQueue(lst_tmp, noeud_newlst);
      noeud_tmp = SS_LST_ND_GET_SUIVANT(noeud_tmp);
    }
  return lst_tmp;
}

/******************************************************************
 * Procedure         : ss_lst_AjouteListeAListe
 *
 * Description       : Ajoute les elements de la liste pm_liste_src a
 *                     la liste pm_liste_dest, sans pour autant oter
 *                     ces elements de la liste pm_liste_src.
 *
 * Parametre entree  : pm_liste_dest : liste destination.
 *                     ss_list_t *pm_liste_src : liste source.
 *
 * Parametre sortie  : - 
 *
 * Valeur retournee  : pm_liste_dest, NULL si erreur.
 *
 * Date Fonction     : Mon Aug 12 15:21:26 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
ss_list_t* ss_lst_AjouteListeAListe(ss_list_t *pm_liste_dest,
					ss_list_t *pm_liste_src)
{
  ss_noeud_t *noeud_tmp = NULL;
  ss_list_t *lst_tmp = NULL;
  
  if((pm_liste_dest == NULL)||(pm_liste_src == NULL)) return pm_liste_dest;

  lst_tmp = ss_lst_DupliqueListe(pm_liste_src);
  noeud_tmp = ss_lst_RetireTete(lst_tmp);
  while(noeud_tmp != NULL)
    {
      ss_lst_AjouteQueue(pm_liste_dest, noeud_tmp);
      noeud_tmp = ss_lst_RetireTete(lst_tmp);
    }

	return pm_liste_dest;
}
				
/******************************************************************
 * Procedure         : ss_lst_Concatene
 *
 * Description       : Meme chose que ss_lst_AjouteListeAListe, sauf que
 *                     la liste pm_liste_src est videe.
 *
 * Parametre entree  : pm_liste_dest : liste destination.
 *                     ss_list_t *pm_liste_src : liste source.
 *
 * Parametre sortie  : - 
 *
 * Valeur retournee  : pm_liste_dest, NULL si erreur.
 *
 * Date Fonction     : Mon Aug 12 15:21:26 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
ss_list_t* ss_lst_Concatene(ss_list_t *pm_liste_dest,
				ss_list_t *pm_liste_src)
{
  ss_noeud_t *noeud_tmp = NULL;
  
  if((pm_liste_dest == NULL)||(pm_liste_src == NULL)) return pm_liste_dest;

  noeud_tmp = ss_lst_RetireTete(pm_liste_src);
  while(noeud_tmp != NULL)
    {
      ss_lst_AjouteQueue(pm_liste_dest, noeud_tmp);
      noeud_tmp = ss_lst_RetireTete(pm_liste_src);
    }

	return pm_liste_dest;
}

/******************************************************************
 * Procedure         :
 *
 * Description       :
 *
 * Parametre entree  :
 *
 * Parametre sortie  : -
 *
 * Valeur retournee  : -
 *
 * Date Fonction     : Sun Apr 20 15:21:26 2002

 * Auteur            : SS
 *
 ******************************************************************/
unsigned long ss_lst_GetNbElt(ss_list_t *pm_liste)
{
  unsigned long nb_elt = 0;
  ss_noeud_t *noeud_tmp = NULL;

  if(pm_liste == NULL) return 0UL;

  noeud_tmp = SS_LST_LST_GET_TETE(pm_liste);
  while(noeud_tmp != NULL)
    {
	  nb_elt++;
	  noeud_tmp = SS_LST_ND_GET_SUIVANT(noeud_tmp);
    }

  return nb_elt;
}


				
/******************************************************************
 * Procedure         : ss_lst_Test_AfficheListe
 *
 * Description       : Fonction inutilisable qui renseigne simplement sur la
 *                     maniere de balayer une liste.
 *
 * Parametre entree  : pm_liste : liste a balayer.
 *
 * Parametre sortie  : - 
 *
 * Valeur retournee  : - 
 *
 * Date Fonction     : Mon Aug 12 15:21:26 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
static void ss_lst_Test_AfficheListe(ss_list_t *pm_liste)
{
  ss_noeud_t *noeud_tmp = NULL;
  noeud_tmp = SS_LST_LST_GET_TETE(pm_liste);
  while(noeud_tmp != NULL)
    {
      printf("elt=0x%lx\n", (long)SS_LST_ND_GET_CONTENU(noeud_tmp));
      noeud_tmp = SS_LST_ND_GET_SUIVANT(noeud_tmp);
    }
}
				
/******************************************************************
 * Procedure         : ss_lst_Test_VideListe
 *
 * Description       : Fonction inutilisable qui renseigne simplement sur la
 *                     maniere de balayer une liste en otant ses elements.
 *
 * Parametre entree  : pm_liste : liste a balayer.
 *
 * Parametre sortie  : -
 *
 * Valeur retournee  : -
 *
 * Date Fonction     : Mon Aug 12 15:21:26 2002,   

 * Auteur            : SS
 *
 ******************************************************************/
static void ss_lst_Test_VideListe(ss_list_t *pm_liste)
{
  ss_noeud_t *noeud_tmp = NULL;
  noeud_tmp = ss_lst_RetireTete(pm_liste);
  while(noeud_tmp != NULL)
    {
      //printf("elt=0x%lx\n", (long)SS_LST_ND_GET_CONTENU(noeud_tmp));
      noeud_tmp = ss_lst_RetireTete(pm_liste);
    }
}
				
