/* Date Requester Package
 * Filename:    MRDateReq.c
 * Author:      Mark R. Rinfret
 * Description:
 *
 * This package contains an ARP-compatible (dependent) date requester.
 * The primary function, MRDateRequest(), displays a requester in the
 * caller's window and allows the user to interactively enter/edit the
 * date value. All information is passed via a pointer to a special
 * packet structure.
 *
 * This code is not entirely reentrant. In order to accomplish this, 
 * the requester and associated gadgets would have to be duplicated and
 * a method for obtaining gadget pointers from gadget ID's implemented.
 * If someone wants to put this in a shared library, that, at a minimum
 * must be done.
 *      
 * 09/01/89 -MRR- Rewritten to use ARP date functions; new requester layout.
 *
 */

#include <exec/memory.h>
#include <intuition/intuition.h> 
#include <intuition/intuitionbase.h> 
#include <libraries/dosextens.h>
#include <libraries/arpbase.h>
#include <graphics/gfxbase.h> 
#include <graphics/gfx.h> 
#include <graphics/display.h> 

#include <graphics/text.h> 
#include <functions.h>
#include <arpfunctions.h>

#include <ctype.h>
#include "MRDates.h"
#include "MRGadgets.h"
#include "MRDateReq.h"

/*==================================================================*/

#define SetImageData(img, dat) ((struct Image *)(img))->ImageData = dat
#define daterequest             RequesterStructure1

#define UP_MONTH_GADGET         1
#define UP_DAY_GADGET           2   
#define UP_YEAR_GADGET          3
#define UP_HOUR_GADGET          4
#define UP_MINUTE_GADGET        5
#define UP_SECOND_GADGET        6
#define DOWN_MONTH_GADGET       7
#define DOWN_DAY_GADGET         8
#define DOWN_YEAR_GADGET        9
#define DOWN_HOUR_GADGET        10
#define DOWN_MINUTE_GADGET      11
#define DOWN_SECOND_GADGET      12
#define NOW_GADGET              13
#define ZERO_GADGET             14
#define OK_GADGET               15
#define CANCEL_GADGET           16
#define YEAR_GADGET             17
#define MONTH_GADGET            18
#define DAY_GADGET              19
#define HOUR_GADGET             20
#define MINUTE_GADGET           21
#define SECOND_GADGET           22
#define DATE_FORMAT_GADGET      23
#define DATE_GADGET             24
#define TIME_GADGET             25
#define DAYNAME_GADGET          26
#define WEEK_PLUS_GADGET        27
#define WEEK_MINUS_GADGET       28
#define PROMPT_GADGET           29


#include "MRDateReq.pw.c"

static void RedrawDateRequester();

#define MAX_DATE_FORMAT     3

static char *dateFormats[FORMAT_MAX+1] = {
    "DD-MMM-YY",    /* FORMAT_DOS */
    "YY-MM-DD",     /* FORMAT_INT */
    "MM-DD-YY",     /* FORMAT_USA */
    "DD-MM-YY"      /* FORMAT_CDN */
    };

/*===================================================================*/

/*  FUNCTION
        DupImage - duplicate an image into CHIP ram.

    SYNOPSIS
        static USHORT *DupImage(theImage, imageSize)
                                struct Image   *theImage;
                                long           *imageSize;

    DESCRIPTION
        DupImage calculates the size of the imageData required by
        <theImage> and stores this value into the variable pointed to
        by <imageSize>. It then attempts to allocate memory for the 
        image in CHIP ram. If the allocation is successful, the image
        data is copied and the pointer to the CHIP copy is returned.
        If the allocation fails, NULL is returned.

        DupImage is "smart" about the duplication process. It uses the 
        PlanePick field of <theImage> to determine how many planes of 
        data are actually present in <theImage>.
*/
static USHORT *
DupImage(theImage, imageSize)
    struct Image    *theImage;
    ULONG           *imageSize;
{
    USHORT  mask;
    USHORT  *newImageData = NULL;
    long    planeSize, totalSize = 0;

    if (theImage) {
        /* The size of a plane is
            the number of 16 bit words of width times
            the number of pixels of height times
            the number of bytes per 16 bit word (USHORT).
        */
        planeSize = (ULONG)
        ( ( (theImage->Width + 15L) >> 4L) * 
             theImage->Height * sizeof(USHORT) );
        for (mask = 1L; mask; mask <<= 1L) {
            if (theImage->PlanePick & mask)
                totalSize += planeSize;
        }
    }
    if (*imageSize = totalSize) {
        newImageData = (USHORT *) AllocMem(totalSize, MEMF_CHIP);
        if (newImageData)
            CopyMem(theImage->ImageData, newImageData, totalSize);
    }
    return newImageData;
}

