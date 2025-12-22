'J Tutorial'

t=.0 0$''
t=.t,'   J Tutorial'
t=.t,'-------------------------------------------'
t=.t,'Enter      Effects'
t=.t,'-------------------------------------------'
t=.t,'(cr)       Exit'
t=.t,'?          This note'
t=.t,'??         Table of contents'
t=.t,'(space)    Next frame'
t=.t,'x          Select a particular frame'
t=.t,'           (e.g. E selects Classifications)'
help=.t

read   =. 1!:1
pr     =. 1!:2&2
uncap  =. '((a.,~a.{~65+i.26)i.y.){a.,~a.{~97+i.26':''
frames =. <&read ('tut/tut'&,)&(,&'.js')&":&.>i.47
hdr    =. 32{.&>frames
dir    =. uncap (|.~ ' '&=&{.)&(_2&{.)"1 hdr

t=.0 0$''
t=.t,'i=.0'
t=.t,'n=.#frames'
t=.t,'pr help'
t=.t,'$.=.3,~4+(3 2$''...???'')i._2{.''..'',x=.uncap read 1'
t=.t,'$.=.$0'
t=.t,'pr help'
t=.t,'pr (j{.x),"1 ''   '',"1 (j=.2%~#x)}.x=.hdr,(2|n,1)$'' '''
t=.t,'i=.n|>:i [ pr>i{frames [ i=.+/(0 1=n>j)*i,j=.((n,1>.#x){.dir)i.x'
tutorial =. t : ''
