MODULE 'oomodules/sort/number'

PROC main()
DEF num1:PTR TO number,
    num2:PTR TO number

  NEW num1.new()
  NEW num2.new()

  WriteF('\s\n',num1.name())

  num1.set(3)
  num2.set(4)
  num1.add(num2)

  WriteF('\d\n', num1.get())

ENDPROC
