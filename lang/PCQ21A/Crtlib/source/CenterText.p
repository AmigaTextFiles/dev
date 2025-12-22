external;

procedure GotoX(x : integer);
external;

function strlen(str : string):integer;
external;

function MaxX: integer;
external;

procedure CenterText(txt : string);
begin
   GotoX((MaxX - StrLen(txt))/2+1);
   WriteLn(txt);
end;
                 
