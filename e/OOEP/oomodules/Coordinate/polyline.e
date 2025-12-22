OPT MODULE
OPT EXPORT

MODULE  'oomodules/coordinate',
        'other/queuestack'

OBJECT polyline OF coordinate
  coordinates:PTR TO queuestack
ENDOBJECT

PROC init() OF polyline
DEF q:PTR TO queuestack

  NEW q.new()

  self.coordinates := q

ENDPROC

PROC end() OF polyline
DEF q:PTR TO queuestack

  q:=self.coordinates

  END q
ENDPROC

PROC name() OF polyline IS 'Polyline'

PROC add(coo:PTR TO coordinate) OF polyline

  self.coordinates.addLast(coo)

ENDPROC
