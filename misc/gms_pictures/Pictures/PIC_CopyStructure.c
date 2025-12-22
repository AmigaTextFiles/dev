
#include <proto/dpkernel.h>
#include <system/all.h>

/************************************************************************************
** Action: CopyToUnv()
** Object: Picture
*/

LIBFUNC void PIC_CopyToUnv(mreg(__a0) struct Universe *unv, mreg(__a1) struct Picture *pic)
{
  CopyStructure(pic->Bitmap,unv);
  unv->Height  = pic->ScrHeight;
  unv->ScrMode = pic->ScrMode;
  unv->Source  = pic->Source;
  unv->Width   = pic->ScrWidth;
}

/************************************************************************************
** Action: CopyFromUnv()
** Object: Picture
*/

LIBFUNC void PIC_CopyFromUnv(mreg(__a0) struct Universe *unv, mreg(__a1) struct Picture *pic)
{
  CopyStructure(unv,pic->Bitmap);
  if (!pic->ScrHeight) pic->ScrHeight = unv->Height;
  if (!pic->ScrMode)   pic->ScrMode   = unv->ScrMode;
  if (!pic->Source)    pic->Source    = unv->Source;
  if (!pic->ScrWidth)  pic->ScrWidth  = unv->Width;
}

