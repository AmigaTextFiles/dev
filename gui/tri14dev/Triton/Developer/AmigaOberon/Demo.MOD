MODULE Demo; (* simple triton.library demo *)

IMPORT
  D := Dos, T := Triton, S := SYSTEM, U := Utility, NoGuru;

VAR
  application: T.AppPtr;
  mainProject: T.ProjectPtr;

BEGIN
  application := NIL;
  mainProject := NIL;

  application := T.CreateAppTags (
    T.caName, S.ADR("OberonDemoApp"),
    T.caLongName, S.ADR("Oberon Demo Application"),
    T.caVersion, S.ADR("0.0"),
    U.done
  );

  IF (application = NIL) THEN HALT(20); END;

  mainProject := T.OpenProjectTags (application,
    T.wiID, 10,
    T.wiTitle, S.ADR("Oberon Demo Application"),
    T.wiBackfill, T.bfFillBackground,
    T.wiPosition, T.wpCenterDisplay,
    T.grVert, T.grAlign,
      T.obSpace, T.stNormal,
      T.grHoriz, T.grPropSpaces+T.grCenter,
        T.obSpace, T.stNormal,
        T.obText, 0,
        T.atText, S.ADR("Demo Demo Demo"),
        T.atFlags, T.tx3D,
        T.obSpace, T.stNormal,
      T.grEnd, 0,
      T.obSpace, T.stNormal,
    T.grEnd, 0,  
    U.done
  );

  IF (mainProject = NIL) THEN HALT(20); END;

  S.SETREG(0, T.Wait(application, 0));

CLOSE
  IF (mainProject # NIL) THEN T.CloseProject (mainProject); END;
  IF (application # NIL) THEN T.DeleteApp (application); END;
END Demo.
