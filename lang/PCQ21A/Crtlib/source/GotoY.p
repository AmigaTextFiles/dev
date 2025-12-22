external;

procedure GotoXY(x,y : integer);
external;

procedure GotoY(y : integer);
begin
   GotoXY(0, y);
end;
             
