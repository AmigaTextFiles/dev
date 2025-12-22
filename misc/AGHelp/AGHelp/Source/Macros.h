#ifndef MACROS_H
#define MACROS_H

/* Various useful macros, to hide compiler specific things
 * or otherwise make things more comfortable.
 */

#define REG(x)	register __ ## x
#define ASM	__asm
#define SAVEDS	__saveds

#define A0	register __a0
#define A1	register __a1
#define A2	register __a2
#define A3	register __a3
#define A4	register __a4
#define A5	register __a5
#define A6	register __a6

#define D0	register __d0
#define D1	register __d1
#define D2	register __d2
#define D3	register __d3
#define D4	register __d4
#define D5	register __d5
#define D6	register __d6
#define D7	register __d7


#define ThisProc()	( ( ( struct Process * ) FindTask( NULL ) ) )

#define GADGET(g)	( ( struct Gadget * ) g )
#define IMAGE(g)	( ( struct Image * ) g )

#define MIN(x,y)	( ( x ) < ( y ) ? ( x ) : ( y ) )
#define MAX(x,y)	( ( x ) > ( y ) ? ( x ) : ( y ) )


/* A private function, preferably inlined */
#define PRIVATEINLINE	__inline static

/* A private function, not necessarely inlined */
#define PRIVATE	static

/* A library function */
#define LIBFUNC	ASM


/* Macros useful in the private classes */

/* The Dispatch function header */
#define DISPATCH()	ASM PRIVATE ULONG \
Dispatch( A0 const Class *class, A2 const Object *object, A1 const Msg message )

/* Method function header. Method specifies the method name.
 * Msgtype specifies the structure type of the message structure.
 */
#define METHOD(method,msgtype)	PRIVATE ULONG \
Method_ ## method( const Class *class, const Object *object, const msgtype message )

/* Same as METHOD(), with one important difference: object is not declared
 * const. Thus, object can be re-used to store the newly created object
 * (on invocation it contains some private BOOPSI value..).
 */
#define METHOD_NEW(method,msgtype)	PRIVATE ULONG \
Method_ ## method( const Class *class, Object *object, const msgtype message )

/* Call above method definition. Only from the dispatcher (or another method)! */
#define CALLMETHOD(method)	Method_ ## method( class, object, ( APTR ) message )

/* Pass current message to super */
#define CALLSUPER()		DoSuperMethodA( class, object, ( Msg ) message )

/* Dispose current object from other method */
#define DISPOSESELF()	CoerceMethod( class, object, OM_DISPOSE ); object = NULL

/* Start switch for method selection */
#define SWITCHMETHOD()	switch( message->MethodID )

/* Entry for method switch case */
#define CASE(method,function)	case method: rc = CALLMETHOD(function); break;

/* Default entry for method switch case */
#define DEFAULT()	default: rc = CALLSUPER(); break;

/* Get the instant data, assuming DISPATCH or METHOD have been used */
#define DATA()	( ( APTR ) INST_DATA( class, object ) )

/* Set the class dispatcher to the DISPATCH() (Dispatch) function. */
#define SETDISPATCH(class)	class->cl_Dispatcher.h_Entry = ( HOOKFUNC ) Dispatch

/* Set the class userdata to the class base. */
#define SETBASE(cb)		cb->cb_Library.cl_Class->cl_UserData = ( LONG ) cb

/* Get the class userdata (assuming it is the class base). */
#define BASE()			( struct ClassBase * ) class->cl_UserData

/* Create a new class based on the private super */
#define MAKEPRIVCLASS(superid,super,type)	MakeClass( NULL, superid, super, sizeof( type ), 0 )


#endif /* MACROS_H */
