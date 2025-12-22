/************************************************************************/
/*                                                                      */
/*  OMF_Load.c : Module pour le chargement/décodage des fichiers OMF.   */
/*                                                                      */
/************************************************************************/
/*  Auteur : Olivier ZARDINI  *  Brutal Deluxe Software  *  Avril 2013  */
/************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Dc_Memory.h"
#include "Dc_Shared.h"
#include "OMF_Record.h"
#include "OMF_Load.h"

static int DecodeOMFFile(struct omf_file *);
static struct omf_segment *DecodeOneSegment(struct omf_file *,int,int *);
static int DecodeSegmentHeader(struct omf_file *,int,struct omf_segment_header *);
static int DecodeSegmentBody(struct omf_file *,int,struct omf_segment *);
static void mem_free_segment(struct omf_segment *);

/***********************************************************/
/*  LoadOMFFile() :  Chargement/Décodage d'un fichier OMF. */
/***********************************************************/
struct omf_file *LoadOMFFile(char *file_path)
{
  int i, result;
  struct omf_file *current_file;

  /* Allocation mémoire */
  current_file = (struct omf_file *) calloc(1,sizeof(struct omf_file));
  if(current_file == NULL)
    {
      printf("  Error : Impossible to allocate memory to process OMF file.\n");
      return(NULL);
    }

  /* Conservation du nom */
  current_file->file_path = strdup(file_path);
  if(current_file->file_path == NULL)
    {
      mem_free_omf(current_file);
      printf("  Error : Impossible to allocate memory to process OMF file.\n");
      return(NULL);
    }
  for(i=strlen(current_file->file_path); i>=0; i--)
    if(current_file->file_path[i] == '\\')
      {
        current_file->file_name = &current_file->file_path[i+1];
        break;
      }
  if(current_file->file_name == NULL)
    current_file->file_name = current_file->file_path;

  /* Chargement des Data du fichier OMF */
  current_file->data = LoadFileData(file_path,&current_file->data_length);
  if(current_file->data == NULL)
    {
      mem_free_omf(current_file);
      printf("  Error : Impossible to load OMF file '%s'.\n",file_path);
      return(NULL);
    }

  /** Décodage du contenu du fichier OMF **/
  result = DecodeOMFFile(current_file);

  /* Renvoie la structure */
  return(current_file);
}


/***************************************************************/
/*  DecodeOMFFile() :  Décodage des structures du fichier OMF. */
/***************************************************************/
static int DecodeOMFFile(struct omf_file *current_file)
{
  int file_offset, segment_length;
  struct omf_segment *current_segment;

  /* Init */
  file_offset = 0;

  /** On va itérer sur tous les segments **/
  while(1)
    {
      /** Décode 1 segment **/
      current_segment = DecodeOneSegment(current_file,file_offset,&segment_length);
      if(current_segment == NULL)
        {
          /* Erreur */
          return(1);
        }

      /* Rattache ce segment au fichier OMF */
      if(current_file->first_segment == NULL)
        current_file->first_segment = current_segment;
      else
        current_file->last_segment->next = current_segment;
      current_file->last_segment = current_segment;
      current_file->nb_segment++;

      /* Segment suivant */
      file_offset += segment_length;

      /* Fin de fichier */
      if(file_offset == current_file->data_length)
        break;
    }

  /* OK */
  return(0);
}


/****************************************************************/
/*  DecodeOneSegment() :  Décodage d'un Segment du fichier OMF. */
/****************************************************************/
static struct omf_segment *DecodeOneSegment(struct omf_file *current_file, int data_offset, int *segment_length_rtn)
{
  int result;
  struct omf_segment *current_segment;

  /* Allocation mémoire */
  current_segment = (struct omf_segment *) calloc(1,sizeof(struct omf_segment));
  if(current_segment == NULL)
    {
      printf("Error : Impossible to allocate memory to process Segment #%d.\n",current_file->nb_segment+1);
      return(NULL);
    }

  /** Décodage du Segment Header **/
  result = DecodeSegmentHeader(current_file,data_offset,&current_segment->header);
  if(result)
    {
      mem_free_segment(current_segment);
      return(NULL);
    }
  current_segment->header.FileOffset = data_offset;
  current_segment->header.SegmentOffset = 0;

  /** Décodage du Segment Body **/
  result = DecodeSegmentBody(current_file,data_offset+current_segment->header.DispDataOffset,current_segment);
  if(result)
    {
      mem_free_segment(current_segment);
      return(NULL);
    }

  /* Renvoie le segment */
  *segment_length_rtn = (int) current_segment->header.ByteCnt;
  return(current_segment);
}


