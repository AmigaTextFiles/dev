OPT MODULE

MODULE  'oomodules/sort/string',
        'oomodules/list/associativeArray',
        'oomodules/library/locale'

OBJECT nuArray OF associativeArray
/****** nuArray/nuArray ******************************

    NAME
        nuArray() of associativeArray

    PURPOSE
        Just to override the testKey() method. This array has strings as
        keys. The strings are the names of the catalogs. When ENDing this
        object the values (catalogs) are disposed (closed) automatically.

    ATTRIBUTES
        cl:PTR TO catalogList -- The catalogList I am in. Just for
            convenience with disposeVal().

    SEE ALSO
        associativeArray

********/
  cl:PTR TO catalogList
ENDOBJECT



EXPORT OBJECT catalogList OF locale
/****** catalogList/catalogList ******************************

    NAME
        catalogList of locale

    PURPOSE
        This object holds any number of catalogs at the same time. Use it
        to make your application use more than one catalog.

        catalogList is needed for the localization of the ooep: each object
        has it's own catalog. Therefore it is necessary to hold any number
        of objects open simultaneously.

    ATTRIBUTES
        catalogArray:PTR TO nuArray -- a slightly modified associativeArray.
            The keys aren't numbers but the names of the catalogs.

    SEE ALSO
        associativeArray/associativeArray

********/
  catalogArray:PTR TO nuArray
ENDOBJECT




/******************

 methods of nuArray

******************/

PROC testKey(string1, string2) OF nuArray IS OstrCmp(string1, string2)
/****** nuArray/testKey ******************************

    NAME
        testKey() of nuArray -- Compare two keys.

    SYNOPSIS
        nuArray.testKey(LONG, LONG)

        nuArray.testKey(string1, string2)

    FUNCTION
        Compares two keys. See associativeArray/testKey().
        In this object the keys are strings. Comparing is done with E's
        builtin OstrCmp().

    INPUTS
        string1:LONG -- First string to compare.

        string2:LONG -- Second string to compare.

    RESULT
        See E.doc/OstrCmp() for the return values.

    SEE ALSO
        nuArray

********/

PROC disposeVal(catalog) OF nuArray
/****** nuArray/disposeVal ******************************

    NAME
        disposeVal() of nuArray -- Dispose the value.

    SYNOPSIS
        nuArray.disposeVal(LONG)

        nuArray.disposeVal(catalog)

    FUNCTION
        Disposes the value stored in the nuArray. This is a catalog, the
        disposing means that it's closed.

    INPUTS
        catalog:LONG -- Catalog to be closed.

    SEE ALSO
        nuArray/nuArray, associativeArray/associativeArray

********/
DEF cl:PTR TO catalogList

  cl := self.cl
  cl.closeCatalog(catalog)

ENDPROC



/******************

 methods of catalogList

******************/



PROC init() OF catalogList
/****** catalogList/init ******************************

    NAME
        init() of catalogList -- Initialization of the object.

    SYNOPSIS
        catalogList.init()

    FUNCTION
        The nuArray is NEWed and SUPER init() is called.

    SEE ALSO
        catalogList/catalogList

********/

  NEW self.catalogArray.new()

  self.catalogArray.cl := self

  SUPER self.init() -> locale.init()

ENDPROC

PROC setCurrentCatalog(locale, name:PTR TO CHAR, builtinLanguage=NIL:PTR TO CHAR) OF catalogList HANDLE
/****** catalogList/setCurrentCatalog ******************************

    NAME
        setCurrentCatalog() of catalogList -- Set the catalog to work with

    SYNOPSIS
        catalogList.setCurrentCatalog(LONG, PTR TO CHAR, PTR TO CHAR=NIL)

        catalogList.setCurrentCatalog(locale, name, builtinLanguage)

    FUNCTION
        Sets the 'current' catalog, i.e. all procs that work with a catalog
        will work with this one. If the catalog isn't open it will be opened.

    INPUTS
        locale:LONG -- locale structure as needed by the locale.library.
            Usually this can be left NIL.

        name:PTR TO CHAR -- name of the catalog.

        builtinLanguage=NIL:PTR TO CHAR -- the language the strings in the
            source are written in. NIL means that English is builtin.

    RESULT
        the catalog

    EXAMPLE
        cl.setCurrentCatalog(NIL,'oomodules/object')

    SEE ALSO
        catalogList

********/
DEF catalog

