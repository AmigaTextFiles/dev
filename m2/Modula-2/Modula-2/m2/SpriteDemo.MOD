(********************************************************************************

Name         : SpriteDemo.MOD
Version      : 1.0
Purpose      : Demo for Hardware Sprites
Author       : ms
Modified     : 2.4.86  15:35  ms

********************************************************************************)

MODULE SpriteDemo;

FROM SYSTEM        IMPORT LONG, ADR, ADDRESS;
FROM SimpleSprites IMPORT SpriteImage, SimpleSprite,
                          GetSprite, ChangeSprite, MoveSprite, FreeSprite;
FROM Terminal      IMPORT WriteString, WriteLn, Read;

VAR sp: SimpleSprite;
    si: SpriteImage;
    ch: CHAR;

BEGIN
  (* init Sprite's Image *)
  si.posctl[0]:=0; si.posctl[1]:=0;
  si.data[ 0]:=LONG(00000H, 0FFFFH);
  si.data[ 1]:=LONG(00000H, 0C003H);
  si.data[ 2]:=LONG(00180H, 0C003H);
  si.data[ 3]:=LONG(00180H, 0C003H);
  si.data[ 4]:=LONG(00180H, 0C003H);
  si.data[ 5]:=LONG(00180H, 0C003H);
  si.data[ 6]:=LONG(03FFCH, 0C003H);
  si.data[ 7]:=LONG(03FFCH, 0C003H);
  si.data[ 8]:=LONG(03FFCH, 0C003H);
  si.data[ 9]:=LONG(00180H, 0C003H);
  si.data[10]:=LONG(00180H, 0C003H);
  si.data[11]:=LONG(00180H, 0C003H);
  si.data[12]:=LONG(00180H, 0C003H);
  si.data[13]:=LONG(00000H, 0C003H);
  si.data[14]:=LONG(00000H, 0C003H);
  si.data[15]:=LONG(00000H, 0FFFFH);

  si.data[16]:=LONG(0FFFFH, 0FFFFH);

  IF GetSprite(sp, 1)#-1D THEN
    sp.x:=160; sp.y:=100; sp.height:=16;
    ChangeSprite(NIL, sp, si);
    WriteString('SpriteDemo'); WriteLn;
    WriteString('=========='); WriteLn; WriteLn;
    WriteString('use numerical keys to move the sprite, esc to exit'); WriteLn;
    LOOP
      Read(ch);
      IF    ch=33C THEN EXIT
      ELSIF ch='1' THEN MoveSprite(NIL, sp, sp.x-1, sp.y+1)
      ELSIF ch='2' THEN MoveSprite(NIL, sp, sp.x, sp.y+2)
      ELSIF ch='3' THEN MoveSprite(NIL, sp, sp.x+1, sp.y+1)
      ELSIF ch='4' THEN MoveSprite(NIL, sp, sp.x-2, sp.y)
      ELSIF ch='6' THEN MoveSprite(NIL, sp, sp.x+2, sp.y)
      ELSIF ch='7' THEN MoveSprite(NIL, sp, sp.x-1, sp.y-1)
      ELSIF ch='8' THEN MoveSprite(NIL, sp, sp.x, sp.y-2)
      ELSIF ch='9' THEN MoveSprite(NIL, sp, sp.x+1, sp.y-1)
      ELSE
      END;
    END;
    FreeSprite(1);
  ELSE
    WriteString("couldn't get sprite"); WriteLn;
  END
END SpriteDemo.
