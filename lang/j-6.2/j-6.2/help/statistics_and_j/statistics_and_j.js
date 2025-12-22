NB. Means
x=. 2.3 5 3.5 6
a=. i. 3 4
am=. +/ % #
gm=. # %: */
hm=. % @ am @ %
means=. am,gm,hm

NB. Variances I
w=. 12 18 24 30 36 42 48
y=. 5.27 5.68 6.25 7.21 8.02 8.71 8.42
dev=. - am
ss=. +/ @ *: @ dev
var=. ss % <:@#
sd=. %: @ var
sp=. +/ @ (*~ dev)
cov=. sp % <:@#@]
corr=. cov % *~&sd

NB. Median and quartiles
c=. 22 14 32 30 19 16 28 21 25 31
c1=. 5.2 3.1 2.9 4.5
c2=. 163 171 174 177 176 181 173 176 168 172 175 169 174 179 168
midpt=. -:@<:@#
median=. -:@(+/)@((<. , >.)@midpt { /:~)
qtrpt=. 0.25&*@(-&2)@([*#@])
ptwts=. (1&- , ])@(1&|)@qtrpt
quartile=. +/@(ptwts * ((<. , >.)@qtrpt {  /:~@]))
q1=. 1&quartile
q2=. 2&quartile
q3=. 3&quartile
median1 =. q2
five=. <./ , q1 , q2 , q3 , >./

NB. Tabulations
a=. 1 1 0 3 1 3 1
nni=. i. @ >:
nub=. ~.
dis =. =
fr=. +/"1 @ dis
onub=. /:~ @ nub
odis=. = @ /:~
ofr=. +/"1 @ odis
rng=. nni @ (>./)
rdis=. rng=/]
rfr=. +/"1 @ rdis
mdis=. (nni@[)=/]
efr=. +/"1 @ ((nni @ [) =/])
frt=. (nni@[) ,"0 efr
dev1=. '(- am) y.' : ''
dev2=. '(- am) y.' : ' x. ^~ (- am) y.'
dev3=. '1 dev3 y.' : 'x. ^~ (- am) y.'
frtab=. '(>./y.) frt y.' : 'x. frt y.'

NB. Barcharts
bars=. ]@#&'*'
barchart=. [ ; (bars@}."1@])

NB. Simulation
dice1=. >:@?@(6&($~)@([,]))
die=. 1&dice1
ri=. [+?@>:@(]-[)
rr=. ] %~ (0&ri@])
dice2=. 1&ri@(6&($~)@([*]))
coords=. rr@(($&100000)@(2&*@]))
incircle=. +/@(1&>:)@(_2&(+/\)@*:@coords)
pi=. 4&% * incircle
s0=. 'r=. 0'
s1=. 'n=. x.'
s2=. '$.=. > (n = 0) { (<3 4 5),<6'
s3=. 'r=. r + incircle y.'
s4=. 'n=. <: n'
s5=. '$.=. 2'
s6=. 'r=. 4 * r % x. * y.'
s=. s0;s1;s2;s3;s4;s5;s6
pi1=. '1 pi1 y.' : s


NB. Poisson distribution
NB. d=. 0 2 2 1 0 0 1 1 0 3 0 2 1 0 0 1 0 1 0 1
NB. d=. d,: 0 0 0 2 0 3 0 2 0 0 0 1 1 1 0 2 0 3 1 0
NB. d=. d, 0 0 0 2 0 2 0 0 1 1 0 0 2 1 1 0 0 2 0 0
NB. d=. d, 0 0 0 1 1 1 2 0 2 0 0 0 1 0 1 2 1 0 0 0
NB. d=. d, 0 1 0 1 1 1 1 0 0 0 0 1 0 0 0 0 1 1 0 0
NB. d=. d, 0 0 0 0 2 1 0 0 1 0 0 1 0 1 1 1 1 1 1 0
NB. d=. d, 0 0 1 0 2 0 0 1 2 0 1 1 3 1 1 1 0 3 0 0
NB. d=. d, 1 0 1 0 0 0 1 0 1 1 0 0 2 0 0 2 1 0 2 0
NB. d=. d, 1 0 0 0 1 0 0 1 0 0 0 0 1 0 0 0 1 1 0 1
NB. d=. d, 0 0 0 0 0 2 1 1 1 0 2 1 1 0 1 2 0 1 0 0
NB. d=. d, 0 0 1 1 0 1 0 2 0 2 0 0 0 0 2 1 3 0 1 1
NB. d=. d, 0 0 0 0 2 4 0 1 3 0 1 1 1 1 2 1 3 1 3 1
NB. d=. d, 1 1 2 1 1 3 0 4 0 1 0 3 2 1 0 2 1 1 0 0
NB. d=. d, 0 1 0 0 0 0 0 1 0 1 1 0 0 0 2 2 0 0 0 0
pd=. ^ * ((^&-@[)%(!@]))


