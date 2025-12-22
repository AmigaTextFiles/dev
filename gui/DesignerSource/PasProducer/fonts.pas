unit fonts;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,liststuff,producerlib,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench;

function makemyfont(font:ttextattr):string;
procedure doopendiskfonts;

implementation

function makemyfont(font:ttextattr):string;
var
  s    : string[100];
  s2   : string[30];
  s3   : string;
  def  : string;
  loop : word;
  notfound : boolean;
  psn      : pstringnode;
  fontname : string;
begin
  ctopas(font.ta_name^,fontname);
  s3:=no0(fontname)+'", ';
  s:='';
  loop:=1;
  while(fontname[loop]<>'.')and(loop<length(fontname))and(fontname[loop]<>#0) do
    begin
      if okchar(fontname[loop]) then
        s:=s+fontname[loop];
      inc(loop);
    end;
  str(font.ta_ysize,s2);
  s3:=s3+s2+', ';
  s:=s+s2;
  str(font.ta_style,s2);
  s:=s+s2;
  s3:=s3+s2+', ';
  str(font.ta_flags,s2);
  s:=s+s2;
  s3:=s3+s2;
  makemyfont:=s;
  notfound:=true;
  def:='  '+s+' : tTextAttr;';
  psn:=pstringnode(varlist.lh_head);
  while(psn^.ln_succ<>nil) do
    begin
      if no0(psn^.st)=def then
        notfound:=false;
      psn:=psn^.ln_succ;
    end;
  if notfound then
    begin
      addline(@opendiskfontlist,s,'');
      addline(@varlist,def,'');
      str(length(no0(fontname))+1,def);
      addline(@constlist,'  '+s+'Name : string['+def+'] = '''+no0(fontname)+'''#0;','');
      addline(@initlist,'  with '+s+' do','');
      addline(@initlist,'    begin','');
      str(font.ta_ysize,s2);
      addline(@initlist,'      '+s+'.ta_YSize:='+s2+';','');
      str(font.ta_flags,s2);
      addline(@initlist,'      '+s+'.ta_Flags:='+s2+';','');
      str(font.ta_style,s2);
      addline(@initlist,'      '+s+'.ta_Style:='+s2+';','');
      addline(@initlist,'      '+s+'.ta_Name:=@'+s+'Name[1];','');
      addline(@initlist,'    end;','');
    end;
end;

procedure doopendiskfonts;
var
  psn : pstringnode;
begin
  psn:=pstringnode(opendiskfontlist.lh_head);
  addline(@procfuncdefslist,'Function OpenDiskFonts:Boolean;','');
  addline(@procfunclist,'','');
  addline(@procfunclist,'Function OpenDiskFonts:Boolean;','');
  addline(@procfunclist,'Begin','');
  addline(@procfunclist,'  OpenDiskFonts:=True;','');
  while (psn^.ln_succ<>nil) do
    begin
      addline(@procfunclist,'  if nil = (OpenDiskFont(@'+no0(psn^.st)+')) then','');
      addline(@procfunclist,'    OpenDiskFonts:=False;','');
      psn:=psn^.ln_succ;
    end;
  addline(@procfunclist,'end;','');
end;


end.