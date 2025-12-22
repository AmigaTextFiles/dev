#ifndef LIBRARIES_FEELIN_H
#define LIBRARIES_FEELIN_H

/*
**    feelin.h
**
**    © 2001-2007 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 12.00 (2007/??/??)

	CLASS
	---------------------------------------------------------------------------------------------

	The F_METHOD_ADD_STATIC macro has been renamed as F_METHOD_OVERRIDE_STATIC
	The F_METHOD_ADD_BOTH macro has been renamed as F_METHOD_ADD_STATIC

	Added the F_METHOD_OVERRIDE macro, similar to  the  F_METHOD_ADD  macro,
	but used when overriding methods.


$VER: 11.00 (2006/05/26)

	RENAMED
	---------------------------------------------------------------------------------------------

		FC_RaioItem                             FC_Item
		RadioItemObject                         ItemObject
		FM_Window_ChainAdd                      FM_Window_AddChainable
		FM_Window_ChainRem                      FM_Window_RemChainable

		_class									_object_class
		_classname								_object_classname

	MODIFIED
	---------------------------------------------------------------------------------------------

		The Object class 'ID' attribute is now on of Element class attributes.



	NEW
	---------------------------------------------------------------------------------------------

		F_ARRAY_PTR, F_ARRAY_NEW, F_METHODS_ARRAY_NAME, F_METHODS_NAME,
		F_RESOLVES_ARRAY_NAME, F_RESOLVES_NAME, F_AUTOS_ARRAY_NAME,
		F_AUTOS_NAME, F_TAGS_ARRAY_NAME, F_TAGS_NAME

		FA_Class_Properties, F_PROPERTIES_ARRAY, F_PROPERTIES_ADD,
		F_PROPERTIES_ADD_VALUES, F_PROPERTIES_PTR, F_PROPERTY,
		F_PROPERTY_ATOM



	DEPRECATED
	---------------------------------------------------------------------------------------------


************************************************************************************************/

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif
#ifndef EXEC_SEMAPHORES_H
#include <exec/semaphores.h>
#endif
#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif
#ifndef FEELIN_CONF_H
#include <libraries/feelin_conf.h>
#endif
#ifndef FEELIN_COMPILER_H
#include <feelin/compiler.h>
#endif

#ifndef FEELIN_MACHINE_H
#include <feelin/machine.h>
#endif
#ifndef FEELIN_TYPES_H
#include <feelin/types.h>
#endif
#ifndef FEELIN_RTG_H
#include <feelin/rtg.h>
#endif
#ifndef FEELIN_XMLAPPLICATION_H
#include <feelin/xmlapplication.h>
#endif
#ifndef FEELIN_XMLOBJECT_H
#include <feelin/xmlobject.h>
#endif
#ifndef FEELIN_XMLDOCUMENT_H
#include <feelin/xmldocument.h>
#endif
#ifndef FEELIN_PREFERENCE_H
#include <feelin/preference.h>
#endif
#ifndef FEELIN_PDRDOCUMENT_H
#include <feelin/pdrdocument.h>
#endif

#if (defined(__MORPHOS__) || defined(__amigaos4__)) && defined(__GNUC__) && defined(__PPC__)
#pragma pack(2)
#endif

#define ALL                                     (-1)
#define FV_FEELIN_VERSION                       10
#define FV_FEELIN_REVISION                      0

#define F_CODE_DEPRECATED                       0

/* F_CODE_DEPRECATED

	This symbol is used to mark deprecated code blocs

*/

/// Include information

/*
   All constants follow these rules :

   FM_<method>          - General method, understood by all classes [NUM]
   FM_<class>_<method>  - Class method                              [NUM,STR]
   FA_<attrib>          - General attribute, known by many classes. [NUM]
   FA_<class>_<attrib>  - Specific class attribute                  [NUM,STR]
   FV_<class>_<value>   - Special attribute value                   [NUM]
   FS_<name>            - Structure of arguments to a method        [SYS]

   FA_<attrib> definitions are followed by a comment [ISG] :
	  I : it's possible to specify this attribute at object creation time.
	  S : it's possible to change this attribute with F_Set().
	  G : it's possible to get this attribute with F_Get().

   FR_<class> = Registered class id (unsigned 24 bits)
   FR_<class>_MTHD = First Method ID of <class>
   FR_<class>_ATTR = First Attribute ID of <class>

   Ranges:

   $C0000000 - $CFFFFFFF is reserved for custom classes methods.
   $8C000000 - $8CFFFFFF is reserved for custom classes attributes.

   $D0000000 - 4DFFFFFFF is reserved for Dynamic methods.
   $8D000000 - 41FFFFFFF is reserved for Dynamic attributes.

   $F0000000 - $FFFFFFFF is reserved for Feelin methods.
   $8F000000 - $8FFFFFFF is reserved for Feelin attributes.

   Since v6 of feelin.library most classes use dynamic IDs instead of static
   ones.  Dynamic  IDs  are  generated on the fly at run time, thus they are
   different at each session and future proof. You should  have  a  look  at
   http://www.feelin.fr/guide/ to learn more about this.

*/

#define FCCM_BASE               0xC0000000
#define FCCA_BASE               0x8C000000
#define DYNA_MTHD               0xD0000000
#define DYNA_ATTR               0x8D000000
#define MTHD_BASE               0xF0000000
#define ATTR_BASE               0x8F000000
//+
/// Macros
#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d)                        ((uint32) (a)<<24 | (uint32) (b)<<16 | (uint32) (c)<<8 | (uint32) (d))
#endif

#ifndef MIN
#define MIN(a,b)                                (((a)<(b))?(a):(b))
#endif

#ifndef MAX
#define MAX(a,b)                                (((a)>(b))?(a):(b))
#endif

#define F_IS_INSIDE(a,a1,a2)                    ((a) >= (a1) && (a) <= (a2))

/*

HOMBRE @ GOFROMIEL : J'ai créé les  macro  F_LIB_OPEN  et  F_LIB_CLOSE  dans
machine.h Je compte m'en reservir pour ouvrir les bibliothèques annexes dans
les classes et les démos. Enfin si j'ai bien pensé le truc :-/

Le résultat sera de toutes façon le même qu'avant avec ces nouvelles  macros
F_FEELIN_OPEN et F_FEELIN_CLOSE

GOFROMIEL: Oui j'ai vu ça, m'a l'air très bien !

*/

#define F_FEELIN_OPEN       F_OPENLIB(FeelinBase,FeelinIFace,IFeelin,"feelin.library", FV_FEELIN_VERSION)
#define F_FEELIN_CLOSE      F_CLOSELIB(IFeelin, FeelinBase)
//+

/************************************************************************************************
*** feelin.library ******************************************************************************
************************************************************************************************/

struct FeelinBase
{
	struct Library                  Libnode;
	BPTR                            Console;

	struct ExecBase                *SYS;
	struct DosLibrary              *DOS;
	struct GfxBase                 *Graphics;
	struct IntuitionBase           *Intuition;
	struct UtilityBase             *Utility;
	struct Library                 *Layers;
	struct Library                 *Locale;

	#ifdef __amigaos4__

	/* Interface pointers for OS4 */

	struct ExecIFace               *I_SYS;
	struct DOSIFace                *I_DOS;
	struct GraphicsIFace           *I_Graphics;
	struct IntuitionIFace          *I_Intuition;
	struct UtilityIFace            *I_Utility;
	struct LayersIFace             *I_Layers;
	struct LocaleIFace             *I_Locale;
	struct FeelinIFace             *I_Feelin;

	#endif
};

#ifdef __amigaos4__

#define F_DECLARE_FEELIN                        struct FeelinBase *FeelinBase = NULL; \
												struct FeelinIFace *IFeelin = NULL

#else

#define F_DECLARE_FEELIN                        struct FeelinBase *FeelinBase = NULL

#endif

#if defined(__MORPHOS__)
#define FF_LIBRARY                              RTF_AUTOINIT | RTF_PPC | RTF_EXTENDED
#elif defined(__AROS__)
#define FF_LIBRARY                              RTF_AUTOINIT | RTF_EXTENDED
#elif defined(__amigaos4__)
#define FF_LIBRARY                              RTF_AUTOINIT | RTF_NATIVE
#else
#define FF_LIBRARY                              RTF_AUTOINIT
#endif

///feelin.library / F_LogA

enum    {

		FV_LOG_USER,
		FV_LOG_DEV,
		FV_LOG_CLASS,
		FV_LOG_CORE

		};

//+
///feelin.library / F_CreatePoolA

#define FA_Pool_Attributes                      (ATTR_BASE + 0)
#define FA_Pool_ItemSize                        (ATTR_BASE + 1)
#define FA_Pool_Items                           (ATTR_BASE + 2)
#define FA_Pool_Name                            (ATTR_BASE + 3)
#define FA_Pool_Public                          (ATTR_BASE + 4)

//+
///feelin.library / F_MakeObjA
enum    {

		FV_MakeObj_None,
		FV_MakeObj_Label,
		FV_MakeObj_Button,
		FV_MakeObj_BarTitle,
		FV_MakeObj_Gauge,
		FV_MakeObj_Slider,
		FV_MakeObj_Prop,
		FV_MakeObj_String,
		FV_MakeObj_Checkbox

		};

#define Button(x)                         		IFEELIN F_MakeObj(FV_MakeObj_Button,x,TAG_DONE)
#define BarTitle(x)                             IFEELIN F_MakeObj(FV_MakeObj_BarTitle,x,TAG_DONE)
#define Gauge(h,mi,ma,v)                        IFEELIN F_MakeObj(FV_MakeObj_Gauge,h,mi,ma,v,TAG_DONE)
#define Prop(h,e,v,f)                           IFEELIN F_MakeObj(FV_MakeObj_Prop,h,e,v,f,TAG_DONE)
#define String(s,l)                             IFEELIN F_MakeObj(FV_MakeObj_String,s,l,TAG_DONE)
#define Slider(h,mi,ma,v)                       IFEELIN F_MakeObj(FV_MakeObj_Slider,h,mi,ma,v,TAG_DONE)
#define Checkbox(checked)                       IFEELIN F_MakeObj(FV_MakeObj_Checkbox,checked,TAG_DONE)
#define HLabel(label)                           IFEELIN F_MakeObj(FV_MakeObj_Label,TRUE,label,TAG_DONE)
#define VLabel(label)                           IFEELIN F_MakeObj(FV_MakeObj_Label,FALSE,label,TAG_DONE)
//+

///FEvent
typedef struct FeelinEvent
{
	uint32                              Class;
	uint16                              Code;
	bits16                              Flags;

	uint16                              Qualifier;
	uint8                               Key;
	uint8                               DecodedChar;

	int16                               MouseX;
	int16                               MouseY;
	uint32                              Seconds;
	uint32                              Micros;

	FObject                             Target;
	APTR                                Special;
}
FEvent;

/*** classes ***********************************************************************************/

#define FF_EVENT_TICK                           (1 << 0)
#define FF_EVENT_KEY                            (1 << 1)
#define FF_EVENT_BUTTON                         (1 << 2)
#define FF_EVENT_MOTION                         (1 << 3)
#define FF_EVENT_WINDOW                         (1 << 4)
#define FF_EVENT_DISK                           (1 << 5)
#define FF_EVENT_WBDROP                         (1 << 6)
#define FF_EVENT_FOCUS                          (1 << 7)
#define FF_EVENT_HELP                           (1 << 8)

