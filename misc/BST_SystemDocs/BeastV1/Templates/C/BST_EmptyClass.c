/****h* Beast/BST_EmptyClass.c [1.0] ********
*
*	NAME
*	  BST_EmptyClass --
*
*	COPYRIGHT
*	  Maverick Software Development
*
*	AUTHOR
*	  Jacco van Weert
*
*	CREATION DATE
*	  14-Feb-96
*
*	MODIFICATION HISTORY
*
******************************************
*/

#include <BEAST:Include/proto/beast.h>
#include <proto/exec.h>
#include <utility/tagitem.h>

/**************************
 **** structure definitions
 ****/
#define BST_EmptyCLASS_NAME "BST_EmptyClass" 

/***************************
 **** The instance structure
 ****/
struct BST_EmptyInstance
{
#include <BEAST:Instances/BST_System/C/BST_EmptyClass.instance>
};

extern struct Library *BeastBase, *SysBase;
extern char  	       idString[], ClassName[];

#ifdef __SAS__
ULONG __asm Init_Class(void);
ULONG __asm Exit_Class(void);
#else
ULONG Init_Class(void);
ULONG Exit_Class(void);
#endif

	/**** These methods are defined as example... they are not needed ****/
rfcall (mth_Init,    BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList);
rfcall (mth_Dispose, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList);
rfcall (mth_GetAttr, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList);
rfcall (mth_SetAttr, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList);

	/**** The name of the library ****/
char idString[]  = "BST_EmptyClass  ("__DATE__")\n\r\0";
	/**** The name of the class as defined in my_class.h ****/
char ClassName[] = BST_EmptyCLASS_NAME ;

struct BST_Class *BST_EmptyClass;

	/**** The SetAttr procedure is used by the OBM_Init and OBM_SetAttr method ****/
ULONG SetAttr( BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList );


/****** BST_EmptyClass/Init_Class [1.0]
*
*	NAME
*	  Init_Class
*
**********************************
*/
#ifdef __SAS__
ULONG __asm Init_Class(void)
#else
ULONG Init_Class(void)
#endif
{
  /*******************************************************************
   **** Define class.... use BST_MakeSubClass if there is a superclass
   ****/
  if (BST_EmptyClass = BST_MakeClass( ClassName, sizeof(struct BST_EmptyInstance )))
    {
      CLSS_AddMethod( BST_EmptyClass, (ULONG *)&mth_Init,    OBM_INIT    );
      CLSS_AddMethod( BST_EmptyClass, (ULONG *)&mth_Dispose, OBM_DISPOSE );
      CLSS_AddMethod( BST_EmptyClass, (ULONG *)&mth_GetAttr, OBM_GETATTR );
      CLSS_AddMethod( BST_EmptyClass, (ULONG *)&mth_SetAttr, OBM_SETATTR );
      BST_AddClass(   BST_EmptyClass );
    }

  return( 0 );
}

/****** BST_EmptyClass/Exit_Class [1.0]
*
*	NAME
*	  Exit_Class
*
***********************************
*/
#ifdef __SAS__
ULONG __asm Exit_Class(void)
#else
ULONG Exit_Class(void)
#endif
{
  BST_RemoveClass( BST_EmptyClass );
  BST_FreeClass(   BST_EmptyClass );
  return( 0 );
}

/****** BST_EmptyClass/SetAttr [1.0]
*
*	NAME
*	  SetAttr
*
********************************************
*/
ULONG SetAttr( BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList )
{
  struct BST_EmptyInstance *EI = Macro_GetInstance;
  struct TagItem 	   *cur_ti, 
  			   *numberof_ti = NULL;
  ULONG  		    the_tag,
  			    nr_attr = 0xFFFFFFFF;

  /*******************************
   **** Check for the BTA_NumberOf
   ****/
  if (numberof_ti = BST_FindTagItem( BTA_NumberOf, TagList ))
      {	nr_attr = numberof_ti->ti_Data; }


  /************************
   **** Set every attribute
   ****/
  for (cur_ti = TagList; ( cur_ti->ti_Tag != TAG_DONE ) &&
  			 ( nr_attr >  0  )   	; cur_ti = BST_NextTagItem( cur_ti ))
    {
      the_tag         = cur_ti->ti_Tag;
      cur_ti->ti_Tag ^= BTF_Ignore;
      nr_attr--;
      switch( the_tag )
        {
	  case BTA_Title: EI->Title = (char *)cur_ti->ti_Data;  break;
          default 	: nr_attr++;
          		  cur_ti->ti_Tag  ^= BTF_Ignore; break;
        }
    }

  /****************************************************
   **** Reset the MethodFlags if all attributes are set
   ****/
  if (  numberof_ti )
    if (!(numberof_ti->ti_Data = nr_attr))
	MethodFlags &= ~( MTHF_DOPARENTS | MTHF_DOCHILDREN | MTHF_PASSTOCHILD );

  return( MethodFlags );
}

/****** BST_EmptyClass/mth_Init [1.0]
*
*	NAME
*	  mth_Init
*
**************************************************
*/
rfcall (mth_Init, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  return SetAttr( MethodFlags, Object, TagList );
}

/****** BST_EmptyClass/mth_Dispose [1.0]
*
*	NAME
*	  mth_Dispose
*
*****************************************************
*/
rfcall (mth_Dispose, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  return MethodFlags;
}


/****** BST_EmptyClass/mth_SetAttr [1.0]
*
*	NAME
*	  mth_SetAttr
*
*****************************************************
*/
rfcall (mth_SetAttr, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  return SetAttr( MethodFlags, Object, TagList );
}


/****** BST_EmptyClass/mth_GetAttr [1.0]
*
*	NAME
*	  mth_GetAttr( MethodFlags, Object, Taglist )
*
*****************************************************
*/
rfcall( mth_GetAttr, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct BST_EmptyInstance *EI = Macro_GetInstance;
  struct TagItem 	   *cur_ti, 
  			   *numberof_ti = NULL;
  ULONG  		    the_tag,
  			    nr_attr = 0xFFFFFFFF;

  /*******************************
   **** Check for the BTA_NumberOf
   ****/
  if (numberof_ti = BST_FindTagItem( BTA_NumberOf, TagList ))
      {	nr_attr = numberof_ti->ti_Data; }


  /************************
   **** Get every attribute
   ****/
  for (cur_ti = TagList; ( cur_ti->ti_Tag != TAG_DONE ) &&
  			 ( nr_attr >  0  )   	; cur_ti = BST_NextTagItem( cur_ti ))
    {
      the_tag         = cur_ti->ti_Tag;
      cur_ti->ti_Tag ^= BTF_Ignore;
      nr_attr--;
      switch( the_tag )
        {
	  case BTA_Title: cur_ti->ti_Data = EI->Title;  break;
          default 	: nr_attr++;
          		  cur_ti->ti_Tag  ^= BTF_Ignore; break;
        }
    }

  /****************************************************
   **** Reset the MethodFlags if all attributes are set
   ****/
  if (    numberof_ti )
    if (!(numberof_ti->ti_Data = nr_attr))
	MethodFlags &= ~( MTHF_DOPARENTS | MTHF_DOCHILDREN | MTHF_PASSTOCHILD );

  return( MethodFlags );

}
