MODULE TritonSupport;

IMPORT
  sys : SYSTEM,
  I   : Intuition,
  T*  : Triton,
  E*  : Exec,
  u   : Utility;

TYPE
  MsgString* = ARRAY 256 OF CHAR;

VAR
  ezTitle* : ARRAY 256 OF CHAR;
  App*     : T.AppPtr;

PROCEDURE CloseProject*(VAR p : T.ProjectPtr);
BEGIN
  T.CloseProject(p);
  p:=NIL;
END CloseProject;

PROCEDURE DeleteApp*(VAR app : T.AppPtr);
BEGIN
  T.DeleteApp(app);
  app:=NIL;
END DeleteApp;

PROCEDURE Req*(VAR p : T.ProjectPtr;
               msg,gadgets : MsgString) : LONGINT;
BEGIN
  RETURN T.EasyRequestTags(App,sys.ADR(msg),
                               sys.ADR(gadgets),
                               T.ezReqPos,T.wpTopLeftScreen,
                               T.ezLockProject,p,
                               T.ezTitle,sys.ADR(ezTitle),
                               T.ezActivate,1,
                               u.done,0);
END Req;

PROCEDURE DisplayBeep*(p : T.ProjectPtr);
VAR
  s : I.ScreenPtr;
BEGIN
  s:=T.LockScreen(p);
  I.DisplayBeep(s);
  T.UnlockScreen(s);
END DisplayBeep;

PROCEDURE SetWindowTitle*(p : T.ProjectPtr; msg : ARRAY OF CHAR);
BEGIN
  T.SetAttribute(p,0,T.wiTitle,sys.ADR(msg));
END SetWindowTitle;

PROCEDURE GetString*(p : T.ProjectPtr; id : E.ULONG) : E.STRPTR;
BEGIN
  RETURN sys.VAL(E.STRPTR,T.GetAttribute(p,id,T.atValue));
END GetString;

PROCEDURE Enable*(p : T.ProjectPtr; id : E.ULONG);
BEGIN
  T.SetAttribute(p,id,T.atDisabled,0);
END Enable;

PROCEDURE Disable*(p : T.ProjectPtr; id : E.ULONG);
BEGIN
  T.SetAttribute(p,id,T.atDisabled,1);
END Disable;

END TritonSupport.
