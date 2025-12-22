/* this file starts Uedit or loads a file */
parse arg file
options failat 5
if ~show('L','rexxarplib.library') then
   call addlib('rexxarplib.library',0,-30,0)
if ~show('L','rexxsupport.library') then
   call addlib('rexxsupport.library',0,-30,0)
if showlist('P','URexx')=0 then do
  address command "RunWsh <NULL: >NULL: DH0:Uedit/uex"
  do i=1 to 10
    if showlist('Ports','URexx') ~= 0 then leave i
    address command 'c:Wait sec 1'
  end
  if showlist('Ports','URexx')=0 then exit
end
file = compress(file, '"')
if (length(file) ~= 0) then
do i = 1 to FileList(file, myfilelist, 'F', E)
  address 'URexx' 'loadfile ' || myfilelist.i
end