/*** codes *************************************************************************************/

enum    {

		FV_EVENT_BUTTON_SELECT,
		FV_EVENT_BUTTON_MENU,
		FV_EVENT_BUTTON_MIDDLE,
		FV_EVENT_BUTTON_WHEEL

		};

enum    {

		FV_EVENT_WINDOW_CLOSE,
		FV_EVENT_WINDOW_ACTIVE,
		FV_EVENT_WINDOW_INACTIVE,
		FV_EVENT_WINDOW_SIZE,
		FV_EVENT_WINDOW_DEPTH,
		FV_EVENT_WINDOW_CHANGE,
		FV_EVENT_WINDOW_REFRESH

		};

/* FIXME-060718:


I must really  do  something  about  FV_EVENT_WINDOW_CHANGE.  Since  I  have
FV_EVENT_WINDOW_SIZE, I could replace it by a FV_EVENT_WINDOW_MOVE.

*/

enum    {

		FV_EVENT_DISK_LOAD,
		FV_EVENT_DISK_EJECT

		};

enum    {

		FV_EVENT_FOCUS_IN,
		FV_EVENT_FOCUS_OUT

		};

enum    {

		FV_EVENT_HELP_OPEN,
		FV_EVENT_HELP_CLOSE

		};

/*** flags *************************************************************************************/

#define FF_EVENT_REPEAT                         (1 << 0)

#define FF_EVENT_KEY_UP                         (1 << 1)
#define FF_EVENT_BUTTON_DOWN                    (1 << 1)
//+

/************************************************************************************************
*** Builtin classes *****************************************************************************
************************************************************************************************/

///Object                   0x000000
#define FR_Object                               0x000000
#define FR_Object_MTHD                          (MTHD_BASE | FR_Object)
#define FR_Object_ATTR                          (ATTR_BASE | FR_Object)
#define FC_Object                               "Object"

#define FM_New                                  (FR_Object_MTHD +  0)
#define FM_Dispose                              (FR_Object_MTHD +  1)
#define FM_Get                                  (FR_Object_MTHD +  2)
#define FM_Set                                  (FR_Object_MTHD +  3)
#define FM_Lock                                 (FR_Object_MTHD +  4)
#define FM_Unlock                               (FR_Object_MTHD +  5)
#define FM_Notify                               (FR_Object_MTHD +  6)
#define FM_UnNotify                             (FR_Object_MTHD +  7)
#define FM_CallHook                             (FR_Object_MTHD +  8)
#define FM_CallHookEntry                        (FR_Object_MTHD +  9)
#define FM_MultiSet                             (FR_Object_MTHD + 10)
#define FM_SetAs                                (FR_Object_MTHD + 11)
#define FM_Connect                              (FR_Object_MTHD + 12)
#define FM_Disconnect                           (FR_Object_MTHD + 13)
#define FM_AddMember                            (FR_Object_MTHD + 14)
#define FM_RemMember                            (FR_Object_MTHD + 15)
#ifdef F_NEW_LISTENERS
#define FM_AddListener                          (FR_Object_MTHD + 16)
#define FM_RemoveListener                       (FR_Object_MTHD + 17)
#endif
#ifdef F_NEW_GETELEMENTBYID
#define FM_GetElementById                       (FR_Object_MTHD + 18)
#endif

struct  FS_Lock                                 { bits32 Flags; };
struct  FS_Notify                               { uint32 Attribute; uint32 Value; FObject Target; uint32 Method; uint32 Count; /*...*/ };
struct  FS_UnNotify                             { FNotifyHandler *Handler; };
struct  FS_CallHook                             { struct Hook *Hook; /*...*/ };
struct  FS_CallHookEntry                        { FHookEntry Entry; /*...*/ };
struct  FS_WriteLong                            { uint32 Value; uint32 *Memory; };
struct  FS_WriteString                          { STRPTR Str; STRPTR Memory; };
struct  FS_MultiSet                             { uint32 Attribute; uint32 Value; /*...*/ };
struct  FS_SetAs                                { bits32 Flags; uint32 Attribute; STRPTR Data; /*...*/ };
struct  FS_Connect                              { FObject Parent; };
struct  FS_AddMember                            { FObject Orphan; uint32 Position; FObject Previous; };
struct  FS_RemMember                            { FObject Member; };
#ifdef F_NEW_LISTENERS
struct 	FS_AddListener							{ STRPTR Attribute; struct Hook *Callback; /* ... */ };
struct	FS_RemoveListener						{ STRPTR Attribute; struct Hook *Callback; };
#endif
#ifdef F_NEW_GETELEMENTBYID
struct	FS_GetElementById						{ STRPTR Id; };
#endif

#define FA_UserData                             (FR_Object_ATTR + 0)
#define FA_NoNotify                             (FR_Object_ATTR + 1)
#define FA_Child                                (FR_Object_ATTR + 2)
//#define FA_Element_Parent                       (FR_Object_ATTR + 3)

enum    {

		FV_Notify_None,
		FV_Notify_Self,
		FV_Notify_Parent,
		FV_Notify_Window,
		FV_Notify_Application

		};

#define FV_Notify_Always                        0x49893131
#define FV_Notify_Toggle                        0x49893132
#define FV_Notify_Value                         0x49893131

enum    {

		FV_AddMember_Head = -1,
		FV_AddMember_Tail,
		FV_AddMember_Insert

		};

enum    {

		FV_SetAs_String = 1,
		FV_SetAs_Decimal,
		FV_SetAs_Hexadecimal,
		FV_SetAs_4CC

		};

#define FF_SetAs_Notify                         (1 << 31)

#define FF_Lock_Exclusive                       (1 << 0)
#define FF_Lock_Shared                          (1 << 1)
#define FF_Lock_Attempt                         (1 << 2)

#ifdef F_NEW_LISTENERS

struct FS_Listener_Trigger
{
	uint32								Id;
	uint32								Value;
	FClassAttribute						*Attribute;
};

#endif

#define _object_class(object_)                  ((FClass *)(((uint32 *)(object_))[-1]))
#define _object_classname(object_)              (_object_class(object_)->Name)

//+
///Class                    0x000040
#define FR_Class                                 0x000040
#define FR_Class_MTHD                           (MTHD_BASE | FR_Class)
#define FR_Class_ATTR                           (ATTR_BASE | FR_Class)
#define FC_Class                                "Class"

#define FA_Class_Name                           (FR_Class_ATTR +  0)
#define FA_Class_Super                          (FR_Class_ATTR +  1)
#define FA_Class_LocalSize                      (FR_Class_ATTR +  2)
#define FA_Class_Dispatcher                     (FR_Class_ATTR +  3)
#define FA_Class_UserData                       (FR_Class_ATTR +  4)
#define FA_Class_Pool                           (FR_Class_ATTR +  5)
#define FA_Class_Methods                        (FR_Class_ATTR +  6)
#define FA_Class_Attributes                     (FR_Class_ATTR +  7)
#define FA_Class_Resolveds                      (FR_Class_ATTR +  8)
#define FA_Class_Autos                          (FR_Class_ATTR +  9)
#define FA_Class_CatalogName                    (FR_Class_ATTR + 10)
#define FA_Class_CatalogTable                   (FR_Class_ATTR + 11)
#define FA_Class_Module                         (FR_Class_ATTR + 12)
#define FA_Class_Atoms                          (FR_Class_ATTR + 13)
#define FA_Class_Revision                       (FR_Class_ATTR + 14)
#define FA_Class_Version                        (FR_Class_ATTR + 15)
#define FA_Class_Properties                     (FR_Class_ATTR + 16)
#define FA_Class_PropertiesLocalSize            (FR_Class_ATTR + 17)

enum    {

		FV_Query_ClassTags = 1,
		FV_Query_MetaClassTags,
		FV_Query_PrefsTags,
		FV_Query_MetaPrefsTags,
		FV_Query_DecoratorPrefsTags,
		FV_Query_MetaDecoratorPrefsTags

		};

/*** Macros ************************************************************************************/

#define F_SUPERDO()                             IFEELIN F_SuperDoA(Class,Obj,Method,Msg)
#define F_OBJDO(o)                              IFEELIN F_DoA(o,Method,Msg)
#define F_STORE(val)                            *((uint32 *)(item.ti_Data)) = (uint32)(val)
#define F_LOD(cl,o)                             ((APTR)((uint32)(o) + cl->Offset))

#if F_CODE_DEPRECATED
#define F_ID(tab,n)                             (tab[n].ID)
#endif

#define F_CAT(n)                                FCC_CatalogTable[CAT_##n].String

#define F_ARRAY_PTR(name)                       feelin_auto_##name
#define F_ARRAY_NEW(type,name)                  type F_ARRAY_PTR(name)[]
#define F_ARRAY_END                             { NULL }


#define F_VALUES_ARRAY(name)                    F_ARRAY_NEW(FClassAttributeValue,values_##name)
#define F_VALUES_ADD(name,value)                { name, value }
#define _value_name(value)                      value->Name


#define F_VALUES_EACH(source, entry)            entry = source ; _value_name(entry) ; entry++


#define F_PROPERTIES_ARRAY                      F_ARRAY_NEW(FClassProperty, properties)
#define F_PROPERTIES_ADD(name)                  { name, NULL, NULL }
#define F_PROPERTIES_ADD_VALUES(name, values)   { name, NULL, F_ARRAY_PTR(values_##values) }
#define F_PROPERTIES_PTR                        F_ARRAY_PTR(properties)

//#define F_PROPERTY(id)                          Class->Properties[FV_PROPERTY_##id]
#define F_PROPERTY_ATOM(id)                     Class->Properties[FV_PROPERTY_##id].Atom

#define F_CLASS_EACH_PROPERTY(source, entry)    entry = source ; entry->Name ; entry++

//
// attributes
//

#define F_ATTRIBUTES_ARRAY                                          F_ARRAY_NEW(FClassAttribute,attributes)
#define F_ATTRIBUTES_ADD(name,type)                                 { name, type,  0, NULL }
#define F_ATTRIBUTES_ADD_VALUES(name,type,values)                   { name, type,  0, F_ARRAY_PTR(values_##values) }
#define F_ATTRIBUTES_ADD_STATIC(name,type,id)                       { name, type, id, NULL }
#define F_ATTRIBUTES_ADD_STATIC_VALUES(name,type,id,values)         { name, type, id, F_ARRAY_PTR(values_##values) }
#define F_ATTRIBUTES_ADD_BOTH(name,type,id)                         { name, type, id, NULL }
#define F_ATTRIBUTES_ADD_BOTH_VALUES(name,type,id,values)           { name, type, id, F_ARRAY_PTR(values_##values) }
#define F_ATTRIBUTES_PTR                                            F_ARRAY_PTR(attributes)

#define _attribute_name(attribute)                          attribute->Name

#define F_ATTRIBUTE_ID(id)                      Class->Attributes[FV_ATTRIBUTE_##id].ID
#define F_ATTRIBUTES_EACH(source, entry)        entry = source ; _attribute_name(entry) ; entry++

//
// methods
//

