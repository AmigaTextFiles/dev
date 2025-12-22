/*
*  This file was created automatically by `FlexCat 1.5'
*  from "valid.cd".
*  Do not edit by hand!
*  NIE ROZPOWSZECHNIAÊ - WERSJA PRYWATNA  (c)Piotr Gapiïski (14.04.96)
*  _UWAGA_
*  Nazwy identyfikatorow MUSZÂ byê zapisane DUÛYMI literami !
*/

OPT MODULE
OPT OSVERSION=37,PREPROCESS,EXPORT

MODULE 'libraries/locale','locale',
       'utility/tagitem'

CONST MSG_ERROR_VOLUMES = 0
CONST MSG_ERROR_ACCESS = 1
CONST MSG_VOLUME_VALIDATING = 2
CONST MSG_VOLUME_VALIDATED = 3

OBJECT catalog_VALID
  cat: PTR TO catalog
  strs[4]:ARRAY OF LONG
ENDOBJECT

PROC create() OF catalog_VALID
  self.cat:=NIL
  self.strs[0]:='volumes list is locked, sorry...\n'
  self.strs[1]:='access error (volume "\s")\n'
  self.strs[2]:='validating (please wait)...'
  self.strs[3]:='OK\n'
ENDPROC

PROC getstr(id) OF catalog_VALID
  RETURN (IF self.cat THEN GetCatalogStr(self.cat,
           id,self.strs[id]) ELSE self.strs[id])
ENDPROC
PROC getStr(id) OF catalog_VALID IS self.getstr(id)

PROC open(loc=NIL:PTR TO locale,language=NIL:PTR TO CHAR) OF catalog_VALID
  IF localebase=NIL THEN RETURN FALSE
  self.close()
  self.cat:=OpenCatalogA(loc,'valid.catalog',
       [OC_BUILTINLANGUAGE,'english',
       IF language THEN OC_LANGUAGE ELSE TAG_IGNORE,language,
       OC_VERSION,2,TAG_DONE])
ENDPROC self.cat<>NIL

PROC close() OF catalog_VALID
  IF (localebase) AND (self.cat) THEN CloseCatalog(self.cat)
  self.cat:=NIL
ENDPROC

PROC end() OF catalog_VALID IS self.close()
