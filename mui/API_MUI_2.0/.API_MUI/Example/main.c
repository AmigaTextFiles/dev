/* -----------------------------------------------------------------------------

  < How its works ... >

*/

/* includes */

#include <stdio.h>
#include <stdlib.h>
#include <proto/api_mui.h>

/* prototypes */

extern int main(int argc, char **argv);

#ifndef __AROS__
struct Library *MUIMasterBase;
#endif

/* example struct */
struct MsgData
	{
	ULONG MethodID;
	APTR data;
	};

struct ClassData
	{
	int	Test1;
	int	Test2;
	};

/*
#### hooks ####

HOOK(name, ptr_obj, ptr_msg)

< variable >
	struct Hook *hook
	ptr_obj obj
	ptr_msg msg

< hook code >

HOOK_END(RetValue)
*/

HOOK_h(testhook);
struct Hook *test = HOOK_REF(testhook);

HOOK (testhook, Object*, struct MsgData*)
HOOK_END(0);

/*** methods and class ***/

#define ID_test 123
/*
#### method class ####

CLASS_METHOD(ClassName, ID, msg_type)

<variable >
	Class *cl
	Object *obj
	msg_type msg

< method code >

CLASS_METHOD_END(RetValue)
*/

CLASS_METHOD(testclass, ID_test, struct MsgData*)
CLASS_METHOD_END(0);

/*
#### dispatcher ####

DISPATCHER(ClassName)

< variable >
	struct IClass *cl
	Object *obj
	Msg msg

CALL_METHOD(ClassName, ID, msg_type)

DISPATCHER_END
*/

DISPATCHER(testclass)
DISPATCHER_BEGIN
CALL_METHOD(testclass, ID_test, struct MsgData*);
DISPATCHER_END;

/*
#### build/remove mui class ####

struct MUI_CustomClass *CREATEEXTERNALCLASS(ClassName, base,         ClassStructData)
struct MUI_CustomClass *CREATEPUBLICCLASS  (ClassName, parent_name,  ClassStructData)
struct MUI_CustomClass *CREATELOCALCLASS   (ClassName, parent_class, ClassStructData)

DELETECUSTOMCLASS(struct MUI_CustomClass *mui_class)

*/

/* main code */
int
main(int argc, char **argv)
{
struct MUI_CustomClass *mui_class;

    puts("hello world!");

/* create mui class */
if ((mui_class=CREATEPUBLICCLASS(testclass, MUIC_Window, struct ClassData)))
	{

/* delete mui class */
	DELETECUSTOMCLASS(mui_class);
	};

return(0);
}                                       
