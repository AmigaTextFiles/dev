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
#define LevelmeterObj		MUI_NewObject(MUIC_Levelmeter
#define BoopsiObj			MUI_NewObject(MUIC_Boopsi
#define ColorfieldObj		MUI_NewObject(MUIC_Colorfield
#define PenadjustObj 		MUI_NewObject(MUIC_Penadjust
#define ColoradjustObj   	MUI_NewObject(MUIC_Coloradjust
#define PaletteObj   		MUI_NewObject(MUIC_Palette
#define GroupObj 			MUI_NewObject(MUIC_Group
#define RegisterObj  		MUI_NewObject(MUIC_Register
#define VirtgroupObj 		MUI_NewObject(MUIC_Virtgroup
#define ScrollgroupObj   	MUI_NewObject(MUIC_Scrollgroup
#define PopstringObj 		MUI_NewObject(MUIC_Popstring
#define PopObjObj 			MUI_NewObject(MUIC_Popobject
#define PoplistObj   		MUI_NewObject(MUIC_Poplist
#define PopaslObj			MUI_NewObject(MUIC_Popasl
#define PendisplayObj		MUI_NewObject(MUIC_Pendisplay
#define PoppenObj			MUI_NewObject(MUIC_Poppen
#define AboutmuiObj  		MUI_NewObject(MUIC_Aboutmui
#define ScrmodelistObj   	MUI_NewObject(MUIC_Scrmodelist
#define KeyentryObj  		MUI_NewObject(MUIC_Keyentry
#define VGroup  			MUI_NewObject(MUIC_Group
#define HGroup  			MUI_NewObject(MUIC_Group,MUIA_Group_Horiz,TRUE
#define ColGroup(cols)  	MUI_NewObject(MUIC_Group,MUIA_Group_Columns,(cols)
#define RowGroup(rows)  	MUI_NewObject(MUIC_Group,MUIA_Group_Rows   ,(rows)
#define PageGroup   		MUI_NewObject(MUIC_Group,MUIA_Group_PageMode,TRUE
#define VGroupV 			MUI_NewObject(MUIC_Virtgroup
#define HGroupV 			MUI_NewObject(MUIC_Virtgroup,MUIA_Group_Horiz,TRUE
#define ColGroupV(cols) 	MUI_NewObject(MUIC_Virtgroup,MUIA_Group_Columns,(cols)
#define RowGroupV(rows) 	MUI_NewObject(MUIC_Virtgroup,MUIA_Group_Rows   ,(rows)
#define PageGroupV  		MUI_NewObject(MUIC_Virtgroup,MUIA_Group_PageMode,TRUE
#define RegisterGroup(t)	MUI_NewObject(MUIC_Register,MUIA_Register_Titles,(t)
#define End 				TAG_DONE)

#define Child       	  	MUIA_Group_Child
#define FChild				MUIA_Family_Child
#define SubWindow   	  	MUIA_Application_Window
#define WindowContents    	MUIA_Window_RootObject
#define CMUI_VGroup			CMUI_Group

// Frame types

#define NoFrame 		 MUIA_Frame, MUIV_Frame_None
#define ButtonFrame 	 MUIA_Frame, MUIV_Frame_Button
#define ImageButtonFrame MUIA_Frame, MUIV_Frame_ImageButton
#define TextFrame   	 MUIA_Frame, MUIV_Frame_Text
#define StringFrame 	 MUIA_Frame, MUIV_Frame_String
#define ReadListFrame    MUIA_Frame, MUIV_Frame_ReadList
#define InputListFrame   MUIA_Frame, MUIV_Frame_InputList
#define PropFrame   	 MUIA_Frame, MUIV_Frame_Prop
#define SliderFrame 	 MUIA_Frame, MUIV_Frame_Slider
#define GaugeFrame  	 MUIA_Frame, MUIV_Frame_Gauge
#define VirtualFrame	 MUIA_Frame, MUIV_Frame_Virtual
#define GroupFrame  	 MUIA_Frame, MUIV_Frame_Group
#define GroupFrameT(s)   MUIA_Frame, MUIV_Frame_Group, MUIA_FrameTitle, s, MUIA_Background, MUII_GroupBack

// Spacing objects

#define HVSpace 		  MUI_NewObject(MUIC_Rectangle,TAG_DONE)
#define HSpace(x)   	  MUI_MakeObject(MUIO_HSpace,x)
#define VSpace(x)   	  MUI_MakeObject(MUIO_VSpace,x)
#define HCenter(obj)	  (HGroup, GroupSpacing(0), Child, HSpace(0), Child, (obj), Child, HSpace(0), End)
#define VCenter(obj)	  (VGroup, GroupSpacing(0), Child, VSpace(0), Child, (obj), Child, VSpace(0), End)
#define InnerSpacing(h,v) MUIA_InnerLeft,(h),MUIA_InnerRight,(h),MUIA_InnerTop,(v),MUIA_InnerBottom,(v)
#define GroupSpacing(x)   MUIA_Group_Spacing,x

// Labelling objects. The standard Label shortcut has been redefined as RLabel
// because some classes have an attribute called "Label".

#define RLabel(label)  MUI_MakeObject(MUIO_Label,label,0)
#define RLabel1(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_SingleFrame)
#define RLabel2(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_DoubleFrame)
#define LLabel(label)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned)
#define LLabel1(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned|MUIO_Label_SingleFrame)
#define LLabel2(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame)
#define CLabel(label)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered)
#define CLabel1(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered|MUIO_Label_SingleFrame)
#define CLabel2(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered|MUIO_Label_DoubleFrame)

#define FreeLabel(label)   MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert)
#define FreeLabel1(label)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_SingleFrame)
#define FreeLabel2(label)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_DoubleFrame)
#define FreeLLabel(label)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned)
#define FreeLLabel1(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_SingleFrame)
#define FreeLLabel2(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame)
#define FreeCLabel(label)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered)
#define FreeCLabel1(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_SingleFrame)
#define FreeCLabel2(label) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_DoubleFrame)

#define KeyLabel(label,key)   MUI_MakeObject(MUIO_Label,label,key)
#define KeyLabel1(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_SingleFrame|(key))
#define KeyLabel2(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_DoubleFrame|(key))
#define KeyLLabel(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned|(key))
#define KeyLLabel1(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned|MUIO_Label_SingleFrame|(key))
#define KeyLLabel2(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame|(key))
#define KeyCLabel(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered|(key))
#define KeyCLabel1(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered|MUIO_Label_SingleFrame|(key))
#define KeyCLabel2(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_Centered|MUIO_Label_DoubleFrame|(key))

#define FreeKeyLabel(label,key)   MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|(key))
#define FreeKeyLabel1(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_SingleFrame|(key))
#define FreeKeyLabel2(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_DoubleFrame|(key))
#define FreeKeyLLabel(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|(key))
#define FreeKeyLLabel1(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_SingleFrame|(key))
#define FreeKeyLLabel2(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_LeftAligned|MUIO_Label_DoubleFrame|(key))
#define FreeKeyCLabel(label,key)  MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered|(key))
#define FreeKeyCLabel1(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_SingleFrame|(key))
#define FreeKeyCLabel2(label,key) MUI_MakeObject(MUIO_Label,label,MUIO_Label_FreeVert|MUIO_Label_Centered|MUIO_Label_DoubleFrame|(key))

#define NO_TAGS     	  	((Tag)TAG_DONE)

#endif				// MUIPP_NOSHORTCUTS

// All variable args methods must start with a StartVarArgs object

class StartVarArgs
{
public:
    ULONG methodID;
};

static StartVarArgs sva;    // Use this object at the start of variable
                            // argument methods.

// When MUIPP_DEBUG is defined then checking is performed to ensure objects
// create successfully, required tags are passed and indexes into lists aren't
// out of range. Depending on the error found either an error or a warning
// message will be generated and printed on stderr. If an error occurs then
// the application is terminated but a warning will just print a message.
// At present, errors can only occur if you use a template Listview or List
// object (ie CTMUI_Listview or CTMUI_List classes) and supply an invalid index
// to the [] operator.

#ifdef MUIPP_DEBUG

#ifdef __GNUC__
#include <inline/exec.h>
#include <inline/utility.h>
#else
#include <clib/exec_protos.h>
#include <clib/utility_protos.h>
#endif

#include <stdio.h>

// This defines the maximum number of tags that are likely to be passed to an
// object during creation. If TAG_DONE is not found within this number of tags
// then an error message will be generated. The default is 30 but this can be
// overridden by defining it to something else or this feature can be turned off
// by defining it to be 0.

#ifndef MUIPP_DEBUG_NUMTAGS
#define MUIPP_DEBUG_NUMTAGS 30
#endif

static void
_MUIPPWarning (const char *message, ...)
{
	fprintf (stderr, "MUIPP Warning: ");
	vfprintf (stderr, message, (_VA_LIST_)(&message + 1));
}

static void
_MUIPPError (const char *message, ...)
{
	fprintf (stderr, "MUIPP Error: ");
	vfprintf (stderr, message, (_VA_LIST_)(&message + 1));

	fprintf (stderr, "Do you wish to quit your application (q) or continue (c)?");
	fflush (stderr);
	char response[10];
	fscanf (stderr, "%s", response);

	if (response[0] == 'q' || response[0] == 'Q')
		exit (10);
}

static void
_CheckTagsSpecifiedA (const char *className,
                      struct TagItem *tags,
                      struct TagItem *requiredTags)
{
	struct TagItem *tag, *tstate;
	int i;

    // Make sure utility.library has been opened first

    if (UtilityBase == NULL)
    {
     	if ((UtilityBase = (struct UtilityBase *)OpenLibrary ("utility.library", 0)) == NULL)
     	{
     	 	_MUIPPWarning ("Could not open utility.library for debugging purposes:\n"
     	 				   "Cannot check correct tags specified or for missing TAG_DONE\n");
     	 	return;
     	}
    }

    // Check for possible missing TAG_DONE

    if (MUIPP_DEBUG_NUMTAGS != 0)
    {
		for (tstate = tags, i = 0; (tag = NextTagItem(&tstate)) != NULL && i < MUIPP_DEBUG_NUMTAGS;)
    		;

    	if (i == MUIPP_DEBUG_NUMTAGS)
    		_MUIPPError ("Possible missing TAG_DONE during construction of a %s object\n", className);
    }

    // Check all required tags are passed

    for (tstate = requiredTags; (tag = NextTagItem(&tstate)) != NULL;)
    {

        if (FindTagItem (tag->ti_Tag, tags) == NULL)
            _MUIPPWarning ("When constructing %s objects the %s attribute should be specified\n",
                           className,
                           (const char *)tag->ti_Data);
    }
}

static void
_CheckTagsSpecified (const char *className,
                     struct TagItem *tags,
                     Tag tag1, ...)
{
    _CheckTagsSpecifiedA (className, tags, (struct TagItem *)&tag1);
}

#endif      /* MUIPP_DEBUG */


/***************************************************************************
**
**                       CMUI_Object class definition
**
**      This is the root object that all MUI C++ classes inherit from
**
***************************************************************************/

class CMUI_Object
{
public:

    CMUI_Object (void)
    {
        object = NULL;
    }

    // If you wish to check if the object was created successfully then
    // call this.

    BOOL IsValid (void) const
    {
        return (object != NULL);
    }

    // Methods to get and set attributes by tag ID. You can use these
    // in derived classes to get and set attributes, instead of having
    // to call the intuition.library/GetAttr() and SetAttrs() functions.

    // Get value of attribute and place value in supplied value address.

    ULONG GetAttr (Tag attr, ULONG *value) const
    {
	 	return ::GetAttr (attr, object, value);
	}

	// Get and return value of attribute

	ULONG GetAttr (Tag attr) const
	{
	 	ULONG value;
	 	GetAttr (attr, &value);
	 	return value;
	}

	void SetAttr (Tag attr, ULONG value)
	{
		SetAttrs (object, attr, value, TAG_DONE);
	}

	// Call a method on this object specified by the supplied method id
	// and parameters.

	ULONG DoMethod (ULONG methodID, ...)
	{
	 	return ::DoMethodA (object, (Msg)&methodID);
	}

	ULONG DoMethodA (Msg msg)
	{
		return ::DoMethodA (object, msg);
	}

    // This can be called to dispose of an object
    // Note: this should only be called for objects that are allocated
    // dynamically and are not disposed when the application object gets
    // disposed. If debugging is turned on then a warning message will
    // be printed if you try to do this and the object won't be disposed.

    void Dispose (void)
    {
#ifdef MUIPP_DEBUG
        if ((Object *)GetAttr (MUIA_Parent) != NULL)
        {
            _MUIPPWarning ("Tried to dispose an object that has a parent object:\n"
                           "Object not disposed\n");
            return;
        }
#endif
        MUI_DisposeObject (object);
        object = NULL;
    }

    // Coersion to BOOPSI objects and to Tags

    operator Object * () const
    {
        return object;
    }

    operator Tag () const
    {
        return (Tag)object;
    }

    // Dynamically adding and removing objects

    void AddMember (Object *child)
    {
        DoMethod (OM_ADDMEMBER, child);
    }

    void RemMember (Object *child)
    {
        DoMethod (OM_REMMEMBER, child);
    }

protected:
    Object *object;       // Pointer to MUI BOOPSI based object
};

/***************************************************************************
**                       CMUI_Notify class definition                       
***************************************************************************/

class CMUI_Notify : public CMUI_Object
{
public:
	Object * ApplicationObject (void) const;
	struct AppMessage * AppMessage (void) const;
	LONG HelpLine (void) const;
	void SetHelpLine (LONG value);
	STRPTR HelpNode (void) const;
	void SetHelpNode (STRPTR value);
	void SetNoNotify (BOOL value);
	ULONG ObjectID (void) const;
	void SetObjectID (ULONG value);
	Object * Parent (void) const;
	LONG Revision (void) const;
	ULONG UserData (void) const;
	void SetUserData (ULONG value);
	LONG Version (void) const;
	ULONG CallHook (StartVarArgs sva, struct Hook * Hook, ULONG param1, ...);
	ULONG Export (Object * dataspace);
	ULONG FindUData (ULONG udata);
	ULONG GetConfigItem (ULONG id, ULONG * storage);
	ULONG GetUData (ULONG udata, ULONG attr, ULONG * storage);
	ULONG Import (Object * dataspace);
	ULONG KillNotify (ULONG TrigAttr);
	ULONG KillNotifyObj (ULONG TrigAttr, Object * dest);
	ULONG MultiSet (StartVarArgs sva, ULONG attr, ULONG val, APTR obj, ...);
	ULONG NoNotifySet (StartVarArgs sva, ULONG attr, char * format, ULONG val, ...);
	ULONG Notify (StartVarArgs sva, ULONG TrigAttr, ULONG TrigVal, APTR DestObj, ULONG FollowParams, ...);
	ULONG Set (ULONG attr, ULONG val);
	ULONG SetAsString (StartVarArgs sva, ULONG attr, char * format, ULONG val, ...);
	ULONG SetUData (ULONG udata, ULONG attr, ULONG val);
	ULONG SetUDataOnce (ULONG udata, ULONG attr, ULONG val);
	ULONG WriteLong (ULONG val, ULONG * memory);
	ULONG WriteString (char * str, char * memory);
protected:
	CMUI_Notify (void)
	: CMUI_Object ()
	{
	}

};

/***************************************************************************
**                       CMUI_Family class definition                       
***************************************************************************/

class CMUI_Family : public CMUI_Notify
{
public:
	struct MinList * List (void) const;
	ULONG AddHead (Object * obj);
	ULONG AddTail (Object * obj);
	ULONG Insert (Object * obj, Object * pred);
	ULONG Remove (Object * obj);
	ULONG Sort (StartVarArgs sva, Object * obj, ...);
	ULONG Transfer (Object * family);
protected:
	CMUI_Family (void)
	: CMUI_Notify ()
	{
	}

};

/***************************************************************************
**                     CMUI_Menustrip class definition                      
***************************************************************************/

class CMUI_Menustrip : public CMUI_Family
{
public:
	CMUI_Menustrip (void)
	: CMUI_Family ()
	{
	}

