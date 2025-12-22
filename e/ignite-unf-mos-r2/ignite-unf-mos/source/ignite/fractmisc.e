OPT MODULE, PREPROCESS, EXPORT

-> fractmisc.e

MODULE 'graphics/rastport', 'intuition/classes', 'utility/hooks'
MODULE 'exec/nodes', 'exec/ports', 'exec/io', 'exec/devices'

MODULE '*/jobdev/jobdefs'

OBJECT rgbstruct
   r:DOUBLE
   g:DOUBLE
   b:DOUBLE
ENDOBJECT

OBJECT display

   /* rgb buffer */
   rendbuf:PTR TO CHAR

   /* dimensions */
   width:LONG
   height:LONG

ENDOBJECT

OBJECT zone
   next:PTR TO zone, prev:PTR TO zone
   r:DOUBLE, x:DOUBLE, y:DOUBLE
ENDOBJECT

OBJECT redrawmsg
   flags:LONG
   left:LONG
   top:LONG
   width:LONG
   height:LONG
   next:PTR TO redrawmsg
ENDOBJECT

SET RDF_BUSY

OBJECT rendermsg
   job:jobmsg
   parameters:LONG   -> must be AllocVec():ed
   display:PTR TO display
   zone:PTR TO zone
   redraw:PTR TO redrawmsg
   hook:PTR TO hook -> new         /* callback hook */ possibly remove
   object:PTR TO object            /* typically the fractal plugin MUI object */
   igniteobj:PTR TO object
   zoneviewobj:PTR TO object
   plotrgbfunc -> plotrgbfunc(rm, x, y, r:REAL, g:REAL, b:REAL)
   setredrawareafunc -> (rm, redraw, r:REAL, g:REAL, b:REAL)
   miscfunc -> (rm, mfid, p1, p2, p3, p4, p5) -> not used yet
ENDOBJECT

ENUM MF_PUSHREDRAW,
     MF_PUSHSTATUSTXT,
     MF_PUSHGAUGE,
     MF_PUSHRENDERDONE



ENUM MUIM_Fract_GetParams = $ABCDE100,    -> (fractparamsptr)
     MUIM_Fract_SetParams,             -> (fractparamsptr)
     MUIM_Fract_RenderDone,            -> called after user rendering is done
     MUIA_Fract_RenderFunc,            -> [..G] always invoked from subtask
     MUIA_Fract_ParameterSize,         -> [..G] size of data to hold parameters
     MUIA_Fract_Name,                  -> [..G]
     MUI_Fract_RESERVED1,
     MUI_Fract_RESERVED2,
     MUI_Fract_RESERVED3,
     MUI_Fract_RESERVED4,
     MUI_Fract_RESERVED5,
     MUI_Fract_RESERVED6,
     MUI_Fract_RESERVED7,
     MUI_Fract_RESERVED8,
     MUI_Fract_PRIVATE                 -> possible private methods of fractal class starts here.


#define Percent(max,val) (!100.0 / ((max!) / (val!)) !)

-> replace inline lists with calls to varargs functions..
-> will ave to wait until ecx supports user varargs functions.
-> for now inline lists work.. but hmm.. perhaps..

#define PushRenderDone(rm) \
   miscfunc(rm, MF_PUSHRENDERDONE, 0, 0, 0)

#define PushStatusTxt(rm, txt) \
   miscfunc(rm, MF_PUSHSTATUSTXT, txt, 0, 0)

#define PushGauge(rm, lev) \
   miscfunc(rm, MF_PUSHGAUGE, lev, 0, 0)

#define PushRedraw(rm) \
   miscfunc(rm, MF_PUSHREDRAW, rm.redraw, 0, 0)

#define PushRedrawRegion(rm,redrawmsg) \
   miscfunc(rm, MF_PUSHREDRAW, redrawmsg, 0, 0)

#define STATUSTXT_DONE 'Done.'
#define STATUSTXT_STOPPED 'Stopped.'


