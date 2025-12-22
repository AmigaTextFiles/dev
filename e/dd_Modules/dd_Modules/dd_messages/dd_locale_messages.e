-> FOLD OPTS
OPT MODULE
-> ENDFOLD
-> FOLD MODULES
MODULE '*dd_messages'

MODULE 'utility/tagitem'
MODULE 'locale','libraries/locale'
-> ENDFOLD
-> FOLD DEFS

-> private global librarybase
DEF localebase

-> ENDFOLD
-> FOLD OBJECTS
-> localemessages is a child of messages
-> and can be used instead to support localization
EXPORT OBJECT localemessages OF messages
PRIVATE
  /**** UNNECESSARY
  locale:LONG
  ****/
  catalog:LONG
ENDOBJECT
-> ENDFOLD

-> FOLD new
-> redefined constructor for locale messages
EXPORT PROC new() OF localemessages

  DEF messagenum

  -> invokes parent class constructor to init built-in messages
  SUPER self.new()

  -> locale library present?
  IF localebase:=OpenLibrary('locale.library',38)

    /**** UNNECESSARY
    -> open locale structure
    locale:=OpenLocale(NIL)
    self.locale:=locale
    ****/

    -> open message catalog
    self.catalog:=OpenCatalogA(NIL,'InfraRexxEditor.catalog',[OC_VERSION,4,TAG_DONE])

    -> catalog opened?
    IF self.catalog

      -> read catalog messages
      FOR messagenum:=0 TO NUM_MSG-1

        -> use localized messages, for those present
        self.set(messagenum,GetCatalogStr(self.catalog,messagenum,self.get(messagenum)))

      ENDFOR

    ELSEIF IoErr()=0
        -> <built-in strings reflect prefered language>

        -> localize built-ins
        self.set(1,'%lU times per second')
    ENDIF
  ENDIF
ENDPROC
-> ENDFOLD
-> FOLD end
-> redefined destructor
EXPORT PROC end() OF localemessages

  /**** UNNECESSSARY
  IF self.locale
    CloseLocale(self.locale)
    self.locale:=NIL
  ENDIF
  ****/

  IF self.catalog
    CloseCatalog(self.catalog)
    self.catalog:=NIL
  ENDIF

  IF localebase
    CloseLibrary(localebase)
    localebase:=NIL
  ENDIF

  -> invoke super destructor
  SUPER self.end()

ENDPROC
-> ENDFOLD
