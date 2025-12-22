#ifndef LIBRARIES_GADTOOLS_H
#define LIBRARIES_GADTOOLS_H


#ifndef EXEC_TYPES_H
MODULE  'exec/types'
#endif
#ifndef UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif
#ifndef INTUITION_INTUITION_H
MODULE  'intuition/intuition'
#endif


#define GENERIC_KIND	0
#define BUTTON_KIND	1
#define CHECKBOX_KIND	2
#define INTEGER_KIND	3
#define LISTVIEW_KIND	4
#define MX_KIND		5
#define NUMBER_KIND	6
#define CYCLE_KIND	7
#define PALETTE_KIND	8
#define SCROLLER_KIND	9

#define SLIDER_KIND	11
#define STRING_KIND	12
#define TEXT_KIND	13
#define NUM_KINDS	14


#define ARROWIDCMP	(IDCMP_GADGETUP OR IDCMP_GADGETDOWN OR\
	IDCMP_INTUITICKS OR IDCMP_MOUSEBUTTONS)
#define BUTTONIDCMP	(IDCMP_GADGETUP)
#define CHECKBOXIDCMP	(IDCMP_GADGETUP)
#define INTEGERIDCMP	(IDCMP_GADGETUP)
#define LISTVIEWIDCMP	(IDCMP_GADGETUP OR IDCMP_GADGETDOWN OR\
	IDCMP_MOUSEMOVE OR ARROWIDCMP)
#define MXIDCMP		(IDCMP_GADGETDOWN)
#define NUMBERIDCMP	(0)
#define CYCLEIDCMP	(IDCMP_GADGETUP)
#define PALETTEIDCMP	(IDCMP_GADGETUP)

#define SCROLLERIDCMP	(IDCMP_GADGETUP OR IDCMP_GADGETDOWN OR IDCMP_MOUSEMOVE)
#define SLIDERIDCMP	(IDCMP_GADGETUP OR IDCMP_GADGETDOWN OR IDCMP_MOUSEMOVE)
#define STRINGIDCMP	(IDCMP_GADGETUP)
#define TEXTIDCMP	(0)


OBJECT NewGadget

    LeftEdge:WORD
 TopEdge:WORD	
    Width:WORD
 Height:WORD		
    GadgetText:PTR TO UBYTE		
      TextAttr:PTR TO TextAttr	
    GadgetID:UWORD			
    Flags:LONG			
    VisualInfo:LONG			
    UserData:LONG			
ENDOBJECT


#define PLACETEXT_LEFT	$0001	
#define PLACETEXT_RIGHT	$0002	
#define PLACETEXT_ABOVE	$0004	
#define PLACETEXT_BELOW	$0008	
#define PLACETEXT_IN	$0010	
#define NG_HIGHLABEL	$0020	


OBJECT NewMenu

    Type:UBYTE		
    
    Label:PTR TO CHAR		
    CommKey:PTR TO CHAR		
    Flags:UWORD		
    MutualExclude:LONG	
    UserData:LONG		
ENDOBJECT


#define MENU_IMAGE	128

#define NM_TITLE	1	
#define NM_ITEM		2	
#define NM_SUB		3	
#define IM_ITEM		(NM_ITEMORMENU_IMAGE)	
#define IM_SUB		(NM_SUBORMENU_IMAGE)	

#define NM_END		0	

#define NM_IGNORE	64

#define NM_BARLABEL	(()-1)

#define NM_MENUDISABLED	MENUENABLED
#define NM_ITEMDISABLED	ITEMENABLED

#define NM_COMMANDSTRING COMMSEQ

#define NM_FLAGMASK	(~(COMMSEQ OR ITEMTEXT OR HIGHFLAGS))
#define NM_FLAGMASK_V39	(~(ITEMTEXT OR HIGHFLAGS))


#define GTMENU_USERDATA(menu) (*  ( ( *)((  menu)+1) ) )
#define GTMENUITEM_USERDATA(menuitem) (*  ( ( *)((  menuitem)+1) ) )

#define MENU_USERDATA(menuitem) (*  ( ( *)(menuitem+1) ) )

#define GTMENU_TRIMMED	$00000001	
#define GTMENU_INVALID	$00000002	
#define GTMENU_NOMEM	$00000003	



#define MX_WIDTH	17
#define MX_HEIGHT	9

#define CHECKBOX_WIDTH	26
#define CHECKBOX_HEIGHT	11


#define GT_TagBase	     TAG_USER + $80000
#define GTVI_NewWindow	     GT_TagBase+1  
#define GTVI_NWTags	     GT_TagBase+2  
#define GT_Private0	     GT_TagBase+3  
#define GTCB_Checked	     GT_TagBase+4  
#define GTLV_Top	     GT_TagBase+5  
#define GTLV_Labels	     GT_TagBase+6  
#define GTLV_ReadOnly	     GT_TagBase+7  
#define GTLV_ScrollWidth     GT_TagBase+8  
#define GTMX_Labels	     GT_TagBase+9  
#define GTMX_Active	     GT_TagBase+10 
#define GTTX_Text	     GT_TagBase+11 
#define GTTX_CopyText	     GT_TagBase+12 
#define GTNM_Number	     GT_TagBase+13 
#define GTCY_Labels	     GT_TagBase+14 
#define GTCY_Active	     GT_TagBase+15 
#define GTPA_Depth	     GT_TagBase+16 
#define GTPA_Color	     GT_TagBase+17 
#define GTPA_ColorOffset     GT_TagBase+18 
#define GTPA_IndicatorWidth  GT_TagBase+19 
#define GTPA_IndicatorHeight GT_TagBase+20 
#define GTSC_Top	     GT_TagBase+21 
#define GTSC_Total	     GT_TagBase+22 
#define GTSC_Visible	     GT_TagBase+23 
#define GTSC_Overlap	     GT_TagBase+24 

