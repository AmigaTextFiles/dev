OPT NATIVE
PUBLIC MODULE 'target/libraries/application'
MODULE 'target/exec/types', 'target/exec' /*was 'target/exec/exec'*/, 'target/exec/interfaces', 'target/exec/libraries', 'target/libraries/application'
MODULE 'target/PEalias/exec', 'utility/tagitem'
{
#include <proto/application.h>
}
{
struct Library* ApplicationBase = NULL;
struct  ApplicationIFace* IApplication  = NULL;
struct PrefsObjectsIFace* IPrefsObjects = NULL;
}
NATIVE {APPLICATION_INTERFACE_DEF_H} CONST
NATIVE {CLIB_APPLICATION_PROTOS_H} CONST

NATIVE {ApplicationBase} DEF applicationbase:PTR TO lib
NATIVE {IApplication} DEF
NATIVE {IPrefsObjects} DEF

PROC new()
	InitLibrary('application.library', NATIVE {(struct Interface **) &IApplication}  ENDNATIVE !!ARRAY OF PTR TO interface, 'application' , 2)
	InitLibrary('application.library', NATIVE {(struct Interface **) &IPrefsObjects} ENDNATIVE !!ARRAY OF PTR TO interface, 'prefsobjects', 2)
ENDPROC

->NATIVE {SetAppLibAttrsA} PROC
PROC SetAppLibAttrsA(tags:ARRAY OF tagitem) IS NATIVE {-IApplication->SetAppLibAttrsA(} tags {)} ENDNATIVE !!INT
->NATIVE {GetAppLibAttrsA} PROC
PROC GetAppLibAttrsA(tags:ARRAY OF tagitem) IS NATIVE {-IApplication->GetAppLibAttrsA(} tags {)} ENDNATIVE !!INT
->NATIVE {RegisterApplicationA} PROC
PROC RegisterApplicationA(appName:/*CONST_STRPTR*/ ARRAY OF CHAR, tags:ARRAY OF tagitem) IS NATIVE {IApplication->RegisterApplicationA(} appName {,} tags {)} ENDNATIVE !!ULONG
->NATIVE {RegisterApplication} PROC
PROC RegisterApplication(appName:/*CONST_STRPTR*/ ARRAY OF CHAR, appName2=0:ULONG, ...) IS NATIVE {IApplication->RegisterApplication(} appName {,} appName2 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {UnregisterApplicationA} PROC
PROC UnregisterApplicationA(appID:ULONG, tags:ARRAY OF tagitem) IS NATIVE {-IApplication->UnregisterApplicationA(} appID {,} tags {)} ENDNATIVE !!INT
->NATIVE {UnregisterApplication} PROC
PROC UnregisterApplication(appID:ULONG, appID2=0:ULONG, ...) IS NATIVE {-IApplication->UnregisterApplication(} appID {,} appID2 {,} ... {)} ENDNATIVE !!INT
->NATIVE {SetApplicationAttrsA} PROC
PROC SetApplicationAttrsA(appID:ULONG, tags:ARRAY OF tagitem) IS NATIVE {-IApplication->SetApplicationAttrsA(} appID {,} tags {)} ENDNATIVE !!INT
->NATIVE {SetApplicationAttrs} PROC
PROC SetApplicationAttrs(appID:ULONG, appID2=0:ULONG, ...) IS NATIVE {-IApplication->SetApplicationAttrs(} appID {,} appID2 {,} ... {)} ENDNATIVE !!INT
->NATIVE {GetApplicationAttrsA} PROC
PROC GetApplicationAttrsA(appID:ULONG, tags:ARRAY OF tagitem) IS NATIVE {-IApplication->GetApplicationAttrsA(} appID {,} tags {)} ENDNATIVE !!INT
->NATIVE {GetApplicationAttrs} PROC
PROC GetApplicationAttrs(appID:ULONG, appID2=0:ULONG, ...) IS NATIVE {-IApplication->GetApplicationAttrs(} appID {,} appID2 {,} ... {)} ENDNATIVE !!INT
->NATIVE {FindApplicationA} PROC
PROC FindApplicationA(tags:ARRAY OF tagitem) IS NATIVE {IApplication->FindApplicationA(} tags {)} ENDNATIVE !!ULONG
->NATIVE {LockApplicationIcon} PROC
PROC LockApplicationIcon(appID:ULONG) IS NATIVE {-IApplication->LockApplicationIcon(} appID {)} ENDNATIVE !!INT
->NATIVE {UnlockApplicationIcon} PROC
PROC UnlockApplicationIcon(appID:ULONG) IS NATIVE {IApplication->UnlockApplicationIcon(} appID {)} ENDNATIVE
->NATIVE {GetApplicationList} PROC
PROC GetApplicationList() IS NATIVE {IApplication->GetApplicationList()} ENDNATIVE !!PTR TO mlh
->NATIVE {FreeApplicationList} PROC
PROC FreeApplicationList(list:PTR TO mlh) IS NATIVE {IApplication->FreeApplicationList(} list {)} ENDNATIVE
->NATIVE {SendApplicationMsg} PROC
PROC SendApplicationMsg(senderAppID:ULONG, receiverAppID:ULONG, msg:PTR TO applicationmsg, msgType:ULONG) IS NATIVE {-IApplication->SendApplicationMsg(} senderAppID {,} receiverAppID {,} msg {,} msgType {)} ENDNATIVE !!INT
->NATIVE {NotifyA} PROC
PROC NotifyA(appID:ULONG, tags:ARRAY OF tagitem) IS NATIVE {IApplication->NotifyA(} appID {,} tags {)} ENDNATIVE !!ULONG
->NATIVE {Notify} PROC
PROC Notify(appID:ULONG, appID2=0:ULONG, ...) IS NATIVE {IApplication->Notify(} appID {,} appID2 {,} ... {)} ENDNATIVE !!ULONG

->NATIVE {PrefsBaseObjectA} PROC
PROC PrefsBaseObjectA(obj:PTR TO PREFSOBJECT, error:PTR TO ULONG, tags:ARRAY OF tagitem) IS NATIVE {PrefsObjectsIFace->PrefsBaseObjectA(} obj {,} error {,} tags {)} ENDNATIVE !!PTR TO PREFSOBJECT
->NATIVE {PrefsBaseObject} PROC
PROC PrefsBaseObject(obj:PTR TO PREFSOBJECT, error:PTR TO ULONG, error2=0:ULONG, ...) IS NATIVE {PrefsObjectsIFace->PrefsBaseObject(} obj {,} error {,} error2 {,} ... {)} ENDNATIVE !!PTR TO PREFSOBJECT
->NATIVE {PrefsStringA} PROC
PROC PrefsStringA(obj:PTR TO PREFSOBJECT, error:PTR TO ULONG, tags:ARRAY OF tagitem) IS NATIVE {PrefsObjectsIFace->PrefsStringA(} obj {,} error {,} tags {)} ENDNATIVE !!PTR TO PREFSOBJECT
->NATIVE {PrefsString} PROC
PROC PrefsString(obj:PTR TO PREFSOBJECT, error:PTR TO ULONG, error2=0:ULONG, ...) IS NATIVE {PrefsObjectsIFace->PrefsString(} obj {,} error {,} error2 {,} ... {)} ENDNATIVE !!PTR TO PREFSOBJECT
->NATIVE {PrefsNumberA} PROC
PROC PrefsNumberA(obj:PTR TO PREFSOBJECT, error:PTR TO ULONG, tags:ARRAY OF tagitem) IS NATIVE {PrefsObjectsIFace->PrefsNumberA(} obj {,} error {,} tags {)} ENDNATIVE !!PTR TO PREFSOBJECT
->NATIVE {PrefsNumber} PROC
PROC PrefsNumber(obj:PTR TO PREFSOBJECT, error:PTR TO ULONG, error2=0:ULONG, ...) IS NATIVE {PrefsObjectsIFace->PrefsNumber(} obj {,} error {,} error2 {,} ... {)} ENDNATIVE !!PTR TO PREFSOBJECT
->NATIVE {PrefsDateA} PROC
PROC PrefsDateA(obj:PTR TO PREFSOBJECT, error:PTR TO ULONG, tags:ARRAY OF tagitem) IS NATIVE {PrefsObjectsIFace->PrefsDateA(} obj {,} error {,} tags {)} ENDNATIVE !!PTR TO PREFSOBJECT
->NATIVE {PrefsDate} PROC
PROC PrefsDate(obj:PTR TO PREFSOBJECT, error:PTR TO ULONG, error2=0:ULONG, ...) IS NATIVE {PrefsObjectsIFace->PrefsDate(} obj {,} error {,} error2 {,} ... {)} ENDNATIVE !!PTR TO PREFSOBJECT
->NATIVE {PrefsBinaryA} PROC
PROC PrefsBinaryA(obj:PTR TO PREFSOBJECT, error:PTR TO ULONG, tags:ARRAY OF tagitem) IS NATIVE {PrefsObjectsIFace->PrefsBinaryA(} obj {,} error {,} tags {)} ENDNATIVE !!PTR TO PREFSOBJECT
->NATIVE {PrefsBinary} PROC
PROC PrefsBinary(obj:PTR TO PREFSOBJECT, error:PTR TO ULONG, error2=0:ULONG, ...) IS NATIVE {PrefsObjectsIFace->PrefsBinary(} obj {,} error {,} error2 {,} ... {)} ENDNATIVE !!PTR TO PREFSOBJECT
->NATIVE {PrefsDictionaryA} PROC
PROC PrefsDictionaryA(obj:PTR TO PREFSOBJECT, error:PTR TO ULONG, tags:ARRAY OF tagitem) IS NATIVE {PrefsObjectsIFace->PrefsDictionaryA(} obj {,} error {,} tags {)} ENDNATIVE !!PTR TO PREFSOBJECT
->NATIVE {PrefsDictionary} PROC
PROC PrefsDictionary(obj:PTR TO PREFSOBJECT, error:PTR TO ULONG, error2=0:ULONG, ...) IS NATIVE {PrefsObjectsIFace->PrefsDictionary(} obj {,} error {,} error2 {,} ... {)} ENDNATIVE !!PTR TO PREFSOBJECT
->NATIVE {PrefsArrayA} PROC
PROC PrefsArrayA(obj:PTR TO PREFSOBJECT, error:PTR TO ULONG, tags:ARRAY OF tagitem) IS NATIVE {PrefsObjectsIFace->PrefsArrayA(} obj {,} error {,} tags {)} ENDNATIVE !!PTR TO PREFSOBJECT
->NATIVE {PrefsArray} PROC
PROC PrefsArray(obj:PTR TO PREFSOBJECT, error:PTR TO ULONG, error2=0:ULONG, ...) IS NATIVE {PrefsObjectsIFace->PrefsArray(} obj {,} error {,} error2 {,} ... {)} ENDNATIVE !!PTR TO PREFSOBJECT
->NATIVE {DictSetObjectForKey} PROC
PROC DictSetObjectForKey(dict:PTR TO PREFSOBJECT, obj:PTR TO PREFSOBJECT, key:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {-PrefsObjectsIFace->DictSetObjectForKey(} dict {,} obj {,} key {)} ENDNATIVE !!INT
->NATIVE {DictGetObjectForKey} PROC
PROC DictGetObjectForKey(dict:PTR TO PREFSOBJECT, key:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {PrefsObjectsIFace->DictGetObjectForKey(} dict {,} key {)} ENDNATIVE !!PTR TO PREFSOBJECT
->NATIVE {DictGetStringForKey} PROC
PROC DictGetStringForKey(dict:PTR TO PREFSOBJECT, key:/*CONST_STRPTR*/ ARRAY OF CHAR, defStr:/*CONST_STRPTR*/ ARRAY OF CHAR) IS NATIVE {PrefsObjectsIFace->DictGetStringForKey(} dict {,} key {,} defStr {)} ENDNATIVE !!CONST_STRPTR
->NATIVE {DictGetIntegerForKey} PROC
PROC DictGetIntegerForKey(dict:PTR TO PREFSOBJECT, key:/*CONST_STRPTR*/ ARRAY OF CHAR, defInt:VALUE) IS NATIVE {PrefsObjectsIFace->DictGetIntegerForKey(} dict {,} key {,} defInt {)} ENDNATIVE !!VALUE
->NATIVE {DictGetBoolForKey} PROC
PROC DictGetBoolForKey(dict:PTR TO PREFSOBJECT, key:/*CONST_STRPTR*/ ARRAY OF CHAR, defBool:INT) IS NATIVE {-PrefsObjectsIFace->DictGetBoolForKey(} dict {,} key {, -} defBool {)} ENDNATIVE !!INT
->NATIVE {DictGetOptionForKey} PROC
PROC DictGetOptionForKey(dict:PTR TO PREFSOBJECT, key:/*CONST_STRPTR*/ ARRAY OF CHAR, optionsTable:ARRAY OF /*CONST_STRPTR*/ ARRAY OF CHAR, defaultOption:VALUE) IS NATIVE {PrefsObjectsIFace->DictGetOptionForKey(} dict {,} key {,} optionsTable {,} defaultOption {)} ENDNATIVE !!VALUE
->NATIVE {ReadPrefsA} PROC
PROC ReadPrefsA(dict:PTR TO PREFSOBJECT, tags:ARRAY OF tagitem) IS NATIVE {PrefsObjectsIFace->ReadPrefsA(} dict {,} tags {)} ENDNATIVE !!ULONG
->NATIVE {ReadPrefs} PROC
PROC ReadPrefs(dict:PTR TO PREFSOBJECT, dict2=0:ULONG, dict3=0:ULONG, ...) IS NATIVE {PrefsObjectsIFace->ReadPrefs(} dict {,} dict2 {,} dict3 {,} ... {)} ENDNATIVE !!ULONG
->NATIVE {WritePrefsA} PROC
PROC WritePrefsA(dict:PTR TO PREFSOBJECT, tags:ARRAY OF tagitem) IS NATIVE {PrefsObjectsIFace->WritePrefsA(} dict {,} tags {)} ENDNATIVE !!ULONG
->NATIVE {WritePrefs} PROC
PROC WritePrefs(dict:PTR TO PREFSOBJECT, dict2=0:ULONG, dict3=0:ULONG, ...) IS NATIVE {PrefsObjectsIFace->WritePrefs(} dict {,} dict2 {,} dict3 {,} ... {)} ENDNATIVE !!ULONG
