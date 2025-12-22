OPT MODULE
OPT EXPORT
-> address.e by Trey Van Riper of the Cheese Olfactory Workshop

MODULE 'oomodules/sort/string','oomodules/sort'

-> address.e is a derived object from 'sortobj', but we'll sort to lname.

OBJECT address OF sort
 lname:PTR TO string
 fname:PTR TO string
 street:PTR TO string
 city:PTR TO string
 phone:PTR TO string
ENDOBJECT 

PROC size() OF address IS 48

PROC name() OF address IS 'Address'

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

-> select() does tons-o-stuff for new()

PROC select(opt,i) OF address
 DEF item
 item:=ListItem(opt,i)
 SELECT item
  CASE "set"
   INC i
   self.set(ListItem(opt,i))
  CASE "sfnm"
   INC i
   self.setFname(ListItem(opt,i))
  CASE "slnm"
   INC i
   self.setLname(ListItem(opt,i))
  CASE "scty"
   INC i
   self.setCity(ListItem(opt,i))
  CASE "sstr"
   INC i
   self.setStreet(ListItem(opt,i))
  CASE "sphn"
   INC i
   self.setPhone(ListItem(opt,i))
 ENDSELECT
ENDPROC i

-> Sets the first name.

PROC setFname(in) OF address
 self.fname.set(in)
ENDPROC

-> These two functions set the last name.

PROC set(in) OF address
 self.setLname(in)
ENDPROC

PROC setLname(in) OF address
 self.lname.set(in)
ENDPROC

-> Sets the Street address.

PROC setStreet(in) OF address
 self.street.set(in)
ENDPROC

-> Sets the City/State

PROC setCity(in) OF address
 self.city.set(in)
ENDPROC

-> Sets the phone #.

PROC setPhone(in) OF address
 self.phone.set(in)
ENDPROC

-> Most addresses are sorted to the last name (at least
-> where I'm from), so the sorting is doing according to the
-> last name.

PROC cmp(item:PTR TO address) OF address IS self.lname.cmp(item.lname)

-> This helps determine how much 'write' will require.

PROC length() OF address
 DEF out
 out := self.lname.length() + self.street.length() + self.city.length() +
        self.phone.length() + self.fname.length()  + 40
ENDPROC out

-> write() comes up with a text suitable to printing out an
-> address.  Could be neater, but hey, it's only an example.

PROC write() OF address
 DEF out
 out:=String(self.length())
 StringF(out,'Name: "\s, \s"\nStreet: \s\nCity: \s\nPhone: \s\n',self.lname.write(),
 							     self.fname.write(),
 							     self.street.write(),
							     self.city.write(),
							     self.phone.write())
ENDPROC out

-> This is a unique id # for address: "addr"

PROC id() OF address IS "addr"

-> Tons-o-stuff to deallocate.

PROC end() OF address
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
