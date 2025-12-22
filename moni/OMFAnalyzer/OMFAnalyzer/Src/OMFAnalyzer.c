/************************************************************************/
/*                                                                      */
/*  Main.c : Outil d'analyse des fichiers OMF.                          */
/*                                                                      */
/************************************************************************/
/*  Auteur : Olivier ZARDINI  *  Brutal Deluxe Software  *  Avril 2013  */
/************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Dc_Shared.h"
#include "OMF_Load.h"
#include "OMF_Dump.h"
#include "OMF_Extract.h"
#include "OMF_Diff.h"
#include "Dc_Memory.h"

static void usage(char *program_name);

/****************************************************/
/*  main() :  Fonction principale de l'application. */
/****************************************************/
int main(int argc, char *argv[])
{
  int result, length_1, length_2;
  struct omf_file *current_file;
  struct omf_file *first_file;
  struct omf_file *second_file;
  unsigned char *file1_data;
  unsigned char *file2_data;

  /* Information */
  printf("%s v1.0 (c) Brutal Deluxe Software 2013-2014\n",argv[0]);

  /* Vérification des paramètres */
  if(argc != 4 && argc != 5)
    {
      usage(argv[0]);
      return(1);
    }

  /* Init */
  my_Memory(MEMORY_INIT,NULL,NULL);

  /***********************************************************/
  /**  On oriente le traitement en fonction de la commande  **/
  /***********************************************************/
  if(!stricmp(argv[1],"DUMP") && argc == 4)
    {
      /** Charge et Décode le fichier OMF **/
      current_file = LoadOMFFile(argv[2]);
      if(current_file == NULL)
        return(2);

      /** Création du fichier Dump Texte **/
      result = CreateDumpFile(current_file,argv[3]);

      /* Libération mémoire */
      mem_free_omf(current_file);
    }
  else if(!stricmp(argv[1],"EXTRACT") && argc == 5)
    {
      /** Charge et Décode le fichier OMF **/
      current_file = LoadOMFFile(argv[2]);
      if(current_file == NULL)
        return(2);

      /** Extraction du LCONST du Nième segment sur disque **/
      result = ExtractLConstFile(current_file,argv[3],argv[4]);

      /* Libération mémoire */
      mem_free_omf(current_file);
    }
  else if(!stricmp(argv[1],"COMPARE") && argc == 5)
    {
      /** Charge et Décode le fichier OMF 1 **/
      first_file = LoadOMFFile(argv[2]);
      if(first_file == NULL)
        return(2);

      /** Charge et Décode le fichier OMF 2 **/
      second_file = LoadOMFFile(argv[3]);
      if(second_file == NULL)
        {
          mem_free_omf(first_file);
          return(2);
        }

      /** Création du fichier Diff Texte **/
      result = CreateDiffFile(first_file,second_file,argv[4]);

      /* Libération mémoire */
      mem_free_omf(first_file);
      mem_free_omf(second_file);
    }
  else if(!stricmp(argv[1],"COMPAREBIN") && argc == 5)
    {
      /** Charge et Décode le fichier Binary 1 **/
      file1_data = LoadFileData(argv[2],&length_1);
      if(file1_data == NULL)
        return(2);

      /** Charge et Décode le fichier Binary 2 **/
      file2_data = LoadFileData(argv[3],&length_2);
      if(file2_data == NULL)
        {
          free(file1_data);
          return(2);
        }

      /** Création du fichier Diff Texte **/
      result = CreateDiffBinaryFile(length_1,file1_data,length_2,file2_data,argv[4]);

      /* Libération mémoire */
      free(file1_data);
      free(file2_data);
    }
  else
    {
      /* Erreur dans les paramètres */
      usage(argv[0]);
      return(1);
    }

  /* Libération */
  my_Memory(MEMORY_FREE,NULL,NULL);

  /* OK */
  return(0);
}


/****************************************************************/
/*  usage() :  Liste des commandes et des paramètres autorisés. */
/****************************************************************/
static void usage(char *program_name)
{
  printf("   Usage : %s DUMP        <omf_file_path>      <output_file_path>.\n",program_name);
  printf("           %s EXTRACT     <omf_file_path>      <segment_number>     <output_file_path>.\n",program_name);
  printf("           %s COMPARE     <omf_file1_path>     <omf_file2_path>     <diff_file_path>.\n",program_name);
  printf("           %s COMPAREBIN  <binary_file1_path>  <binary_file2_path>  <diff_file_path>.\n",program_name);
}

/******************************************************************************/