/*  FUNCTION
        FreeMRDatePacket - free memory allocated to an MRDatePacket.

    SYNOPSIS
        void FreeMRDatePacket(thePacket)
                    MRDatePacket *thePacket;

    DESCRIPTION
        FreeMRDatePacket simply frees the memory allocated to an
        MRDateRequest packet, specified by <thePacket>.
*/

void
FreeMRDatePacket(thePacket)
    MRDatePacket *thePacket;
{
    if (thePacket->myStrings) {     /* Did I allocate the strings? */
        if (thePacket->ARPDatePacket.dat_StrDay)
            FreeMem(thePacket->ARPDatePacket.dat_StrDay, LEN_DATSTRING);
        if (thePacket->ARPDatePacket.dat_StrDate)
            FreeMem(thePacket->ARPDatePacket.dat_StrDate, LEN_DATSTRING);
        if (thePacket->ARPDatePacket.dat_StrTime)
            FreeMem(thePacket->ARPDatePacket.dat_StrTime, LEN_DATSTRING);
    }
    FreeMem(thePacket, (long) sizeof(*thePacket));
}

/*  FUNCTION
        CreateMRDatePacket - allocate and initialize an MRDatePacket.

    SYNOPSIS
        MRDatePacket *CreateMRDatePacket(theDate, theFormat, makeStrings)
                                        struct DateStamp *theDate;
                                        int              theFormat;
                                        int              makeStrings;

    DESCRIPTION
        InitMRDateRequest() allocates an MRDateRequest packet and initializes
        several of its fields. <theDate> may be a pointer to a DateStamp 
        structure containing the initial (default) date value or it may be
        NULL. If NULL, the current date and time are used as the default.
        <theFormat> is expected to be a value in the range of 0 through
        FORMAT_MAX, as defined in <libraries/arpbase.h>, and is the desired
        date format. If <makeStrings> is non-zero, CreateMRDatePacket() also 
        allocates the strings for the string fields in the embedded
        ARPDatePacket.

        A pointer to an MRDateRequest packet is returned if successful. 
        Otherwise, NULL is returned, indicating an out-of-memory
        condition.
*/
MRDatePacket *
CreateMRDatePacket(theDate, theFormat, makeStrings)
    struct DateStamp *theDate; 
    int theFormat, makeStrings;
{
    MRDatePacket    *dr;

    dr = (MRDatePacket *) AllocMem((long)sizeof(*dr), MEMF_CLEAR);
    if (dr) {
        if ( (theFormat < 0) || (theFormat > FORMAT_MAX))
            theFormat = FORMAT_USA;
        dr->ARPDatePacket.dat_Format = theFormat;
        dr->requester = &daterequest;
        if (theDate)
            dr->ARPDatePacket.dat_Stamp = *theDate;
        else
            DateStamp(&dr->ARPDatePacket.dat_Stamp);
        DSToDate(&dr->ARPDatePacket.dat_Stamp, &dr->newDate);
        if (dr->newDate.Dyear == 0) {
            dr->newDate.Dyear = 1978;
            DateToDS(&dr->newDate, &dr->ARPDatePacket.dat_Stamp);
        }
        if (makeStrings) {
            dr->myStrings = 1;
            dr->ARPDatePacket.dat_StrDay = (BYTE *)
                AllocMem(LEN_DATSTRING, MEMF_CLEAR);
            dr->ARPDatePacket.dat_StrDate = (BYTE *)
                AllocMem(LEN_DATSTRING, MEMF_CLEAR);
            dr->ARPDatePacket.dat_StrTime = (BYTE *)
                AllocMem(LEN_DATSTRING, MEMF_CLEAR);

            if ((dr->ARPDatePacket.dat_StrDay == NULL) ||
                (dr->ARPDatePacket.dat_StrDate == NULL) ||
                (dr->ARPDatePacket.dat_StrTime == NULL)) {
                FreeMRDatePacket(dr);
                dr = NULL;
            }
        }
    }
    return dr;
}

