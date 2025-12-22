
#define CODE_FORM (0x464F524DL)
#define CODE_BODY (0x424F4459L)
#define CODE_ILBM (0x494C424DL)
#define CODE_CAMG (0x43414D47L)
#define CODE_CMAP (0x434D4150L)
#define CODE_BMHD (0x424D4844L)
#define CODE_ANNO (0x414E4E4FL)
#define CODE_DRNG (0x44524E47L)

#define UNPACKSIZE 8192
#define BUFFERSIZE 4096

#define OSV_HIRES (1L<<15)
#define OSV_HAM   (1L<<11)
#define OSV_EHB   (1L<<10)
#define OSV_LACED (1L<<2)

extern struct SysObject *PicObject;
extern struct GVBase    *GVBase;
extern struct ModPublic *Public;

void FreeModule(void);
LONG UnpackPicture(struct Picture *, struct BMHD *, struct File *, LONG *CMAP, LONG CAMG);
WORD SkipLine(struct BMHD *BMHD, BYTE *BODY, struct File *File, struct Bitmap *ILBMBitmap, WORD BPos);
WORD UnpackPlane(struct BMHD *BMHD, struct File *File, struct Bitmap *ILBMBitmap, BYTE *Dest, BYTE *Buffer, WORD BufferPos);

LIBFUNC LONG PIC_CheckFile(mreg(__a0) struct File *, mreg(__a1) LONG *);
LIBFUNC void PIC_CopyToUnv(mreg(__a0) struct Universe *, mreg(__a1) struct Picture *);
LIBFUNC void PIC_CopyFromUnv(mreg(__a0) struct Universe *, mreg(__a1) struct Picture *);
LIBFUNC void PIC_Free(mreg(__a0) struct Picture *);
LIBFUNC struct Picture * PIC_Get(mreg(__a0) struct Picture *);
LIBFUNC LONG PIC_Init(mreg(__a0) struct Picture *);
LIBFUNC struct Picture * PIC_Load(mreg(__a0) APTR);
LIBFUNC LONG PIC_Query(mreg(__a0) struct Picture *);
LIBFUNC LONG PIC_Read(mreg(__a0) struct Picture *,  mreg(__a1) BYTE *, mreg(__d0) LONG);
LIBFUNC LONG PIC_SaveToFile(mreg(__a0) struct Picture *, mreg(__a1) struct File *);
LIBFUNC LONG PIC_Seek(mreg(__a0) struct Picture *,  mreg(__d0) LONG, mreg(__d1) WORD);
LIBFUNC LONG PIC_Write(mreg(__a0) struct Picture *, mreg(__a1) BYTE *, mreg(__d0) LONG);

struct BMHD {
  WORD  Width;       /* Picture width */
  WORD  Height;      /* Picture height */
  WORD  X;           /* ? */
  WORD  Y;           /* ? */
  BYTE  Depth;       /* Amount of planes */
  BYTE  Mask;        /* Masking technique in use */
  BYTE  Pack;        /* 1 if ByteRunOne, 0 if none */
  BYTE  PAD;         /* Empty */
  WORD  TColor;      /* Transparent colour number */
  BYTE  XAspect;     /* Pixel Width */
  BYTE  YAspect;     /* Height ratio */
  WORD  ScrWidth;    /* Screen/ViewPort Width */
  WORD  ScrHeight;   /* Screen/ViewPort Height */
};

