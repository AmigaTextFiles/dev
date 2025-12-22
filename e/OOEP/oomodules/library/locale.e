OPT MODULE

MODULE  'oomodules/library',
        'oomodules/object',
        'oomodules/sort/string',

        'locale',
        'libraries/locale'

EXPORT OBJECT locale OF library
/****** library/locale ******************************

    NAME
        locale() of library --

    SYNOPSIS
        library.locale(LONG, LONG)

        library.locale(catalog , builtinLanguage )

    FUNCTION

    INPUTS
        catalog :LONG -- 

        builtinLanguage :LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        library

********/
  catalog -> the current catalog
  builtinLanguage -> if NIL it's english
ENDOBJECT

EXPORT PROC init() OF locale
/****** locale/init ******************************

    NAME
        init() of locale --

    SYNOPSIS
        locale.init()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        locale

********/

  self.version:=0
  self.open()

ENDPROC

PROC open() OF locale
/****** locale/open ******************************

    NAME
        open() of locale --

    SYNOPSIS
        locale.open()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        locale

********/

  IF localebase THEN RETURN

  IF (localebase := OpenLibrary('locale.library', self.version))=NIL THEN Throw("lib", 'Unable to open locale.library')

ENDPROC

PROC close() OF locale
/****** locale/close ******************************

    NAME
        close() of locale --

    SYNOPSIS
        locale.close()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        locale

********/

  IF localebase THEN CloseLibrary(localebase)

ENDPROC

PROC openCatalog(locale, name:PTR TO CHAR, builtinLanguage=NIL:PTR TO CHAR) OF locale
/****** locale/openCatalog ******************************

    NAME
        openCatalog() of locale --

    SYNOPSIS
        locale.openCatalog(LONG, PTR TO CHAR, PTR TO CHAR=NIL:PTR TO CHAR)

        locale.openCatalog(locale, name, builtinLanguage)

    FUNCTION

    INPUTS
        locale:LONG -- 

        name:PTR TO CHAR -- 

        builtinLanguage:PTR TO CHAR -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        locale

********/

  IF self.catalog -> if there's a catalog open

    self.closeCatalog(self.catalog)

    self.catalog := NIL

  ENDIF

  self.builtinLanguage := builtinLanguage

  self.catalog := OpenCatalogA(locale,name, IF self.builtinLanguage=NIL THEN 'english' ELSE self.builtinLanguage)

  RETURN self.catalog

ENDPROC

PROC closeCatalog(catalog) OF locale
/****** locale/closeCatalog ******************************

    NAME
        closeCatalog() of locale --

    SYNOPSIS
        locale.closeCatalog(LONG)

        locale.closeCatalog(catalog)

    FUNCTION

    INPUTS
        catalog:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        locale

********/

  IF catalog THEN CloseCatalog(catalog)

ENDPROC

PROC getString(number, default=NIL:PTR TO CHAR) OF locale
/****** locale/getString ******************************

    NAME
        getString() of locale --

    SYNOPSIS
        locale.getString(LONG, PTR TO CHAR=NIL:PTR TO CHAR)

        locale.getString(number, default)

    FUNCTION

    INPUTS
        number:LONG -- 

        default:PTR TO CHAR -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        locale

********/
-> gets a string from the current catalog
-> if no catalog is open returns "NoCa" (no catalog)

  IF self.catalog THEN RETURN GetCatalogStr(self.catalog,number,default) ELSE RETURN "NoCa"

ENDPROC

PROC end() OF locale
/****** locale/end ******************************

    NAME
        end() of locale --

    SYNOPSIS
        locale.end()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        locale

********/

  self.closeCatalog(self.catalog)

  self.close()

ENDPROC

PROC select(optionlist, index) OF locale
/****** locale/select ******************************

    NAME
        select() of locale --

    SYNOPSIS
        locale.select(LONG, LONG)

        locale.select(optionlist, index)

    FUNCTION

    INPUTS
        optionlist:LONG -- 

        index:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        locale

********/
DEF item

  item:=ListItem(optionlist,index)

  SELECT item

    CASE "ctlg" -> open catalog

      INC index
      self.openCatalog(NIL, ListItem(optionlist,index), self.builtinLanguage)

    CASE "lang" -> set builtin language

      INC index
      self.builtinLanguage := ListItem(optionlist,index)

  ENDSELECT

ENDPROC index

PROC getObjectString(object:PTR TO object, container:PTR TO string,number, default=NIL:PTR TO CHAR) OF locale
/****** locale/getObjectString ******************************

    NAME
        getObjectString() of locale --

    SYNOPSIS
        locale.getObjectString(PTR TO object, PTR TO string, LONG, PTR TO CHAR=NIL:PTR TO CHAR)

        locale.getObjectString(object, container, number, default)

    FUNCTION

    INPUTS
        object:PTR TO object -- 

        container:PTR TO string -- 

        number:LONG -- 

        default:PTR TO CHAR -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        locale

********/
/****** locale/getObjectString ******************************************

    NAME
        getLocalizedObjectString() -- get string from object catalog

    SYNOPSIS
        object.getLocalizedObjectString(LONG, PTR TO CHAR=NIL)

        object.getLocalizedObjectString(number, default=NIL)

    FUNCTION
        Gets a string from the object's catalog.

    INPUTS
        number:LONG -- The number of the string to get.

        default=NIL:LONG -- The default string to return if there is no string
            of that number.

    RESULT
        "NoCa" if the locale.library couldn't be opened.
        The default string if there's no entry of that number in the catalog,
        otherwise the requested string.

    NOTES
        The returned string from the catalog is READ-ONLY.

******************************************************************************/

DEF string:PTR TO string,
    oldCatalog,
    stringToReturn:PTR TO CHAR

  END container
  NEW container.new()

  NEW string.new()
  string.cat('oomodules/')
  string.cat(object.name())
  string.cat('.catalog')

 /*
  * 'save' the old catalog
  */

  oldCatalog := self.catalog

 /*
  * Set it to NIL so self.openCatalog() won't close it
  */

  self.catalog:=NIL

 /*
  * Open the object's catalog
  */

  self.openCatalog(NIL, string.write(), self.builtinLanguage)

  stringToReturn :=  self.getString(number,default)
  container.cat(stringToReturn)

  self.closeCatalog(self.catalog)

 /*
  * Restore the old catalog
  */

  self.catalog := oldCatalog

  END string

ENDPROC


PROC name() OF locale IS 'Locale'
