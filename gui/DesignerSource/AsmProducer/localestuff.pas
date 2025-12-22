unit localestuff;

interface

uses utility,layers,gadtools,exec,intuition,dos,routines,producerlib,
     amigados,graphics,definitions,iffparse,amiga,asl,workbench;



procedure setuplocalestuff;

implementation

procedure setuplocalestuff;
var
  s: string;
begin
  
  if not producernode^.codeoptions[4] then
    addline(@constlist,'    XREF    _LocaleBase','');
  
  
  addline(@constlist,'','');
  addline(@constlist,sfp(producernode^.basename)+'_Catalog:','');
  addline(@constlist,'    dc.l    0','');
  
  addline(@constlist,'','');
  addline(@constlist,sfp(producernode^.basename)+'_BuiltInLanguage:','');
  addline(@constlist,'    dc.b    '''+sfp(producernode^.builtinlanguage)+''',0','');
  addline(@constlist,'','');
  addline(@constlist,'CatalogName:','');
  addline(@constlist,'    dc.b    '''+sfp(producernode^.basename)+'.catalog'',0','');
  addline(@constlist,'    cnop    0,2','');
  
  addline(@constlist,'','');
  addline(@constlist,'OpenCatalogTags:','');
  addline(@constlist,'    dc.l    $80090004,0','OC_Language');
  addline(@constlist,'    dc.l    $80090001,'+sfp(producernode^.basename)+'_BuiltInLanguage','OC_BuiltInLanguage');
  str(producernode^.localeversion,s);
  addline(@constlist,'    dc.l    $80090003,'+s,'OC_Version');
  addline(@constlist,'    dc.l    0','TAG_DONE');
  addline(@constlist,'','');


addline(@externlist,'    XREF    Open'+sfp(producernode^.basename)+'Catalog','Parameters are a0=locale, a1=language');
addline(@procfunclist,'    XDEF    Open'+sfp(producernode^.basename)+'Catalog','Parameters are a0=locale, a1=language');

addline(@procfunclist,'Open'+sfp(producernode^.basename)+'Catalog:','Parameters are a0=locale, a1=language');
{
addline(@procfunclist,'*   a0 = Locale','');
addline(@procfunclist,'*   a1 = Language','');
}
addline(@procfunclist,'    movem.l a2/a6,-(sp)','Save Regs');
addline(@procfunclist,'    lea     OpenCatalogTags,a2','Store Language');
addline(@procfunclist,'    move.l  a1,4(a2)','');
addline(@procfunclist,'    bne     Open'+sfp(producernode^.basename)+'Catalog1','Skip first tag if empty');
addline(@procfunclist,'    lea     8(a2),a2','');
addline(@procfunclist,'Open'+sfp(producernode^.basename)+'Catalog1:','');
addline(@procfunclist,'    move.l  _LocaleBase,a6','Call locale OpenCatalog');
addline(@procfunclist,'    move.l  a6,d0','Locale opened?');
addline(@procfunclist,'    beq     Open'+sfp(producernode^.basename)+'CatalogEnd','No, skip');
addline(@procfunclist,'    tst.l   '+sfp(producernode^.basename)+'_Catalog','Catalog opened?');
addline(@procfunclist,'    bne     Open'+sfp(producernode^.basename)+'CatalogEnd','Yes, skip');
addline(@procfunclist,'    lea     CatalogName,a1','');
addline(@procfunclist,'    jsr     OpenCatalogA(a6)','');
addline(@procfunclist,'    move.l  d0,'+sfp(producernode^.basename)+'_Catalog','');
addline(@procfunclist,'Open'+sfp(producernode^.basename)+'CatalogEnd:','');
addline(@procfunclist,'    movem.l (sp)+,a2/a6','');
addline(@procfunclist,'    rts','');
addline(@procfunclist,'','');

addline(@externlist,'    XREF    Close'+sfp(producernode^.basename)+'Catalog','');
addline(@procfunclist,'    XDEF    Close'+sfp(producernode^.basename)+'Catalog','');


addline(@procfunclist,'Close'+sfp(producernode^.basename)+'Catalog:','');
addline(@procfunclist,'    move.l  a6,-(sp)','');
addline(@procfunclist,'    move.l  '+sfp(producernode^.basename)+'_Catalog,a0','Close the Catalog, if needed');
addline(@procfunclist,'    move.l  #0,'+sfp(producernode^.basename)+'_Catalog','');
addline(@procfunclist,'    move.l  _LocaleBase,a6','');
addline(@procfunclist,'    move.l  a6,d0','Locale.library opened?');
addline(@procfunclist,'    beq     Close'+sfp(producernode^.basename)+'CatalogEnd','No, skip');
addline(@procfunclist,'    jsr     CloseCatalog(a6)','');
addline(@procfunclist,'Close'+sfp(producernode^.basename)+'CatalogEnd:','');
addline(@procfunclist,'    move.l  (sp)+,a6','');
addline(@procfunclist,'    rts','');
addline(@procfunclist,'','');

addline(@externlist,'    XREF    '+sfp(producernode^.getstring),'parameter : d0=string id');
addline(@procfunclist,'    XDEF    '+sfp(producernode^.getstring),'');

addline(@procfunclist,sfp(producernode^.getstring)+':','parameter : d0=string id');
addline(@procfunclist,'    movem.l d1-d2/a0-a2/a6,-(sp)','Save regs');

addline(@procfunclist,'    movea.l _LocaleBase,a6','See if locale library open');
addline(@procfunclist,'    move.l  a6,d1','');
addline(@procfunclist,'    beq     '+sfp(producernode^.getstring)+'Default','if No get default skip');
addline(@procfunclist,'    movea.l '+sfp(producernode^.basename)+'_Catalog,a0','See if catalog open');
addline(@procfunclist,'    move.l  a0,d1','');
addline(@procfunclist,'    beq     '+sfp(producernode^.getstring)+'Default','');
addline(@procfunclist,'    jsr     GetCatalogStr(a6)','');
addline(@procfunclist,sfp(producernode^.getstring)+'Done:','');
addline(@procfunclist,'    movem.l (sp)+,d1-d2/a0-a2/a6','');
addline(@procfunclist,'    rts','');
addline(@procfunclist,sfp(producernode^.getstring)+'Default:','');
addline(@procfunclist,'    lea     '+sfp(producernode^.basename)+'_Strings,a0','Get default string');
addline(@procfunclist,'    mulu    #4,d0','Get string offset');
addline(@procfunclist,'    adda.l  d0,a0','Get address of adress of string');
addline(@procfunclist,'    move.l  (a0),d0','');
addline(@procfunclist,'    jmp     '+sfp(producernode^.getstring)+'Done','');


addline(@localeidlist,'','');

end;


end.