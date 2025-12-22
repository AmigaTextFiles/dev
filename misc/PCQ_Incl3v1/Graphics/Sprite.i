{
    Sprite.i for PCQ Pascal
}

const

    SPRITE_ATTACHED     = $80;

type

    SimpleSprite = record
        posctldata      : Address;
        height          : Short;
        x,y             : Short;        { current position }
        num             : Short;
    end;
    SimpleSpritePtr = ^SimpleSprite;

    ExtSprite = Record
        es_SimpleSprite : SimpleSprite;         { conventional simple sprite structure }
        es_wordwidth    : WORD;                 { graphics use only, subject to change }
        es_flags        : WORD;                 { graphics use only, subject to change }
    end;
    ExtSpritePtr = ^ExtSprite;

const
{ tags for AllocSpriteData() }
 SPRITEA_Width          = $81000000;
 SPRITEA_XReplication   = $81000002;
 SPRITEA_YReplication   = $81000004;
 SPRITEA_OutputHeight   = $81000006;
 SPRITEA_Attached       = $81000008;
 SPRITEA_OldDataFormat  = $8100000a;      { MUST pass in outputheight if using this tag }

{ tags for GetExtSprite() }
 GSTAG_SPRITE_NUM = $82000020;
 GSTAG_ATTACHED   = $82000022;
 GSTAG_SOFTSPRITE = $82000024;

{ tags valid for either GetExtSprite or ChangeExtSprite }
 GSTAG_SCANDOUBLED     =  $83000000;      { request "NTSC-Like" height if possible. }




Procedure ChangeSprite(vp : Address; s : SimpleSpritePtr; newData : Address);
    External;   { vp is a ViewPortPtr }

Procedure FreeSprite(pick : Short);
    External;

Function GetSprite(sprite : SimpleSpritePtr; pick : Short) : Short;
    External;

Procedure MoveSprite(vp : Address; sprite : SimpleSpritePtr; x, y : Short);
    External;   { vp is a ViewPortPtr }

{ --- functions in V39 or higher (Release 3) --- }

FUNCTION GetExtSpriteA(ss : ExtSpritePtr; taglist : Address) : Integer;
    External;

FUNCTION AllocSpriteDataA(BM : BitMapPtr; TagList : Address) : ExtSpritePtr;
    External;

FUNCTION ChangeExtSpriteA(VP : ViewPortPtr; oldsprite, newsprite : ExtSpritePtr;
                          TagList : Address) :  Integer;
    External;

PROCEDURE FreeSpriteData(sp : ExtSpritePtr);
    External;


