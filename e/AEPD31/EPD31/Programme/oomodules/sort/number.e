OPT MODULE
OPT EXPORT

MODULE 'oomodules/sort'

OBJECT number OF sort
ENDOBJECT

PROC name() OF number IS 'Number'

PROC get() OF number IS EMPTY

PROC cmp(what:PTR TO number) OF number IS EMPTY

PROC add(in:PTR TO number) OF number IS EMPTY

PROC substract(in:PTR TO number) OF number IS EMPTY

PROC multiply(in:PTR TO number) OF number IS EMPTY

PROC power(in:PTR TO number) OF number IS EMPTY

PROC max(in:PTR TO number) OF number IS EMPTY

PROC abs() OF number IS EMPTY

PROC neg() OF number IS EMPTY

PROC min(in:PTR TO number) OF number IS EMPTY

PROC sign() OF number IS EMPTY

PROC bounds(min:PTR TO number,max:PTR TO number) OF number IS EMPTY

PROC rnd(min=0:PTR TO number,max=0:PTR TO number) IS EMPTY
