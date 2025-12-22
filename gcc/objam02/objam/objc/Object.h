/*
** ObjectiveAmiga: Interface for the Object class for Objective-C
** See GNU:lib/libobjam/ReadMe for details
*/


#ifndef __object_INCLUDE_GNU
#define __object_INCLUDE_GNU

#include <objc/objc.h>
#include <objc/typedstream.h>

/*
 * All classes are derived from Object.  As such,
 * this is the overhead tacked onto those objects.
 */

@interface Object
{
  OCClass* isa;           // A pointer to the instance's class structure
}

        /* Initializing the class */
+ initialize;

        /* Creating, copying and freeing instances */
+ alloc;
+ allocFromZone:(NXZone *)zone; // NeXT only
+ new;
- copy;
- copyFromZone:(NXZone *)zone;  // NeXT only
- (NXZone *)zone;               // NeXT only
- free;
- shallowCopy;                  // GNU only
- deepen;                       // GNU only
- deepCopy;                     // GNU only

        /* Initializing a new instance */
- init;

        /* Identifying classes */
- (OCClass*)class;
- (OCClass*)superclass;   // NeXT only
- (OCClass*)superClass;   // GNU only
- (MetaClass*)metaClass;  // GNU only

        /* Identifying and comparing instances */
- (BOOL)isEqual:anObject;
- (unsigned int)hash;
- self;
- (const char *)name;
- (void)printForDebugger;     // NeXT only //-- - (void)printForDebugger:(NXStream *)stream;
- (int)compare:anotherObject; // GNU only

        /* Testing object type (GNU only) */
- (BOOL)isMetaClass;  // GNU only
- (BOOL)isClass;      // GNU only
- (BOOL)isInstance;   // GNU only

        /* Testing inheritance relationships */
- (BOOL)isKindOf:(OCClass*)aClassObject;
- (BOOL)isKindOfClassNamed:(const char *)aClassName;
- (BOOL)isMemberOf:(OCClass*)aClassObject;
- (BOOL)isMemberOfClassNamed:(const char *)aClassName;

        /* Testing class functionality */
- (BOOL)respondsTo:(SEL)aSel;
+ (BOOL)instancesRespondTo:(SEL)aSel;

        /* Testing for protocol conformance */
- (BOOL)conformsTo:(Protocol*)aProtocol;

        /* Sending messages determined at run time */
- perform:(SEL)aSel;
- perform:(SEL)aSel with:anObject;
- perform:(SEL)aSel with:anObject1 with:anObject2;

        /* Forwarding messages */
- forward:(SEL)aSel :(arglist_t)argFrame;
- performv:(SEL)aSel :(arglist_t)argFrame;

        /* Obtaining method information (GNU calls it 'Introspection') */
- (IMP)methodFor:(SEL)aSel;
+ (IMP)instanceMethodFor:(SEL)aSel;
- (struct objc_method_description *)descriptionForMethod:(SEL)aSel;
+ (struct objc_method_description *)descriptionForInstanceMethod:(SEL)aSel;

        /* Posing */
+ poseAs:(OCClass*)aClassObject;
- (OCClass*)transmuteClassTo:(OCClass*)aClassObject;  // GNU only

        /* Enforcing intentions */
- notImplemented:(SEL)aSel;
- subclassResponsibility:(SEL)aSel;
- shouldNotImplement:(SEL)aSel; // GNU only

        /* Error handling */
- doesNotRecognize:(SEL)aSel;
- error:(const char *)aString, ...;

        /* Dynamic loading (NeXT only) */
//-- + finishLoading;  // NeXT only
//-- + startUnloading; // NeXT only

        /* Archiving */
- read: (TypedStream*)aStream;
- write: (TypedStream*)aStream;
//-- + startArchiving;     // NeXT only
- awake;
//-- + finishUnarchiving;  // NeXT only
+ setVersion:(int)aVersion;
+ (int)version;
+ (int)streamVersion: (TypedStream*)aStream;  // GNU only

@end


@interface Object (StepstoneArchiving) // Stepstone only

+ readFrom:(STR)aFile;
- (BOOL)storeOn:(STR)aFile;

@end


#endif
