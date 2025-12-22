program GenerateMD5;

uses
  SysUtils, md5;



var
  Hash: TMDDigest;
  Res: Integer;
  F: TextFile;
begin
  if ParamCount = 0 then
  begin
    Writeln('Usage: ' + ExtractFileName(ParamStr(0)) + ' <file> [<output.md5>]');
    Exit;
  end;
  Hash := MDFile(ParamStr(1), MD_VERSION_5);
  WriteLn(MD5Print(Hash));
  if ParamCount > 1 then
  begin
    Assign(F, ChangeFileExt(ParamStr(2), 'md5'));
    Rewrite(F);
    WriteLn(F, MD5Print(Hash));
    Close(F);
  end;

end.