/**********************************************************/
/*  DecodeSegmentHeader() :  Décode le Header du Segment. */
/**********************************************************/
static int DecodeSegmentHeader(struct omf_file *current_file, int data_offset, struct omf_segment_header *current_header)
{
  int length;

  /* Vérifie la taille */
  if(data_offset + SEGMENT_HEADER_SIZE > current_file->data_length)
    {
      printf("Error : Not enough data to encode a Segment Header (offset=%d, Segment #%d).\n",data_offset,current_file->nb_segment+1);
      return(1);
    }

  /*******************************************************/
  /**  On va décoder tous les éléments fixes du Header  **/
  /*******************************************************/
  memcpy(&current_header->ByteCnt,&current_file->data[data_offset+0x00],sizeof(DWORD));
  memcpy(&current_header->ResSpc,&current_file->data[data_offset+0x04],sizeof(DWORD));
  memcpy(&current_header->Length,&current_file->data[data_offset+0x08],sizeof(DWORD));
  memcpy(&current_header->undefine_1,&current_file->data[data_offset+0x0C],sizeof(BYTE));
  memcpy(&current_header->LabLen,&current_file->data[data_offset+0x0D],sizeof(BYTE));
  memcpy(&current_header->NumLen,&current_file->data[data_offset+0x0E],sizeof(BYTE));
  memcpy(&current_header->Version,&current_file->data[data_offset+0x0F],sizeof(BYTE));
  memcpy(&current_header->BankSize,&current_file->data[data_offset+0x10],sizeof(DWORD));
  memcpy(&current_header->Kind,&current_file->data[data_offset+0x14],sizeof(WORD));
  memcpy(&current_header->undefine_2,&current_file->data[data_offset+0x16],sizeof(BYTE));
  memcpy(&current_header->undefine_3,&current_file->data[data_offset+0x17],sizeof(BYTE));
  memcpy(&current_header->Org,&current_file->data[data_offset+0x18],sizeof(DWORD));
  memcpy(&current_header->Align,&current_file->data[data_offset+0x1C],sizeof(DWORD));
  memcpy(&current_header->NumSEx,&current_file->data[data_offset+0x20],sizeof(BYTE));
  memcpy(&current_header->undefine_4,&current_file->data[data_offset+0x21],sizeof(BYTE));
  memcpy(&current_header->SegNum,&current_file->data[data_offset+0x22],sizeof(WORD));
  memcpy(&current_header->EntryPointOffset,&current_file->data[data_offset+0x24],sizeof(DWORD));
  memcpy(&current_header->DispNameOffset,&current_file->data[data_offset+0x28],sizeof(WORD));       /* Load Name Offset */
  memcpy(&current_header->DispDataOffset,&current_file->data[data_offset+0x2A],sizeof(WORD));       /* Segment Name Offset */

  /********************************************/
  /**  On va valider les données récupérées  **/
  /********************************************/
  /* Taille du Segment */
  if((int)(data_offset + current_header->ByteCnt) > (int) current_file->data_length)
    {
      printf("Segment #%d Header Error : Invalid 'ByteCnt' value (the segment size can't be larger than the OMF file).\n",current_file->nb_segment+1);
      return(1);
    }
  if(current_header->ByteCnt < SEGMENT_HEADER_SIZE)
    {
      printf("Segment #%d Header Error : Invalid 'ByteCnt' value (the segment size can't be smaller than the Sgement Header size).\n",current_file->nb_segment+1);
      return(1);
    }

  /* Nombre de 0x00 à ajouter à la fin */
  if(current_header->ResSpc >= 0x010000)
    {
      printf("Segment #%d Header Error : Invalid 'ResSpc' value (the size can't be larger than 64 KB).\n",current_file->nb_segment+1);
      return(1);
    }

  /* La taille d'un Segment en mémoire ne peut pas dépasser 64 KB */
  if(current_header->Length >= 0x010000)
    {
      printf("Segment #%d Header Error : Invalid 'Length' value (the segment size can't be larger than 64 KB).\n",current_file->nb_segment+1);
      return(1);
    }

  /* LabLen : 0 ou 10 */
  if(current_header->LabLen != 0x00 && current_header->LabLen != 0x0A)
    {
      printf("Segment #%d Header Error : Invalid 'LabLen' value (the value should be 0 or 10 for the Apple IIgs).\n",current_file->nb_segment+1);
      return(1);
    }

  /* Num Len : Tjs à 4 pour le IIgs */
  if(current_header->NumLen != 0x04)
    {
      printf("Segment #%d Header Error : Invalid 'NumLen' value (the value should be 4 for the Apple IIgs).\n",current_file->nb_segment+1);
      return(1);
    }

  /* Version : Tjs à 2 */
  if(current_header->Version != 0x02)
    {
      printf("Segment #%d Header Error : Invalid 'Version' value (the value should be 2 for the Apple IIgs).\n",current_file->nb_segment+1);
      return(1);
    }

  /* BankSize : <= 64 KB */
  if(current_header->BankSize > 0x010000)
    {
      printf("Segment #%d Header Error : Invalid 'BankSize' value (the value can't be larger than 64 KB).\n",current_file->nb_segment+1);
      return(1);
    }

  /* Kind */
  if((current_header->Kind & 0x001F) != 0x0000 && (current_header->Kind & 0x001F) != 0x0001 && (current_header->Kind & 0x001F) != 0x0002 &&
     (current_header->Kind & 0x001F) != 0x0004 && (current_header->Kind & 0x001F) != 0x0008 && (current_header->Kind & 0x001F) != 0x0010 &&
     (current_header->Kind & 0x001F) != 0x0012)
    {
      printf("Segment #%d Header Error : Invalid 'Kind' value (possible values are 0,1,2,4,8,16 or 18).\n",current_file->nb_segment+1);
      return(1);
    }

  /* Org : < 64 KB */
  if(current_header->Org >= 0x010000)
    {
      printf("Segment #%d Header Error : Invalid 'Org' value (the value can't be larger than 64 KB).\n",current_file->nb_segment+1);
      return(1);
    }

  /* Align : 0, 0x0100 ou 0x010000 */
  if(current_header->Align != 0x00 && current_header->Align != 0x0100 && current_header->Align != 0x010000)
    {
      printf("Segment #%d Header Error : Invalid 'Align' value (the value should be 0, 256 or 64KB or for the Apple IIgs).\n",current_file->nb_segment+1);
      return(1);
    }

  /* NumSEx : Tjs à 0 */
  if(current_header->NumSEx != 0x00)
    {
      printf("Segment #%d Header Error : Invalid 'NumSEx' value (the value should be 0 for the Apple IIgs).\n",current_file->nb_segment+1);
      return(1);
    }

  /* SegNum : 1 -> N */
  if(current_header->SegNum != (WORD) current_file->nb_segment+1)
    {
      printf("Segment #%d Header Error : Invalid 'SegNum' value (the value should be %d and we have %d for the Apple IIgs).\n",current_file->nb_segment+1,current_file->nb_segment+1,current_header->SegNum);
      return(1);
    }

  /* Entry Point */
  if(current_header->EntryPointOffset > current_header->Length)
    {
      printf("Segment #%d Header Error : Invalid 'EntryPointOffset' value (the value can't be larger than the Segment size).\n",current_file->nb_segment+1);
      return(1);
    }

  /* DispName offset (devrait être 44 si TmpOrg est vide) */
  if(current_header->DispNameOffset < SEGMENT_HEADER_MIN_SIZE)
    {
      printf("Segment #%d Header Error : Invalid 'DispNameOffset' value (the value can't be smaller than the Segment Header size).\n",current_file->nb_segment+1);
      return(1);
    }
  if(current_header->DispNameOffset > current_header->ByteCnt)
    {
      printf("Segment #%d Header Error : Invalid 'DispNameOffset' value (the value can't be larger than the Segment size).\n",current_file->nb_segment+1);
      return(1);
    }

  /* DispData offset (devrait être 64 si TmpOrg est vide) */
  if(current_header->DispDataOffset < SEGMENT_HEADER_MIN_SIZE)
    {
      printf("Segment #%d Header Error : Invalid 'DispDataOffset' value (the value can't be smaller than the Segment Header size).\n",current_file->nb_segment+1);
      return(1);
    }
  if(current_header->DispNameOffset > current_header->ByteCnt)
    {
      printf("Segment #%d Header Error : Invalid 'DispDataOffset' value (the value can't be larger than the Segment size).\n",current_file->nb_segment+1);
      return(1);
    }

  /*********************************************/
  /**  On va récupérer les données variables  **/
  /*********************************************/
  /* Temp Org */
  if(current_header->DispNameOffset > SEGMENT_HEADER_MIN_SIZE) /* 44 */
    {
      current_header->TempOrgLength = current_header->DispNameOffset - SEGMENT_HEADER_MIN_SIZE;
      memcpy(current_header->TempOrg,&current_file->data[data_offset+SEGMENT_HEADER_MIN_SIZE],current_header->TempOrgLength);
    }
  else
    current_header->TempOrgLength = 0;

  /* Noms */
  memcpy(current_header->LoadName,&current_file->data[data_offset+current_header->DispNameOffset],10);
  if(current_header->LabLen > 0)
    memcpy(current_header->SegName,&current_file->data[data_offset+current_header->DispNameOffset+10],current_header->LabLen);
  else
    {
      /* La longueur est codée au début */
      length = (int) current_file->data[data_offset+current_header->DispNameOffset+10];
      memcpy(&current_header->SegName,&current_file->data[data_offset+current_header->DispNameOffset+10+1],length);
    }

  /* OK */
  return(0);
}


