OPT NATIVE
MODULE 'target/exec/lists'
{#include <aros/arossupportbase.h>}
NATIVE {AROS_AROSSUPPORTBASE_H} CONST

NATIVE {AROSSupportBase} OBJECT arossupportbase
    {StdOut}	stdout	:PTR
    {kprintf}	kprintf	:PTR /*int (*kprintf)(const char *, ...)*/
    {rkprintf}	rkprintf	:PTR /*int (*rkprintf)(const char *, const char *, int, const char *, ...)*/
    {vkprintf}	vkprintf	:PTR /*int (*vkprintf)(const char *, va_list)*/
    {DebugConfig}	debugconfig	:PTR
    {AllocMemList}	allocmemlist	:mlh
ENDOBJECT
