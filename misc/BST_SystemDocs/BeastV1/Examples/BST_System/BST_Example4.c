
/****h* Beast/BST_Example4.c [1.0] **************
*
*	NAME
*	  BST_Example4 --
*
*	COPYRIGHT
*	  Maverick Software Development
*
*	FUNCTION
*
*	AUTHOR
*	  Jacco van Weert
*
*	CREATION DATE
*	  25-Mar-96
*
*	MODIFICATION HISTORY
*
*	NOTES
*
****************************************************
*/
#include <BEAST:Include/proto/beast.h>
#include <proto/exec.h>
#include <stdio.h>

struct Library *BeastBase;

struct TagItem EmptyList[] =
{  {TAG_DONE, 0}
};


/************************************************************
 ***** my class instance definition, only used for sizeof()!!
 *****/
struct Double_Instance
{
	LONG	N;
};


/***********************
 **** OBM_GETATTR method
 ****/
__geta4 rfcall (Dbl_GetAttr, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct Double_Instance *Instance = Macro_GetInstance;

  struct TagItem *cur_ti, *numberof_ti = NULL;
  ULONG  the_tag, nr_attr = 0xFFFFFFFF;

  /*******************************
   **** Check for the BTA_NumberOf
   ****/
  if (numberof_ti = BST_FindTagItem( BTA_NumberOf, TagList ))
      {	nr_attr = numberof_ti->ti_Data; }


  /************************
   **** Get every attribute
   ****/
  for (cur_ti = TagList; ( cur_ti->ti_Tag != TAG_DONE ) &
  			 ( nr_attr >  0  )   	; cur_ti = BST_NextTagItem( cur_ti ))
    {
      the_tag         = cur_ti->ti_Tag;
      cur_ti->ti_Tag |= BTF_Ignore;
      nr_attr--;
      switch( the_tag )
        {
				/**************************
				 **** Resolve the Double
				 ****/
	  case BTA_LongNumber:  cur_ti->ti_Data = Instance->N;
				struct TagItem TL_GetN[] =
				  { {BTA_NumberOf,   1},
				    {BTA_LongNumber, Instance->N / 2},
				    {TAG_DONE, 0}
				  };
				/****************************************************
				 **** If the tag wasn't found... BTA_NumberOf still 1
				 ****/
				OBJ_MethodToParent( Object, OBM_GETATTR, TL_GetN, MTHF_DOPARENTS );
				printf( "=== Double %ld = %ld\n", Instance->N, TL_GetN[1].ti_Data );
	  			break;
          default   	     : 	nr_attr++;
          			cur_ti->ti_Tag  &= ~BTF_Ignore; break;
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


/***********************
 **** OBM_SETATTR method
 ****/
__geta4 rfcall (Dbl_SetAttr, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct Double_Instance *Instance = Macro_GetInstance;

  struct TagItem *cur_ti, *numberof_ti = NULL;
  ULONG  the_tag, nr_attr = 0xFFFFFFFF;

  /*******************************
   **** Check for the BTA_NumberOf
   ****/
  if (numberof_ti = BST_FindTagItem( BTA_NumberOf, TagList ))
      {	nr_attr = numberof_ti->ti_Data; }


  /************************
   **** Set every attribute
   ****/
  for (cur_ti = TagList; ( cur_ti->ti_Tag != TAG_DONE ) &
  			 ( nr_attr >  0  )   	; cur_ti = BST_NextTagItem( cur_ti ))
    {
      the_tag         = cur_ti->ti_Tag;
      cur_ti->ti_Tag |= BTF_Ignore;
      nr_attr--;
      switch( the_tag )
        {
				/******************************************
				 **** Set also the N number at the children
				 ****/
	  case BTA_LongNumber: 	Instance->N     = cur_ti->ti_Data;
				cur_ti->ti_Data = cur_ti->ti_Data * 2;
				nr_attr++;
          			cur_ti->ti_Tag  &= ~BTF_Ignore;
	  			break;

          default   	    : 	nr_attr++;
          			cur_ti->ti_Tag  &= ~BTF_Ignore;
          			break;

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



/*********************************/
/**** M A I N - P R O G R A M ****/
/*********************************/
main()
{
  struct BST_Class  *my_DoubleClass;
  struct BST_Object *my_DblObj1, *my_DblObj2, *my_DblObj3, *my_DblObj4;

  printf("*** Beast OO Example4 START ***\n");
  if (BeastBase = (struct Library *)OpenLibrary("beast.library", 1 ))
    {
      my_DoubleClass = BST_MakeClass( "my_DoubleClass", sizeof( struct Double_Instance ));
      CLSS_AddMethod( my_DoubleClass, &Dbl_SetAttr, OBM_SETATTR );
      CLSS_AddMethod( my_DoubleClass, &Dbl_GetAttr, OBM_GETATTR );
      BST_AddClass(   my_DoubleClass );

      if       (my_DblObj1 = OBJ_NewObject( NULL, "my_DoubleClass", NULL       ))
        if     (my_DblObj2 = OBJ_NewObject( NULL, "my_DoubleClass", my_DblObj1 ))
          if   (my_DblObj3 = OBJ_NewObject( NULL, "my_DoubleClass", my_DblObj2 ))
            if (my_DblObj4 = OBJ_NewObject( NULL, "my_DoubleClass", my_DblObj3 ))
	      {
		struct TagItem TL_SetN[] =
		  { {BTA_NumberOf,   1},
		    {BTA_LongNumber, 4},
		    {TAG_DONE, 0}
		  };
		OBJ_DoMethod( my_DblObj1, OBM_SETATTR, TL_SetN, MTHF_PASSTOCHILD );

		{
		struct TagItem TL_GetN[] =
		  { {BTA_NumberOf,   1},
		    {BTA_LongNumber, 0},
		    {TAG_DONE, 0}
		  };
		OBJ_DoMethod( my_DblObj4, OBM_GETATTR, TL_GetN, MTHF_DOPARENTS );
		printf( "--- BTA_NumberOf   = %ld\n", TL_GetN[0].ti_Data );
		printf( "--- BTA_LongNumber = %ld\n", TL_GetN[1].ti_Data );
		}

		{
		struct TagItem TL_GetN[] =
		  { {BTA_NumberOf,   1},
		    {BTA_LongNumber, 0},
		    {TAG_DONE, 0}
		  };
		OBJ_DoMethod( my_DblObj2, OBM_GETATTR, TL_GetN, MTHF_DOPARENTS );
		printf( "--- BTA_NumberOf   = %ld\n", TL_GetN[0].ti_Data );
		printf( "--- BTA_LongNumber = %ld\n", TL_GetN[1].ti_Data );
		}

	      }

      OBJ_DisposeObject( my_DblObj1 );
      BST_RemoveClass(   my_DoubleClass );
      BST_FreeClass(     my_DoubleClass );

      CloseLibrary( BeastBase );
    }
  printf("*** Beast OO Example4 END ***\n");
}
