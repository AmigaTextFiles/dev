package body graphics_Graphics is


procedure SetRPAttrsA (  rp : RastPort_Ptr; tags : TagListType ) is
   procedure SetRPAttrsA (  rp : RastPort_Ptr; tags : System.Address);
   pragma Import (C, SetRPAttrsA, "SetRPAttrsA");

   begin
      SetRPAttrsA(rp, tags.Tag_Address );
   end;
pragma Inline(SetRPAttrsA);

procedure GetRPAttrsA (  rp : RastPort_Ptr; tags : TagListType ) is   
   procedure GetRPAttrsA (  rp : RastPort_Ptr; tags : System.Address);
  pragma Import (C, GetRPAttrsA, "GetRPAttrsA");
   begin
      GetRPAttrsA(rp, tags.Tag_Address );
   end;
pragma Inline(GetRPAttrsA);


function GetExtSpriteA (  ss : ExtSprite_Ptr; tags : TagListType) return INTEGER is
   function GetExtSpriteA (  ss : ExtSprite_Ptr; tags : System.Address) return INTEGER;
   pragma Import (C, GetExtSpriteA, "GetExtSpriteA");

   begin
      return GetExtSpriteA(ss,tags.Tag_Address );
   end  GetExtSpriteA;
pragma Inline(GetExtSpriteA);

function ObtainBestPenA (  cm : ColorMap_Ptr; r : Integer; g : Integer; b : Integer; tags : TagListType) return INTEGER is
   function ObtainBestPenA (  cm : ColorMap_Ptr; r : Integer; g : Integer; b : Integer; tags : System.Address) return INTEGER;
   pragma Import (C, ObtainBestPenA, "ObtainBestPenA");

   begin
      return  ObtainBestPenA(cm,r,g,b,tags.Tag_Address );
   end  ObtainBestPenA;
pragma Inline(ObtainBestPenA);

function VideoControl (  colorMap : ColorMap_Ptr; tagarray : TagListType) return Boolean is
   function VideoControl (  colorMap : ColorMap_Ptr; tagarray : System.Address) return Boolean;
   pragma Import (C, VideoControl, "VideoControl");

   begin
      return VideoControl(colorMap,tagarray.Tag_Address );
   end  VideoControl;
pragma Inline(VideoControl);

function WeighTAMatch (  reqTextAttr : TextAttr_Ptr; targetTextAttr : TextAttr_Ptr; targetTags : TagListType) return Integer_16 is
   function WeighTAMatch (  reqTextAttr : TextAttr_Ptr; targetTextAttr : TextAttr_Ptr; targetTags : System.Address) return Integer_16;
   pragma Import (C, WeighTAMatch, "WeighTAMatch");

   begin
      return WeighTAMatch( reqTextAttr, targetTextAttr, targetTags.Tag_Address );
   end  WeighTAMatch;
pragma Inline(WeighTAMatch);

function AllocSpriteDataA (  bm : BitMap_Ptr; tags : TagListType) return  ExtSprite_Ptr is
   function AllocSpriteDataA (  bm : BitMap_Ptr; tags : System.Address) return  ExtSprite_Ptr;
   pragma Import (C, AllocSpriteDataA, "AllocSpriteDataA");

   begin
      return AllocSpriteDataA(bm, tags.Tag_Address);
   end  AllocSpriteDataA;
pragma Inline (AllocSpriteDataA);

function BestModeIDA (  tags : TagListType) return Integer is
   function BestModeIDA (  tags : System.Address) return Integer;
   pragma Import (C, BestModeIDA, "BestModeIDA");

   begin
      return BestModeIDA(tags.Tag_Address );
   end  BestModeIDA;
pragma Inline( BestModeIDA);

function ChangeExtSpriteA (  vp : ViewPort_Ptr; oldsprite : ExtSprite_Ptr; newsprite : ExtSprite_Ptr; tags : TagListType) return INTEGER is
   function ChangeExtSpriteA (  vp : ViewPort_Ptr; oldsprite : ExtSprite_Ptr; newsprite : ExtSprite_Ptr; tags : System.Address) return INTEGER;
   pragma Import (C, ChangeExtSpriteA, "ChangeExtSpriteA");

   begin
      return ChangeExtSpriteA(vp,oldsprite,newsprite,tags.Tag_Address );
   end  ChangeExtSpriteA;
pragma Inline(ChangeExtSpriteA);

function ExtendFont (  font : TextFont_Ptr; fontTags : TagListType) return Integer is
   function ExtendFont (  font : TextFont_Ptr; fontTags : System.Address) return Integer;
   pragma Import (C, ExtendFont, "ExtendFont");

   begin
      return ExtendFont( font, fontTags.Tag_Address );
   end  ExtendFont;
pragma Inline(ExtendFont);

end graphics_Graphics;