/*  FUNCTION
        MRDateRequest - request a date from the user.

    SYNOPSIS
        int MRDateRequest(datePacket)
                MRDatePacket *datePacket;
    DESCRIPTION
        Prior to calling MRDateRequest(), the caller must allocate the
        <datePacket> and initialize the following <datePacket> fields:
            ARPDatePacket.dat_Stamp     - the initial date value
            ARPDatePacket.dat_Format    - one of the ARP date format values
            prompt                      - a short prompt string
            window                      - window in which requester will
                                          appear

        Part of this initialization can be performed by InitMRDateRequest().

        A requester will be created and initialized with the values
        provided by the user. The user may then interact with the requester
        to specify a new date. Upon return, the following fields of
        <datePacket->ARPDatePacket> will be meaningful:
            dat_Format      - contains final date format
            dat_Stamp       - contains return date value (DateStamp)

        In addition, the following fields of <datePacket> contain info:
            newDate         - contains date in MRDate format
            status          - 0 = OK, 1 => error or CANCEL  
            
 */
int
MRDateRequest(datePacket)
    MRDatePacket    *datePacket;
{
#define MYFLAGS (REQSET | GADGETUP | GADGETDOWN)

    ULONG           class;          /* message class */
    USHORT          code;           /* message code */
    struct Gadget   *gadget;        /* pointer to gadget affected */
    USHORT          gadgid;         /* gadget ID */
    USHORT          i;
    USHORT          *downImage = NULL, *upImage = NULL;
    LONG            downImageSize, upImageSize;
    struct Image    *image;
    struct IntuiMessage *msg;       /* Intuition message pointer */
    ULONG           IDCMPFlags;     /* current IDCMP flags */
    BOOL            ready;
    BOOL            redraw;         /* TRUE => redraw requester */
    USHORT          *saveDownImage, *saveUpImage;
    LONG            value;
    SHORT           x,y;            /* mouse x and y position */

    if ( (datePacket->ARPDatePacket.dat_Format < 0) ||
         (datePacket->ARPDatePacket.dat_Format > FORMAT_MAX) )
        datePacket->ARPDatePacket.dat_Format = FORMAT_DOS;

    saveDownImage = GadgetImageData(&downYearGadget);
    saveUpImage = GadgetImageData(&upYearGadget);
    downImage = DupImage(downYearGadget.GadgetRender, &downImageSize);
    if (downImage) {
        image = (struct Image *) downYearGadget.GadgetRender;
        SetImageData(image, downImage);   
        downMonthGadget.GadgetRender = (APTR) image;
        downDayGadget.GadgetRender = (APTR) image;
        downHourGadget.GadgetRender = (APTR) image;
        downMinuteGadget.GadgetRender = (APTR) image;
        downMinuteGadget.GadgetRender = (APTR) image;
        downSecondGadget.GadgetRender = (APTR) image; 
    }
    upImage = DupImage(upYearGadget.GadgetRender, &upImageSize);
    if (upImage) {
        image = (struct Image *) upYearGadget.GadgetRender;
        SetImageData(image, upImage);
        upMonthGadget.GadgetRender = (APTR) image;
        upDayGadget.GadgetRender = (APTR) image;
        upHourGadget.GadgetRender = (APTR) image;
        upMinuteGadget.GadgetRender = (APTR) image;
        upMinuteGadget.GadgetRender = (APTR) image;
        upSecondGadget.GadgetRender = (APTR) image; 
    }
    datePacket->status = 0;
    daterequest.BackFill = 0;
    /* Make sure that the requester's window can see a REQSET message.
     * This allows us to ignore messages until our requester is up.
     */
    IDCMPFlags = datePacket->window->IDCMPFlags;
    ModifyIDCMP(datePacket->window, IDCMPFlags | MYFLAGS);
    if (! Request(&daterequest, datePacket->window)) {
        datePacket->status = 1;
        goto done;
    }
    SetBPen(daterequest.ReqLayer->rp, 1L);
    SetStringGadget(&promptGadget, datePacket->window,
                    datePacket->requester, datePacket->prompt);

    datePacket->requester = &daterequest;
    DSToDate(&datePacket->ARPDatePacket.dat_Stamp, &datePacket->newDate);
    RedrawDateRequester(datePacket);

    for (ready = 0; ! ready ;) {    /* Wait for REQSET message. */
        Wait(1L << datePacket->window->UserPort->mp_SigBit);
        while (msg = (struct IntuiMessage *)
            GetMsg(datePacket->window->UserPort)) {
            if (msg->Class == REQSET) ready = 1;
            ReplyMsg(msg);
        }
    }

    for (;;) {
        Wait(1L << datePacket->window->UserPort->mp_SigBit);
        while (msg = (struct IntuiMessage *) 
                    GetMsg(datePacket->window->UserPort)) {
            class = msg->Class;
            code = msg->Code;
            gadget = (struct Gadget *) msg->IAddress;
            x = msg->MouseX;
            y = msg->MouseY;
            ReplyMsg(msg);      /* acknowledge the message */

            redraw = TRUE;          /* Assume a redraw will be needed. */
            switch (class) {

#ifdef undef
            case REQSET: 
                redraw = FALSE;
                break;
#endif
#ifdef undef
            case GADGETDOWN:
                gadgid = gadget->GadgetID;
                switch (gadgid) {
                default:
                    break;
                }
                break;
#endif
            case GADGETUP:
                gadgid = gadget->GadgetID;
                switch (gadgid) {
                case NOW_GADGET:
                    DateStamp(&datePacket->ARPDatePacket.dat_Stamp);
                    DSToDate(&datePacket->ARPDatePacket.dat_Stamp, 
                             &datePacket->newDate);
                    break;

                case ZERO_GADGET:
                    setmem(&datePacket->newDate, 
                           sizeof(datePacket->newDate), 0);
                    datePacket->newDate.Dmonth = 1;
                    datePacket->newDate.Dday = 1;
                    break;

                case WEEK_PLUS_GADGET:
                    datePacket->ARPDatePacket.dat_Stamp.ds_Days += 7;
                    DSToDate(&datePacket->ARPDatePacket.dat_Stamp,
                             &datePacket->newDate);
                    break;

                case WEEK_MINUS_GADGET:
                    if (datePacket->ARPDatePacket.dat_Stamp.ds_Days >= 7)
                        datePacket->ARPDatePacket.dat_Stamp.ds_Days -= 7;
                    else
                        datePacket->ARPDatePacket.dat_Stamp.ds_Days = 0;
                    DSToDate(&datePacket->ARPDatePacket.dat_Stamp,
                             &datePacket->newDate);
                    break;
                        
                case OK_GADGET:
                    goto done;
                    break;

                case CANCEL_GADGET:
                    datePacket->status = 1;
                    goto done;
                    break;

                case YEAR_GADGET:
                    value = GadgetValue(&yearGadget);
                    if ((value >= 1978) && (value <= 2100))
                        datePacket->newDate.Dyear = value;
                    break;

                case MONTH_GADGET:
                    break;

                case DAY_GADGET:
                    value = GadgetValue(&dayGadget);
                    if ((value >= 1) && (value <= 31))
                        datePacket->newDate.Dday = value;
                    break;

                case HOUR_GADGET:
                    value = GadgetValue(&hourGadget);
                    if ((value >= 0) && (value < 24))
                        datePacket->newDate.Dhour = value;
                    break;

                case MINUTE_GADGET:
                    value = GadgetValue(&minuteGadget);
                    if ((value >= 0) && (value < 60))
                        datePacket->newDate.Dminute = value;
                    break;

                case SECOND_GADGET:
                    value = GadgetValue(&secondGadget);
                    if ((value >= 0) && (value < 60))
                        datePacket->newDate.Dsecond = value;
                    break;

                case UP_YEAR_GADGET:
                    ++datePacket->newDate.Dyear;
                    break;

                case DOWN_YEAR_GADGET:
                    if (datePacket->newDate.Dyear > 1978) 
                        --datePacket->newDate.Dyear;
                    break;

                case UP_MONTH_GADGET:
                    if (++datePacket->newDate.Dmonth > 12) 
                    datePacket->newDate.Dmonth = 1;
                    break;

                case DOWN_MONTH_GADGET:
                    if (--datePacket->newDate.Dmonth < 1) 
                        datePacket->newDate.Dmonth = 12;
                    break;

                case UP_DAY_GADGET:
                    if (datePacket->newDate.Dday < 31) {
                        ++datePacket->newDate.Dday;
                    }
                    break;

                case DOWN_DAY_GADGET:
                    if (datePacket->newDate.Dday > 1) 
                        --datePacket->newDate.Dday;
                    break;

                case UP_HOUR_GADGET:
                    if (++datePacket->newDate.Dhour > 23) 
                        datePacket->newDate.Dhour = 0;
                    break;

                case DOWN_HOUR_GADGET:
                    if (--datePacket->newDate.Dhour < 0) 
                        datePacket->newDate.Dhour = 23;
                    break;

                case UP_MINUTE_GADGET:
                    if (++datePacket->newDate.Dminute > 59) 
                        datePacket->newDate.Dminute = 0;
                    break;

                case DOWN_MINUTE_GADGET:
                    if (--datePacket->newDate.Dminute < 0) 
                        datePacket->newDate.Dminute = 59;
                    break;

                case UP_SECOND_GADGET:
                    if (++datePacket->newDate.Dsecond > 59) 
                        datePacket->newDate.Dsecond = 0;
                    break;

                case DOWN_SECOND_GADGET:
                    if (--datePacket->newDate.Dsecond < 0) 
                        datePacket->newDate.Dsecond = 59;
                    break;

                case DATE_FORMAT_GADGET:
                    if (++datePacket->ARPDatePacket.dat_Format>FORMAT_MAX)
                        datePacket->ARPDatePacket.dat_Format = 0;
                    SetOptionGadget(&dateFormatGadget, datePacket->window,
                        datePacket->requester, 
                        dateFormats[datePacket->ARPDatePacket.dat_Format]);
                    break;
                    
                default:
                    redraw = FALSE;
                    break;
                }                   /* end switch(gadgid) */

                /* Reformat the new date value. */
                if (redraw) {
                    DateToDS(&datePacket->newDate,
                             &datePacket->ARPDatePacket.dat_Stamp);
                    DSToDate(&datePacket->ARPDatePacket.dat_Stamp, 
                             &datePacket->newDate);
                    RedrawDateRequester(datePacket);                 
                }
                break;

            default:
                break;          /* ignore the rest */
            }                   /* end switch(class) */
        }
    }
done:
    /* Restore gadget image data pointers. */
    SetImageData(GadgetImage(&downYearGadget), saveDownImage);
    SetImageData(GadgetImage(&upYearGadget), saveUpImage);

    /* Restore window's IDCMP flags. */
    ModifyIDCMP(datePacket->window, IDCMPFlags);   
    if (downImage) FreeMem(downImage, downImageSize);
    if (upImage) FreeMem(upImage, upImageSize);
    DateToDS(&datePacket->newDate, &datePacket->ARPDatePacket.dat_Stamp);
    return datePacket->status;
}