	CMUI_Menustrip (struct TagItem *tags)
	: CMUI_Family ()
	{
		object = MUI_NewObjectA (MUIC_Menustrip, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Menustrip object\n");
#endif
	}

	CMUI_Menustrip (Tag tag1, ...)
	: CMUI_Family ()
	{
		object = MUI_NewObjectA (MUIC_Menustrip, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Menustrip object\n");
#endif
	}

	CMUI_Menustrip (Object * obj)
	: CMUI_Family ()
	{
		object = obj;
	}

	CMUI_Menustrip (struct NewMenu * nm, ULONG flags)
	: CMUI_Family ()
	{
		object = MUI_MakeObject (MUIO_MenustripNM, nm, flags);
	}

	CMUI_Menustrip & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	BOOL Enabled (void) const;
	void SetEnabled (BOOL value);
};

/***************************************************************************
**                        CMUI_Menu class definition                        
***************************************************************************/

class CMUI_Menu : public CMUI_Family
{
public:
	CMUI_Menu (void)
	: CMUI_Family ()
	{
	}

	CMUI_Menu (struct TagItem *tags)
	: CMUI_Family ()
	{
		object = MUI_NewObjectA (MUIC_Menu, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Menu object\n");
#endif
	}

	CMUI_Menu (Tag tag1, ...)
	: CMUI_Family ()
	{
		object = MUI_NewObjectA (MUIC_Menu, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Menu object\n");
#endif
	}

	CMUI_Menu (Object * obj)
	: CMUI_Family ()
	{
		object = obj;
	}

	CMUI_Menu & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	BOOL Enabled (void) const;
	void SetEnabled (BOOL value);
	STRPTR Title (void) const;
	void SetTitle (STRPTR value);
};

/***************************************************************************
**                      CMUI_Menuitem class definition                      
***************************************************************************/

class CMUI_Menuitem : public CMUI_Family
{
public:
	CMUI_Menuitem (void)
	: CMUI_Family ()
	{
	}

	CMUI_Menuitem (struct TagItem *tags)
	: CMUI_Family ()
	{
		object = MUI_NewObjectA (MUIC_Menuitem, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Menuitem object\n");
#endif
	}

	CMUI_Menuitem (Tag tag1, ...)
	: CMUI_Family ()
	{
		object = MUI_NewObjectA (MUIC_Menuitem, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Menuitem object\n");
#endif
	}

	CMUI_Menuitem (Object * obj)
	: CMUI_Family ()
	{
		object = obj;
	}

	CMUI_Menuitem (STRPTR label, STRPTR shortcut, ULONG flags, ULONG data)
	: CMUI_Family ()
	{
		object = MUI_MakeObject (MUIO_Menuitem, label, shortcut, flags, data);
	}

	CMUI_Menuitem & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	BOOL Checked (void) const;
	void SetChecked (BOOL value);
	BOOL Checkit (void) const;
	void SetCheckit (BOOL value);
	BOOL CommandString (void) const;
	void SetCommandString (BOOL value);
	BOOL Enabled (void) const;
	void SetEnabled (BOOL value);
	LONG Exclude (void) const;
	void SetExclude (LONG value);
	STRPTR Shortcut (void) const;
	void SetShortcut (STRPTR value);
	STRPTR Title (void) const;
	void SetTitle (STRPTR value);
	BOOL Toggle (void) const;
	void SetToggle (BOOL value);
	struct MenuItem * Trigger (void) const;
};

/***************************************************************************
**                    CMUI_Application class definition                     
***************************************************************************/

class CMUI_Application : public CMUI_Notify
{
public:
	CMUI_Application (void)
	: CMUI_Notify ()
	{
	}

	CMUI_Application (struct TagItem *tags)
	: CMUI_Notify ()
	{
#ifdef MUIPP_DEBUG
		_CheckTagsSpecified ("CMUI_Application", tags, MUIA_Application_Author, "MUIA_Application_Author", MUIA_Application_Base, "MUIA_Application_Base", MUIA_Application_Copyright, "MUIA_Application_Copyright", MUIA_Application_Description, "MUIA_Application_Description", MUIA_Application_Title, "MUIA_Application_Title", MUIA_Application_Version, "MUIA_Application_Version", TAG_DONE);
#endif
		object = MUI_NewObjectA (MUIC_Application, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Application object\n");
#endif
	}

	CMUI_Application (Tag tag1, ...)
	: CMUI_Notify ()
	{
#ifdef MUIPP_DEBUG
		_CheckTagsSpecified ("CMUI_Application", (struct TagItem *)&tag1, MUIA_Application_Author, "MUIA_Application_Author", MUIA_Application_Base, "MUIA_Application_Base", MUIA_Application_Copyright, "MUIA_Application_Copyright", MUIA_Application_Description, "MUIA_Application_Description", MUIA_Application_Title, "MUIA_Application_Title", MUIA_Application_Version, "MUIA_Application_Version", TAG_DONE);
#endif
		object = MUI_NewObjectA (MUIC_Application, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Application object\n");
#endif
	}

	CMUI_Application (Object * obj)
	: CMUI_Notify ()
	{
		object = obj;
	}

	CMUI_Application & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	/* Adds a new window object to application */
	
	void AddWindow (Object *window)
	{
		DoMethod (OM_ADDMEMBER, window);
	}
	
	/* Removes a window object from the application */
	
	void RemoveWindow (Object *window)
	{
		DoMethod (OM_REMMEMBER, window);
	}
	
	BOOL Active (void) const;
	void SetActive (BOOL value);
	STRPTR Author (void) const;
	STRPTR Base (void) const;
	CxObj * Broker (void) const;
	struct Hook * BrokerHook (void) const;
	void SetBrokerHook (struct Hook * value);
	struct MsgPort * BrokerPort (void) const;
	LONG BrokerPri (void) const;
	struct MUI_Command * Commands (void) const;
	void SetCommands (struct MUI_Command * value);
	STRPTR Copyright (void) const;
	STRPTR Description (void) const;
	struct DiskObject * DiskObject (void) const;
	void SetDiskObject (struct DiskObject * value);
	BOOL DoubleStart (void) const;
	void SetDropObject (Object * value);
	BOOL ForceQuit (void) const;
	STRPTR HelpFile (void) const;
	void SetHelpFile (STRPTR value);
	BOOL Iconified (void) const;
	void SetIconified (BOOL value);
	ULONG MenuAction (void) const;
	ULONG MenuHelp (void) const;
	struct Hook * RexxHook (void) const;
	void SetRexxHook (struct Hook * value);
	struct RxMsg * RexxMsg (void) const;
	void SetRexxString (STRPTR value);
	void SetSleep (BOOL value);
	STRPTR Title (void) const;
	STRPTR Version (void) const;
	struct List * WindowList (void) const;
	ULONG AboutMUI (Object * refwindow);
	ULONG AddInputHandler (struct MUI_InputHandlerNode * ihnode);
	ULONG CheckRefresh (void);
	ULONG InputBuffered (void);
	ULONG Load (STRPTR name);
	ULONG NewInput (LONGBITS * signal);
	ULONG OpenConfigWindow (ULONG flags);
	ULONG PushMethod (StartVarArgs sva, Object * dest, LONG count, ...);
	ULONG RemInputHandler (struct MUI_InputHandlerNode * ihnode);
	ULONG ReturnID (ULONG retid);
	ULONG Save (STRPTR name);
	ULONG SetConfigItem (ULONG item, APTR data);
	ULONG ShowHelp (Object * window, char * name, char * node, LONG line);
#ifdef MUI_OBSOLETE
	struct NewMenu * Menu (void) const;
	ULONG GetMenuCheck (ULONG MenuID);
	ULONG GetMenuState (ULONG MenuID);
	ULONG Input (LONGBITS * signal);
	ULONG SetMenuCheck (ULONG MenuID, LONG stat);
	ULONG SetMenuState (ULONG MenuID, LONG stat);

#endif /* MUI_OBSOLETE */
};

/***************************************************************************
**                       CMUI_Window class definition                       
***************************************************************************/

class CMUI_Window : public CMUI_Notify
{
public:
	CMUI_Window (void)
	: CMUI_Notify ()
	{
	}

	CMUI_Window (struct TagItem *tags)
	: CMUI_Notify ()
	{
#ifdef MUIPP_DEBUG
		_CheckTagsSpecified ("CMUI_Window", tags, MUIA_Window_RootObject, "MUIA_Window_RootObject", TAG_DONE);
#endif
		object = MUI_NewObjectA (MUIC_Window, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Window object\n");
#endif
	}

	CMUI_Window (Tag tag1, ...)
	: CMUI_Notify ()
	{
#ifdef MUIPP_DEBUG
		_CheckTagsSpecified ("CMUI_Window", (struct TagItem *)&tag1, MUIA_Window_RootObject, "MUIA_Window_RootObject", TAG_DONE);
#endif
		object = MUI_NewObjectA (MUIC_Window, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Window object\n");
#endif
	}

	CMUI_Window (Object * obj)
	: CMUI_Notify ()
	{
		object = obj;
	}

	CMUI_Window & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	BOOL Activate (void) const;
	void SetActivate (BOOL value);
	Object * ActiveObject (void) const;
	void SetActiveObject (Object * value);
	LONG AltHeight (void) const;
	LONG AltLeftEdge (void) const;
	LONG AltTopEdge (void) const;
	LONG AltWidth (void) const;
	BOOL CloseRequest (void) const;
	Object * DefaultObject (void) const;
	void SetDefaultObject (Object * value);
	BOOL FancyDrawing (void) const;
	void SetFancyDrawing (BOOL value);
	LONG Height (void) const;
	ULONG ID (void) const;
	void SetID (ULONG value);
	struct InputEvent * InputEvent (void) const;
	BOOL IsSubWindow (void) const;
	void SetIsSubWindow (BOOL value);
	LONG LeftEdge (void) const;
	ULONG MenuAction (void) const;
	void SetMenuAction (ULONG value);
	Object * Menustrip (void) const;
	Object * MouseObject (void) const;
	void SetNoMenus (BOOL value);
	BOOL Open (void) const;
	void SetOpen (BOOL value);
	STRPTR PublicScreen (void) const;
	void SetPublicScreen (STRPTR value);
	void SetRefWindow (Object * value);
	Object * RootObject (void) const;
	void SetRootObject (Object * value);
	struct Screen * Screen (void) const;
	void SetScreen (struct Screen * value);
	STRPTR ScreenTitle (void) const;
	void SetScreenTitle (STRPTR value);
	BOOL Sleep (void) const;
	void SetSleep (BOOL value);
	STRPTR Title (void) const;
	void SetTitle (STRPTR value);
	LONG TopEdge (void) const;
	BOOL UseBottomBorderScroller (void) const;
	void SetUseBottomBorderScroller (BOOL value);
	BOOL UseLeftBorderScroller (void) const;
	void SetUseLeftBorderScroller (BOOL value);
	BOOL UseRightBorderScroller (void) const;
	void SetUseRightBorderScroller (BOOL value);
	LONG Width (void) const;
	struct Window * Window (void) const;
	ULONG AddEventHandler (struct MUI_EventHandlerNode * ehnode);
	ULONG RemEventHandler (struct MUI_EventHandlerNode * ehnode);
	ULONG ScreenToBack (void);
	ULONG ScreenToFront (void);
	ULONG Snapshot (LONG flags);
	ULONG ToBack (void);
	ULONG ToFront (void);
#ifdef MUI_OBSOLETE
	ULONG GetMenuCheck (ULONG MenuID);
	ULONG GetMenuState (ULONG MenuID);
	ULONG SetCycleChain (StartVarArgs sva, Object * obj, ...);
	ULONG SetMenuCheck (ULONG MenuID, LONG stat);
	ULONG SetMenuState (ULONG MenuID, LONG stat);

#endif /* MUI_OBSOLETE */
};

/***************************************************************************
**                      CMUI_Aboutmui class definition                      
***************************************************************************/

class CMUI_Aboutmui : public CMUI_Window
{
public:
	CMUI_Aboutmui (void)
	: CMUI_Window ()
	{
	}

	CMUI_Aboutmui (struct TagItem *tags)
	: CMUI_Window ()
	{
		object = MUI_NewObjectA (MUIC_Aboutmui, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Aboutmui object\n");
#endif
	}

	CMUI_Aboutmui (Tag tag1, ...)
	: CMUI_Window ()
	{
		object = MUI_NewObjectA (MUIC_Aboutmui, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Aboutmui object\n");
#endif
	}

	CMUI_Aboutmui (Object * obj)
	: CMUI_Window ()
	{
		object = obj;
	}

	CMUI_Aboutmui & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                        CMUI_Area class definition                        
***************************************************************************/

class CMUI_Area : public CMUI_Notify
{
public:
	void SetBackground (LONG value);
	LONG BottomEdge (void) const;
	Object * ContextMenu (void) const;
	void SetContextMenu (Object * value);
	Object * ContextMenuTrigger (void) const;
	char ControlChar (void) const;
	void SetControlChar (char value);
	LONG CycleChain (void) const;
	void SetCycleChain (LONG value);
	BOOL Disabled (void) const;
	void SetDisabled (BOOL value);
	BOOL Draggable (void) const;
	void SetDraggable (BOOL value);
	BOOL Dropable (void) const;
	void SetDropable (BOOL value);
	void SetFillArea (BOOL value);
	struct TextFont * Font (void) const;
	LONG Height (void) const;
	LONG HorizDisappear (void) const;
	void SetHorizDisappear (LONG value);
	WORD HorizWeight (void) const;
	void SetHorizWeight (WORD value);
	LONG InnerBottom (void) const;
	LONG InnerLeft (void) const;
	LONG InnerRight (void) const;
	LONG InnerTop (void) const;
	LONG LeftEdge (void) const;
	BOOL Pressed (void) const;
	LONG RightEdge (void) const;
	BOOL Selected (void) const;
	void SetSelected (BOOL value);
	STRPTR ShortHelp (void) const;
	void SetShortHelp (STRPTR value);
	BOOL ShowMe (void) const;
	void SetShowMe (BOOL value);
	LONG Timer (void) const;
	LONG TopEdge (void) const;
	LONG VertDisappear (void) const;
	void SetVertDisappear (LONG value);
	WORD VertWeight (void) const;
	void SetVertWeight (WORD value);
	LONG Width (void) const;
	struct Window * Window (void) const;
	Object * WindowObject (void) const;
	ULONG AskMinMax (struct MUI_MinMax * MinMaxInfo);
	ULONG Cleanup (void);
	ULONG ContextMenuBuild (LONG mx, LONG my);
	ULONG ContextMenuChoice (Object * item);
	ULONG CreateBubble (LONG x, LONG y, char * txt, ULONG flags);
	ULONG CreateShortHelp (LONG mx, LONG my);
	ULONG DeleteBubble (APTR bubble);
	ULONG DeleteShortHelp (STRPTR help);
	ULONG DragBegin (Object * obj);
	ULONG DragDrop (Object * obj, LONG x, LONG y);
	ULONG DragFinish (Object * obj);
	ULONG DragQuery (Object * obj);
	ULONG DragReport (Object * obj, LONG x, LONG y, LONG update);
	ULONG Draw (ULONG flags);
	ULONG DrawBackground (LONG left, LONG top, LONG width, LONG height, LONG xoffset, LONG yoffset, LONG flags);
	ULONG HandleEvent (struct IntuiMessage * imsg, LONG muikey);
	ULONG HandleInput (struct IntuiMessage * imsg, LONG muikey);
	ULONG Hide (void);
	ULONG Setup (struct MUI_RenderInfo * RenderInfo);
	ULONG Show (void);
#ifdef MUI_OBSOLETE
	ULONG ExportID (void) const;
	void SetExportID (ULONG value);

#endif /* MUI_OBSOLETE */
protected:
	CMUI_Area (void)
	: CMUI_Notify ()
	{
	}

};

/***************************************************************************
**                     CMUI_Rectangle class definition                      
***************************************************************************/

class CMUI_Rectangle : public CMUI_Area
{
public:
	CMUI_Rectangle (void)
	: CMUI_Area ()
	{
	}

	CMUI_Rectangle (struct TagItem *tags)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Rectangle, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Rectangle object\n");
#endif
	}

	CMUI_Rectangle (Tag tag1, ...)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Rectangle, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Rectangle object\n");
#endif
	}

	CMUI_Rectangle (Object * obj)
	: CMUI_Area ()
	{
		object = obj;
	}

	CMUI_Rectangle & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	STRPTR BarTitle (void) const;
	BOOL HBar (void) const;
	BOOL VBar (void) const;
};

/***************************************************************************
**                      CMUI_Balance class definition                       
***************************************************************************/

class CMUI_Balance : public CMUI_Area
{
public:
	CMUI_Balance (void)
	: CMUI_Area ()
	{
	}

	CMUI_Balance (struct TagItem *tags)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Balance, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Balance object\n");
#endif
	}

	CMUI_Balance (Tag tag1, ...)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Balance, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Balance object\n");
#endif
	}

	CMUI_Balance (Object * obj)
	: CMUI_Area ()
	{
		object = obj;
	}

	CMUI_Balance & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                       CMUI_Image class definition                        
***************************************************************************/

class CMUI_Image : public CMUI_Area
{
public:
	CMUI_Image (void)
	: CMUI_Area ()
	{
	}

	CMUI_Image (struct TagItem *tags)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Image, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Image object\n");
#endif
	}

	CMUI_Image (Tag tag1, ...)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Image, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Image object\n");
#endif
	}

	CMUI_Image (Object * obj)
	: CMUI_Area ()
	{
		object = obj;
	}

	CMUI_Image & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	void SetState (LONG value);
};

/***************************************************************************
**                       CMUI_Bitmap class definition                       
***************************************************************************/

class CMUI_Bitmap : public CMUI_Area
{
public:
	CMUI_Bitmap (void)
	: CMUI_Area ()
	{
	}

	CMUI_Bitmap (struct TagItem *tags)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Bitmap, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Bitmap object\n");
#endif
	}

	CMUI_Bitmap (Tag tag1, ...)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Bitmap, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Bitmap object\n");
#endif
	}

	CMUI_Bitmap (Object * obj)
	: CMUI_Area ()
	{
		object = obj;
	}

	CMUI_Bitmap & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	struct BitMap * Bitmap (void) const;
	void SetBitmap (struct BitMap * value);
	LONG Height (void) const;
	void SetHeight (LONG value);
	UBYTE * MappingTable (void) const;
	void SetMappingTable (UBYTE * value);
	LONG Precision (void) const;
	void SetPrecision (LONG value);
	struct BitMap * RemappedBitmap (void) const;
	ULONG * SourceColors (void) const;
	void SetSourceColors (ULONG * value);
	LONG Transparent (void) const;
	void SetTransparent (LONG value);
	LONG Width (void) const;
	void SetWidth (LONG value);
};

/***************************************************************************
**                     CMUI_Bodychunk class definition                      
***************************************************************************/

class CMUI_Bodychunk : public CMUI_Bitmap
{
public:
	CMUI_Bodychunk (void)
	: CMUI_Bitmap ()
	{
	}

	CMUI_Bodychunk (struct TagItem *tags)
	: CMUI_Bitmap ()
	{
		object = MUI_NewObjectA (MUIC_Bodychunk, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Bodychunk object\n");
#endif
	}

	CMUI_Bodychunk (Tag tag1, ...)
	: CMUI_Bitmap ()
	{
		object = MUI_NewObjectA (MUIC_Bodychunk, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Bodychunk object\n");
#endif
	}

	CMUI_Bodychunk (Object * obj)
	: CMUI_Bitmap ()
	{
		object = obj;
	}

	CMUI_Bodychunk & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	UBYTE * Body (void) const;
	void SetBody (UBYTE * value);
	UBYTE Compression (void) const;
	void SetCompression (UBYTE value);
	LONG Depth (void) const;
	void SetDepth (LONG value);
	UBYTE Masking (void) const;
	void SetMasking (UBYTE value);
};

/***************************************************************************
**                        CMUI_Text class definition                        
***************************************************************************/

class CMUI_Text : public CMUI_Area
{
public:
	CMUI_Text (void)
	: CMUI_Area ()
	{
	}

	CMUI_Text (struct TagItem *tags)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Text, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Text object\n");
#endif
	}

	CMUI_Text (Tag tag1, ...)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Text, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Text object\n");
#endif
	}

	CMUI_Text (Object * obj)
	: CMUI_Area ()
	{
		object = obj;
	}

	CMUI_Text & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	operator const char * ();
	CMUI_Text & operator = (const char *contents);
	STRPTR Contents (void) const;
	void SetContents (STRPTR value);
	STRPTR PreParse (void) const;
	void SetPreParse (STRPTR value);
};

/***************************************************************************
**                       CMUI_Gadget class definition                       
***************************************************************************/

class CMUI_Gadget : public CMUI_Area
{
public:
	struct Gadget * Gadget (void) const;
protected:
	CMUI_Gadget (void)
	: CMUI_Area ()
	{
	}

};

/***************************************************************************
**                       CMUI_String class definition                       
***************************************************************************/

class CMUI_String : public CMUI_Gadget
{
public:
	CMUI_String (void)
	: CMUI_Gadget ()
	{
	}

	CMUI_String (struct TagItem *tags)
	: CMUI_Gadget ()
	{
		object = MUI_NewObjectA (MUIC_String, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_String object\n");
#endif
	}

	CMUI_String (Tag tag1, ...)
	: CMUI_Gadget ()
	{
		object = MUI_NewObjectA (MUIC_String, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_String object\n");
#endif
	}

	CMUI_String (Object * obj)
	: CMUI_Gadget ()
	{
		object = obj;
	}

	CMUI_String (STRPTR label, LONG maxlen)
	: CMUI_Gadget ()
	{
		object = MUI_MakeObject (MUIO_String, label, maxlen);
	}

	CMUI_String & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	// These operators allow CMUI_String object to be treated like const char *
	
	operator const char * ();
	operator ULONG ();
	CMUI_String & operator = (const char *contents);
	CMUI_String & operator = (ULONG contents);
	STRPTR Accept (void) const;
	void SetAccept (STRPTR value);
	STRPTR Acknowledge (void) const;
	BOOL AdvanceOnCR (void) const;
	void SetAdvanceOnCR (BOOL value);
	Object * AttachedList (void) const;
	void SetAttachedList (Object * value);
	LONG BufferPos (void) const;
	void SetBufferPos (LONG value);
	STRPTR Contents (void) const;
	void SetContents (STRPTR value);
	LONG DisplayPos (void) const;
	void SetDisplayPos (LONG value);
	struct Hook * EditHook (void) const;
	void SetEditHook (struct Hook * value);
	LONG Format (void) const;
	ULONG Integer (void) const;
	void SetInteger (ULONG value);
	BOOL LonelyEditHook (void) const;
	void SetLonelyEditHook (BOOL value);
	LONG MaxLen (void) const;
	STRPTR Reject (void) const;
	void SetReject (STRPTR value);
	BOOL Secret (void) const;
};

/***************************************************************************
**                       CMUI_Boopsi class definition                       
***************************************************************************/

class CMUI_Boopsi : public CMUI_Gadget
{
public:
	CMUI_Boopsi (void)
	: CMUI_Gadget ()
	{
	}

	CMUI_Boopsi (struct TagItem *tags)
	: CMUI_Gadget ()
	{
		object = MUI_NewObjectA (MUIC_Boopsi, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Boopsi object\n");
#endif
	}

	CMUI_Boopsi (Tag tag1, ...)
	: CMUI_Gadget ()
	{
		object = MUI_NewObjectA (MUIC_Boopsi, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Boopsi object\n");
#endif
	}

	CMUI_Boopsi (Object * obj)
	: CMUI_Gadget ()
	{
		object = obj;
	}

	CMUI_Boopsi & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	struct IClass * Class (void) const;
	void SetClass (struct IClass * value);
	char * ClassID (void) const;
	void SetClassID (char * value);
	ULONG MaxHeight (void) const;
	void SetMaxHeight (ULONG value);
	ULONG MaxWidth (void) const;
	void SetMaxWidth (ULONG value);
	ULONG MinHeight (void) const;
	void SetMinHeight (ULONG value);
	ULONG MinWidth (void) const;
	void SetMinWidth (ULONG value);
	Object * BoopsiObject (void) const;
	ULONG TagDrawInfo (void) const;
	void SetTagDrawInfo (ULONG value);
	ULONG TagScreen (void) const;
	void SetTagScreen (ULONG value);
	ULONG TagWindow (void) const;
	void SetTagWindow (ULONG value);
};

/***************************************************************************
**                        CMUI_Prop class definition                        
***************************************************************************/

class CMUI_Prop : public CMUI_Gadget
{
public:
	CMUI_Prop (void)
	: CMUI_Gadget ()
	{
	}

	CMUI_Prop (struct TagItem *tags)
	: CMUI_Gadget ()
	{
		object = MUI_NewObjectA (MUIC_Prop, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Prop object\n");
#endif
	}

	CMUI_Prop (Tag tag1, ...)
	: CMUI_Gadget ()
	{
		object = MUI_NewObjectA (MUIC_Prop, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Prop object\n");
#endif
	}

	CMUI_Prop (Object * obj)
	: CMUI_Gadget ()
	{
		object = obj;
	}

	CMUI_Prop & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	LONG Entries (void) const;
	void SetEntries (LONG value);
	LONG First (void) const;
	void SetFirst (LONG value);
	BOOL Horiz (void) const;
	BOOL Slider (void) const;
	void SetSlider (BOOL value);
	LONG Visible (void) const;
	void SetVisible (LONG value);
	ULONG Decrease (LONG amount);
	ULONG Increase (LONG amount);
};

/***************************************************************************
**                       CMUI_Gauge class definition                        
***************************************************************************/

class CMUI_Gauge : public CMUI_Area
{
public:
	CMUI_Gauge (void)
	: CMUI_Area ()
	{
	}

	CMUI_Gauge (struct TagItem *tags)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Gauge, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Gauge object\n");
#endif
	}

	CMUI_Gauge (Tag tag1, ...)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Gauge, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Gauge object\n");
#endif
	}

	CMUI_Gauge (Object * obj)
	: CMUI_Area ()
	{
		object = obj;
	}

	CMUI_Gauge & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	LONG Current (void) const;
	void SetCurrent (LONG value);
	BOOL Divide (void) const;
	void SetDivide (BOOL value);
	STRPTR InfoText (void) const;
	void SetInfoText (STRPTR value);
	LONG Max (void) const;
	void SetMax (LONG value);
};

/***************************************************************************
**                       CMUI_Scale class definition                        
***************************************************************************/

class CMUI_Scale : public CMUI_Area
{
public:
	CMUI_Scale (void)
	: CMUI_Area ()
	{
	}

	CMUI_Scale (struct TagItem *tags)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Scale, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Scale object\n");
#endif
	}

	CMUI_Scale (Tag tag1, ...)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Scale, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Scale object\n");
#endif
	}

	CMUI_Scale (Object * obj)
	: CMUI_Area ()
	{
		object = obj;
	}

	CMUI_Scale & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	BOOL Horiz (void) const;
	void SetHoriz (BOOL value);
};

/***************************************************************************
**                     CMUI_Colorfield class definition                     
***************************************************************************/

class CMUI_Colorfield : public CMUI_Area
{
public:
	CMUI_Colorfield (void)
	: CMUI_Area ()
	{
	}

	CMUI_Colorfield (struct TagItem *tags)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Colorfield, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Colorfield object\n");
#endif
	}

	CMUI_Colorfield (Tag tag1, ...)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Colorfield, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Colorfield object\n");
#endif
	}

	CMUI_Colorfield (Object * obj)
	: CMUI_Area ()
	{
		object = obj;
	}

	CMUI_Colorfield & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	ULONG Blue (void) const;
	void SetBlue (ULONG value);
	ULONG Green (void) const;
	void SetGreen (ULONG value);
	ULONG Pen (void) const;
	ULONG Red (void) const;
	void SetRed (ULONG value);
	ULONG * RGB (void) const;
	void SetRGB (ULONG * value);
};

/***************************************************************************
**                        CMUI_List class definition                        
***************************************************************************/

class CMUI_List : public CMUI_Area
{
public:
	CMUI_List (void)
	: CMUI_Area ()
	{
	}

	CMUI_List (struct TagItem *tags)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_List, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_List object\n");
#endif
	}

	CMUI_List (Tag tag1, ...)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_List, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_List object\n");
#endif
	}

	CMUI_List (Object * obj)
	: CMUI_Area ()
	{
		object = obj;
	}

	CMUI_List & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	// By overloading the [] operator you can treat lists like arrays
	
	APTR operator [] (LONG pos)
	{
	    APTR entry;
	    DoMethod (MUIM_List_GetEntry, pos, &entry);
	    return entry;
	}
	
	// This method is a convienient alternative to the Entries attribute
	
	LONG Length (void) const
	{
		return (LONG)GetAttr (MUIA_List_Entries);
	}
	
	// This method can be used to retrieve the number of selected entries
	// in a list
	
	ULONG NumSelected (void)
	{
		ULONG numSelected;
		DoMethod (MUIM_List_Select, MUIV_List_Select_All, MUIV_List_Select_Ask, &numSelected);
		return numSelected;
	}
	
	// These methods can be used as shortcuts for inserting objects into lists
	
	void AddHead (APTR entry)
	{
		DoMethod (MUIM_List_InsertSingle, entry, MUIV_List_Insert_Top);
	}
	
	void AddTail (APTR entry)
	{
		DoMethod (MUIM_List_InsertSingle, entry, MUIV_List_Insert_Bottom);
	}
	
	void InsertTop (APTR entry)
	{
	    DoMethod (MUIM_List_InsertSingle, entry, MUIV_List_Insert_Top);
	}
	
	void InsertBottom (APTR entry)
	{
	    DoMethod (MUIM_List_InsertSingle, entry, MUIV_List_Insert_Bottom);
	}
	
	void InsertSorted (APTR entry)
	{
	    DoMethod (MUIM_List_InsertSingle, entry, MUIV_List_Insert_Sorted);
	}
	
	void InsertActive (APTR entry)
	{
	    DoMethod (MUIM_List_InsertSingle, entry, MUIV_List_Insert_Active);
	}
	
	
	LONG Active (void) const;
	void SetActive (LONG value);
	BOOL AutoVisible (void) const;
	void SetAutoVisible (BOOL value);
	void SetCompareHook (struct Hook * value);
	void SetConstructHook (struct Hook * value);
	void SetDestructHook (struct Hook * value);
	void SetDisplayHook (struct Hook * value);
	BOOL DragSortable (void) const;
	void SetDragSortable (BOOL value);
	LONG DropMark (void) const;
	LONG Entries (void) const;
	LONG First (void) const;
	STRPTR Format (void) const;
	void SetFormat (STRPTR value);
	LONG InsertPosition (void) const;
	void SetMultiTestHook (struct Hook * value);
	void SetQuiet (BOOL value);
	BOOL ShowDropMarks (void) const;
	void SetShowDropMarks (BOOL value);
	char * Title (void) const;
	void SetTitle (char * value);
	LONG Visible (void) const;
	ULONG Clear (void);
	ULONG CreateImage (Object * obj, ULONG flags);
	ULONG DeleteImage (APTR listimg);
	ULONG Exchange (LONG pos1, LONG pos2);
	ULONG GetEntry (LONG pos, APTR * entry);
	ULONG Insert (APTR * entries, LONG count, LONG pos);
	ULONG InsertSingle (APTR entry, LONG pos);
	ULONG Jump (LONG pos);
	ULONG Move (LONG from, LONG to);
	ULONG NextSelected (LONG * pos);
	ULONG Redraw (LONG pos);
	ULONG Remove (LONG pos);
	ULONG Select (LONG pos, LONG seltype, LONG * state);
	ULONG Sort (void);
	ULONG TestPos (LONG x, LONG y, struct MUI_List_TestPos_Result * res);
};

/***************************************************************************
**                     CMUI_Floattext class definition                      
***************************************************************************/

class CMUI_Floattext : public CMUI_List
{
public:
	CMUI_Floattext (void)
	: CMUI_List ()
	{
	}

	CMUI_Floattext (struct TagItem *tags)
	: CMUI_List ()
	{
		object = MUI_NewObjectA (MUIC_Floattext, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Floattext object\n");
#endif
	}

	CMUI_Floattext (Tag tag1, ...)
	: CMUI_List ()
	{
		object = MUI_NewObjectA (MUIC_Floattext, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Floattext object\n");
#endif
	}

	CMUI_Floattext (Object * obj)
	: CMUI_List ()
	{
		object = obj;
	}

	CMUI_Floattext & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	BOOL Justify (void) const;
	void SetJustify (BOOL value);
	void SetSkipChars (STRPTR value);
	void SetTabSize (LONG value);
	STRPTR Text (void) const;
	void SetText (STRPTR value);
};

/***************************************************************************
**                     CMUI_Volumelist class definition                     
***************************************************************************/

class CMUI_Volumelist : public CMUI_List
{
public:
	CMUI_Volumelist (void)
	: CMUI_List ()
	{
	}

	CMUI_Volumelist (struct TagItem *tags)
	: CMUI_List ()
	{
		object = MUI_NewObjectA (MUIC_Volumelist, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Volumelist object\n");
#endif
	}

	CMUI_Volumelist (Tag tag1, ...)
	: CMUI_List ()
	{
		object = MUI_NewObjectA (MUIC_Volumelist, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Volumelist object\n");
#endif
	}

	CMUI_Volumelist (Object * obj)
	: CMUI_List ()
	{
		object = obj;
	}

	CMUI_Volumelist & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                    CMUI_Scrmodelist class definition                     
***************************************************************************/

class CMUI_Scrmodelist : public CMUI_List
{
public:
	CMUI_Scrmodelist (void)
	: CMUI_List ()
	{
	}

	CMUI_Scrmodelist (struct TagItem *tags)
	: CMUI_List ()
	{
		object = MUI_NewObjectA (MUIC_Scrmodelist, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Scrmodelist object\n");
#endif
	}

	CMUI_Scrmodelist (Tag tag1, ...)
	: CMUI_List ()
	{
		object = MUI_NewObjectA (MUIC_Scrmodelist, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Scrmodelist object\n");
#endif
	}

	CMUI_Scrmodelist (Object * obj)
	: CMUI_List ()
	{
		object = obj;
	}

	CMUI_Scrmodelist & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                      CMUI_Dirlist class definition                       
***************************************************************************/

class CMUI_Dirlist : public CMUI_List
{
public:
	CMUI_Dirlist (void)
	: CMUI_List ()
	{
	}

	CMUI_Dirlist (struct TagItem *tags)
	: CMUI_List ()
	{
		object = MUI_NewObjectA (MUIC_Dirlist, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Dirlist object\n");
#endif
	}

	CMUI_Dirlist (Tag tag1, ...)
	: CMUI_List ()
	{
		object = MUI_NewObjectA (MUIC_Dirlist, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Dirlist object\n");
#endif
	}

	CMUI_Dirlist (Object * obj)
	: CMUI_List ()
	{
		object = obj;
	}

	CMUI_Dirlist & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	void SetAcceptPattern (STRPTR value);
	STRPTR Directory (void) const;
	void SetDirectory (STRPTR value);
	void SetDrawersOnly (BOOL value);
	void SetFilesOnly (BOOL value);
	void SetFilterDrawers (BOOL value);
	void SetFilterHook (struct Hook * value);
	void SetMultiSelDirs (BOOL value);
	LONG NumBytes (void) const;
	LONG NumDrawers (void) const;
	LONG NumFiles (void) const;
	STRPTR Path (void) const;
	void SetRejectIcons (BOOL value);
	void SetRejectPattern (STRPTR value);
	void SetSortDirs (LONG value);
	void SetSortHighLow (BOOL value);
	void SetSortType (LONG value);
	LONG Status (void) const;
	ULONG ReRead (void);
};

/***************************************************************************
**                      CMUI_Numeric class definition                       
***************************************************************************/

class CMUI_Numeric : public CMUI_Area
{
public:
	operator LONG ();
	operator int ();
	CMUI_Numeric & operator = (LONG value);
	CMUI_Numeric & operator = (int value);
	CMUI_Numeric operator ++ ();
	CMUI_Numeric operator ++ (int dummy);
	CMUI_Numeric & operator += (LONG value);
	CMUI_Numeric operator -- ();
	CMUI_Numeric operator -- (int dummy);
	CMUI_Numeric & operator -= (LONG value);
	
	
	BOOL CheckAllSizes (void) const;
	void SetCheckAllSizes (BOOL value);
	LONG Default (void) const;
	void SetDefault (LONG value);
	STRPTR Format (void) const;
	void SetFormat (STRPTR value);
	LONG Max (void) const;
	void SetMax (LONG value);
	LONG Min (void) const;
	void SetMin (LONG value);
	BOOL Reverse (void) const;
	void SetReverse (BOOL value);
	BOOL RevLeftRight (void) const;
	void SetRevLeftRight (BOOL value);
	BOOL RevUpDown (void) const;
	void SetRevUpDown (BOOL value);
	LONG Value (void) const;
	void SetValue (LONG value);
	ULONG Decrease (LONG amount);
	ULONG Increase (LONG amount);
	ULONG ScaleToValue (LONG scalemin, LONG scalemax, LONG scale);
	ULONG SetDefault (void);
	ULONG Stringify (LONG value);
	ULONG ValueToScale (LONG scalemin, LONG scalemax);
protected:
	CMUI_Numeric (void)
	: CMUI_Area ()
	{
	}

};

/***************************************************************************
**                        CMUI_Knob class definition                        
***************************************************************************/

class CMUI_Knob : public CMUI_Numeric
{
public:
	CMUI_Knob (void)
	: CMUI_Numeric ()
	{
	}

	CMUI_Knob (struct TagItem *tags)
	: CMUI_Numeric ()
	{
		object = MUI_NewObjectA (MUIC_Knob, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Knob object\n");
#endif
	}

	CMUI_Knob (Tag tag1, ...)
	: CMUI_Numeric ()
	{
		object = MUI_NewObjectA (MUIC_Knob, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Knob object\n");
#endif
	}

	CMUI_Knob (Object * obj)
	: CMUI_Numeric ()
	{
		object = obj;
	}

	CMUI_Knob & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                     CMUI_Levelmeter class definition                     
***************************************************************************/

class CMUI_Levelmeter : public CMUI_Numeric
{
public:
	CMUI_Levelmeter (void)
	: CMUI_Numeric ()
	{
	}

	CMUI_Levelmeter (struct TagItem *tags)
	: CMUI_Numeric ()
	{
		object = MUI_NewObjectA (MUIC_Levelmeter, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Levelmeter object\n");
#endif
	}

	CMUI_Levelmeter (Tag tag1, ...)
	: CMUI_Numeric ()
	{
		object = MUI_NewObjectA (MUIC_Levelmeter, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Levelmeter object\n");
#endif
	}

	CMUI_Levelmeter (Object * obj)
	: CMUI_Numeric ()
	{
		object = obj;
	}

	CMUI_Levelmeter & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	STRPTR Label (void) const;
	void SetLabel (STRPTR value);
};

/***************************************************************************
**                   CMUI_Numericbutton class definition                    
***************************************************************************/

class CMUI_Numericbutton : public CMUI_Numeric
{
public:
	CMUI_Numericbutton (void)
	: CMUI_Numeric ()
	{
	}

	CMUI_Numericbutton (struct TagItem *tags)
	: CMUI_Numeric ()
	{
		object = MUI_NewObjectA (MUIC_Numericbutton, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Numericbutton object\n");
#endif
	}

	CMUI_Numericbutton (Tag tag1, ...)
	: CMUI_Numeric ()
	{
		object = MUI_NewObjectA (MUIC_Numericbutton, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Numericbutton object\n");
#endif
	}

	CMUI_Numericbutton (Object * obj)
	: CMUI_Numeric ()
	{
		object = obj;
	}

	CMUI_Numericbutton (STRPTR label, LONG min, LONG max, STRPTR format)
	: CMUI_Numeric ()
	{
		object = MUI_MakeObject (MUIO_NumericButton, label, min, max, format);
	}

	CMUI_Numericbutton & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                       CMUI_Slider class definition                       
***************************************************************************/

class CMUI_Slider : public CMUI_Numeric
{
public:
	CMUI_Slider (void)
	: CMUI_Numeric ()
	{
	}

	CMUI_Slider (struct TagItem *tags)
	: CMUI_Numeric ()
	{
		object = MUI_NewObjectA (MUIC_Slider, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Slider object\n");
#endif
	}

	CMUI_Slider (Tag tag1, ...)
	: CMUI_Numeric ()
	{
		object = MUI_NewObjectA (MUIC_Slider, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Slider object\n");
#endif
	}

	CMUI_Slider (Object * obj)
	: CMUI_Numeric ()
	{
		object = obj;
	}

	CMUI_Slider (STRPTR label, LONG min, LONG max)
	: CMUI_Numeric ()
	{
		object = MUI_MakeObject (MUIO_Slider, label, min, max);
	}

	CMUI_Slider & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	BOOL Horiz (void) const;
	void SetHoriz (BOOL value);
#ifdef MUI_OBSOLETE
	LONG Level (void) const;
	void SetLevel (LONG value);
	LONG Max (void) const;
	void SetMax (LONG value);
	LONG Min (void) const;
	void SetMin (LONG value);
	BOOL Reverse (void) const;
	void SetReverse (BOOL value);

#endif /* MUI_OBSOLETE */
};

/***************************************************************************
**                    CMUI_Framedisplay class definition                    
***************************************************************************/

class CMUI_Framedisplay : public CMUI_Area
{
public:
protected:
	CMUI_Framedisplay (void)
	: CMUI_Area ()
	{
	}

};

/***************************************************************************
**                      CMUI_Popframe class definition                      
***************************************************************************/

class CMUI_Popframe : public CMUI_Framedisplay
{
public:
protected:
	CMUI_Popframe (void)
	: CMUI_Framedisplay ()
	{
	}

};

/***************************************************************************
**                    CMUI_Imagedisplay class definition                    
***************************************************************************/

class CMUI_Imagedisplay : public CMUI_Area
{
public:
protected:
	CMUI_Imagedisplay (void)
	: CMUI_Area ()
	{
	}

};

/***************************************************************************
**                      CMUI_Popimage class definition                      
***************************************************************************/

class CMUI_Popimage : public CMUI_Imagedisplay
{
public:
protected:
	CMUI_Popimage (void)
	: CMUI_Imagedisplay ()
	{
	}

};

/***************************************************************************
**                     CMUI_Pendisplay class definition                     
***************************************************************************/

class CMUI_Pendisplay : public CMUI_Area
{
public:
	CMUI_Pendisplay (void)
	: CMUI_Area ()
	{
	}

	CMUI_Pendisplay (struct TagItem *tags)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Pendisplay, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Pendisplay object\n");
#endif
	}

	CMUI_Pendisplay (Tag tag1, ...)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Pendisplay, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Pendisplay object\n");
#endif
	}

	CMUI_Pendisplay (Object * obj)
	: CMUI_Area ()
	{
		object = obj;
	}

	CMUI_Pendisplay & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	Object * Pen (void) const;
	Object * Reference (void) const;
	void SetReference (Object * value);
	struct MUI_RGBcolor * RGBcolor (void) const;
	void SetRGBcolor (struct MUI_RGBcolor * value);
	struct MUI_PenSpec  * Spec (void) const;
	void SetSpec (struct MUI_PenSpec  * value);
	ULONG SetColormap (LONG colormap);
	ULONG SetMUIPen (LONG muipen);
	ULONG SetRGB (ULONG red, ULONG green, ULONG blue);
};

/***************************************************************************
**                       CMUI_Poppen class definition                       
***************************************************************************/

class CMUI_Poppen : public CMUI_Pendisplay
{
public:
	CMUI_Poppen (void)
	: CMUI_Pendisplay ()
	{
	}

	CMUI_Poppen (struct TagItem *tags)
	: CMUI_Pendisplay ()
	{
		object = MUI_NewObjectA (MUIC_Poppen, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Poppen object\n");
#endif
	}

	CMUI_Poppen (Tag tag1, ...)
	: CMUI_Pendisplay ()
	{
		object = MUI_NewObjectA (MUIC_Poppen, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Poppen object\n");
#endif
	}

	CMUI_Poppen (Object * obj)
	: CMUI_Pendisplay ()
	{
		object = obj;
	}

	CMUI_Poppen & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                       CMUI_Group class definition                        
***************************************************************************/

class CMUI_Group : public CMUI_Area
{
public:
	CMUI_Group (void)
	: CMUI_Area ()
	{
	}

	CMUI_Group (struct TagItem *tags)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Group, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Group object\n");
#endif
	}

	CMUI_Group (Tag tag1, ...)
	: CMUI_Area ()
	{
		object = MUI_NewObjectA (MUIC_Group, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Group object\n");
#endif
	}

	CMUI_Group (Object * obj)
	: CMUI_Area ()
	{
		object = obj;
	}

	CMUI_Group & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	/* Adds a new object object to the group */
	
	void AddObject (Object *obj)
	{
	    DoMethod (OM_ADDMEMBER, obj);
	}
	
	/* Removes an object from the group */
	
	void RemObject (Object *obj)
	{
	    DoMethod (OM_REMMEMBER, obj);
	}
	
	
	LONG ActivePage (void) const;
	void SetActivePage (LONG value);
	struct List * ChildList (void) const;
	void SetColumns (LONG value);
	LONG HorizSpacing (void) const;
	void SetHorizSpacing (LONG value);
	void SetRows (LONG value);
	void SetSpacing (LONG value);
	LONG VertSpacing (void) const;
	void SetVertSpacing (LONG value);
	ULONG ExitChange (void);
	ULONG InitChange (void);
	ULONG Sort (StartVarArgs sva, Object * obj, ...);
};

/***************************************************************************
**                      CMUI_Mccprefs class definition                      
***************************************************************************/

class CMUI_Mccprefs : public CMUI_Group
{
public:
protected:
	CMUI_Mccprefs (void)
	: CMUI_Group ()
	{
	}

};

/***************************************************************************
**                      CMUI_Register class definition                      
***************************************************************************/

class CMUI_Register : public CMUI_Group
{
public:
	CMUI_Register (void)
	: CMUI_Group ()
	{
	}

	CMUI_Register (struct TagItem *tags)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Register, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Register object\n");
#endif
	}

	CMUI_Register (Tag tag1, ...)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Register, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Register object\n");
#endif
	}

	CMUI_Register (Object * obj)
	: CMUI_Group ()
	{
		object = obj;
	}

	CMUI_Register & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	BOOL Frame (void) const;
	STRPTR * Titles (void) const;
};

/***************************************************************************
**                     CMUI_Penadjust class definition                      
***************************************************************************/

class CMUI_Penadjust : public CMUI_Register
{
public:
protected:
	CMUI_Penadjust (void)
	: CMUI_Register ()
	{
	}

};

/***************************************************************************
**                   CMUI_Settingsgroup class definition                    
***************************************************************************/

class CMUI_Settingsgroup : public CMUI_Group
{
public:
	ULONG ConfigToGadgets (Object * configdata);
	ULONG GadgetsToConfig (Object * configdata);
protected:
	CMUI_Settingsgroup (void)
	: CMUI_Group ()
	{
	}

};

/***************************************************************************
**                      CMUI_Settings class definition                      
***************************************************************************/

class CMUI_Settings : public CMUI_Group
{
public:
protected:
	CMUI_Settings (void)
	: CMUI_Group ()
	{
	}

};

/***************************************************************************
**                    CMUI_Frameadjust class definition                     
***************************************************************************/

class CMUI_Frameadjust : public CMUI_Group
{
public:
protected:
	CMUI_Frameadjust (void)
	: CMUI_Group ()
	{
	}

};

/***************************************************************************
**                    CMUI_Imageadjust class definition                     
***************************************************************************/

class CMUI_Imageadjust : public CMUI_Group
{
public:
protected:
	CMUI_Imageadjust (void)
	: CMUI_Group ()
	{
	}

};

/***************************************************************************
**                     CMUI_Virtgroup class definition                      
***************************************************************************/

class CMUI_Virtgroup : public CMUI_Group
{
public:
	CMUI_Virtgroup (void)
	: CMUI_Group ()
	{
	}

	CMUI_Virtgroup (struct TagItem *tags)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Virtgroup, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Virtgroup object\n");
#endif
	}

	CMUI_Virtgroup (Tag tag1, ...)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Virtgroup, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Virtgroup object\n");
#endif
	}

	CMUI_Virtgroup (Object * obj)
	: CMUI_Group ()
	{
		object = obj;
	}

	CMUI_Virtgroup & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	LONG Height (void) const;
	LONG Left (void) const;
	void SetLeft (LONG value);
	LONG Top (void) const;
	void SetTop (LONG value);
	LONG Width (void) const;
};

/***************************************************************************
**                    CMUI_Scrollgroup class definition                     
***************************************************************************/

class CMUI_Scrollgroup : public CMUI_Group
{
public:
	CMUI_Scrollgroup (void)
	: CMUI_Group ()
	{
	}

	CMUI_Scrollgroup (struct TagItem *tags)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Scrollgroup, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Scrollgroup object\n");
#endif
	}

	CMUI_Scrollgroup (Tag tag1, ...)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Scrollgroup, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Scrollgroup object\n");
#endif
	}

	CMUI_Scrollgroup (Object * obj)
	: CMUI_Group ()
	{
		object = obj;
	}

	CMUI_Scrollgroup & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	Object * Contents (void) const;
	Object * HorizBar (void) const;
	Object * VertBar (void) const;
};

/***************************************************************************
**                     CMUI_Scrollbar class definition                      
***************************************************************************/

class CMUI_Scrollbar : public CMUI_Group
{
public:
	CMUI_Scrollbar (void)
	: CMUI_Group ()
	{
	}

	CMUI_Scrollbar (struct TagItem *tags)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Scrollbar, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Scrollbar object\n");
#endif
	}

	CMUI_Scrollbar (Tag tag1, ...)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Scrollbar, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Scrollbar object\n");
#endif
	}

	CMUI_Scrollbar (Object * obj)
	: CMUI_Group ()
	{
		object = obj;
	}

	CMUI_Scrollbar & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                      CMUI_Listview class definition                      
***************************************************************************/

class CMUI_Listview : public CMUI_List
{
public:
	CMUI_Listview (void)
	: CMUI_List ()
	{
	}

	CMUI_Listview (struct TagItem *tags)
	: CMUI_List ()
	{
#ifdef MUIPP_DEBUG
		_CheckTagsSpecified ("CMUI_Listview", tags, MUIA_Listview_List, "MUIA_Listview_List", TAG_DONE);
#endif
		object = MUI_NewObjectA (MUIC_Listview, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Listview object\n");
#endif
	}

	CMUI_Listview (Tag tag1, ...)
	: CMUI_List ()
	{
#ifdef MUIPP_DEBUG
		_CheckTagsSpecified ("CMUI_Listview", (struct TagItem *)&tag1, MUIA_Listview_List, "MUIA_Listview_List", TAG_DONE);
#endif
		object = MUI_NewObjectA (MUIC_Listview, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Listview object\n");
#endif
	}

	CMUI_Listview (Object * obj)
	: CMUI_List ()
	{
		object = obj;
	}

	CMUI_Listview & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	LONG ActivePage (void) const;
	void SetActivePage (LONG value);
	struct List * ChildList (void) const;
	void SetColumns (LONG value);
	LONG HorizSpacing (void) const;
	void SetHorizSpacing (LONG value);
	void SetRows (LONG value);
	void SetSpacing (LONG value);
	LONG VertSpacing (void) const;
	void SetVertSpacing (LONG value);
	ULONG ExitChange (void);
	ULONG InitChange (void);
	ULONG Sort (StartVarArgs sva, Object * obj, ...);
	LONG ClickColumn (void) const;
	LONG DefClickColumn (void) const;
	void SetDefClickColumn (LONG value);
	BOOL DoubleClick (void) const;
	LONG DragType (void) const;
	void SetDragType (LONG value);
	Object * List (void) const;
	BOOL SelectChange (void) const;
};

/***************************************************************************
**                       CMUI_Radio class definition                        
***************************************************************************/

class CMUI_Radio : public CMUI_Group
{
public:
	CMUI_Radio (void)
	: CMUI_Group ()
	{
	}

	CMUI_Radio (struct TagItem *tags)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Radio, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Radio object\n");
#endif
	}

	CMUI_Radio (Tag tag1, ...)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Radio, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Radio object\n");
#endif
	}

	CMUI_Radio (Object * obj)
	: CMUI_Group ()
	{
		object = obj;
	}

	CMUI_Radio (STRPTR label, STRPTR * entries)
	: CMUI_Group ()
	{
		object = MUI_MakeObject (MUIO_Radio, label, entries);
	}

	CMUI_Radio & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	LONG Active (void) const;
	void SetActive (LONG value);
};

/***************************************************************************
**                       CMUI_Cycle class definition                        
***************************************************************************/

class CMUI_Cycle : public CMUI_Group
{
public:
	CMUI_Cycle (void)
	: CMUI_Group ()
	{
	}

	CMUI_Cycle (struct TagItem *tags)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Cycle, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Cycle object\n");
#endif
	}

	CMUI_Cycle (Tag tag1, ...)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Cycle, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Cycle object\n");
#endif
	}

	CMUI_Cycle (Object * obj)
	: CMUI_Group ()
	{
		object = obj;
	}

	CMUI_Cycle (STRPTR label, STRPTR * entries)
	: CMUI_Group ()
	{
		object = MUI_MakeObject (MUIO_Cycle, label, entries);
	}

	CMUI_Cycle & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	LONG Active (void) const;
	void SetActive (LONG value);
};

/***************************************************************************
**                    CMUI_Coloradjust class definition                     
***************************************************************************/

class CMUI_Coloradjust : public CMUI_Group
{
public:
	CMUI_Coloradjust (void)
	: CMUI_Group ()
	{
	}

	CMUI_Coloradjust (struct TagItem *tags)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Coloradjust, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Coloradjust object\n");
#endif
	}

	CMUI_Coloradjust (Tag tag1, ...)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Coloradjust, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Coloradjust object\n");
#endif
	}

	CMUI_Coloradjust (Object * obj)
	: CMUI_Group ()
	{
		object = obj;
	}

	CMUI_Coloradjust & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	ULONG Blue (void) const;
	void SetBlue (ULONG value);
	ULONG Green (void) const;
	void SetGreen (ULONG value);
	ULONG ModeID (void) const;
	void SetModeID (ULONG value);
	ULONG Red (void) const;
	void SetRed (ULONG value);
	ULONG * RGB (void) const;
	void SetRGB (ULONG * value);
};

/***************************************************************************
**                      CMUI_Palette class definition                       
***************************************************************************/

class CMUI_Palette : public CMUI_Group
{
public:
	CMUI_Palette (void)
	: CMUI_Group ()
	{
	}

	CMUI_Palette (struct TagItem *tags)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Palette, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Palette object\n");
#endif
	}

	CMUI_Palette (Tag tag1, ...)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Palette, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Palette object\n");
#endif
	}

	CMUI_Palette (Object * obj)
	: CMUI_Group ()
	{
		object = obj;
	}

	CMUI_Palette & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	struct MUI_Palette_Entry * Entries (void) const;
	BOOL Groupable (void) const;
	void SetGroupable (BOOL value);
	char ** Names (void) const;
	void SetNames (char ** value);
};

/***************************************************************************
**                     CMUI_Popstring class definition                      
***************************************************************************/

class CMUI_Popstring : public CMUI_Group
{
public:
	CMUI_Popstring (void)
	: CMUI_Group ()
	{
	}

	CMUI_Popstring (struct TagItem *tags)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Popstring, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Popstring object\n");
#endif
	}

	CMUI_Popstring (Tag tag1, ...)
	: CMUI_Group ()
	{
		object = MUI_NewObjectA (MUIC_Popstring, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Popstring object\n");
#endif
	}

	CMUI_Popstring (Object * obj)
	: CMUI_Group ()
	{
		object = obj;
	}

	CMUI_Popstring & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	Object * Button (void) const;
	struct Hook * CloseHook (void) const;
	void SetCloseHook (struct Hook * value);
	struct Hook * OpenHook (void) const;
	void SetOpenHook (struct Hook * value);
	Object * String (void) const;
	BOOL Toggle (void) const;
	void SetToggle (BOOL value);
	ULONG Close (LONG result);
	ULONG Open (void);
};

/***************************************************************************
**                     CMUI_Popobject class definition                      
***************************************************************************/

class CMUI_Popobject : public CMUI_Popstring
{
public:
	CMUI_Popobject (void)
	: CMUI_Popstring ()
	{
	}

	CMUI_Popobject (struct TagItem *tags)
	: CMUI_Popstring ()
	{
		object = MUI_NewObjectA (MUIC_Popobject, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Popobject object\n");
#endif
	}

	CMUI_Popobject (Tag tag1, ...)
	: CMUI_Popstring ()
	{
		object = MUI_NewObjectA (MUIC_Popobject, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Popobject object\n");
#endif
	}

	CMUI_Popobject (Object * obj)
	: CMUI_Popstring ()
	{
		object = obj;
	}

	CMUI_Popobject & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	BOOL Follow (void) const;
	void SetFollow (BOOL value);
	BOOL Light (void) const;
	void SetLight (BOOL value);
	Object * PopObject (void) const;
	struct Hook * ObjStrHook (void) const;
	void SetObjStrHook (struct Hook * value);
	struct Hook * StrObjHook (void) const;
	void SetStrObjHook (struct Hook * value);
	BOOL Volatile (void) const;
	void SetVolatile (BOOL value);
	struct Hook * WindowHook (void) const;
	void SetWindowHook (struct Hook * value);
};

/***************************************************************************
**                      CMUI_Poplist class definition                       
***************************************************************************/

class CMUI_Poplist : public CMUI_Popobject
{
public:
	CMUI_Poplist (void)
	: CMUI_Popobject ()
	{
	}

	CMUI_Poplist (struct TagItem *tags)
	: CMUI_Popobject ()
	{
		object = MUI_NewObjectA (MUIC_Poplist, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Poplist object\n");
#endif
	}

	CMUI_Poplist (Tag tag1, ...)
	: CMUI_Popobject ()
	{
		object = MUI_NewObjectA (MUIC_Poplist, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Poplist object\n");
#endif
	}

	CMUI_Poplist (Object * obj)
	: CMUI_Popobject ()
	{
		object = obj;
	}

	CMUI_Poplist & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                     CMUI_Popscreen class definition                      
***************************************************************************/

class CMUI_Popscreen : public CMUI_Popobject
{
public:
	CMUI_Popscreen (void)
	: CMUI_Popobject ()
	{
	}

	CMUI_Popscreen (struct TagItem *tags)
	: CMUI_Popobject ()
	{
		object = MUI_NewObjectA (MUIC_Popscreen, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Popscreen object\n");
#endif
	}

	CMUI_Popscreen (Tag tag1, ...)
	: CMUI_Popobject ()
	{
		object = MUI_NewObjectA (MUIC_Popscreen, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Popscreen object\n");
#endif
	}

	CMUI_Popscreen (Object * obj)
	: CMUI_Popobject ()
	{
		object = obj;
	}

	CMUI_Popscreen & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                       CMUI_Popasl class definition                       
***************************************************************************/

class CMUI_Popasl : public CMUI_Popstring
{
public:
	CMUI_Popasl (void)
	: CMUI_Popstring ()
	{
	}

	CMUI_Popasl (struct TagItem *tags)
	: CMUI_Popstring ()
	{
		object = MUI_NewObjectA (MUIC_Popasl, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Popasl object\n");
#endif
	}

	CMUI_Popasl (Tag tag1, ...)
	: CMUI_Popstring ()
	{
		object = MUI_NewObjectA (MUIC_Popasl, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Popasl object\n");
#endif
	}

	CMUI_Popasl (Object * obj)
	: CMUI_Popstring ()
	{
		object = obj;
	}

	CMUI_Popasl & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	BOOL Active (void) const;
	struct Hook * StartHook (void) const;
	void SetStartHook (struct Hook * value);
	struct Hook * StopHook (void) const;
	void SetStopHook (struct Hook * value);
	ULONG Type (void) const;
};

/***************************************************************************
**                     CMUI_Semaphore class definition                      
***************************************************************************/

class CMUI_Semaphore : public CMUI_Object
{
public:
	CMUI_Semaphore (void)
	: CMUI_Object ()
	{
	}

	CMUI_Semaphore (struct TagItem *tags)
	: CMUI_Object ()
	{
		object = MUI_NewObjectA (MUIC_Semaphore, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Semaphore object\n");
#endif
	}

	CMUI_Semaphore (Tag tag1, ...)
	: CMUI_Object ()
	{
		object = MUI_NewObjectA (MUIC_Semaphore, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Semaphore object\n");
#endif
	}

	CMUI_Semaphore (Object * obj)
	: CMUI_Object ()
	{
		object = obj;
	}

	CMUI_Semaphore & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	ULONG Attempt (void);
	ULONG AttemptShared (void);
	ULONG Obtain (void);
	ULONG ObtainShared (void);
	ULONG Release (void);
};

/***************************************************************************
**                      CMUI_Applist class definition                       
***************************************************************************/

class CMUI_Applist : public CMUI_Semaphore
{
public:
	CMUI_Applist (void)
	: CMUI_Semaphore ()
	{
	}

	CMUI_Applist (struct TagItem *tags)
	: CMUI_Semaphore ()
	{
		object = MUI_NewObjectA (MUIC_Applist, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Applist object\n");
#endif
	}

	CMUI_Applist (Tag tag1, ...)
	: CMUI_Semaphore ()
	{
		object = MUI_NewObjectA (MUIC_Applist, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Applist object\n");
#endif
	}

	CMUI_Applist (Object * obj)
	: CMUI_Semaphore ()
	{
		object = obj;
	}

	CMUI_Applist & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                     CMUI_Dataspace class definition                      
***************************************************************************/

class CMUI_Dataspace : public CMUI_Semaphore
{
public:
	CMUI_Dataspace (void)
	: CMUI_Semaphore ()
	{
	}

	CMUI_Dataspace (struct TagItem *tags)
	: CMUI_Semaphore ()
	{
		object = MUI_NewObjectA (MUIC_Dataspace, tags);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Dataspace object\n");
#endif
	}

	CMUI_Dataspace (Tag tag1, ...)
	: CMUI_Semaphore ()
	{
		object = MUI_NewObjectA (MUIC_Dataspace, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
		if (object == NULL)
			_MUIPPWarning ("Could not create a CMUI_Dataspace object\n");
#endif
	}

	CMUI_Dataspace (Object * obj)
	: CMUI_Semaphore ()
	{
		object = obj;
	}

	CMUI_Dataspace & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

	ULONG Add (APTR data, LONG len, ULONG id);
	ULONG Clear (void);
	ULONG Find (ULONG id);
	ULONG Merge (Object * dataspace);
	ULONG ReadIFF (struct IFFHandle * handle);
	ULONG Remove (ULONG id);
	ULONG WriteIFF (struct IFFHandle * handle, ULONG type, ULONG id);
};

/***************************************************************************
**                     CMUI_Configdata class definition                     
***************************************************************************/

class CMUI_Configdata : public CMUI_Dataspace
{
public:
protected:
	CMUI_Configdata (void)
	: CMUI_Dataspace ()
	{
	}

};

/***************************************************************************
**                       CMUI_Label class definition                        
***************************************************************************/

class CMUI_Label : public CMUI_Text
{
public:
	CMUI_Label (void)
	: CMUI_Text ()
	{
	}

	CMUI_Label (Object * obj)
	: CMUI_Text ()
	{
		object = obj;
	}

	CMUI_Label (STRPTR label, ULONG flags)
	: CMUI_Text ()
	{
		object = MUI_MakeObject (MUIO_Label, label, flags);
	}

	CMUI_Label & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                       CMUI_Button class definition                       
***************************************************************************/

class CMUI_Button : public CMUI_Text
{
public:
	CMUI_Button (void)
	: CMUI_Text ()
	{
	}

	CMUI_Button (Object * obj)
	: CMUI_Text ()
	{
		object = obj;
	}

	CMUI_Button (STRPTR label)
	: CMUI_Text ()
	{
		object = MUI_MakeObject (MUIO_Button, label);
	}

	CMUI_Button & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                     CMUI_Checkmark class definition                      
***************************************************************************/

class CMUI_Checkmark : public CMUI_Image
{
public:
	CMUI_Checkmark (void)
	: CMUI_Image ()
	{
	}

	CMUI_Checkmark (Object * obj)
	: CMUI_Image ()
	{
		object = obj;
	}

	CMUI_Checkmark (STRPTR label)
	: CMUI_Image ()
	{
		object = MUI_MakeObject (MUIO_Checkmark, label);
	}

	CMUI_Checkmark & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                       CMUI_HSpace class definition                       
***************************************************************************/

class CMUI_HSpace : public CMUI_Rectangle
{
public:
	CMUI_HSpace (void)
	: CMUI_Rectangle ()
	{
	}

	CMUI_HSpace (Object * obj)
	: CMUI_Rectangle ()
	{
		object = obj;
	}

	CMUI_HSpace (LONG space)
	: CMUI_Rectangle ()
	{
		object = MUI_MakeObject (MUIO_HSpace, space);
	}

	CMUI_HSpace & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                       CMUI_VSpace class definition                       
***************************************************************************/

class CMUI_VSpace : public CMUI_Rectangle
{
public:
	CMUI_VSpace (void)
	: CMUI_Rectangle ()
	{
	}

	CMUI_VSpace (Object * obj)
	: CMUI_Rectangle ()
	{
		object = obj;
	}

	CMUI_VSpace (LONG space)
	: CMUI_Rectangle ()
	{
		object = MUI_MakeObject (MUIO_VSpace, space);
	}

	CMUI_VSpace & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                        CMUI_HBar class definition                        
***************************************************************************/

class CMUI_HBar : public CMUI_Rectangle
{
public:
	CMUI_HBar (void)
	: CMUI_Rectangle ()
	{
	}

	CMUI_HBar (Object * obj)
	: CMUI_Rectangle ()
	{
		object = obj;
	}

	CMUI_HBar (LONG space)
	: CMUI_Rectangle ()
	{
		object = MUI_MakeObject (MUIO_HBar, space);
	}

	CMUI_HBar & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                        CMUI_VBar class definition                        
***************************************************************************/

class CMUI_VBar : public CMUI_Rectangle
{
public:
	CMUI_VBar (void)
	: CMUI_Rectangle ()
	{
	}

	CMUI_VBar (Object * obj)
	: CMUI_Rectangle ()
	{
		object = obj;
	}

	CMUI_VBar (LONG space)
	: CMUI_Rectangle ()
	{
		object = MUI_MakeObject (MUIO_VBar, space);
	}

	CMUI_VBar & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

/***************************************************************************
**                      CMUI_BarTitle class definition                      
***************************************************************************/

class CMUI_BarTitle : public CMUI_Rectangle
{
public:
	CMUI_BarTitle (void)
	: CMUI_Rectangle ()
	{
	}

	CMUI_BarTitle (Object * obj)
	: CMUI_Rectangle ()
	{
		object = obj;
	}

	CMUI_BarTitle (LONG space)
	: CMUI_Rectangle ()
	{
		object = MUI_MakeObject (MUIO_BarTitle, space);
	}

	CMUI_BarTitle & operator = (Object * obj)
	{
		object = obj;
		return *this;
	}

};

#ifndef MUIPP_NOINLINES

inline Object * CMUI_Notify::ApplicationObject (void) const
{
	 return (Object *)GetAttr (MUIA_ApplicationObject);
}

inline struct AppMessage * CMUI_Notify::AppMessage (void) const
{
	 return (struct AppMessage *)GetAttr (MUIA_AppMessage);
}

inline LONG CMUI_Notify::HelpLine (void) const
{
	 return (LONG)GetAttr (MUIA_HelpLine);
}

inline void CMUI_Notify::SetHelpLine (LONG value)
{
	 SetAttr (MUIA_HelpLine, (ULONG)value);
}

inline STRPTR CMUI_Notify::HelpNode (void) const
{
	 return (STRPTR)GetAttr (MUIA_HelpNode);
}

inline void CMUI_Notify::SetHelpNode (STRPTR value)
{
	 SetAttr (MUIA_HelpNode, (ULONG)value);
}

inline void CMUI_Notify::SetNoNotify (BOOL value)
{
	 SetAttr (MUIA_NoNotify, (ULONG)value);
}

inline ULONG CMUI_Notify::ObjectID (void) const
{
	 return (ULONG)GetAttr (MUIA_ObjectID);
}

inline void CMUI_Notify::SetObjectID (ULONG value)
{
	 SetAttr (MUIA_ObjectID, (ULONG)value);
}

inline Object * CMUI_Notify::Parent (void) const
{
	 return (Object *)GetAttr (MUIA_Parent);
}

inline LONG CMUI_Notify::Revision (void) const
{
	 return (LONG)GetAttr (MUIA_Revision);
}

inline ULONG CMUI_Notify::UserData (void) const
{
	 return (ULONG)GetAttr (MUIA_UserData);
}

inline void CMUI_Notify::SetUserData (ULONG value)
{
	 SetAttr (MUIA_UserData, (ULONG)value);
}

inline LONG CMUI_Notify::Version (void) const
{
	 return (LONG)GetAttr (MUIA_Version);
}

inline ULONG CMUI_Notify::CallHook (StartVarArgs sva, struct Hook * Hook, ULONG param1, ...)
{
	sva.methodID = MUIM_CallHook;
	return DoMethodA ((Msg)&sva);
}

inline ULONG CMUI_Notify::Export (Object * dataspace)
{
	return DoMethod (MUIM_Export, dataspace);
}

inline ULONG CMUI_Notify::FindUData (ULONG udata)
{
	return DoMethod (MUIM_FindUData, udata);
}

inline ULONG CMUI_Notify::GetConfigItem (ULONG id, ULONG * storage)
{
	return DoMethod (MUIM_GetConfigItem, id, storage);
}

inline ULONG CMUI_Notify::GetUData (ULONG udata, ULONG attr, ULONG * storage)
{
	return DoMethod (MUIM_GetUData, udata, attr, storage);
}

inline ULONG CMUI_Notify::Import (Object * dataspace)
{
	return DoMethod (MUIM_Import, dataspace);
}

inline ULONG CMUI_Notify::KillNotify (ULONG TrigAttr)
{
	return DoMethod (MUIM_KillNotify, TrigAttr);
}

inline ULONG CMUI_Notify::KillNotifyObj (ULONG TrigAttr, Object * dest)
{
	return DoMethod (MUIM_KillNotifyObj, TrigAttr, dest);
}

inline ULONG CMUI_Notify::MultiSet (StartVarArgs sva, ULONG attr, ULONG val, APTR obj, ...)
{
	sva.methodID = MUIM_MultiSet;
	return DoMethodA ((Msg)&sva);
}

inline ULONG CMUI_Notify::NoNotifySet (StartVarArgs sva, ULONG attr, char * format, ULONG val, ...)
{
	sva.methodID = MUIM_NoNotifySet;
	return DoMethodA ((Msg)&sva);
}

inline ULONG CMUI_Notify::Notify (StartVarArgs sva, ULONG TrigAttr, ULONG TrigVal, APTR DestObj, ULONG FollowParams, ...)
{
	sva.methodID = MUIM_Notify;
	return DoMethodA ((Msg)&sva);
}

inline ULONG CMUI_Notify::Set (ULONG attr, ULONG val)
{
	return DoMethod (MUIM_Set, attr, val);
}

inline ULONG CMUI_Notify::SetAsString (StartVarArgs sva, ULONG attr, char * format, ULONG val, ...)
{
	sva.methodID = MUIM_SetAsString;
	return DoMethodA ((Msg)&sva);
}

inline ULONG CMUI_Notify::SetUData (ULONG udata, ULONG attr, ULONG val)
{
	return DoMethod (MUIM_SetUData, udata, attr, val);
}

inline ULONG CMUI_Notify::SetUDataOnce (ULONG udata, ULONG attr, ULONG val)
{
	return DoMethod (MUIM_SetUDataOnce, udata, attr, val);
}

inline ULONG CMUI_Notify::WriteLong (ULONG val, ULONG * memory)
{
	return DoMethod (MUIM_WriteLong, val, memory);
}

inline ULONG CMUI_Notify::WriteString (char * str, char * memory)
{
	return DoMethod (MUIM_WriteString, str, memory);
}

inline struct MinList * CMUI_Family::List (void) const
{
	 return (struct MinList *)GetAttr (MUIA_Family_List);
}

inline ULONG CMUI_Family::AddHead (Object * obj)
{
	return DoMethod (MUIM_Family_AddHead, obj);
}

inline ULONG CMUI_Family::AddTail (Object * obj)
{
	return DoMethod (MUIM_Family_AddTail, obj);
}

inline ULONG CMUI_Family::Insert (Object * obj, Object * pred)
{
	return DoMethod (MUIM_Family_Insert, obj, pred);
}

inline ULONG CMUI_Family::Remove (Object * obj)
{
	return DoMethod (MUIM_Family_Remove, obj);
}

inline ULONG CMUI_Family::Sort (StartVarArgs sva, Object * obj, ...)
{
	sva.methodID = MUIM_Family_Sort;
	return DoMethodA ((Msg)&sva);
}

inline ULONG CMUI_Family::Transfer (Object * family)
{
	return DoMethod (MUIM_Family_Transfer, family);
}

inline BOOL CMUI_Menustrip::Enabled (void) const
{
	 return (BOOL)GetAttr (MUIA_Menustrip_Enabled);
}

inline void CMUI_Menustrip::SetEnabled (BOOL value)
{
	 SetAttr (MUIA_Menustrip_Enabled, (ULONG)value);
}

inline BOOL CMUI_Menu::Enabled (void) const
{
	 return (BOOL)GetAttr (MUIA_Menu_Enabled);
}

inline void CMUI_Menu::SetEnabled (BOOL value)
{
	 SetAttr (MUIA_Menu_Enabled, (ULONG)value);
}

inline STRPTR CMUI_Menu::Title (void) const
{
	 return (STRPTR)GetAttr (MUIA_Menu_Title);
}

inline void CMUI_Menu::SetTitle (STRPTR value)
{
	 SetAttr (MUIA_Menu_Title, (ULONG)value);
}

inline BOOL CMUI_Menuitem::Checked (void) const
{
	 return (BOOL)GetAttr (MUIA_Menuitem_Checked);
}

inline void CMUI_Menuitem::SetChecked (BOOL value)
{
	 SetAttr (MUIA_Menuitem_Checked, (ULONG)value);
}

inline BOOL CMUI_Menuitem::Checkit (void) const
{
	 return (BOOL)GetAttr (MUIA_Menuitem_Checkit);
}

inline void CMUI_Menuitem::SetCheckit (BOOL value)
{
	 SetAttr (MUIA_Menuitem_Checkit, (ULONG)value);
}

inline BOOL CMUI_Menuitem::CommandString (void) const
{
	 return (BOOL)GetAttr (MUIA_Menuitem_CommandString);
}

inline void CMUI_Menuitem::SetCommandString (BOOL value)
{
	 SetAttr (MUIA_Menuitem_CommandString, (ULONG)value);
}

inline BOOL CMUI_Menuitem::Enabled (void) const
{
	 return (BOOL)GetAttr (MUIA_Menuitem_Enabled);
}

inline void CMUI_Menuitem::SetEnabled (BOOL value)
{
	 SetAttr (MUIA_Menuitem_Enabled, (ULONG)value);
}

inline LONG CMUI_Menuitem::Exclude (void) const
{
	 return (LONG)GetAttr (MUIA_Menuitem_Exclude);
}

inline void CMUI_Menuitem::SetExclude (LONG value)
{
	 SetAttr (MUIA_Menuitem_Exclude, (ULONG)value);
}

inline STRPTR CMUI_Menuitem::Shortcut (void) const
{
	 return (STRPTR)GetAttr (MUIA_Menuitem_Shortcut);
}

inline void CMUI_Menuitem::SetShortcut (STRPTR value)
{
	 SetAttr (MUIA_Menuitem_Shortcut, (ULONG)value);
}

inline STRPTR CMUI_Menuitem::Title (void) const
{
	 return (STRPTR)GetAttr (MUIA_Menuitem_Title);
}

inline void CMUI_Menuitem::SetTitle (STRPTR value)
{
	 SetAttr (MUIA_Menuitem_Title, (ULONG)value);
}

inline BOOL CMUI_Menuitem::Toggle (void) const
{
	 return (BOOL)GetAttr (MUIA_Menuitem_Toggle);
}

inline void CMUI_Menuitem::SetToggle (BOOL value)
{
	 SetAttr (MUIA_Menuitem_Toggle, (ULONG)value);
}

inline struct MenuItem * CMUI_Menuitem::Trigger (void) const
{
	 return (struct MenuItem *)GetAttr (MUIA_Menuitem_Trigger);
}

inline BOOL CMUI_Application::Active (void) const
{
	 return (BOOL)GetAttr (MUIA_Application_Active);
}

inline void CMUI_Application::SetActive (BOOL value)
{
	 SetAttr (MUIA_Application_Active, (ULONG)value);
}

inline STRPTR CMUI_Application::Author (void) const
{
	 return (STRPTR)GetAttr (MUIA_Application_Author);
}

inline STRPTR CMUI_Application::Base (void) const
{
	 return (STRPTR)GetAttr (MUIA_Application_Base);
}

inline CxObj * CMUI_Application::Broker (void) const
{
	 return (CxObj *)GetAttr (MUIA_Application_Broker);
}

inline struct Hook * CMUI_Application::BrokerHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Application_BrokerHook);
}

inline void CMUI_Application::SetBrokerHook (struct Hook * value)
{
	 SetAttr (MUIA_Application_BrokerHook, (ULONG)value);
}

inline struct MsgPort * CMUI_Application::BrokerPort (void) const
{
	 return (struct MsgPort *)GetAttr (MUIA_Application_BrokerPort);
}

inline LONG CMUI_Application::BrokerPri (void) const
{
	 return (LONG)GetAttr (MUIA_Application_BrokerPri);
}

inline struct MUI_Command * CMUI_Application::Commands (void) const
{
	 return (struct MUI_Command *)GetAttr (MUIA_Application_Commands);
}

inline void CMUI_Application::SetCommands (struct MUI_Command * value)
{
	 SetAttr (MUIA_Application_Commands, (ULONG)value);
}

inline STRPTR CMUI_Application::Copyright (void) const
{
	 return (STRPTR)GetAttr (MUIA_Application_Copyright);
}

inline STRPTR CMUI_Application::Description (void) const
{
	 return (STRPTR)GetAttr (MUIA_Application_Description);
}

inline struct DiskObject * CMUI_Application::DiskObject (void) const
{
	 return (struct DiskObject *)GetAttr (MUIA_Application_DiskObject);
}

inline void CMUI_Application::SetDiskObject (struct DiskObject * value)
{
	 SetAttr (MUIA_Application_DiskObject, (ULONG)value);
}

inline BOOL CMUI_Application::DoubleStart (void) const
{
	 return (BOOL)GetAttr (MUIA_Application_DoubleStart);
}

inline void CMUI_Application::SetDropObject (Object * value)
{
	 SetAttr (MUIA_Application_DropObject, (ULONG)value);
}

inline BOOL CMUI_Application::ForceQuit (void) const
{
	 return (BOOL)GetAttr (MUIA_Application_ForceQuit);
}

inline STRPTR CMUI_Application::HelpFile (void) const
{
	 return (STRPTR)GetAttr (MUIA_Application_HelpFile);
}

inline void CMUI_Application::SetHelpFile (STRPTR value)
{
	 SetAttr (MUIA_Application_HelpFile, (ULONG)value);
}

inline BOOL CMUI_Application::Iconified (void) const
{
	 return (BOOL)GetAttr (MUIA_Application_Iconified);
}

inline void CMUI_Application::SetIconified (BOOL value)
{
	 SetAttr (MUIA_Application_Iconified, (ULONG)value);
}

inline ULONG CMUI_Application::MenuAction (void) const
{
	 return (ULONG)GetAttr (MUIA_Application_MenuAction);
}

inline ULONG CMUI_Application::MenuHelp (void) const
{
	 return (ULONG)GetAttr (MUIA_Application_MenuHelp);
}

inline struct Hook * CMUI_Application::RexxHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Application_RexxHook);
}

inline void CMUI_Application::SetRexxHook (struct Hook * value)
{
	 SetAttr (MUIA_Application_RexxHook, (ULONG)value);
}

inline struct RxMsg * CMUI_Application::RexxMsg (void) const
{
	 return (struct RxMsg *)GetAttr (MUIA_Application_RexxMsg);
}

inline void CMUI_Application::SetRexxString (STRPTR value)
{
	 SetAttr (MUIA_Application_RexxString, (ULONG)value);
}

inline void CMUI_Application::SetSleep (BOOL value)
{
	 SetAttr (MUIA_Application_Sleep, (ULONG)value);
}

inline STRPTR CMUI_Application::Title (void) const
{
	 return (STRPTR)GetAttr (MUIA_Application_Title);
}

inline STRPTR CMUI_Application::Version (void) const
{
	 return (STRPTR)GetAttr (MUIA_Application_Version);
}

inline struct List * CMUI_Application::WindowList (void) const
{
	 return (struct List *)GetAttr (MUIA_Application_WindowList);
}

inline ULONG CMUI_Application::AboutMUI (Object * refwindow)
{
	return DoMethod (MUIM_Application_AboutMUI, refwindow);
}

inline ULONG CMUI_Application::AddInputHandler (struct MUI_InputHandlerNode * ihnode)
{
	return DoMethod (MUIM_Application_AddInputHandler, ihnode);
}

inline ULONG CMUI_Application::CheckRefresh (void)
{
	return DoMethod (MUIM_Application_CheckRefresh);
}

inline ULONG CMUI_Application::InputBuffered (void)
{
	return DoMethod (MUIM_Application_InputBuffered);
}

inline ULONG CMUI_Application::Load (STRPTR name)
{
	return DoMethod (MUIM_Application_Load, name);
}

inline ULONG CMUI_Application::NewInput (LONGBITS * signal)
{
	return DoMethod (MUIM_Application_NewInput, signal);
}

inline ULONG CMUI_Application::OpenConfigWindow (ULONG flags)
{
	return DoMethod (MUIM_Application_OpenConfigWindow, flags);
}

inline ULONG CMUI_Application::PushMethod (StartVarArgs sva, Object * dest, LONG count, ...)
{
	sva.methodID = MUIM_Application_PushMethod;
	return DoMethodA ((Msg)&sva);
}

inline ULONG CMUI_Application::RemInputHandler (struct MUI_InputHandlerNode * ihnode)
{
	return DoMethod (MUIM_Application_RemInputHandler, ihnode);
}

inline ULONG CMUI_Application::ReturnID (ULONG retid)
{
	return DoMethod (MUIM_Application_ReturnID, retid);
}

inline ULONG CMUI_Application::Save (STRPTR name)
{
	return DoMethod (MUIM_Application_Save, name);
}

inline ULONG CMUI_Application::SetConfigItem (ULONG item, APTR data)
{
	return DoMethod (MUIM_Application_SetConfigItem, item, data);
}

inline ULONG CMUI_Application::ShowHelp (Object * window, char * name, char * node, LONG line)
{
	return DoMethod (MUIM_Application_ShowHelp, window, name, node, line);
}

inline BOOL CMUI_Window::Activate (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_Activate);
}

inline void CMUI_Window::SetActivate (BOOL value)
{
	 SetAttr (MUIA_Window_Activate, (ULONG)value);
}

inline Object * CMUI_Window::ActiveObject (void) const
{
	 return (Object *)GetAttr (MUIA_Window_ActiveObject);
}

inline void CMUI_Window::SetActiveObject (Object * value)
{
	 SetAttr (MUIA_Window_ActiveObject, (ULONG)value);
}

inline LONG CMUI_Window::AltHeight (void) const
{
	 return (LONG)GetAttr (MUIA_Window_AltHeight);
}

inline LONG CMUI_Window::AltLeftEdge (void) const
{
	 return (LONG)GetAttr (MUIA_Window_AltLeftEdge);
}

inline LONG CMUI_Window::AltTopEdge (void) const
{
	 return (LONG)GetAttr (MUIA_Window_AltTopEdge);
}

inline LONG CMUI_Window::AltWidth (void) const
{
	 return (LONG)GetAttr (MUIA_Window_AltWidth);
}

inline BOOL CMUI_Window::CloseRequest (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_CloseRequest);
}

inline Object * CMUI_Window::DefaultObject (void) const
{
	 return (Object *)GetAttr (MUIA_Window_DefaultObject);
}

inline void CMUI_Window::SetDefaultObject (Object * value)
{
	 SetAttr (MUIA_Window_DefaultObject, (ULONG)value);
}

inline BOOL CMUI_Window::FancyDrawing (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_FancyDrawing);
}

inline void CMUI_Window::SetFancyDrawing (BOOL value)
{
	 SetAttr (MUIA_Window_FancyDrawing, (ULONG)value);
}

inline LONG CMUI_Window::Height (void) const
{
	 return (LONG)GetAttr (MUIA_Window_Height);
}

inline ULONG CMUI_Window::ID (void) const
{
	 return (ULONG)GetAttr (MUIA_Window_ID);
}

inline void CMUI_Window::SetID (ULONG value)
{
	 SetAttr (MUIA_Window_ID, (ULONG)value);
}

inline struct InputEvent * CMUI_Window::InputEvent (void) const
{
	 return (struct InputEvent *)GetAttr (MUIA_Window_InputEvent);
}

inline BOOL CMUI_Window::IsSubWindow (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_IsSubWindow);
}

inline void CMUI_Window::SetIsSubWindow (BOOL value)
{
	 SetAttr (MUIA_Window_IsSubWindow, (ULONG)value);
}

inline LONG CMUI_Window::LeftEdge (void) const
{
	 return (LONG)GetAttr (MUIA_Window_LeftEdge);
}

inline ULONG CMUI_Window::MenuAction (void) const
{
	 return (ULONG)GetAttr (MUIA_Window_MenuAction);
}

inline void CMUI_Window::SetMenuAction (ULONG value)
{
	 SetAttr (MUIA_Window_MenuAction, (ULONG)value);
}

inline Object * CMUI_Window::Menustrip (void) const
{
	 return (Object *)GetAttr (MUIA_Window_Menustrip);
}

inline Object * CMUI_Window::MouseObject (void) const
{
	 return (Object *)GetAttr (MUIA_Window_MouseObject);
}

inline void CMUI_Window::SetNoMenus (BOOL value)
{
	 SetAttr (MUIA_Window_NoMenus, (ULONG)value);
}

inline BOOL CMUI_Window::Open (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_Open);
}

inline void CMUI_Window::SetOpen (BOOL value)
{
	 SetAttr (MUIA_Window_Open, (ULONG)value);
}

inline STRPTR CMUI_Window::PublicScreen (void) const
{
	 return (STRPTR)GetAttr (MUIA_Window_PublicScreen);
}

inline void CMUI_Window::SetPublicScreen (STRPTR value)
{
	 SetAttr (MUIA_Window_PublicScreen, (ULONG)value);
}

inline void CMUI_Window::SetRefWindow (Object * value)
{
	 SetAttr (MUIA_Window_RefWindow, (ULONG)value);
}

inline Object * CMUI_Window::RootObject (void) const
{
	 return (Object *)GetAttr (MUIA_Window_RootObject);
}

inline void CMUI_Window::SetRootObject (Object * value)
{
	 SetAttr (MUIA_Window_RootObject, (ULONG)value);
}

inline struct Screen * CMUI_Window::Screen (void) const
{
	 return (struct Screen *)GetAttr (MUIA_Window_Screen);
}

inline void CMUI_Window::SetScreen (struct Screen * value)
{
	 SetAttr (MUIA_Window_Screen, (ULONG)value);
}

inline STRPTR CMUI_Window::ScreenTitle (void) const
{
	 return (STRPTR)GetAttr (MUIA_Window_ScreenTitle);
}

inline void CMUI_Window::SetScreenTitle (STRPTR value)
{
	 SetAttr (MUIA_Window_ScreenTitle, (ULONG)value);
}

inline BOOL CMUI_Window::Sleep (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_Sleep);
}

inline void CMUI_Window::SetSleep (BOOL value)
{
	 SetAttr (MUIA_Window_Sleep, (ULONG)value);
}

inline STRPTR CMUI_Window::Title (void) const
{
	 return (STRPTR)GetAttr (MUIA_Window_Title);
}

inline void CMUI_Window::SetTitle (STRPTR value)
{
	 SetAttr (MUIA_Window_Title, (ULONG)value);
}

inline LONG CMUI_Window::TopEdge (void) const
{
	 return (LONG)GetAttr (MUIA_Window_TopEdge);
}

inline BOOL CMUI_Window::UseBottomBorderScroller (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_UseBottomBorderScroller);
}

inline void CMUI_Window::SetUseBottomBorderScroller (BOOL value)
{
	 SetAttr (MUIA_Window_UseBottomBorderScroller, (ULONG)value);
}

inline BOOL CMUI_Window::UseLeftBorderScroller (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_UseLeftBorderScroller);
}

inline void CMUI_Window::SetUseLeftBorderScroller (BOOL value)
{
	 SetAttr (MUIA_Window_UseLeftBorderScroller, (ULONG)value);
}

inline BOOL CMUI_Window::UseRightBorderScroller (void) const
{
	 return (BOOL)GetAttr (MUIA_Window_UseRightBorderScroller);
}

inline void CMUI_Window::SetUseRightBorderScroller (BOOL value)
{
	 SetAttr (MUIA_Window_UseRightBorderScroller, (ULONG)value);
}

inline LONG CMUI_Window::Width (void) const
{
	 return (LONG)GetAttr (MUIA_Window_Width);
}

inline struct Window * CMUI_Window::Window (void) const
{
	 return (struct Window *)GetAttr (MUIA_Window_Window);
}

inline ULONG CMUI_Window::AddEventHandler (struct MUI_EventHandlerNode * ehnode)
{
	return DoMethod (MUIM_Window_AddEventHandler, ehnode);
}

inline ULONG CMUI_Window::RemEventHandler (struct MUI_EventHandlerNode * ehnode)
{
	return DoMethod (MUIM_Window_RemEventHandler, ehnode);
}

inline ULONG CMUI_Window::ScreenToBack (void)
{
	return DoMethod (MUIM_Window_ScreenToBack);
}

inline ULONG CMUI_Window::ScreenToFront (void)
{
	return DoMethod (MUIM_Window_ScreenToFront);
}

inline ULONG CMUI_Window::Snapshot (LONG flags)
{
	return DoMethod (MUIM_Window_Snapshot, flags);
}

inline ULONG CMUI_Window::ToBack (void)
{
	return DoMethod (MUIM_Window_ToBack);
}

inline ULONG CMUI_Window::ToFront (void)
{
	return DoMethod (MUIM_Window_ToFront);
}

inline void CMUI_Area::SetBackground (LONG value)
{
	 SetAttr (MUIA_Background, (ULONG)value);
}

inline LONG CMUI_Area::BottomEdge (void) const
{
	 return (LONG)GetAttr (MUIA_BottomEdge);
}

inline Object * CMUI_Area::ContextMenu (void) const
{
	 return (Object *)GetAttr (MUIA_ContextMenu);
}

inline void CMUI_Area::SetContextMenu (Object * value)
{
	 SetAttr (MUIA_ContextMenu, (ULONG)value);
}

inline Object * CMUI_Area::ContextMenuTrigger (void) const
{
	 return (Object *)GetAttr (MUIA_ContextMenuTrigger);
}

inline char CMUI_Area::ControlChar (void) const
{
	 return (char)GetAttr (MUIA_ControlChar);
}

inline void CMUI_Area::SetControlChar (char value)
{
	 SetAttr (MUIA_ControlChar, (ULONG)value);
}

inline LONG CMUI_Area::CycleChain (void) const
{
	 return (LONG)GetAttr (MUIA_CycleChain);
}

inline void CMUI_Area::SetCycleChain (LONG value)
{
	 SetAttr (MUIA_CycleChain, (ULONG)value);
}

inline BOOL CMUI_Area::Disabled (void) const
{
	 return (BOOL)GetAttr (MUIA_Disabled);
}

inline void CMUI_Area::SetDisabled (BOOL value)
{
	 SetAttr (MUIA_Disabled, (ULONG)value);
}

inline BOOL CMUI_Area::Draggable (void) const
{
	 return (BOOL)GetAttr (MUIA_Draggable);
}

inline void CMUI_Area::SetDraggable (BOOL value)
{
	 SetAttr (MUIA_Draggable, (ULONG)value);
}

inline BOOL CMUI_Area::Dropable (void) const
{
	 return (BOOL)GetAttr (MUIA_Dropable);
}

inline void CMUI_Area::SetDropable (BOOL value)
{
	 SetAttr (MUIA_Dropable, (ULONG)value);
}

inline void CMUI_Area::SetFillArea (BOOL value)
{
	 SetAttr (MUIA_FillArea, (ULONG)value);
}

inline struct TextFont * CMUI_Area::Font (void) const
{
	 return (struct TextFont *)GetAttr (MUIA_Font);
}

inline LONG CMUI_Area::Height (void) const
{
	 return (LONG)GetAttr (MUIA_Height);
}

inline LONG CMUI_Area::HorizDisappear (void) const
{
	 return (LONG)GetAttr (MUIA_HorizDisappear);
}

inline void CMUI_Area::SetHorizDisappear (LONG value)
{
	 SetAttr (MUIA_HorizDisappear, (ULONG)value);
}

inline WORD CMUI_Area::HorizWeight (void) const
{
	 return (WORD)GetAttr (MUIA_HorizWeight);
}

inline void CMUI_Area::SetHorizWeight (WORD value)
{
	 SetAttr (MUIA_HorizWeight, (ULONG)value);
}

inline LONG CMUI_Area::InnerBottom (void) const
{
	 return (LONG)GetAttr (MUIA_InnerBottom);
}

inline LONG CMUI_Area::InnerLeft (void) const
{
	 return (LONG)GetAttr (MUIA_InnerLeft);
}

inline LONG CMUI_Area::InnerRight (void) const
{
	 return (LONG)GetAttr (MUIA_InnerRight);
}

inline LONG CMUI_Area::InnerTop (void) const
{
	 return (LONG)GetAttr (MUIA_InnerTop);
}

inline LONG CMUI_Area::LeftEdge (void) const
{
	 return (LONG)GetAttr (MUIA_LeftEdge);
}

inline BOOL CMUI_Area::Pressed (void) const
{
	 return (BOOL)GetAttr (MUIA_Pressed);
}

inline LONG CMUI_Area::RightEdge (void) const
{
	 return (LONG)GetAttr (MUIA_RightEdge);
}

inline BOOL CMUI_Area::Selected (void) const
{
	 return (BOOL)GetAttr (MUIA_Selected);
}

inline void CMUI_Area::SetSelected (BOOL value)
{
	 SetAttr (MUIA_Selected, (ULONG)value);
}

inline STRPTR CMUI_Area::ShortHelp (void) const
{
	 return (STRPTR)GetAttr (MUIA_ShortHelp);
}

inline void CMUI_Area::SetShortHelp (STRPTR value)
{
	 SetAttr (MUIA_ShortHelp, (ULONG)value);
}

inline BOOL CMUI_Area::ShowMe (void) const
{
	 return (BOOL)GetAttr (MUIA_ShowMe);
}

inline void CMUI_Area::SetShowMe (BOOL value)
{
	 SetAttr (MUIA_ShowMe, (ULONG)value);
}

inline LONG CMUI_Area::Timer (void) const
{
	 return (LONG)GetAttr (MUIA_Timer);
}

inline LONG CMUI_Area::TopEdge (void) const
{
	 return (LONG)GetAttr (MUIA_TopEdge);
}

inline LONG CMUI_Area::VertDisappear (void) const
{
	 return (LONG)GetAttr (MUIA_VertDisappear);
}

inline void CMUI_Area::SetVertDisappear (LONG value)
{
	 SetAttr (MUIA_VertDisappear, (ULONG)value);
}

inline WORD CMUI_Area::VertWeight (void) const
{
	 return (WORD)GetAttr (MUIA_VertWeight);
}

inline void CMUI_Area::SetVertWeight (WORD value)
{
	 SetAttr (MUIA_VertWeight, (ULONG)value);
}

inline LONG CMUI_Area::Width (void) const
{
	 return (LONG)GetAttr (MUIA_Width);
}

inline struct Window * CMUI_Area::Window (void) const
{
	 return (struct Window *)GetAttr (MUIA_Window);
}

inline Object * CMUI_Area::WindowObject (void) const
{
	 return (Object *)GetAttr (MUIA_WindowObject);
}

inline ULONG CMUI_Area::AskMinMax (struct MUI_MinMax * MinMaxInfo)
{
	return DoMethod (MUIM_AskMinMax, MinMaxInfo);
}

inline ULONG CMUI_Area::Cleanup (void)
{
	return DoMethod (MUIM_Cleanup);
}

inline ULONG CMUI_Area::ContextMenuBuild (LONG mx, LONG my)
{
	return DoMethod (MUIM_ContextMenuBuild, mx, my);
}

inline ULONG CMUI_Area::ContextMenuChoice (Object * item)
{
	return DoMethod (MUIM_ContextMenuChoice, item);
}

inline ULONG CMUI_Area::CreateBubble (LONG x, LONG y, char * txt, ULONG flags)
{
	return DoMethod (MUIM_CreateBubble, x, y, txt, flags);
}

inline ULONG CMUI_Area::CreateShortHelp (LONG mx, LONG my)
{
	return DoMethod (MUIM_CreateShortHelp, mx, my);
}

inline ULONG CMUI_Area::DeleteBubble (APTR bubble)
{
	return DoMethod (MUIM_DeleteBubble, bubble);
}

inline ULONG CMUI_Area::DeleteShortHelp (STRPTR help)
{
	return DoMethod (MUIM_DeleteShortHelp, help);
}

inline ULONG CMUI_Area::DragBegin (Object * obj)
{
	return DoMethod (MUIM_DragBegin, obj);
}

inline ULONG CMUI_Area::DragDrop (Object * obj, LONG x, LONG y)
{
	return DoMethod (MUIM_DragDrop, obj, x, y);
}

inline ULONG CMUI_Area::DragFinish (Object * obj)
{
	return DoMethod (MUIM_DragFinish, obj);
}

inline ULONG CMUI_Area::DragQuery (Object * obj)
{
	return DoMethod (MUIM_DragQuery, obj);
}

inline ULONG CMUI_Area::DragReport (Object * obj, LONG x, LONG y, LONG update)
{
	return DoMethod (MUIM_DragReport, obj, x, y, update);
}

inline ULONG CMUI_Area::Draw (ULONG flags)
{
	return DoMethod (MUIM_Draw, flags);
}

inline ULONG CMUI_Area::DrawBackground (LONG left, LONG top, LONG width, LONG height, LONG xoffset, LONG yoffset, LONG flags)
{
	return DoMethod (MUIM_DrawBackground, left, top, width, height, xoffset, yoffset, flags);
}

inline ULONG CMUI_Area::HandleEvent (struct IntuiMessage * imsg, LONG muikey)
{
	return DoMethod (MUIM_HandleEvent, imsg, muikey);
}

inline ULONG CMUI_Area::HandleInput (struct IntuiMessage * imsg, LONG muikey)
{
	return DoMethod (MUIM_HandleInput, imsg, muikey);
}

inline ULONG CMUI_Area::Hide (void)
{
	return DoMethod (MUIM_Hide);
}

inline ULONG CMUI_Area::Setup (struct MUI_RenderInfo * RenderInfo)
{
	return DoMethod (MUIM_Setup, RenderInfo);
}

inline ULONG CMUI_Area::Show (void)
{
	return DoMethod (MUIM_Show);
}

inline STRPTR CMUI_Rectangle::BarTitle (void) const
{
	 return (STRPTR)GetAttr (MUIA_Rectangle_BarTitle);
}

inline BOOL CMUI_Rectangle::HBar (void) const
{
	 return (BOOL)GetAttr (MUIA_Rectangle_HBar);
}

inline BOOL CMUI_Rectangle::VBar (void) const
{
	 return (BOOL)GetAttr (MUIA_Rectangle_VBar);
}

inline void CMUI_Image::SetState (LONG value)
{
	 SetAttr (MUIA_Image_State, (ULONG)value);
}

inline struct BitMap * CMUI_Bitmap::Bitmap (void) const
{
	 return (struct BitMap *)GetAttr (MUIA_Bitmap_Bitmap);
}

inline void CMUI_Bitmap::SetBitmap (struct BitMap * value)
{
	 SetAttr (MUIA_Bitmap_Bitmap, (ULONG)value);
}

inline LONG CMUI_Bitmap::Height (void) const
{
	 return (LONG)GetAttr (MUIA_Bitmap_Height);
}

inline void CMUI_Bitmap::SetHeight (LONG value)
{
	 SetAttr (MUIA_Bitmap_Height, (ULONG)value);
}

inline UBYTE * CMUI_Bitmap::MappingTable (void) const
{
	 return (UBYTE *)GetAttr (MUIA_Bitmap_MappingTable);
}

inline void CMUI_Bitmap::SetMappingTable (UBYTE * value)
{
	 SetAttr (MUIA_Bitmap_MappingTable, (ULONG)value);
}

inline LONG CMUI_Bitmap::Precision (void) const
{
	 return (LONG)GetAttr (MUIA_Bitmap_Precision);
}

inline void CMUI_Bitmap::SetPrecision (LONG value)
{
	 SetAttr (MUIA_Bitmap_Precision, (ULONG)value);
}

inline struct BitMap * CMUI_Bitmap::RemappedBitmap (void) const
{
	 return (struct BitMap *)GetAttr (MUIA_Bitmap_RemappedBitmap);
}

inline ULONG * CMUI_Bitmap::SourceColors (void) const
{
	 return (ULONG *)GetAttr (MUIA_Bitmap_SourceColors);
}

inline void CMUI_Bitmap::SetSourceColors (ULONG * value)
{
	 SetAttr (MUIA_Bitmap_SourceColors, (ULONG)value);
}

inline LONG CMUI_Bitmap::Transparent (void) const
{
	 return (LONG)GetAttr (MUIA_Bitmap_Transparent);
}

inline void CMUI_Bitmap::SetTransparent (LONG value)
{
	 SetAttr (MUIA_Bitmap_Transparent, (ULONG)value);
}

inline LONG CMUI_Bitmap::Width (void) const
{
	 return (LONG)GetAttr (MUIA_Bitmap_Width);
}

inline void CMUI_Bitmap::SetWidth (LONG value)
{
	 SetAttr (MUIA_Bitmap_Width, (ULONG)value);
}

inline UBYTE * CMUI_Bodychunk::Body (void) const
{
	 return (UBYTE *)GetAttr (MUIA_Bodychunk_Body);
}

inline void CMUI_Bodychunk::SetBody (UBYTE * value)
{
	 SetAttr (MUIA_Bodychunk_Body, (ULONG)value);
}

inline UBYTE CMUI_Bodychunk::Compression (void) const
{
	 return (UBYTE)GetAttr (MUIA_Bodychunk_Compression);
}

inline void CMUI_Bodychunk::SetCompression (UBYTE value)
{
	 SetAttr (MUIA_Bodychunk_Compression, (ULONG)value);
}

inline LONG CMUI_Bodychunk::Depth (void) const
{
	 return (LONG)GetAttr (MUIA_Bodychunk_Depth);
}

inline void CMUI_Bodychunk::SetDepth (LONG value)
{
	 SetAttr (MUIA_Bodychunk_Depth, (ULONG)value);
}

inline UBYTE CMUI_Bodychunk::Masking (void) const
{
	 return (UBYTE)GetAttr (MUIA_Bodychunk_Masking);
}

inline void CMUI_Bodychunk::SetMasking (UBYTE value)
{
	 SetAttr (MUIA_Bodychunk_Masking, (ULONG)value);
}

inline STRPTR CMUI_Text::Contents (void) const
{
	 return (STRPTR)GetAttr (MUIA_Text_Contents);
}

inline void CMUI_Text::SetContents (STRPTR value)
{
	 SetAttr (MUIA_Text_Contents, (ULONG)value);
}

inline STRPTR CMUI_Text::PreParse (void) const
{
	 return (STRPTR)GetAttr (MUIA_Text_PreParse);
}

inline void CMUI_Text::SetPreParse (STRPTR value)
{
	 SetAttr (MUIA_Text_PreParse, (ULONG)value);
}

inline struct Gadget * CMUI_Gadget::Gadget (void) const
{
	 return (struct Gadget *)GetAttr (MUIA_Gadget_Gadget);
}

inline STRPTR CMUI_String::Accept (void) const
{
	 return (STRPTR)GetAttr (MUIA_String_Accept);
}

inline void CMUI_String::SetAccept (STRPTR value)
{
	 SetAttr (MUIA_String_Accept, (ULONG)value);
}

inline STRPTR CMUI_String::Acknowledge (void) const
{
	 return (STRPTR)GetAttr (MUIA_String_Acknowledge);
}

inline BOOL CMUI_String::AdvanceOnCR (void) const
{
	 return (BOOL)GetAttr (MUIA_String_AdvanceOnCR);
}

inline void CMUI_String::SetAdvanceOnCR (BOOL value)
{
	 SetAttr (MUIA_String_AdvanceOnCR, (ULONG)value);
}

inline Object * CMUI_String::AttachedList (void) const
{
	 return (Object *)GetAttr (MUIA_String_AttachedList);
}

inline void CMUI_String::SetAttachedList (Object * value)
{
	 SetAttr (MUIA_String_AttachedList, (ULONG)value);
}

inline LONG CMUI_String::BufferPos (void) const
{
	 return (LONG)GetAttr (MUIA_String_BufferPos);
}

inline void CMUI_String::SetBufferPos (LONG value)
{
	 SetAttr (MUIA_String_BufferPos, (ULONG)value);
}

inline STRPTR CMUI_String::Contents (void) const
{
	 return (STRPTR)GetAttr (MUIA_String_Contents);
}

inline void CMUI_String::SetContents (STRPTR value)
{
	 SetAttr (MUIA_String_Contents, (ULONG)value);
}

inline LONG CMUI_String::DisplayPos (void) const
{
	 return (LONG)GetAttr (MUIA_String_DisplayPos);
}

inline void CMUI_String::SetDisplayPos (LONG value)
{
	 SetAttr (MUIA_String_DisplayPos, (ULONG)value);
}

inline struct Hook * CMUI_String::EditHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_String_EditHook);
}

inline void CMUI_String::SetEditHook (struct Hook * value)
{
	 SetAttr (MUIA_String_EditHook, (ULONG)value);
}

inline LONG CMUI_String::Format (void) const
{
	 return (LONG)GetAttr (MUIA_String_Format);
}

inline ULONG CMUI_String::Integer (void) const
{
	 return (ULONG)GetAttr (MUIA_String_Integer);
}

inline void CMUI_String::SetInteger (ULONG value)
{
	 SetAttr (MUIA_String_Integer, (ULONG)value);
}

inline BOOL CMUI_String::LonelyEditHook (void) const
{
	 return (BOOL)GetAttr (MUIA_String_LonelyEditHook);
}

inline void CMUI_String::SetLonelyEditHook (BOOL value)
{
	 SetAttr (MUIA_String_LonelyEditHook, (ULONG)value);
}

inline LONG CMUI_String::MaxLen (void) const
{
	 return (LONG)GetAttr (MUIA_String_MaxLen);
}

inline STRPTR CMUI_String::Reject (void) const
{
	 return (STRPTR)GetAttr (MUIA_String_Reject);
}

inline void CMUI_String::SetReject (STRPTR value)
{
	 SetAttr (MUIA_String_Reject, (ULONG)value);
}

inline BOOL CMUI_String::Secret (void) const
{
	 return (BOOL)GetAttr (MUIA_String_Secret);
}

inline struct IClass * CMUI_Boopsi::Class (void) const
{
	 return (struct IClass *)GetAttr (MUIA_Boopsi_Class);
}

inline void CMUI_Boopsi::SetClass (struct IClass * value)
{
	 SetAttr (MUIA_Boopsi_Class, (ULONG)value);
}

inline char * CMUI_Boopsi::ClassID (void) const
{
	 return (char *)GetAttr (MUIA_Boopsi_ClassID);
}

inline void CMUI_Boopsi::SetClassID (char * value)
{
	 SetAttr (MUIA_Boopsi_ClassID, (ULONG)value);
}

inline ULONG CMUI_Boopsi::MaxHeight (void) const
{
	 return (ULONG)GetAttr (MUIA_Boopsi_MaxHeight);
}

inline void CMUI_Boopsi::SetMaxHeight (ULONG value)
{
	 SetAttr (MUIA_Boopsi_MaxHeight, (ULONG)value);
}

inline ULONG CMUI_Boopsi::MaxWidth (void) const
{
	 return (ULONG)GetAttr (MUIA_Boopsi_MaxWidth);
}

inline void CMUI_Boopsi::SetMaxWidth (ULONG value)
{
	 SetAttr (MUIA_Boopsi_MaxWidth, (ULONG)value);
}

inline ULONG CMUI_Boopsi::MinHeight (void) const
{
	 return (ULONG)GetAttr (MUIA_Boopsi_MinHeight);
}

inline void CMUI_Boopsi::SetMinHeight (ULONG value)
{
	 SetAttr (MUIA_Boopsi_MinHeight, (ULONG)value);
}

inline ULONG CMUI_Boopsi::MinWidth (void) const
{
	 return (ULONG)GetAttr (MUIA_Boopsi_MinWidth);
}

inline void CMUI_Boopsi::SetMinWidth (ULONG value)
{
	 SetAttr (MUIA_Boopsi_MinWidth, (ULONG)value);
}

inline Object * CMUI_Boopsi::BoopsiObject (void) const
{
	 return (Object *)GetAttr (MUIA_Boopsi_Object);
}

inline ULONG CMUI_Boopsi::TagDrawInfo (void) const
{
	 return (ULONG)GetAttr (MUIA_Boopsi_TagDrawInfo);
}

inline void CMUI_Boopsi::SetTagDrawInfo (ULONG value)
{
	 SetAttr (MUIA_Boopsi_TagDrawInfo, (ULONG)value);
}

inline ULONG CMUI_Boopsi::TagScreen (void) const
{
	 return (ULONG)GetAttr (MUIA_Boopsi_TagScreen);
}

inline void CMUI_Boopsi::SetTagScreen (ULONG value)
{
	 SetAttr (MUIA_Boopsi_TagScreen, (ULONG)value);
}

inline ULONG CMUI_Boopsi::TagWindow (void) const
{
	 return (ULONG)GetAttr (MUIA_Boopsi_TagWindow);
}

inline void CMUI_Boopsi::SetTagWindow (ULONG value)
{
	 SetAttr (MUIA_Boopsi_TagWindow, (ULONG)value);
}

inline LONG CMUI_Prop::Entries (void) const
{
	 return (LONG)GetAttr (MUIA_Prop_Entries);
}

inline void CMUI_Prop::SetEntries (LONG value)
{
	 SetAttr (MUIA_Prop_Entries, (ULONG)value);
}

inline LONG CMUI_Prop::First (void) const
{
	 return (LONG)GetAttr (MUIA_Prop_First);
}

inline void CMUI_Prop::SetFirst (LONG value)
{
	 SetAttr (MUIA_Prop_First, (ULONG)value);
}

inline BOOL CMUI_Prop::Horiz (void) const
{
	 return (BOOL)GetAttr (MUIA_Prop_Horiz);
}

inline BOOL CMUI_Prop::Slider (void) const
{
	 return (BOOL)GetAttr (MUIA_Prop_Slider);
}

inline void CMUI_Prop::SetSlider (BOOL value)
{
	 SetAttr (MUIA_Prop_Slider, (ULONG)value);
}

inline LONG CMUI_Prop::Visible (void) const
{
	 return (LONG)GetAttr (MUIA_Prop_Visible);
}

inline void CMUI_Prop::SetVisible (LONG value)
{
	 SetAttr (MUIA_Prop_Visible, (ULONG)value);
}

inline ULONG CMUI_Prop::Decrease (LONG amount)
{
	return DoMethod (MUIM_Prop_Decrease, amount);
}

inline ULONG CMUI_Prop::Increase (LONG amount)
{
	return DoMethod (MUIM_Prop_Increase, amount);
}

inline LONG CMUI_Gauge::Current (void) const
{
	 return (LONG)GetAttr (MUIA_Gauge_Current);
}

inline void CMUI_Gauge::SetCurrent (LONG value)
{
	 SetAttr (MUIA_Gauge_Current, (ULONG)value);
}

inline BOOL CMUI_Gauge::Divide (void) const
{
	 return (BOOL)GetAttr (MUIA_Gauge_Divide);
}

inline void CMUI_Gauge::SetDivide (BOOL value)
{
	 SetAttr (MUIA_Gauge_Divide, (ULONG)value);
}

inline STRPTR CMUI_Gauge::InfoText (void) const
{
	 return (STRPTR)GetAttr (MUIA_Gauge_InfoText);
}

inline void CMUI_Gauge::SetInfoText (STRPTR value)
{
	 SetAttr (MUIA_Gauge_InfoText, (ULONG)value);
}

inline LONG CMUI_Gauge::Max (void) const
{
	 return (LONG)GetAttr (MUIA_Gauge_Max);
}

inline void CMUI_Gauge::SetMax (LONG value)
{
	 SetAttr (MUIA_Gauge_Max, (ULONG)value);
}

inline BOOL CMUI_Scale::Horiz (void) const
{
	 return (BOOL)GetAttr (MUIA_Scale_Horiz);
}

inline void CMUI_Scale::SetHoriz (BOOL value)
{
	 SetAttr (MUIA_Scale_Horiz, (ULONG)value);
}

inline ULONG CMUI_Colorfield::Blue (void) const
{
	 return (ULONG)GetAttr (MUIA_Colorfield_Blue);
}

inline void CMUI_Colorfield::SetBlue (ULONG value)
{
	 SetAttr (MUIA_Colorfield_Blue, (ULONG)value);
}

inline ULONG CMUI_Colorfield::Green (void) const
{
	 return (ULONG)GetAttr (MUIA_Colorfield_Green);
}

inline void CMUI_Colorfield::SetGreen (ULONG value)
{
	 SetAttr (MUIA_Colorfield_Green, (ULONG)value);
}

inline ULONG CMUI_Colorfield::Pen (void) const
{
	 return (ULONG)GetAttr (MUIA_Colorfield_Pen);
}

inline ULONG CMUI_Colorfield::Red (void) const
{
	 return (ULONG)GetAttr (MUIA_Colorfield_Red);
}

inline void CMUI_Colorfield::SetRed (ULONG value)
{
	 SetAttr (MUIA_Colorfield_Red, (ULONG)value);
}

inline ULONG * CMUI_Colorfield::RGB (void) const
{
	 return (ULONG *)GetAttr (MUIA_Colorfield_RGB);
}

inline void CMUI_Colorfield::SetRGB (ULONG * value)
{
	 SetAttr (MUIA_Colorfield_RGB, (ULONG)value);
}

inline LONG CMUI_List::Active (void) const
{
	 return (LONG)GetAttr (MUIA_List_Active);
}

inline void CMUI_List::SetActive (LONG value)
{
	 SetAttr (MUIA_List_Active, (ULONG)value);
}

inline BOOL CMUI_List::AutoVisible (void) const
{
	 return (BOOL)GetAttr (MUIA_List_AutoVisible);
}

inline void CMUI_List::SetAutoVisible (BOOL value)
{
	 SetAttr (MUIA_List_AutoVisible, (ULONG)value);
}

inline void CMUI_List::SetCompareHook (struct Hook * value)
{
	 SetAttr (MUIA_List_CompareHook, (ULONG)value);
}

inline void CMUI_List::SetConstructHook (struct Hook * value)
{
	 SetAttr (MUIA_List_ConstructHook, (ULONG)value);
}

inline void CMUI_List::SetDestructHook (struct Hook * value)
{
	 SetAttr (MUIA_List_DestructHook, (ULONG)value);
}

inline void CMUI_List::SetDisplayHook (struct Hook * value)
{
	 SetAttr (MUIA_List_DisplayHook, (ULONG)value);
}

inline BOOL CMUI_List::DragSortable (void) const
{
	 return (BOOL)GetAttr (MUIA_List_DragSortable);
}

inline void CMUI_List::SetDragSortable (BOOL value)
{
	 SetAttr (MUIA_List_DragSortable, (ULONG)value);
}

inline LONG CMUI_List::DropMark (void) const
{
	 return (LONG)GetAttr (MUIA_List_DropMark);
}

inline LONG CMUI_List::Entries (void) const
{
	 return (LONG)GetAttr (MUIA_List_Entries);
}

inline LONG CMUI_List::First (void) const
{
	 return (LONG)GetAttr (MUIA_List_First);
}

inline STRPTR CMUI_List::Format (void) const
{
	 return (STRPTR)GetAttr (MUIA_List_Format);
}

inline void CMUI_List::SetFormat (STRPTR value)
{
	 SetAttr (MUIA_List_Format, (ULONG)value);
}

inline LONG CMUI_List::InsertPosition (void) const
{
	 return (LONG)GetAttr (MUIA_List_InsertPosition);
}

inline void CMUI_List::SetMultiTestHook (struct Hook * value)
{
	 SetAttr (MUIA_List_MultiTestHook, (ULONG)value);
}

inline void CMUI_List::SetQuiet (BOOL value)
{
	 SetAttr (MUIA_List_Quiet, (ULONG)value);
}

inline BOOL CMUI_List::ShowDropMarks (void) const
{
	 return (BOOL)GetAttr (MUIA_List_ShowDropMarks);
}

inline void CMUI_List::SetShowDropMarks (BOOL value)
{
	 SetAttr (MUIA_List_ShowDropMarks, (ULONG)value);
}

inline char * CMUI_List::Title (void) const
{
	 return (char *)GetAttr (MUIA_List_Title);
}

inline void CMUI_List::SetTitle (char * value)
{
	 SetAttr (MUIA_List_Title, (ULONG)value);
}

inline LONG CMUI_List::Visible (void) const
{
	 return (LONG)GetAttr (MUIA_List_Visible);
}

inline ULONG CMUI_List::Clear (void)
{
	return DoMethod (MUIM_List_Clear);
}

inline ULONG CMUI_List::CreateImage (Object * obj, ULONG flags)
{
	return DoMethod (MUIM_List_CreateImage, obj, flags);
}

inline ULONG CMUI_List::DeleteImage (APTR listimg)
{
	return DoMethod (MUIM_List_DeleteImage, listimg);
}

inline ULONG CMUI_List::Exchange (LONG pos1, LONG pos2)
{
	return DoMethod (MUIM_List_Exchange, pos1, pos2);
}

inline ULONG CMUI_List::GetEntry (LONG pos, APTR * entry)
{
	return DoMethod (MUIM_List_GetEntry, pos, entry);
}

inline ULONG CMUI_List::Insert (APTR * entries, LONG count, LONG pos)
{
	return DoMethod (MUIM_List_Insert, entries, count, pos);
}

inline ULONG CMUI_List::InsertSingle (APTR entry, LONG pos)
{
	return DoMethod (MUIM_List_InsertSingle, entry, pos);
}

inline ULONG CMUI_List::Jump (LONG pos)
{
	return DoMethod (MUIM_List_Jump, pos);
}

inline ULONG CMUI_List::Move (LONG from, LONG to)
{
	return DoMethod (MUIM_List_Move, from, to);
}

inline ULONG CMUI_List::NextSelected (LONG * pos)
{
	return DoMethod (MUIM_List_NextSelected, pos);
}

inline ULONG CMUI_List::Redraw (LONG pos)
{
	return DoMethod (MUIM_List_Redraw, pos);
}

inline ULONG CMUI_List::Remove (LONG pos)
{
	return DoMethod (MUIM_List_Remove, pos);
}

inline ULONG CMUI_List::Select (LONG pos, LONG seltype, LONG * state)
{
	return DoMethod (MUIM_List_Select, pos, seltype, state);
}

inline ULONG CMUI_List::Sort (void)
{
	return DoMethod (MUIM_List_Sort);
}

inline ULONG CMUI_List::TestPos (LONG x, LONG y, struct MUI_List_TestPos_Result * res)
{
	return DoMethod (MUIM_List_TestPos, x, y, res);
}

inline BOOL CMUI_Floattext::Justify (void) const
{
	 return (BOOL)GetAttr (MUIA_Floattext_Justify);
}

inline void CMUI_Floattext::SetJustify (BOOL value)
{
	 SetAttr (MUIA_Floattext_Justify, (ULONG)value);
}

inline void CMUI_Floattext::SetSkipChars (STRPTR value)
{
	 SetAttr (MUIA_Floattext_SkipChars, (ULONG)value);
}

inline void CMUI_Floattext::SetTabSize (LONG value)
{
	 SetAttr (MUIA_Floattext_TabSize, (ULONG)value);
}

inline STRPTR CMUI_Floattext::Text (void) const
{
	 return (STRPTR)GetAttr (MUIA_Floattext_Text);
}

inline void CMUI_Floattext::SetText (STRPTR value)
{
	 SetAttr (MUIA_Floattext_Text, (ULONG)value);
}

inline void CMUI_Dirlist::SetAcceptPattern (STRPTR value)
{
	 SetAttr (MUIA_Dirlist_AcceptPattern, (ULONG)value);
}

inline STRPTR CMUI_Dirlist::Directory (void) const
{
	 return (STRPTR)GetAttr (MUIA_Dirlist_Directory);
}

inline void CMUI_Dirlist::SetDirectory (STRPTR value)
{
	 SetAttr (MUIA_Dirlist_Directory, (ULONG)value);
}

inline void CMUI_Dirlist::SetDrawersOnly (BOOL value)
{
	 SetAttr (MUIA_Dirlist_DrawersOnly, (ULONG)value);
}

inline void CMUI_Dirlist::SetFilesOnly (BOOL value)
{
	 SetAttr (MUIA_Dirlist_FilesOnly, (ULONG)value);
}

inline void CMUI_Dirlist::SetFilterDrawers (BOOL value)
{
	 SetAttr (MUIA_Dirlist_FilterDrawers, (ULONG)value);
}

inline void CMUI_Dirlist::SetFilterHook (struct Hook * value)
{
	 SetAttr (MUIA_Dirlist_FilterHook, (ULONG)value);
}

inline void CMUI_Dirlist::SetMultiSelDirs (BOOL value)
{
	 SetAttr (MUIA_Dirlist_MultiSelDirs, (ULONG)value);
}

inline LONG CMUI_Dirlist::NumBytes (void) const
{
	 return (LONG)GetAttr (MUIA_Dirlist_NumBytes);
}

inline LONG CMUI_Dirlist::NumDrawers (void) const
{
	 return (LONG)GetAttr (MUIA_Dirlist_NumDrawers);
}

inline LONG CMUI_Dirlist::NumFiles (void) const
{
	 return (LONG)GetAttr (MUIA_Dirlist_NumFiles);
}

inline STRPTR CMUI_Dirlist::Path (void) const
{
	 return (STRPTR)GetAttr (MUIA_Dirlist_Path);
}

inline void CMUI_Dirlist::SetRejectIcons (BOOL value)
{
	 SetAttr (MUIA_Dirlist_RejectIcons, (ULONG)value);
}

inline void CMUI_Dirlist::SetRejectPattern (STRPTR value)
{
	 SetAttr (MUIA_Dirlist_RejectPattern, (ULONG)value);
}

inline void CMUI_Dirlist::SetSortDirs (LONG value)
{
	 SetAttr (MUIA_Dirlist_SortDirs, (ULONG)value);
}

inline void CMUI_Dirlist::SetSortHighLow (BOOL value)
{
	 SetAttr (MUIA_Dirlist_SortHighLow, (ULONG)value);
}

inline void CMUI_Dirlist::SetSortType (LONG value)
{
	 SetAttr (MUIA_Dirlist_SortType, (ULONG)value);
}

inline LONG CMUI_Dirlist::Status (void) const
{
	 return (LONG)GetAttr (MUIA_Dirlist_Status);
}

inline ULONG CMUI_Dirlist::ReRead (void)
{
	return DoMethod (MUIM_Dirlist_ReRead);
}

inline BOOL CMUI_Numeric::CheckAllSizes (void) const
{
	 return (BOOL)GetAttr (MUIA_Numeric_CheckAllSizes);
}

inline void CMUI_Numeric::SetCheckAllSizes (BOOL value)
{
	 SetAttr (MUIA_Numeric_CheckAllSizes, (ULONG)value);
}

inline LONG CMUI_Numeric::Default (void) const
{
	 return (LONG)GetAttr (MUIA_Numeric_Default);
}

inline void CMUI_Numeric::SetDefault (LONG value)
{
	 SetAttr (MUIA_Numeric_Default, (ULONG)value);
}

inline STRPTR CMUI_Numeric::Format (void) const
{
	 return (STRPTR)GetAttr (MUIA_Numeric_Format);
}

inline void CMUI_Numeric::SetFormat (STRPTR value)
{
	 SetAttr (MUIA_Numeric_Format, (ULONG)value);
}

inline LONG CMUI_Numeric::Max (void) const
{
	 return (LONG)GetAttr (MUIA_Numeric_Max);
}

inline void CMUI_Numeric::SetMax (LONG value)
{
	 SetAttr (MUIA_Numeric_Max, (ULONG)value);
}

inline LONG CMUI_Numeric::Min (void) const
{
	 return (LONG)GetAttr (MUIA_Numeric_Min);
}

inline void CMUI_Numeric::SetMin (LONG value)
{
	 SetAttr (MUIA_Numeric_Min, (ULONG)value);
}

inline BOOL CMUI_Numeric::Reverse (void) const
{
	 return (BOOL)GetAttr (MUIA_Numeric_Reverse);
}

inline void CMUI_Numeric::SetReverse (BOOL value)
{
	 SetAttr (MUIA_Numeric_Reverse, (ULONG)value);
}

inline BOOL CMUI_Numeric::RevLeftRight (void) const
{
	 return (BOOL)GetAttr (MUIA_Numeric_RevLeftRight);
}

inline void CMUI_Numeric::SetRevLeftRight (BOOL value)
{
	 SetAttr (MUIA_Numeric_RevLeftRight, (ULONG)value);
}

inline BOOL CMUI_Numeric::RevUpDown (void) const
{
	 return (BOOL)GetAttr (MUIA_Numeric_RevUpDown);
}

inline void CMUI_Numeric::SetRevUpDown (BOOL value)
{
	 SetAttr (MUIA_Numeric_RevUpDown, (ULONG)value);
}

inline LONG CMUI_Numeric::Value (void) const
{
	 return (LONG)GetAttr (MUIA_Numeric_Value);
}

inline void CMUI_Numeric::SetValue (LONG value)
{
	 SetAttr (MUIA_Numeric_Value, (ULONG)value);
}

inline ULONG CMUI_Numeric::Decrease (LONG amount)
{
	return DoMethod (MUIM_Numeric_Decrease, amount);
}

inline ULONG CMUI_Numeric::Increase (LONG amount)
{
	return DoMethod (MUIM_Numeric_Increase, amount);
}

inline ULONG CMUI_Numeric::ScaleToValue (LONG scalemin, LONG scalemax, LONG scale)
{
	return DoMethod (MUIM_Numeric_ScaleToValue, scalemin, scalemax, scale);
}

inline ULONG CMUI_Numeric::SetDefault (void)
{
	return DoMethod (MUIM_Numeric_SetDefault);
}

inline ULONG CMUI_Numeric::Stringify (LONG value)
{
	return DoMethod (MUIM_Numeric_Stringify, value);
}

inline ULONG CMUI_Numeric::ValueToScale (LONG scalemin, LONG scalemax)
{
	return DoMethod (MUIM_Numeric_ValueToScale, scalemin, scalemax);
}

inline STRPTR CMUI_Levelmeter::Label (void) const
{
	 return (STRPTR)GetAttr (MUIA_Levelmeter_Label);
}

inline void CMUI_Levelmeter::SetLabel (STRPTR value)
{
	 SetAttr (MUIA_Levelmeter_Label, (ULONG)value);
}

inline BOOL CMUI_Slider::Horiz (void) const
{
	 return (BOOL)GetAttr (MUIA_Slider_Horiz);
}

inline void CMUI_Slider::SetHoriz (BOOL value)
{
	 SetAttr (MUIA_Slider_Horiz, (ULONG)value);
}

inline Object * CMUI_Pendisplay::Pen (void) const
{
	 return (Object *)GetAttr (MUIA_Pendisplay_Pen);
}

inline Object * CMUI_Pendisplay::Reference (void) const
{
	 return (Object *)GetAttr (MUIA_Pendisplay_Reference);
}

inline void CMUI_Pendisplay::SetReference (Object * value)
{
	 SetAttr (MUIA_Pendisplay_Reference, (ULONG)value);
}

inline struct MUI_RGBcolor * CMUI_Pendisplay::RGBcolor (void) const
{
	 return (struct MUI_RGBcolor *)GetAttr (MUIA_Pendisplay_RGBcolor);
}

inline void CMUI_Pendisplay::SetRGBcolor (struct MUI_RGBcolor * value)
{
	 SetAttr (MUIA_Pendisplay_RGBcolor, (ULONG)value);
}

inline struct MUI_PenSpec  * CMUI_Pendisplay::Spec (void) const
{
	 return (struct MUI_PenSpec  *)GetAttr (MUIA_Pendisplay_Spec);
}

inline void CMUI_Pendisplay::SetSpec (struct MUI_PenSpec  * value)
{
	 SetAttr (MUIA_Pendisplay_Spec, (ULONG)value);
}

inline ULONG CMUI_Pendisplay::SetColormap (LONG colormap)
{
	return DoMethod (MUIM_Pendisplay_SetColormap, colormap);
}

inline ULONG CMUI_Pendisplay::SetMUIPen (LONG muipen)
{
	return DoMethod (MUIM_Pendisplay_SetMUIPen, muipen);
}

inline ULONG CMUI_Pendisplay::SetRGB (ULONG red, ULONG green, ULONG blue)
{
	return DoMethod (MUIM_Pendisplay_SetRGB, red, green, blue);
}

inline LONG CMUI_Group::ActivePage (void) const
{
	 return (LONG)GetAttr (MUIA_Group_ActivePage);
}

inline void CMUI_Group::SetActivePage (LONG value)
{
	 SetAttr (MUIA_Group_ActivePage, (ULONG)value);
}

inline struct List * CMUI_Group::ChildList (void) const
{
	 return (struct List *)GetAttr (MUIA_Group_ChildList);
}

inline void CMUI_Group::SetColumns (LONG value)
{
	 SetAttr (MUIA_Group_Columns, (ULONG)value);
}

inline LONG CMUI_Group::HorizSpacing (void) const
{
	 return (LONG)GetAttr (MUIA_Group_HorizSpacing);
}

inline void CMUI_Group::SetHorizSpacing (LONG value)
{
	 SetAttr (MUIA_Group_HorizSpacing, (ULONG)value);
}

inline void CMUI_Group::SetRows (LONG value)
{
	 SetAttr (MUIA_Group_Rows, (ULONG)value);
}

inline void CMUI_Group::SetSpacing (LONG value)
{
	 SetAttr (MUIA_Group_Spacing, (ULONG)value);
}

inline LONG CMUI_Group::VertSpacing (void) const
{
	 return (LONG)GetAttr (MUIA_Group_VertSpacing);
}

inline void CMUI_Group::SetVertSpacing (LONG value)
{
	 SetAttr (MUIA_Group_VertSpacing, (ULONG)value);
}

inline ULONG CMUI_Group::ExitChange (void)
{
	return DoMethod (MUIM_Group_ExitChange);
}

inline ULONG CMUI_Group::InitChange (void)
{
	return DoMethod (MUIM_Group_InitChange);
}

inline ULONG CMUI_Group::Sort (StartVarArgs sva, Object * obj, ...)
{
	sva.methodID = MUIM_Group_Sort;
	return DoMethodA ((Msg)&sva);
}

inline BOOL CMUI_Register::Frame (void) const
{
	 return (BOOL)GetAttr (MUIA_Register_Frame);
}

inline STRPTR * CMUI_Register::Titles (void) const
{
	 return (STRPTR *)GetAttr (MUIA_Register_Titles);
}

inline ULONG CMUI_Settingsgroup::ConfigToGadgets (Object * configdata)
{
	return DoMethod (MUIM_Settingsgroup_ConfigToGadgets, configdata);
}

inline ULONG CMUI_Settingsgroup::GadgetsToConfig (Object * configdata)
{
	return DoMethod (MUIM_Settingsgroup_GadgetsToConfig, configdata);
}

inline LONG CMUI_Virtgroup::Height (void) const
{
	 return (LONG)GetAttr (MUIA_Virtgroup_Height);
}

inline LONG CMUI_Virtgroup::Left (void) const
{
	 return (LONG)GetAttr (MUIA_Virtgroup_Left);
}

inline void CMUI_Virtgroup::SetLeft (LONG value)
{
	 SetAttr (MUIA_Virtgroup_Left, (ULONG)value);
}

inline LONG CMUI_Virtgroup::Top (void) const
{
	 return (LONG)GetAttr (MUIA_Virtgroup_Top);
}

inline void CMUI_Virtgroup::SetTop (LONG value)
{
	 SetAttr (MUIA_Virtgroup_Top, (ULONG)value);
}

inline LONG CMUI_Virtgroup::Width (void) const
{
	 return (LONG)GetAttr (MUIA_Virtgroup_Width);
}

inline Object * CMUI_Scrollgroup::Contents (void) const
{
	 return (Object *)GetAttr (MUIA_Scrollgroup_Contents);
}

inline Object * CMUI_Scrollgroup::HorizBar (void) const
{
	 return (Object *)GetAttr (MUIA_Scrollgroup_HorizBar);
}

inline Object * CMUI_Scrollgroup::VertBar (void) const
{
	 return (Object *)GetAttr (MUIA_Scrollgroup_VertBar);
}

inline LONG CMUI_Listview::ActivePage (void) const
{
	 return (LONG)GetAttr (MUIA_Group_ActivePage);
}

inline void CMUI_Listview::SetActivePage (LONG value)
{
	 SetAttr (MUIA_Group_ActivePage, (ULONG)value);
}

inline struct List * CMUI_Listview::ChildList (void) const
{
	 return (struct List *)GetAttr (MUIA_Group_ChildList);
}

inline void CMUI_Listview::SetColumns (LONG value)
{
	 SetAttr (MUIA_Group_Columns, (ULONG)value);
}

inline LONG CMUI_Listview::HorizSpacing (void) const
{
	 return (LONG)GetAttr (MUIA_Group_HorizSpacing);
}

inline void CMUI_Listview::SetHorizSpacing (LONG value)
{
	 SetAttr (MUIA_Group_HorizSpacing, (ULONG)value);
}

inline void CMUI_Listview::SetRows (LONG value)
{
	 SetAttr (MUIA_Group_Rows, (ULONG)value);
}

inline void CMUI_Listview::SetSpacing (LONG value)
{
	 SetAttr (MUIA_Group_Spacing, (ULONG)value);
}

inline LONG CMUI_Listview::VertSpacing (void) const
{
	 return (LONG)GetAttr (MUIA_Group_VertSpacing);
}

inline void CMUI_Listview::SetVertSpacing (LONG value)
{
	 SetAttr (MUIA_Group_VertSpacing, (ULONG)value);
}

inline ULONG CMUI_Listview::ExitChange (void)
{
	return DoMethod (MUIM_Group_ExitChange);
}

inline ULONG CMUI_Listview::InitChange (void)
{
	return DoMethod (MUIM_Group_InitChange);
}

inline ULONG CMUI_Listview::Sort (StartVarArgs sva, Object * obj, ...)
{
	sva.methodID = MUIM_Group_Sort;
	return DoMethodA ((Msg)&sva);
}

inline LONG CMUI_Listview::ClickColumn (void) const
{
	 return (LONG)GetAttr (MUIA_Listview_ClickColumn);
}

inline LONG CMUI_Listview::DefClickColumn (void) const
{
	 return (LONG)GetAttr (MUIA_Listview_DefClickColumn);
}

inline void CMUI_Listview::SetDefClickColumn (LONG value)
{
	 SetAttr (MUIA_Listview_DefClickColumn, (ULONG)value);
}

inline BOOL CMUI_Listview::DoubleClick (void) const
{
	 return (BOOL)GetAttr (MUIA_Listview_DoubleClick);
}

inline LONG CMUI_Listview::DragType (void) const
{
	 return (LONG)GetAttr (MUIA_Listview_DragType);
}

inline void CMUI_Listview::SetDragType (LONG value)
{
	 SetAttr (MUIA_Listview_DragType, (ULONG)value);
}

inline Object * CMUI_Listview::List (void) const
{
	 return (Object *)GetAttr (MUIA_Listview_List);
}

inline BOOL CMUI_Listview::SelectChange (void) const
{
	 return (BOOL)GetAttr (MUIA_Listview_SelectChange);
}

inline LONG CMUI_Radio::Active (void) const
{
	 return (LONG)GetAttr (MUIA_Radio_Active);
}

inline void CMUI_Radio::SetActive (LONG value)
{
	 SetAttr (MUIA_Radio_Active, (ULONG)value);
}

inline LONG CMUI_Cycle::Active (void) const
{
	 return (LONG)GetAttr (MUIA_Cycle_Active);
}

inline void CMUI_Cycle::SetActive (LONG value)
{
	 SetAttr (MUIA_Cycle_Active, (ULONG)value);
}

inline ULONG CMUI_Coloradjust::Blue (void) const
{
	 return (ULONG)GetAttr (MUIA_Coloradjust_Blue);
}

inline void CMUI_Coloradjust::SetBlue (ULONG value)
{
	 SetAttr (MUIA_Coloradjust_Blue, (ULONG)value);
}

inline ULONG CMUI_Coloradjust::Green (void) const
{
	 return (ULONG)GetAttr (MUIA_Coloradjust_Green);
}

inline void CMUI_Coloradjust::SetGreen (ULONG value)
{
	 SetAttr (MUIA_Coloradjust_Green, (ULONG)value);
}

inline ULONG CMUI_Coloradjust::ModeID (void) const
{
	 return (ULONG)GetAttr (MUIA_Coloradjust_ModeID);
}

inline void CMUI_Coloradjust::SetModeID (ULONG value)
{
	 SetAttr (MUIA_Coloradjust_ModeID, (ULONG)value);
}

inline ULONG CMUI_Coloradjust::Red (void) const
{
	 return (ULONG)GetAttr (MUIA_Coloradjust_Red);
}

inline void CMUI_Coloradjust::SetRed (ULONG value)
{
	 SetAttr (MUIA_Coloradjust_Red, (ULONG)value);
}

inline ULONG * CMUI_Coloradjust::RGB (void) const
{
	 return (ULONG *)GetAttr (MUIA_Coloradjust_RGB);
}

inline void CMUI_Coloradjust::SetRGB (ULONG * value)
{
	 SetAttr (MUIA_Coloradjust_RGB, (ULONG)value);
}

inline struct MUI_Palette_Entry * CMUI_Palette::Entries (void) const
{
	 return (struct MUI_Palette_Entry *)GetAttr (MUIA_Palette_Entries);
}

inline BOOL CMUI_Palette::Groupable (void) const
{
	 return (BOOL)GetAttr (MUIA_Palette_Groupable);
}

inline void CMUI_Palette::SetGroupable (BOOL value)
{
	 SetAttr (MUIA_Palette_Groupable, (ULONG)value);
}

inline char ** CMUI_Palette::Names (void) const
{
	 return (char **)GetAttr (MUIA_Palette_Names);
}

inline void CMUI_Palette::SetNames (char ** value)
{
	 SetAttr (MUIA_Palette_Names, (ULONG)value);
}

inline Object * CMUI_Popstring::Button (void) const
{
	 return (Object *)GetAttr (MUIA_Popstring_Button);
}

inline struct Hook * CMUI_Popstring::CloseHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Popstring_CloseHook);
}

inline void CMUI_Popstring::SetCloseHook (struct Hook * value)
{
	 SetAttr (MUIA_Popstring_CloseHook, (ULONG)value);
}

inline struct Hook * CMUI_Popstring::OpenHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Popstring_OpenHook);
}

inline void CMUI_Popstring::SetOpenHook (struct Hook * value)
{
	 SetAttr (MUIA_Popstring_OpenHook, (ULONG)value);
}

inline Object * CMUI_Popstring::String (void) const
{
	 return (Object *)GetAttr (MUIA_Popstring_String);
}

inline BOOL CMUI_Popstring::Toggle (void) const
{
	 return (BOOL)GetAttr (MUIA_Popstring_Toggle);
}

inline void CMUI_Popstring::SetToggle (BOOL value)
{
	 SetAttr (MUIA_Popstring_Toggle, (ULONG)value);
}

inline ULONG CMUI_Popstring::Close (LONG result)
{
	return DoMethod (MUIM_Popstring_Close, result);
}

inline ULONG CMUI_Popstring::Open (void)
{
	return DoMethod (MUIM_Popstring_Open);
}

inline BOOL CMUI_Popobject::Follow (void) const
{
	 return (BOOL)GetAttr (MUIA_Popobject_Follow);
}

inline void CMUI_Popobject::SetFollow (BOOL value)
{
	 SetAttr (MUIA_Popobject_Follow, (ULONG)value);
}

inline BOOL CMUI_Popobject::Light (void) const
{
	 return (BOOL)GetAttr (MUIA_Popobject_Light);
}

inline void CMUI_Popobject::SetLight (BOOL value)
{
	 SetAttr (MUIA_Popobject_Light, (ULONG)value);
}

inline Object * CMUI_Popobject::PopObject (void) const
{
	 return (Object *)GetAttr (MUIA_Popobject_Object);
}

inline struct Hook * CMUI_Popobject::ObjStrHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Popobject_ObjStrHook);
}

inline void CMUI_Popobject::SetObjStrHook (struct Hook * value)
{
	 SetAttr (MUIA_Popobject_ObjStrHook, (ULONG)value);
}

inline struct Hook * CMUI_Popobject::StrObjHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Popobject_StrObjHook);
}

inline void CMUI_Popobject::SetStrObjHook (struct Hook * value)
{
	 SetAttr (MUIA_Popobject_StrObjHook, (ULONG)value);
}

inline BOOL CMUI_Popobject::Volatile (void) const
{
	 return (BOOL)GetAttr (MUIA_Popobject_Volatile);
}

inline void CMUI_Popobject::SetVolatile (BOOL value)
{
	 SetAttr (MUIA_Popobject_Volatile, (ULONG)value);
}

inline struct Hook * CMUI_Popobject::WindowHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Popobject_WindowHook);
}

inline void CMUI_Popobject::SetWindowHook (struct Hook * value)
{
	 SetAttr (MUIA_Popobject_WindowHook, (ULONG)value);
}

inline BOOL CMUI_Popasl::Active (void) const
{
	 return (BOOL)GetAttr (MUIA_Popasl_Active);
}

inline struct Hook * CMUI_Popasl::StartHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Popasl_StartHook);
}

inline void CMUI_Popasl::SetStartHook (struct Hook * value)
{
	 SetAttr (MUIA_Popasl_StartHook, (ULONG)value);
}

inline struct Hook * CMUI_Popasl::StopHook (void) const
{
	 return (struct Hook *)GetAttr (MUIA_Popasl_StopHook);
}

inline void CMUI_Popasl::SetStopHook (struct Hook * value)
{
	 SetAttr (MUIA_Popasl_StopHook, (ULONG)value);
}

inline ULONG CMUI_Popasl::Type (void) const
{
	 return (ULONG)GetAttr (MUIA_Popasl_Type);
}

inline ULONG CMUI_Semaphore::Attempt (void)
{
	return DoMethod (MUIM_Semaphore_Attempt);
}

inline ULONG CMUI_Semaphore::AttemptShared (void)
{
	return DoMethod (MUIM_Semaphore_AttemptShared);
}

inline ULONG CMUI_Semaphore::Obtain (void)
{
	return DoMethod (MUIM_Semaphore_Obtain);
}

inline ULONG CMUI_Semaphore::ObtainShared (void)
{
	return DoMethod (MUIM_Semaphore_ObtainShared);
}

inline ULONG CMUI_Semaphore::Release (void)
{
	return DoMethod (MUIM_Semaphore_Release);
}

inline ULONG CMUI_Dataspace::Add (APTR data, LONG len, ULONG id)
{
	return DoMethod (MUIM_Dataspace_Add, data, len, id);
}

inline ULONG CMUI_Dataspace::Clear (void)
{
	return DoMethod (MUIM_Dataspace_Clear);
}

inline ULONG CMUI_Dataspace::Find (ULONG id)
{
	return DoMethod (MUIM_Dataspace_Find, id);
}

inline ULONG CMUI_Dataspace::Merge (Object * dataspace)
{
	return DoMethod (MUIM_Dataspace_Merge, dataspace);
}

inline ULONG CMUI_Dataspace::ReadIFF (struct IFFHandle * handle)
{
	return DoMethod (MUIM_Dataspace_ReadIFF, handle);
}

inline ULONG CMUI_Dataspace::Remove (ULONG id)
{
	return DoMethod (MUIM_Dataspace_Remove, id);
}

inline ULONG CMUI_Dataspace::WriteIFF (struct IFFHandle * handle, ULONG type, ULONG id)
{
	return DoMethod (MUIM_Dataspace_WriteIFF, handle, type, id);
}


#ifdef MUI_OBSOLETE

inline struct NewMenu * CMUI_Application::Menu (void) const
{
	 return (struct NewMenu *)GetAttr (MUIA_Application_Menu);
}

inline ULONG CMUI_Application::GetMenuCheck (ULONG MenuID)
{
	return DoMethod (MUIM_Application_GetMenuCheck, MenuID);
}

inline ULONG CMUI_Application::GetMenuState (ULONG MenuID)
{
	return DoMethod (MUIM_Application_GetMenuState, MenuID);
}

inline ULONG CMUI_Application::Input (LONGBITS * signal)
{
	return DoMethod (MUIM_Application_Input, signal);
}

inline ULONG CMUI_Application::SetMenuCheck (ULONG MenuID, LONG stat)
{
	return DoMethod (MUIM_Application_SetMenuCheck, MenuID, stat);
}

inline ULONG CMUI_Application::SetMenuState (ULONG MenuID, LONG stat)
{
	return DoMethod (MUIM_Application_SetMenuState, MenuID, stat);
}

inline ULONG CMUI_Window::GetMenuCheck (ULONG MenuID)
{
	return DoMethod (MUIM_Window_GetMenuCheck, MenuID);
}

inline ULONG CMUI_Window::GetMenuState (ULONG MenuID)
{
	return DoMethod (MUIM_Window_GetMenuState, MenuID);
}

inline ULONG CMUI_Window::SetCycleChain (StartVarArgs sva, Object * obj, ...)
{
	sva.methodID = MUIM_Window_SetCycleChain;
	return DoMethodA ((Msg)&sva);
}

inline ULONG CMUI_Window::SetMenuCheck (ULONG MenuID, LONG stat)
{
	return DoMethod (MUIM_Window_SetMenuCheck, MenuID, stat);
}

inline ULONG CMUI_Window::SetMenuState (ULONG MenuID, LONG stat)
{
	return DoMethod (MUIM_Window_SetMenuState, MenuID, stat);
}

inline ULONG CMUI_Area::ExportID (void) const
{
	 return (ULONG)GetAttr (MUIA_ExportID);
}

inline void CMUI_Area::SetExportID (ULONG value)
{
	 SetAttr (MUIA_ExportID, (ULONG)value);
}

inline LONG CMUI_Slider::Level (void) const
{
	 return (LONG)GetAttr (MUIA_Slider_Level);
}

inline void CMUI_Slider::SetLevel (LONG value)
{
	 SetAttr (MUIA_Slider_Level, (ULONG)value);
}

inline LONG CMUI_Slider::Max (void) const
{
	 return (LONG)GetAttr (MUIA_Slider_Max);
}

inline void CMUI_Slider::SetMax (LONG value)
{
	 SetAttr (MUIA_Slider_Max, (ULONG)value);
}

inline LONG CMUI_Slider::Min (void) const
{
	 return (LONG)GetAttr (MUIA_Slider_Min);
}

inline void CMUI_Slider::SetMin (LONG value)
{
	 SetAttr (MUIA_Slider_Min, (ULONG)value);
}

inline BOOL CMUI_Slider::Reverse (void) const
{
	 return (BOOL)GetAttr (MUIA_Slider_Reverse);
}

inline void CMUI_Slider::SetReverse (BOOL value)
{
	 SetAttr (MUIA_Slider_Reverse, (ULONG)value);
}



#endif     /* MUI_OBSOLETE*/

#endif     /* MUIPP_NOINLINES */
/***************************************************************************
**                  CMUI_HGroup class definition
***************************************************************************/

class CMUI_HGroup : public CMUI_Group
{
public:

    CMUI_HGroup (void)
    : CMUI_Group ()
    {
        object = NULL;
    }

    CMUI_HGroup (Tag tag1, ...)
    : CMUI_Group (MUIA_Group_Horiz, TRUE,
                  TAG_MORE, (Tag)&tag1)
    {
    }

    CMUI_HGroup (Object * obj)
    : CMUI_Group ()
    {
        object = obj;
    }
};

inline CMUI_String::operator const char * ()
{
    return (const char *)Contents ();
}

inline CMUI_String::operator ULONG ()
{
    return Integer ();
}

inline CMUI_String & CMUI_String::operator = (const char *contents)
{
    SetContents ((STRPTR)contents);
    return *this;
}

inline CMUI_String & CMUI_String::operator = (ULONG contents)
{
    SetInteger (contents);
    return *this;
}

inline CMUI_Text::operator const char * ()
{
    return (const char *)Contents ();
}

inline CMUI_Text & CMUI_Text::operator = (const char *contents)
{
    SetContents ((STRPTR)contents);
    return *this;
}

inline CMUI_Numeric::operator LONG ()
{
    return Value ();
}

inline CMUI_Numeric::operator int ()
{
    return (int)Value ();
}

inline CMUI_Numeric & CMUI_Numeric::operator = (LONG value)
{
    SetValue (value);
    return *this;
}

inline CMUI_Numeric & CMUI_Numeric::operator = (int value)
{
    SetValue ((LONG)value);
    return *this;
}

inline CMUI_Numeric CMUI_Numeric::operator ++ ()            // prefix
{
    Increase (1);
    return *this;
}

inline CMUI_Numeric CMUI_Numeric::operator ++ (int dummy)   // postfix
{
    Increase (1);
    return *this;
}

inline CMUI_Numeric & CMUI_Numeric::operator += (LONG value)
{
    Increase (value);
    return *this;
}

inline CMUI_Numeric CMUI_Numeric::operator -- ()            // prefix
{
    Decrease (1);
    return *this;
}

inline CMUI_Numeric CMUI_Numeric::operator -- (int dummy)   // postfix
{
    Decrease (1);
    return *this;
}

inline CMUI_Numeric & CMUI_Numeric::operator -= (LONG value)
{
    Decrease (value);
    return *this;
}

#ifdef MUIPP_TEMPLATES

/***************************************************************************
**        CTMUI_List : Template version of CMUI_List class definition
***************************************************************************/

template <class Type>
class CTMUI_List : public CMUI_Area
{
public:
    CTMUI_List (void)
    : CMUI_Area ()
    {
        object = NULL;
    }

    CTMUI_List (Tag tag1, ...)
    : CMUI_Area ()
    {
        object = MUI_NewObjectA (MUIC_List, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
        if (object == NULL)
            _MUIPPWarning ("Could not create a CTMUI_List object\n");
#endif
    }

    CTMUI_List (Object * obj)
    : CMUI_Area ()
    {
        object = obj;
    }

    CTMUI_List & operator = (Object * obj)
    {
        object = obj;
        return *this;
    }

    // By overloading the [] operator you can treat lists like arrays

    Type & operator [] (LONG pos)
    {
        Type *entry;
        DoMethod (MUIM_List_GetEntry, pos, &entry);

#ifdef MUIPP_DEBUG
        if (entry == NULL)
            _MUIPPError ("Index into CTMUI_List is out of range:\n"
                         "Index = %ld, List length = %ld\n", pos, (LONG)Entries());
#endif
        return *entry;
    }

    // This method is a convienient alternative to the Entries attribute

    LONG Length (void) const
    {
        return (LONG)GetAttr (MUIA_List_Entries);
    }

    // This method can be used to retrieve the number of selected entries
    // in a list

    ULONG NumSelected (void)
    {
        ULONG numSelected;
        DoMethod (MUIM_List_Select, MUIV_List_Select_All, MUIV_List_Select_Ask, &numSelected);
        return numSelected;
    }

    // These methods can be used as shortcuts for inserting objects into lists

    void InsertTop (Type *entry)
    {
        DoMethod (MUIM_List_InsertSingle, entry, MUIV_List_Insert_Top);
    }

    void InsertTop (Type &entry)
    {
        DoMethod (MUIM_List_InsertSingle, &entry, MUIV_List_Insert_Top);
    }

    void InsertBottom (Type *entry)
    {
        DoMethod (MUIM_List_InsertSingle, entry, MUIV_List_Insert_Bottom);
    }

    void InsertBottom (Type &entry)
    {
        DoMethod (MUIM_List_InsertSingle, &entry, MUIV_List_Insert_Bottom);
    }

    void InsertSorted (Type *entry)
    {
        DoMethod (MUIM_List_InsertSingle, entry, MUIV_List_Insert_Sorted);
    }

    void InsertSorted (Type &entry)
    {
        DoMethod (MUIM_List_InsertSingle, &entry, MUIV_List_Insert_Sorted);
    }

    void InsertActive (Type *entry)
    {
        DoMethod (MUIM_List_InsertSingle, entry, MUIV_List_Insert_Active);
    }

    void InsertActive (Type &entry)
    {
        DoMethod (MUIM_List_InsertSingle, &entry, MUIV_List_Insert_Active);
    }

    void InsertSingle (Type &entry, LONG pos)
    {
        DoMethod (MUIM_List_InsertSingle, &entry, pos);
    }

    LONG Active (void) const
    {
         return (LONG)GetAttr (MUIA_List_Active);
    }

    void SetActive (LONG value)
    {
         SetAttr (MUIA_List_Active, (ULONG)value);
    }

    BOOL AutoVisible (void) const
    {
         return (BOOL)GetAttr (MUIA_List_AutoVisible);
    }

    void SetAutoVisible (BOOL value)
    {
         SetAttr (MUIA_List_AutoVisible, (ULONG)value);
    }

    void SetCompareHook (struct Hook * value)
    {
         SetAttr (MUIA_List_CompareHook, (ULONG)value);
    }

    void SetConstructHook (struct Hook * value)
    {
         SetAttr (MUIA_List_ConstructHook, (ULONG)value);
    }

    void SetDestructHook (struct Hook * value)
    {
         SetAttr (MUIA_List_DestructHook, (ULONG)value);
    }

    void SetDisplayHook (struct Hook * value)
    {
         SetAttr (MUIA_List_DisplayHook, (ULONG)value);
    }

    BOOL DragSortable (void) const
    {
         return (BOOL)GetAttr (MUIA_List_DragSortable);
    }

    void SetDragSortable (BOOL value)
    {
         SetAttr (MUIA_List_DragSortable, (ULONG)value);
    }

    LONG DropMark (void) const
    {
         return (LONG)GetAttr (MUIA_List_DropMark);
    }

    LONG Entries (void) const
    {
         return (LONG)GetAttr (MUIA_List_Entries);
    }

    LONG First (void) const
    {
         return (LONG)GetAttr (MUIA_List_First);
    }

    STRPTR Format (void) const
    {
         return (STRPTR)GetAttr (MUIA_List_Format);
    }

    void SetFormat (STRPTR value)
    {
         SetAttr (MUIA_List_Format, (ULONG)value);
    }

    LONG InsertPosition (void) const
    {
         return (LONG)GetAttr (MUIA_List_InsertPosition);
    }

    void SetMultiTestHook (struct Hook * value)
    {
         SetAttr (MUIA_List_MultiTestHook, (ULONG)value);
    }

    void SetQuiet (BOOL value)
    {
         SetAttr (MUIA_List_Quiet, (ULONG)value);
    }

    BOOL ShowDropMarks (void) const
    {
         return (BOOL)GetAttr (MUIA_List_ShowDropMarks);
    }

    void SetShowDropMarks (BOOL value)
    {
         SetAttr (MUIA_List_ShowDropMarks, (ULONG)value);
    }

    char * Title (void) const
    {
         return (char *)GetAttr (MUIA_List_Title);
    }

    void SetTitle (char * value)
    {
         SetAttr (MUIA_List_Title, (ULONG)value);
    }

    LONG Visible (void) const
    {
         return (LONG)GetAttr (MUIA_List_Visible);
    }

    ULONG Clear (void)
    {
        return DoMethod (MUIM_List_Clear);
    }

    ULONG CreateImage (Object * obj, ULONG flags)
    {
        return DoMethod (MUIM_List_CreateImage, obj, flags);
    }

    ULONG DeleteImage (APTR listimg)
    {
        return DoMethod (MUIM_List_DeleteImage, listimg);
    }

    ULONG Exchange (LONG pos1, LONG pos2)
    {
        return DoMethod (MUIM_List_Exchange, pos1, pos2);
    }

    ULONG GetEntry (LONG pos, Type ** entry)
    {
        return DoMethod (MUIM_List_GetEntry, pos, entry);
    }

    ULONG Insert (Type ** entries, LONG count, LONG pos)
    {
        return DoMethod (MUIM_List_Insert, entries, count, pos);
    }

    ULONG InsertSingle (Type * entry, LONG pos)
    {
        return DoMethod (MUIM_List_InsertSingle, entry, pos);
    }

    ULONG Jump (LONG pos)
    {
        return DoMethod (MUIM_List_Jump, pos);
    }

    ULONG Move (LONG from, LONG to)
    {
        return DoMethod (MUIM_List_Move, from, to);
    }

    ULONG NextSelected (LONG * pos)
    {
        return DoMethod (MUIM_List_NextSelected, pos);
    }

    ULONG Redraw (LONG pos)
    {
        return DoMethod (MUIM_List_Redraw, pos);
    }

    ULONG Remove (LONG pos)
    {
        return DoMethod (MUIM_List_Remove, pos);
    }

    ULONG Select (LONG pos, LONG seltype, LONG * state)
    {
        return DoMethod (MUIM_List_Select, pos, seltype, state);
    }

    ULONG Sort (void)
    {
        return DoMethod (MUIM_List_Sort);
    }

    ULONG TestPos (LONG x, LONG y, struct MUI_List_TestPos_Result * res)
    {
        return DoMethod (MUIM_List_TestPos, x, y, res);
    }
};



/***************************************************************************
**  CTMUI_Listview : Template version of CMUI_Listview class definition
***************************************************************************/

template <class Type>
class CTMUI_Listview : public CTMUI_List<Type>
{
public:
    CTMUI_Listview (void)
    : CTMUI_List<Type> ()
    {
        object = NULL;
    }

    CTMUI_Listview (Tag tag1, ...)
    : CTMUI_List<Type> ()
    {
#ifdef MUIPP_DEBUG
        _CheckTagsSpecified ("CTMUI_Listview", (struct TagItem *)&tag1, MUIA_Listview_List, "MUIA_Listview_List", TAG_DONE);
#endif
        object = MUI_NewObjectA (MUIC_Listview, (struct TagItem *)&tag1);
#ifdef MUIPP_DEBUG
        if (object == NULL)
            _MUIPPWarning ("Could not create a CTMUI_Listview object\n");
#endif
    }

    CTMUI_Listview (Object * obj)
    : CTMUI_List<Type> ()
    {
        object = obj;
    }

    CTMUI_Listview & operator = (Object * obj)
    {
        object = obj;
        return *this;
    }

    LONG ActivePage (void) const
    {
         return (LONG)GetAttr (MUIA_Group_ActivePage);
    }

    void SetActivePage (LONG value)
    {
         SetAttr (MUIA_Group_ActivePage, (ULONG)value);
    }

    struct List * ChildList (void) const
    {
         return (struct List *)GetAttr (MUIA_Group_ChildList);
    }

    void SetColumns (LONG value)
    {
         SetAttr (MUIA_Group_Columns, (ULONG)value);
    }

    LONG HorizSpacing (void) const
    {
         return (LONG)GetAttr (MUIA_Group_HorizSpacing);
    }

    void SetHorizSpacing (LONG value)
    {
         SetAttr (MUIA_Group_HorizSpacing, (ULONG)value);
    }

    void SetRows (LONG value)
    {
         SetAttr (MUIA_Group_Rows, (ULONG)value);
    }

    void SetSpacing (LONG value)
    {
         SetAttr (MUIA_Group_Spacing, (ULONG)value);
    }

    LONG VertSpacing (void) const
    {
         return (LONG)GetAttr (MUIA_Group_VertSpacing);
    }

    void SetVertSpacing (LONG value)
    {
         SetAttr (MUIA_Group_VertSpacing, (ULONG)value);
    }

    ULONG ExitChange (void)
    {
        return DoMethod (MUIM_Group_ExitChange);
    }

    ULONG InitChange (void)
    {
        return DoMethod (MUIM_Group_InitChange);
    }

    ULONG Sort (StartVarArgs sva, Object * obj, ...)
    {
        sva.methodID = MUIM_Group_Sort;
        return DoMethodA ((Msg)&sva);
    }

    LONG ClickColumn (void) const
    {
         return (LONG)GetAttr (MUIA_Listview_ClickColumn);
    }

    LONG DefClickColumn (void) const
    {
         return (LONG)GetAttr (MUIA_Listview_DefClickColumn);
    }

    void SetDefClickColumn (LONG value)
    {
         SetAttr (MUIA_Listview_DefClickColumn, (ULONG)value);
    }

    BOOL DoubleClick (void) const
    {
         return (BOOL)GetAttr (MUIA_Listview_DoubleClick);
    }

    LONG DragType (void) const
    {
         return (LONG)GetAttr (MUIA_Listview_DragType);
    }

    void SetDragType (LONG value)
    {
         SetAttr (MUIA_Listview_DragType, (ULONG)value);
    }

    Object * List (void) const
    {
         return (Object *)GetAttr (MUIA_Listview_List);
    }

    BOOL SelectChange (void) const
    {
         return (BOOL)GetAttr (MUIA_Listview_SelectChange);
    }
};


#endif          /* MUIPP_TEMPLATES */

#endif          /* LIBRARIES_MUI_HPP */
