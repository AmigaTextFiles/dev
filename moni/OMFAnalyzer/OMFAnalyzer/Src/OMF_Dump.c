/************************************************************************/
/*                                                                      */
/*  OMF_Dump.c : Module pour le dump en format Text des fichiers OMF.   */
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

static void DumpSegmentHeader(struct omf_segment_header *,FILE *);
static char *GetSegmentType(WORD,int);
static char *GetSegmentAlign(DWORD);
static char *GetRecordList(struct omf_segment *);
static void DumpLCONSTRecord(struct omf_body_record *,FILE *,int);
static void DumpRELOCRecord(struct omf_body_record *,FILE *,int);
static void DumpcRELOCRecord(struct omf_body_record *,FILE *,int);
static void DumpINTERSEGRecord(struct omf_body_record *,FILE *,int);
static void DumpcINTERSEGRecord(struct omf_body_record *,FILE *,int);
static void DumpSUPERRecord(struct omf_body_record *,FILE *,int);

/****************************************************************************/
/*  CreateDumpFile() :  Création du fichier DUMP pour un fichier objet OMF. */
/****************************************************************************/
int CreateDumpFile(struct omf_file *current_file, char *file_path)
{
  int i, j, nb_item;
  FILE *fd;
  char bit_shift[256];
  char buffer[2048];
  struct omf_segment *current_segment;

  /* Création du fichier */
  fd = fopen(file_path,"w");
  if(fd == NULL)
    {
      printf("Error : Impossible to create output DUMP file '%s'.\n",file_path);
      return(1);
    }

  /* Information du fichier */
  fprintf(fd,"***************************\n");
  fprintf(fd,"**   File Information    **\n");
  fprintf(fd,"***************************\n\n");
  fprintf(fd,"     - File Name      :  '%s'\n",current_file->file_name);
  fprintf(fd,"     - Length         :  %06X (%d)\n",current_file->data_length,current_file->data_length);
  fprintf(fd,"     - Segment Number :  %02X (%d)\n\n",current_file->nb_segment,current_file->nb_segment);

  /** Segment Summary **/
  fprintf(fd,"***************************\n");
  fprintf(fd,"**    Segments Summary   **\n");
  fprintf(fd,"***************************\n\n");

  fprintf(fd,"       +----------+----------+-----------------+----------------+----------------+-------------+------------+--------------\n");
  fprintf(fd,"       |  Offset  |  SegNum  |     SegType     |     SegName    |    LoadName    |  SegLength  |  # Record  |  RecordList  \n");
  fprintf(fd,"       +----------+----------+-----------------+----------------+----------------+-------------+------------+--------------\n");
  for(current_segment=current_file->first_segment; current_segment; current_segment=current_segment->next)
    {
      /* Information du Segment */
      fprintf(fd,"       |  %06X  |    %02X    | %-15s |  %-12s  |  %-12s  |    %06X   |    %04X    |  %s\n",
              current_segment->header.FileOffset,current_segment->header.SegNum,GetSegmentType(current_segment->header.Kind,1),current_segment->header.SegName,
              current_segment->header.LoadName,current_segment->header.ByteCnt,current_segment->nb_record,GetRecordList(current_segment));
    }
  fprintf(fd,"       +----------+----------+-----------------+----------------+----------------+-------------+------------+--------------\n\n");

  /** Dump des Segments **/
  for(current_segment=current_file->first_segment; current_segment; current_segment=current_segment->next)
    {
      fprintf(fd,"***************************\n");
      fprintf(fd,"**      Segment %02X       **\n",current_segment->header.SegNum);
      fprintf(fd,"***************************\n\n");

      /** Header **/
      fprintf(fd,"  ***  Header  ***\n\n");
      DumpSegmentHeader(&current_segment->header,fd);

      /** Data / Code **/
      fprintf(fd,"  ***  Data or Code  ***\n\n");
      if(current_segment->lconst_length == 0)
        fprintf(fd,"       - No Data or Code record\n\n");
      else
        {
          fprintf(fd,"     - Length         :  %06X (%d)\n\n",current_segment->lconst_length,current_segment->lconst_length);
          for(i=0; i< (int) current_segment->lconst_length; i+=nb_item)
            {
              /* 1 Ligne de 32 bytes */
              nb_item = ((i+32) > (int) current_segment->lconst_length) ? (current_segment->lconst_length - i) : 32;
              for(j=0; j<nb_item; j++)
                {
                  sprintf(&buffer[j*3],"%02X",current_segment->lconst_data[i+j]);
                  strcat(buffer,(j == 15) ? "." : " ");
                }

              /* Dump dans le fichier */
              fprintf(fd,"       %06X   %s\n",i,buffer);
            }
        }
      fprintf(fd,"\n");

      /** Relocation dictionary **/
      if(current_segment->nb_reloc > 0 || current_segment->nb_interseg > 0)
        fprintf(fd,"  ***  Relocation Dictionary ***\n\n");

      /** RELOC **/
      if(current_segment->nb_reloc > 0)
        {
          fprintf(fd,"     - # Address to be patched  :  %04X (%d)\n\n",current_segment->nb_reloc,current_segment->nb_reloc);
          fprintf(fd,"       +--------+-----------+-------------+----------+-------------+\n");
          fprintf(fd,"       |    #   |  # Bytes  |  Bit Shift  |  Offset  |  Reference  |\n");
          fprintf(fd,"       +--------+-----------+-------------+----------+-------------+\n");
          for(i=0; i<current_segment->nb_reloc; i++)
            {
              /* Bit Shift en version Ascii */
              if(current_segment->tab_reloc[i]->BitShiftCnt == 0x00)
                strcpy(bit_shift,"     ");
              else if(current_segment->tab_reloc[i]->BitShiftCnt == 0xF8)   /* F8 = -8 */
                strcpy(bit_shift,">> 8 ");
              else if(current_segment->tab_reloc[i]->BitShiftCnt == 0xF0)   /* F0 = -16 */
                strcpy(bit_shift,">> 16");
              else
                sprintf(bit_shift," %02X  ",current_segment->tab_reloc[i]->BitShiftCnt);

              /* Ligne de Patch d'une adresse */
              fprintf(fd,"       |  %04X  |    %02X     |    %s    |   %04X   |    %04X     |\n",
                         i,
                         current_segment->tab_reloc[i]->ByteCnt,
                         bit_shift,
                         current_segment->tab_reloc[i]->OffsetPatch,
                         current_segment->tab_reloc[i]->OffsetReference);
            }
          fprintf(fd,"       +--------+-----------+-------------+----------+-------------+\n\n");
        }

      /** INTERSEG **/
      if(current_segment->nb_interseg > 0)
        {
          fprintf(fd,"     - # Address to be patched  :  %04X (%d)\n\n",current_segment->nb_interseg,current_segment->nb_interseg);
          fprintf(fd,"       +--------+-----------+-------------+----------+-------------+------------+-----------+\n");
          fprintf(fd,"       |    #   |  # Bytes  |  Bit Shift  |  Offset  |  Reference  |  File Num  |  Seg Num  |\n");
          fprintf(fd,"       +--------+-----------+-------------+----------+-------------+------------+-----------+\n");
          for(i=0; i<current_segment->nb_interseg; i++)
            {
              /* Bit Shift en version Ascii */
              if(current_segment->tab_interseg[i]->BitShiftCnt == 0x00)
                strcpy(bit_shift,"     ");
              else if(current_segment->tab_interseg[i]->BitShiftCnt == 0xF8)   /* -8 */
                strcpy(bit_shift,">> 8 ");
              else if(current_segment->tab_interseg[i]->BitShiftCnt == 0xF0)   /* -16 */
                strcpy(bit_shift,">> 16");
              else
                sprintf(bit_shift," %02X  ",current_segment->tab_interseg[i]->BitShiftCnt);

              /* Ligne de Patch d'une adresse */
              fprintf(fd,"       |  %04X  |    %02X     |    %s    |   %04X   |    %04X     |    %04X    |    %04X   |\n",
                         i,
                         current_segment->tab_interseg[i]->ByteCnt,
                         bit_shift,
                         current_segment->tab_interseg[i]->OffsetPatch,
                         current_segment->tab_interseg[i]->OffsetReference,
                         current_segment->tab_interseg[i]->FileNum,
                         current_segment->tab_interseg[i]->SegNum);
            }
          fprintf(fd,"       +--------+-----------+-------------+----------+-------------+------------+-----------+\n\n");
        }
    }

  /* Fermeture du fichier */
  fprintf(fd,"\n************************************************************************************************************\n");
  fclose(fd);

  /* OK */
  return(0);
}

