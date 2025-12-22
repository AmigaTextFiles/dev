/************************************************************************/
/*                                                                      */
/*  Dc_Shared.c : Module pour la bibliothèque de fonctions génériques.  */
/*                                                                      */
/************************************************************************/
/*  Auteur : Olivier ZARDINI  *  Brutal Deluxe Software  *  Avril 2013  */
/************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include <ctype.h>
#include <setjmp.h>
#include <io.h>

#include "Dc_Shared.h"

/*************************************************************/
/*  LoadFileData() :  Récupération des données d'un fichier. */
/*************************************************************/
unsigned char *LoadFileData(char *file_path, int *data_length_rtn)
{
  FILE *fd;
  int nb_read, file_size;
  unsigned char *data;

  /* Ouverture du fichier */
  fd = fopen(file_path,"rb");
  if(fd == NULL)
    return(NULL);

  /* Taille du fichier */
  fseek(fd,0L,SEEK_END);
  file_size = ftell(fd);
  fseek(fd,0L,SEEK_SET);
   
  /* Allocation mémoire */
  data = (unsigned char *) calloc(1,file_size+1);
  if(data == NULL)
    {
      fclose(fd);
      return(NULL);
    }

  /* Lecture des données */
  nb_read = fread(data,1,file_size,fd);
  if(nb_read < 0)
    {
      free(data);
      fclose(fd);
      return(NULL);
    }
  data[nb_read] = '\0';

  /* Fermeture du fichier */
  fclose(fd);

  /* Renvoi les données et la taille */
  *data_length_rtn = nb_read;
  return(data);
}


/********************************************************************/
/*  CreateBinaryFile() :  Création d'un fichier binaire sur disque. */
/********************************************************************/
int CreateBinaryFile(char *file_path, int data_length, unsigned char *data)
{
  FILE *fd;
  int nb_write;

  /* Ouverture du fichier */
  fd = fopen(file_path,"wb");
  if(fd == NULL)
    return(1);

  /* Lecture des données */
  nb_write = fwrite(data,1,data_length,fd);

  /* Fermeture du fichier */
  fclose(fd);

  /* OK */
  if(nb_write != data_length)
    return(2);
  return(0);
}

/************************************************************************/
