/*
** ObjectiveAmiga: Declare the class Protocol for Objective C programs
** See GNU:lib/libobjam/ReadMe for details
*/


#ifndef __Protocol_INCLUDE_GNU
#define __Protocol_INCLUDE_GNU

#include <objc/Object.h>

@interface Protocol : Object
{
@private
        char *protocol_name;
        struct objc_protocol_list *protocol_list;
        struct objc_method_description_list *instance_methods, *class_methods; 
}

/* Obtaining attributes intrinsic to the protocol */

- (const char *)name;

/* Testing protocol conformance */

- (BOOL) conformsTo: (Protocol *)aProtocolObject;

/* Looking up information specific to a protocol */

- (struct objc_method_description *) descriptionForInstanceMethod:(SEL)aSel;
- (struct objc_method_description *) descriptionForClassMethod:(SEL)aSel;

@end

#endif __Protocol_INCLUDE_GNU
