
/*
 *  RASTPORT.C
 */

#include <local/typedefs.h>

extern struct IntuitionBase *IntuitionBase;

int
MakeRastPort(rp, bm, tmprassize, numai)
RP *rp;
BM *bm;
long  tmprassize;
short numai;
{
    if (!IntuitionBase)
	OpenIntuitionLibrary();

    InitRastPort(rp);
    if (numai) {
	register char *buf;
	rp->AreaInfo = AllocMem(sizeof(AREAINFO), MEMF_PUBLIC | MEMF_CLEAR);
	if (!rp->AreaInfo)
	    goto fail;
	buf = AllocMem(numai * 5, MEMF_PUBLIC|MEMF_CLEAR);
	if (!buf)
	    goto fail;
	InitArea(rp->AreaInfo, (short *)buf, numai);
    }
    if (tmprassize) {
	PLANEPTR tmpraster;
	if (tmprassize == -1)
	    tmprassize = bm->Rows * bm->BytesPerRow;
	rp->TmpRas = AllocMem(sizeof(TMPRAS), MEMF_PUBLIC | MEMF_CLEAR);
	if (!rp->TmpRas)
	    goto fail;
	tmpraster = AllocMem(tmprassize, MEMF_PUBLIC | MEMF_CLEAR);
	if (!tmpraster)
	    goto fail;
	InitTmpRas(rp->TmpRas, tmpraster, tmprassize);
    }
    rp->BitMap = bm;
    SetAPen(rp, 1);
    SetDrMd(rp, JAM2);
    return(1);
fail:
    FreeRastPort(rp);
    return(0);
}

void
FreeRastPort(rp)
RP *rp;
{
    if (rp) {
	WaitBlit();
	{
	    register AREAINFO *ai;
	    if (ai = rp->AreaInfo) {
		if (ai->VctrTbl)
		    FreeMem(ai->VctrTbl, ai->MaxCount * 5);
		FreeMem(ai, sizeof(AREAINFO));
		rp->AreaInfo = NULL;
	    }
	}
	{
	    register TMPRAS *tr;
	    if (tr = rp->TmpRas) {
		if (tr->RasPtr)
		    FreeMem(tr->RasPtr, tr->Size);
		FreeMem(tr, sizeof(TMPRAS));
	    }
	    rp->TmpRas = NULL;
	}
	rp->BitMap = NULL;
    }
}

