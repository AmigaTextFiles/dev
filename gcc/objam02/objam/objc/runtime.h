/*
** ObjectiveAmiga: Runtime internal declarations
** See GNU:lib/libobjam/ReadMe for details
*/


#ifndef __objc_runtime_INCLUDE_GNU
#define __objc_runtime_INCLUDE_GNU

#include <stdio.h>
#include <ctype.h>

#include <stdarg.h>
#include <stddef.h>
#include <assert.h>

#include <objc/objc.h>		/* core data types */
#include <objc/objc-api.h>	/* runtime api functions */

#include <objc/list.h>		/* linear lists */

extern void __objc_add_class_to_hash(OCClass*);                 /* (objc-class.c)     */
extern void __objc_init_selector_tables();                      /* (objc-sel.c)       */
extern void __objc_init_class_tables();                         /* (objc-class.c)     */
extern void __objc_init_dispatch_tables();                      /* (objc-dispatch.c)  */
extern void __objc_install_premature_dtable(OCClass*);          /* (objc-dispatch.c)  */
extern void __objc_resolve_class_links();                       /* (objc-class.c)     */
extern void __objc_register_selectors_from_class(OCClass*);     /* (objc-sel.c)       */
extern void __objc_update_dispatch_table_for_class (OCClass*);  /* (objc-msg.c)       */
extern void class_add_method_list(OCClass*, MethodList_t);

/* True when class links has been resolved */     
extern BOOL __objc_class_links_resolved;

/* Number of selectors stored in each of the selector tables */
extern int __objc_selector_max_index;

#ifdef DEBUG
#define DEBUG_PRINTF printf
#else
#define DEBUG_PRINTF
#endif 

BOOL __objc_responds_to (id object, SEL sel); /* for internal use only! */

#endif /* not __objc_runtime_INCLUDE_GNU */
