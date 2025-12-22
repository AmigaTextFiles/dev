#ifndef	DATATYPES_DATATYPESCLASS_H
#define	DATATYPES_DATATYPESCLASS_H

#ifndef	UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif
#ifndef	DATATYPES_DATATYPES_H
MODULE  'datatypes/datatypes'
#endif
#ifndef	INTUITION_INTUITION_H
MODULE  'intuition/intuition'
#endif
#ifndef	DEVICES_PRINTER_H
MODULE  'devices/printer'
#endif
#ifndef	DEVICES_PRTBASE_H
MODULE  'devices/prtbase'
#endif

#define	DATATYPESCLASS		'datatypesclass'

#define	DTA_Dummy		(TAG_USER+$1000)

#define	DTA_TextAttr		(DTA_Dummy+10)
	
#define	DTA_TopVert		(DTA_Dummy+11)
	
#define	DTA_VisibleVert		(DTA_Dummy+12)
	
#define	DTA_TotalVert		(DTA_Dummy+13)
	
#define	DTA_VertUnit		(DTA_Dummy+14)
	
#define	DTA_TopHoriz		(DTA_Dummy+15)
	
#define	DTA_VisibleHoriz	(DTA_Dummy+16)
	
#define	DTA_TotalHoriz		(DTA_Dummy+17)
	
#define	DTA_HorizUnit		(DTA_Dummy+18)
	
#define	DTA_NodeName		(DTA_Dummy+19)
	
#define	DTA_Title		(DTA_Dummy+20)
	
#define	DTA_TriggerMethods	(DTA_Dummy+21)
	
#define	DTA_Data		(DTA_Dummy+22)
	
#define	DTA_TextFont		(DTA_Dummy+23)
	
#define	DTA_Methods		(DTA_Dummy+24)
	
#define	DTA_PrinterStatus	(DTA_Dummy+25)
	
#define	DTA_PrinterProc		(DTA_Dummy+26)
	
#define	DTA_LayoutProc		(DTA_Dummy+27)
	
#define	DTA_Busy		(DTA_Dummy+28)
	
#define	DTA_Sync		(DTA_Dummy+29)
	
#define	DTA_BaseName		(DTA_Dummy+30)
	
#define	DTA_GroupID		(DTA_Dummy+31)
	
#define	DTA_ErrorLevel		(DTA_Dummy+32)
	
#define	DTA_ErrorNumber		(DTA_Dummy+33)
	
#define	DTA_ErrorString		(DTA_Dummy+34)
	
#define	DTA_Conductor		(DTA_Dummy+35)
	
#define	DTA_ControlPanel	(DTA_Dummy+36)
	
#define	DTA_Immediate		(DTA_Dummy+37)
	
#define	DTA_Repeat		(DTA_Dummy+38)
	

#define	DTA_Name		(DTA_Dummy+100)
#define	DTA_SourceType		(DTA_Dummy+101)
#define	DTA_Handle		(DTA_Dummy+102)
#define	DTA_DataType		(DTA_Dummy+103)
#define	DTA_Domain		(DTA_Dummy+104)

#define	DTA_Left		(DTA_Dummy+105)
#define	DTA_Top			(DTA_Dummy+106)
#define	DTA_Width		(DTA_Dummy+107)
#define	DTA_Height		(DTA_Dummy+108)
#define	DTA_ObjName		(DTA_Dummy+109)
#define	DTA_ObjAuthor		(DTA_Dummy+110)
#define	DTA_ObjAnnotation	(DTA_Dummy+111)
#define	DTA_ObjCopyright	(DTA_Dummy+112)
#define	DTA_ObjVersion		(DTA_Dummy+113)
#define	DTA_ObjectID		(DTA_Dummy+114)
#define	DTA_UserData		(DTA_Dummy+115)
#define	DTA_FrameInfo		(DTA_Dummy+116)

#define	DTA_RelRight		(DTA_Dummy+117)
#define	DTA_RelBottom		(DTA_Dummy+118)
#define	DTA_RelWidth		(DTA_Dummy+119)
#define	DTA_RelHeight		(DTA_Dummy+120)
#define	DTA_SelectDomain	(DTA_Dummy+121)
#define	DTA_TotalPVert		(DTA_Dummy+122)
#define	DTA_TotalPHoriz		(DTA_Dummy+123)
#define	DTA_NominalVert		(DTA_Dummy+124)
#define	DTA_NominalHoriz	(DTA_Dummy+125)

#define	DTA_DestCols		(DTA_Dummy+400)
	
#define	DTA_DestRows		(DTA_Dummy+401)
	
#define	DTA_Special		(DTA_Dummy+402)
	
#define	DTA_RastPort		(DTA_Dummy+403)
	
#define	DTA_ARexxPortName	(DTA_Dummy+404)
	

#define	DTST_RAM		1
#define	DTST_FILE		2
#define	DTST_CLIPBOARD		3
#define	DTST_HOTLINK		4


