/*
        radiodiallib.c

        Amiga shard library to serve as an example
        how to develope external gadgets for StormWIZARD.

        © 1998 HAAGE & PARTNER Computer GmbH

        written by Jan-Claas Dirks
        basing on code by Thomas Mittelsdorf,
        Commodore-Amiga and Amiga Technologies.

        This gadget resembles the old-fashioned station
        dial of a radio.
        Click on it's knob and drag it to the left or right
        to change the value. You can turn around the knob
        several times until you reach the gadgets upper
        or lower limit.

        To use this source as a template for your gadget,
        search for comments that begin with "//!".
        This string points you to key information
        you will need to change.

        BTW: I use GoldEd's folding feature with modified
        start/end markers: //S/ and //E/. This gives the
        opportunity to do nested folding.
*/

//S/ Includes
#include  <clib/alib_protos.h>
#include  <clib/macros.h>
#include  <string.h>
#include  <stdlib.h>
#include  <math.h>

#include  <exec/exec.h>
#include  <exec/memory.h>
#include  <exec/libraries.h>

#include  <pragma/exec_lib.h>
#include  <pragma/intuition_lib.h>

#include  <pragma/exec_lib.h>
#include  <pragma/gadtools_lib.h>
#include  <pragma/graphics_lib.h>
#include  <pragma/intuition_lib.h>
#include  <pragma/layers_lib.h>
#include  <pragma/utility_lib.h>

#include  <graphics/clip.h>
#include  <graphics/rastport.h>
#include  <graphics/gfxmacros.h>

#include  <intuition/gadgetclass.h>
#include  <intuition/intuition.h>
#include  <intuition/imageclass.h>

#include  <utility/utility.h>
#include  <libraries/wizard.h>

#include  <libraries/wizardextern.h>

//! This is the definition of the tags for our gadget
#include  "radiodiallib.h"
//E/

//S/ Debug macros
//! Set MYDEBUG to 1 to get debug output.
//  Set bug to the printf-style output function to be called.
//  Use these macros this way: D(bug("x is %ld\n", x));
//  To use kprintf(), include "debug.lib" in your project.
#define MYDEBUG 0
void kprintf(UBYTE *fmt,...);
void dprintf(UBYTE *fmt,...);
#define bug kprintf
#if MYDEBUG
#define D(x) x
#else
#define D(x) ;
#endif /* MYDEBUG */
//E/

struct WizardRadioDialBase
  {
  struct Library library;
  ULONG result;
  };

//S/ Defines
#pragma libbase WizardRadioDialBase;

//! This is the name of the library and it's version string
#define _LibNameString "wizard_radiodial.library"
#define _LibVersionString _LibNameString " 1.0 (" __DATE__ ")"

// some casting abbrevations
#define OPSET(x)    ((struct opSet *)x)
#define OPGET(x)    ((struct opGet *)x)
#define GPRENDER(x) ((struct gpRender *)x)
#define GADGET(x)   ((struct Gadget *)x)
#define GDIM(x)     ((struct grmDimensions *)x)
#define GPINPUT(x)  ((struct gpInput *)x)
#define GPINACT(x)  ((struct gpGoInactive *)x)
#define OPUPDATE(x) ((struct opUpdate *)x)
//E/

//S/ Variablen
//! This struct holds the attributes of a gadget instance.
//  Remember, one shared library controls all instances of
//  your gadget, thus you must not use global variables to
//  store attributes of one particular gadget.
//  A pointer to an instance of this struct will be passed
//  to you by Intuition whenever needed.

typedef struct {
    //! Some attributes for StormWizard
    UWORD MinWidth, MinHeight;          // minimum layout size
    struct Rectangle ClipRectangle;     // for rendering
    BOOL Active;                        // gadget visible or not
    UWORD ShortCutKey;                  // short cut key

    long minlimit, maxlimit, value;     // see radiodiallib.h
    WORD rastersteps, rasteroffset;

    WORD lastx;                         // last processed ie->ie_X value
    long lastvalue;                     // backed-up value for canceling
    struct

    {
        WORD x, y, radius;
    } knob;                             // internal: dial's geometry

    struct
    {
        WORD x, y, radius;
    } dial;                             // internal: knob's geometry
} LibData;

