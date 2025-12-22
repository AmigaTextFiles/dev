
NB. Frames for "The Archaeologist's Problem".

t=.0 0$''
t=.t,'   The Archaeologist''s Problem'
t=.t,'-------------------------------------------'
t=.t,'Enter      Effects'
t=.t,'-------------------------------------------'
t=.t,'(cr)       Exit'
t=.t,'?          This note'
t=.t,'??         Table of contents'
t=.t,'(space)    Next frame'
t=.t,'x          Select a particular frame'
ahelp=.t

read   =. 1!:1
pr     =. 1!:2&2
uncap  =. '((a.,~a.{~65+i.26)i.y.){a.,~a.{~97+i.26':''
aframes =. <&read ('ar.dir/a'&,)&(,&'')&":&.>i.14
ahdr    =. 32{.&>aframes
adir    =. uncap (|.~ ' '&=&{.)&(_2&{.)"1 ahdr

t=.0 0$''
t=.t,'i=.0'
t=.t,'n=.#aframes'
t=.t,'pr ahelp'
t=.t,'$.=.3,~4+(3 2$''...???'')i._2{.''..'',x=.uncap read 1'
t=.t,'$.=.$0'
t=.t,'pr ahelp'
t=.t,'pr (j{.x),"1 ''   '',"1 (j=.2%~#x)}.x=.ahdr,(2|n,1)$'' '''
t=.t,'i=.n|>:i [ pr>i{aframes [ i=.+/(0 1=n>j)*i,j=.((n,1>.#x){.adir)i.x'
a =. t : ''

