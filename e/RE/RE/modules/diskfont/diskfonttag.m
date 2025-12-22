#ifndef  DISKFONT_DISKFONTTAG_H
#define  DISKFONT_DISKFONTTAG_H

#ifndef	EXEC_TYPES_H
MODULE 	'exec/types'
#endif
#ifndef	UTILITY_TAGITEM_H
MODULE 	'utility/tagitem'
#endif

#define  OT_Level0	TAG_USER

#define  OT_Level1	(TAG_USER OR $1000)

#define  OT_Level2	(TAG_USER OR $2000)

#define  OT_Level3	(TAG_USER OR $3000)

#define  OT_Indirect	$8000




#define  OT_DeviceDPI	(OT_Level0 OR $01)	

#define  OT_DotSize	(OT_Level0 OR $02)

#define  OT_PointHeight	(OT_Level0 OR $08)

#define  OT_SetFactor	(OT_Level0 OR $09)

#define  OT_ShearSin	(OT_Level0 OR $0a)
#define  OT_ShearCos	(OT_Level0 OR $0b)

#define  OT_RotateSin	(OT_Level0 OR $0c)
#define  OT_RotateCos	(OT_Level0 OR $0d)

#define  OT_EmboldenX	(OT_Level0 OR $0e)
#define  OT_EmboldenY	(OT_Level0 OR $0f)

#define  OT_PointSize	(OT_Level0 OR $10)

#define  OT_GlyphCode	(OT_Level0 OR $11)

#define  OT_GlyphCode2	(OT_Level0 OR $12)

#define  OT_GlyphWidth	(OT_Level0 OR $13)

#define  OT_OTagPath	(OT_Level0 OR OT_Indirect OR $14)
#define  OT_OTagList	(OT_Level0 OR OT_Indirect OR $15)

#define  OT_GlyphMap	(OT_Level0 OR OT_Indirect OR $20)

#define  OT_WidthList	(OT_Level0 OR OT_Indirect OR $21)

#define  OT_TextKernPair (OT_Level0 OR OT_Indirect OR $22)
#define  OT_DesignKernPair (OT_Level0 OR OT_Indirect OR $23)

#define  OT_UnderLined		(OT_Level0 OR $24)
#define  OTUL_None		0
#define  OTUL_Solid		1
#define  OTUL_Broken		2
#define  OTUL_DoubleSolid	3
#define  OUTL_DoubleBroken	4

#define  OT_StrikeThrough	(OT_Level0 OR $25)



#define  OTSUFFIX	'.otag'

#define  OT_FileIdent	(OT_Level1 OR $01)

#define  OT_Engine	(OT_Level1 OR OT_Indirect OR $02)
#define  OTE_Bullet	'bullet'

#define  OT_Family	(OT_Level1 OR OT_Indirect OR $03)


#define  OT_BName	(OT_Level2 OR OT_Indirect OR $05)

#define  OT_IName	(OT_Level2 OR OT_Indirect OR $06)

#define  OT_BIName	(OT_Level2 OR OT_Indirect OR $07)

#define  OT_SymbolSet	(OT_Level1 OR $10)

#define  OT_YSizeFactor	(OT_Level1 OR $11)

#define  OT_SpaceWidth	(OT_Level2 OR $12)

#define  OT_IsFixed	(OT_Level2 OR $13)

#define  OT_SerifFlag	(OT_Level1 OR $14)

#define  OT_StemWeight	(OT_Level1 OR $15)
#define  OTS_UltraThin	  8	
#define  OTS_ExtraThin	 24	
#define  OTS_Thin	 40	
#define  OTS_ExtraLight	 56	
#define  OTS_Light	 72	
#define  OTS_DemiLight	 88	
#define  OTS_SemiLight	104	
#define  OTS_Book	120	
#define  OTS_Medium	136	
#define  OTS_SemiBold	152	
#define  OTS_DemiBold	168	
#define  OTS_Bold	184	
#define  OTS_ExtraBold	200	
#define  OTS_Black	216	
#define  OTS_ExtraBlack	232	
#define  OTS_UltraBlack	248	

#define  OT_SlantStyle	(OT_Level1 OR $16)
#define  OTS_Upright	0
#define  OTS_Italic	1	
#define  OTS_LeftItalic	2	

#define  OT_HorizStyle	(OT_Level1 OR $17)
#define  OTH_UltraCompressed	 16	
#define  OTH_ExtraCompressed	 48	
#define  OTH_Compressed		 80	
#define  OTH_Condensed		112	
#define  OTH_Normal		144	
#define  OTH_SemiExpanded	176	
#define  OTH_Expanded		208	
#define  OTH_ExtraExpanded	240	

#define  OT_SpaceFactor	(OT_Level2 OR $18)

#define  OT_InhibitAlgoStyle (OT_Level2 OR $19)

#define  OT_AvailSizes	(OT_Level1 OR OT_Indirect OR $20)
#define  OT_MAXAVAILSIZES	20	

#define  OT_SpecCount	(OT_Level1 OR $100)

#define  OT_Spec	(OT_Level1 OR $100)

#define  OT_Spec1	(OT_Level1 OR $101)
#endif	 
