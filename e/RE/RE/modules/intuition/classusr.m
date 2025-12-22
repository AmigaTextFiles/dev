//Converting: ram:classusr.h
//dest: ram:classusr.m
#ifndef	INTUITION_CLASSUSR_H
#define INTUITION_CLASSUSR_H	1

#ifndef UTILITY_HOOKS_H
MODULE  'utility/hooks'
#endif

 	
->#define Object ULONG	
		
->#define ClassID PTR TO UBYTE


  OBJECT Msg

    MethodID:LONG
    
ENDOBJECT		

#define ROOTCLASS	'rootclass'		
#define IMAGECLASS	'imageclass'		
#define FRAMEICLASS	'frameiclass'
#define SYSICLASS	'sysiclass'
#define FILLRECTCLASS	'fillrectclass'
#define GADGETCLASS	'gadgetclass'		
#define PROPGCLASS	'propgclass'
#define STRGCLASS	'strgclass'
#define BUTTONGCLASS	'buttongclass'
#define FRBUTTONCLASS	'frbuttonclass'
#define GROUPGCLASS	'groupgclass'
#define ICCLASS		'icclass'		
#define MODELCLASS	'modelclass'
#define ITEXTICLASS	'itexticlass'
#define POINTERCLASS	'pointerclass'		

#define OM_Dummy	($100)
#define OM_NEW		($101)	
#define OM_DISPOSE	($102)	
#define OM_SET		($103)	
#define OM_GET		($104)	
#define OM_ADDTAIL	($105)	
#define OM_REMOVE	($106)	
#define OM_NOTIFY	($107)	
#define OM_UPDATE	($108)	
#define OM_ADDMEMBER	($109)	
#define OM_REMMEMBER	($10A)	


OBJECT opSet
 
    MethodID:LONG
    	AttrList:PTR TO TagItem	
    	GInfo:PTR TO GadgetInfo	
ENDOBJECT


OBJECT opUpdate
 
    MethodID:LONG
    	AttrList:PTR TO TagItem	
    	GInfo:PTR TO GadgetInfo	
    Flags:LONG	
ENDOBJECT


#define OPUF_INTERIM	(1<<0)

OBJECT opGet
 
    MethodID:LONG
    AttrID:LONG
    Storage:PTR TO LONG	
ENDOBJECT


OBJECT opAddTail
 
    MethodID:LONG
    		List:PTR TO List
ENDOBJECT


#define  opAddMember opMember
OBJECT opMember
 
    MethodID:LONG
    Object:PTR TO Object
ENDOBJECT

#endif
