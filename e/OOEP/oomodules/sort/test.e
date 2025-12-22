MODULE 'oomodules/sort/string','oomodules/sort/address'

PROC main() HANDLE
 DEF mystr:PTR TO string,hisstr:PTR TO string,
     myaddr:PTR TO address
 NEW mystr.new(["set",'aaaaaa'])
 NEW hisstr.new(["set",'aaab'])
 WriteF('mystr = «\s»\n',mystr.write())
 mystr.cat('bbbbbb')
 WriteF('mystr after cat = «\s»\n',mystr.write())

 WriteF('mystr = «\s»\nhisstr = «\s»\n',mystr.write(),hisstr.write())
 WriteF('mystr has a length of \d.\nhisstr has a length of \d.\n',mystr.length(),hisstr.length())

 WriteF('Is mystr less than hisstr?\n')
 IF mystr.lt(hisstr) THEN WriteF('Yes\n') ELSE WriteF('No\n')

 WriteF('Is mystr greater than hisstr?\n')
 IF mystr.gt(hisstr) THEN WriteF('Yes\n') ELSE WriteF('No\n')

 WriteF('Is mystr less than or equal to hisstr?\n')
 IF mystr.le(hisstr) THEN WriteF('Yes\n') ELSE WriteF('No\n')
 WriteF('And mystr is a «\s».\n',mystr.name())
 mystr.catString(hisstr)
 WriteF('Concatenating the two strings yields «\s» of length \d\n',
         mystr.write(),mystr.length())
 WriteF('===================================================\nTesting address:\n---\n')
 NEW myaddr.new(["sfnm",'Joseph',
                 "slnm",'Van Riper',
      "scty",'Asheville, NC',
      "sstr",'19-A Dredge Ave.',
      "sphn",'(704) 555-6545'])
 END mystr
 END hisstr
 mystr := myaddr.write()
 WriteF('\s---\naddress string length: \d\n',mystr.write(),mystr.length())
 hisstr := mystr.left(5)
 WriteF('left(5)    :«\s»\n',hisstr.write())
 END hisstr
 hisstr := mystr.right(5)
 WriteF('right(5)   :«\s»\n',hisstr.write())
 END hisstr
 hisstr := mystr.middle(5,5)
 WriteF('middle(5,5):«\s»\n',hisstr.write())
EXCEPT
 WriteF('error\n')
ENDPROC
