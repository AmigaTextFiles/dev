/************************************************************************/
/*                                                                      */
/*  OMF_Diff.c : Module pour le Diff en format Text des fichiers OMF.   */
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
#include "OMF_Load.h"
#include "Dc_Memory.h"
#include "OMF_Record.h"
#include "OMF_Dump.h"

static int CompareSegment(struct omf_segment *,struct omf_segment *,int);
static int CompareHeader(struct omf_segment_header *,struct omf_segment_header *,int);
static int CompareData(int,unsigned char *,int,unsigned char *,int);
static int CompareReloc(int,struct omf_reloc **,int,struct omf_reloc **,int);
static int CompareOneReloc(struct omf_reloc *,struct omf_reloc *,int,int,int);
static int CompareInterseg(int,struct omf_interseg **,int,struct omf_interseg **,int);
static int CompareOneInterseg(struct omf_interseg *,struct omf_interseg *,int,int,int);

/***************************************************/
/*  CreateDiffFile() :  Compare deux fichiers OMF. */
/***************************************************/
int CreateDiffFile(struct omf_file *file_1, struct omf_file *file_2, char *diff_file_path)
{
  int i;
  struct omf_segment *segment_1;
  struct omf_segment *segment_2;

  /** On compare tous les Segments entre eux **/
  segment_2 = file_2->first_segment;
  for(i=0,segment_1 = file_1->first_segment; segment_1; segment_1=segment_1->next,i++)
    {
      if(segment_1 != NULL && segment_2 != NULL)
        CompareSegment(segment_1,segment_2,i+1);
    }

  /* Fin */
  printf(" ####################################################\n");

  /* OK */
  return(0);
}


/********************************************************/
/*  CreateDiffFile() :  Compare deux fichiers binaires. */
/********************************************************/
int CreateDiffBinaryFile(int length_1, unsigned char *data_1, int length_2, unsigned char *data_2, char *diff_file_path)
{
  int i, common_length, nb_diff;

  /* Init */
  nb_diff = 0;
  common_length = (length_1 < length_2) ? length_1 : length_2;

  /* Taille identique ? */
  if(length_1 != length_2)
    printf("    Data  [Length]  : %04X     - %04X\n",(WORD)length_1,(WORD)length_2);
  
  /** On compare sur la plage commune **/
  for(i=0; i<common_length; i++)
    if(data_1[i] != data_2[i])
      {
        printf("    Data  [%04X]  : %02X   - %02X\n",(WORD)i,data_1[i],data_2[i]);
        nb_diff++;
        if(nb_diff > 50)
          {
            printf("    To many errors...\n");
            break;
          }
      }
  /* Fin */
  printf(" ####################################################\n");

  /* OK */
  return(0);
}


/*********************************************************/
/*  CompareSegment() :  Compare deux Segments entre eux. */
/*********************************************************/
static int CompareSegment(struct omf_segment *segment_1, struct omf_segment *segment_2, int seg_num)
{
  /** Compare le Header **/
  printf(" ####################################################\n");
  printf(" - Compare HEADER :\n");
  CompareHeader(&segment_1->header,&segment_2->header,seg_num);

  /** Compare les Data **/
  printf(" - Compare DATA :\n");
  CompareData(segment_1->lconst_length,segment_1->lconst_data,segment_2->lconst_length,segment_2->lconst_data,seg_num);

  /** Compare les Reloc **/
  printf(" - Compare RELOC :\n");
  CompareReloc(segment_1->nb_reloc,segment_1->tab_reloc,segment_2->nb_reloc,segment_2->tab_reloc,seg_num);

  /** Compare les Interseg **/
  printf(" - Compare INTERSEG :\n");
  CompareInterseg(segment_1->nb_interseg,segment_1->tab_interseg,segment_2->nb_interseg,segment_2->tab_interseg,seg_num);

  /* OK */
  return(0);
}