/*
  BYTE record_super_type;
    struct omf_body_record *current_record;
for(i=1,current_record=current_segment->first_record; current_record; current_record=current_record->next,i++)
  {
    /* Information du Record *
    record_super_type = (current_record->operation_code == 0xF7) ? ((struct record_SUPER *)current_record->record_data)->RecordType : 0;
    fprintf(fd,"\n  %06X  %02X  %06X   Length=%04X   Record #%04X   Operation Code=%02X  %s\n",current_record->FileOffset,current_segment->header.SegNum,current_record->SegmentOffset,current_record->length,
                                                                                              i,current_record->operation_code,GetRecordName(current_record->operation_code,record_super_type));

    /* Détail du Record *
    if(current_record->operation_code == 0xE2)
      DumpRELOCRecord(current_record,fd,current_segment->header.SegNum);
    else if(current_record->operation_code == 0xE3)
      DumpINTERSEGRecord(current_record,fd,current_segment->header.SegNum);             
    else if(current_record->operation_code == 0xF2)
      DumpLCONSTRecord(current_record,fd,current_segment->header.SegNum);
    else if(current_record->operation_code == 0xF5)
      DumpcRELOCRecord(current_record,fd,current_segment->header.SegNum);
    else if(current_record->operation_code == 0xF6)
      DumpcINTERSEGRecord(current_record,fd,current_segment->header.SegNum);             
    else if(current_record->operation_code == 0xF7)
      DumpSUPERRecord(current_record,fd,current_segment->header.SegNum);                         
  }
*/