#define F_METHODS_ARRAY                         F_ARRAY_NEW(FClassMethod,methods)
#define F_METHODS_ARRAY_NAME(name)              F_ARRAY_NEW(FClassMethod,methods_##name)
#define F_METHODS_ADD_PRIVATE(func,name,id)     { (FMethod) F_FUNCTION_GATE(func), name, id }
#define F_METHODS_ADD(func,name)                F_METHODS_ADD_PRIVATE(func,name,0)
#define F_METHODS_ADD_STATIC(func,name,id)      F_METHODS_ADD_PRIVATE(func,name,id)
#define F_METHODS_OVERRIDE(func, class, name)	F_METHODS_ADD_PRIVATE(func, "FM_" class "_" name,0)
#define F_METHODS_OVERRIDE_STATIC(func, id)		F_METHODS_ADD_PRIVATE(func,NULL,id)
#define F_METHODS_OVERRIDE_STATIC(func, id)		F_METHODS_ADD_PRIVATE(func,NULL,id)
#define F_METHODS_PTR                           F_ARRAY_PTR(methods)
#define F_METHODS_NAME_PTR(name)                F_ARRAY_PTR(methods##name)

#define _method_name(method)                    method->Name

#define F_METHOD_ID(id)                         Class->Methods[FV_METHOD_##id].ID
#define F_METHODS_EACH(source, entry)           entry = source ; entry->Function ; entry++

//
// resolveds
//

#define F_RESOLVEDS_ARRAY                       F_ARRAY_NEW(FDynamicEntry,resolves)
#define F_RESOLVEDS_ARRAY_NAME(name)            F_ARRAY_NEW(FDynamicEntry,resolves##name)
#define F_RESOLVEDS_ADD(name)                   { name, 0 }
#define F_RESOLVEDS_PTR                         F_ARRAY_PTR(resolves)
#define F_RESOLVEDS_NAME_PTR(name)              F_ARRAY_PTR(resolves##name)

#define F_RESOLVED_ID(id)                       Class->Resolveds[FV_RESOLVED_##id].ID
#define F_RESOLVEDS_EACH(source, entry)         entry = source ; source->Name ; entry++

//
// autos
//

#define F_AUTOS_ARRAY                           F_ARRAY_NEW(FDynamicEntry,autos)
#define F_AUTOS_ARRAY_NAME(name)                F_ARRAY_NEW(FDynamicEntry,autos##name)
#define F_AUTOS_ADD(name)                       { name, 0 }
#define F_AUTOS_PTR                             F_ARRAY_PTR(autos)
#define F_AUTOS_NAME_PTR(name)                  F_ARRAY_PTR(autos##name)

#define F_AUTO_ID(id)                           Class->Autos[FV_AUTO_##id].ID
#define F_AUTOS_EACH(source, entry)             entry = source ; source->Name ; entry++

//
// atoms
//

#define F_ATOMS_ARRAY                           F_ARRAY_NEW(FClassAtom,atoms)
#define F_ATOMS_ARRAY_NAME(name)                F_ARRAY_NEW(FClassAtom,atoms##name)
#define F_ATOMS_ADD(name)                       { name, 0 }
#define F_ATOMS_PTR                             F_ARRAY_PTR(atoms)
#define F_ATOMS_NAME_PTR(name)                  F_ARRAY_PTR(atoms##name)

#define F_ATOM(id)                              Class->Atoms[FV_ATOM_##id].Atom
#define F_ATOM_KEY(id)                          F_ATOM(id)->Key
#define F_ATOM_KEYLENGTH(id)                    F_ATOM(id)->KeyLength

//
// tags
//

#define F_TAGS_ARRAY                            F_ARRAY_NEW(struct TagItem,tags)
#define F_TAGS_ARRAY_NAME(name)                 F_ARRAY_NEW(struct TagItem,tags##name)
#define F_TAGS_ADD(tag,data)                    { FA_Class_##tag, (uint32) data }
#define F_TAGS_PTR                              F_ARRAY_PTR(tags)
#define F_TAGS_NAME_PTR(name)                   F_ARRAY_PTR(tags##name)

//
// predefined tags
//

#define F_TAGS_ADD_ATTRIBUTES                   F_TAGS_ADD(Attributes, F_ATTRIBUTES_PTR)
#define F_TAGS_ADD_METHODS                      F_TAGS_ADD(Methods, F_METHODS_PTR)
#define F_TAGS_ADD_RESOLVEDS                    F_TAGS_ADD(Resolveds, F_RESOLVEDS_PTR)
#define F_TAGS_ADD_AUTOS                        F_TAGS_ADD(Autos, F_AUTOS_PTR)
#define F_TAGS_ADD_CATALOG                      F_TAGS_ADD(CatalogTable, FCC_CatalogTable)
#define F_TAGS_ADD_DISPATCHER(name)             F_TAGS_ADD(Dispatcher, F_FUNCTION_GATE(name))
#define F_TAGS_ADD_LOD                          F_TAGS_ADD(LocalSize, sizeof (struct LocalObjectData))
//#define F_TAGS_ADD_LPD                          F_TAGS_ADD(LODSize, sizeof (struct LocalPreferenceData))
//#define F_TAGS_ADD_LCD                          F_TAGS_ADD(LODSize, sizeof (struct LocalClassData))
#define F_TAGS_ADD_SUPER(name)                  F_TAGS_ADD(Super, FC_##name)
#define F_TAGS_ADD_ATOMS                        F_TAGS_ADD(Atoms, F_ATOMS_PTR)

#define F_TAGS_ADD_PROPERTIES                   F_TAGS_ADD(Properties, F_PROPERTIES_PTR)

#define F_LPD(class, space)                     ((APTR) ((uint32)(space) + class->PropertiesOffset))
#define F_TAGS_ADD_PROPERTIES_SIZE(pseudos)     F_TAGS_ADD(PropertiesLocalSize, sizeof (struct LocalPropertiesData) * (1 + (pseudos)))
//+

/************************************************************************************************
*** Support *************************************************************************************
************************************************************************************************/

///Render                   0x900000
#define FR_Render                               0x900000
#define FR_Render_MTHD                          (MTHD_BASE | FR_Render)
#define FR_Render_ATTR                          (ATTR_BASE | FR_Render)

#define FA_Render_Application                   (FR_Render_ATTR +  0)
#define FA_Render_Display                       (FR_Render_ATTR +  1)
#define FA_Render_Window                        (FR_Render_ATTR +  2)
#define FA_Render_RPort                         (FR_Render_ATTR +  3)
#define FA_Render_Palette                       (FR_Render_ATTR +  4)
#define FA_Render_Friend                        (FR_Render_ATTR +  5)
#define FA_Render_Forbid                        (FR_Render_ATTR +  6)

#define FM_Render_AddClip                       (FR_Render_MTHD +  0)
#define FM_Render_RemClip                       (FR_Render_MTHD +  1)
#define FM_Render_AddClipRegion                 (FR_Render_MTHD +  2)
#define FM_Render_CreateBuffer                  (FR_Render_MTHD +  3)
#define FM_Render_DeleteBuffer                  (FR_Render_MTHD +  4)
#define FM_Render_Fill                          (FR_Render_MTHD +  5)
struct  FS_Render_AddClip                       { FRect *Rect; };
struct  FS_Render_RemClip                       { APTR Handle; };
struct  FS_Render_AddClipRegion                 { struct Region *Region; };
struct  FS_Render_CreateBuffer                  { uint32 Width; uint32 Height; };
struct  FS_Render_DeleteBuffer                  { FRender *Buffer; };
struct 	FS_Render_Fill                          { int32 x1; int32 y1; int32 x2; int32 y2; uint32 RGBA; };

#define FF_Render_Refreshing                    (1 <<  0)
#define FF_Render_Complex                       (1 <<  1)
#define FF_Render_TrueColors                    (1 << 30)
#define FF_Render_Forbid                        (1 << 31)

#define FC_Render                               "Render"
#define RenderObject                            IFEELIN F_NewObj(FC_Render

#define F_ARGB_TO_RGBA(argb)                    (argb << 8) | (~argb >> 24)
#define F_RGBA_TO_ARGB(rgba)                    (rgba >> 8) | (~rgba << 24)
#define F_ARGB_AVERAGE(a,b)                     (((a ^ b) & 0xFFFEFEFEUL) >> 1) + (a & b)
//+
///Family                   0x900040
#define FR_Family                               0x900040
#define FR_Family_MTHD                          (MTHD_BASE | FR_Family)
#define FR_Family_ATTR                          (ATTR_BASE | FR_Family)

#define FA_Family                               (FR_Family_ATTR +  0)
#define FA_Family_Head                          (FR_Family_ATTR +  1)
#define FA_Family_Tail                          (FR_Family_ATTR +  2)
#define FA_Family_Owner                         (FR_Family_ATTR +  3)
#define FA_Family_CreateNodeHook                (FR_Family_ATTR +  4)
#define FA_Family_DeleteNodeHook                (FR_Family_ATTR +  5)

struct  FS_Family_CreateNode                    { FObject Object; };
struct  FS_Family_DeleteNode                    { FFamilyNode *Node; };

#define FC_Family                               "Family"
#define FamilyObject                            IFEELIN F_NewObj(FC_Family
#define Child                                   FA_Child
#define End                                     TAG_DONE)
//+
///ImageDisplay             0x9000C0
#define FR_ImageDisplay                         0x9000C0
#define FR_ImageDisplay_MTHD                    (MTHD_BASE | FR_ImageDisplay)
#define FR_ImageDisplay_ATTR                    (ATTR_BASE | FR_ImageDisplay)

#define FM_ImageDisplay_Setup                   (FR_ImageDisplay_MTHD + 0)
#define FM_ImageDisplay_Cleanup                 (FR_ImageDisplay_MTHD + 1)
#define FM_ImageDisplay_Draw                    (FR_ImageDisplay_MTHD + 2)
struct  FS_ImageDisplay_Setup                   { FRender *Render; };
struct  FS_ImageDisplay_Draw                    { FRender *Render; FRect *Rect; bits32 Flags; };
struct  FS_ImageDisplay_HookDraw                { FRender *Render; FRect *Rect; bits32 Flags; FRect *Region; };

#define FA_ImageDisplay_Spec                    (FR_ImageDisplay_ATTR + 0)
#define FA_ImageDisplay_Width                   (FR_ImageDisplay_ATTR + 1)
#define FA_ImageDisplay_Height                  (FR_ImageDisplay_ATTR + 2)
#define FA_ImageDisplay_Mask                    (FR_ImageDisplay_ATTR + 3)
#define FA_ImageDisplay_Origin                  (FR_ImageDisplay_ATTR + 4)
#define FA_ImageDisplay_Owner                 	(FR_ImageDisplay_ATTR + 5)

#define FF_ImageDisplay_Draw_Region             (1 << 0)
#define FF_ImageDisplay_Draw_Touch              (1 << 1)
#define FF_ImageDisplay_Draw_Focus              (1 << 2)
#define FF_ImageDisplay_Draw_Ghost              (1 << 3)

#define FC_ImageDisplay                         "ImageDisplay"
#define ImageDisplayObject                      IFEELIN F_NewObj(FC_ImageDisplay
//+
///TextDisplay              0x900100
#define FR_TextDisplay                          0x900100
#define FR_TextDisplay_MTHD                     (MTHD_BASE | FR_TextDisplay)
#define FR_TextDisplay_ATTR                     (ATTR_BASE | FR_TextDisplay)

#define FM_TextDisplay_Setup                    (FR_TextDisplay_MTHD + 0)
#define FM_TextDisplay_Cleanup                  (FR_TextDisplay_MTHD + 1)
#define FM_TextDisplay_Draw                     (FR_TextDisplay_MTHD + 2)
struct  FS_TextDisplay_Setup                    { FRender *Render; };
struct  FS_TextDisplay_Draw                     { FRect *Rect; bits32 Flags; };

