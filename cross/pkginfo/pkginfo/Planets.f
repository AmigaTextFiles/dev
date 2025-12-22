// Created by Dickens 1.0b7
// °° Note: This file may contain needed resources !! 
// Document
book := {
	version: 1,
	isbn: "0-9999-1111-0",
	title: "Die Planeten",
	shortTitle: "Planeten",
	copyright: "(c)1993 Zeus Publishing, Inc.",
	author: "Brad Zeus",
	publisher: "Zeus Publishing, Inc.",
	keywords: "Planets Mars Venus Jupiter Pluto Neptune Saturn Uranus Mercury Earth",
	publicationDate: 656593,
	data: {},   // Authorês own data
	contents: Array(12, NIL),
	styles: [], hints: Array(12, NIL),
	browsers: [], templates: [], rendering: []};
output.book := book;

// Hints
book.hints[1] := TRUE;
book.hints[2] := TRUE;
book.hints[3] := TRUE;
book.hints[5] := TRUE;
book.hints[8] := StuffHex("32000000233A3964001000404030002C2000000840002004582C004850201018005040341000090870AA706C002004006A3820780018A22C01800008610222142000000040A808004000010420000100300000004320600C2A041400201002200000000000000000000008004800000000000000000000000000000000080020",'data);
book.hints[10] := TRUE;
book.hints[11] := TRUE;

// Text Styles
s0 := {
	family: 'Geneva,
	face: 0,
	size: 9};
AddArraySlot(book.styles, s0);

s1 := {
	family: 'NewYork,
	face: 0,
	size: 12};
AddArraySlot(book.styles, s1);

s2 := {
	family: 'NewYork,
	face: 1,
	size: 12};
AddArraySlot(book.styles, s2);

s3 := {
	family: 'NewYork,
	face: 2,
	size: 12};
AddArraySlot(book.styles, s3);


// Contents
c1 := {
	data: "Die Planeten",
	viewFont: s2,
	layout: 16384
};
book.contents[0] := c1;

c2 := {
	data: "Erde",
	viewFont: s1,
	scripts: ['buttonClickScript, func ()
begin
	if (curRendering = 0) then :TurnToPage(destPage);
	else :TurnToPage(:FindPageByContent(kioskDest, 0, NIL))
end], 
	name: "Contents"
};
book.contents[1] := c2;

c3 := {
	data: "Mars",
	viewFont: s1,
	scripts: ['buttonClickScript, func ()
begin
	if (curRendering = 0) then :TurnToPage(destPage);
	else :TurnToPage(:FindPageByContent(kioskDest, 0, NIL))
end], 
	name: "Contents"
};
book.contents[2] := c3;

c4 := {
	data: "Jupiter",
	viewFont: s1,
	scripts: ['buttonClickScript, func ()
begin
	if (curRendering = 0) then :TurnToPage(destPage);
	else :TurnToPage(:FindPageByContent(kioskDest, 0, NIL))
end], 
	name: "Contents"
};
book.contents[3] := c4;

c5 := {
	data: GetNamedResource("PICT", "11191", 'picture),
	layout: 16384
};
book.contents[4] := c5;

c6 := {
	data: "Erde, der lebende Planet",
	viewFont: s1,
	layout: 32, 
	name: "earth"
};
book.contents[5] := c6;

c7 := {
	data: GetNamedResource("PICT", "9481", 'picture),
	layout: 4,
	scripts: ['buttonClickScript, func ()
begin
PlaySound(ROM_click);
:ShowStoryCard('card, "earth", {left: 60, top: 20, right: 160, bottom: 140});
end]
};
book.contents[6] := c7;

c8 := {
	data: "Introduction",
	layout: 2048
};
book.contents[7] := c8;

c9 := {
	data: "Am meisten wissen unsere Wissenschaftler ¸ber die Erde, denn hier kˆnnen sie ihre Annahmen am einfachsten ¸berpr¸den.
Sie nehmen an, daﬂ die Erde in ihrem Zentrum aus einem zweiteiligen Nickel-Eisen-Kern besteht. Er hat wiederum zwei Teile: Ein metallisches Innenkern mit 2500 Kilometern Durchmesser, umbgeben von einer 2200 Kilometer dicken Schicht, in der Nickel und Eisen fl¸ssig sind.",
	styles: [186, s1, 17, s3, 186, s1]
};
book.contents[8] := c9;

c10 := {
	data: "Durchmesser 12,756 km
Masse	1
Dichte	5.52
Tag 23h 56m",
	viewFont: s1,
	layout: 16384,
	scripts: ['buttonClickScript, func ()
begin

end],
	card: "earth" 
};
book.contents[9] := c10;

c11 := {
	data: "Mars, der rote Planet",
	viewFont: s1,
	layout: 32, 
	name: "mars"
};
book.contents[10] := c11;

c12 := {
	data: "Jupiter, der groﬂe Planet mit dem Ring",
	viewFont: s1,
	layout: 32, 
	name: "jupiter"
};
book.contents[11] := c12;


// Kiosk references
AddArraySlot(c2.scripts, 'kioskDest);
AddArraySlot(c2.scripts, c6);
AddArraySlot(c2.scripts, 'destPage);
AddArraySlot(c2.scripts, 2);

AddArraySlot(c3.scripts, 'kioskDest);
AddArraySlot(c3.scripts, c11);
AddArraySlot(c3.scripts, 'destPage);
AddArraySlot(c3.scripts, 3);

AddArraySlot(c4.scripts, 'kioskDest);
AddArraySlot(c4.scripts, c12);
AddArraySlot(c4.scripts, 'destPage);
AddArraySlot(c4.scripts, 4);


// Page Templates
Default := {
	nColumns: 1,
	column: [{
	width: 12,
	type: 0}]
};
AddArraySlot(book.templates, Default);
Menu := {
	nColumns: 1,
	column: [{
	width: 12,
	type: 0}],
	flags: 1,
	header: c1
};
AddArraySlot(book.templates, Menu);
PictFull := {
	nColumns: 1,
	column: [{
	width: 12,
	type: 0}],
	header: c5
};
AddArraySlot(book.templates, PictFull);

// Bounds List
bnd1 := [0,16,240,32];
bnd2 := [0,32,240,48];
bnd3 := [0,48,240,318];
bnd4 := [97,32,142,74];
bnd5 := [0,74,240,318];
bnd6 := [0,16,240,318];

// Pages
pageList := {pageSize: {left: 0, top: 0, right: 240, bottom: 336},
	contents: [], pages: []};

// Page 1
page := {template: Menu, blocks: []};
AddArraySlot(page.blocks,
	{bounds: bnd1,
	item: c2});
AddArraySlot(page.blocks,
	{bounds: bnd2,
	item: c3});
AddArraySlot(page.blocks,
	{bounds: bnd3,
	item: c4});
AddArraySlot(pageList.pages, page);

// Page 2
page := {template: PictFull, blocks: []};
AddArraySlot(page.blocks,
	{bounds: bnd1,
	item: c6});
AddArraySlot(page.blocks,
	{bounds: bnd4,
	item: c7});
AddArraySlot(page.blocks,
	{bounds: bnd5,
	item: c9});
AddArraySlot(pageList.pages, page);

// Page 3
page := {template: PictFull, blocks: []};
AddArraySlot(page.blocks,
	{bounds: bnd6,
	item: c11});
AddArraySlot(pageList.pages, page);

// Page 4
page := {template: PictFull, blocks: []};
AddArraySlot(page.blocks,
	{bounds: bnd1,
	item: c12});
AddArraySlot(pageList.pages, page);

AddArraySlot(book.rendering, pageList);

// Browsers & ñPage Hintsî
b1 := {
	name: "Contents",  list: []
};
bp1 := [];		// ñPage Hintsî for list browser

AddArraySlot(b1.list, {	// 0
	level: 2,
	item: c6
});
AddArraySlot(bp1, 2);
AddArraySlot(b1.list, {	// 1
	level: 2,
	item: c8
});
AddArraySlot(bp1, 2);
AddArraySlot(b1.list, {	// 2
	item: c11
});
AddArraySlot(bp1, 3);
AddArraySlot(b1.list, {	// 3
	item: c12
});
AddArraySlot(bp1, 4);
AddArraySlot(book.browsers, b1);
AddArraySlot(pageList.contents, bp1);

