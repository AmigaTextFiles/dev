external;

procedure GotoXY(x,y : integer);
external;

procedure GotoX(x : integer);
begin
   GotoXY(x, 0);
end;
                                  