#define FA_TextDisplay_Contents                 (FR_TextDisplay_ATTR +  0)
#define FA_TextDisplay_PreParse                 (FR_TextDisplay_ATTR +  1)
#define FA_TextDisplay_Font                     (FR_TextDisplay_ATTR +  2)
#define FA_TextDisplay_Width                    (FR_TextDisplay_ATTR +  3)
#define FA_TextDisplay_Height                   (FR_TextDisplay_ATTR +  4)
#define FA_TextDisplay_Shortcut                 (FR_TextDisplay_ATTR +  5)

#define FC_TextDisplay                          "TextDisplay"
#define TextDisplayObject                       IFEELIN F_NewObj(FC_TextDisplay
//+

/************************************************************************************************
*** System **************************************************************************************
************************************************************************************************/

///Application              0x004000
#define FR_Application                          0x004000
#define FR_Application_MTHD                     (MTHD_BASE | FR_Application)
#define FR_Application_ATTR                     (ATTR_BASE | FR_Application)

#define FM_Application_Run                      (FR_Application_MTHD +  0)
#define FM_Application_Shutdown                 (FR_Application_MTHD +  1)
#define FM_Application_Sleep                    (FR_Application_MTHD +  2)
#define FM_Application_Awake                    (FR_Application_MTHD +  3)
#define FM_Application_PushMethod               (FR_Application_MTHD +  4)
#define FM_Application_Setup                    (FR_Application_MTHD +  5)
#define FM_Application_Cleanup                  (FR_Application_MTHD +  6)
#define FM_Application_CreateSignalHandler      (FR_Application_MTHD +  7)
#define FM_Application_DeleteSignalHandler      (FR_Application_MTHD +  8)
#define FM_Application_Load                     (FR_Application_MTHD +  9)
#define FM_Application_Save                     (FR_Application_MTHD + 10)
#define FM_Application_Update                   (FR_Application_MTHD + 11)
#define FM_Application_OpenFont                 (FR_Application_MTHD + 12)
#define FM_Application_Post                     (FR_Application_MTHD + 13)
#define FM_Application_PostClean                (FR_Application_MTHD + 14)
#define FM_Application_AddStyleSheet            (FR_Application_MTHD + 15)
#define FM_Application_RemStyleSheet            (FR_Application_MTHD + 16)

struct  FS_Application_PushMethod               { FObject Target; uint32 Method ; uint32 Count; /*...*/ };
struct  FS_Application_DeleteSignalHandler      { APTR Handler; };
struct  FS_Application_Load                     { STRPTR Name; };
struct  FS_Application_Save                     { STRPTR Name; };
struct  FS_Application_OpenFont                 { FObject Object; STRPTR Spec; };
struct  FS_Application_Post                     { struct FeelinPost *Post; };
struct  FS_Application_PostClean                { struct Hook *CleanHook; };
struct  FS_Application_HookPostClean            { struct FeelinPost *Post; };
struct 	FS_Application_AddStyleSheet			{ APTR Source; uint32 SourceType; };
struct 	FS_Application_RemStyleSheet			{ APTR Source; };

#define FA_Application_Title                    (FR_Application_ATTR +  0)
#define FA_Application_Version                  (FR_Application_ATTR +  1)
#define FA_Application_Copyright                (FR_Application_ATTR +  2)
#define FA_Application_Author                   (FR_Application_ATTR +  3)
#define FA_Application_Description              (FR_Application_ATTR +  4)
#define FA_Application_Base                     (FR_Application_ATTR +  5)
#define FA_Application_Sleep                    (FR_Application_ATTR +  6)
#define FA_Application_Signal                   (FR_Application_ATTR +  7)
#define FA_Application_Display                  (FR_Application_ATTR +  8)
#define FA_Application_Preference               (FR_Application_ATTR +  9)
#define FA_Application_Unique                   (FR_Application_ATTR + 10)
#define FA_Application_UserSignals              (FR_Application_ATTR + 11)
#define FA_Application_BrokerPort               (FR_Application_ATTR + 12)
#define FA_Application_BrokerHook               (FR_Application_ATTR + 13)
#define FA_Application_BrokerPri                (FR_Application_ATTR + 14)
#define FA_Application_Broker                   (FR_Application_ATTR + 15)

enum    {

		FV_Application_ENV,
		FV_Application_ENVARC,
		FV_Application_BOTH

		};

enum    {

		FV_KEY_NONE,
		FV_KEY_PRESS,
		FV_KEY_RELEASE,
		FV_KEY_UP,
		FV_KEY_DOWN,
		FV_KEY_STEPUP,
		FV_KEY_STEPDOWN,
		FV_KEY_TOP,
		FV_KEY_BOTTOM,
		FV_KEY_LEFT,
		FV_KEY_RIGHT,
		FV_KEY_STEPLEFT,
		FV_KEY_STEPRIGHT,
		FV_KEY_FIRST,
		FV_KEY_LAST,
		FV_KEY_CHARBACK,
		FV_KEY_CHARDEL,
		FV_KEY_WORDBACK,
		FV_KEY_WORDDEL,
		FV_KEY_LINEBACK,
		FV_KEY_LINEDEL,
		FV_KEY_NEXTOBJ,
		FV_KEY_PREVOBJ,
		FV_KEY_NOOBJ,
		FV_KEY_CLOSEWINDOW,

		FV_KEY_COUNT

		};

#define FF_Application_PostClean_Eat            (1 << 0)

#define FC_Application                          "Application"
#define ApplicationObject                       IFEELIN F_NewObj(FC_Application
#define AppObject                               IFEELIN F_NewObj(FC_Application

/*** SignalHandler *****************************************************************************/

#define FA_SignalHandler_Target                 (ATTR_BASE + 0)
#define FA_SignalHandler_Method                 (ATTR_BASE + 1)
#define FA_SignalHandler_Signals                (ATTR_BASE + 2)
#define FA_SignalHandler_Seconds                (ATTR_BASE + 3)
#define FA_SignalHandler_Micros                 (ATTR_BASE + 4)

/*** FPost *************************************************************************************/

typedef struct FeelinPost
{
	struct Message                  sys;
	uint32                          Type;
	APTR                            Data;
}
FPost;

enum    {

		FV_Application_Post_Type_Dummy,
		FV_Application_Post_Type_Event

		};
//+
///Display                  0x004080
#define FR_Display                              0x004080
#define FR_Display_MTHD                         (MTHD_BASE | FR_Display)
#define FR_Display_ATTR                         (ATTR_BASE | FR_Display)

#define FM_Display_AddColor                     (FR_Display_MTHD +  0)
#define FM_Display_RemColor                     (FR_Display_MTHD +  1)
#define FM_Display_AddPalette                   (FR_Display_MTHD +  2)
#define FM_Display_RemPalette                   (FR_Display_MTHD +  3)
#define FM_Display_CreateColor                  (FR_Display_MTHD +  4)

struct  FS_Display_AddColor                     { uint32 ARGB; };
struct  FS_Display_RemColor                     { FColor *Color; };
struct  FS_Display_AddPalette                   { uint32 Count; uint32 *ARGBs; };
struct  FS_Display_RemPalette                   { FPalette *Palette; };
struct  FS_Display_CreateColor                  { STRPTR Spec; FPalette *Reference; };
struct  FS_Display_PixelRead                    { uint32 PixelX, PixelY; };

enum    {

		FV_Pen_Text,         // 0
		FV_Pen_Shine,        // 1
		FV_Pen_HalfShine,    // 2
		FV_Pen_Fill,         // 3
		FV_Pen_HalfShadow,   // 4
		FV_Pen_Shadow,       // 5
		FV_Pen_HalfDark,     // 6
		FV_Pen_Dark,         // 7
		FV_Pen_Highlight,    // 8
		FV_PEN_COUNT

		};

enum    {                                       // FA_Display_Name

		FV_Display_Frontmost = -2,
		FV_Display_Workbench,
		FV_Display_Public

		};

typedef struct FeelinHSV
{
	uint16                                      h;
	uint8                                       s,v;
}
FHSV;

typedef struct FeelinRGB
{
	uint8                                       r,g,b;
}
FRGB;

#define FC_Display                              "Display"
#define DisplayObject                           IFEELIN F_NewObj(FC_Display
//+

/************************************************************************************************
*** GUI *****************************************************************************************
************************************************************************************************/

///Element                  0x001000
#define FR_Element                              0x001000
#define FR_Element_MTHD                         (MTHD_BASE | FR_Element)
#define FR_Element_ATTR                         (ATTR_BASE | FR_Element)

#ifdef F_NEW_GLOBALCONNECT
#define FM_Element_GlobalConnect          		(FR_Element_MTHD +  0)
#define FM_Element_GlobalDisconnect         	(FR_Element_MTHD +  1)
#endif
#define FM_Element_Setup                        (FR_Element_MTHD +  2)
#define FM_Element_Cleanup                      (FR_Element_MTHD +  3)
#define FM_Element_CreateDecodedStyle           (FR_Element_MTHD +  4)
#define FM_Element_DeleteDecodedStyle           (FR_Element_MTHD +  5)
#define FM_Element_LoadPersistentAttributes     (FR_Element_MTHD +  7)
#define FM_Element_SavePersistentAttributes     (FR_Element_MTHD +  8)
#define FM_Element_GetProperty                  (FR_Element_MTHD +  9)

#ifdef F_NEW_GLOBALCONNECT
struct	FS_Element_GlobalConnect				{ FObject Application; FObject Window; };
#endif
struct  FS_Element_Setup                        { FRender *Render; };
struct  FS_Element_Cleanup                      { FRender *Render; };
struct  FS_Element_LoadPersistentAttributes     { FObject Storage; };
struct  FS_Element_SavePersistentAttributes     { FObject Storage; };
struct  FS_Element_GetProperty                  { FAtom *PseudoAtom; FAtom *Atom; STRPTR *ValuePtr; uint32 *NumericValuePtr; };
struct  FS_Element_CreateDecodedStyle           { APTR DecodedSpace; FPreferenceStyle *Style; APTR Pool; };
struct  FS_Element_DeleteDecodedStyle           { APTR DecodedSpace; };

#define FA_Element_PublicData                   (FR_Element_ATTR + 0)
#define FA_Element_Id                           (FR_Element_ATTR + 1)
#define FA_Element_Persist                      (FR_Element_ATTR + 2)
#define FA_Element_Class                        (FR_Element_ATTR + 3)
#define FA_Element_Style                        (FR_Element_ATTR + 4)

#ifdef F_NEW_GLOBALCONNECT
#define FA_Element_Application                  (FR_Element_ATTR + 5)
#define FA_Element_Window                       (FR_Element_ATTR + 6)
#endif

#define FA_Element_DecodedStyle                 (FR_Element_ATTR + 7)
#define FA_Element_ComposedStyle                (FR_Element_ATTR + 8)
#define FA_Element_Parent                       (FR_Element_ATTR + 9)



#ifdef F_NEW_GLOBALCONNECT

typedef struct FeelinElementPublic
{
	FObject							Application;
	FObject							Window;
	FObject							Parent;
}
FElementPublic;

#define F_MEMBER_ELEMENT_PUBLIC                 FElementPublic *ElementPublic
#define F_GET_ELEMENT_PUBLIC(object_)           (FElementPublic *) IFEELIN F_Get(object_, FA_Element_PublicData)
#define F_SAVE_ELEMENT_PUBLIC                   LOD->ElementPublic = F_GET_ELEMENT_PUBLIC(Obj)