/*  FUNCTION
 *      RedrawDateRequester - reformat and redisplay the date requester
 * 
 *  SYNOPSIS
 *      static void RedrawDateRequester(datePacket)
 *                      MRDatePacket    *datePacket;
 */
static void
RedrawDateRequester(datePacket)
    MRDatePacket *datePacket;
{
    char    *p, s[20];


    sprintf(s,"%4d", datePacket->newDate.Dyear);
    SetStringGadget(&yearGadget, datePacket->window, 
                    datePacket->requester, s);
    SetStringGadget(&monthGadget, datePacket->window, datePacket->requester, 
                    calendar[datePacket->newDate.Dmonth-1].Mname);
    sprintf(s,"%02d", datePacket->newDate.Dday);
    SetStringGadget(&dayGadget, datePacket->window, datePacket->requester, s);
    sprintf(s,"%02d", datePacket->newDate.Dhour);
    SetStringGadget(&hourGadget, datePacket->window, 
                    datePacket->requester, s);
    sprintf(s,"%02d", datePacket->newDate.Dminute);
    SetStringGadget(&minuteGadget, datePacket->window, 
                    datePacket->requester, s);
    sprintf(s,"%02d", datePacket->newDate.Dsecond);
    SetStringGadget(&secondGadget, datePacket->window, 
                    datePacket->requester, s);

    StamptoStr(datePacket);
    /* There appears to be a bug in ARP's formatting of the time
     * string. A trash character appears where the terminating null
     * should be.
     */
    datePacket->ARPDatePacket.dat_StrTime[8] = 0;
    SetStringGadget(&dateGadget, datePacket->window, 
                    datePacket->requester,
                    datePacket->ARPDatePacket.dat_StrDate);

    SetStringGadget(&timeGadget, datePacket->window,
                    datePacket->requester,
                    datePacket->ARPDatePacket.dat_StrTime);
    
    SetStringGadget(&dayNameGadget, datePacket->window,
                    datePacket->requester,
                    datePacket->ARPDatePacket.dat_StrDay);

    SetOptionGadget(&dateFormatGadget, datePacket->window,
                    datePacket->requester, 
                    dateFormats[datePacket->ARPDatePacket.dat_Format]);

}
    

