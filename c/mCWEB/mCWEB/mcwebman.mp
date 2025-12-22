input boxes
%
% original CWEB
%
beginfig(1);
boxit.web(btex\hbox{\tt\ foo.w\ }etex);
boxit.tex(btex\hbox{\tt foo.tex}etex);
boxit.c(btex\hbox{\tt\ foo.c\ }etex);
boxit.dvi(btex\hbox{\tt foo.dvi}etex);
boxit.exe(btex\hbox{\tt\ \ foo\ \ }etex);
web.w=(0,0);
tex.w=web.ne shifted (50,20);
c.w=web.se shifted (50,-20);
dvi.w=tex.e shifted (50,0);
exe.w=c.e shifted (50,0);
drawboxed(web,tex,c,dvi,exe);
drawarrow web.e .. tex.w;
label.lft(btex\hbox{\tt CWEAVE}etex,0.5[web.e,tex.w]-(0,-10));
drawarrow web.e .. c.w;
label.lft(btex\hbox{\tt CTANGLE}etex,0.5[web.e,c.w]-(0,10));
drawarrow tex.e .. dvi.w;
label.top(btex\hbox{\TeX} etex,0.5[tex.e,dvi.w]);
drawarrow c.e .. exe.w;
label.top(btex\hbox{\tt cc} etex,0.5[c.e,exe.w]);
endfig;

%
% data flow of mCWEB
%
beginfig(2);
path p;
pair s,e;
xdist:=60;
ydist:=15;
vardef boxdrawarrow(suffix a,b,xxx)=
	p:=a.c .. b.xxx;
	s:=bpath.a intersectionpoint p;
	e:=bpath.b intersectionpoint p;
	drawarrow s .. e;
enddef;
vardef boxdrawdblarrow(suffix a,b,xxx)=
	p:=a.c .. b.xxx;
	s:=bpath.a intersectionpoint p;
	e:=bpath.b intersectionpoint p;
	drawdblarrow s .. e;