/******************************************************/
/*  CompareHeader() :  Compare deux Header entre eux. */
/******************************************************/
static int CompareHeader(struct omf_segment_header *header_1, struct omf_segment_header *header_2, int seg_num)
{
  /** Compare toues les membres **/
  if(header_1->ByteCnt != header_2->ByteCnt)
    printf("    Segment #%d Header [ByteCnt]                 : %08X - %08X\n",seg_num,header_1->ByteCnt,header_2->ByteCnt);
  if(header_1->ResSpc != header_2->ResSpc)
    printf("    Segment #%d Header [ResSpc]                  : %08X - %08X\n",seg_num,header_1->ResSpc,header_2->ResSpc);
  if(header_1->Length != header_2->Length)
    printf("    Segment #%d Header [Length]                  : %08X - %08X\n",seg_num,header_1->Length,header_2->Length);
  if(header_1->undefine_1 != header_2->undefine_1)
    printf("    Segment #%d Header [undefine_1]              : %02X       - %02X\n",seg_num,header_1->undefine_1,header_2->undefine_1);
  if(header_1->LabLen != header_2->LabLen)
    printf("    Segment #%d Header [LabLen]                  : %02X       - %02X\n",seg_num,header_1->LabLen,header_2->LabLen);
  if(header_1->NumLen != header_2->NumLen)
    printf("    Segment #%d Header [NumLen]                  : %02X       - %02X\n",seg_num,header_1->NumLen,header_2->NumLen);
  if(header_1->Version != header_2->Version)
    printf("    Segment #%d Header [Version]                 : %02X       - %02X\n",seg_num,header_1->Version,header_2->Version);
  if(header_1->BankSize != header_2->BankSize)
    printf("    Segment #%d Header [BankSize]                : %08X - %08X\n",seg_num,header_1->BankSize,header_2->BankSize);
  if(header_1->Kind != header_2->Kind)
    printf("    Segment #%d Header [Kind]                    : %04X     - %04X\n",seg_num,header_1->Kind,header_2->Kind);
  if(header_1->undefine_2 != header_2->undefine_2)
    printf("    Segment #%d Header [undefine_2]              : %02X       - %02X\n",seg_num,header_1->undefine_2,header_2->undefine_2);
  if(header_1->undefine_3 != header_2->undefine_3)
    printf("    Segment #%d Header [undefine_3]              : %02X       - %02X\n",seg_num,header_1->undefine_3,header_2->undefine_3);
  if(header_1->Org != header_2->Org)
    printf("    Segment #%d Header [Org]                     : %08X - %08X\n",seg_num,header_1->Org,header_2->Org);
  if(header_1->Align != header_2->Align)
    printf("    Segment #%d Header [Align]                   : %08X - %08X\n",seg_num,header_1->Align,header_2->Align);
  if(header_1->NumSEx != header_2->NumSEx)
    printf("    Segment #%d Header [NumSEx]                  : %02X       - %02X\n",seg_num,header_1->NumSEx,header_2->NumSEx);
  if(header_1->undefine_4 != header_2->undefine_4)
    printf("    Segment #%d Header [undefine_4]              : %02X       - %02X\n",seg_num,header_1->undefine_4,header_2->undefine_4);
  if(header_1->SegNum != header_2->SegNum)
    printf("    Segment #%d Header [SegNum]                  : %04X     - %04X\n",seg_num,header_1->SegNum,header_2->SegNum);
  if(header_1->EntryPointOffset != header_2->EntryPointOffset)
    printf("    Segment #%d Header [EntryPointOffset]        : %08X - %08X\n",seg_num,header_1->EntryPointOffset,header_2->EntryPointOffset);
  if(header_1->DispNameOffset != header_2->DispNameOffset)
    printf("    Segment #%d Header [DispNameOffset]          : %04X     - %04X\n",seg_num,header_1->DispNameOffset,header_2->DispNameOffset);
  if(header_1->DispDataOffset != header_2->DispDataOffset)
    printf("    Segment #%d Header [DispDataOffset]          : %04X     - %04X\n",seg_num,header_1->DispDataOffset,header_2->DispDataOffset);
  if(strcmp(header_1->LoadName,header_2->LoadName))
    printf("    Segment #%d Header [LoadName]                : '%s' - '%s'\n",seg_num,header_1->LoadName,header_2->LoadName);
  if(strcmp(header_1->SegName,header_2->SegName))
    printf("    Segment #%d Header [SegName]                 : '%s' - '%s'\n",seg_num,header_1->SegName,header_2->SegName);

  /* OK */
  return(0);
}


