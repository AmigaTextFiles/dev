/* Copyright (c) 1990 Commodore-Amiga, Inc.
 *
 * This example is provided in electronic form by Commodore-Amiga, Inc. for
 * use with the 1.3 revisions of the Addison-Wesley Amiga reference manuals. 
 * The 1.3 Addison-Wesley Amiga Reference Manual series contains additional
 * information on the correct usage of the techniques and operating system
 * functions presented in this example.  The source and executable code of
 * this example may only be distributed in free electronic form, via bulletin
 * board or as part of a fully non-commercial and freely redistributable
 * diskette.  Both the source and executable code (including comments) must
 * be included, without modification, in any copy.  This example may not be
 * published in printed form or distributed with any commercial product.
 * However, the programming techniques and support routines set forth in
 * this example may be used in the development of original executable
 * software products for Commodore Amiga computers.
 * All other rights reserved.
 * This example is provided "as-is" and is subject to change; no warranties
 * are made.  All use is at your own risk.  No liability or responsibility
 * is assumed.
 */

/* A Simple program to show speech on the amiga.
 * If you do not define the flag FACE_ON, 
 * ALL code involved with reading mouth shapes is excluded.
 * If you do not define the flag PARSE,  ALL code involved
 * with parsing the command line is excluded, and defaults
 * are used. Code by Dave Lucas.
 *
 * Lattice use lc -b1 -cfist -v -y. Link with lc.lib and amiga.lib. 
 *
 *   FACE_ON      PARSE    ~Lines'o'Source    ~Executeable size
 *
 *      0           0         185                 8.8K
 *      0           1         360                10.7K
 *      1           0         355                10.4K
 *      1           1         540                12.3K
 */

#define FACE_ON
#define PARSE

#include <exec/types.h>
#include <exec/io.h>
#include <intuition/intuition.h>
#include <devices/narrator.h>
#include <libraries/translator.h>
#include <libraries/dos.h>

#include <proto/all.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef LATTICE
int CXBRK(void) { return(0); }  /* Disable Lattice CTRL/C handling */
int chkabort(void) { return(0); }  /* really */
#endif


/* The length of the English and phonetic buffers. */
#define ENGLISH_TEXT_LEN 25   /* Just long enough for default */
/* Input line is restricted to nnn chars (AmigaDOS), but */
#define PHONEME_TEXT_LEN 512  /* Phonemes are longer than English. */


void DrawFace(void);
void DrawMouth(USHORT half_w,USHORT half_h);
extern LONG ParseArgs (int argc, char **argv, UBYTE *show_face, UWORD *sex,
                    UWORD *inflect, UWORD *samp, UWORD *pitch, UWORD *speed,
                    UWORD *vol, char **text);
extern void BadOpt(char *option);
void CleanUp(void);

/* Which audio channels to use. */
BYTE audio_chan[] = {3, 5, 10, 12};

/* Pointer to translator library vectors. */
struct Library *TranslatorBase = NULL;

struct MsgPort write_port;
struct narrator_rb voice_io;

/* Indicative of the Open() return. */
UBYTE NarratorOpenError = -1;
/* Indicative of a Translations success. */
UBYTE TranslatorError = 0;

UBYTE EnglBuffer[ENGLISH_TEXT_LEN] = "This is amiga speaking.";
UBYTE PhonBuffer[PHONEME_TEXT_LEN] = "DHIHS IHZ AHMIY3GAH SPIY4KIHNX.";

struct IntuitionBase *IntuitionBase = NULL;
struct GfxBase *GfxBase = NULL;

#ifdef FACE_ON
/* Pen numbers to draw gadget borders/images/text with. */
#define REDP   3        /* Color in register 3 once was red. */
#define BLKP   2        /* Color in register 2 was black. */
#define WHTP   1        /* Color in register 1 was white. */
#define BLUP   0        /* Color in register 0 was blue. */

