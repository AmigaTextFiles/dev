#ifndef SSLISTLIB_PROTOS_H
#define SSLISTLIB_PROTOS_H
/********************************************************************
*      Societe                   :
*      Affaire                   :
*      Tache                     :
*
*      Nom du module             :  $RCSfile: SSListLib_protos.h,v $
*      Version du module         :  $Revision: 1.2 $
*      Date de la version        :  $Date: 2003/05/10 10:15:23 $
*
*      Description               :
*
*
*      Auteurs                   : 
*
*      Materiels necessaires     :  
*      Systeme                   :  
*
*      Langage de programmation  :  C ansi.
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
#include "SSListLib.h"

/*******************************************************************
 * DEFINES
*******************************************************************/

/* MACRO d'acces aux elements des objets ss_list_t* et ss_noeud_t*
**--------------------------------
*/
/* Definies dans SSListLib.h
   #define SS_LST_ND_SET_CONTENU(X, Y) ((X)->element = Y)
   #define SS_LST_ND_GET_CONTENU(X)    ((X)->element)
   #define SS_LST_ND_GET_SUIVANT(X)    ((X)->suivant)
   #define SS_LST_ND_GET_PRECEDENT(X)  ((X)->precedent)
   #define SS_LST_LST_GET_TETE(X)      ((X)->tete)
   #define SS_LST_LST_GET_QUEUE(X)     ((X)->queue)
   #define SS_LST_LST_EST_ELLE_VIDE(X) ((((X)->tete)==NULL)?TRUE:FALSE)
*/

/*******************************************************************
 * SIGNATURES DES FONCTIONS EXPORTEES
*******************************************************************/


/* Gestion de listes
**--------------------------------
*/
#ifdef __cplusplus
extern "C"
{
#endif

extern long ss_highlst_AjouteTete(ss_list_t *pm_liste, void *pm_elt);
extern long ss_highlst_AjouteQueue(ss_list_t *pm_liste, void *pm_elt);
extern void* ss_highlst_RetireQueue(ss_list_t *pm_liste);
extern ss_noeud_t* ss_highlst_RetireTete(ss_list_t *pm_liste);
extern long ss_highlst_RetireElt(ss_list_t *pm_liste,
				   void *pm_elt);
extern void* ss_highlst_FindFirst(ss_list_t *pm_liste, void *pm_elt_tocmp,
				    unsigned long (*cmpCB)(void*, void*));
long ss_highlst_ExecForEachNode(ss_list_t *pm_liste, void *pm_userdata,
				  ss_lst_execaction_t (*execCB)(void*,void*));
extern 
long ss_highlst_SortWithCmpFunc(ss_list_t *pm_liste,
				  void *pm_userdata,
				  unsigned long (*cmpCB)(void*,void*,void*));

extern ss_noeud_t* ss_lst_RetireTete(ss_list_t *pm_liste);
extern ss_noeud_t* ss_lst_RetireQueue(ss_list_t *pm_liste);
extern long ss_lst_AjouteQueue(ss_list_t *pm_liste,
				 ss_noeud_t *pm_noeud);
extern long ss_lst_AjouteTete(ss_list_t *pm_liste, ss_noeud_t *pm_noeud);
extern void ss_lst_Init(ss_list_t *pm_liste);
extern ss_noeud_t* ss_lst_AlloueNoeudAvecElt(const void *pm_elt);
extern long ss_lst_LibereNoeud(ss_noeud_t *pm_noeud);
extern void ss_lst_VideEtLibereNoeuds(ss_list_t *pm_liste, void (*freeCB)(void*));
extern long ss_lst_RetireNoeud(ss_list_t *pm_liste,
				 ss_noeud_t *pm_noeud);
extern ss_list_t* ss_lst_DupliqueListe(ss_list_t *pm_liste);
extern ss_list_t* ss_lst_AjouteListeAListe(ss_list_t *pm_liste_dest,
					ss_list_t *pm_liste_src);
extern ss_list_t* ss_lst_Concatene(ss_list_t *pm_liste_dest,
				ss_list_t *pm_liste_src);
extern void ss_lst_DeconnecteNoeud(ss_list_t *pm_liste,
				     ss_noeud_t *pm_noeud);
extern long ss_lst_SwapNodes(ss_list_t *pm_liste,
			       ss_noeud_t *pm_nd1, ss_noeud_t *pm_nd2);
extern unsigned long ss_lst_GetNbElt(ss_list_t *pm_liste);

#ifdef __cplusplus
}
#endif

#endif   // SSLISTLIB_PROTOS_H
