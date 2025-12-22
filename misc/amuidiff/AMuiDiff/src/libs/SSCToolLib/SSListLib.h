#ifndef SSLISTLIB_H
#define SSLISTLIB_H
/********************************************************************
*      Societe                   :
*      Affaire                   :
*      Tache                     :
*
*      Nom du module             :  $RCSfile: SSListLib.h,v $
*      Version du module         :  $Revision: 1.1 $
*      Date de la version        :  $Date: 2003/05/04 10:17:39 $
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

/*******************************************************************
 * DEFINES
*******************************************************************/



/* MACRO d'acces aux elements des objets ss_list_t* et ss_noeud_t*
**--------------------------------
*/
#define SS_LST_ND_SET_CONTENU(X, Y) ((X)->element = Y)
#define SS_LST_ND_GET_CONTENU(X)    ((X)->element)
#define SS_LST_ND_GET_SUIVANT(X)    ((X)->suivant)
#define SS_LST_ND_GET_PRECEDENT(X)  ((X)->precedent)
#define SS_LST_LST_GET_TETE(X)      ((X)->tete)
#define SS_LST_LST_GET_QUEUE(X)     ((X)->queue)
#define SS_LST_LST_EST_ELLE_VIDE(X) ((((X)->tete)==NULL)?TRUE:FALSE)

/*******************************************************************
 * TYPES
*******************************************************************/

/* Types associes a la fonction de gestion des LISTES
**--------------------------------
*/
typedef struct SS_NOEUD_T
{
  struct SS_NOEUD_T *precedent;
  struct SS_NOEUD_T *suivant;
  void *element;
} ss_noeud_t, *ss_pnoeud_t;

typedef struct
{
  ss_noeud_t *tete;
  ss_noeud_t *queue;
} ss_list_t, *ss_plist_t;

typedef enum
  {
    SS_LST_NOTHING,
    SS_LST_STOP,
    SS_LST_REMOVENODE,
  }ss_lst_execaction_t;


#endif  // SSLISTLIB_H