/* These are used for face rendering. */
#define FACE_ET     12 /* top of eyes */
#define FACE_EB     22 /* bottom of eyes */
#define FACE_LIP_T  23 /* top of mouth clear area */
#define FACE_MID_H  42 /* the middle of the mouth, heightwise */
#define FACE_H      80 /* overall window height */
#define FACE_ELL    24 /* left eye left side */
#define FACE_ELR    40 /* left eye right side */
#define FACE_INIT_W 32 /* left point for initial mouth line */
#define FACE_MID_W  56 /* the middle of the mouth, widthwise */
#define FACE_ERL    72 /* right eye left side */
#define FACE_ERR    88 /* right eye right side */
#define FACE_W     120 /* overall window width */

struct NewWindow NewFaceWindow =
{
   0, 11,               /* Start LeftEdge, TopEdge. */
   FACE_W, FACE_H,      /* Width, Height. */
   -1, -1,              /* DetailPen, BlockPen. */
   0,                   /* IDCMP FLAGS. */
   WINDOWDRAG | WINDOWDEPTH | GIMMEZEROZERO, /* Flags. */
   NULL,                /* No pointer to FirstGadget. */
   NULL,                /* No pointer to first CheckMark. */
   NULL,                /* No Title. */
   NULL,                /* No pointer to Screen. */
   NULL,                /* No pointer to BitMap. */
   FACE_W, FACE_H,      /* Minimum sizeable to (NA-not sizeable). */
   FACE_W, FACE_H,      /* Maximum sizeable to (NA-not sizeable). */
   WBENCHSCREEN         /* Type of screen window appears in. */
};

struct Window *FaceWindow = NULL;
struct IntuiMessage *MyIntuiMessage;

struct MsgPort read_port;
struct mouth_rb mouth_io;
#endif /* FACE_ON defined */

