/***************************************************************************
*   Ce fichier, ainsi que tous les  modules  l'accompagnant, peut et  doit *
* etre  copié GRATUITEMENT à la seule condition expresse de conserver      *
* l'INTEGRALITE  du  Code Source, de  la documentation, et  des fichiers   *
* annexes du package. Ce logiciel est Shareware, veuilez envoyer 100 FF à  *
* l'auteur pour recevoir regulièrement les nouvelles versions.             *
* Toute modification est INTERDITE sans l'autorisation écrite de l'auteur. *
*            Tous droits réservés à M. DIALLO Barrou, Juillet 1992.        *
***************************************************************************/

     /*** module cleo: TYPES pour le gestionnaire de library ***/

     /* Doit etre mis à jour en meme temps que lib/include/clib.h */

typedef struct fctlib{
    int node;       /* Noeud de la library à laquelle elle appartient */
    int id;         /* Id de cette fct */
    int retype;     /* Type de la valeur de retour */
    int nbarg;      /* Nbre d'arg */
    int *type;      /* Tableau sur les type des args */
    char *nom;      /* Nom de la fonction */
    struct fctlib *next;
    } FCTLIB;

typedef struct{
        char nom[255];      /* Nom de la library */
        int nbfct;          /* Nombre de fonctions */
        int node;           /* Noeud de la library */
    }LIBHEAD;
