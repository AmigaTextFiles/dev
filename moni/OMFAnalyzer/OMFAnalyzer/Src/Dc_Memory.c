/************************************************************************/
/*                                                                      */
/*  Dc_Memory.c : Module pour la bibliothèque de gestion mémoire.       */
/*                                                                      */
/************************************************************************/
/*  Auteur : Olivier ZARDINI  *  Brutal Deluxe Software  *  Avril 2013  */
/************************************************************************/

#include <stdio.h>
#include <stdlib.h>

#include "Dc_Shared.h"
#include "OMF_Record.h"
#include "Dc_Memory.h"

int compare_reloc(const void *,const void *);
int compare_interseg(const void *,const void *);

/********************************************************************/
/*  my_Memory() :  Bibliothèque de gestion des ressources mémoires. */
/********************************************************************/
void my_Memory(int code, void *data, void *value)
{
  int i;
  static int nb_reloc;
  static struct omf_reloc *first_reloc;
  static struct omf_reloc *last_reloc;
  struct omf_reloc *current_reloc;
  struct omf_reloc *next_reloc;
  struct omf_reloc **tab_reloc;
  static int nb_interseg;
  static struct omf_interseg *first_interseg;
  static struct omf_interseg *last_interseg;
  struct omf_interseg *current_interseg;
  struct omf_interseg *next_interseg;
  struct omf_interseg **tab_interseg;

  switch(code)
    {
      /********************/
      /*  Initialisation  */
      /********************/
      case MEMORY_INIT :
        nb_reloc = 0;
        first_reloc = NULL;
        last_reloc = NULL;
        nb_interseg = 0;
        first_interseg = NULL;
        last_interseg = NULL;
        break;

      case MEMORY_FREE :
        my_Memory(MEMORY_FREE_RELOC,NULL,NULL);
        my_Memory(MEMORY_FREE_INTERSEG,NULL,NULL);
        break;

      /***************************/
      /*  Liste chaine de RELOC  */
      /***************************/
      case MEMORY_ADD_RELOC :
        current_reloc = (struct omf_reloc *) data;
        if(current_reloc == NULL)
          return;

        /* Ajoute la structure */
        if(first_reloc == NULL)
          first_reloc = current_reloc;
        else
          last_reloc->next = current_reloc;
        last_reloc = current_reloc;
        nb_reloc++;
        break;

      case MEMORY_GET_RELOC_NB :
        *((int *) data) = nb_reloc;
        break;

      case MEMORY_SORT_RELOC :
        /* Allocatioon d'un Tableau trié */
        if(nb_reloc == 0)
          {
            *((int *) data) = 0;
            *((struct omf_reloc ***) value) = NULL;
            return;
          }

        /* Allocation */
        tab_reloc = (struct omf_reloc **) calloc(nb_reloc,sizeof(struct omf_reloc *));
        if(tab_reloc == NULL)
          ;

        /* Remplissage */
        for(current_reloc=first_reloc, i=0; current_reloc; current_reloc=current_reloc->next, i++)
          tab_reloc[i] = current_reloc;

        /* Tri */
        qsort(tab_reloc,nb_reloc,sizeof(struct omf_reloc *),compare_reloc);

        /* Renvoi les éléments */
        *((int *) data) = nb_reloc;
        *((struct omf_reloc ***) value) = tab_reloc;

        /* Nettoyage */
        nb_reloc = 0;
        first_reloc = NULL;
        last_reloc = NULL;
        break;

      case MEMORY_FREE_RELOC :
        for(current_reloc = first_reloc; current_reloc; )
          {
            next_reloc = current_reloc->next;
            free(current_reloc);
            current_reloc = next_reloc;
          }
        nb_reloc = 0;
        first_reloc = NULL;
        last_reloc = NULL;
        break;

      /******************************/
      /*  Liste chaine de INTERSEG  */
      /******************************/
      case MEMORY_ADD_INTERSEG :
        current_interseg = (struct omf_interseg *) data;
        if(current_interseg == NULL)
          return;

        /* Ajoute la structure */
        if(first_interseg == NULL)
          first_interseg = current_interseg;
        else
          last_interseg->next = current_interseg;
        last_interseg = current_interseg;
        nb_interseg++;
        break;

      case MEMORY_GET_INTERSEG_NB :
        *((int *) data) = nb_interseg;
        break;

      case MEMORY_SORT_INTERSEG :
        /* Allocatioon d'un Tableau trié */
        if(nb_interseg == 0)
          {
            *((int *) data) = 0;
            *((struct omf_interseg ***) value) = NULL;
            return;
          }

        /* Allocation */
        tab_interseg = (struct omf_interseg **) calloc(nb_interseg,sizeof(struct omf_interseg *));
        if(tab_interseg == NULL)
          ;

        /* Remplissage */
        for(current_interseg=first_interseg, i=0; current_interseg; current_interseg=current_interseg->next, i++)
          tab_interseg[i] = current_interseg;

        /* Tri */
        qsort(tab_interseg,nb_interseg,sizeof(struct omf_interseg *),compare_interseg);

        /* Renvoi les éléments */
        *((int *) data) = nb_interseg;
        *((struct omf_interseg ***) value) = tab_interseg;

        /* Nettoyage */
        nb_interseg = 0;
        first_interseg = NULL;
        last_interseg = NULL;
        break;

      case MEMORY_FREE_INTERSEG :
        for(current_interseg = first_interseg; current_interseg; )
          {
            next_interseg = current_interseg->next;
            free(current_interseg);
            current_interseg = next_interseg;
          }
        nb_interseg = 0;
        first_interseg = NULL;
        last_interseg = NULL;
        break;

      default :
        break;
    }
}


/******************************************************************/
/*  compare_reloc() : Fonction de comparaison pour le Quick Sort. */
/******************************************************************/
int compare_reloc(const void *data_1, const void *data_2)
{
  struct omf_reloc *reloc_1;
  struct omf_reloc *reloc_2;

  /* Récupération des paramètres */
  reloc_1 = *((struct omf_reloc **) data_1);
  reloc_2 = *((struct omf_reloc **) data_2);

  /* Comparaison des adresses */
  if(reloc_1->OffsetPatch < reloc_2->OffsetPatch)
    return(-1);
  else if(reloc_1->OffsetPatch > reloc_2->OffsetPatch)
    return(1);
  else
    {
      /* Si l'adresse est la même, on prévilégie le nb de byte */
      if(reloc_1->ByteCnt < reloc_2->ByteCnt)
        return(1);
      else if(reloc_1->ByteCnt > reloc_2->ByteCnt)
        return(-1);
      else
        return(0);
    }
}


/*********************************************************************/
/*  compare_interseg() : Fonction de comparaison pour le Quick Sort. */
/*********************************************************************/
int compare_interseg(const void *data_1, const void *data_2)
{
  struct omf_interseg *interseg_1;
  struct omf_interseg *interseg_2;

  /* Récupération des paramètres */
  interseg_1 = *((struct omf_interseg **) data_1);
  interseg_2 = *((struct omf_interseg **) data_2);

  /* Comparaison des adresses */
  if(interseg_1->OffsetPatch < interseg_2->OffsetPatch)
    return(-1);
  else if(interseg_1->OffsetPatch > interseg_2->OffsetPatch)
    return(1);
  else
    {
      /* Si l'adresse est la même, on prévilégie le nb de byte */
      if(interseg_1->ByteCnt < interseg_2->ByteCnt)
        return(1);
      else if(interseg_1->ByteCnt > interseg_2->ByteCnt)
        return(-1);
      else
        return(0);
    }
}

/************************************************************************/
