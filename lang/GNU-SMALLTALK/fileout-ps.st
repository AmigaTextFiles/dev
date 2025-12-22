"======================================================================
|
|   File out method definitions as PostScript.
|
 ======================================================================"

"======================================================================
|
| Copyright (C) 1990, 1991, 1992 Free Software Foundation, Inc.
| Written by Steve Byrne.
|
| This file is part of GNU Smalltalk.
|
| GNU Smalltalk is free software; you can redistribute it and/or modify it
| under the terms of the GNU General Public License as published by the Free
| Software Foundation; either version 1, or (at your option) any later version.
| 
| GNU Smalltalk is distributed in the hope that it will be useful, but WITHOUT
| ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
| FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
| details.
| 
| You should have received a copy of the GNU General Public License along with
| GNU Smalltalk; see the file COPYING.  If not, write to the Free Software
| Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  
|
 ======================================================================"

"
|     Change Log
| ============================================================================
| Author       Date       Change 
| sbb	     16 Feb 92	  created Feb 92.
|
"

!String methodsFor: 'useful functionality'!

linesDo: aBlock
    "Send 'aBlock' a substring of the receiver for each newline delimited
     line in the receiver"
    | start substr |
    start _ 1.
    1 to: self size do:
	[ :i | (self at: i) == Character nl
		   ifTrue: [ substr _ self copyFrom: start to: i - 1.
			     aBlock value: substr.
			     start _ i + 1. ]
	      ].
    "start - 1 <= self size   this includes the blank line at the end"
    start <= self size
	ifTrue: [ aBlock value: (self copyFrom: start to: self size) ]
!

tabExpand
    "Replace tabs in self with appropriate number of spaces"
    | hpos dest |
    hpos _ 1.
    dest _ String new: (self size * 8).
    self do:
	[ :ch | ch == Character tab
		    ifTrue: [ [ dest at: hpos put: Character space.
				hpos _ hpos + 1.
				(hpos \\ 8) ~= 1 ] whileTrue.
			      ]
		    ifFalse: [ (ch == $( ) | (ch == $) )
				   ifTrue: [ dest at: hpos put: $\.
					     hpos _ hpos + 1 ].
			       dest at: hpos put: ch.
			       hpos _ hpos + 1 ]
		    ].
    ^dest copyFrom: 1 to: hpos - 1
! !

"Execute to test:
----------------------------------------------------------------------
'foo
bar
baz
' linesDo: [ :aLine | aLine printNl ]!
----------------------------------------------------------------------
"



!ClassDescription methodsFor: 'filing'!

filePostscriptOutOn: aFileStream
    | categories now |
    categories _ Set new.
    methodDictionary isNil ifTrue: [ ^self ].
    methodDictionary do:
	[ :method | categories add: (method methodCategory) ].

    self emitPostscriptHeader: aFileStream.

    aFileStream nextPutAll: 'normal'; nl;
	nextPutAll: '(''Filed out from ';
	nextPutAll: Version;
	nextPutAll: ' on '.
    now _ Date dateAndTimeNow.
    aFileStream print: (now at: 1);
	nextPutAll:  '  ';
	print: (now at: 2);
	nextPutAll: ' GMT''!)'; 
	nextPutAll: ' show newline newline'; nl; nl.

    categories asSortedCollection do:
        [ :category | self emitPostscriptCategory: category toStream: aFileStream ].

    aFileStream nextPutAll: 'finish'; nl.
! !


!ClassDescription methodsFor: 'private'!

