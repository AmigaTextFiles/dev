/* ========================================================================== **
 *                                ubi_sample.c
 * ========================================================================== **
 * Written by Chris Hertel.
 * ========================================================================== **
 *
 *  $Log: ubi_sample.c,v $
 *  Revision 0.2  1997/07/26 05:03:37  crh
 *  Added code to print the module information.
 *
 *  Revision 0.1  1997/06/03 04:38:45  crh
 *  Initial Revision.
 *
 *
 * ========================================================================== **
 */
#include <stdio.h>              /* Standard I/O.     */
#include <string.h>             /* String functions. */
#include <stdlib.h>             /* Standard C library header. */
#include <errno.h>              /* Error handling.   */

/* Note: Only one of the headers below should be included.  Comment out all
 *       but one.  This determines which type of tree balancing you are using.
 */

/*#include "ubi_BinTree.h"        /* Binary tree module. */
#include "ubi_AVLtree.h"        /* AVL tree module.    */
/*#include "ubi_SplayTree.h"      /* Splay tree module.  */

/* -------------------------------------------------------------------------- **
 * Constants...
 *
 * Just some numbers we need.
 */

#define NAMESIZE 240

/* -------------------------------------------------------------------------- **
 * Typedefs...
 *
 *  Note: ulong is an unsigned long, oolong is a tea.
 *
 *  SampleRec    - This is the sample data record with which we will be
 *                 playing.  It starts with a ubi_trNode structure (so that
 *                 the tree functions can fiddle with it), the rest is data.
 *                 In this case, we're just using a fixed-length character
 *                 array.  In a "real" program, you could have all sorts
 *                 of stuff.
 *  SampleRecPtr - A pointer to a SampleRec.
 */

typedef unsigned long ulong;

typedef struct {
  ubi_trNode Node;
  char       Name[NAMESIZE];
  } SampleRec;

typedef SampleRec *SampleRecPtr;

/* -------------------------------------------------------------------------- **
 * Global Variables...
 *
 *  We'll declare our tree header globally.  The structure is called a
 *  ubi_trRoot, but it's really a housekeeping header with a pointer to the
 *  tree's root node.
 *
 *  Root    - The tree header.
 *  RootPtr - A pointer to the tree header.
 */

static ubi_trRoot    Root;
static ubi_trRootPtr RootPtr = &Root;

/* -------------------------------------------------------------------------- **
 * Functions...
 */

static int CompareFunc( ubi_trItemPtr ItemPtr, ubi_trNodePtr NodePtr )
  /* ------------------------------------------------------------------------ **
   * If we are going to sort the data, we will need to be able to compare the
   * data.  That's what this function does.  A pointer to this function will
   * be stored in the tree header.
   *
   *  Input:  ItemPtr - A pointer to the comparison data record.
   *                    Take a look at the Insert(), Find() and Locate()
   *                    functions.  They all take a parameter of type
   *                    ubi_trItemPtr.  This is a pointer to the data to be
   *                    compared.  In Find() and Locate(), it's a value that
   *                    you want to find within the tree.  In Insert() it's
   *                    a pointer to the part of the new node that contains
   *                    the data to be compared.
   *          NodePtr - This is a pointer to a node in the tree.
   *  Output: An integer in one of three ranges:
   *          < 0 indicates ItemPtr < (the data contained in) NodePtr
   *          = 0 indicates ItemPtr = (the data contained in) NodePtr
   *          > 0 indicates ItemPtr > (the data contained in) NodePtr
   * ------------------------------------------------------------------------ **
   */
  {
  char *A, *B;

  A = (char *)ItemPtr;                /* Find the comparison data indicated
                                       * by ItemPtr.  In our case, the data
                                       * is a string, and ItemPtr already
                                       * points to it.  We simply typecast
                                       * ItemPtr to the correct pointer type.
                                       * This is typically what you would
                                       * need to do.
                                       */
  B = ((SampleRecPtr)NodePtr)->Name;  /* Find the data connected to the node
                                       * that is in the tree.  Remember that
                                       * this function gets a pointer to the
                                       * ubi_trNode structure.  Convert the
                                       * Node pointer to a pointer to our
                                       * record type, then find the data item
                                       * within that node.
                                       */
  return( strcmp( A, B ) );           /* Now compare and return the result. */
  } /* CompareFunc */