/********************************************************/
/*  DumpSegmentHeader() :  Dump le Header d'un Segment. */
/********************************************************/
static void DumpSegmentHeader(struct omf_segment_header *current_header, FILE *fd)
{
  fprintf(fd,"     - Segment Header size + Segment Body size               :  %06X %d\n",current_header->ByteCnt,current_header->ByteCnt);
  fprintf(fd,"     - Number of 0x00 to add at the end of the Segment Body  :  %06X %d\n",current_header->ResSpc,current_header->ResSpc);
  fprintf(fd,"     - Size of the Segment once loaded in Memory             :  %06X %d\n",current_header->Length,current_header->Length);
  fprintf(fd,"     - Undefined Byte #1 (usually set to 0x00)               :      %02X\n",current_header->undefine_1);
  fprintf(fd,"     - Label Length (usually set to 0x00 or 0x0A)            :      %02X\n",current_header->LabLen);
  fprintf(fd,"     - Number Length (usually set to 4 bytes)                :      %02X\n",current_header->NumLen);
  fprintf(fd,"     - Segment OMF Version (should be 0x02 for 2.1)          :      %02X\n",current_header->Version);
  fprintf(fd,"     - Bank Size (64 KB for Code, 0-64 KB for Data)          :  %06X %d\n",current_header->BankSize,current_header->BankSize);
  fprintf(fd,"     - Segment Type + Segment Attributes                     :    %04X = %s\n",current_header->Kind,GetSegmentType(current_header->Kind,0));
  fprintf(fd,"     - Undefined Byte #2 (usually set to 0x00)               :      %02X\n",current_header->undefine_2);
  fprintf(fd,"     - Undefined Byte #3 (usually set to 0x00)               :      %02X\n",current_header->undefine_3);
  fprintf(fd,"     - Org Address to load the Segment (0x0000 = anywhere)   :  %06X\n",current_header->Org);
  fprintf(fd,"     - Boundary for Segment Alignment (0, 0x100 or 0x010000) :  %06X = %s\n",current_header->Align,GetSegmentAlign(current_header->Align));
  fprintf(fd,"     - Order of the bytes in a Number (0x00 for the IIgs)    :      %02X\n",current_header->NumSEx);
  fprintf(fd,"     - Undefined Byte #4 (usually set to 0x00)               :      %02X\n",current_header->undefine_4);
  fprintf(fd,"     - Segment Number (1 to N)                               :    %04X %d\n",current_header->SegNum,current_header->SegNum);
  fprintf(fd,"     - Entry Point in the Segment                            :  %06X %d\n",current_header->EntryPointOffset,current_header->EntryPointOffset);
  fprintf(fd,"     - Load Name                                             :  '%s'\n",current_header->LoadName);
  fprintf(fd,"     - Segment Name                                          :  '%s'\n\n",current_header->SegName);
}


