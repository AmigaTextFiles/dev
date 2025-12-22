unit localestuff;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,liststuff,producerlib,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench,producerwininterface;

procedure localestring(stri:string;labl : string;comment:string);
procedure setuplocalestuff;

{
procedure cdfile;
procedure ctfile;
}

implementation

{ add a atring to the list of strings used in the program with locale }

procedure localestring(stri:string;labl : string;comment:string);
var
  s   : string;
begin
  if comment[0]>char(70) then
    comment[0]:=char(70);
  if stri[0]>char(70) then
    stri[0]:=char(70);
  
  stri:=stri+#0;
  labl:=labl+#0;
  comment:=comment+#0;
  if oksofar then
    oksofar:=boolean(AddLocaleString(producernode,@stri[1],@labl[1],@comment[1]));
  
end;

{ create all necessary functions for hspascal to use locale }
{look at c producer for info on how to do it with proper includes }

procedure setuplocalestuff;
var
  loop : word;
  s : string;
  spec : string;
begin
  if not producernode^.codeoptions[13] then
    begin  

      for loop:=1 to 10 do
        addline(@procfunclist,cc[loop],'');
      for loop:=1 to 13 do
        addline(@procfunclist,gls[loop],'');
      for loop:=1 to 13 do
        addline(@procfunclist,oca[loop],'');
  
      addline(@procfuncdefslist,'function GetCatalogStr (catalog: pointer; stringNum: longint;'+
                                ' defaultString: pointer): longint;','');
      addline(@procfuncdefslist,'function CloseCatalog (catalog: pointer): longint;','');  
      addline(@procfuncdefslist,'function OpenCatalogA (locale, name, tags: pointer): pointer;','');
    end;

  addline(@procfunclist,'','');
  addline(@procfunclist,'function '+sfp(producernode^.getstring)
        +'( id : long ):string;','');
  addline(@procfuncdefslist,'function  '+sfp(producernode^.getstring)
        +'( id : long ):string;','');
  addline(@procfunclist,'var','');
  addline(@procfunclist,'  temp : string;','');
  addline(@procfunclist,'  p    : pbyte;','');
  addline(@procfunclist,'begin','');
  addline(@procfunclist,'  p:='+sfp(producernode^.getstring)
         +'ptr( id );','');
  addline(@procfunclist,'  ctopas(p^,temp);','');
  addline(@procfunclist,'  '+sfp(producernode^.getstring)
         +':=temp;','');
  addline(@procfunclist,'end;','');
  
  { write ptr to string}
  
  addline(@procfunclist,'','');
  addline(@procfunclist,'function '+sfp(producernode^.getstring)
          +'ptr( id : long ):pbyte;','');
  addline(@procfuncdefslist,'function '+sfp(producernode^.getstring)+'ptr( id : long ):pbyte;','');
  addline(@procfunclist,'begin','');
  addline(@procfunclist,'  if '+sfp(producernode^.basename)+'_Catalog<>nil then','');
  addline(@procfunclist,'    '+sfp(producernode^.getstring)+'ptr:=pbyte(GetCatalogStr('
          +sfp(producernode^.basename)+'_Catalog, id, STRPTR(@Programstrings[id,1])))','');
  addline(@procfunclist,'   else','');
  addline(@procfunclist,'    '+sfp(producernode^.getstring)+'ptr:=pbyte(@ProgramStrings[id,1]);','');
  addline(@procfunclist,'end;','');

  if producernode^.codeoptions[13] then
    addline(@varlist,'  '+sfp(producernode^.basename)+'_Catalog : pCatalog;','')
   else
    addline(@varlist,'  '+sfp(producernode^.basename)+'_Catalog : pointer;','');
  
  addline(@initlist,'  '+sfp(producernode^.basename)+'_Catalog:=nil;','');
  
  str(length(sfp(producernode^.builtinlanguage))+1,s);
  addline(@constlist,'  '+sfp(producernode^.basename)+
     '_BuiltInLanguage : string['+s+'] = '''+sfp(producernode^.builtinlanguage)+'''#0;','');
  
  str(length(sfp(producernode^.basename))+9,s);
  addline(@constlist,'  '+sfp(producernode^.basename)+
      '_CatName : string['+s+'] = '''+no0(sfp(producernode^.basename))+'.catalog''#0;','');
  
  addline(@initlist,'  LocaleBase:=nil;','');
  
  spec:='pointer';
  
  if producernode^.codeoptions[13] then
    spec:='pLocale';
  
  addline(@procfuncdefslist,'procedure Open'+sfp(producernode^.basename)+'Catalog(loc : '+spec+' ;lang : pbyte);','');
  addline(@procfunclist,'','');
  addline(@procfunclist,'procedure Open'+sfp(producernode^.basename)+'Catalog(loc : '+spec+' ;lang : pbyte);','');
  addline(@procfunclist,'var','');
  addline(@procfunclist,'  tags : array[1..5] of ttagitem;','');
  addline(@procfunclist,'begin','');
  addline(@procfunclist,'  tags[1].ti_data:=long(lang);','');
  addline(@procfunclist,'  if lang<>nil then','');
  addline(@procfunclist,'    tags[1].ti_tag:=$80090004','');
  addline(@procfunclist,'   else','');
  addline(@procfunclist,'    tags[1].ti_tag:=tag_ignore;','');
  addline(@procfunclist,'  settagitem(@tags[2],$80090001,long(@'+sfp(producernode^.basename)+'_BuiltInLanguage[1]));','');
  str(producernode^.localeversion,s);
  addline(@procfunclist,'  settagitem(@tags[3],$80090003,'+s+');','');
  addline(@procfunclist,'  tags[4].ti_tag:=tag_done;','');
  addline(@procfunclist,'  if (localebase<>nil) and ('+sfp(producernode^.basename)+'_Catalog = nil) then','');
  addline(@procfunclist,'    '+sfp(producernode^.basename)+'_Catalog:=OpenCatalogA(loc,@'+
       sfp(producernode^.basename)+'_CatName[1], @tags[1]);','');
  addline(@procfunclist,'end;','');
  
  addline(@procfunclist,'','');
  
  addline(@procfuncdefslist,'Procedure Close'+sfp(producernode^.basename)+'Catalog;','');
  addline(@procfunclist,'Procedure Close'+sfp(producernode^.basename)+'Catalog;','');
  addline(@procfunclist,'begin','');
  addline(@procfunclist,'  if localebase<>nil then','');
  if producernode^.codeoptions[13] then
    addline(@procfunclist,'    CloseCatalog('+sfp(producernode^.basename)+'_Catalog);','')
   else
    addline(@procfunclist,'    if 0=CloseCatalog('+sfp(producernode^.basename)+'_Catalog) then;','');
  addline(@procfunclist,'  '+sfp(producernode^.basename)+'_Catalog:=nil;','');
  addline(@procfunclist,'end;','');

end;

end.