/*****************************************************************/
/*  CompareData() :  Compare la partie LCONST des deux Segments. */
/*****************************************************************/
static int CompareData(int length_1, unsigned char *data_1, int length_2, unsigned char *data_2, int seg_num)
{
  int i, common_length, nb_diff;

  /* Init */
  nb_diff = 0;
  common_length = (length_1 < length_2) ? length_1 : length_2;

  /* Taille identique ? */
  if(length_1 != length_2)
    printf("    Segment #%d Data [Length]                    : %04X     - %04X\n",seg_num,(WORD)length_1,(WORD)length_2);
  
  /** On compare sur la plage commune **/
  for(i=0; i<common_length; i++)
    if(data_1[i] != data_2[i])
      {
        printf("    Segment #%d Data [%04X]                      : %02X       - %02X\n",seg_num,(WORD)i,data_1[i],data_2[i]);
        nb_diff++;
        if(nb_diff > 50)
          {
            printf("    To many errors...\n");
            break;
          }
      }

  /* OK */
  return(0);
}


/*****************************************************************/
/*  CompareReloc() :  Compare la partie Reloc des deux Segments. */
/*****************************************************************/
static int CompareReloc(int nb_reloc_1, struct omf_reloc **tab_reloc_1, int nb_reloc_2, struct omf_reloc **tab_reloc_2, int seg_num)
{
  int i, common_length, nb_diff;

  /* Init */
  nb_diff = 0;
  common_length = (nb_reloc_1 < nb_reloc_2) ? nb_reloc_1 : nb_reloc_2;

  /* Taille identique ? */
  if(nb_reloc_1 != nb_reloc_2)
    printf("    Segment #%d Reloc [Number]                   : %04X     - %04X\n",seg_num,(WORD)nb_reloc_1,(WORD)nb_reloc_2);

  /** On compare sur la plage commune **/
  for(i=0; i<common_length; i++)
    if(CompareOneReloc(tab_reloc_1[i],tab_reloc_2[i],i,seg_num,nb_diff))
      {
        nb_diff++;
        if(nb_diff > 50)
          {
            printf("    To many errors...\n");
            break;
          }
      }

  /* OK */
  return(0);
}


/***********************************************************************/
/*  CompareOneReloc() :  Compare les membres de deux structures Reloc. */
/***********************************************************************/
static int CompareOneReloc(struct omf_reloc *reloc_1, struct omf_reloc *reloc_2, int reloc_num, int seg_num, int nb_global_diff)
{
  int nb_diff;

  /* Init */
  nb_diff = 0;

  /** On compare les membres **/
  if(reloc_1->ByteCnt != reloc_2->ByteCnt)
    {
      if(nb_global_diff > 0 && nb_diff == 0)
        printf("    --\n");
      printf("    Segment #%d Reloc #%04X [ByteCnt]            : %02X       - %02X\n",seg_num,reloc_num,reloc_1->ByteCnt,reloc_2->ByteCnt);
      nb_diff = 1;
    }

  if(reloc_1->BitShiftCnt != reloc_2->BitShiftCnt)
    {
      if(nb_global_diff > 0 && nb_diff == 0)
        printf("    --\n");
      printf("    Segment #%d Reloc #%04X [BitShiftCnt]        : %02X       - %02X\n",seg_num,reloc_num,reloc_1->BitShiftCnt,reloc_2->BitShiftCnt);
      nb_diff = 1;
    }

  if(reloc_1->OffsetPatch != reloc_2->OffsetPatch)
    {
      if(nb_global_diff > 0 && nb_diff == 0)
        printf("    --\n");
      printf("    Segment #%d Reloc #%04X [OffsetPatch]        : %04X     - %04X\n",seg_num,reloc_num,reloc_1->OffsetPatch,reloc_2->OffsetPatch);
      nb_diff = 1;
    }

  if(reloc_1->OffsetReference != reloc_2->OffsetReference)
    {
      if(nb_global_diff > 0 && nb_diff == 0)
        printf("    --\n");
      printf("    Segment #%d Reloc #%04X [OffsetReference]    : %04X     - %04X\n",seg_num,reloc_num,reloc_1->OffsetReference,reloc_2->OffsetReference);
      nb_diff = 1;
    }

  /* Identique ? */
  return(nb_diff);
}