extern ULONG HookEntry();

struct Library  *DOSBase;
struct Library  *MathIeeeDoubBasBase;
struct Library  *MathIeeeDoubTransBase;
struct Library  *GfxBase;
struct Library  *IntuitionBase;
struct Library  *LayersBase;
struct Library  *UtilityBase;
//E/

static void SetKnobPosition(LibData *data)
//S/
{
    // given a LibData structure, this functions sets the
    // position of the knob according to its value.

    double x, y;
    double cx, cy;
    double a, sinA, cosA;

    x = (double)data->dial.x;
    y = (double)(data->dial.y - (data->dial.radius*3)/4);
    cx = (double)data->dial.x;
    cy = (double)data->dial.y;
    a = (double)(2*PI*(data->rasteroffset - data->minlimit + data->value) / data->rastersteps);
    sinA = sin(a);
    cosA = cos(a);

    data->knob.x = data->dial.x + (WORD)floor(x*cosA - y*sinA - cx*cosA + cy*sinA + 0.5);
    data->knob.y = data->dial.y + (WORD)floor(x*sinA + y*cosA - cx*sinA - cy*cosA + 0.5);
}
//E/

void INIT_9_OpenLibs(void)
//S/
{
    //! I use StromC's INIT_n_-mechanism
    //  for automatic initialisation
    GfxBase = OpenLibrary("graphics.library", 37);
    IntuitionBase = OpenLibrary("intuition.library", 37);
    LayersBase = OpenLibrary("layers.library", 37);
    UtilityBase = OpenLibrary("utility.library", 37);
    MathIeeeDoubBasBase = OpenLibrary("mathieeedoubbas.library", 37);
    MathIeeeDoubTransBase = OpenLibrary("mathieeedoubtrans.library", 37);

}
//E/

void EXIT_9_CloseLibs(void)
//S/
{
    if (MathIeeeDoubBasBase)
        CloseLibrary(MathIeeeDoubBasBase);
    if (MathIeeeDoubTransBase)
        CloseLibrary(MathIeeeDoubTransBase);
    if (GfxBase)
        CloseLibrary(GfxBase);
    if (IntuitionBase)
        CloseLibrary(IntuitionBase);
    if (LayersBase)
        CloseLibrary(LayersBase);
    if(UtilityBase)
        CloseLibrary(UtilityBase);
}
//E/

static ULONG Notify(Object *obj,
                    struct GadgetInfo *gi,
                    ULONG flags,
                    Tag tag1,
                    ...)
//S/
{
    return (DoMethod(obj, OM_NOTIFY, (struct TagItem*)&tag1, gi, flags));
}
//E/

static void SendMsg(IClass *class,
                    Object *obj,
                    Msg msg)
//S/
{
    struct TagItem tags[2];
    tags[0].ti_Tag = GA_ID;
    tags[0].ti_Data = GADGET(obj)->GadgetID;
    tags[1].ti_Tag = TAG_DONE;
    DoSuperMethod(class, obj, OM_NOTIFY, tags, GPINPUT(msg)->gpi_GInfo, 0);
}
//E/

static ULONG Dispatcher(IClass *class,
                        Object *obj,
                        Msg msg)
