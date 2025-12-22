MODULE '*coordinate'

PROC main()

DEF coo:PTR TO coordinate

  NEW coo.new(["set", 1.0,2.0,0.0])
  WriteF('\s\n', coo.write())
/*
  WriteF('now lets rotate it around 90 degree( z-axis)\n')

  coo.rotateZ(90.0)
  WriteF('\s\n', coo.write())

  WriteF('now lets rotate it back( z-axis)\n')

  coo.rotateZ(270.0)
  WriteF('\s\n\n', coo.write())



  WriteF('now lets rotate it around 90 degree( y-axis)\n')

  coo.rotateY(90.0)
  WriteF('\s\n', coo.write())

  WriteF('now lets rotate it back( y-axis)\n')

  coo.rotateY(270.0)
  WriteF('\s\n\n', coo.write())


*/
  WriteF(' 90 (180, 270) degree( x-axis)\n')

  coo.rotateX(90.0)
  WriteF('\s\n', coo.write())
  coo.rotateX(90.0)
  WriteF('\s\n', coo.write())
  coo.rotateX(90.0)
  WriteF('\s\n', coo.write())
  coo.rotateX(90.0)
  WriteF('\s\n\n', coo.write())
  coo.rotateX(180.0)
  WriteF('\s\n', coo.write())
  coo.rotateX(180.0)
  WriteF('\s\n\n', coo.write())
  coo.rotateX(270.0)
  WriteF('\s\n', coo.write())
  coo.rotateX(270.0)
  WriteF('\s\n', coo.write())
  coo.rotateX(270.0)
  WriteF('\s\n', coo.write())
  coo.rotateX(270.0)
  WriteF('\s\n', coo.write())

  WriteF(' 90 (180, 270) degree( y-axis)\n')

  coo.rotateY(90.0)
  WriteF('\s\n', coo.write())
  coo.rotateY(90.0)
  WriteF('\s\n', coo.write())
  coo.rotateY(90.0)
  WriteF('\s\n', coo.write())
  coo.rotateY(90.0)
  WriteF('\s\n\n', coo.write())
  coo.rotateY(180.0)
  WriteF('\s\n', coo.write())
  coo.rotateY(180.0)
  WriteF('\s\n\n', coo.write())
  coo.rotateY(270.0)
  WriteF('\s\n', coo.write())
  coo.rotateY(270.0)
  WriteF('\s\n', coo.write())
  coo.rotateY(270.0)
  WriteF('\s\n', coo.write())
  coo.rotateY(270.0)
  WriteF('\s\n', coo.write())

  WriteF(' 90 (180, 270) degree( x-axis)\n')

  coo.rotateZ(90.0)
  WriteF('\s\n', coo.write())
  coo.rotateZ(90.0)
  WriteF('\s\n', coo.write())
  coo.rotateZ(90.0)
  WriteF('\s\n', coo.write())
  coo.rotateZ(90.0)
  WriteF('\s\n\n', coo.write())
  coo.rotateZ(180.0)
  WriteF('\s\n', coo.write())
  coo.rotateZ(180.0)
  WriteF('\s\n\n', coo.write())
  coo.rotateZ(270.0)
  WriteF('\s\n', coo.write())
  coo.rotateZ(270.0)
  WriteF('\s\n', coo.write())
  coo.rotateZ(270.0)
  WriteF('\s\n', coo.write())
  coo.rotateZ(270.0)
  WriteF('\s\n', coo.write())


ENDPROC