/*********************************************************************/
/*  GetSegmentType() :  Décode les différentes valeurs pour le Type. */
/*********************************************************************/
static char *GetSegmentType(WORD Type, int type_only)
{
  static char type_txt[1024];
  char attributes_txt[512] = "";

  /** Décode le Type + Attributs **/
  if((Type & 0x001F) == 0x0000)
    strcpy(type_txt,"Code");
  else if((Type & 0x001F) == 0x0001)
    strcpy(type_txt,"Data");
  else if((Type & 0x001F) == 0x0002)
    strcpy(type_txt,"Jump Table");
  else if((Type & 0x001F) == 0x0004)
    strcpy(type_txt,"PathName");
  else if((Type & 0x001F) == 0x0008)
    strcpy(type_txt,"Lib Dictionnary");
  else if((Type & 0x001F) == 0x0010)
    strcpy(type_txt,"Init");
  else if((Type & 0x001F) == 0x0012)
    strcpy(type_txt,"DP / Stack");
  else
    strcpy(type_txt,"Unknown Type");
  if(type_only == 1)
    return(&type_txt[0]);

  /** Attributs **/
  if((Type & 0x8000) == 0x0000)
    strcpy(attributes_txt,"Static");
  else
    strcpy(attributes_txt,"Dynamic");
  if((Type & 0x4000))
    strcat(attributes_txt," + Private");
  if((Type & 0x2000))
    strcat(attributes_txt," + Position independent");
  if((Type & 0x1000) == 0x0000)
    strcat(attributes_txt," + Can be loaded in Special Memory");
  if((Type & 0x0800))
    strcat(attributes_txt," + Absolute Bank");
  if((Type & 0x0400))
    strcat(attributes_txt," + Reload");
  if((Type & 0x0200))
    strcat(attributes_txt," + Skip");
  if((Type & 0x0100))
    strcat(attributes_txt," + Bank Relative");

  /* Ajoute les attributs */
  strcat(type_txt,"  (");
  strcat(type_txt,attributes_txt);
  strcat(type_txt,")");

  /* Renvoi le Texte */
  return(&type_txt[0]);
}


/***************************************************************************/
/*  GetSegmentAlign() :  Décode les différentes valeurs pour l'alignement. */
/***************************************************************************/
static char *GetSegmentAlign(DWORD Align)
{
  static char align_txt[256];

  /** Décode l'alignement **/
  if(Align == 0)
    strcpy(align_txt,"No alignment needed");
  else if(Align == 0x100)
    strcpy(align_txt,"Page boundary alignment");
  else if(Align == 0x010000)
    strcpy(align_txt,"Bank boundary alignment");
  else
    strcpy(align_txt,"Unknown alignment");

  /* Renvoi le Texte */
  return(&align_txt[0]);
}


