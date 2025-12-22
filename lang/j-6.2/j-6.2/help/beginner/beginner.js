NB. Frames for "A Beginner's look at J".

t=.0 0$''
t=.t,'     A beginner''s look at J'
t=.t,'-------------------------------------------'
t=.t,'Enter      Effects'
t=.t,'-------------------------------------------'
t=.t,'(cr)       Exit'
t=.t,'?          This note'
t=.t,'??         Table of contents'
t=.t,'(space)    Next frame'
t=.t,'x          Select a particular frame'
bhelp=.t

read   =. 1!:1
pr     =. 1!:2&2
uncap  =. '((a.,~a.{~65+i.26)i.y.){a.,~a.{~97+i.26':''
bframes =. <&read ('be.dir/f'&,)&(,&'')&":&.>i.19
bhdr    =. 32{.&>bframes
bdir    =. uncap (|.~ ' '&=&{.)&(_2&{.)"1 bhdr

t=.0 0$''
t=.t,'i=.0'
t=.t,'n=.#bframes'
t=.t,'pr bhelp'
t=.t,'$.=.3,~4+(3 2$''...???'')i._2{.''..'',x=.uncap read 1'
t=.t,'$.=.$0'
t=.t,'pr bhelp'
t=.t,'pr (j{.x),"1 ''   '',"1 (j=.2%~#x)}.x=.bhdr,(2|n,1)$'' '''
t=.t,'i=.n|>:i [ pr>i{bframes [ i=.+/(0 1=n>j)*i,j=.((n,1>.#x){.bdir)i.x'
b =. t : ''


