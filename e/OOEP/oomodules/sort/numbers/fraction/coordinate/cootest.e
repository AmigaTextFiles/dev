MODULE '*coordinate'

PROC main()
DEF coo:PTR TO coordinate,
    co2:PTR TO coordinate

  NEW coo.new(["set",1,1,2,1,0,1])

  WriteF('\s\n', coo.write())

  NEW co2.new()
/*  WriteF('\s\n', coo.write())

  coo.copy(co2)

  WriteF('A copy: \s\n', co2.write())

  WriteF('\nNow shift the first by the second:\n')

  coo.shift(co2)

  WriteF('\s\n', coo.write())

  coo.angle2radians(90)
*/

  WriteF('now lets rotate it around 90 degree( z-axis)\n')

  coo.rotateZ(90)
  WriteF('\s\n', coo.write())

  WriteF('now lets rotate it back( z-axis)\n')

  coo.rotateZ(270)
  WriteF('\s\n', coo.write())


-> y geht noch nicht ganz...

  WriteF('now lets rotate it 90 degree( y-axis)\n')

  coo.rotateY(180)

  WriteF('\s\n', coo.write())

  WriteF('now lets rotate it back( y-axis)\n')

  coo.rotateY(180)

  WriteF('\s\n', coo.write())
/*
-> x

  WriteF('now lets rotate it 90 degree( x-axis)\n')

  coo.rotateX(90)

  WriteF('\s\n', coo.write())

  WriteF('now lets rotate it back( x-axis)\n')

  coo.rotateX(-90)

  WriteF('\s\n', coo.write())
*/
ENDPROC
