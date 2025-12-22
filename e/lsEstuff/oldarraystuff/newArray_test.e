MODULE '*newArray'

PROC main()
   DEF na1:PTR TO newArray
   DEF na2:PTR TO newArray
   NEW na1.newArray()
   NEW na2.newArray()

   na1.set(10, 1000)

   na2.set(10, 5000)
   na2.set(30, 7000)
   na1.subtraction(na2)
   na1.printArrayContents()
   na1.applyNew(na2)
   na1.printArrayContents()
   na1.scroll(5)
   na1.printArrayContents()
   END na1
   END na2
ENDPROC