OBJECT DTSpecialInfo

     	 Lock:SignalSemaphore	
    Flags:LONG
    TopVert:LONG	
    VisVert:LONG	
    TotVert:LONG	
    OTopVert:LONG	
    VertUnit:LONG	
    TopHoriz:LONG	
    VisHoriz:LONG	
    TotHoriz:LONG	
    OTopHoriz:LONG	
    HorizUnit:LONG	
ENDOBJECT


#define	DTSIF_LAYOUT		(1<<0)

#define	DTSIF_NEWSIZE		(1<<1)
#define	DTSIF_DRAGGING		(1<<2)
#define	DTSIF_DRAGSELECT	(1<<3)
#define	DTSIF_HIGHLIGHT		(1<<4)

#define	DTSIF_PRINTING		(1<<5)

#define	DTSIF_LAYOUTPROC	(1<<6)

OBJECT DTMethod

    Label:PTR TO CHAR
    Command:PTR TO CHAR
    Method:LONG
ENDOBJECT


#define	DTM_Dummy		$600

#define	DTM_FRAMEBOX		$601

#define	DTM_PROCLAYOUT		$602

#define	DTM_ASYNCLAYOUT		$603

#define	DTM_REMOVEDTOBJECT	$604
#define	DTM_SELECT		$605
#define	DTM_CLEARSELECTED	$606
#define	DTM_COPY		$607
#define	DTM_PRINT		$608
#define	DTM_ABORTPRINT		$609
#define	DTM_NEWMEMBER		$610
#define	DTM_DISPOSEMEMBER	$611
#define	DTM_GOTO		$630
#define	DTM_TRIGGER		$631
#define	DTM_OBTAINDRAWINFO	$640
#define	DTM_DRAW		$641
#define	DTM_RELEASEDRAWINFO	$642
#define	DTM_WRITE		$650

OBJECT FrameInfo

    PropertyFlags:LONG		
    Resolution:Point		
    RedBits:UBYTE
    GreenBits:UBYTE
    BlueBits:UBYTE
        OBJECT Dimensions

	Width:LONG
	Height:LONG
	Depth:LONG
     ENDOBJECT
     	Screen:PTR TO Screen
     	ColorMap:PTR TO ColorMap
    Flags:LONG
ENDOBJECT

#define	FIF_SCALABLE	$1
#define	FIF_SCROLLABLE	$2
#define	FIF_REMAPPABLE	$4

OBJECT dtGeneral

    MethodID:LONG
     	GInfo:PTR TO GadgetInfo
ENDOBJECT


OBJECT dtSelect

    MethodID:LONG
     	GInfo:PTR TO GadgetInfo
     	 Select:Rectangle
ENDOBJECT


OBJECT dtFrameBox

    MethodID:LONG
     	GInfo:PTR TO GadgetInfo
     	ContentsInfo:PTR TO FrameInfo	
     	FrameInfo:PTR TO FrameInfo		
    SizeFrameInfo:LONG
    FrameFlags:LONG
ENDOBJECT

#ifndef	FRAMEF_SPECIFY
#define FRAMEF_SPECIFY	(1<<0)	
#endif

OBJECT dtGoto

    MethodID:LONG
     	GInfo:PTR TO GadgetInfo
    NodeName:PTR TO CHAR		
     	AttrList:PTR TO TagItem		
ENDOBJECT


OBJECT dtTrigger

    MethodID:LONG
     	GInfo:PTR TO GadgetInfo
    Function:LONG
    Data:LONG
ENDOBJECT

#define	STM_PAUSE		1
#define	STM_PLAY		2
#define	STM_CONTENTS		3
#define	STM_INDEX		4
#define	STM_RETRACE		5
#define	STM_BROWSE_PREV		6
#define	STM_BROWSE_NEXT		7
#define	STM_NEXT_FIELD		8
#define	STM_PREV_FIELD		9
#define	STM_ACTIVATE_FIELD	10
#define	STM_COMMAND		11

#define	STM_REWIND		12
#define	STM_FASTFORWARD		13
#define	STM_STOP		14
#define	STM_RESUME		15
#define	STM_LOCATE		16

UNION printerIO

      ios:IOStdReq
      iodrp:IODRPReq
      iopc:IOPrtCmdReq
ENDUNION


OBJECT dtPrint

    MethodID:LONG
     	GInfo:PTR TO GadgetInfo		
     	PIO:PTR TO printerIO		
     	AttrList:PTR TO TagItem		
ENDOBJECT


OBJECT dtDraw

    MethodID:LONG
     	RPort:PTR TO RastPort
    Left:LONG
    Top:LONG
    Width:LONG
    Height:LONG
    TopHoriz:LONG
    TopVert:LONG
     	AttrList:PTR TO TagItem		
ENDOBJECT


OBJECT dtWrite

    MethodID:LONG
     	GInfo:PTR TO GadgetInfo		
    FileHandle:LONG	
    Mode:LONG
     	AttrList:PTR TO TagItem		
ENDOBJECT


#define	DTWM_IFF	0

#define	DTWM_RAW	1
#endif 
