MODULE 'exec/nodes'

#define IsListEmpty(x)    (x::MLH.TailPred = (x))
#define IsMsgPortEmpty(x) (x::MP.LN.TailPred = x::MP.LN)

OBJECT List|LH
	Head:PTR TO LN,
	Tail:PTR TO LN,
	TailPred:PTR TO LN,
	Type:UBYTE,
	pad:UBYTE

OBJECT MinList|MLH
	Head:PTR TO MLN,
	Tail:PTR TO MLN,
	TailPred:PTR TO MLN
