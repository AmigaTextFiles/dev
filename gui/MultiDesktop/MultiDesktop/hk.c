struct BackFillMsg
{
   struct Layer    *Layer;
   struct Rectangle Bounds;
   LONG             OffsetX;
   LONG             OffsetY;
};

ULONG HookProc(hook,xxrp,bfm)
 struct Hook        *hook;
 UWORD              *xxrp;
 struct BackFillMsg *bfm;
{
 UWORD            x1,y1,x2,y2;
 struct RastPort  rp;

 geta4(); 

 CopyMemQuick(xxrp,&rp,sizeof(struct RastPort));
 rp.Layer=NULL;

 x1=bfm->Bounds.MinX;
 y1=bfm->Bounds.MinY;
 x2=bfm->Bounds.MaxX;
 y2=bfm->Bounds.MaxY;

 SetDrMd(&rp,1);
 SetAPen(&rp,3);
 RectFill(&rp,x1,y1,x2,y2);

 return(1L);
}