/*******************************************************************************/
/*  DecodeSegmentBody() :  Décode les différents Records du Body d'un Segment. */
/*******************************************************************************/
static int DecodeSegmentBody(struct omf_file *current_file, int data_offset, struct omf_segment *current_segment)
{
  int body_offset, body_length, record_length;
  struct omf_body_record *current_record;

  /* Init */
  body_offset = 0;
  body_length = current_segment->header.ByteCnt - current_segment->header.DispDataOffset;

  /* On libère les structures précédentes */
  my_Memory(MEMORY_FREE_RELOC,NULL,NULL);
  my_Memory(MEMORY_FREE_INTERSEG,NULL,NULL);

  /** Boucle sur tous les Records du Body **/
  while(1)
    {
      /** Extrait un Record du Body **/
      current_record = DecodeOneRecord(&current_file->data[data_offset+body_offset],current_segment->header.SegNum,data_offset+body_offset,current_segment->header.ByteCnt+body_offset,current_segment->lconst_data,current_segment->lconst_length,&record_length);
      if(current_record == NULL)
        return(1);
      current_record->FileOffset = data_offset+body_offset;
      current_record->SegmentOffset = current_segment->header.ByteCnt + body_offset;

      /* Attache de Record aux précédents */
      if(current_segment->first_record == NULL)
        current_segment->first_record = current_record;
      else
        current_segment->last_record->next = current_record;
      current_segment->last_record = current_record;
      current_segment->nb_record++;

      /* On conserverve un pointeur vers les Data du Segment */
      if(current_record->operation_code >= 0x01 && current_record->operation_code <= 0xDF && current_record->record_data != NULL)
        {
          /* Conserve un pointeur sur le LCONST du Segment */
          current_segment->lconst_data = ((struct record_CONST *)(current_record->record_data))->data;
          current_segment->lconst_length = ((struct record_CONST *)(current_record->record_data))->ByteCnt;
        }
      else if(current_record->operation_code == 0xF2 && current_record->record_data != NULL)
        {
          /* Conserve un pointeur sur le LCONST du Segment */
          current_segment->lconst_data = ((struct record_LCONST *)(current_record->record_data))->data;
          current_segment->lconst_length = ((struct record_LCONST *)(current_record->record_data))->ByteCnt;
        }

      /* On passe au Record suivant */
      body_offset += record_length;
      if(body_offset == body_length)
        break;
    }

  /** On va extraire tous les RELOC / INTERSEG **/
  my_Memory(MEMORY_SORT_RELOC,&current_segment->nb_reloc,&current_segment->tab_reloc);
  my_Memory(MEMORY_SORT_INTERSEG,&current_segment->nb_interseg,&current_segment->tab_interseg);

  /* OK */
  return(0);
}


