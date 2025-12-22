/****h* Beast/BST_Example3.c [1.0] **************
*
*	NAME
*	  BST_Example3 --
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
*	  17-Mar-96
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
{
  {TAG_DONE, 0}
};


/*************************************************************
 ***** math class instance definitions, only used for sizeof()!!
 *****/

struct math_x2_Instance
{
#include "math_a.instance"
};
struct math_x_Instance
{
#include "math_a.instance"
};
struct math_a_Instance
{
#include "math_a.instance"
};
struct math_xy_Instance
{
#include "math_a.instance"
	LONG	Y;
};




/***************************************************************************
 ===========================================================================
 **** MATH_aClass methods
 ************************/
__geta4 rfcall (mth_a_Init, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_a_Instance *Instance = Macro_GetInstance;

  Instance->A = 1;
  return( MethodFlags );
}



/**********************************************
 ----------------------------------------------
 **** Method called when a new X number arrives
 ****/
__geta4 rfcall (mth_a_InputX, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_a_Instance *Instance = Macro_GetInstance;

  struct TagItem TL_Output[] =
    { {BTA_Y,    Instance->A},
      {TAG_DONE, 0}
    };
  OBJ_ToOutput( Object,TL_Output, OBM_OUTPUT, 0 );

  return( MethodFlags );
}



/***************************************************************
 ---------------------------------------------------------------
 **** Method called the object connected to this method requests
 **** for new input.
 ****/
