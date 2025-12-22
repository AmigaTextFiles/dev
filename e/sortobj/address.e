OPT MODULE
-> address.e by Trey Van Riper of the Cheese Olfactory Workshop

MODULE '*string','*sortobj'

-> address.e is a derived object from 'sortobj', but we'll sort to lname.

EXPORT OBJECT address OF sortobj
 lname:PTR TO string
 fname:PTR TO string
 street:PTR TO string
 city:PTR TO string
 phone:PTR TO string
ENDOBJECT 

-> We have much to initialize here.

PROC init() OF address
 DEF tmp:PTR TO string
 NEW tmp.new()
 self.fname:=tmp
 NEW tmp.new()
 self.lname:=tmp
 NEW tmp.new()
 self.street:=tmp
 NEW tmp.new()
 self.city:=tmp
 NEW tmp.new()
 self.phone:=tmp
ENDPROC

-> Sets the first name.

EXPORT PROC setFname(in) OF address
 self.fname.set(in)
ENDPROC

-> These two functions set the last name.

EXPORT PROC set(in) OF address
 self.setLname(in)
ENDPROC

EXPORT PROC setLname(in) OF address
 self.lname.set(in)
ENDPROC

-> Sets the Street address.

EXPORT PROC setStreet(in) OF address
 self.street.set(in)
ENDPROC

-> Sets the City/State

EXPORT PROC setCity(in) OF address
 self.city.set(in)
ENDPROC

-> Sets the phone #.

EXPORT PROC setPhone(in) OF address
 self.phone.set(in)
ENDPROC

-> Most addresses are sorted to the last name (at least
-> where I'm from), so the sorting is doing according to the
-> last name.

EXPORT PROC cmp(item:PTR TO address) OF address
 RETURN self.lname.cmp(item.lname)
ENDPROC

-> This helps determine how much 'write' will require.

EXPORT PROC size() OF address
 DEF out
 out := self.lname.size() + self.street.size() + self.city.size() + self.phone.size() + self.fname.size() + 40
ENDPROC out

-> write() comes up with a text suitable to printing out an
-> address.  Could be neater, but hey, it's only an example.

EXPORT PROC write() OF address
 DEF out
 out:=String(self.size())
 StringF(out,'Name: "\s, \s"\nStreet: \s\nCity: \s\nPhone: \s\n',self.lname.write(),
 							     self.fname.write(),
 							     self.street.write(),
							     self.city.write(),
							     self.phone.write())
ENDPROC out

-> This is a unique id # for address: "addr"

EXPORT PROC id() OF address IS "addr"

-> Tons-o-stuff to deallocate.

EXPORT PROC end() OF address
 DEF tmp:PTR TO string
 tmp:=self.street
 END tmp
 tmp:=self.city
 END tmp
 tmp:=self.phone
 END tmp
 tmp:=self.lname
 END tmp
 tmp:=self.fname
 END tmp
ENDPROC
