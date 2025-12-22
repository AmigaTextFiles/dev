MenuTags:
	dc.b	NM_TITLE,0
MT_Project:
	dc.l	0,0
	dc.w	0
	dc.l	0,0

	dc.b	NM_ITEM,0
MI_Asetukset:
	dc.l	0,0
	dc.w	0
	dc.l	0,AvaaAsetusIkkuna

	dc.b	NM_ITEM,0
MI_MUI_Asetukset:
	dc.l	0,0
	dc.w	0
	dc.l	0,AvaaMUIAsetusIkkuna

	dc.b	NM_ITEM,0
	dc.l	NM_BARLABEL,0
	dc.w	0
	dc.l	0,0

	dc.b	NM_ITEM,0
MI_Tietoja:
	dc.l	0,0
	dc.w	0
	dc.l	0,AvaaTietojaIkkuna

	dc.b	NM_ITEM,0
MI_TietojaMUI:
	dc.l	0,0
	dc.w	0
	dc.l	0,AvaaTietojaIkkuna_MUI

	dc.b	NM_ITEM,0
	dc.l	NM_BARLABEL,0
	dc.w	0
	dc.l	0,0

	dc.b	NM_ITEM,0
MI_Quit	dc.l	0,0
	dc.w	0
	dc.l	0,xt_LopetaSovellus

	dc.b	NM_END,0
	dc.l	0,0
	dc.w	0
	dc.l	0,0