->  WriteF('Setting the new catalog .\s.\n',name)

  catalog := self.catalogArray.get(name)

  self.catalog := catalog
  RETURN catalog

EXCEPT

->  WriteF('have to open it.\n\n')

  catalog := self.openCatalog(locale,name,builtinLanguage)

  IF catalog

    self.catalogArray.set(name, catalog)

    self.catalog := catalog

  ENDIF

  RETURN catalog

ENDPROC

PROC removeCurrentCatalog() OF catalogList HANDLE
/****** catalogList/removeCurrentCatalog ******************************

    NAME
        removeCurrentCatalog() of catalogList -- Remove catalog from list.

    SYNOPSIS
        catalogList.removeCurrentCatalog()

    FUNCTION
        Removes the current catalog from the internal list. It is *not*
        closed, you have to do that.

    RESULT
        the current catalog

    SEE ALSO
        catalogList

********/

  IF self.catalog THEN self.catalogArray.remove(self.catalog)
  RETURN self.catalog

EXCEPT

ENDPROC

PROC end() OF catalogList
/****** catalogList/end ******************************

    NAME
        end() of catalogList -- Global destructor.

    SYNOPSIS
        catalogList.end()

    FUNCTION
        ENDs the nuArray and calls SUPER end().

    SEE ALSO
        catalogList, locale/end()

********/

  END self.catalogArray

  SUPER self.end()

ENDPROC

PROC select(optionlist, index) OF catalogList
/****** catalogList/select ******************************

    NAME
        select() of catalogList -- Selection of action.

    SYNOPSIS
        catalogList.select(LONG, LONG)

        catalogList.select(optionlist, index)

    FUNCTION
        Supports the following tags:

            "ctlg" -- Name of catalog to open at once.

            "lang" -- Bultin language to set. NIL means English. Set this
                before you open any catalog.

    INPUTS
        optionlist:LONG -- elist of options

        index:LONG -- index of option list

    RESULT
        index after processing one tag.

    SEE ALSO
        catalogList, object/select()

********/
DEF item

  item:=ListItem(optionlist,index)

  SELECT item

    CASE "ctlg" -> open catalog

      INC index
      self.setCurrentCatalog(NIL, ListItem(optionlist,index), self.builtinLanguage)

    CASE "lang" -> set builtin language

      INC index
      self.builtinLanguage := ListItem(optionlist,index)

  ENDSELECT

ENDPROC index



PROC name() OF catalogList IS 'CatalogList'
/****** catalogList/name ******************************

    NAME
        name() of catalogList -- Return object's name.

    SYNOPSIS
        catalogList.name()

    FUNCTION
        Returns the name of the object.

    RESULT
        'CatalogList'

    SEE ALSO
        catalogList

********/

PROC length() OF catalogList IS self.catalogArray.tail-1
/****** catalogList/length ******************************

    NAME
        length() of catalogList -- Get number of catalogs open.

    SYNOPSIS
        catalogList.length()

    FUNCTION
        Gets you the number of catalogs open.

    RESULT
        LONG -- tail entry of nuArray minus 1.

    SEE ALSO
        catalogList, nuArray/nuArray

********/

/*
PROC write(index) OF catalogList
    WriteF('key\d=\d val\d=$\h\n', index, self.catalogArray.key[index], index, self.catalogArray.val[index])

ENDPROC

*/


/*EE folds
-1
133 22 136 58 139 25 142 20 145 48 
EE folds*/
