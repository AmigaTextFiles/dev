/***************************************************************************
** 
** MUI - MagicUserInterface
** (c) 1993-1996 Stefan Stuntz
** 
** C++ Header File for MUI 3.8 by Nicholas Allen
** 
** This header allows the use of MUI through C++ classes instead of using
** C and BOOPSI. The advantage of this approach is that more errors will
** be found at compile time and it makes the code easier to read and write.
** 
****************************************************************************
** Creating objects
****************************************************************************
** 
** Objects can be declared in C++ without initializing them by using the
** following syntax:
** 
**     CMUI_<class>  object;
** 
** For example:
** 
**     CMUI_Window   myWindow;
** 
** Because this does no initialization the muimaster.library does not
** have to be open at this point. This allows objects to be declared
** within structures, classes and as global variables without having to
** initialize them first.
** 
** Having declared an object it could be initialized it later using the
** following syntax:
** 
**     object = CMUI_<class> (<tags>);
** 
**     eg:
** 
**     myWindow = CMUI_Window (MUIA_Window_Title, "A test window",
**                             .
**                             .
**                             .
**                             TAG_DONE);
** 
** You can also declare and initialize objects at the same time by using
** the following syntax:
** 
**     CMUI_<class>  object (<tags>);
** 
** For example:
** 
**     CMUI_Slider   mySlider (MUIA_Numeric_Min, 1,
**                             MUIA_Numeric_Max, 10,
**                             TAG_DONE);
** 
** Versions of muimaster.library after V8 come with the ability to create
** common objects using MUI_MakeObject(). This can also be done in C++ by
** specifying the MakeObject parameters instead of the tag list for
** objects that are supported by MakeObject. For example:
** 
**     CMUI_Slider     mySlider ("example slider", 0, 100);
**     CMUI_Button     myButton ("_Ok");
**     CMUI_Checkmark  myCheckmark ("example checkmark");
** 
** The following classes allow creation of objects in this manner:
** 
**     Class name              Parameters
**     ----------              ----------
** 
**     CMUI_Label              STRPTR label, ULONG flags
**     CMUI_Button             STRPTR label
**     CMUI_Checkmark          STRPTR label
**     CMUI_Cycle              STRPTR label, STRPTR *entries
**     CMUI_Radio              STRPTR label, STRPTR *entries
**     CMUI_Slider             STRPTR label, LONG min, LONG max
**     CMUI_String             STRPTR label, LONG maxlen
**     CMUI_HSpace             LONG space
**     CMUI_VSpace             LONG space
**     CMUI_HBar               LONG space
**     CMUI_VBar               LONG space
**     CMUI_Menustrip          struct NewMenu *nm, ULONG flags
**     CMUI_Menuitem           STRPTR label, STRPTR shortcut, ULONG flags, ULONG data
**     CMUI_BarTitle           STRPTR label
**     CMUI_Numericbutton      STRPTR label, LONG min, LONG max, STRPTR format
** 
****************************************************************************
** Disposing objects
****************************************************************************
** 
** When you have finished using an object you need to dispose of it.
** Normally you will only have to dispose the Application object as this
** will automatically dispose all of its children. However, if you add
** and remove objects dynamically to the application then they will need
** to be disposed when they are removed. To dispose of an object you just
** call its Dispose method. For example:
** 
**     myApplication.Dispose();
** 
** will dispose of the application object and its children. The same
** syntax is used to dispose of any kind of object.
** 
** If you dispose of an object that is connected to a parent object then
** when the parent object is disposed it will get disposed twice and this
** will cause your program to crash. If MUIPlusPlus is in debug mode then
** an error message will be generated if you try to dispose an object
** connected to a parent and the object won't be disposed.
** 
****************************************************************************
** Getting and setting attributes
****************************************************************************
** 
** To get an attribute from an object you call the appropriate get member
** function. The get member function has the same name as the last part
** of the tag name in MUI. Thus to check if a window is open or not (i.e.
** get its MUIA_Window_Open attribute) you would write:
** 
**     if (myWindow.Open())
**     {
**         .
**         .
**         .
**     }
** 
** 
** To set an attribute you call the appropraite set member function. The
** set member function has the same name as the last part of the tag name
** in MUI but is peceeded by "Set". The value to set the attribute is
** passed as a parameter. Thus to open a window object (i.e. set its
** MUIA_Window_Open attribute to TRUE) you would write:
** 
**     myWindow.SetOpen(TRUE);
** 
****************************************************************************
** Calling methods
****************************************************************************
** 
** To call a method just call the member function of the object with the
** same name as the last part of the method tag with the parameters to
** the method. For example, to call the Jump method for a List object to
** jump to line 10 you would write:
** 
**     myList.Jump(10);    // Scroll the 10th line into view
** 
** Because of the way BOOPSI has been implemented calling methods that
** have a variable number of arguments cannot be called in exactly the
** same way as those with a fixed number of arguments. In MUIPlusPlus you
** must pass an object called "sva" (meaning Start Variable Args) as the
** first argument to the method and then any other arguments must follow.
** For example, the Notify method of an object takes a variable number of
** arguments. To setup a notification for an application object to return
** MUIV_Application_ReturnID_Quit when a window object is closed:
** 
**     window.Notify(sva, MUIA_Window_CloseRequest, TRUE,
**                   app, 2, MUIM_Application_ReturnID,
**                   MUIV_Application_ReturnID_Quit);
** 
** The only difference, therefore, is that you must pass "sva" as the
** first parameter. If you forget to do this then the compiler will
** object (you will not cause any problems in your program by forgetting
** to do this- it just won't compile).
** 
** 
***************************************************************************/
#ifndef LIBRARIES_MUI_HPP
#define LIBRARIES_MUI_HPP