static void PrintNode( ubi_trNodePtr NodePtr, void *Userdata )
  /* ------------------------------------------------------------------------ **
   * Print out the contents of a record stored in the tree.
   *  Input:  NodePtr  - A pointer to the Node structure part of a record.
   *          UserData - In this program, we're using this to pass in a
   *                     a pointer to an integer.
   * ------------------------------------------------------------------------ **
   */
  {
  SampleRecPtr RecPtr;
  int         *IntPtr;

  RecPtr = (SampleRecPtr)NodePtr; /* RecPtr now points to the entire record. */
  IntPtr = (int *)Userdata;       /* IntPtr points to the integer.           */

  (*IntPtr)++;              /* Increment the integer indicated via Userdata. */
  (void)printf( "%d: %s\n", *IntPtr, RecPtr->Name );
  } /* PrintNode */

static void KillNode( ubi_trNodePtr NodePtr )
  /* ------------------------------------------------------------------------ **
   * Free the memory associated with a node (free the entire record).
   *  Input:  NodePtr  - A pointer to a node in the tree.
   * ------------------------------------------------------------------------ **
   */
  {
  /* This could be very complicated if your data portion includes pointers to
   * all sorts of other allocated memory.  In our case, it's quite simple.
   */
  free( NodePtr );
  } /* KillNode */

int main( int argc, char *argv[] )
  /* ------------------------------------------------------------------------ **
   * Program main line.
   * ------------------------------------------------------------------------ **
   */
  {
  char          s[1024];
  SampleRecPtr  RecPtr;
  int           i;
  char         *ModInfo[2];

  for( i = ubi_trModuleID( 2, ModInfo ); i > 0; )
    (void)printf( "%s", ModInfo[--i] );

  (void)ubi_trInitTree( RootPtr,      /* Pointer to the tree header           */
                        CompareFunc,  /* Pointer to the comparison function.  */
                        0 );          /* Don't allow overwrites or duplicates.*/
                                      /* See the Insert() notes in BinTree.h. */

  (void)printf( "Input string (blank line to exit)> " );
  while( gets( s ) && strlen(s) )
    {
    /* Allocate a new node to be added to the tree. */
    RecPtr = (SampleRecPtr)malloc( sizeof(SampleRec) );
    if( !RecPtr )
      {
      perror( "main" );
      exit( EXIT_FAILURE );
      }

    /* Copy the new data into the record. */
    s[NAMESIZE-1] = '\0';             /* Make sure the string is short enough.*/
    (void)strcpy( RecPtr->Name, s );  /* Copy the string into our new record. */

    /* Add the record to the tree. */
    if( !ubi_trInsert( RootPtr,       /* To which tree are we adding this?    */
                       RecPtr,        /* The new node to be added.            */
                       RecPtr->Name,  /* Points to the comparison field.      */
                       NULL )         /* Overwrites are not allowed.          */
      )
      {
      (void)fprintf( stderr, "Error: Duplicate key.  Record not added.\n" );
      free( RecPtr );
      }
    (void)printf( "Input string (blank line to exit)> " );
    }

  /* Now that the tree is full, dump it in sorted order. */
  i = 0;
  (void)ubi_trTraverse( RootPtr,    /* Tree root pointer. */
                        PrintNode,  /* Pointer to function that prints out
                                     * record contents.
                                     */
                        &i );       /* Userdata is typically not needed.
                                     * This is an example of what you can
                                     * do with it.
                                     */
  (void)printf( "A total of %d records found.\n", i );

  /* Now free all nodes in the tree. */
  (void)ubi_trKillTree( RootPtr,    /* Tree root pointer. */
                        KillNode ); /* Function that frees the node. */
  return( EXIT_SUCCESS );
  } /* main */

/* ========================================================================== */