#define _element_public							LOD->ElementPublic->
#define _element_application					(_element_public Application)
#define _element_window							(_element_public Window)
#define _element_parent							(_element_public Parent)

#endif

#define FC_Element                              "Element"
#define ElementObject                           IFEELIN F_NewObj(FC_Element
//+
///Area                     0x001040
#define FR_Area                                 0x001040
#define FR_Area_MTHD                            (MTHD_BASE | FR_Area)
#define FR_Area_ATTR                            (ATTR_BASE | FR_Area)

/*** attributes ********************************************************************************/

#define FA_Area_PublicData                      (FR_Area_ATTR +  0)
#define FA_Area_Orientation                     (FR_Area_ATTR +  1)
#define FA_Area_Fillable                        (FR_Area_ATTR +  2)
#define FA_Area_Damaged                         (FR_Area_ATTR +  3)
#define FA_Area_Font                            (FR_Area_ATTR + 16)
#define FA_Area_Bufferize                       (FR_Area_ATTR + 18)

/*** methods ***********************************************************************************/

#define FM_Area_AskMinMax                       (FR_Area_MTHD + 0)
#define FM_Area_Layout                          (FR_Area_MTHD + 1)
#define FM_Area_Show                            (FR_Area_MTHD + 2)
#define FM_Area_Hide                            (FR_Area_MTHD + 3)
#define FM_Area_Erase                           (FR_Area_MTHD + 4)
#define FM_Area_Draw                            (FR_Area_MTHD + 5)
#define FM_Area_SetState                        (FR_Area_MTHD + 6)
#define FM_Area_Move                       		(FR_Area_MTHD + 7)

struct  FS_Area_Erase                           { FRect *Rect; bits32 Flags; };
struct  FS_Area_Draw                            { bits32 Flags; };
struct  FS_Area_SetState                        { uint32 State; };
struct  FS_Area_Move                            { int32 x, y; bits32 Flags; };

enum	{

		FV_Area_Orientation_Horizontal,
		FV_Area_Orientation_Vertical

		};

/*** flags *************************************************************************************/

#define FF_Area_Horizontal                      (1 <<  0)
#define FF_Area_Damaged                         (1 <<  1)
#define FF_Area_Drawable                        (1 <<  2)
#define FF_Area_Bufferize                       (1 <<  3)
#define FF_Area_Fillable                        (1 <<  4)

/* F_Draw() & FM_Area_Draw */

#define FF_Draw_Object                          (1 <<  0)
#define FF_Draw_Update                          (1 <<  1)
#define FF_Draw_Damaged                         (1 <<  2)

#define FF_Draw_Custom_1                        (1 << 24)
#define FF_Draw_Custom_2                        (1 << 25)
#define FF_Draw_Custom_3                        (1 << 26)
#define FF_Draw_Custom_4                        (1 << 27)
#define FF_Draw_Custom_5                        (1 << 28)
#define FF_Draw_Custom_6                        (1 << 29)
#define FF_Draw_Custom_7                        (1 << 30)
#define FF_Draw_Custom_8                        (1 << 31)

/* F_Erase() & FM_Area_Erase */

#define FF_Erase_Fill                           (1 <<  0)
#define FF_Erase_Region                         (1 <<  1)
#define FF_Erase_Box                            (1 <<  2)

/* FM_Area_Move */

#define FF_Move_Absolute                        (1 <<  0)
#define FF_Move_Relative                        (1 <<  1)

/*** values ************************************************************************************/

		/* FM_Area_SetState */

enum    {

		FV_Area_State_Neutral = 0,
		FV_Area_State_Touch,
		FV_Area_State_Focus,
		FV_Area_State_Ghost,

		FV_AREA_STATE_COUNT

		};

#define FV_Area_Max                             10000

/*** Types *************************************************************************************/

typedef struct FeelinAreaPublic
{
	bits16                                      Flags;
	uint8                                       State;
	uint8                                       _pad0;

	#ifndef F_NEW_GLOBALCONNECT
	FObject                                     Parent;
	#endif
	FRender                                    *Render;

	FBox                                        Box;
	FBox                                        Content;
	FPadding									Padding;
	FPadding									Border;
	FPadding									Margin;

	FMinMax                                     MinMax;

	struct TextFont                            *Font;
	FPalette                                   *Palette;
	FObject                                     Background;
}
FAreaPublic;

/*** Macros ************************************************************************************/

#define F_MEMBER_AREA_PUBLIC                    FAreaPublic *AreaPublic
#define F_GET_AREA_PUBLIC(object_)              (FAreaPublic *) IFEELIN F_Get(object_, FA_Area_PublicData)
#define F_SAVE_AREA_PUBLIC                      LOD->AreaPublic = F_GET_AREA_PUBLIC(Obj)

#define F_AREA_STATE_TOUCH						"touch"
#define F_AREA_STATE_FOCUS                      "focus"
#define F_AREA_STATE_GHOST                      "ghost"

/* access */

#define _area_public                            LOD->AreaPublic->
#define _area_flags                             (_area_public Flags)
#define _area_state                             (_area_public State)
#ifndef F_NEW_GLOBALCONNECT
#define _area_parent                            (_area_public Parent)
#endif
#define _area_render                            (_area_public Render)
#define _area_box                               (_area_public Box)
#define _area_content                   		(_area_public Content)
#define _area_padding                           (_area_public Padding)
#define _area_border                            (_area_public Border)
#define _area_margin                            (_area_public Margin)
#define _area_minmax                            (_area_public MinMax)
#define _area_font                              (_area_public Font)
#define _area_palette                           (_area_public Palette)
#define _area_pens								(_area_palette->Pens)
#define _area_background                        (_area_public Background)

#define _area_is_horizontal                     ((FF_Area_Horizontal & _area_flags) != 0)
#define _area_isnt_horizontal                   ((FF_Area_Horizontal & _area_flags) == 0)
#define _area_is_damaged                        ((FF_Area_Damaged & _area_flags) != 0)
#define _area_isnt_damaged                      ((FF_Area_Damaged & _area_flags) == 0)
#define _area_set_damaged                       _area_flags |= FF_Area_Damaged
#define _area_clear_damaged                     _area_flags &= ~FF_Area_Damaged
#define _area_is_drawable                       ((FF_Area_Drawable & _area_flags) != 0)
#define _area_isnt_drawable                     ((FF_Area_Drawable & _area_flags) == 0)
#define _area_set_drawable						_area_flags |= FF_Area_Drawable
#define _area_clear_drawable					_area_flags &= ~FF_Area_Drawable
#define _area_is_bufferize                      ((FF_Area_Bufferize & _area_flags) != 0)
#define _area_is_fillable                       ((FF_Area_Fillable & _area_flags) != 0)
#define _area_isnt_fillable                     ((FF_Area_Fillable & _area_flags) == 0)
#define _area_set_fillable                      _area_flags |= FF_Area_Fillable
#define _area_clear_fillable                    _area_flags &= ~FF_Area_Fillable

#define _area_app                               (_area_render->Application)
#define _area_win                               (_area_render->Window)
#define _area_display                           (_area_render->Display)
#define _area_rp                                (_area_render->RPort)

#define _area_x                                 (_area_box.x)
#define _area_y                                 (_area_box.y)
#define _area_w                                 (_area_box.w)
#define _area_h                                 (_area_box.h)
#define _area_x2                                (_area_x + _area_w - 1)
#define _area_y2                                (_area_y + _area_h - 1)

#define _area_cx                                (_area_content.x)
#define _area_cy                                (_area_content.y)
#define _area_cw                                (_area_content.w)
#define _area_ch                                (_area_content.h)
#define _area_cx2                               (_area_cx + _area_cw - 1)
#define _area_cy2                               (_area_cy + _area_ch - 1)

#define _area_minw                              (_area_minmax.MinW)
#define _area_minh                              (_area_minmax.MinH)
#define _area_maxw                              (_area_minmax.MaxW)
#define _area_maxh                              (_area_minmax.MaxH)

/* drawing macros */

#define _FPen(fp)                               IGRAPHICS SetAPen(rp, _area_pens[fp])
#define _APen(p)                                IGRAPHICS SetAPen(rp,p)
#define _BPen(p)                                IGRAPHICS SetBPen(rp,p)
#define _DrMd(m)                                IGRAPHICS SetDrMd(rp,m)
#define _Plot(x1,y1)                            IGRAPHICS WritePixel(rp,x1,y1)
#define _Move(x,y)                              IGRAPHICS Move(rp,x,y)
#define _Draw(x,y)                              IGRAPHICS Draw(rp,x,y)
#define _Boxf(x1,y1,x2,y2)                      IGRAPHICS RectFill(rp,x1,y1,x2,y2)
#define _Text(s,c)                              IGRAPHICS Text(rp,s,c)

/* object generation macros */

#define FC_Area                                 "Area"
#define AreaObject                              IFEELIN F_NewObj(FC_Area
//+
///Border                   0x001080
#define FR_Border                               0x001080
#define FR_Border_MTHD                          (MTHD_BASE | FR_Border)
#define FR_Border_ATTR                          (ATTR_BASE | FR_Border)

#define FA_Border_Caption                       (FR_Border_ATTR + 0)

#define FC_Border                               "Border"
#define BorderObject                            IFEELIN F_NewObj(FC_Border
//+
///Widget                   0x0010C0
#define FR_Widget                               0x0010C0
#define FR_Widget_MTHD                          (MTHD_BASE | FR_Widget)
#define FR_Widget_ATTR                          (ATTR_BASE | FR_Widget)

#define FM_Widget_ModifyEvents                  (FR_Widget_MTHD + 0)
#define FM_Widget_HandleEvent                   (FR_Widget_MTHD + 1)
#define FM_Widget_DnDDo                         (FR_Widget_MTHD + 2)
#define FM_Widget_DnDQuery                      (FR_Widget_MTHD + 3)
#define FM_Widget_DnDBegin                      (FR_Widget_MTHD + 4)
#define FM_Widget_DnDFinish                     (FR_Widget_MTHD + 5)
#define FM_Widget_DnDReport                     (FR_Widget_MTHD + 6)
#define FM_Widget_DnDDrop                       (FR_Widget_MTHD + 7)

struct  FS_Widget_ModifyEvents                  { bits32 Add; bits32 Sub; };
struct  FS_Widget_HandleEvent                   { FEvent *Event; };

/*
#define FM_BuildContextHelp                     (FR_Area_MTHD + 12)
#define FM_BuildContextMenu                     (FR_Area_MTHD + 13)
*/