#ifdef DEBUG

/* --- Only compiled in the debug version --- */

#include <exec/memory.h>

/* New window structure */

struct NewWindow newwindow = {
    0,0,640,200,0,1,

/* IDCMP Flags */

    MOUSEMOVE | MENUPICK | MOUSEBUTTONS | 
    CLOSEWINDOW | GADGETDOWN | GADGETUP | REQSET, 

/* Flags */
    WINDOWCLOSE | WINDOWDEPTH | ACTIVATE | RMBTRAP | REPORTMOUSE,

    NULL,                           /* First gadget */
    NULL,                           /* Checkmark */
    (UBYTE *)"Date Requester Test Program", /* Window title */
    NULL,                           /* No custom streen */
    NULL,                           /* Not a super bitmap window */
    0,0,640,200,                    /* Not used, but set up anyway */
    WBENCHSCREEN
};

static struct IntuiText MoreText = {
    AUTOFRONTPEN,               /* FrontPen */
    AUTOBACKPEN,                /* BackPen */
    JAM2,                       /* DrawMode */
    AUTOLEFTEDGE,               /* LeftEdge */
    AUTOTOPEDGE,                /* TopEdge */
    AUTOITEXTFONT,              /* ITextFont */
    (UBYTE *) "Want to play some more?", /* IText */
    NULL                        /* NextText */
    };

