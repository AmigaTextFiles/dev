OPT MODULE

MODULE 'class/catalog'

-> Generated automatically with FlexCat 2.0 from "helloworld.cd"
EXPORT OBJECT cat_helloworld OF catalog_obj; ENDOBJECT

EXPORT CONST MSG_HELLO=0
EXPORT CONST MSG_BYE=1

EXPORT PROC open(name=NIL, lang=NIL, locale=NIL) OF cat_helloworld
  SUPER self.open(
    IF name THEN name ELSE 'helloworld.catalog',
    IF lang THEN lang ELSE 'english',
    locale
  )
  SUPER self.def([
    0, 'This is a test string for the world to see: HELLO WORLD!',
    1, 'This is another test string: BYE!'
  ])
ENDPROC