NB. Binomial distribution
tt=. ,@{@(]@#&(<0 1))
ttkey=. >@(+/ &. >)@tt
bcoeff=. fr@ttkey
brng=. <"0@i.@>:
bsf=. ({&'FS' &. >)@tt
grbsf=. ttkey </. bsf
bpr=. (*/ &. >)@,@{@(] # (<@|@(1&-@[ , [)))
grbpr=. ttkey@] </. >@bpr
bd=. <"0@>@(+/ &. >)@grbpr
bsum=. (brng@]),"0 1(grbsf@],"0 0 bd)
bc=. i.@>:!]

NB. Variances II
d=. 1 4 2 2 1 3;0 6 4 3 1 5;10 17 13 14 12 15
varlist=. var"1@>
PT=. i.@! A. i.
rtake=. {."1
rsort=. /:~"1
C=. nub@:rsort@([ rtake PT@])
first=. >@(0&{)
second=. >@(1&{)
dispairs=. (2&C@#) { ]
covarlist=. (first cov second)"1 @ dispairs
corrlist=. (first corr second)"1 @ dispairs
allpairs=. ((2&#@#) #: (i.@*:@#)) { ]
vctable=. (2&#@#) $ (first cov second)"1 @ allpairs
corrtable=. (2&#@#) $ (first corr second)"1 @ allpairs

NB. Regression
w=. 12 18 24 30 36 42 48
y=. 5.27 5.68 6.25 7.21 8.02 8.71 8.42
d0=. w;y
d=. 1 4 2 2 1 3;0 6 4 3 1 5;10 17 13 14 12 15
am=. +/%#
dev=. -am
indepvar=. (1&,"1)@|:@(>@}:)
depvar=. ;@{:

s0=. 'b=. (y=. depvar y.)%.X=. indepvar y.'
s1=. 'sst=. +/*:(y-am y)'
s2=. 'ssr=. sst-sse=. +/*:(y-yest=. X +/ . * b)'
s3=. 'F=. (msr=. ssr%k)%mse=. sse%_1+(n=. $y)-k=. <:#y.'
s4=. 'rsq=. ssr%sst'
s5=. 'seb=. %:(0{mse)*(<1 0)|:%.(|:X)+/ . * X'
t0=. 'r=. 49{.''             Var.    Coeff.      S.E.         t'''
t1=. 'r=. r, 15.0 12.5 12.5 10.2 ": (i. >:k),. b,. seb,. b%seb'
t2=. 'r=. r, '' '''
t3=. 'r=. r, ''  Source     D.F.    S.S.        M.S.         F'''
t4=. 'r=. r, ''Regression'', 5.0 12.5 12.5 10.2 ": k, ssr,msr,F'
t5=. 'r=. r, ''Error     '', 5.0 12.5 12.5": (n-k+1), sse, mse'
t6=. 'r=. r, ''Total     '', 5.0 12.5 ": (n-1), sst'
t7=. 'r=. r, '' '''
t8=. 'r=. r, ''S.E. of estimate    '', 10.5":%:mse'
t9=. 'r=. r, ''Corr. coeff. squared'', 10.5": rsq'
z=. s0;s1;s2;s3;s4;s5;t0;t1;t2;t3;t4;t5;t6;t7;t8;t9
reg=. z : ''

NB. Analysis of variance
a=. 25 7 21 4 10 16 5 21 4 25 7 6
a=. a, 3 6 16 18 20 18 19 17 16 2 15 6
a=. a, 13 23 8 25 19 19 20 14 23 9 10 18
a=. a, 27 26 19 24 13 9 19 13 20 18 16 12
a=. 2 4 6 $ a
x=. i. 3 5
y=. i. 2 3 4
tt=. ,@{@(]@#&(<0 1))
T=. '' : '+/^:(+/-.x.)(/:x.)|:y.'
SS=. (+/@((*:@,)@T)) % (*/@(-.@[ # $@]))
allSS=. (>@tt@#@$) SS"1 _ ]

