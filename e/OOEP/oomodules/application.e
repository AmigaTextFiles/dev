OPT MODULE

/*

Application object. Features: arexx port, commodity

    NAME
        application

    PURPOSE
        A basic application object. By now it's totally undefined what will
        find it's way in here. Any ideas are welcome. Here's a list of things
        That could be part of this object in the future:

        - locale support
        - arexx support
        - commodity
        - gui engine (easygui and/or MUI via compiler switch)

*/

MODULE  'oomodules/object',
        'oomodules/commodity',
        'oomodules/library/exec/port/arexxport',
        'oomodules/library/exec/port/portlist'

OBJECT application OF object
  commodity:PTR TO commodity
  ports:PTR TO portList
ENDOBJECT

PROC init() OF application

  NEW ports.new()

ENDPROC

PROC select(opts,i) OF application
DEF item,
    arexx:PTR TO arexxPort,
    cx:PTR TO commodity

  item:=ListItem(opts,i)


  SELECT item

    CASE "rexx"

      INC i
      NEW arexx.new(ListItem(opts,i))
      self.ports.add(arexx,"rexx")

    CASE "cx"

      NEW cx.new(ListItem(opts,i))
      self.commodity := cx

  ENDSELECT

ENDPROC i

/*EE folds
-1
32 3 35 22 
EE folds*/
