/************************************************************************/
/*                                                                      */
/*  OMF_Record.h : Header pour le décodage des Record des Segments OMF. */
/*                                                                      */
/************************************************************************/
/*  Auteur : Olivier ZARDINI  *  Brutal Deluxe Software  *  Avril 2013  */
/************************************************************************/

struct omf_body_record
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
  int length;

  void *record_data;

  int processed;              /* Flag interne */

  struct omf_body_record *next;
};

struct subrecord_SuperReloc2
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE Count;

  BYTE ByteCnt;          /* Number of Bytes to be relocated = Toujours à 2 */
  BYTE BitShiftCnt;      /* Opérations >> ou << = Toujours à 0  */

  int nb_address;
  WORD OffsetPatch[256];       /* HHLL :  : OffsetPatch = Offset of the first Byte to be Patched */
  WORD OffsetReference[256];   /* Adresse */  

  struct subrecord_SuperReloc2 *next;
};

struct subrecord_SuperReloc3
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE Count;

  BYTE ByteCnt;                /* Number of Bytes to be relocated = Toujours à 3 */
  BYTE BitShiftCnt;            /* Opérations >> ou << = Toujours à 0  */

  int nb_address;
  WORD OffsetPatch[256];       /* HHLL : OffsetPatch = Offset of the first Byte to be Patched */
  WORD OffsetReference[256];   /* Adresse */

  struct subrecord_SuperReloc3 *next;
};

struct subrecord_SuperInterseg1
{
  DWORD FileOffset;      /* Offset depuis le début du fichier */
  DWORD SegmentOffset;   /* Offset depuis le début du Segment */

  BYTE Count;

  BYTE ByteCnt;          /* Number of Bytes to be relocated = Toujours à 3 */
  BYTE BitShiftCnt;      /* Opérations >> ou << = Toujours à 0  */
  WORD FileNum;          /* File Number toujours à 1 */

  int nb_address;
  WORD OffsetPatch[256];     /* HHLL : OffsetPatch = Offset of the first Byte to be Patched */
  WORD OffsetReference[256];   /* Adresse */
  WORD SegNum[256];            /* Segment Number */
 

  struct subrecord_SuperInterseg1 *next;
};


struct subrecord_SuperInterseg212
{
  DWORD FileOffset;       /* Offset depuis le début du fichier */
  DWORD SegmentOffset;    /* Offset depuis le début du Segment */

  BYTE Count;

  BYTE ByteCnt;           /* Number of Bytes to be relocated = Toujours à 3 */
  BYTE BitShiftCnt;       /* Opérations >> ou << = Toujours à 0  */
  WORD FileNum;           /* File Number : 2-12 */

  int nb_address;
  WORD OffsetPatch[256];      /* HHLL  : OffsetPatch = Offset of the first Byte to be Patched */
  WORD OffsetReference[256];  /* Adresse */  
  WORD SegNum[256];           /* Segment Number */

  struct subrecord_SuperInterseg212 *next;
};


struct subrecord_SuperInterseg1324
{
  DWORD FileOffset;       /* Offset depuis le début du fichier */
  DWORD SegmentOffset;    /* Offset depuis le début du Segment */

  BYTE Count;

  BYTE ByteCnt;           /* Number of Bytes to be relocated = Toujours à 2 */
  BYTE BitShiftCnt;       /* Opérations >> ou << = Toujours à 0  */
  BYTE SegNum;            /* Segment Number 1-12 */
  WORD FileNum;           /* File Number toujours à 1 */

  int nb_address;
  WORD OffsetPatch[256];      /* HHLL  : OffsetPatch = Offset of the first Byte to be Patched */
  WORD OffsetReference[256];  /* Adresse */  

  struct subrecord_SuperInterseg1324 *next;
};


struct subrecord_SuperInterseg2536
{
  DWORD FileOffset;       /* Offset depuis le début du fichier */
  DWORD SegmentOffset;    /* Offset depuis le début du Segment */

  BYTE Count;

  BYTE ByteCnt;           /* Number of Bytes to be relocated = Toujours à 2 */
  BYTE BitShiftCnt;       /* Opérations >> ou << = Toujours à 0xF0  */
  BYTE SegNum;            /* Segment Number 1-12 */
  WORD FileNum;           /* File Number toujours à 1 */

  int nb_address;
  WORD OffsetPatch[256];      /* HHLL  : OffsetPatch = Offset of the first Byte to be Patched */
  WORD OffsetReference[256];  /* Adresse */  

  struct subrecord_SuperInterseg2536 *next;
};


struct record_END
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};


struct record_CONST
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;

  BYTE ByteCnt;
  unsigned char *data;
};

