{
        Pens.i of PCQ Pascal

        This is not a standard Amiga include file, but since the
        various drawing routines don't seem to fit in any other
        include file, this one was created to declare them.
}

{$I "Include:Graphics/Rastport.i" }
{$I "Include:Graphics/View.i"}

Procedure Draw(rp : Address; x, y : Short);
    External;

Procedure DrawCircle(rp : Address; cx, cy, radius : Short);
    External;

Procedure DrawEllipse(rp : Address; cx, cy, a, b : Short);
    External;

Procedure Flood(rp : Address; mode : Integer; x, y : Short);
    External;

Procedure Move(rp : Address; x, y : Short);
    External;

Procedure PolyDraw(rp : Address; count : Short; ary : Address);
    External;

Function ReadPixel(rp : Address; x, y : Short) : Integer;
    External;

Procedure RectFill(rp : Address; xmin, ymin, xmax, ymax : Short);
    External;

Procedure SetAPen(rp : Address; pen : Byte);
    External;

Procedure SetBPen(rp : Address; pen : Byte);
    External;

Procedure SetDrMd(rp : Address; mode : Byte);
    External;

FUNCTION WritePixel(rp : Address; x, y : Short) : Integer;
    External;

FUNCTION ReadPixelArray8(RP : RastPortPtr; xstart, ystart, xstop, ystop : Short; 
                         PixelArray : Address; tempRP : RastPortPtr) : Integer;
    External;

FUNCTION ReadPixelLine8(RP : RastPortPtr; xstart, ystart, Width : Short;
                         LineArray : Address; tempRP : RastPortPtr) : Integer;
    External;

FUNCTION WritePixelArray8(RP : RastPortPtr; xstart, ystart, xstop, ystop : Short;
                         PixelArray : Address; tempRP : RastPortPtr) : Integer;
    External;

FUNCTION WritePixelLine8(RP : RastPortPtr; xstart, ystart, Width : Short;
                         LineArray : Address; tempRP : RastPortPtr) : Integer;
    External;

{ --- functions in V39 or higher (Release 3) --- }
FUNCTION ObtainBestPenA(cm : ColorMapPtr; r,g,b : Integer; TagList : Address) : Integer;
    External;

FUNCTION GetAPen(RP : RastPortPtr) : Integer;
    External;

FUNCTION GetBPen(RP : RastPortPtr) : Integer;
    External;

FUNCTION GetDrMd(RP : RastPortPtr) : Integer;
    External;

FUNCTION GetOutlinePen(RP : RastPortPtr) : Integer;
    External;

PROCEDURE SetABPenDrMd(RP : RastPortPtr; APen, BPen, DrawMode : Integer);
    External;

PROCEDURE ReleasePen(CM : ColorMapPtr; n : Integer);
    External;

FUNCTION ObtainPen(CM : ColorMapPtr; n, r, g, b, f : Integer) : Integer;
    External;

FUNCTION SetOutlinePen(RP : RastPortPtr; Pen : Integer) : Integer;
    External;

FUNCTION SetWriteMask(RP : RastPortPtr; msk : Integer) : Integer;
    External;

PROCEDURE SetMaxPen(RP : RastPortPtr; maxpen : Integer);
    External;

PROCEDURE SetRPAttrsA(RP : RastPortPtr; TagList : Address);
    External;

PROCEDURE GetRPAttrsA(RP : RastPortPtr; TagList : Address);
    External;

{ --- functions in V40 or higher (Release 3.1) --- }
PROCEDURE WriteChunkyPixels(RP : RastPortPtr; xstart, ystart,
                            xstop, ystop : Integer; WCParray : Address;
                            bytesperrow : Integer);
    External;


{
   This are varargs functions to use with PCQ Pascal vers. 2.0 and above
}
     

{$C+}
PROCEDURE SetRPAttrs(rp : RastPortPtr; ...);
EXTERNAL;

FUNCTION ObtainBestPen(cm : ColorMapPtr; r,g,b: Integer;...): INTEGER;
EXTERNAL;

PROCEDURE GetRPAttrs(rp : RastPortPtr; ...);
EXTERNAL;
{$C-}


