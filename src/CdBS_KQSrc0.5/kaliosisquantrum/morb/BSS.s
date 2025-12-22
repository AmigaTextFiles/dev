*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* BSS Section
* $Id: BSS.s 0.5 1998/02/13 13:07:59 MORB Exp MORB $
*

	 section   gleurp,BSS

KBHBuf:
	 ds.b      KBLENGTH

KBAscBeg:
	 ds.b      KBABLENGTH
KBAscEnd:

KBRawBeg:
	 ds.b      KBRBLENGTH
KBRawEnd:

_MergeCopTmp:
	 ds.l      MaxCopperLayers+1
_CopperRepairBuffer:
	 ds.l      2*MaxCopperDamages

;RMapSize           = NbHorTile*NbVerTile*2
;RTblSize           = NbHorTile*NbVerTile*12+4

RMap1:
	 ds.b      880
RTbl1:
	 ds.b      5284
RMap2:
	 ds.b      880
RTbl2:
	 ds.b      5284
RTbl3:
	 ds.b      5284

_GuiTemp:
	 ds.b      ge_Size*100
_StrBuf:
	 ds.b      1024

_EditBuffer:
	 ds.b      1024

_NameBuffer:
	 ds.b      40
_FRBuffer:
	 ds.b      FRBufferSize

_BlitQueue:
	 ds.b      bn_Size*BlitQueueSize

	 section   spouirfl,BSS_C
RipolinBuf:
	 ds.l      (16+4+3)*256
cl12buf:
	 ds.l      100
