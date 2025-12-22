NB. Arithmetic mean
w=. 2.3 5 3.5 6
am=. +/ % #
sum=. +/
tally=. #
AM=. sum % tally
a=. i. 3 4

NB. Geometric and harmonic means
gm=. # %: */
hm=. % @ am @ %
means=. am,gm,hm
prod=. */
root=. %:
recip=. %
GM=. tally root prod
HM=. recip @ am @ recip

NB. Variance and standard deviation
dev=. - am
ss=. +/ @ *: @ dev
var=. ss % <:@#
sd=. %: @ var

NB. Median and quartiles
u=. 22 14 32 30 19 16 28 21 25 31
sort=. /:~
midindices=. (<. , >.) @ -: @ <: @ #
midvalues=. midindices { ]
q1=. am @ midvalues
median=. q1 @ sort
q0=. q1 @ ((q1 > ]) # ])
FirstQuartile=. q0 @ sort
q2=. q1 @ ((q1 < ]) # ])
ThirdQuartile=. q1 @ sort
Five=. ({.,q0,q1,q2,{:) @ sort

NB. Frequency distributions
over=. ({.,.@;}.)@":@,
by=. ' '&;@,.@[,.]
a=. 1 1 0 3 1 3 1
d=. 1 5 2 4 6 5 1 6 2 5
fr=. +/"1 @ =   NB. fr=. #/.~
frtab=. ~. ,"0 fr
rfr=. +/"1 @ (=/)
rfrtab=. [ ,"0 rfr
DieFr=. 1 2 3 4 5 6&rfr
CtoI=. >. @ ((] - -:@[) % [)

NB. Barcharts
barchart=. ~. ;"0 (#&'*' &. >) @  fr
rbarchart=. [ ;"0 (#&'*' &. >) @  rfr

NB. Stem and leaf plot
U=. 14 16 19 21 22 25 28 30 31 32
div=. <. @ %
stem=. 10&* @ div&10
leaf=. 10&|
slplot=. (~. @ stem ;"0 stem </. leaf) @ sort

NB. Binomial trials
cp=. , @ { @ (] # < @ (-. , ]) @ [)
succ=. +/"1 @ > @ (1&cp)
prob=. */"1 @ > @ cp
bc=. #/.~ @ succ  NB. bc=. i.@>: ! ]
bp=. succ@] +//. prob

NB. Simulation
die=. >: @ ? @ $&6
dice=. >: @ ? @ (6&($~)@,)
TwoDice=. 2&dice
SumTwoDice=. +/ @ TwoDice
SumTwoDiceFr=. (2&+@i. 11)&rfr@SumTwoDice
EqualTwoDice=. =/ @ TwoDice
NewDice=. (-@[) <\ >: @ ? @ (6&($~)@*)
SumTwoNewDice=. +/"1 @ > @ (2&NewDice)

NB. Central limit theorem 
SumDice=. +/"1 @ > @ NewDice
ExpSum=. 3.5&*
SDSum=. %:@(2.91667&*)
SU=. (] - ExpSum@[) % SDSum@[ 
ISU=. 0.5&CtoI 
CLTchart=. (_6 _5 _4 _3 _2 _1 0 1 2 3 4 5 6)&rbarchart
CLTdemo=. CLTchart @ ISU @ ([ SU SumDice)

NB. Probability distributions
cdf=. '+/ @ ([ x.f. (i. @ >: @ ]))' : 1
bd=. (x!n) * (p^x) * (-.@p=. {:@[) ^ (n=.{.@[) - x=. ]
BD=. bd cdf
pd=. ^@-@[ * ^ % !@]
PD=. pd cdf
gd=. [ * -.@[ ^ ]
GD=. gd cdf
stn=. 0.398942&* @ ^ @ - @ -: @ *: @ ]
STN0=. 1 0.049867347 0.0211410061 0.0032776263
STN0=. STN0, 0.0000380036 0.0000488906 0.000005383
STN1=.0.5&- @ -: @ (_16&(^~)@([ +/ . * ((i. 7)&(^~) @ ])))
STN=. STN0 & STN1 @ ]

NB. Rolling dice
P=. -. @ (] ^~ -.@[)
P1=. (%6)&P
P2=. (%36)&P

NB. Linear regression
x1=. 12 18 24 30 36 42 48
y1=. 5.27 5.68 6.25 7.21 8.02 8.71 8.42
s0=. 'b=. y.%.X=.1,"0 x.'
s1=. 'sst=. +/*:y.-am y.'
s2=. 'sse=. +/*:y.- X +/ . * b'
s3=. 'mse=. sse%<:<:$y.'
s4=. 'seb=. %:mse%+/*:x.-am x.'
s5=. 'r=. ''Regression coefficient'',10.5":{:b'
s6=. 'r=. r,: ''   Standard error     '',10.5":seb'
s7=. 'r=. r,''Intercept             '',10.5":{.b'
s8=. 'r=. r,''St. error of estimate '',10.5":%:mse'
s9=. 'r=. r,''Corr. coeff. squared  '',10.5":1-sse%sst'   
s=. s0;s1;s2;s3;s4;s5;s6;s7;s8;s9   
linreg=. '' : s
dev1=. '(- am) y.' : ''
dev2=. '(- am) y.' : ' x. ^~ (- am) y.'
dev3=. '1 dev3 y.' : ' x. ^~ (- am) y.'
s0=. 'r=. 0$0'
s1=. '$.=. > (y. = #r) { (<2 3), <4'
s2=. 'r=. r, < >: ? x.$6'
s3=. '$.=. 1'
s4=. 'r'
s=. s0;s1;s2;s3;s4
DICE=. '' : s

NB. Analysis of variance
x=. 3 4 $ 4 7 5 6 9 4 3 8 2 5 7 3 
T=. '' : '+/^:(+/-.x.)(/:x.)|:y.'
S=. (+/@((*:@,)@T)) % (*/@(-.@[ # $@]))

NB. Appendix 2. Multiple regression calculations
d0=. 1 4 2 2 1 3;0 6 4 3 1 5;10 17 13 14 12 15
s0=. 'b=. (y=. ;@{: y.)%.X=.(1&,"1)@|:@(>@}:) y.'
s1=. 'sst=. +/*:(y-am y)'
s2=. 'ssr=. sst-sse=. +/*:(y- X +/ . * b)'
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

NB. Appendix 3. Analysis-of-variance calculations
tt=. ,@{@(]@#&(<0 1))
T=. '' : '+/^:(+/-.x.)(/:x.)|:y.'
S=. (+/@((*:@,)@T)) % (*/@(-.@[ # $@]))
allS=. (>@tt@#@$) S"1 _ ]
stt=. <"1@|."1@(/: +/"1)@(>@tt)
alphabet=. 'ABCDEF'
tag=. ]#({.&alphabet)@#@]
numtag=. (({.&alphabet)@(#@$@])) e. [
alltags=. (tag &. >)@(1&}.)@stt
expand=. /:@\:@[{#@[{.]
ps=. <"1@expand"1 >@stt@(+/)
ss=. | @ (-/) @ (>@ps@([numtag]) (+/"1@[ +//. S"1 _) ])
df=. */@<:@(numtag # $@])
term=. ss (] , [ , %) df
allterms=. (>@[) term"1 _ ]
s0=. '(alltags #$y.) AOV y.'
t0=. 'AOVtable=. x. allterms y.'
t1=. 'Labels=. 8{."1 >x.'
t2=. 'dfTotal=. <:*/$y.'
t3=. 'ssTotal=. (+/*:,y.) - '''' ss y.'
t4=. 'dfError=. dfTotal - +/0{"1 AOVtable'
t5=. '$.=. > (dfError=0) { (<6 7 8 9 10 11),<9 10 11'
t6=. 'ssError=. ssTotal - +/1{"1 AOVtable'
t7=. 'AOVtable=. AOVtable,ssError(],[,%)dfError'
t8=. 'Labels=. Labels,''Error'''
t9=. 'r=. Labels,"1 (5 12.5 12.5)":AOVtable'
t10=. 'AOVtable=: AOVtable,TotalRow=. dfTotal,ssTotal'
t11=. 'r, ''Total   '',5 12.5":TotalRow'
t=. t0;t1;t2;t3;t4;t5;t6;t7;t8;t9;t10;t11
AOV=. s0 : t
Model1=. 'A';'B';'AB';'C';'AC';'BC';'ABC';'D'
TestData=. 25 7 21 4 10 16 5 21 4 25 7 6
TestData=. TestData, 3 6 16 18 20 18 19 17 16 2 15 6
TestData=. TestData, 13 23 8 25 19 19 20 14 23 9 10 18
TestData=. TestData, 27 26 19 24 13 9 19 13 20 18 16 12
TestData=. 2 4 6 $ TestData

NB. Appendix 4. Coupon collector's problem
c0=. * +/ @ % @ >: @ i.
pos=. >: @ i. 
c=. * +/ @ % @ pos
cc=. c"0 @ pos
int=. ". @ (6.0&":) 
cctable=. (5&*@i.@[) by (pos@]) over int @ cc @,
Prize=. >: @ ?
s0=. 'r=. 0 $ 0'
s1=. '$.=. > (y. = # ~. r) { (<2 3),<4'
s2=. 'r=. r, Prize y.'
s3=. '$.=. 1'
s4=. 'r'
s=. s0;s1;s2;s3;s4
ccsim=. s : ''
ccsample=. (#@ccsim)"0@# 
ccnext=. ] , Prize @ [
ccsim0=. ccnext ^: ([ > # @ ~. @ ]) & ''

NB. ***** END OF SCRIPT FILE *****