/***********************************************************************/
/*  CompareInterseg() :  Compare la partie Interseg des deux Segments. */
/***********************************************************************/
static int CompareInterseg(int nb_interseg_1, struct omf_interseg **tab_interseg_1, int nb_interseg_2, struct omf_interseg **tab_interseg_2, int seg_num)
{
  int i, common_length, nb_diff;

  /* Init */
  nb_diff = 0;
  common_length = (nb_interseg_1 < nb_interseg_2) ? nb_interseg_1 : nb_interseg_2;

  /* Taille identique ? */
  if(nb_interseg_1 != nb_interseg_2)
    printf("    Segment #%d Interseg [Number]                : %04X     - %04X\n",seg_num,(WORD)nb_interseg_1,(WORD)nb_interseg_2);

  /** On compare sur la plage commune **/
  for(i=0; i<common_length; i++)
    if(CompareOneInterseg(tab_interseg_1[i],tab_interseg_2[i],i,seg_num,nb_diff))
      {
        nb_diff++;
        if(nb_diff > 50)
          {
            printf("    To many errors...\n");
            break;
          }
      }

  /* OK */
  return(0);
}


/***********************************************************************/
/*  CompareOneInterseg() :  Compare les membres de deux structures Interseg. */
/***********************************************************************/
static int CompareOneInterseg(struct omf_interseg *interseg_1, struct omf_interseg *interseg_2, int interseg_num, int seg_num, int nb_global_diff)
{
  int nb_diff;

  /* Init */
  nb_diff = 0;

  /** On compare les membres **/
  if(interseg_1->ByteCnt != interseg_2->ByteCnt)
    {
      if(nb_global_diff > 0 && nb_diff == 0)
        printf("    --\n");
      printf("    Segment #%d Interseg #%04X [ByteCnt]         : %02X       - %02X\n",seg_num,interseg_num,interseg_1->ByteCnt,interseg_2->ByteCnt);
      nb_diff = 1;
    }

  if(interseg_1->BitShiftCnt != interseg_2->BitShiftCnt)
    {
      if(nb_global_diff > 0 && nb_diff == 0)
        printf("    --\n");
      printf("    Segment #%d Interseg #%04X [BitShiftCnt]     : %02X       - %02X\n",seg_num,interseg_num,interseg_1->BitShiftCnt,interseg_2->BitShiftCnt);
      nb_diff = 1;
    }

  if(interseg_1->OffsetPatch != interseg_2->OffsetPatch)
    {
      if(nb_global_diff > 0 && nb_diff == 0)
        printf("    --\n");
      printf("    Segment #%d Interseg #%04X [OffsetPatch]     : %04X     - %04X\n",seg_num,interseg_num,interseg_1->OffsetPatch,interseg_2->OffsetPatch);
      nb_diff = 1;
    }

  if(interseg_1->OffsetReference != interseg_2->OffsetReference)
    {
      if(nb_global_diff > 0 && nb_diff == 0)
        printf("    --\n");
      printf("    Segment #%d Interseg #%04X [OffsetReference] : %04X     - %04X\n",seg_num,interseg_num,interseg_1->OffsetReference,interseg_2->OffsetReference);
      nb_diff = 1;
    }

  if(interseg_1->FileNum != interseg_2->FileNum)
    {
      if(nb_global_diff > 0 && nb_diff == 0)
        printf("    --\n");
      printf("    Segment #%d Interseg #%04X [FileNum]         : %04X     - %04X\n",seg_num,interseg_num,interseg_1->FileNum,interseg_2->FileNum);
      nb_diff = 1;
    }

  if(interseg_1->SegNum != interseg_2->SegNum)
    {
      if(nb_global_diff > 0 && nb_diff == 0)
        printf("    --\n");
      printf("    Segment #%d Interseg #%04X [SegNum]          : %04X     - %04X\n",seg_num,interseg_num,interseg_1->SegNum,interseg_2->SegNum);
      nb_diff = 1;
    }

  /* Identique ? */
  return(nb_diff);
}

/************************************************************************/
