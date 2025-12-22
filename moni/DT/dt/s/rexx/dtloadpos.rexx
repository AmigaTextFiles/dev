/*** $VER DT_LoadPos 1.2 (31.11.93) ***/

Trace results

Options Results

Address DT.1

offen=Open(dirfile,'EnvArc:DTSavePos','read')
adr=ReadLN(dirfile)
seg=ReadLN(dirfile)
ln=ReadLN(dirfile)
xx=ReadLN(dirfile)
call Close(dirfile)

UnLoad

LOAD LN

stri=xx||'+$'||adr

Breakpoint stri

RUN

Exit