/***************************************************************/
/*  GetRecordList() :  Extrait la liste des Record du Segment. */
/***************************************************************/
static char *GetRecordList(struct omf_segment *current_segment)
{
  int nb_found;
  struct omf_body_record *current_record;
  struct omf_body_record *next_record;
  static char record_list[2048];

  /* Init */
  strcpy(record_list,"");
  for(current_record=current_segment->first_record; current_record; current_record=current_record->next)
    current_record->processed = 0;

  /** Passe tous les Record en revue **/
  for(current_record=current_segment->first_record; current_record; current_record=current_record->next)
    {
      /* Déjà traitée ? */
      if(current_record->processed == 1)
        continue;

      /** Ajoute celui là **/
      if(strlen(record_list) > 0)
        strcat(record_list," + ");
      strcat(record_list,GetRecordName(current_record->operation_code,0xFF));
      current_record->processed = 1;

      /* Combien du même type ? */
      for(nb_found=1,next_record=current_record->next; next_record; next_record=next_record->next)
        if(next_record->processed == 0)
          if(next_record->operation_code == current_record->operation_code)
            {
              nb_found++;
              next_record->processed = 1;
            }

      /* On met le nombre si + de 1 */
      if(nb_found > 1)
        sprintf(&record_list[strlen(record_list)]," (%d)",nb_found);
    }

  /* Renvoie la liste */
  return(&record_list[0]);
}


/******************************************************************/
/*  DumpLCONSTRecord() :  Dump des informations du Record LCONST. */
/******************************************************************/
static void DumpLCONSTRecord(struct omf_body_record *current_record, FILE *fd, int segment_num)
{
  struct record_LCONST *current_LCONST;
  int i, j, nb_item;
  char buffer[2048];
  
  /* Récupère la structure dédiée */
  current_LCONST = (struct record_LCONST *) current_record->record_data;
  
  /** Dump les données en Hexa **/
  for(i=0; i< (int) current_LCONST->ByteCnt; i+=nb_item)
    {
      /* 1 Ligne de 32 bytes */
      nb_item = ((i+32) > (int) current_LCONST->ByteCnt) ? (current_LCONST->ByteCnt - i) : 32;
      for(j=0; j<nb_item; j++)
        {
          sprintf(&buffer[j*3],"%02X",current_LCONST->data[i+j]);
          strcat(buffer,(j == 15) ? "." : " ");
        }
        
      /* Dump dans le fichier */
      fprintf(fd,"  %06X  %02X  %06X  %06X   %s\n",current_LCONST->FileOffset+i,segment_num,current_LCONST->SegmentOffset+i,i,buffer);
    }
}


/****************************************************************/
/*  DumpRELOCRecord() :  Dump des informations du Record RELOC. */
/****************************************************************/
static void DumpRELOCRecord(struct omf_body_record *current_record, FILE *fd, int segment_num)
{
  struct record_RELOC *current_RELOC;
  
  /* Récupère la structure dédiée */
  current_RELOC = (struct record_RELOC *) current_record->record_data;
  
  /** Dump les données **/
  fprintf(fd,"       # Byte to be relocated = %02X,   Bit Shift = %02X,   Offset Patch = %08X,   Reference = %08X\n",
             current_RELOC->ByteCnt,current_RELOC->BitShiftCnt,current_RELOC->OffsetPatch,current_RELOC->OffsetReference);
}


/******************************************************************/
/*  DumpcRELOCRecord() :  Dump des informations du Record cRELOC. */
/******************************************************************/
static void DumpcRELOCRecord(struct omf_body_record *current_record, FILE *fd, int segment_num)
{
  struct record_cRELOC *current_cRELOC;
  
  /* Récupère la structure dédiée */
  current_cRELOC = (struct record_cRELOC *) current_record->record_data;
  
  /** Dump les données **/
  fprintf(fd,"       # Byte to be relocated = %02X,   Bit Shift = %02X,   Offset Patch = %04X,   Reference = %04X\n",
             current_cRELOC->ByteCnt,current_cRELOC->BitShiftCnt,current_cRELOC->OffsetPatch,current_cRELOC->OffsetReference);
}