/** Start of code ***************************/
VOID main(int argc,char **argv)
{
    ULONG Signals;        /* Wait() tells me which to look at. */
    UBYTE *pp_string;
    UWORD rate, pitch, mode, sex, volume, sampfreq;
    UBYTE show_face = 0;
    /* Let CleanUp() know these signals not allocated yet. */
    write_port.mp_SigBit = -1;
#ifdef FACE_ON
    read_port.mp_SigBit = -1;
#endif /* FACE_ON defined */

    pp_string = &EnglBuffer[0];

    rate = DEFRATE;
    pitch = DEFPITCH;
    mode = DEFMODE;
    sex = DEFSEX;
    volume = DEFVOL;
    sampfreq = DEFFREQ;

#ifdef PARSE
    ParseArgs(argc, argv, &show_face, &sex, &mode, &sampfreq, &pitch, &rate,
     &volume, (APTR)&pp_string);
#endif /* PARSE defined */

    /* Open those libraries that the program uses directly. */
    if ((IntuitionBase = (struct IntuitionBase *)
     OpenLibrary("intuition.library", 33)) == NULL)
    {
        fprintf(stderr, "Can't open the intuition library\n");
        CleanUp();
        exit(RETURN_WARN);
    }

    if ((GfxBase = (struct GfxBase *)
     OpenLibrary("graphics.library", 33)) == NULL)
    {
        fprintf(stderr, "Can't open the graphics library\n");
        CleanUp();
        exit(RETURN_WARN);
    }

    if ((TranslatorBase =  (struct Library *)
     OpenLibrary("translator.library", 0L)) == NULL)
    {
        fprintf(stderr, "Can't open the translator library\n");
        CleanUp();
        exit(RETURN_WARN);
    }

    if ((TranslatorError = Translate((UBYTE *)pp_string,
     strlen(pp_string), (UBYTE *)PhonBuffer, PHONEME_TEXT_LEN)) != 0)
    {
        fprintf(stderr, "Translator won't. (%lx)\n",TranslatorError);
    }

    if ((NarratorOpenError =
     OpenDevice("narrator.device",0, (struct IORequest *) &voice_io, 0))!=0)
    {
        fprintf(stderr, "Can't open the narrator device\n");
        CleanUp();
        exit(RETURN_WARN);
    }

    /* Set up the write port, allocate the signal */
    /* and the message. */
    if ((write_port.mp_SigBit = AllocSignal(-1)) == -1)
    {
        fprintf(stderr, "Couldn't Allocate write Signal bit\n");
        CleanUp();
        exit(RETURN_WARN);
    }
    write_port.mp_Node.ln_Name = "speech_write";
    write_port.mp_Node.ln_Type = NT_MSGPORT;
    write_port.mp_Flags = PA_SIGNAL;
    write_port.mp_SigTask = (struct Task *)FindTask(NULL);

    NewList(&write_port.mp_MsgList);

    /* Set up the write channel information. */
    voice_io.message.io_Command = CMD_WRITE;
    voice_io.message.io_Offset = 0;
    voice_io.message.io_Data = (APTR)PhonBuffer;
    voice_io.message.io_Length = strlen(PhonBuffer);

    voice_io.message.io_Message.mn_Node.ln_Type = NT_MSGPORT;
    voice_io.message.io_Message.mn_Length = sizeof(voice_io);
    voice_io.message.io_Message.mn_ReplyPort = &write_port;
    voice_io.message.io_Unit = 0;

    voice_io.ch_masks = (UBYTE *)audio_chan;
    voice_io.nm_masks = sizeof(audio_chan);
    voice_io.mouths = show_face;
    voice_io.rate = rate;
    voice_io.pitch = pitch;
    voice_io.mode = mode;
    voice_io.sex = sex;
    voice_io.volume = volume;
    voice_io.sampfreq = sampfreq;

#ifdef FACE_ON
    if (show_face)
    {
        /* Set up the read port, allocate the signal */
        /* and the message. */
        read_port.mp_Node.ln_Type = NT_MSGPORT;
        read_port.mp_Flags = PA_SIGNAL;
        if ((read_port.mp_SigBit = AllocSignal(-1)) == -1)
        {
            fprintf(stderr, "Couldn't Allocate read Signal bit\n");
            CleanUp();
            exit(RETURN_WARN);
        }
        read_port.mp_SigTask = (struct Task *)FindTask(NULL);
        NewList(&read_port.mp_MsgList);

        /* Set up the read channel information. */
        mouth_io.voice = voice_io;
        mouth_io.width = 0;
        mouth_io.height = 0;
        mouth_io.voice.message.io_Message.mn_ReplyPort = &read_port;
        mouth_io.voice.message.io_Command = CMD_READ;
        mouth_io.voice.message.io_Error = 0;

        if ((FaceWindow = OpenWindow(&NewFaceWindow))
         == NULL)
        {
            fprintf(stderr, "Couldn't open the face window.\n");
            CleanUp();
            exit(RETURN_WARN);
        }
        DrawFace();
    }
#endif /* FACE_ON defined */

    SendIO((struct IORequest *) &voice_io );

#ifdef FACE_ON
    if (show_face)
    {
        SendIO((struct IORequest *) &mouth_io );
    }
#endif /* FACE_ON defined */

    /* Wait() lets the rest of the system run while */
    /* this program sleeps. */
    for (;;)
    {
#ifdef FACE_ON
        if (show_face)
            Signals = Wait(
          (1L << voice_io.message.io_Message.mn_ReplyPort->mp_SigBit)
        | (1L << mouth_io.voice.message.io_Message.mn_ReplyPort->mp_SigBit));
        else
#endif /* FACE_ON defined */
            Signals = Wait(
          (1L << voice_io.message.io_Message.mn_ReplyPort->mp_SigBit));

        /* A voice SendIO() (Write) has completed. */
        if (Signals & (1L <<
         voice_io.message.io_Message.mn_ReplyPort->mp_SigBit))
        {
            /* Was it Sucessful? filter out the abort error. */
            if (voice_io.message.io_Error == -2)
                voice_io.message.io_Error = 0;
            if (voice_io.message.io_Error != 0)
            {
                fprintf(stderr, "Narrator won't. (%ld)\n",
                 voice_io.message.io_Error);
                voice_io.message.io_Error = 0;
            }
            CleanUp();
            exit(RETURN_OK);
        }

#ifdef FACE_ON
        /* A mouth SendIO() (Read) has completed. */
        if (Signals & (1L <<
         mouth_io.voice.message.io_Message.mn_ReplyPort->mp_SigBit))
        {

            USHORT LipWidth, LipHeight;

            LipWidth = mouth_io.width << 2;
            LipHeight = mouth_io.height;

         DrawMouth(LipWidth, LipHeight);

            /* On occasion, the first request for a mouth shape is
             * handled before the narrator realizes it's speaking.
             * That's why this error is ignored.
             */
            if (mouth_io.voice.message.io_Error == ND_NoWrite)
                mouth_io.voice.message.io_Error = 0;

            if (mouth_io.voice.message.io_Error == 0)
             SendIO((struct IORequest *) &mouth_io );
            else
            {
                fprintf(stderr, "Narrator won't mouth. (%ld)\n",
                 mouth_io.voice.message.io_Error);
                CleanUp();
                exit(RETURN_WARN);
            }
        }
#endif /* FACE_ON defined */
    } /* The for will never exit through here, no CleanUp() needed. */
}  /* main */

    /* handle abort like this !!!! */
