unit fname;

interface

type f_name_base=record
 path:string;
 name:string;
 ext:string;
end;

type f_name=object
 entered_name,stored_name:f_name_base;

 constructor init;

 procedure enter_fullname(s:string);
 procedure restore_fullname(s:string);
 procedure change_path(s:string);
 procedure change_ext(s:string);
 procedure change_name(s:string);

 function return_fullname:string;
 function return_name:string;
 function return_path:string;
 function return_ext:string;
 function return_xtdname:string;

 destructor done;
end;

implementation

constructor f_name.init;
begin
 self.entered_name.path:='';
 self.entered_name.name:='';
 self.entered_name.ext:='';
end;

procedure f_name.enter_fullname(s:string);

{ split up a filename into the internal structure. }
{ path,filename,extension                          }

var i,ptpos,extpos:byte;
begin

 ptpos:=0;
 extpos:=0;
 for i:= length(s) downto 1 do
 begin
  if(s[i]='\')then
  begin
   if(ptpos=0)then
   begin
    ptpos:=i;
   end;
  end;
  if(s[i]='.')then
  begin
   if(extpos=0)then
   begin
    extpos:=i;
   end;
  end;
 end;

 if(ptpos<>0)then
 begin
  if(extpos<>0)then
  begin
   self.entered_name.path:=copy(s,1,ptpos);
   self.entered_name.name:=copy(s,ptpos+1,extpos-ptpos-1);
   self.entered_name.ext:=copy(s,extpos+1,length(s)-extpos);
  end else
  begin
   self.entered_name.path:=copy(s,1,ptpos);
   self.entered_name.name:=copy(s,ptpos+1,length(s)-ptpos-1);
   self.entered_name.ext:='';
  end;
 end else
 begin
  if(extpos<>0)then
  begin
   self.entered_name.path:='';
   self.entered_name.name:=copy(s,1,extpos-1);
   self.entered_name.ext:=copy(s,extpos+1,length(s)-extpos);
  end else
  begin
   self.entered_name.path:='';
   self.entered_name.name:=copy(s,1,length(s));
   self.entered_name.ext:='';
  end;
 end;
end;

procedure f_name.restore_fullname(s:string);
begin
end;

procedure f_name.change_path(s:string);
begin
 self.entered_name.path:=s;
end;

procedure f_name.change_ext(s:string);
begin
 self.entered_name.ext:=s;
end;

procedure f_name.change_name(s:string);
begin
 self.entered_name.name:=s;
end;

function f_name.return_fullname:string;
begin
 return_fullname:=concat(self.entered_name.path,self.entered_name.name,'.',self.entered_name.ext);
end;

function f_name.return_name:string;
begin
 return_name:=self.entered_name.name;
end;

function f_name.return_path:string;
begin
 return_path:=self.entered_name.path;
end;

function f_name.return_ext:string;
begin
 return_ext:=self.entered_name.ext;
end;

function f_name.return_xtdname:string;
begin
 return_xtdname:=concat(self.entered_name.name,'.',self.entered_name.ext);
end;

destructor f_name.done;
begin
end;

begin
end.