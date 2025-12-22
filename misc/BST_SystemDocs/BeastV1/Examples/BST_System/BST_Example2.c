
/****h* Beast/BST_Example2.c [1.0] **************
*
*	NAME
*	  BST_Example2 --
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
#include <BEAST:Include/proto/Beast.h>
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
struct math_ax2_Instance
{
	LONG	A;
};
struct math_bx_Instance
{
	LONG	B;
};
struct math_c_Instance
{
	LONG	C;
};
struct math_xy_Instance
{
	LONG	X,Y;
};


/***************************************************************************
 ===========================================================================
 **** MATH_ax2_Class methods
 ***************************/
__geta4 rfcall (mth_ax2_Init, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_ax2_Instance *Instance = Macro_GetInstance;

  Instance->A = 1;
  return( MethodFlags );
}



/**********************************************
 ----------------------------------------------
 **** Method called when a new X number arrives
 ****/
__geta4 rfcall (mth_ax2_InputX, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_ax2_Instance *Instance = Macro_GetInstance;
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
      MethodFlags = OBJ_ToOutput( Object,TL_Output, OBM_OUTPUT, 0 );
    }

  return( MethodFlags );
}



/***************************************************************
 ---------------------------------------------------------------
 **** Method called the object connected to this method requests
 **** for new input.
 ****/
__geta4 rfcall (mth_ax2_OutputX, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_ax2_Instance *Instance = Macro_GetInstance;

  /**************************************************************
   **** We don't cache the A*X*X result so, get it from our input
   ****/
  OBJ_FromInput( Object, OBM_INPUT, 0, EmptyList );
  return( MethodFlags );
}



/*****************************************************************
 -----------------------------------------------------------------
 **** Method call to set some attributes
 **** Note: This routine is a little bit overdone, but it's a demo
 ****/
