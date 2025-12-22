   NB.  This file can be used as a script input file to J Version 5.1a.
   NB.  August 1992
   
   NB.  Donald B. McIntyre
   NB.  Luachmhor, 1 Church Road
   NB.  KINFAUNS, PERTH PH2 7LD
   NB.  SCOTLAND - U.K.
   NB.  Telephone:  In the UK:      0738-86-726
   NB.  From USA and Canada:   011-1-738-86-726
   NB.  email:  donald.mcintyre@almac.co.uk

NB. From E.E. McDonnell, Control Structures in J
NB. Notes from "J in Exposition II', 
NB. APL Bay-Area Users Group, Feb 10 Meeting
NB. APL BUG Newsletter (March 1992) p.5-6
NB. Revision: 11 March 1992
NB. Copyright 1992 Iverson Software Inc., Used with permission

NB. Power conjunction:

cos =. 2&o.
b   =. 1
cos b
cos cos b
cos cos cos b
cos cos cos cos b

NB. Power conjunction:  Iteration

power =. ^:
rvli  =. ,.       NB. Ravel items
rvli cos power (i.10) b
infinite =. _
limit    =. power infinite
cos limit b
cos 0.739085

NB. Power conjunction:  Inversion

sqrt  =. %:
sqrt 36 49
inv   =. power _1
sqr   =. sqrt inv
sqr 36 49
sqr sqrt 36 49

g1=. %&1.8     NB. Divide by 1.8
g3=. -&32      NB. Subtract 32
g5=. g1@g3     NB. Celsius from
               NB. Farenheit
g5 _40 32 212
g6=. g5 inv    NB. Farenheit from
               NB. Celsius
g6 _40 0 100

NB. f power boolean y
NB. yields   y   if   boolean is 0
NB. and    f y   if   boolean is 1

! power (2<3) 5   NB. If
! power (2>3) 5

NB. This construction is analogous to the "if" facility
NB. in other programming languages

NB. Gerunds
NB. Agenda construction

NB. if ... then ... else

g =. +`^    NB. Gerund
#g

NB. The tie conjunction ` can make nouns from verbs

a =. <
2 a 3
agenda =. @.

NB. The agenda conjunction creates a verb from its gerund left
NB. argument in accordance with its verb right argument

2 g agenda a 3
3 g agenda a 2

NB. This facility is analogous to the  if... then ... else
NB. construction of other programming languages

NB. Gerund
NB. Agenda construction
NB. Case statement

double =. +:
halve  =. -:
square =. *:
sqrt   =. %:
gerund =. double`halve`square`sqrt
test   =. 4&|
gerund agenda test 99

NB. This is analogous to the case facility in other
NB. programming languages

NB. Gerund
NB. Agenda construction
NB. MIMD

rvli gerund agenda test"0 i.10

NB. The elements of the gerund are repeated as required.
NB. This is the MIMD facility used in parallel processing machines

NB. Insert with gerund

NB. The insert adverb / applies to a gerund in a manner analogous
NB. to its application to a verb.   For example:

c=. 3  [  x=. 4  [  power=. _1
g/ c,x,power
3+x^_1

NB. The elements of the gerund are repeated as required.
NB. For example:

+`*/ 1, x, 3, x, 3, x, 1

NB. This last sentence above corresponds to Horner'e efficient
NB. evaluation of the polynomial with coefficients 1 3 3 1
NB. and argument x.

NB. Recursion using agenda

factorial=.1:`(]*factorial@<:)@.*
factorial "0 i.6

NB. Recursive nonce functions may be used, with self-reference
NB. provided by $:

1:`(]*$:@<:) @. * "0 i. 6

NB. Iteration using power conjunction

NB. We've seen that iteration can proceed to the limit,
NB. but it can also be controlled by a verb.

NB. For example, to add to a beginning value 3 the sum of
NB. successive negative powers of 4, beginning with _1, and
NB. continuing as long as the ratio of the sum to the next
NB. power exceeds 1000:

f=.+`^/ , 1&{ , <:@{:

NB. A test to see whether the ending criterion has been met would
NB. include division of the current sum by the current power of 4

h=. %`^/

NB. And a complete test would see if 1000 were greater than this
NB. or not, yielding 1 if it was, and 0 otherwise.

g=. 1000&>@h

]r=. f r=.3, 4, _1
h r
g r
]r=. f r
h r
g r
]r=. f r
h r
g r
]r=. f r
h r
g r

NB. We can encapsulate the test with the applied verb
NB. using the power conjunction

f^:g 3 4 _1
(f^:g) f.