IMPLEMENTATION MODULE Workbench ;

IMPORT M2Lib ;

BEGIN
  WBMsg := M2Lib._WBMsg ;
  WorkbenchBase := M2Lib.OpenLib( WORKBENCH_NAME, VERSION )
END Workbench.