enddef;
%
% create bubbles ctangle & cweave
%
boxjoin(a.e=a.c+(30,0);a.w=a.c-(30,0);a.n=a.c+(0,30);a.s=a.c-(0,30));
circleit.cweave(btex{\tt mCWEAVE}etex);
circleit.ctangle(btex{\tt mCTANGLE}etex);
circleit.dummy1("Dummy");
%
% create boxes for files
%
boxjoin(a.e=a.w+(75,0);a.n=a.c+(0,10);a.s=a.c-(0,10));
boxit.foobar.prg(btex{\tt foobar.prg}etex);
boxit.foo.w(btex{\tt foo.w}etex);
boxit.bar.w(btex{\tt bar.w}etex);
boxit.foo.ch(btex{\tt foo.ch}etex);
boxit.bar.ch(btex{\tt foo.ch}etex);
boxit.foobar.tex(btex{\tt foobar.tex}etex);
boxit.foo.tex(btex{\tt foo.tex}etex);
boxit.bar.tex(btex{\tt bar.tex}etex);
boxit.autodoc.tex(btex{\tt autodoc.tex}etex);
boxit.functions.adc(btex{\tt functions.adc}etex);
boxit.datatypes.adc(btex{\tt datatypes.adc}etex);
boxit.foobar.dvi(btex{\tt foobar.dvi}etex);
boxit.autodoc.dvi(btex{\tt autodoc.dvi}etex);
boxit.makefile(btex{\tt Makefile}etex);
boxit.foobar.exp(btex${\tt foobar.exp}^{\dag}$etex);
boxit.foo.c(btex{\tt foo.c}etex);
boxit.foo.shr(btex{\tt foo.shr}etex);
boxit.foo.exp(btex${\tt foo.exp}^{\dag}$etex);
boxit.bar.c(btex{\tt bar.c}etex);
boxit.bar.shr(btex{\tt bar.shr}etex);
boxit.bar.exp(btex${\tt bar.exp}^{\dag}$etex);
boxit.exe(btex Executable etex);
boxit.dummy2("Dummy");
%
% create ovals
%
boxjoin(a.e=a.w+(75,0);a.n=a.c+(0,20);a.s=a.c-(0,20));
circleit.xidsidiid(btex${\hbox{\strut\tt*.xid}\atop\hbox{\strut\tt*.sid}}\atop\hbox{\strut\tt*.iid}$etex);
circleit.idxscn(btex$\hbox{\strut\tt*.idx}\atop\hbox{\strut\tt*.scn}$etex);
circleit.deprep(btex$\hbox{\strut\tt*.dep}^{\dag}\atop\hbox{\strut\tt*.rep}$etex);
circleit.include(btex$\hbox{\tt *.h}^{\ddag}\atop\hbox{\tt*.exp}^{\dag}$etex);
boxit.dummy("Dummy");
%
% set the bubbles
%
cweave.s=(0,60);
ctangle.n=(0,-60);
%
% set the input files
%
foo.ch.e=(xpart(cweave.w)-xdist,0);
foo.w.sw=foo.ch.nw;
foobar.prg.sw=foo.w.nw;
bar.w.nw=foo.ch.sw;
bar.ch.nw=bar.w.sw;
include.n=(xpart foobar.prg.n,ypart idxscn.n);
%
% set the TeX output files
%
bar.tex.w=cweave.e+(xdist,-40);
foo.tex.sw=bar.tex.nw;
foobar.tex.sw=foo.tex.nw;
foobar.dvi.w=foobar.tex.e+(xdist,0);
%
% set the autodoc files
%
datatypes.adc.sw=foobar.tex.nw+(0,ydist);
functions.adc.sw=datatypes.adc.nw;
autodoc.tex.sw=functions.adc.nw;
autodoc.dvi.w=autodoc.tex.e+(xdist,0);
%
% set idx/scn and xid/sid/iid files
%
idxscn.s=autodoc.tex.n+(0,ydist);
xidsidiid.n=(xpart cweave.n,ypart idxscn.n);
%
% export files
%
foobar.exp.nw=bar.tex.sw-(0,2ydist);
foo.exp.nw=foobar.exp.sw;
bar.exp.nw=foo.exp.sw;
%
% set C files
%
foo.c.nw=bar.exp.sw-(0,ydist);
foo.shr.nw=foo.c.sw;
bar.c.nw=foo.shr.sw-(0,ydist);
bar.shr.nw=bar.c.sw;
makefile.nw=bar.shr.sw-(0,ydist);
deprep.n=(xpart ctangle.n,ypart makefile.s);
%
% draw boxes and bubbles
%
drawboxed(cweave,ctangle,foobar.prg,foo.w,bar.w,foo.ch,bar.ch);
drawboxed(foobar.tex,foo.tex,bar.tex,autodoc.tex,functions.adc,datatypes.adc);
drawboxed(foobar.dvi,autodoc.dvi);
drawboxed(makefile,foo.c,foo.shr,bar.c,bar.shr,foobar.exp,foo.exp,bar.exp);
drawboxed(xidsidiid,idxscn,deprep,include);
%
% draw arrows from input files
%
linejoin:=mitered;
linecap:=butt;
drawarrow 0.4[foo.ch.c,cweave.c] .. 0.7[foo.w.c,cweave.c] withpen pencircle scaled 5 withcolor 0.8white;
drawarrow 0.4[foo.ch.c,ctangle.c] .. 0.7[foo.w.c,ctangle.c] withpen pencircle scaled 5 withcolor 0.8white;
linejoin:=rounded;
linecap:=rounded;
boxdrawarrow(include,cweave,c);
%
% draw arrows to TeX output files
%
boxdrawarrow(cweave,foobar.tex,w);
boxdrawarrow(cweave,foo.tex,w);
boxdrawarrow(cweave,bar.tex,w);
drawarrow foobar.tex.e .. foobar.dvi.w;
label.top(btex\TeX etex,0.5[foobar.tex.e,foobar.dvi.w]);
%
% draw arrows to autodoc output files
%
boxdrawarrow(cweave,autodoc.tex,w);
boxdrawarrow(cweave,functions.adc,w);
boxdrawarrow(cweave,datatypes.adc,w);
drawarrow autodoc.tex.e .. autodoc.dvi.w;
label.top(btex\TeX etex,0.5[autodoc.tex.e,autodoc.dvi.w]);
boxdrawdblarrow(cweave,xidsidiid,c);
boxdrawarrow(cweave,idxscn,w);
%
% draw arrows to C files
%
boxdrawarrow(ctangle,makefile,w);
boxdrawarrow(ctangle,foo.c,w);
boxdrawarrow(ctangle,bar.c,w);
boxdrawarrow(ctangle,foo.shr,w);
boxdrawarrow(ctangle,bar.shr,w);
boxdrawarrow(ctangle,foobar.exp,w);
boxdrawarrow(ctangle,foo.exp,w);
boxdrawarrow(ctangle,bar.exp,w);
boxdrawdblarrow(ctangle,deprep,c);
%
% draw arrows from exp file to cweave
%
draw bar.shr.e {dir 0} .. bar.shr.e+(10,10) {dir 90} -- foo.shr.e+(10,10);
draw bar.exp.e {dir 0} .. bar.exp.e+(10,10) {dir 90};
draw foo.exp.e {dir 0} .. foo.exp.e+(10,10) {dir 90};
drawarrow foo.shr.e {dir 0} .. foo.shr.e+(10,10) {dir 90} -- foobar.exp.ne+(10,0) .. foobar.exp.ne+(0,10) {dir 180} -- foobar.exp.n+(-10,10) {dir 180} .. foobar.exp.nw+(0,10) .. cweave.c cutafter bpath.cweave;
draw foobar.exp.n {dir 90} .. foobar.exp.n+(-10,10) {dir 180};
%
% Legende
%
z1=(xpart foobar.prg.w,ypart ctangle.s)+(10,-40);
label.rt(btex$\dag\ldots\hbox{relative to \tt DEPDIR}$etex,z1);
label.rt(btex$\ddag\ldots\hbox{relative to \tt INCLUDE}$etex,z1-(0,13));
%
% Executable
%
y2=ypart 0.5[foobar.exp.n,makefile.s];
x2=xpart makefile.e+20;
exe.w=(xpart autodoc.dvi.w,y2);
drawboxed(exe);
linejoin:=mitered;
linecap:=butt;
drawarrow z2 .. exe.w-(10,0) withpen pencircle scaled 5 withcolor 0.8white;
linejoin:=rounded;
linecap:=rounded;
label.top(btex{\tt cc}etex,0.5[z2,exe.w-(10,0)]+(0,5));

endfig;

end