struct  FS_Widget_DnDDo                         { int32 MouseX, MouseY; };
struct  FS_Widget_DnDQuery                      { int32 MouseX, MouseY; FObject Source; FBox *Box; };
struct  FS_Widget_DnDBegin                      { FObject Source; };
struct  FS_Widget_DnDFinish                     { FObject Source; };
struct  FS_Widget_DnDReport                     { int32 MouseX, MouseY; FObject Source; uint32 Update; FBox *DragBox; };
struct  FS_Widget_DnDDrop                       { int32 MouseX, MouseY; FObject Source; };
/*
struct  FS_BuildContextHelp                     { int32 MouseX, MouseY; };
struct  FS_BuildContextMenu                     { int32 MouseX, MouseY; FObject Menu, ContextOwner; FRender *Render; };
*/
#define FA_Widget_PublicData                    (FR_Widget_ATTR +  0)
#define FA_Widget_Align                         (FR_Widget_ATTR +  1)
#define FA_Widget_Mode                          (FR_Widget_ATTR +  2)
#define FA_Widget_Weight                        (FR_Widget_ATTR +  3)
#define FA_Widget_Chainable                     (FR_Widget_ATTR +  4)
#define FA_Widget_Active                        (FR_Widget_ATTR +  5)
#define FA_Widget_Disabled                      (FR_Widget_ATTR +  6)
#define FA_Widget_Hidden                        (FR_Widget_ATTR +  7)
#define FA_Widget_Pressed                       (FR_Widget_ATTR +  8)
#define FA_Widget_PressedTick                   (FR_Widget_ATTR +  9)
#define FA_Widget_Selected                      (FR_Widget_ATTR + 10)
#define FA_Widget_Draggable                     (FR_Widget_ATTR + 11)
#define FA_Widget_Dropable                      (FR_Widget_ATTR + 12)
#define FA_Widget_Accel                         (FR_Widget_ATTR + 13)
#define FA_Widget_SetMin                        (FR_Widget_ATTR + 14)
#define FA_Widget_SetMax                        (FR_Widget_ATTR + 15)

enum    {	// Align

		FV_Widget_Align_Center = 0,
		FV_Widget_Align_Start,
		FV_Widget_Align_End

		};


#ifdef F_NEW_WIDGET_MODE

enum	{	// Mode

		FV_Widget_Mode_Inert,
		FV_Widget_Mode_Touch,
		FV_Widget_Mode_Toggle,
		FV_Widget_Mode_Button

		};

#else

enum    {	// Mode

		FV_Widget_Mode_Inert,
		FV_Widget_Mode_Immediate,
		FV_Widget_Mode_Release,
		FV_Widget_Mode_Toggle

		};

#endif

enum    {	// SetMin, SetMax

		FV_Widget_SetNone,
		FV_Widget_SetBoth,
		FV_Widget_SetWidth,
		FV_Widget_SetHeight

		};

enum    {	// DnDReport

		FV_Widget_DnDReport_Timer,
		FV_Widget_DnDReport_Motion

		};

/*** flags *************************************************************************************/

/* flags */

#define FF_Widget_Showable                      (1 <<  0)
#define FF_Widget_Selected                      (1 <<  1)
#define FF_Widget_Pressed                       (1 <<  2)
#define FF_Widget_Active                        (1 <<  3)
#define FF_Widget_Disabled                      (1 <<  4)
#define FF_Widget_SetMinW                       (1 <<  5)
#define FF_Widget_SetMaxW                       (1 <<  6)
#define FF_Widget_SetMinH                       (1 <<  7)
#define FF_Widget_SetMaxH                       (1 <<  8)

#define FF_Widget_Reserved1                     (1 << 16)
#define FF_Widget_Reserved2                     (1 << 17)
#define FF_Widget_Reserved3                     (1 << 18)

#define FF_Widget_Group                         (1 << 31)

/* FA_Hidden flags */

#define FF_Hidden_NoNesting                     (1 << 31)
#define FF_Hidden_Check                         (1 << 30)

/* FA_Disabled flags */

#define FF_Disabled_NoNesting                   (1 << 31)
#define FF_Disabled_Check                       (1 << 30)

/* FM_HandleEvent */

#define FF_HandleEvent_Eat                      (1 << 0)

/*** Types *************************************************************************************/

typedef struct FeelinWidgetPublic
{
	bits32                                      Flags;
	uint16                                      Weight;
	uint8                                       Align;
	uint8                                       _pad0;

	#ifdef F_NEW_WIDGET_PUBLIC

	FElementPublic							   	*ElementPublic;
	FAreaPublic									*AreaPublic;

	#endif
}
FWidgetPublic;

/*** Macros ************************************************************************************/

/* the following macros assume the variable 'LOD' to be declared and holding
a  field  'AreaData'  of  type  (FAreaData  *).  If it is not the case undef
'_areadata' and redefine it to your convenience */

#define F_MEMBER_WIDGET_PUBLIC                  FWidgetPublic *WidgetPublic
#define F_GET_WIDGET_PUBLIC(object_)            (FWidgetPublic *) IFEELIN F_Get(object_, FA_Widget_PublicData)
#define F_SAVE_WIDGET_PUBLIC                    LOD->WidgetPublic = F_GET_WIDGET_PUBLIC(Obj)

#define _widget_public                          LOD->WidgetPublic->

#define _widget_flags                           (_widget_public Flags)
#define _widget_is_showable                     ((_widget_flags & FF_Widget_Showable) != 0)
#define _widget_isnt_showable                   ((_widget_flags & FF_Widget_Showable) == 0)
#define _widget_is_selected                     ((_widget_flags & FF_Widget_Selected) != 0)
#define _widget_isnt_selected                   ((_widget_flags & FF_Widget_Selected) == 0)
#define _widget_is_pressed                      ((_widget_flags & FF_Widget_Pressed) != 0)
#define _widget_isnt_pressed                    ((_widget_flags & FF_Widget_Pressed) == 0)
#define _widget_is_active                       ((_widget_flags & FF_Widget_Active) != 0)
#define _widget_isnt_active                     ((_widget_flags & FF_Widget_Active) == 0)
#define _widget_is_disabled                     ((_widget_flags & FF_Widget_Disabled) != 0)
#define _widget_isnt_disabled                   ((_widget_flags & FF_Widget_Disabled) == 0)
#define _widget_is_setminw                      ((FF_Widget_SetMinW & _widget_flags) != 0)
#define _widget_isnt_setminw                    ((FF_Widget_SetMinW & _widget_flags) == 0)
#define _widget_is_setmaxw                      ((FF_Widget_SetMaxW & _widget_flags) != 0)
#define _widget_isnt_setmaxw                    ((FF_Widget_SetMaxW & _widget_flags) == 0)
#define _widget_is_setminh                      ((FF_Widget_SetMinH & _widget_flags) != 0)
#define _widget_isnt_setminh                    ((FF_Widget_SetMinH & _widget_flags) == 0)
#define _widget_is_setmaxh                      ((FF_Widget_SetMaxH & _widget_flags) != 0)
#define _widget_isnt_setmaxh                    ((FF_Widget_SetMaxH & _widget_flags) == 0)

#define _widget_is_group                        ((_widget_flags & FF_Widget_Group) != 0)
#define _widget_isnt_group                      ((_widget_flags & FF_Widget_Group) == 0)
#define _widget_weight                          (_widget_public Weight)
#define _widget_align                           (_widget_public Align)

#ifdef F_NEW_WIDGET_PUBLIC

/* Area shortcuts */
/*
#define _widget_area_public                     _widget_public AreaPublic->
#define _widget_area_flags                      (_widget_area_public Flags)
#define _widget_state                           (_widget_area_public State)
#define _widget_padding                         (_widget_area_public Padding)
#define _widget_border                          (_widget_area_public Border)
#define _widget_margin                          (_widget_area_public Margin)
#define _widget_font                            (_widget_area_public Font)
#define _widget_background                      (_widget_area_public Background)

#define _widget_is_horizontal                   ((FF_Area_Horizontal & _widget_area_flags) != 0)
#define _widget_isnt_horizontal                 ((FF_Area_Horizontal & _widget_area_flags) == 0)
#define _widget_is_damaged                      ((FF_Area_Damaged & _widget_area_flags) != 0)
#define _widget_isnt_damaged                    ((FF_Area_Damaged & _widget_area_flags) == 0)
#define _widget_set_damaged                     _widget_area_flags |= FF_Area_Damaged
#define _widget_clear_damaged                   _widget_area_flags &= ~FF_Area_Damaged
#define _widget_is_drawable                     ((FF_Area_Drawable & _widget_area_flags) != 0)
#define _widget_isnt_drawable                   ((FF_Area_Drawable & _widget_area_flags) == 0)
#define _widget_set_drawable					_widget_area_flags |= FF_Area_Drawable
#define _widget_clear_drawable					_widget_area_flags &= ~FF_Area_Drawable
#define _widget_is_bufferize                    ((FF_Area_Bufferize & _widget_area_flags) != 0)
#define _widget_is_fillable                     ((FF_Area_Fillable & _widget_area_flags) != 0)
#define _widget_isnt_fillable                   ((FF_Area_Fillable & _widget_area_flags) == 0)
#define _widget_set_fillable                    _widget_area_flags |= FF_Area_Fillable
#define _widget_clear_fillable                  _widget_area_flags &= ~FF_Area_Fillable

#define _widget_render                          (_widget_area_public Render)
#define _widget_app                             (_widget_render->Application)
#define _widget_win                             (_widget_render->Window)
#define _widget_display                         (_widget_render->Display)
#define _widget_rp                              (_widget_render->RPort)

#define _widget_box                             (_widget_area_public Box)
#define _widget_x                               (_widget_box.x)
#define _widget_y                               (_widget_box.y)
#define _widget_w                               (_widget_box.w)
#define _widget_h                               (_widget_box.h)
#define _widget_x2                              (_widget_x + _widget_w - 1)
#define _widget_y2                              (_widget_y + _widget_h - 1)

#define _widget_content                   		(_widget_area_public Content)
#define _widget_cx                              (_widget_content.x)
#define _widget_cy                              (_widget_content.y)
#define _widget_cw                              (_widget_content.w)
#define _widget_ch                              (_widget_content.h)
#define _widget_cx2                             (_widget_cx + _widget_cw - 1)
#define _widget_cy2                             (_widget_cy + _widget_ch - 1)

#define _widget_minmax                          (_widget_area_public MinMax)
#define _widget_minw                            (_widget_minmax.MinW)
#define _widget_minh                            (_widget_minmax.MinH)
#define _widget_maxw                            (_widget_minmax.MaxW)
#define _widget_maxh                            (_widget_minmax.MaxH)

#define _widget_palette                         (_widget_area_public Palette)
#define _widget_pens							(_widget_palette->Pens)
*/
/* element macros */
/*
#define _widget_element_public					_widget_public ElementPublic->
#define _widget_parent							(_widget_element_public Parent)
*/
#endif

/* object generation macros */

#define FC_Widget                               "Widget"
#define WidgetObject                            IFEELIN F_NewObj(FC_Widget

#define InputImmediate                          FA_Widget_Mode, FV_Widget_Mode_Immediate
#define InputRelease                            FA_Widget_Mode, FV_Widget_Mode_Release
#define InputToggle                             FA_Widget_Mode, FV_Widget_Mode_Toggle
#define DontChain                               FA_Widget_Chainable, FALSE
//+
///Window                   0x001100
#define FR_Window                               0x001100
#define FR_Window_MTHD                          (MTHD_BASE | FR_Window)
#define FR_Window_ATTR                          (ATTR_BASE | FR_Window)

#define FM_Window_Open                          (FR_Window_MTHD +  0)
#define FM_Window_Close                         (FR_Window_MTHD +  1)
#define FM_Window_AddChainable                  (FR_Window_MTHD +  2)
#define FM_Window_RemChainable                  (FR_Window_MTHD +  3)
#define FM_Window_CreateEventHandler            (FR_Window_MTHD +  4)
#define FM_Window_DeleteEventHandler            (FR_Window_MTHD +  5)
#define FM_Window_DispatchEvent                 (FR_Window_MTHD +  6)
#define FM_Window_RequestRethink                (FR_Window_MTHD +  7)
#define FM_Window_Zoom                          (FR_Window_MTHD +  8)
#define FM_Window_Depth                         (FR_Window_MTHD +  9)
struct  FS_Window_AddChainable                  { FObject Widget; };
struct  FS_Window_RemChainable                  { FObject Widget; };
struct  FS_Window_DeleteEventHandler            { APTR Handler; };
struct  FS_Window_DispatchEvent                 { FEvent *Event; };
struct  FS_Window_Zoom                          { bool32 Zoom; };
struct  FS_Window_Depth                         { bool32 Depth; };

