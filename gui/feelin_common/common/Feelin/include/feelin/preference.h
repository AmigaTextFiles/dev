#ifndef FEELIN_PREFERENCE_H
#define FEELIN_PREFERENCE_H

#ifndef FEELIN_CSSDOCUMENT_H
#include <feelin/cssdocument.h>
#endif

/*
**  feelin/preference.h
**
**  © 2001-2005 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 02.00 (2006/04/25)

	Added Atoms and Styles support.

$VER: 01.10 (2005/09/15)

	Since FC_Preference is now a subclass of FC_CSSDocument, I've added the
	'<feelin/cssdocument.h>' include.

	Added FV_Preference_Magic value and F_PREFERENCE_MAGIC macro.

************************************************************************************************/

/************************************************************************************************
*** Generation **********************************************************************************
************************************************************************************************/

#define FC_Preference                           "Preference"
#define FC_PreferenceEditor                     "PreferenceEditor"
#define FC_PreferenceGroup                      "PreferenceGroup"

#define PreferenceObject                        IFEELIN F_NewObj(FC_Preference
#define PreferenceEditorObject                  IFEELIN F_NewObj(FC_PreferenceEditor
#define PreferenceGroupObject                   IFEELIN F_NewObj(FC_PreferenceGroup
		
/************************************************************************************************
*** Types ***************************************************************************************
************************************************************************************************/

typedef struct FeelinPreferenceProperty
{
	FAtom                          *Atom;
	STRPTR                          Value;
	uint32                          NumericValue;
	bits32                          NumericType;

}
FPreferenceProperty;

typedef struct FeelinPreferenceStyle
{
	struct FeelinPreferenceStyle   *Next; // pseudos
	FPreferenceProperty           **Properties;
	FAtom                          *Atom;

	APTR                            DecodedPropertiesSpace;
}
FPreferenceStyle;

typedef struct FeelinPreferenceScript
{
	STRPTR                          DeclarationName;
	STRPTR                          PropertyName;
	STRPTR                          Attribute;
}
FPreferenceScript;

/************************************************************************************************
*** Messages ************************************************************************************
************************************************************************************************/

struct  FS_Preference_Find                      { STRPTR Name; APTR *DataPtr; uint32 *ValuePtr; };
struct  FS_Preference_Remove                    { STRPTR Name; };
struct  FS_Preference_Read                      { STRPTR Name; };
struct  FS_Preference_Write                     { STRPTR Name; };

struct  FS_Preference_ObtainStyle               { FObject Reference; };
struct  FS_Preference_ReleaseStyle              { FObject Reference; FPreferenceStyle *Style; };

struct  FS_PreferenceGroup_Load                 { FObject Prefs; uint32 id_GetProperty; };
struct  FS_PreferenceGroup_Save                 { FObject Prefs; uint32 id_AddProperty; };

/************************************************************************************************
*** Macros **************************************************************************************
************************************************************************************************/

#define F_PREFERENCE_GLOBAL_NAME                "global"

#define F_PREFERENCES_ARRAY                     F_ARRAY_NEW(FPreferenceScript,preferences)

/*FIXME: This macro is used for compatibility, 'type' and 'default' are no
longer used and should be removed later */

#define F_PREFERENCES_ADD(declaration,property,type,attribute,default) { declaration, property, attribute }
#define F_PREFERENCES_ADD_REFERENCE(reference)  { reference, NULL, NULL }
#define F_PREFERENCES_PTR                       F_ARRAY_PTR(preferences)

#endif