//S/
{
    LibData *data;
    ULONG retval = NULL;
    struct TagItem *tag, *tstate;
    struct DrawInfo *drinfo;
    BOOL redraw;
    struct InputEvent*  ie;
    struct Gadget *g = GADGET(obj); // abbrevation: save some casts and null-indices

    // OM_NEW has no information about obj yet.
    if (msg->MethodID != OM_NEW)
        data = INST_DATA(class, obj);

    switch (msg->MethodID)
    {
        case OM_NEW:
//S/
            // Creation of this gadget
            D(bug("** OM_NEW\n"));

            if ((retval = DoSuperMethodA(class, obj, msg)))
            {
                data = INST_DATA(class, retval);

                //! Initialize default values for a gadget instance.
                data->MinWidth = 8;
                data->MinHeight = 8;

                data->minlimit = 0;
                data->maxlimit = 100;
                data->value = 0;
                data->rastersteps = 36;
                data->rasteroffset = 0;
                //! Don't worry about any attributes that depend on the layout.
                //  There will be a WEXTERNM_lAYOUT call later.

                //  read attributes from the tag list.
                tstate = OPSET(msg)->ops_AttrList;
                while ((tag = NextTagItem(&tstate))!=NULL)
                {
                    switch (tag->ti_Tag)
                    {
                        case GA_DrawInfo:
                            drinfo = (struct DrawInfo *)tag->ti_Data;
                            break;
                        case WGA_MinWidth:
                            data->MinWidth = (UWORD)tag->ti_Data;
                            break;
                        case WGA_MinHeight:
                            data->MinHeight = (UWORD)tag->ti_Data;
                            break;

                        //! Overriding the default values on gadget creation time.
                        case RADIODIAL_MinLimit:
                            data->minlimit = tag->ti_Data;
                            break;
                        case RADIODIAL_MaxLimit:
                            data->maxlimit = tag->ti_Data;
                            break;
                        case RADIODIAL_Value:
                            data->value = tag->ti_Data;
                            break;
                        case RADIODIAL_RasterSteps:
                            data->rastersteps = tag->ti_Data;
                            break;
                        case RADIODIAL_RasterOffset:
                            data->rasteroffset = tag->ti_Data;
                            break;
                    }
                }
            }
            break;
//E/
        case OM_SET:
        case OM_UPDATE:
//S/
            // SetGadgetAttrs() and notifying
            D(bug("** OM_SET / OM_UPDAtE\n"));

            retval=DoSuperMethodA(class, obj, msg);

            //! Now we do our own processing
            redraw = FALSE;
            tstate = OPSET(msg)->ops_AttrList;
            while ((tag = NextTagItem(&tstate))!=NULL)
            {
                switch (tag->ti_Tag)
                {
                    case RADIODIAL_MinLimit:
                        data->minlimit = (long)tag->ti_Data;
                        break;

                    case RADIODIAL_MaxLimit:
                        data->maxlimit = (long)tag->ti_Data;
                        break;

                    case RADIODIAL_Value:
                        if ((long)tag->ti_Data < data->minlimit)
                            data->value = data->minlimit;
                        else
                            if ((long)tag->ti_Data > data->maxlimit)
                                data->value = data->maxlimit;
                            else
                                data->value = (long)tag->ti_Data;

                        redraw = TRUE;

                        SetKnobPosition(data);
                        Notify(obj, OPSET(msg)->ops_GInfo, OPSET(msg)->MethodID == OM_UPDATE ? OPUPDATE(msg)->opu_Flags : 0L, GA_ID, g->GadgetID, RADIODIAL_Value, data->value, TAG_END);
                        break;
                }

                if (redraw && data->Active)
                {
                    struct RastPort *rp;
                    if ((rp = ObtainGIRPort(OPSET(msg)->ops_GInfo)) != NULL)
                    {
                        DoMethod(obj, GM_RENDER, OPSET(msg)->ops_GInfo, rp, GREDRAW_REDRAW);
                        ReleaseGIRPort(rp);
                    }
                }
            }
            break;
//E/
        case OM_GET:
//S/
            // GetAttr()
            D(bug("** OM_GET\n"));

            retval = TRUE;

            switch (OPGET(msg)->opg_AttrID)
            {
                //! Someone in the outside world is interested in us

                case WGA_MinWidth:
                    *(OPGET(msg)->opg_Storage) = (ULONG)data->MinWidth;
                    break;
                case WGA_MinHeight:
                    *(OPGET(msg)->opg_Storage) = (ULONG)data->MinHeight;
                    break;
                case RADIODIAL_MinLimit:
                    *(OPGET(msg)->opg_Storage) = (ULONG)data->minlimit;
                    break;
                case RADIODIAL_MaxLimit:
                    *(OPGET(msg)->opg_Storage) = (ULONG)data->maxlimit;
                    break;
                case RADIODIAL_Value:
                    *(OPGET(msg)->opg_Storage) = (ULONG)data->value;
                    break;
                case RADIODIAL_RasterSteps:
                    *(OPGET(msg)->opg_Storage) = (ULONG)data->rastersteps;
                    break;
                case RADIODIAL_RasterOffset:
                    *(OPGET(msg)->opg_Storage) = (ULONG)data->rasteroffset;
                    break;
                default:
                    retval = DoSuperMethodA(class, obj, msg);
            }
            break;
//E/
        case GM_HITTEST:
//S/
            // SELECT_DOWN
            D(bug("** GM_HITTEST\n"));

            //! The mouse clicked over our gadget,
            //  this gadget does not check if it's
            //  particular graphics was hit.
            retval = GMR_GADGETHIT;
            break;
//E/
        case GM_HELPTEST:
//S/
            // HELP test
            D(bug("** GM_HELPTEST\n"));

            //! Actually, we don't react on this.
            if (data->Active)
                retval = DoSuperMethodA(class, obj, msg);
            break;
//E/
        case GM_GOACTIVE:
//S/
            // grab the input focus?
            D(bug("** GM_GOACTIVE\n"));

            if (!data->Active)
                retval = GMR_NOREUSE;
            else
            {
                ie = GPINPUT(msg)->gpi_IEvent;
                //! this gadget does not react on ActivateGadget()
                if (ie)
                {
                    retval = GMR_MEACTIVE;
                    data->lastx = GADGET(obj)->LeftEdge + GPINPUT(msg)->gpi_Mouse.X;
                    data->lastvalue = data->value;
                }
            }
            break;
//E/
        case GM_GOINACTIVE:
//S/
            // after the input focus has been released
            D(bug("** GM_GOINACTIVE\n"));

            //! You probabilly need to redraw your gadget
            //  in an inactive look. This gadget doesn't.
            retval = DoSuperMethodA(class, obj, msg);
            break;
//E/
        case GM_HANDLEINPUT:
//S/
            // process user input on our gadget
            D(bug("** GM_HANDLEINPUT\n"));

            ie = GPINPUT(msg)->gpi_IEvent;
            retval = GMR_MEACTIVE;

            //! Now for the interaction:
            if (ie->ie_Class == IECLASS_RAWMOUSE)
            {
                switch (ie->ie_Code)
                {
                    case SELECTUP:
                        if (((GPINPUT(msg)->gpi_Mouse).X < 0) ||
                            ((GPINPUT(msg)->gpi_Mouse).X >= g->Width) ||
                            ((GPINPUT(msg)->gpi_Mouse).Y < 0) ||
                            ((GPINPUT(msg)->gpi_Mouse).Y >= g->Height))
                        {
                            D(bug("  UP and VERIFY\n"));
                            retval = GMR_NOREUSE | GMR_VERIFY;
                        }
                        else
                        {
                            D(bug("  UP\n"));
                            retval = GMR_NOREUSE;
                        }
                        break;

                    case MENUDOWN:
                        D(bug("  CANCEL\n"));
                        SetGadgetAttrs(g, GPINPUT(msg)->gpi_GInfo->gi_Window, NULL, RADIODIAL_Value, data->lastvalue, TAG_END);
                        SendMsg(class, obj, msg);
                        retval = GMR_REUSE;
                        break;

                    default:
                        // overrides a bug: at most times the last message has the mouse at (0/0)
                        if (ie->ie_X != 0 && ie->ie_Y != 0)
                        {
                            D(bug("  %4ld, %4ld, %4ld", data->value,ie->ie_X, data->lastx));
                            SetGadgetAttrs(g, GPINPUT(msg)->gpi_GInfo->gi_Window, NULL, RADIODIAL_Value, data->value + (ie->ie_X - data->lastx) / 2, TAG_END);
                            SendMsg(class, obj, msg);
                            data->lastx = ie->ie_X;
                        }
                        break;
                }
            }
            break;
//E/
        case GM_RENDER:
//S/
            // RefreshGadgets(), RefreshGList()
            D(bug("** GM_RENDER\n"));
            {
                struct GadgetInfo *GInfo = GPRENDER(msg)->gpr_GInfo;
                struct RastPort *rp = GPRENDER(msg)->gpr_RPort;
                struct Region *OldRegion;

                if (DoSuperMethod(class, obj, WEXTERNM_INSTALLCLIP, GInfo, &OldRegion))
                {
                    struct DrawInfo *DrInfo = GInfo->gi_DrInfo;
                    //! use exactly this rastPort etc. to draw your gadget right now.

                    SetAPen(rp, DrInfo->dri_Pens[BACKGROUNDPEN]);
                    RectFill(rp, g->LeftEdge, g->TopEdge, g->LeftEdge+g->Width-1, g->TopEdge+g->Height-1);

                    // Now you get an idea why the visual appearance of this gadget
                    // remembers of good ol' 8-bit times:
                    SetAPen(rp, DrInfo->dri_Pens[TEXTPEN]);
                    DrawCircle(rp, data->dial.x, data->dial.y, data->dial.radius);
                    DrawCircle(rp, data->knob.x, data->knob.y, data->knob.radius);

                    DoSuperMethod(class, obj, WEXTERNM_UNINSTALLCLIP, GInfo, OldRegion);
                }
            }
            break;
//E/
        case WEXTERNM_LAYOUT:
//S/
            // Position / size may have changed
            D(bug("** WEXTERNM_LAYOUT\n"));

            // Needed calculations for any external gadget
            data->ClipRectangle = ((struct WizardExternLayout *)msg)->wepl_ClipRectangle;

            g->LeftEdge = ((struct WizardExternLayout *)msg)->wepl_Bounds.Left;
            g->TopEdge = ((struct WizardExternLayout *)msg)->wepl_Bounds.Top;
            g->Width = ((struct WizardExternLayout *)msg)->wepl_Bounds.Width;
            g->Height = ((struct WizardExternLayout *)msg)->wepl_Bounds.Height;

            //! These are our attributes that need to be re-calculated
            //  if the gadget layout changes.
            data->dial.x = g->LeftEdge + g->Width/2;
            data->dial.y = g->TopEdge + g->Height/2;
            data->dial.radius = MIN(g->Width, g->Height) / 2 - 1;

            SetKnobPosition(data);
            data->knob.radius = MAX(3, data->dial.radius / 6);

            retval=DoSuperMethodA(class, obj, msg);
            break;
//E/
        case WEXTERNM_UPDATEPAGE:
//S/
            // visibility of this gadget
            D(bug("** WEXTERNM_UPDATEPAGE\n"));

            data->Active = ((struct WizardExternUpdatePage *)msg)->wepup_Active;
            retval=DoSuperMethodA(class, obj, msg);
            break;
//E/
        default:
//S/
            retval=DoSuperMethodA(class, obj, msg);
            break;
//E/
    }

    return retval;
}
//E/

//! Following are the two public functions of this library.
//  If you haven't changed the name of the dispatcher function
//  or the gadget instance struct, you do not need to change
//  anything below this point - besides the debug output.

struct IClass *privat_MakeClass(register __a0 struct IClass *parentclass)
//S/
{
    struct IClass *myclass;

    if ((myclass = MakeClass(0, 0, parentclass, sizeof(LibData), 0)))
    {
        myclass->cl_Dispatcher.h_Entry = HookEntry;
        myclass->cl_Dispatcher.h_SubEntry = (ULONG(*)())&Dispatcher;
        //!
        D(bug("** wizard_radialdial.library ist there.\n"));
    }

    return myclass;
}
//E/

void privat_FreeClass(register __a0 struct IClass *myclass)
//S/
{
    FreeClass(myclass);
}
//E/