#define FA_Window_Open                          (FR_Window_ATTR +  0)
#define FA_Window_CloseRequest                  (FR_Window_ATTR +  1)
#define FA_Window_Title                         (FR_Window_ATTR +  2)
#define FA_Window_ScreenTitle                   (FR_Window_ATTR +  3)
#define FA_Window_Active                        (FR_Window_ATTR +  4)
#define FA_Window_ActiveObject                  (FR_Window_ATTR +  5)
#define FA_Window_Backdrop                      (FR_Window_ATTR +  6)
#define FA_Window_Borderless                    (FR_Window_ATTR +  7)
#define FA_Window_Resizable                     (FR_Window_ATTR +  8)
#define FA_Window_System                        (FR_Window_ATTR +  9)

//#warning FA_Window_Resizable is deprecated

/* FIXME-060719:  Since  Window  class  is  now  a  subclass  of  Area,  the
FA_Window_Resizable   attribute  is  obsolete.  One  can  check  _area_minw,
_area_maxw, _area_minh and _area_minw to know if the window is resizable  or
not, just like the Group class does with its children. */

#define FA_Window_GadNone                       (FR_Window_ATTR + 10)
#define FA_Window_GadDragbar                    (FR_Window_ATTR + 11)
#define FA_Window_GadClose                      (FR_Window_ATTR + 12)
#define FA_Window_GadDepth                      (FR_Window_ATTR + 13)
#define FA_Window_GadIconify                    (FR_Window_ATTR + 14)
#define FA_Window_Decorator                     (FR_Window_ATTR + 15)
#define FA_Window_Events                        (FR_Window_ATTR + 16)
#define FA_Window_Activable                     (FR_Window_ATTR + 17)
#define FA_Window_Left                     		(FR_Window_ATTR + 18)
#define FA_Window_Right                     	(FR_Window_ATTR + 19)
#define FA_Window_Top                     		(FR_Window_ATTR + 20)
#define FA_Window_Bottom                     	(FR_Window_ATTR + 21)
#define FA_Window_Height                     	(FR_Window_ATTR + 22)
#define FA_Window_Width                     	(FR_Window_ATTR + 23)

enum    {

		FV_Window_ActiveObject_Prev = -2,
		FV_Window_ActiveObject_Next,
		FV_Window_ActiveObject_None

		};

enum    {

		FV_Window_Zoom_Full = - 3,
		FV_Window_Zoom_Max,
		FV_Window_Zoom_Toggle

		};

enum    {

		FV_Window_Depth_Back = -3,
		FV_Window_Depth_Front,
		FV_Window_Depth_Toggle

		};

#define FC_Window                               "Window"
#define WindowObject                            IFEELIN F_NewObj(FC_Window

#define FA_EventHandler_Events                  (ATTR_BASE + 0)
#define FA_EventHandler_Target                  (ATTR_BASE + 1)
#define FA_EventHandler_Class                   (ATTR_BASE + 2)
#define FA_EventHandler_Priority                (ATTR_BASE + 3)
//+
///Group                    0x001140
#define FR_Group                                0x001140
#define FR_Group_MTHD                           (MTHD_BASE | FR_Group)
#define FR_Group_ATTR                           (ATTR_BASE | FR_Group)

#define FM_Group_Forward                        (FR_Group_MTHD +  0)

#define FA_Group_HSpacing                       (FR_Group_ATTR +  0)
#define FA_Group_VSpacing                       (FR_Group_ATTR +  1)
#define FA_Group_SameSize                       (FR_Group_ATTR +  2)
#define FA_Group_SameWidth                      (FR_Group_ATTR +  3)
#define FA_Group_SameHeight                     (FR_Group_ATTR +  4)
#define FA_Group_LayoutHook                     (FR_Group_ATTR +  5)
#define FA_Group_MinMaxHook                     (FR_Group_ATTR +  6)
#define FA_Group_Forward                        (FR_Group_ATTR +  7)
#define FA_Group_Quiet                          (FR_Group_ATTR +  8)
#define FA_Group_Rows                           (FR_Group_ATTR +  9)
#define FA_Group_Columns                        (FR_Group_ATTR + 10)
#define FA_Group_Virtual                        (FR_Group_ATTR + 11)
#define FA_Group_RelSizing                      (FR_Group_ATTR + 12)
#define FA_Group_Name                           (FR_Group_ATTR + 13)

#define FF_Group_Virtual                        FF_Widget_Reserved3

/*** types *************************************************************************************/

typedef struct FeelinWidgetNode
{
	struct FeelinWidgetNode        *Next;
	struct FeelinWidgetNode        *Prev;
	FObject                         Widget;
//  end of FFamilyNode header

	FAreaPublic                    *AreaPublic;
	FWidgetPublic                  *WidgetPublic;

	bits32                          Flags;
	FBox                            PreviousBox;
}
FWidgetNode;

#define FF_WIDGETNODE_COMPUTE_W                 (1 << 0)
#define FF_WIDGETNODE_COMPUTE_H                 (1 << 1)

/*** generation ********************************************************************************/

#define FC_Group                                "Group"
#define GroupObject                             IFEELIN F_NewObj(FC_Group
#define VGroup                                  IFEELIN F_NewObj(FC_Group,FA_Area_Orientation, FV_Area_Orientation_Vertical
#define HGroup                                  IFEELIN F_NewObj(FC_Group
#define RowGroup(x)                             IFEELIN F_NewObj(FC_Group,FA_Group_Rows,x
#define ColGroup(x)                             IFEELIN F_NewObj(FC_Group,FA_Group_Columns,x
//+
///Text                     0x001180
#define FR_Text                                 0x001180
#define FR_Text_MTHD                            (MTHD_BASE | FR_Text)
#define FR_Text_ATTR                            (ATTR_BASE | FR_Text)

#define FA_Text_Contents                        (FR_Text_ATTR +  0)
#define FA_Text_PreParse                        (FR_Text_ATTR +  1)
//#define FA_Text_AltPreParse                     (FR_Text_ATTR +  2)
#define FA_Text_HCenter                         (FR_Text_ATTR +  3)
#define FA_Text_VCenter                         (FR_Text_ATTR +  4)
#define FA_Text_Shortcut                        (FR_Text_ATTR +  5)
#define FA_Text_Static                          (FR_Text_ATTR +  6)

#define FC_Text                                 "Text"
#define TextObject                              IFEELIN F_NewObj(FC_Text
//+

/************************************************************************************************
*** Classes *************************************************************************************
************************************************************************************************/
 
#define FC_Adjust                               "Adjust"
#define FC_AdjustBrush                          "AdjustBrush"
#define FC_AdjustColor                          "AdjustColor"
#define FC_AdjustFrame                          "AdjustFrame"
#define FC_AdjustGradient                       "AdjustGradient"
#define FC_AdjustImage                          "AdjustImage"
#define FC_AdjustRaster                         "AdjustRaster"
#define FC_AdjustPadding                        "AdjustPadding" /* FIXME: This class is a bug !! */
#define FC_AdjustPicture                        "AdjustPicture"
#define FC_AdjustPen                            "AdjustPen"
#define FC_AdjustPreParse                       "AdjustPreParse"
#define FC_AdjustRGB                            "AdjustRGB"
#define FC_AdjustScheme                         "AdjustScheme"
#define FC_AdjustSchemeEntry                    "AdjustSchemeEntry"
#define FC_Balance                              "Balance"
#define FC_Bar                                  "Bar"
#define FC_Border                               "Border"
#define FC_Crawler                              "Crawler"
#define FC_Cycle                                "Cycle"
#define FC_Dataspace                            "Dataspace"
#define FC_Decorator                            "Decorator"
#define FC_Dialog                               "Dialog"
#define FC_DOSList                              "DOSList"
#define FC_DOSNotify                            "DOSNotify"
#define FC_Gauge                                "Gauge"
#define FC_FileChooser                          "FileChooser"
#define FC_FontChooser                          "FontChooser"
#define FC_FontDialog                           "FontDialog"
#define FC_Histogram                            "Histogram"
#define FC_Image                                "Image"
#define FC_Item                                 "Item"
#define FC_List                                 "List"
#define FC_Listview                             "Listview"
#define FC_ModulesList                          "ModulesList"
#define FC_Numeric                              "Numeric"
#define FC_Page                                 "Page"
#define FC_Palette                              "Palette"
#ifdef F_NEW_PERSISTENT
#define FC_PDRDocument                          "PDRDocument"
#endif
#define FC_Picture                              "Picture"
#define FC_PopButton                            "PopButton"
#define FC_PopColor                             "PopColor"
#define FC_PopFile                              "PopFile"
#define FC_PopFont                              "PopFont"
#define FC_PopFrame                             "PopFrame"
#define FC_PopHelp                              "PopHelp"
#define FC_PopImage                             "PopImage"
#define FC_PopScheme                            "PopScheme"
#define FC_Preview                              "Preview"
#define FC_PreviewColor                         "PreviewColor"
#define FC_PreviewGradient                      "PreviewGradient"
#define FC_PreviewFrame                         "PreviewFrame"
#define FC_PreviewImage                         "PreviewImage"
#define FC_PreviewScheme                        "PreviewScheme"
#define FC_Prop                                 "Prop"
#define FC_Radio                                "Radio"
#define FC_Render                               "Render"
#define FC_Scrollbar                            "Scrollbar"
#define FC_Slider                               "Slider"
#define FC_String                               "String"
#define FC_TextDisplay                          "TextDisplay"
#define FC_Thread                               "Thread"