/*  AbortIO(&voice_io);
    voice_io.message.io_Error = 0;
    mouth_io.voice.message.io_Error = 0;
*/

#ifdef FACE_ON
void DrawFace(void)
{
    /* Set pen to White, fill whole window. */
    SetAPen(FaceWindow->RPort, WHTP);
    RectFill(FaceWindow->RPort, 0, 0, FACE_W, FACE_H);

    /* Set pen to Blue, do eyes. */
    SetAPen(FaceWindow->RPort, BLUP);
    RectFill(FaceWindow->RPort, FACE_ELL, FACE_ET, FACE_ELR, FACE_EB);
    RectFill(FaceWindow->RPort, FACE_ERL, FACE_ET, FACE_ERR, FACE_EB);

    /* Do gob. */
    DrawMouth(FACE_INIT_W, 1);
}
void DrawMouth(USHORT half_w,USHORT half_h)
{
    WaitBOVP(&FaceWindow->WScreen->ViewPort);

    /* Clear the entire mouth area. */
    SetAPen(FaceWindow->RPort, WHTP);
    RectFill(FaceWindow->RPort, 0, FACE_LIP_T, FACE_W, FACE_H);

    /* Draw a new mouth. */
    SetAPen(FaceWindow->RPort, REDP);

    Move(FaceWindow->RPort, FACE_MID_W - half_w, FACE_MID_H);
    Draw(FaceWindow->RPort, FACE_MID_W,          FACE_MID_H - half_h);
    Draw(FaceWindow->RPort, FACE_MID_W + half_w, FACE_MID_H);
    Draw(FaceWindow->RPort, FACE_MID_W,          FACE_MID_H + half_h);
    Draw(FaceWindow->RPort, FACE_MID_W - half_w, FACE_MID_H);
}
#endif /* FACE_ON defined */


