OPT MODULE, EXPORT, PREPROCESS


-> mainmisc.e (was: ignite_defs.e)

MODULE '*fractmisc'
MODULE '*/jobdev/jobdefs'
MODULE 'exec/io'
MODULE 'exec/nodes'
MODULE 'exec/ports'

#define SENDRMSG(rmsg) SendIO(rmsg)
#define CHECKRMSG(rmsg) CheckIO(rmsg)
#define ABORTRMSG(rmsg) AbortIO(rmsg)
#define STOPRMSG(rmsg) IF CheckIO(rmsg) = FALSE THEN rmsg.job.break := JMBREAKF_STOP
#define WAITRMSG(rmsg) IF rmsg.job.io.mn.ln.succ THEN WaitIO(rmsg)


ENUM MUIM_DispWin_Render = $ABCDE300,
     MUIM_DispWin_StopRender,
     MUIA_DispWin_IgniteHook,            -> [I..]
     MUIA_DispWin_RenderMsg,             -> [I.G]  (iorequest)
     MUIA_DispWin_IsDispWin,             -> [..G]
     MUI_DispWin_PRIVATE

ENUM IH_DELETEWIN,
     IH_WINACTIVE, -> ignite private
     IH_RENDER,
     IH_STOP,
     IH_MENU

ENUM MUIM_Zonegroup_Set_Zone = $ABCDE500,
     MUIM_Zonegroup_Get_Zone,
     MUIA_Zonegroup_ActionHook

ENUM AH_NONE,
     AH_RENDER,
     AH_ABORTRENDER,
     AH_ZOOM,
     AH_MOVE,

     AH_CLOSEREQUEST,

     AH_NEWZONE,
     AH_PREVZONE, -> undo
     AH_NEXTZONE,  -> redo

     AH_SKIP_LEFT,
     AH_SKIP_RIGHT,
     AH_SKIP_UP,
     AH_SKIP_DOWN,
     AH_SKIP_IN,
     AH_SKIP_OUT,

     AH_PRIVATE


ENUM MUIA_RendWin_FractMCC = $ABCDE400, -> [I..]
     MUIA_RendWin_FractParams, ->          [I..] copy of in-use parameter struct
     MUIA_RendWin_RenderMsg             -> [I..] iorequest


ENUM MUIM_Zoneview_Redraw_Msg = $ABCDE200,   -> redrawmsg
     MUIA_Zoneview_ActionHook,               -> [I..] hook (dispwin), bla, actionid
     MUIA_Zoneview_Display,                  -> [..G]
     MUI_Zoneview_PRIVATE

PROC __xget(obj,attr)
   DEF x=NIL
   GetAttr(attr,obj,{x})
ENDPROC x

#define XGET(obj, attr) __xget(IF (obj) < $FFF THEN Raise("LOBJ") ELSE obj, attr)

#define DOMETHODA(obj,msg) doMethodA(IF (obj) < $FFF THEN Raise("LOBJ") ELSE obj, msg)

#define CALLHOOKA(hook,obj,msg) callHookA(IF (hook) < $FFF THEN Raise("LHOK") ELSE hook, obj, msg)