emitPostscriptCategory: category toStream: aFileStream
    "I write Postscript for legal Smalltalk load syntax definitions of all of my methods
     are in the 'category' category to the aFileStream"

    aFileStream nextPutAll: 'italic'; nl;
	nextPutAll: '(!';
	print: self;
	nextPutAll: ' methodsFor: ''';
	nextPutAll: category;
	nextPutAll: '''!)';
	nextPutAll: ' show '; nl.
    methodDictionary notNil
  	ifTrue: [ methodDictionary do:
		      [ :method | (method methodCategory) = category
			          ifTrue: [ self emitPostscriptMethod: method
						 toStream: aFileStream ]
				      ] ].
    aFileStream nextPutAll: '(!) show newline
newline newline
'
!

emitPostscriptMethod: method toStream: aFileStream
    self splitOffSelector: method methodSourceString
	 to: [ :sel :body | aFileStream nextPutAll: 'newline newline'; nl;
				nextPutAll: 'bold'; nl.
			    self emitLines: sel toStream: aFileStream.
			    aFileStream nextPutAll: 'normal'; nl.
			    self emitLines: body toStream: aFileStream.
			    aFileStream nextPutAll: '(! ) show '; nl.
			    ] 
!


splitOffSelector: methodString to: aBlock
    | sel body ch split pos |
    ch _ methodString at: 1.	"could skip whitespace"
    ch isAlphaNumeric
	ifTrue: [ split _ self parseUnaryOrKeyword: methodString ]
	ifFalse: [ pos _ self skipToWhite: 1 on: methodString.
		   pos _ self skipWhite: pos on: methodString.
		   pos _ self skipIdentifier: pos on: methodString.
		   split _ self skipPastNewline: pos on: methodString ].
    sel _ methodString copyFrom: 1 to: split - 1.
    body _ methodString copyFrom: split to: methodString size.
    aBlock value: sel value: body
!

skipToWhite: start on: string
    | pos |
    pos _ start.
    [ (string at: pos) isSeparator ]
	whileFalse: [ pos _ pos + 1].
    ^pos
!

skipWhite: start on: string
    | pos |
    pos _ start.
    [ (string at: pos) isSeparator ]
	whileTrue: [ pos _ pos + 1].
    ^pos
!

skipIdentifier: start on: string
    | pos |
    pos _ start.
    [ (string at: pos) isAlphaNumeric ]
	whileTrue: [ pos _ pos + 1].
    ^pos
!    

skipPastNewline: start on: string
    | pos ch |
    pos _ start.
    [ ch _ string at: pos.
      (ch isSeparator) and: [ ch ~~ Character nl] ]
	whileTrue: [ pos _ pos + 1].
    ch == Character nl
	ifTrue: [ pos _ pos + 1 ].
    ^pos
!    

parseUnaryOrKeyword: string
    | pos ch tempPos |
    pos _ self skipIdentifier: 1 on: string.
    ch _ string at: pos.
    ch ~~ $:
	ifTrue: [ "Got a unary selector"
		  pos _ self skipPastNewline: pos on: string.
		  ^pos ].
    pos _ 1.
    [ tempPos _ self skipWhite: pos on: string.
      ch _ string at: tempPos.
     "make sure we have a valid keyword identifier to start"
      ch isLetter 
	  ifFalse: [ ^self skipPastNewline: pos on: string ].
      tempPos _ self skipIdentifier: tempPos on: string.
      ch _ string at: tempPos.
      ch ~~ $:
	  ifTrue: [ ^self skipPastNewline: pos on: string ].
     "parsed a keyword, expect an identifier next"
      tempPos _ self skipWhite: tempPos + 1 on: string.
      ch _ string at: tempPos.
      ch isLetter 
	  ifFalse: [ ^self skipPastNewline: pos on: string ].
      pos _ self skipIdentifier: tempPos on: string.
      true ] whileTrue
!

emitLines: string toStream: aStream
    string linesDo: [ :line | aStream nextPut: $(;
				  nextPutAll: line tabExpand;
				  nextPutAll: ') show newline'; nl ]
!


emitPostscriptHeader: aFileStream
    aFileStream nextPutAll: 
'%!

%%%
%%% User settable parameters
%%%

/fontSize 10 def
/leading 2 def
/indent 0 def


%%% 
%%% End of user settable parameters
%%%

clippath pathbbox 
  /uy exch def
  /ux exch def
  /ly exch def
  /lx exch def


/lineHeight fontSize leading add def

/ystart uy lineHeight sub def
/ypos ystart def

/linecounter 0 def
/maxline
    uy ly sub	    	    % height
    lineHeight              % line_height height
    div floor		    % max_whole_lines_per_page
def

/Helvetica findfont fontSize scalefont /hel exch def
/Helvetica-Bold findfont fontSize scalefont /helb exch def
/Helvetica-Oblique findfont fontSize scalefont /heli exch def

/normal {
    hel setfont
} def

/bold {
    helb setfont
} def

/italic {
    heli setfont
} def

/newline { % - => -
    /ypos ypos lineHeight sub def
    /linecounter linecounter 1 add def
    linecounter maxline 1 sub ge
    {
	showpage
        /ypos ystart def
	/linecounter 0 def
    } if
    indent ypos moveto
} def

/finish { % - => -
    linecounter 0 gt
    { showpage }
    if
} def 

indent ypos moveto



'

! !

"Some test code.  Eval the region in comments after you've filed it in."

"SymLink filePostscriptOutOn: stdout!"

"
| pipe |
    pipe _ FileStream popen: 'lpr' dir: 'w'.
    Association filePostscriptOutOn: pipe.
    pipe close
!
"

"
Object filePostscriptOutOn: stdout!
"
