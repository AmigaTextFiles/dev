 /* Copyright © 1995 Kai Hofmann. All rights reserved. */

 #ifndef NOERRORHANDLING
 #include <exec/types.h>


 LONG MUI_Fault(LONG code, STRPTR header, STRPTR buffer, LONG len);
 const STRPTR MUI_AttrName(const STRPTR ClassName, const ULONG AttrID);
 ULONG MUI_AttrClass(const ULONG AttrID);
 const STRPTR MUI_MethodName(const STRPTR ClassName, const ULONG MethodID);
 ULONG MUI_MethodClass(const ULONG MethodID);
 const STRPTR MUI_ClassName(const ULONG ClassID);


 #ifndef MUIEXT
   #define NotifyClass		 1
   #define FamilyClass		 2
   #define MenustripClass 	 3
   #define MenuClass		 4
   #define MenuitemClass	 5
   #define ApplicationClass	 6
   #define WindowClass		 7
   #define AboutmuiClass	 8
   #define AreaClass		 9
   #define RectangleClass 	10
   #define BalanceClass		11
   #define ImageClass		12
   #define BitmapClass		13
   #define BodychunkClass 	14
   #define TextClass		15
   #define GadgetClass		16
   #define StringClass		17
   #define BoopsiClass		18
   #define PropClass		19
   #define GaugeClass		20
   #define ScaleClass		21
   #define ColorfieldClass	22
   #define ListClass		23
   #define FloattextClass 	24
   #define VolumelistClass	25
   #define ScrmodelistClass	26
   #define DirlistClass		27
   #define NumericClass		28
   #define FramedisplayClass	29
   #define PopframeClass	30
   #define ImagedisplayClass	31
   #define PopimageClass	32
   #define PendisplayClass	33
   #define PoppenClass		34
   #define KnobClass		35
   #define LevelmeterClass	36
   #define NumericbuttonClass	37
   #define SliderClass		38
   #define GroupClass		39
   #define MccprefsClass	40
   #define RegisterClass	41
   #define SettingsgroupClass	42
   #define SettingsClass	43
   #define FrameadjustClass	44
   #define PenadjustClass 	45
   #define ImageadjustClass	46
   #define VirtgroupClass 	47
   #define ScrollgroupClass	48
   #define ScrollbarClass 	49
   #define ListviewClass	50
   #define RadioClass		51
   #define CycleClass		52
   #define ColoradjustClass	53
   #define PaletteClass		54
   #define PopstringClass 	55
   #define PopobjectClass 	56
   #define PoplistClass		57
   #define PopscreenClass 	58
   #define PopaslClass		59
   #define SemaphoreClass 	60
   #define ApplistClass		61
   #define DataspaceClass 	62
   #define ConfigdataClass	63

   #define BusyClass		64
   #define MonthNavigatorClass	65

   #define MUIEXT
 #endif
 #endif