__geta4 rfcall (mth_ax2_SetAttr, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_ax2_Instance *Instance = Macro_GetInstance;

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
	  case BTA_LongNumber: Instance->A = cur_ti->ti_Data;  break;
          default	    : nr_attr++;
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
 **** MATH_bx_Class methods
 **************************/
__geta4 rfcall (mth_bx_Init, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_bx_Instance *Instance = Macro_GetInstance;

  Instance->B = 1.0;
  return( MethodFlags );
}



/**********************************************
 ----------------------------------------------
 **** Method called when a new X number arrives
 ****/
__geta4 rfcall (mth_bx_InputX, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_bx_Instance *Instance = Macro_GetInstance;
  struct TagItem 	  *cur_ti;

  /******************************
   **** Search for the BTA_X tag.
   ****/
  if ( cur_ti = BST_FindTagItem( BTA_X, TagList ))
    {
      LONG X = cur_ti->ti_Data;

      struct TagItem TL_Output[] =
  	{ {BTA_Y, (Instance->B * X)},		/**** Calculate B * X   ****/
	  {TAG_DONE, 0}
  	};
      MethodFlags = OBJ_ToOutput( Object,TL_Output, OBM_OUTPUT, 0 );
    }

  return( MethodFlags );
}



/***************************************************************
 ---------------------------------------------------------------
 **** Method called the object connected to this method requests
 **** for new input.
 ****/
__geta4 rfcall (mth_bx_OutputX, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct my_bx_Instance *Instance = Macro_GetInstance;

  /************************************************************
   **** We don't cache the B*X result so, get it from our input
   ****/
  OBJ_FromInput( Object, OBM_INPUT, 0, EmptyList );
  return( MethodFlags );
}



/*****************************************************************
 -----------------------------------------------------------------
 **** Method call to set some attributes
 **** Note: This routine is a little bit overdone, but it's a demo
 ****/
__geta4 rfcall (mth_bx_SetAttr, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_bx_Instance *Instance = Macro_GetInstance;

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
	  case BTA_LongNumber: Instance->B = cur_ti->ti_Data;  break;
          default	    : nr_attr++;
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
 **** MATH_c_Class methods
 *************************/
__geta4 rfcall (mth_c_Init, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_c_Instance *Instance = Macro_GetInstance;

  Instance->C = 0.0;
  return( MethodFlags );
}



/**********************************************
 ----------------------------------------------
 **** Method called when a new X number arrives
 ****/
__geta4 rfcall (mth_c_InputX, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_c_Instance *Instance = Macro_GetInstance;

  struct TagItem TL_Output[] =
    { {BTA_Y,    Instance->C},
      {TAG_DONE, 0}
    };
  MethodFlags = OBJ_ToOutput( Object,TL_Output, OBM_OUTPUT, 0 );

  return( MethodFlags );
}



/***************************************************************
 ---------------------------------------------------------------
 **** Method called the object connected to this method requests
 **** for new input.
 ****/
__geta4 rfcall (mth_c_OutputX, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
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
__geta4 rfcall (mth_c_SetAttr, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_c_Instance *Instance = Macro_GetInstance;

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
	  case BTA_LongNumber: 	Instance->C = cur_ti->ti_Data;  break;
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
 **** MATH_xy_Class methods
 **************************/
__geta4 rfcall (mth_xy_Init, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_xy_Instance *Instance = Macro_GetInstance;

  Instance->X = 0.0;
  Instance->Y = 0.0;
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
      Instance->Y = Instance->Y + cur_ti->ti_Data;
    }

  return( MethodFlags );
}



/***************************************************************
 ---------------------------------------------------------------
 **** Method called the object connected to this method requests
 **** for new input.
 ****/
__geta4 rfcall (mth_xy_OutputX, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_xy_Instance *Instance = Macro_GetInstance;

  Instance->Y = 0;	/**** Reset the result ****/

  struct TagItem TL_Output[] =
    { {BTA_X, Instance->X},
      {TAG_DONE, 0}
    };
  MethodFlags = OBJ_ToOutput( Object, TL_Output, OBM_OUTPUT, 0 );

  printf("**** Y result = %ld \n", Instance->Y );

  return( MethodFlags );
}



/*****************************************************************
 -----------------------------------------------------------------
 **** Method call to set some attributes
 **** Note: This routine is a little bit overdone, but it's a demo
 ****/
__geta4 rfcall (mth_xy_SetAttr, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
  struct math_xy_Instance *Instance = Macro_GetInstance;

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
	  case BTA_X: Instance->X = cur_ti->ti_Data;  break;
          default   : nr_attr++;
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




/*********************************/
/**** M A I N - P R O G R A M ****/
/*********************************/
main()
{
  struct BST_Class  *math_ax2_class, *math_bx_class, *math_c_class, *math_xy_class;
  struct BST_Object *math_ax2_obj,   *math_bx_obj,   *math_c_obj,   *math_xy_obj;
  
  printf("*** Beast OO Example2 START ***\n");
  if (BeastBase = (struct Library *)OpenLibrary("beast.library",0))
    {

      math_ax2_class = BST_MakeClass( "MATH_ax2Class", sizeof( struct math_ax2_Instance ));
      math_bx_class  = BST_MakeClass( "MATH_bxClass",  sizeof( struct math_bx_Instance  ));
      math_c_class   = BST_MakeClass( "MATH_cClass",   sizeof( struct math_c_Instance   ));
      math_xy_class  = BST_MakeClass( "MATH_xyClass",  sizeof( struct math_xy_Instance  ));


      CLSS_AddMethod( math_ax2_class, &mth_ax2_Init,    OBM_INIT    );
      CLSS_AddMethod( math_ax2_class, &mth_ax2_InputX,  OBM_INPUT   );
      CLSS_AddMethod( math_ax2_class, &mth_ax2_OutputX, OBM_OUTPUT  );
      CLSS_AddMethod( math_ax2_class, &mth_ax2_SetAttr, OBM_SETATTR );
      CLSS_AddMethod( math_bx_class,  &mth_bx_Init,     OBM_INIT    );
      CLSS_AddMethod( math_bx_class,  &mth_bx_InputX,   OBM_INPUT   );
      CLSS_AddMethod( math_bx_class,  &mth_bx_OutputX,  OBM_OUTPUT  );
      CLSS_AddMethod( math_bx_class,  &mth_bx_SetAttr, 	OBM_SETATTR );
      CLSS_AddMethod( math_c_class,   &mth_c_Init,      OBM_INIT    );
      CLSS_AddMethod( math_c_class,   &mth_c_InputX,    OBM_INPUT   );
      CLSS_AddMethod( math_c_class,   &mth_c_OutputX,   OBM_OUTPUT  );
      CLSS_AddMethod( math_c_class,   &mth_c_SetAttr, 	OBM_SETATTR );
      CLSS_AddMethod( math_xy_class,  &mth_xy_Init,     OBM_INIT    );
      CLSS_AddMethod( math_xy_class,  &mth_xy_InputY,   OBM_INPUT   );
      CLSS_AddMethod( math_xy_class,  &mth_xy_OutputX,  OBM_OUTPUT  );
      CLSS_AddMethod( math_xy_class,  &mth_xy_SetAttr, 	OBM_SETATTR );


      BST_AddClass(   math_ax2_class );
      BST_AddClass(   math_bx_class  );
      BST_AddClass(   math_c_class   );
      BST_AddClass(   math_xy_class  );

      /***************************
       **** Now create the objects
       ****/
      math_ax2_obj = OBJ_NewObject( NULL, "MATH_ax2Class", NULL );
      if (math_ax2_obj != NULL)
      {
	math_bx_obj = OBJ_NewObject( NULL, "MATH_bxClass", NULL );
	if (math_bx_obj != NULL)
	{
	  math_c_obj = OBJ_NewObject( NULL, "MATH_cClass", NULL );
	  if (math_c_obj != NULL)
	  {
	    math_xy_obj = OBJ_NewObject( NULL, "MATH_xyClass", NULL );
	    if (math_xy_obj != NULL)
	    {
	      OBJ_DoMethod( math_ax2_obj, OBM_INIT, EmptyList, 0 );
	      OBJ_DoMethod( math_bx_obj,  OBM_INIT, EmptyList, 0 );
	      OBJ_DoMethod( math_c_obj,   OBM_INIT, EmptyList, 0 );

	      /**** Create the connection (the actual program) ****
	       *
	       * The object connection will look like;
	       *
	       *
	       *     OBM_INPUT  ,--------------, OBM_OUTPUT
	       *  ,------------>| math_ax2_obj |------------,
	       *  |		`--------------'    	    |
	       *  |				    	    | OBM_INPUT
	       *  |  OBM_INPUT  ,--------------, OBM_OUTPUT \	,-------------, OBM_OUTPUT
	       *  |------------>| math_bx_obj  |--------------->| math_xy_obj |---,
	       *  |		`--------------'	    /	`-------------'	  |
	       *  |					    |			  |
	       *  |  OBM_INPUT	,--------------, OBM_OUTPUT |			  |
	       *  |------------>| math_c_obj   |------------'			  |
	       *  |		`--------------'				  |
	       *  |								  |
	       *  `---------------------------------------------------------------'
	       *
	       *******************************************************/

	      OBJ_CreateConnection( math_ax2_obj, math_xy_obj,  OBM_OUTPUT, OBM_INPUT );
	      OBJ_CreateConnection( math_bx_obj,  math_xy_obj,  OBM_OUTPUT, OBM_INPUT );
	      OBJ_CreateConnection( math_c_obj,   math_xy_obj,  OBM_OUTPUT, OBM_INPUT );
	      OBJ_CreateConnection( math_xy_obj,  math_ax2_obj, OBM_OUTPUT, OBM_INPUT );
	      OBJ_CreateConnection( math_xy_obj,  math_bx_obj,  OBM_OUTPUT, OBM_INPUT );
	      OBJ_CreateConnection( math_xy_obj,  math_c_obj,   OBM_OUTPUT, OBM_INPUT );


	      /**** Setting our values ****/
	      { struct TagItem TL_SetAttr[] = { {BTA_NumberOf, 1}, {BTA_LongNumber, 1}, {TAG_DONE, 0} };
	        OBJ_DoMethod( math_ax2_obj, OBM_SETATTR, TL_SetAttr, 0 ); }
	      { struct TagItem TL_SetAttr[] = { {BTA_NumberOf, 1}, {BTA_LongNumber, 1}, {TAG_DONE, 0} };
	        OBJ_DoMethod( math_bx_obj,  OBM_SETATTR, TL_SetAttr, 0 ); }
	      { struct TagItem TL_SetAttr[] = { {BTA_NumberOf, 1}, {BTA_LongNumber, 4}, {TAG_DONE, 0} };
	        OBJ_DoMethod( math_c_obj,   OBM_SETATTR, TL_SetAttr, 0 ); }

	      { struct TagItem TL_SetAttr[] = { {BTA_NumberOf, 1}, {BTA_X, 2}, {TAG_DONE, 0} };
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
      OBJ_DisposeObject( math_ax2_obj );
      OBJ_DisposeObject( math_bx_obj  );
      OBJ_DisposeObject( math_c_obj   );
      OBJ_DisposeObject( math_xy_obj  );

      /***********************
       **** Remove the classes
       ****/
      BST_RemoveClass( math_xy_class  );
      BST_RemoveClass( math_c_class   );
      BST_RemoveClass( math_bx_class  );
      BST_RemoveClass( math_ax2_class );

      BST_FreeClass(   math_xy_class  );
      BST_FreeClass(   math_c_class   );
      BST_FreeClass(   math_bx_class  );
      BST_FreeClass(   math_ax2_class );

      CloseLibrary( BeastBase );
    }
  printf("*** Beast OO Example2 END ***\n");
}