// Many MUI shortcuts are incompatiable with this header as they have the
// same name as member functions in classes. For this reason they cannot
// be included. Instead, the shortcuts which are compatiable are redefined
// later in this header file.

#ifndef MUI_NOSHORTCUTS
#define MUI_NOSHORTCUTS
#endif

#ifndef LIBRARIES_MUI_H
#include <libraries/mui.h>
#endif

// Include prototypes for MUI and BOOPSI function calls

#ifdef __GNUC__
#include <inline/muimaster.h>
#include <inline/intuition.h>
#else
#include <clib/muimaster_protos.h>
#include <clib/intuition_protos.h>
#endif

#include <clib/alib_protos.h>

// Shortcuts that are compatiable with this header are redefined here.
// The standard MUI <class>Object shortcuts for creating objects
// (eg. WindowObject etc) have been redefined as <class>Obj
// (eg. WindowObj) so as not to conflict with member functions of the
// same name within classes.

#ifndef MUIPP_NOSHORTCUTS

#define MenustripObj 		MUI_NewObject(MUIC_Menustrip
#define MenuObj  			MUI_NewObject(MUIC_Menu
#define MenuObjT(name)   	MUI_NewObject(MUIC_Menu,MUIA_Menu_Title,name
#define MenuitemObj  		MUI_NewObject(MUIC_Menuitem
#define WindowObj			MUI_NewObject(MUIC_Window
#define ImageObj 			MUI_NewObject(MUIC_Image
#define BitmapObj			MUI_NewObject(MUIC_Bitmap
#define BodychunkObj 		MUI_NewObject(MUIC_Bodychunk
#define NotifyObj			MUI_NewObject(MUIC_Notify
#define ApplicationObj   	MUI_NewObject(MUIC_Application
#define TextObj  			MUI_NewObject(MUIC_Text
#define RectangleObj 		MUI_NewObject(MUIC_Rectangle
#define BalanceObj   		MUI_NewObject(MUIC_Balance
#define ListObj  			MUI_NewObject(MUIC_List
#define PropObj  			MUI_NewObject(MUIC_Prop
#define StringObj			MUI_NewObject(MUIC_String
#define ScrollbarObj 		MUI_NewObject(MUIC_Scrollbar
#define ListviewObj  		MUI_NewObject(MUIC_Listview
#define RadioObj 			MUI_NewObject(MUIC_Radio
#define VolumelistObj		MUI_NewObject(MUIC_Volumelist
#define FloattextObj 		MUI_NewObject(MUIC_Floattext
#define DirlistObj   		MUI_NewObject(MUIC_Dirlist
#define CycleObj 			MUI_NewObject(MUIC_Cycle
#define GaugeObj 			MUI_NewObject(MUIC_Gauge
#define ScaleObj 			MUI_NewObject(MUIC_Scale
#define NumericObj   		MUI_NewObject(MUIC_Numeric
#define SliderObj			MUI_NewObject(MUIC_Slider
#define NumericbuttonObj 	MUI_NewObject(MUIC_Numericbutton
#define KnobObj  			MUI_NewObject(MUIC_Knob
