OPT MODULE
OPT EXPORT

MODULE 'oomodules/sort'

OBJECT number OF sort
ENDOBJECT

PROC name() OF number IS 'Number'

PROC add(in:PTR TO number) OF number IS self.derivedClassResponse()

PROC subtract(in:PTR TO number) OF number IS self.derivedClassResponse()

PROC multiply(in:PTR TO number) OF number IS self.derivedClassResponse()

PROC power(in:PTR TO number) OF number IS self.derivedClassResponse()

PROC max(in:PTR TO number) OF number IS self.derivedClassResponse()

PROC abs() OF number IS self.derivedClassResponse()

PROC neg() OF number IS self.derivedClassResponse()

PROC min(in:PTR TO number) OF number IS self.derivedClassResponse()

PROC sign() OF number IS self.derivedClassResponse()

PROC bounds(min:PTR TO number,max:PTR TO number) OF number IS self.derivedClassResponse()

PROC rnd(min=0:PTR TO number,max=0:PTR TO number) OF number IS self.derivedClassResponse()
