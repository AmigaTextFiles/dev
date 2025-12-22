MODULE '*string','*address'

PROC main()
 DEF mystr:PTR TO string,hisstr:PTR TO string,myaddr:PTR TO address,
     heradr:PTR TO address
 NEW mystr.new()
 NEW hisstr.new()

 mystr.set('aaaaa')
 hisstr.set('aaaab')

 WriteF('''mystr'' = "\s"\n''hisstr'' = "\s"\n',mystr.write(),hisstr.write())
 WriteF('''mystr'' has a length of \d.\n''hisstr'' has a length of \d.\n',mystr.size(),hisstr.size())

 WriteF('Is ''mystr'' less than ''hisstr''?\n')
 IF mystr.lt(hisstr) THEN WriteF('Yes\n') ELSE WriteF('No\n')

 WriteF('Is ''mystr'' greater than ''hisstr''?\n')
 IF mystr.gt(hisstr) THEN WriteF('Yes\n') ELSE WriteF('No\n')

 WriteF('IS ''mystr'' less than or equal to ''hisstr''?\n')
 IF mystr.le(hisstr) THEN WriteF('Yes\n') ELSE WriteF('No\n')
 NEW myaddr.new()
 NEW heradr.new()

 WriteF('\nSetting addresses.\n\n')

 myaddr.setFname('Trey')
 myaddr.setLname('Van Riper')
 myaddr.setCity('Asheville, NC')
 myaddr.setStreet('19-A Dortch Ave.')
 myaddr.setPhone('(704) 555-8964')

 heradr.setFname('Georgia')
 heradr.setLname('Brown')
 heradr.setCity('Dover, AL')
 heradr.setStreet('5 RosyPalm Dr.')
 heradr.setPhone('(803) 555-1234')

 WriteF('My Address:\n\s\n',myaddr.write())
 WriteF('Her Address:\n\s\n',heradr.write())

 WriteF('Is myaddr greater than heradr?\n')
 IF myaddr.gt(heradr) THEN WriteF('Yes.\n') ELSE WriteF('No.\n')
 WriteF('Is myaddr less than heradr?\n')
 IF myaddr.lt(heradr) THEN WriteF('Yes.\n') ELSE WriteF('No.\n')
ENDPROC