/**********************************************************************/
/*  DumpINTERSEGRecord() :  Dump des informations du Record INTERSEG. */
/**********************************************************************/
static void DumpINTERSEGRecord(struct omf_body_record *current_record, FILE *fd, int segment_num)
{
  struct record_INTERSEG *current_INTERSEG;
  
  /* Récupère la structure dédiée */
  current_INTERSEG = (struct record_INTERSEG *) current_record->record_data;
  
  /** Dump les données **/
  fprintf(fd,"       # Byte to be relocated = %02X,   Bit Shift = %02X,   Offset Patch = %08X,   Reference = %08X,   File Number = %04X,   Segment Number = %04X\n",
             current_INTERSEG->ByteCnt,current_INTERSEG->BitShiftCnt,current_INTERSEG->OffsetPatch,current_INTERSEG->OffsetReference,current_INTERSEG->FileNum,current_INTERSEG->SegNum);
}


/************************************************************************/
/*  DumpcINTERSEGRecord() :  Dump des informations du Record cINTERSEG. */
/************************************************************************/
static void DumpcINTERSEGRecord(struct omf_body_record *current_record, FILE *fd, int segment_num)
{
  struct record_cINTERSEG *current_cINTERSEG;
  
  /* Récupère la structure dédiée */
  current_cINTERSEG = (struct record_cINTERSEG *) current_record->record_data;
  
  /** Dump les données **/
  fprintf(fd,"       # Byte to be relocated = %02X,   Bit Shift = %02X,   Offset Patch = %04X,   Reference = %04X,   Segment Number = %02X\n",
             current_cINTERSEG->ByteCnt,current_cINTERSEG->BitShiftCnt,current_cINTERSEG->OffsetPatch,current_cINTERSEG->OffsetReference,current_cINTERSEG->SegNum);
}