static struct IntuiText YesText = {
    AUTOFRONTPEN,               /* FrontPen */
    AUTOBACKPEN,                /* BackPen */
    AUTODRAWMODE,               /* DrawMode */
    AUTOLEFTEDGE,               /* LeftEdge */
    AUTOTOPEDGE,                /* TopEdge */
    AUTOITEXTFONT,              /* ITextFont */
    (UBYTE *) "Sure!",          /* IText */
    NULL                        /* NextText */
    };

static struct IntuiText NoText = {
    AUTOFRONTPEN,               /* FrontPen */
    AUTOBACKPEN,                /* BackPen */
    JAM2,                       /* DrawMode */
    AUTOLEFTEDGE,               /* LeftEdge */
    AUTOTOPEDGE,                /* TopEdge */
    AUTOITEXTFONT,              /* ITextFont */
    (UBYTE *) "Nope!",          /* IText */
    NULL                        /* NextText */
    };

struct ArpBase          *ArpBase;
struct GfxBase          *GfxBase;
struct IntuitionBase    *IntuitionBase;
struct Window           *mywindow;
long                    *ds;

main()
{
    static char     *arpNotOpen = "I can not open the ARP library!\n";  
    short           keep_going;
    MRDatePacket    *datePacket = NULL;

    ArpBase = (struct ArpBase *) OpenLibrary(ArpName, ArpVersion);
    if (ArpBase == NULL) {
        Write(Output(), arpNotOpen , (long) sizeof(arpNotOpen));
        goto done;
    }
    GfxBase = (struct GfxBase *) ArpBase->GfxBase;
    IntuitionBase = (struct IntuitionBase *) ArpBase->IntuiBase;

    datePacket = CreateMRDatePacket(NULL, FORMAT_USA, 1);

    mywindow = OpenWindow(&newwindow);
    /* Set initial values in date packet. */
    datePacket->window = mywindow;
    do {
        MRDateRequest(datePacket);
        keep_going = AutoRequest(mywindow, &MoreText, &YesText, &NoText,
                        NULL, NULL, 220L, 50L);
    } while (keep_going);

done:
    if (datePacket)
        FreeMRDatePacket(datePacket);

    if (mywindow)
        CloseWindow(mywindow);

    if (IntuitionBase)
        CloseLibrary(IntuitionBase);

}

#endif