#ifdef PARSE
/** ************************************************************************/
LONG
ParseArgs (int argc,
           char **argv,
           UBYTE *show_face,
           UWORD *sex,
           UWORD *inflect,
           UWORD *samp,
           UWORD *pitch,
           UWORD *speed,
           UWORD *vol,
           char **text)
{
    int len;

    argc--;
    argv++;

    while (argc > 0 && argv[0][0] == '-')
    {
    len = strlen(*argv);
    switch (argv[0][1])
    {
        case 'm':        /* -Male */
            if ((!strncmp(*argv, "-m", len)) ||
                (!strncmp(*argv, "-male", len)))
            {
                *sex = FEMALE;
            }
            else
            {
                BadOpt(*argv);
                return(1);
            }
            break;

        case 'f':        /* -face -Female */
            if ((!strncmp(*argv, "-f", len)) ||
                     (!strncmp(*argv, "-female", len)))
            {
                *sex = FEMALE;
            }
#ifdef FACE_ON
            else if (!strncmp(*argv, "-face", len))
            {
                *show_face = 1;
            }
#endif /* FACE_ON defined */
            else
            {
                BadOpt(*argv);
                return(1);
            }
            break;

        case 'r':        /* -Robotic */
            if ((!strncmp(*argv, "-r", len)) ||
                (!strncmp(*argv, "-robotic", len)))
            {
                    *inflect = ROBOTICF0;
            }
            else
            {
                BadOpt(*argv);
                return(1);
            }
            break;

        case 'n':        /* -Natural */
            if ((!strncmp(*argv, "-n", len)) ||
                (!strncmp(*argv, "-natural", len)))
            {
                    *inflect = NATURALF0;
            }
            else
            {
                BadOpt(*argv);
                return(1);
            }
            break;

        case 's':        /* -Speed <frequency> */
            if ((!strncmp(*argv, "-s", len)) ||
                (!strncmp(*argv, "-speed", len)))
            {
                argc--; argv++;
                *speed = atoi(*argv);
            }
            else
            {
                BadOpt(*argv);
                return(1);
            }
            break;

        case 'p':        /* -pitch <frequency> */
            if ((!strncmp(*argv, "-p", len)) ||
                (!strncmp(*argv, "-pitch", len)))
            {
                argc--; argv++;
                *pitch = atoi(*argv);
            }
            else
            {
                BadOpt(*argv);
                return(1);
            }
            break;

        case 'v':        /* -vol <level> */
            if ((!strncmp(*argv, "-v", len)) ||
                (!strncmp(*argv, "-vol", len)) ||
                (!strncmp(*argv, "-volume", len)))
            {
                argc--; argv++;
                *vol = atoi(*argv);
            }
            else
            {
                BadOpt(*argv);
                return(1);
            }
            break;

        default:
            BadOpt(*argv);
            return(1);
            break;

        }
        argc--; argv++;
    }

    /* The last arg is the English string to speak. */
    if (argc > 0)
    {
        *text = *argv;
    }

    if (argc > 1)
    {
        fprintf(stderr, "Arguments after text ignored.\n");
    }

    /* Narrator has it's limits, be sure to abide by them. */
    if (*speed > MAXRATE)
        *speed = MAXRATE;
    if (*speed < MINRATE)
        *speed = MINRATE;

    if (*pitch > MAXPITCH)
        *pitch = MAXPITCH;
    if (*pitch < MINPITCH)
        *pitch = MINPITCH;

    if (*samp > MAXFREQ)
        *samp = MAXFREQ;
    if (*samp < MINFREQ)
        *samp = MINFREQ;

    if (*vol > MAXVOL)
        *vol = MAXVOL;
    if (*vol < MINVOL)
        *vol = MINVOL;

}

void BadOpt(char *option)
{
    char *whoami;
    whoami = "sayit";

    fprintf(stderr, "%s: option \"%s\" not supported.\n", whoami, *option);
    fprintf(stderr, "Usage: %s\n", whoami); 
    fprintf(stderr, "  -m or -male   -f or -female\n");
    fprintf(stderr, "  -r or -robot  -n or -natural\n");
    fprintf(stderr, "  -s or -speed  <WPM 40-400>\n");
    fprintf(stderr, "  -p or -pitch  <65-320>\n");
    fprintf(stderr, "  -v or -volume <0-64>\n");
#ifdef FACE_ON
    fprintf(stderr, "  -face\n");
#endif /* FACE_ON defined */
    fprintf(stderr, "  [\"quoted text\"]\n");

    CleanUp();
}
#endif /* PARSE defined */

/* Deallocate any memory, and close all of the
 * windows/screens/devices/libraries in reverse order to
 * make things work smoothly. And be sure to check
 * that the open/allocation was successful before
 * closing/deallocating.
 */
void CleanUp(void)
{
   if (write_port.mp_SigBit != -1)
      FreeSignal(write_port.mp_SigBit);
#ifdef FACE_ON
   if (read_port.mp_SigBit != -1)
      FreeSignal(read_port.mp_SigBit);
   if (FaceWindow != NULL)
      CloseWindow(FaceWindow);
#endif /* FACE_ON defined */
   if (NarratorOpenError == 0)
      CloseDevice((struct IORequest *) &voice_io);
   if (TranslatorBase != NULL)
      CloseLibrary(TranslatorBase);
   if (GfxBase != NULL)
      CloseLibrary(GfxBase);
   if (IntuitionBase != NULL)
      CloseLibrary(IntuitionBase);
   return;
}