/*******************************************************************/
/*  mem_free_omf() :  Libération mémoire de la structure omf_file. */
/*******************************************************************/
void mem_free_omf(struct omf_file *current_file)
{
  struct omf_segment *current_segment;
  struct omf_segment *next_segment;

  if(current_file)
    {
      if(current_file->file_path)
        free(current_file->file_path);

      if(current_file->data)
        free(current_file->data);

      /* Libération des segments */
      for(current_segment = current_file->first_segment; current_segment; )
        {
          next_segment = current_segment->next;
          mem_free_segment(current_segment);
          current_segment = next_segment;
        }

      free(current_file);
    }
}


/**************************************************************************/
/*  mem_free_segment() :  Libération mémoire de la structure omf_segment. */
/**************************************************************************/
static void mem_free_segment(struct omf_segment *current_segment)
{
  int i;
  struct omf_body_record *current_record;
  struct omf_body_record *next_record;

  if(current_segment)
    {
      /* Libération des Records */
      for(current_record=current_segment->first_record; current_record; )
        {
          next_record = current_record->next;
          mem_free_record(current_record);
          current_record = next_record;
        }

      /* Libération des tableaux */
      if(current_segment->tab_reloc)
        {
          for(i=0; i<current_segment->nb_reloc; i++)
            free(current_segment->tab_reloc[i]);
          free(current_segment->tab_reloc);
        }
      if(current_segment->tab_interseg)
        {
          for(i=0; i<current_segment->nb_interseg; i++)
            free(current_segment->tab_interseg[i]);
          free(current_segment->tab_interseg);
        }

      free(current_segment);
    }
}

/************************************************************************/