struct record_ALIGN
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_ORG
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_RELOC
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
  
  BYTE ByteCnt;           /* Number of Bytes to be relocated */
  BYTE BitShiftCnt;       /* Opérations >> ou << */
  DWORD OffsetPatch;      /* Offset of the first Byte to be Patched */
  DWORD OffsetReference;  /* Adresse */  
};

struct record_INTERSEG
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
  
  BYTE ByteCnt;           /* Number of Bytes to be relocated */
  BYTE BitShiftCnt;       /* Opérations >> ou << */
  DWORD OffsetPatch;      /* Offset of the first Byte to be Patched */
  WORD FileNum;           /* File Number */
  WORD SegNum;            /* Segment Number */
  DWORD OffsetReference;  /* Adresse */  
};

struct record_USING
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_STRONG
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_GLOBAL
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_GEQU
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_MEM
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_EXPR
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_ZEXPR
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_BEXPR
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_RELEXPR
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_LOCAL
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_EQU
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_DS
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_LCONST
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;

  DWORD ByteCnt;
  unsigned char *data;
};

struct record_LEXPR
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_ENTRY
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_cRELOC
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;

  BYTE ByteCnt;          /* Number of Bytes to be relocated */
  BYTE BitShiftCnt;      /* Opérations >> ou << */
  WORD OffsetPatch;      /* Offset of the first Byte to be Patched */
  WORD OffsetReference;  /* Adresse */
};

struct record_cINTERSEG
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;

  BYTE ByteCnt;          /* Number of Bytes to be relocated */
  BYTE BitShiftCnt;      /* Opérations >> ou << */
  WORD OffsetPatch;      /* Offset of the first Byte to be Patched */
  WORD FileNum;          /* File Number : toujours à 1 */
  BYTE SegNum;           /* Segment Number */
  WORD OffsetReference;  /* Adresse */
};

struct record_SUPER
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;

  DWORD ByteCnt;
  BYTE RecordType;

  /* SuperReloc2 */
  int nb_SuperReloc2;
  struct subrecord_SuperReloc2 *first_SuperReloc2;
  struct subrecord_SuperReloc2 *last_SuperReloc2;
  
  /* SuperReloc3 */
  int nb_SuperReloc3;
  struct subrecord_SuperReloc3 *first_SuperReloc3;
  struct subrecord_SuperReloc3 *last_SuperReloc3;

  /* SuperInterseg1 */
  int nb_SuperInterseg1;
  struct subrecord_SuperInterseg1 *first_SuperInterseg1;
  struct subrecord_SuperInterseg1 *last_SuperInterseg1;

  /* SuperInterseg 2-12 */
  int nb_SuperInterseg212;
  struct subrecord_SuperInterseg212 *first_SuperInterseg212;
  struct subrecord_SuperInterseg212 *last_SuperInterseg212;

  /* SuperInterseg 13-24 */
  int nb_SuperInterseg1324;
  struct subrecord_SuperInterseg1324 *first_SuperInterseg1324;
  struct subrecord_SuperInterseg1324 *last_SuperInterseg1324;

  /* SuperInterseg 25-36 */
  int nb_SuperInterseg2536;
  struct subrecord_SuperInterseg2536 *first_SuperInterseg2536;
  struct subrecord_SuperInterseg2536 *last_SuperInterseg2536;
};


struct record_General
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct record_Experimental
{
  DWORD FileOffset;            /* Offset depuis le début du fichier */
  DWORD SegmentOffset;         /* Offset depuis le début du Segment */

  BYTE operation_code;
};

struct omf_reloc
{
  BYTE ByteCnt;           /* Number of Bytes to be relocated (1,2,3 ou 4) */
  BYTE BitShiftCnt;       /* Opérations >> ou << */
  WORD OffsetPatch;       /* Offset of the first Byte to be Patched */
  WORD OffsetReference;   /* Adresse */  

  struct omf_reloc *next;
};

struct omf_interseg
{
  BYTE ByteCnt;           /* Number of Bytes to be relocated (1,2,3 ou 4) */
  BYTE BitShiftCnt;       /* Opérations >> ou << */
  WORD OffsetPatch;       /* Offset of the first Byte to be Patched */
  WORD OffsetReference;   /* Adresse */
  WORD FileNum;           /* File Number */
  WORD SegNum;            /* Segment Number */

  struct omf_interseg *next;
};


struct omf_body_record *DecodeOneRecord(unsigned char *,int,int,int,unsigned char *,int,int *);
char *GetRecordName(BYTE,BYTE);
char *GetSUPERType(BYTE);
void mem_free_record(struct omf_body_record *);

/************************************************************************/