__geta4 rfcall (mth_a_OutputX, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{

  /***********************************
   **** Just call our OBM_INPUT method
   ****/
  OBJ_DoMethod( Object, OBM_INPUT, EmptyList, 0 );
  return( MethodFlags );
}



/*****************************************************************
 -----------------------------------------------------------------
 **** Method call to set some attributes
 **** Note: This routine is a little bit overdone, but it's a demo
 ****/
__geta4 rfcall (mth_a_SetAttr, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_a_Instance *Instance = Macro_GetInstance;

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
	  case BTA_LongNumber: 	Instance->A = cur_ti->ti_Data;  break;
          default   	    : 	nr_attr++;
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





/***************************************************************************
 ===========================================================================
 **** MATH_x2_Class methods
 **************************/

/**********************************************
 ----------------------------------------------
 **** Method called when a new X number arrives
 ****/
__geta4 rfcall (mth_x2_InputX, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_x2_Instance *Instance = Macro_GetInstance;
  struct TagItem	   *cur_ti;

  /******************************
   **** Search for the BTA_X tag.
   ****/
  if ( cur_ti = BST_FindTagItem( BTA_X, TagList ))
    {
      LONG X = cur_ti->ti_Data;

      struct TagItem TL_Output[] =
  	{ {BTA_Y, (Instance->A * X*X)},		/**** Calculate A * X^2  ****/
	  {TAG_DONE, 0}
  	};
      OBJ_ToOutput( Object,TL_Output, OBM_OUTPUT, 0 );
    }

  return( MethodFlags | MTHF_BREAK );
}



/***************************************************************************
 ===========================================================================
 **** MATH_x_Class methods
 *************************/


/**********************************************
 ----------------------------------------------
 **** Method called when a new X number arrives
 ****/
__geta4 rfcall (mth_x_InputX, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_x_Instance *Instance = Macro_GetInstance;
  struct TagItem 	  *cur_ti;

  /******************************
   **** Search for the BTA_X tag.
   ****/
  if ( cur_ti = BST_FindTagItem( BTA_X, TagList ))
    {
      LONG X = cur_ti->ti_Data;

      struct TagItem TL_Output[] =
  	{ {BTA_Y, (Instance->A * X)},		/**** Calculate A * X   ****/
	  {TAG_DONE, 0}
  	};
      OBJ_ToOutput( Object,TL_Output, OBM_OUTPUT, 0 );
    }

  return( MethodFlags | MTHF_BREAK );
}



/***************************************************************************
 ===========================================================================
 **** MATH_xy_Class methods
 **************************/
__geta4 rfcall (mth_xy_Init, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_xy_Instance *Instance = Macro_GetInstance;

  Instance->Y = 0;
  return( MethodFlags );
}



/**********************************************************
 ----------------------------------------------------------
 **** Method called when a new _part_ of the result arrives
 ****/
__geta4 rfcall (mth_xy_InputY, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_xy_Instance *Instance = Macro_GetInstance;
  struct TagItem	  *cur_ti;

  /******************************
   **** Search for the BTA_Y tag.
   ****/
  if ( cur_ti = BST_FindTagItem( BTA_Y, TagList ))
    {
      printf("----- add %ld\n",cur_ti->ti_Data);
      Instance->Y = Instance->Y + cur_ti->ti_Data;
    }

  return( MethodFlags | MTHF_BREAK );
}



/***************************************************************
 ---------------------------------------------------------------
 **** Method called the object connected to this method requests
 **** for new input.
 ****/
__geta4 rfcall (mth_xy_OutputX, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_xy_Instance *Instance = Macro_GetInstance;

  Instance->Y = 0.0;	/**** Reset the result ****/

  struct TagItem TL_Output[] =
    { {BTA_X, Instance->A},
      {TAG_DONE, 0}
    };
  OBJ_ToOutput( Object, TL_Output, OBM_OUTPUT, 0 );

  printf("**** Y result = %ld \n", Instance->Y );

  return( MethodFlags | MTHF_BREAK );
}




/*********************************/
/**** M A I N - P R O G R A M ****/
/*********************************/
main()
{
  struct BST_Class  *math_x2_class, *math_x_class, *math_a_class, *math_xy_class;
  struct BST_Object *math_x2_obj,   *math_x_obj,   *math_a_obj,   *math_xy_obj;
  
  printf("*** Beast OO Example3 START ***\n");
  if (BeastBase = (struct Library *)OpenLibrary("beast.library",0))
    {

      math_a_class   = BST_MakeClass( "MATH_aClass",   sizeof( struct math_a_Instance   ));
      CLSS_AddMethod( math_a_class,   &mth_a_Init,      OBM_INIT    );
      CLSS_AddMethod( math_a_class,   &mth_a_InputX,    OBM_INPUT   );
      CLSS_AddMethod( math_a_class,   &mth_a_OutputX,   OBM_OUTPUT  );
      CLSS_AddMethod( math_a_class,   &mth_a_SetAttr, 	OBM_SETATTR );
      BST_AddClass(   math_a_class   );

      math_x2_class = BST_MakeSubClass( "MATH_x2Class", sizeof( struct math_x2_Instance ), "MATH_aClass" );
      math_x_class  = BST_MakeSubClass( "MATH_xClass",  sizeof( struct math_x_Instance  ), "MATH_aClass" );
      math_xy_class = BST_MakeSubClass( "MATH_xyClass", sizeof( struct math_xy_Instance ), "MATH_aClass" );

      CLSS_AddMethod( math_x2_class, &mth_x2_InputX,  OBM_INPUT   );
      CLSS_AddMethod( math_x_class,  &mth_x_InputX,   OBM_INPUT   );
      CLSS_AddMethod( math_xy_class, &mth_xy_Init,    OBM_INIT    );
      CLSS_AddMethod( math_xy_class, &mth_xy_InputY,  OBM_INPUT   );
      CLSS_AddMethod( math_xy_class, &mth_xy_OutputX, OBM_OUTPUT  );

      BST_AddClass(   math_x2_class );
      BST_AddClass(   math_x_class  );
      BST_AddClass(   math_xy_class );

      /***************************
       **** Now create the objects
       ****/
      math_x2_obj = OBJ_NewObject( NULL, "MATH_x2Class", NULL );
      if (math_x2_obj != NULL)
      {
	math_x_obj = OBJ_NewObject( NULL, "MATH_xClass", NULL );
	if (math_x_obj != NULL)
	{
	  math_a_obj = OBJ_NewObject( NULL, "MATH_aClass", NULL );
	  if (math_a_obj != NULL)
	  {
	    math_xy_obj = OBJ_NewObject( NULL, "MATH_xyClass", NULL );
	    if (math_xy_obj != NULL)
	    {
	      OBJ_DoMethod( math_x2_obj, OBM_INIT, EmptyList, 0 );
	      OBJ_DoMethod( math_x_obj,  OBM_INIT, EmptyList, 0 );
	      OBJ_DoMethod( math_a_obj,  OBM_INIT, EmptyList, 0 );

	      /**** Create the connection (the actual program) ****
	       *
	       * The object connection will look like;
	       *
	       *
	       *     OBM_INPUT  ,--------------, OBM_OUTPUT
	       *  ,------------>| math_x2_obj  |------------,
	       *  |		`--------------'    	    |
	       *  |				    	    | OBM_INPUT
	       *  |  OBM_INPUT  ,--------------, OBM_OUTPUT \	,-------------, OBM_OUTPUT
	       *  |------------>| math_x_obj   |--------------->| math_xy_obj |---,
	       *  |		`--------------'	    /	`-------------'	  |
	       *  |					    |			  |
	       *  |  OBM_INPUT	,--------------, OBM_OUTPUT |			  |
	       *  |------------>| math_a_obj   |------------'			  |
	       *  |		`--------------'				  |
	       *  |								  |
	       *  `---------------------------------------------------------------'
	       *
	       *******************************************************/

	      OBJ_CreateConnection( math_x2_obj, math_xy_obj, OBM_OUTPUT, OBM_INPUT );
	      OBJ_CreateConnection( math_x_obj,  math_xy_obj, OBM_OUTPUT, OBM_INPUT );
	      OBJ_CreateConnection( math_a_obj,  math_xy_obj, OBM_OUTPUT, OBM_INPUT );
	      OBJ_CreateConnection( math_xy_obj, math_x2_obj, OBM_OUTPUT, OBM_INPUT );
	      OBJ_CreateConnection( math_xy_obj, math_x_obj,  OBM_OUTPUT, OBM_INPUT );
	      OBJ_CreateConnection( math_xy_obj, math_a_obj,  OBM_OUTPUT, OBM_INPUT );


	      /**** Setting our values ****/
	      { struct TagItem TL_SetAttr[] = { {BTA_NumberOf, 1}, {BTA_LongNumber, 1}, {TAG_DONE, 0} };
	        OBJ_DoMethod( math_x2_obj, OBM_SETATTR, TL_SetAttr, 0 ); }
	      { struct TagItem TL_SetAttr[] = { {BTA_NumberOf, 1}, {BTA_LongNumber, 1}, {TAG_DONE, 0} };
	        OBJ_DoMethod( math_x_obj,  OBM_SETATTR, TL_SetAttr, 0 ); }
	      { struct TagItem TL_SetAttr[] = { {BTA_NumberOf, 1}, {BTA_LongNumber, 4}, {TAG_DONE, 0} };
	        OBJ_DoMethod( math_a_obj,   OBM_SETATTR, TL_SetAttr, 0 ); }

	      { struct TagItem TL_SetAttr[] = { {BTA_NumberOf, 1}, {BTA_LongNumber, 2}, {TAG_DONE, 0} };
	        OBJ_DoMethod( math_xy_obj,  OBM_SETATTR, TL_SetAttr, 0 ); }

	      /**** Play around ****/
	      { struct TagItem TL_Start[] = { {TAG_DONE, 0} };
	        OBJ_DoMethod( math_xy_obj, OBM_OUTPUT, TL_Start, 0 ); }

	    }
	  }
	}
      }

      /**************************
       **** Get rid of our object
       ****/
      OBJ_DisposeObject( math_x2_obj );
      OBJ_DisposeObject( math_x_obj  );
      OBJ_DisposeObject( math_a_obj  );
      OBJ_DisposeObject( math_xy_obj );

      /***********************
       **** Remove the classes
       ****/
      BST_RemoveClass( math_xy_class );
      BST_RemoveClass( math_a_class  );
      BST_RemoveClass( math_x_class  );
      BST_RemoveClass( math_x2_class );

      BST_FreeClass(   math_xy_class );
      BST_FreeClass(   math_a_class  );
      BST_FreeClass(   math_x_class  );
      BST_FreeClass(   math_x2_class );

      CloseLibrary( BeastBase );
    }
  printf("*** Beast OO Example3 END ***\n");
}