#define GTSL_Min	     GT_TagBase+38 
#define GTSL_Max	     GT_TagBase+39 
#define GTSL_Level	     GT_TagBase+40 
#define GTSL_MaxLevelLen     GT_TagBase+41 
#define GTSL_LevelFormat     GT_TagBase+42 
#define GTSL_LevelPlace      GT_TagBase+43 
#define GTSL_DispFunc	     GT_TagBase+44 
#define GTST_String	     GT_TagBase+45 
#define GTST_MaxChars	     GT_TagBase+46 
#define GTIN_Number	     GT_TagBase+47 
#define GTIN_MaxChars	     GT_TagBase+48 
#define GTMN_TextAttr	     GT_TagBase+49 
#define GTMN_FrontPen	     GT_TagBase+50 
#define GTBB_Recessed	     GT_TagBase+51 
#define GT_VisualInfo	     GT_TagBase+52 
#define GTLV_ShowSelected    GT_TagBase+53 
#define GTLV_Selected	     GT_TagBase+54 
#define GT_Reserved1	     GT_TagBase+56 
#define GTTX_Border	     GT_TagBase+57 
#define GTNM_Border	     GT_TagBase+58 
#define GTSC_Arrows	     GT_TagBase+59 
#define GTMN_Menu	     GT_TagBase+60 
#define GTMX_Spacing	     GT_TagBase+61 

#define GTMN_FullMenu	     GT_TagBase+62 
#define GTMN_SecondaryError  GT_TagBase+63 
#define GT_Underscore	     GT_TagBase+64 
#define GTST_EditHook	     GT_TagBase+55 
#define GTIN_EditHook	     GTST_EditHook 

#define GTMN_Checkmark	     GT_TagBase+65 
#define GTMN_AmigaKey	     GT_TagBase+66 
#define GTMN_NewLookMenus    GT_TagBase+67 

#define GTCB_Scaled	     GT_TagBase+68 
#define GTMX_Scaled	     GT_TagBase+69 
#define GTPA_NumColors	     GT_TagBase+70 
#define GTMX_TitlePlace      GT_TagBase+71 
#define GTTX_FrontPen	     GT_TagBase+72 
#define GTTX_BackPen	     GT_TagBase+73 
#define GTTX_Justification   GT_TagBase+74 
#define GTNM_FrontPen	     GT_TagBase+72 
#define GTNM_BackPen	     GT_TagBase+73 
#define GTNM_Justification   GT_TagBase+74 
#define GTNM_Format	     GT_TagBase+75 
#define GTNM_MaxNumberLen    GT_TagBase+76 
#define GTBB_FrameType	     GT_TagBase+77 
#define GTLV_MakeVisible     GT_TagBase+78 
#define GTLV_ItemHeight      GT_TagBase+79 
#define GTSL_MaxPixelLen     GT_TagBase+80 
#define GTSL_Justification   GT_TagBase+81 
#define GTPA_ColorTable      GT_TagBase+82 
#define GTLV_CallBack	     GT_TagBase+83 
#define GTLV_MaxPen	     GT_TagBase+84 
#define GTTX_Clipped	     GT_TagBase+85 
#define GTNM_Clipped	     GT_TagBase+85 

#define GT_Reserved0	     GTST_EditHook


#define GTJ_LEFT   0
#define GTJ_RIGHT  1
#define GTJ_CENTER 2


#define BBFT_BUTTON	 1  
#define BBFT_RIDGE	 2  
#define BBFT_ICONDROPBOX 3  


#define INTERWIDTH	8
#define INTERHEIGHT	4


#define NWAY_KIND	CYCLE_KIND
#define NWAYIDCMP	CYCLEIDCMP
#define GTNW_Labels	GTCY_Labels
#define GTNW_Active	GTCY_Active


#define GADTOOLBIT	$($8000)

#define GADTOOLMASK	(~GADTOOLBIT)



#define LV_DRAW       $202	

#define LVCB_OK       0		
#define LVCB_UNKNOWN  1		

#define LVR_NORMAL	      0	
#define LVR_SELECTED	      1	
#define LVR_NORMALDISABLED    2		
#define	LVR_SELECTEDDISABLED  8		

OBJECT LVDrawMsg

    MethodID:LONG   
       RastPort:PTR TO RastPort   
       DrawInfo:PTR TO DrawInfo   
       Bounds:Rectangle     
    State:LONG      
ENDOBJECT


#endif 
