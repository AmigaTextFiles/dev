MODULE 'oomodules/logic/catprop'

PROC main()
 DEF a:PTR TO catprop,b:PTR TO catprop
 WriteF('Testing A true...\n')
 NEW a.new(["sp",'cats','felines',"beA","true"])
 a.write()
 WriteF('\n')
 b := a.asE()
 b.write()
 WriteF('\n')
 END b
 b := a.asI()
 b.write()
 WriteF('\n')
 END b
 b := a.asO()
 b.write()
 WriteF('\n')
 END b; END a
 WriteF('Testing E true...\n')
 NEW a.new(["sp",'cats','dogs',"beE","true"])
 a.write()
 WriteF('\n')
 b := a.asA()
 b.write()
 WriteF('\n')
 END b
 b := a.asI()
 b.write()
 WriteF('\n')
 END b
 b := a.asO()
 b.write()
 WriteF('\n')
 END b; END a
 WriteF('Testing I true...\n')
 NEW a.new(["sp",'felines','cats',"beI","true"])
 a.write()
 WriteF('\n')
 b := a.asA()
 b.write()
 WriteF('\n')
 END b
 b := a.asE()
 b.write()
 WriteF('\n')
 END b
 b := a.asO()
 b.write()
 WriteF('\n')
 END b; END a
 WriteF('Testing O true...\n')
 NEW a.new(["sp",'felines','dogs',"beO","true"])
 a.write()
 WriteF('\n')
 b := a.asA()
 b.write()
 WriteF('\n')
 END b
 b := a.asE()
 b.write()
 WriteF('\n')
 END b
 b := a.asI()
 b.write()
 WriteF('\n')
 END b; END a
 WriteF('Testing A false...\n')
 NEW a.new(["sp",'cats','dogs',"beA","fals"])
 a.write()
 WriteF('\n')
 b := a.asE()
 b.write()
 WriteF('\n')
 END b
 b := a.asI()
 b.write()
 WriteF('\n')
 END b
 b := a.asO()
 b.write()
 WriteF('\n')
 END b; END a
 WriteF('Testing E false...\n')
 NEW a.new(["sp",'cats','felines',"beE","fals"])
 a.write()
 WriteF('\n')
 b := a.asA()
 b.write()
 WriteF('\n')
 END b
 b := a.asI()
 b.write()
 WriteF('\n')
 END b
 b := a.asO()
 b.write()
 WriteF('\n')
 END b; END a
 WriteF('Testing I false...\n')
 NEW a.new(["sp",'dogs','felines',"beI","fals"])
 a.write()
 WriteF('\n')
 b := a.asA()
 b.write()
 WriteF('\n')
 END b
 b := a.asE()
 b.write()
 WriteF('\n')
 END b
 b := a.asO()
 b.write()
 WriteF('\n')
 END b; END a
 WriteF('Testing O false...\n')
 NEW a.new(["sp",'cats','felines',"beO","fals"])
 a.write()
 WriteF('\n')
 b := a.asA()
 b.write()
 WriteF('\n')
 END b
 b := a.asE()
 b.write()
 WriteF('\n')
 END b
 b := a.asI()
 b.write()
 WriteF('\n')
 END b; END a
 WriteF('Testing finished.\n')
ENDPROC