/****************************************************************/
/*  DumpSUPERRecord() :  Dump des informations du Record SUPER. */
/****************************************************************/
static void DumpSUPERRecord(struct omf_body_record *current_record, FILE *fd, int segment_num)
{
  int i;
  struct record_SUPER *current_SUPER;
  struct subrecord_SuperReloc2 *current_SuperReloc2;
  struct subrecord_SuperReloc3 *current_SuperReloc3;
  struct subrecord_SuperInterseg1 *current_SuperInterseg1;
  struct subrecord_SuperInterseg212 *current_SuperInterseg212;
  struct subrecord_SuperInterseg1324 *current_SuperInterseg1324;
  struct subrecord_SuperInterseg2536 *current_SuperInterseg2536;

  /* Récupère la structure dédiée */
  current_SUPER = (struct record_SUPER *) current_record->record_data;
    
  /** On Dump le contenu **/
  if(current_SUPER->RecordType == 0x00)    /* SuperReloc2 */
    {
      for(current_SuperReloc2=current_SUPER->first_SuperReloc2; current_SuperReloc2; current_SuperReloc2=current_SuperReloc2->next)
        for(i=0; i<current_SuperReloc2->nb_address; i++)
          fprintf(fd,"       # Byte to be relocated = %02X,   Bit Shift = %02X,   Offset Patch = %04X,   Reference = %04X\n",
                     current_SuperReloc2->ByteCnt,
                     current_SuperReloc2->BitShiftCnt,
                     current_SuperReloc2->OffsetPatch[i],
                     current_SuperReloc2->OffsetReference[i]);
    }
  else if(current_SUPER->RecordType == 0x01)    /* SuperReloc3 */
    {
      for(current_SuperReloc3=current_SUPER->first_SuperReloc3; current_SuperReloc3; current_SuperReloc3=current_SuperReloc3->next)
        for(i=0; i<current_SuperReloc3->nb_address; i++)
          fprintf(fd,"       # Byte to be relocated = %02X,   Bit Shift = %02X,   Offset Patch = %04X,   Reference = %04X\n",
                     current_SuperReloc3->ByteCnt,
                     current_SuperReloc3->BitShiftCnt,
                     current_SuperReloc3->OffsetPatch[i],
                     current_SuperReloc3->OffsetReference[i]);
    }
  else if(current_SUPER->RecordType == 0x02)    /* Super Interseg1 */
    {
      for(current_SuperInterseg1=current_SUPER->first_SuperInterseg1; current_SuperInterseg1; current_SuperInterseg1=current_SuperInterseg1->next)
        for(i=0; i<current_SuperInterseg1->nb_address; i++)
          fprintf(fd,"       # Byte to be relocated = %02X,   Bit Shift = %02X,   Offset Patch = %04X,   Reference = %04X,   Segment Number = %04X,   File Number = %04X\n",
                     current_SuperInterseg1->ByteCnt,
                     current_SuperInterseg1->BitShiftCnt,
                     current_SuperInterseg1->OffsetPatch[i],
                     current_SuperInterseg1->OffsetReference[i],
                     current_SuperInterseg1->SegNum[i],
                     current_SuperInterseg1->FileNum);
    }
  else if(current_SUPER->RecordType >= 0x03 && current_SUPER->RecordType <= 0x0D)    /* Super Interseg 2-12 */
    {
      for(current_SuperInterseg212=current_SUPER->first_SuperInterseg212; current_SuperInterseg212; current_SuperInterseg212=current_SuperInterseg212->next)
        for(i=0; i<current_SuperInterseg212->nb_address; i++)
          fprintf(fd,"       # Byte to be relocated = %02X,   Bit Shift = %02X,   Offset Patch = %04X,   Reference = %02X,   Segment Number = %04X,   File Number = %04X\n",
                     current_SuperInterseg212->ByteCnt,
                     current_SuperInterseg212->BitShiftCnt,
                     current_SuperInterseg212->OffsetPatch[i],
                     current_SuperInterseg212->OffsetReference[i],
                     current_SuperInterseg212->SegNum[i],
                     current_SuperInterseg212->FileNum);
    }
  else if(current_SUPER->RecordType >= 0x0E && current_SUPER->RecordType <= 0x19)    /* Super Interseg 13-24 */
    {
      for(current_SuperInterseg1324=current_SUPER->first_SuperInterseg1324; current_SuperInterseg1324; current_SuperInterseg1324=current_SuperInterseg1324->next)
        for(i=0; i<current_SuperInterseg1324->nb_address; i++)
          fprintf(fd,"       # Byte to be relocated = %02X,   Bit Shift = %02X,   Offset Patch = %04X,   Reference = %04X,   Segment Number = %02X,   File Number = %04X\n",
                     current_SuperInterseg1324->ByteCnt,
                     current_SuperInterseg1324->BitShiftCnt,
                     current_SuperInterseg1324->OffsetPatch[i],
                     current_SuperInterseg1324->OffsetReference[i],
                     current_SuperInterseg1324->SegNum,
                     current_SuperInterseg1324->FileNum); 
  }
  else if(current_SUPER->RecordType >= 0x1A && current_SUPER->RecordType <= 0x25)    /* Super Interseg 25-36 */
    {
      for(current_SuperInterseg2536=current_SUPER->first_SuperInterseg2536; current_SuperInterseg2536; current_SuperInterseg2536=current_SuperInterseg2536->next)
        for(i=0; i<current_SuperInterseg2536->nb_address; i++)
          fprintf(fd,"       # Byte to be relocated = %02X,   Bit Shift = %02X,   Offset Patch = %04X,   Reference = %04X,   Segment Number = %02X,   File Number = %04X\n",
                     current_SuperInterseg2536->ByteCnt,
                     current_SuperInterseg2536->BitShiftCnt,
                     current_SuperInterseg2536->OffsetPatch[i],
                     current_SuperInterseg2536->OffsetReference[i],
                     current_SuperInterseg2536->SegNum,
                     current_SuperInterseg2536->FileNum);
    }
}

/************************************************************************/
