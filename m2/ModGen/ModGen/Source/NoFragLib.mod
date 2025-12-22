IMPLEMENTATION MODULE NoFragLib;

FROM M2Lib IMPORT OpenLib;

BEGIN
  NoFragBase:=OpenLib (noFragName,VERSION);
END NoFragLib.