#define AdjustObject                            IFEELIN F_NewObj(FC_Adjust
#define AdjustBrushObject                       IFEELIN F_NewObj(FC_AdjustBrush
#define AdjustColorObject                       IFEELIN F_NewObj(FC_AdjustColor
#define AdjustFrameObject                       IFEELIN F_NewObj(FC_AdjustFrame
#define AdjustGradientObject                    IFEELIN F_NewObj(FC_AdjustGradient
#define AdjustImageObject                       IFEELIN F_NewObj(FC_AdjustImage
#define AdjustPaddingObject                     IFEELIN F_NewObj(FC_AdjustPadding /* FIXME: This class is a bug */
#define AdjustPictureObject                     IFEELIN F_NewObj(FC_AdjustPicture
#define AdjustPenObject                         IFEELIN F_NewObj(FC_AdjustPen
#define AdjustPreParseObject                    IFEELIN F_NewObj(FC_AdjustPreParse
#define AdjustRasterObject                      IFEELIN F_NewObj(FC_AdjustRaster
#define AdjustRGBObject                         IFEELIN F_NewObj(FC_AdjustRGB
#define AdjustSchemeObject                      IFEELIN F_NewObj(FC_AdjustScheme
#define AdjustSchemeEntryObject                 IFEELIN F_NewObj(FC_AdjustSchemeEntry
#define BalanceObject                           IFEELIN F_NewObj(FC_Balance
#define BalanceID(id)                           IFEELIN F_NewObj(FC_Balance,FA_ID,id,TAG_DONE)
#define BarObject                               IFEELIN F_NewObj(FC_Bar
#define BorderObject							IFEELIN F_NewObj(FC_Border
#define CrawlerObject                           IFEELIN F_NewObj(FC_Crawler
#define CycleObject                             IFEELIN F_NewObj(FC_Cycle
#define DataspaceObject                         IFEELIN F_NewObj(FC_Dataspace
#define DecoratorObject                         IFEELIN F_NewObj(FC_Decorator
#define DialogObject                            IFEELIN F_NewObj(FC_Dialog
#define DOSListObject                           IFEELIN F_NewObj(FC_DOSList
#define DOSNotifyObject                         IFEELIN F_NewObj(FC_DOSNotify
#define FileChooserObject                       IFEELIN F_NewObj(FC_FileChooser
#define FontChooserObject                       IFEELIN F_NewObj(FC_FontChooser
#define FontDialogObject                        IFEELIN F_NewObj(FC_FontDialog
#define GaugeObject                             IFEELIN F_NewObj(FC_Gauge
#define HistogramObject                         IFEELIN F_NewObj(FC_Histogram
#define ImageObject                             IFEELIN F_NewObj(FC_Image
#define ItemObject                              IFEELIN F_NewObj(FC_Item
#define ListObject                              IFEELIN F_NewObj(FC_List
#define ListviewObject                          IFEELIN F_NewObj(FC_Listview
#define ModulesListObject                       IFEELIN F_NewObj(FC_ModulesList
#define NumericObject                           IFEELIN F_NewObj(FC_Numeric
#define PageObject                              IFEELIN F_NewObj(FC_Page
#define PaletteObject                           IFEELIN F_NewObj(FC_Palette
#ifdef F_NEW_PERSISTENT
#define PDRDocumentObject                       IFEELIN F_NewObj(FC_PDRDocument
#endif
#define PictureObject                           IFEELIN F_NewObj(FC_Picture
#define PopButtonObject                         IFEELIN F_NewObj(FC_PopButton
#define PopColorObject                          IFEELIN F_NewObj(FC_PopColor
#define PopFileObject                           IFEELIN F_NewObj(FC_PopFile
#define PopFontObject                           IFEELIN F_NewObj(FC_PopFont
#define PopFrameObject                          IFEELIN F_NewObj(FC_PopFrame
#define PopHelpObject                           IFEELIN F_NewObj(FC_PopHelp
#define PopImageObject                          IFEELIN F_NewObj(FC_PopImage
#define PopSchemeObject                         IFEELIN F_NewObj(FC_PopScheme
#define PreviewObject                           IFEELIN F_NewObj(FC_Preview
#define PreviewColorObject                      IFEELIN F_NewObj(FC_PreviewColor
#define PreviewGradientObject                   IFEELIN F_NewObj(FC_PreviewGradient
#define PreviewFrameObject                      IFEELIN F_NewObj(FC_PreviewFrame
#define PreviewImageObject                      IFEELIN F_NewObj(FC_PreviewImage
#define PreviewSchemeObject                     IFEELIN F_NewObj(FC_PreviewScheme
#define PropObject                              IFEELIN F_NewObj(FC_Prop
#define RadioObject                             IFEELIN F_NewObj(FC_Radio
#define ScrollbarObject                         IFEELIN F_NewObj(FC_Scrollbar
#define SliderObject                            IFEELIN F_NewObj(FC_Slider
#define StringObject                            IFEELIN F_NewObj(FC_String
#define ThreadObject                            IFEELIN F_NewObj(FC_Thread

/*** Types *************************************************************************************/

typedef struct FeelinListDisplay
{
	STRPTR                          String;
	STRPTR                          PreParse;
}
FListDisplay;

typedef struct FeelinModuleCreated
{
	struct FeelinModuleCreated     *Next;
	struct FeelinModuleCreated     *Prev;
	struct Library                 *Module;
	FClass                         *Meta;
	FClass                         *Class;
}
FModuleCreated;

/*** Method Messages ***************************************************************************/

struct  FS_Adjust_Split                         { STRPTR Spec; STRPTR *Array; };
struct  FS_Adjust_Query                         { STRPTR Spec; };
struct  FS_Adjust_ToString                      { STRPTR Spec; int32 Notify; uint32 UserData; };
struct  FS_Adjust_ToObject                      { STRPTR Spec; FObject XMLDocument; };
struct  FS_Adjust_ParseXML                      { STRPTR Source; uint32 SourceType; FAtom *Markup; FObject *XMLDocument; uint32 *id_Resolve; };
struct  FS_Dataspace_Add                        { uint32 ID; APTR Data; uint32 Size; };
struct  FS_Dataspace_Remove                     { uint32 ID; };
struct  FS_Dataspace_Find                       { uint32 ID; };
struct  FS_Dataspace_Resolve                    { uint32 ID; uint32 *Save; };
struct  FS_Dataspace_WriteIFF                   { struct IFFHandle *IFF; uint32 Type; uint32 ID; };
struct  FS_Dataspace_ReadIFF                    { struct IFFHandle *IFF; };
struct  FS_List_Construct                       { APTR Entry; APTR Pool; };
struct  FS_List_Destruct                        { APTR Entry; APTR Pool; };
struct  FS_List_Display                         { APTR Entry; STRPTR *Strings; STRPTR *PreParses; };
struct  FS_List_Compare                         { APTR Entry; APTR Other; int32 Type1; int32 Type2; };
struct  FS_List_Insert                          { APTR *Entries; int32 Count; int32 Pos; };
struct  FS_List_InsertSingle                    { APTR Entry; int32 Pos; };
struct  FS_List_GetEntry                        { int32 Position; };
struct  FS_List_Remove                          { int32 Position; };
struct  FS_List_FindString                      { STRPTR String; };
struct  FS_ModulesList_Create                   { uint32 Which; };
struct  FS_ModulesList_Delete                   { uint32 Which; };
struct  FS_Numeric_Increase                     { int32 Value; };
struct  FS_Numeric_Decrease                     { int32 Value; };
struct  FS_Numeric_Stringify                    { int32 Value; };
struct  FS_Picture_Draw                         { FRender *Render; FRect *Rect; bits32 Flags; };
struct  FS_Prop_Decrease                        { int32 Value; };
struct  FS_Prop_Increase                        { int32 Value; };
struct  FS_Preview_Query                        { STRPTR Spec; };
struct  FS_Preview_ParseXML                     { STRPTR Source; uint32 SourceType; FAtom *Markup; FObject *XMLDocument; uint32 *id_Resolve; };
struct  FS_Preview_ToString                     { STRPTR Spec; };
struct  FS_Preview_Adjust                       { STRPTR WindowTitle; STRPTR AdjustClass; /* ... */ };
struct  FS_Thread_Send                          { int32 Cmd; };
struct  FS_Thread_Push                          { int32 Cmd; };
struct  FS_Thread_Wait                          { bits32 Bits; };

#define F_MSG_PREVIEW_PARSEXML(source,sourcetype,ids,markupid,xmldocument,id_resolve)   source,sourcetype,ids,markupid,xmldocument,id_resolve

/************************************************************************************************
*** Values **************************************************************************************
************************************************************************************************/

#define FV_Adjust_Separator         '|'
#define F_ADJUST_SEPARATOR          "|"

/*** Cycle *************************************************************************************/

enum    {

		FV_Cycle_Active_Prev = -3,
		FV_Cycle_Active_Next,
		FV_Cycle_Active_Last,
		FV_Cycle_Active_First

		};

/*** Dialog ************************************************************************************/

enum    {

		FV_Dialog_Response_None = 0,
		FV_Dialog_Response_Ok,
		FV_Dialog_Response_Cancel,
		FV_Dialog_Response_Apply,
		FV_Dialog_Response_Yes,
		FV_Dialog_Response_No,
		FV_Dialog_Response_All,
		FV_Dialog_Response_Save,
		FV_Dialog_Response_Use

		};

enum    {

		FV_Dialog_Buttons_None = 0,
		FV_Dialog_Buttons_Ok,
		FV_Dialog_Buttons_Boolean,
		FV_Dialog_Buttons_Confirm,
		FV_Dialog_Buttons_Always,
		FV_Dialog_Buttons_Preference,
		FV_Dialog_Buttons_PreferenceTest

		};

/*** List **************************************************************************************/

#define FV_List_Hook_String         -1
#define FV_List_NotVisible          -1

enum    {

		FV_List_Active_PageDown = -7,
		FV_List_Active_PageUp,
		FV_List_Active_Down,
		FV_List_Active_Up,
		FV_List_Active_Bottom,
		FV_List_Active_Top,
		FV_List_Active_None

		};

enum    {

		FV_List_Activation_Unknown = 0,
		FV_List_Activation_Click,
		FV_List_Activation_DoubleClick,
		FV_List_Activation_Key,
		FV_List_Activation_External

		};

enum    {

		FV_List_Insert_Bottom = -3,
		FV_List_Insert_Sorted,
		FV_List_Insert_Active,
		FV_List_Insert_Top

		};

enum    {

		FV_List_Remove_First = -9,
		FV_List_Remove_Last,
		FV_List_Remove_Prev,
		FV_List_Remove_Next,
		FV_List_Remove_Active,
		FV_List_Remove_Others,
		FV_List_Remove_ToBottom,
		FV_List_Remove_FromTop,
		FV_List_Remove_All

		};
	
enum    {

		FV_List_GetEntry_First = -5,
		FV_List_GetEntry_Last,
		FV_List_GetEntry_Prev,
		FV_List_GetEntry_Next,
		FV_List_GetEntry_Active


		};

enum    {

		FV_List_Sort_Ascending = -1,
		FV_List_Sort_None,
		FV_List_Sort_Descending

		};

#define FV_List_FindString_NotFound             -1

/*** Page **************************************************************************************/

enum    {

		FV_Page_Active_Prev = -3,
		FV_Page_Active_Next,
		FV_Page_Active_Last,
		FV_Page_Active_First

		};

/*** Preference ********************************************************************************/

enum    {

		FV_Preference_ENV = -3,
		FV_Preference_ENVARC,
		FV_Preference_BOTH

		};

/*** Radio *************************************************************************************/

enum    {

		FV_Radio_Active_Prev = -3,
		FV_Radio_Active_Next,
		FV_Radio_Active_Last,
		FV_Radio_Active_First

		};

/*** scrollbar *********************************************************************************/

enum    {

		FV_Scrollbar_Type_Symetric = 0,
		FV_Scrollbar_Type_Start,
		FV_Scrollbar_Type_End,
		FV_Scrollbar_Type_Clear

		};

/*** String ************************************************************************************/

enum    {

		FV_String_Decimal = -2,
		FV_String_Hexadecimal,

		FV_String_Left,
		FV_String_Center,
		FV_String_Right,

		};

/*** Thread ************************************************************************************/

enum    {

		FV_Thread_Reserved1 = -4,
		FV_Thread_Reserved2,
		FV_Thread_Hello,
		FV_Thread_Bye,
		FV_Thread_Dummy = 1

		};

#define F_IS_THREAD_MSG(msg)                    ((uint32)(Obj) == (uint32)(((struct Message *) msg)->mn_Node.ln_Name))

/***********************************************************************************************/

#if (defined(__MORPHOS__) || defined(__amigaos4__)) && defined(__GNUC__) && defined(__PPC__)
#pragma pack()
#endif

#endif
