
/****h* Beast/BST_Example1.c [1.0] **************
*
*	NAME
*	  BST_Example1 --
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


/************************************************************
 ***** my class instance definition, only used for sizeof()!!
 *****/
struct my_class_Instance
{
	LONG	X;
	LONG	Y;
};


/***************************************************************************
 **** OBM_INIT method : use the rfcall() macro to define the method function
 ****/
__geta4 rfcall (my_init, BST_MethodFlags MethodFlags, struct BST_Object *Object, struct TagItem *TagList)
{
	/****************************************************
	 **** Get pointer to the Instance
	 **** Use it always in this way, caching the Instance
	 **** pointer is _not_ good practice.
	 ****/
	struct my_class_Instance *Instance = Macro_GetInstance;


	/***************************
	 **** Set the default values
	 ****/
	Instance->X = 1;
	Instance->Y = 1;
	
	printf("=== Init method %lx %lx %lx\n", MethodFlags, Object, TagList );
	printf("=== X = %ld, Y = %ld \n", Instance->X, Instance->Y );

	/*********************************************
	 **** IMPORTANT: return always the MethodFlags
	 **** The method may alter the MethodFlags.
	 ****/
	return( MethodFlags );
}


/*********************************/
/**** M A I N - P R O G R A M ****/
/*********************************/
main()
{
  struct BST_Class  *my_class;
  struct BST_Object *my_object;

  printf("*** Beast OO Example1 START ***\n");
  if (BeastBase = (struct Library *)OpenLibrary("beast.library",0))
    {
      /********************
       **** Create my_class
       ****/
      my_class = BST_MakeClass( "my_firstclass", sizeof( struct my_class_Instance ));
      CLSS_AddMethod( my_class, &my_init, OBM_INIT );
      BST_AddClass(   my_class );

      printf("*** my_firstclass created = %lx ***\n", my_class );

      /*************************
       **** Now create an object
       ****/
      my_object = OBJ_NewObject( NULL, "my_firstclass", NULL );
      if (my_object != NULL)
	{
	  printf("*** my_first Object created = %lx ***\n", my_object );

	  /********************************
	   **** Trigger the OBM_INIT method
	   ****/
	  OBJ_DoMethod( my_object, OBM_INIT, EmptyList, 0 );

	}

      /**************************
       **** Get rid of our object
       ****/
      OBJ_DisposeObject( my_object );


      /********************
       **** Remove my_class
       ****/
      BST_RemoveClass( my_class );
      BST_FreeClass(   my_class );

      CloseLibrary( BeastBase );
    }
  printf("*** Beast OO Example1 END ***\n");
}
