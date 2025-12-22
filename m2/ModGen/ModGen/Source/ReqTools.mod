IMPLEMENTATION MODULE ReqTools;

FROM M2Lib IMPORT OpenLib;

BEGIN
  ReqToolsBase:=OpenLib (ReqToolsName,VERSION);
END ReqTools.
