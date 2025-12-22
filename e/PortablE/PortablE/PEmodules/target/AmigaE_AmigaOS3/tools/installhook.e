OPT NATIVE, INLINE
MODULE 'utility/hooks'
{MODULE 'tools/installhook'}

NATIVE {installhook} PROC
PROC installhook(hook:PTR TO hook, func:PTR) IS NATIVE {installhook(} hook {,} func {)} ENDNATIVE !!PTR TO hook
