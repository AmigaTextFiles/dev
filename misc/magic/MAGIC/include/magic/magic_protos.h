#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif


struct MagicImage      *AllocMagicImageA (Tag *);
void                    FreeMagicImage (struct MagicImage *);
BOOL                    AddMagicImage (struct MagicImage *);
BOOL                    RemMagicImage (struct MagicImage *);
struct MagicHandle     *OpenMagicImageA (struct MagicImage *, char *, Tag *);
BOOL                    CloseMagicImage (struct MagicHandle *);
BOOL                    LockMagicImage (struct MagicHandle *, LONG);
BOOL                    AttemptLockMagicImage (struct MagicHandle *, LONG);
void                    UnlockMagicImage (struct MagicHandle *);
BOOL                    GetMagicImageDataA (struct MagicHandle *, LONG, LONG, Tag *);
BOOL                    PutMagicImageDataA (struct MagicHandle *, LONG, LONG, Tag *);
BOOL                    IsMagicMessage (struct Message *);
void                    CycleMagicImage (struct MagicHandle *);
void                    RedrawMagicImage (struct MagicHandle *, LONG, LONG, LONG, LONG);
void                    UpdateMagicImage (struct MagicHandle *);
BOOL                    SaveMagicImage (struct MagicHandle *, LONG, LONG, LONG, LONG);
BOOL                    RestoreMagicImage (struct MagicHandle *);
BOOL                    SetDefaultMagicImage (struct MagicImage *);
struct MagicImage      *PickMagicImageA (struct Screen *, Tag *);

struct MagicImage      *AllocMagicImage (Tag, ...);
struct MagicHandle     *OpenMagicImage (struct MagicImage *, char *, Tag, ...);
BOOL                    GetMagicImageData (struct MagicHandle *, LONG, LONG, Tag, ...);
BOOL                    PutMagicImageData (struct MagicHandle *, LONG, LONG, Tag, ...);
struct MagicImage      *PickMagicImage (struct Screen *, Tag, ...);

