/*
 * MAGIC - structures and definitions.
 *
 * Developed by Thomas Krehbiel
 * Nova Design, Inc.
 *
 * December, 1992
 *
 */

#ifndef MAGIC_MAGIC_H


#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_NODES_H
#include <exec/nodes.h>
#endif

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#ifndef EXEC_SEMAPHORES_H
#include <exec/semaphores.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif


#define MAGIC_NAME         "magic.library"


/*
 * Library base
 */
struct MagicBase {
   struct Library          LibNode;
   struct Task            *Server;           /* Server task */
   struct SignalSemaphore  Lock;             /* Lock on PI list */
   struct List             MagicImageList;   /* List of public images */
   struct MagicImage      *DefaultImage;     /* "Active" image */
   LONG                    Counter;          /* Name counter */
};


/*
 * MAGIC image definition
 */
struct MagicImage {

   struct Node             Node;

   char                    Name[128];     /* Image name for reference */

   ULONG                   Flags;         /* Various flags - see below */
   LONG                    Width;         /* Pixel width */
   LONG                    Height;        /* Pixel height */
   LONG                    Depth;         /* 8-bit planes (generally
                                             1 for greyscale and 3
                                             for color) */

   WORD                    AspectX,       /* Horizontal pixel aspect */
                           AspectY;       /* Vertical pixel aspect */

   WORD                    DPIX,          /* Horizontal dpi */
                           DPIY;          /* Vertical dpi */

   char                   *OwnerName;     /* Name of image's owner */

   LONG                    Reserved[7];

   UBYTE                  *Red,           /* Direct pointers to RGB planes */
                          *Green,         /* and alpha channel.  If these are */
                          *Blue,          /* NULL, a translation function */
                          *Alpha;         /* must be used instead */

   APTR                    ImageData;     /* Image data handle - only
                                             the owner of an image
                                             can mess with this. */

   /*
    * The following fields are PRIVATE!  Do not touch.
    */

   struct SignalSemaphore  Lock;          /* Semaphore for obtaining
                                             an exclusive write-lock on
                                             the image.  To prevent two
                                             tasks from writing to the
                                             image at the same time. */
   struct Task            *Owner;         /* Task owning this image. */
   struct MsgPort         *OwnerPort;     /* Owner's message port. */
   struct List             OpenList;      /* List of tasks that currently
                                             have access to this
                                             image. */
   LONG                    OpenCount;     /* Number of tasks (besides
                                             the owner) that currently
                                             have this image open. */

   int                   (*GetData)(struct PublicImage *, LONG, LONG, Tag *);
   int                   (*PutData)(struct PublicImage *, LONG, LONG, Tag *);

};

/*
 * MagicHandle - returned by OpenMagicImage()
 */
struct MagicHandle {
   struct Node             Node;
   UWORD                   Flags;         /* reserved */
   struct MagicImage      *Object;        /* Image that is opened */
   struct MsgPort         *Port;          /* Port to send messages
                                             about this image. */
};


/* Tags passed to AllocMagicImage(): */
enum AMI_Tags {
   AMI_Width = TAG_USER,
   AMI_Height,
   AMI_Depth,
   AMI_Name,
   AMI_ImageData,
   AMI_GetDataCode,
   AMI_PutDataCode,
   AMI_MsgPort,
   AMI_Red,
   AMI_Green,
   AMI_Blue,
   AMI_Alpha,
   AMI_AspectX,
   AMI_AspectY,
   AMI_DPIX,
   AMI_DPIY,
   AMI_OwnerName
};
#define AMI_Grey  AMI_Red

/* Tags passed to OpenMagicImage(): */
enum OMI_Tags {
   OMI_MsgPort = TAG_USER,    /* opener's should use this */
   OMI_OwnerPort,             /* owner's should use this instead */
};

/* Tags passed to GetMagicImageData() and PutMagicImageData(): */
enum GMI_Tags {
   GMI_Red = TAG_USER,  /* red bytes */
   GMI_Green,           /* green bytes */
   GMI_Blue,            /* blue bytes */
   GMI_RGB,             /* RGB bytes (requires 3 times storage!) */
   GMI_ARGB,            /* ARGB bytes (requires 4 times storage!) */
   GMI_Alpha,           /* alpha channel bytes */
   GMI_Mask             /* (reserved) */
};
#define GMI_Grey  GMI_Red

/* Lock types passed to [Attempt]LockMagicImage(): */
#define LMI_Read           1
#define LMI_Write          2

/* Tags passed to PickMagicImageA(): */
enum PMI_Tags {
   PMI_IncludeName = TAG_USER,
   PMI_ExcludeName,
   PMI_IncludeOwner,
   PMI_ExcludeOwner,
   PMI_MinWidth,
   PMI_MinHeight,
   PMI_MinDepth,
   PMI_MaxWidth,
   PMI_MaxHeight,
   PMI_MaxDepth,
   PMI_ShowSize,
   PMI_ShowOwner,
   PMI_All,
};

/*
 * Messages sent to OwnerPort, and/or to each opener.
 */
struct MagicMessage {
   struct Message          Msg;           /* Exec message */
   struct MagicImage      *Object;        /* Object of this message */
   LONG                    Action;        /* What to do */
   LONG                    Args[8];       /* Up to 8 parameters */
   LONG                    Result;        /* Result code */
   struct Task            *Server;        /* Server task - do not touch */
};

/* Message Actions */
enum Act_Tags {
   MMSG_KILLSERVER = 0,                   /* Server Private */
   MMSG_REDRAW,                           /* Redraw image */
   MMSG_TOFRONT,                          /* Bring interface to front */
   MMSG_UPDATE,                           /* Update size */
   MMSG_SAVEUNDO,                         /* Save a copy of buffer */
   MMSG_RESTOREUNDO,                      /* Restore undo buffer */
   MMSG_CLOSE,                            /* Closing an image */
};



#define MAGIC_MAGIC_H
#endif
