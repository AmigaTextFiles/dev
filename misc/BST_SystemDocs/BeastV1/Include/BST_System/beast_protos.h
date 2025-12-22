#ifndef  BEAST_PROTOS_H
#define  BEAST_PROTOS_H

/****h* Beast/Beast_Protos.h [0.1b]
*
*  NAME
*    Beast_protos.h -- beast prototypes
*
*  COPYRIGHT
*    Maverick Software Development 1995
*
***************************************
*/

#include <BEAST:Include/BST_System/beast.h>
#include <utility/tagitem.h>

struct BST_Class *BST_MakeClass   (char *, ULONG) ;
void              BST_AddClass    (struct BST_Class *) ;
void              BST_RemoveClass (struct BST_Class *) ;
void              BST_FreeClass   (struct BST_Class *) ;

struct BST_Class        *CLSS_AddMethod     (struct BST_Class *, ULONG *, BST_Method) ;
struct class_MethodList *CLSS_FindMethod    (struct BST_Class *, BST_Method );
void                     CLSS_DisposeMethod (struct BST_Class *, ULONG *, BST_Method );
struct clss_InputLink   *CLSS_AddInput      (struct BST_Class *, char *, BST_Method );
struct clss_OutputLink  *CLSS_AddOutput     (struct BST_Class, char *, BST_Method );
void                     CLSS_RemoveInput   (struct clss_InputLink  * );
void                     CLSS_RemoveOutput  (struct clss_OutputLink * );

struct BST_Object *OBJ_NewObject        (struct BST_Class *, char *, struct BST_Object * );
void               OBJ_DisposeObject    (struct BST_Object * );
struct BST_Object *OBJ_DestroyObject    (struct BST_Object *, BST_MethodFlags );
BST_MethodFlags    OBJ_DoMethod         (struct BST_Object *, BST_Method, struct TagItem *, BST_MethodFlags );
BST_MethodFlags    OBJ_MethodToChildren (struct BST_Object *, BST_Method, struct TagItem *, BST_MethodFlags );
BST_MethodFlags    OBJ_MethodToParent   (struct BST_Object *, BST_Method, struct TagItem *, BST_MethodFlags );

struct obj_OutputLink *OBJ_CreateConnection( struct BST_Object *, struct BST_Object *, BST_Method, BST_Method );
void		       OBJ_RemoveConnection( struct obj_OutputLink * );
BST_MethodFlags    OBJ_ToOutput         (struct BST_Object *, struct TagItem *, BST_Method, BST_MethodFlags );
BST_MethodFlags    OBJ_FromInput	(struct BST_Object *, BST_Method, BST_MethodFlags, struct TagItem * );

void		BST_SetDelayedDispose	( struct BST_Object * );
void		BST_DelayedDispose	( void );

struct TagItem *BST_FindTagItem          (ULONG, struct TagItem *) ;
struct TagItem *BST_NextTagItem          (struct TagItem *) ;
void            BST_ApplyTagChanges      (struct TagItem *, struct TagItem *) ;
struct TagItem *BST_CloneTagItems        (struct TagItem *) ;
void            BST_FreeTagItems         (struct TagItem *) ;
void            BST_TagListGETATTRParent (struct TagItem *, struct TagItem *, struct BST_Object *) ;
void            BST_FillAttrTagList      (struct TagItem *, Tag *, ULONG) ;

struct BST_Class *BST_MakeSubClass( char *, ULONG, char * );
void		BST_ForceDestroyBeast	( void );

struct BST_Object *OBJ_CreateObject( char *, struct BST_Object *, struct TagItem * );


#endif	 /* BEAST_PROTOS_H */
