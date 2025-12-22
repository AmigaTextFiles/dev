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
| sbb	     16 Feb 92	  created a while ago
|
"

Object subclass: #Browser
       instanceVariableNames: ''
       classVariableNames: ''
       poolDictionaries: ''
       category: 'Class browser'
!

!Browser class methodsFor: 'browsing'!

startEmacsMessage
    stdout nextPut: (Character value: 2)
!

finishEmacsMessage
    nil				"does nothing for now"
!

withGcOff: aBlock
    | oldFlag |
    oldFlag _ Smalltalk gcMessage: false.
    aBlock value.
    Smalltalk gcMessage: oldFlag
!

emacsFunction: funcName on: aBlock
    self withGcOff:
	[ self startEmacsMessage.
	  stdout nextPut: $(;
	      nextPutAll: funcName; nl.
	  aBlock value.
	  stdout nextPut: $); nl.    
    	  self finishEmacsMessage ]
!

emacsListFunction: funcName on: aBlock
    self emacsFunction: funcName on:
	[ stdout nextPutAll: '''('; nl.
	  aBlock value.
	  stdout nextPut: $) ]
!

oldShowInstanceMethods: class
    | methods |
    methods _ self getMethods: class.
    self withGcOff:
	[ self startEmacsMessage.
	  stdout nextPutAll: '(smalltalk-browse "instance methods"'; nl;
	      nextPutAll: '''test-func'; nl;
	      nextPutAll: 't'; nl;
	      nextPutAll: '''('; nl.
	  class allSelectors do:
	      [ :sel | stdout nextPutAll: '("';
    	    	           print: sel;
    	    	           nextPutAll: '" . "';
		           print: sel;
		       	   nextPutAll: '")'; nl ].
    	  stdout nextPutAll: ')'; nl.    
    	  self finishEmacsMessage ]
!

showMethods: class for: methodType 
    | methods |
    "Experimental version"
    methods _ class newGetMethods.    
    self emacsFunction: 'smalltalk-browse' on: 
	[ stdout nextPut: $";
	      nextPutAll: methodType;
	      nextPutAll: ' methods"'; nl;
	      nextPutAll: '''test-func'; nl;
	      nextPutAll: 't'; nl;
	      nextPutAll: '''('; nl.
	  methods associationsDo:
	      [ :sel | sel value value methodSourceFile notNil 
			   ifTrue: 
			       [ stdout nextPutAll: '("'; 
				     print: sel key; tab; tab;
				     print: sel value key;
				     nextPutAll: '" . ("'; 
				     nextPutAll: sel value value methodSourceFile;
nextPutAll: '" . ';
				     nextPutAll: sel value value methodSourcePos printString;
				     nextPut: $).
				 stdout nextPut: $); nl ] 
			   ifFalse:
			       [ stdout nextPutAll: '("'; 
				     print: sel key; tab; tab;
				     print: sel value key;
				     nextPutAll: '" . ("'; 
				     nextPutAll: sel value value methodSourceString
				     nextPut: $).
				 stdout nextPut: $); nl ]
			   ].
    	  stdout nextPut: $) ]
!
    
showDirectMethods: class inBuffer: bufferName
    | methods |
    "Experimental version"
    methods _ class getDirectMethods.
    self browseMethods: methods forClass: class inBuffer: bufferName .
!

showAllMethods: class inBuffer: bufferName
    | methods |
    "Experimental version"
    methods _ class getAllMethods.
    self browseMethods: methods forClass: class inBuffer: bufferName .
!

showIndirectMethods: class inBuffer: bufferName
    | methods |
    "Experimental version"
    methods _ class getIndirectMethods.
    self browseMethods: methods forClass: class inBuffer: bufferName.
!

getAllSelectors: selector inBuffer: bufferName
    | methods |
    methods _ self getMethodsFor: selector.
    self browseMethods: methods forClass: Object inBuffer: bufferName.
!    

browseMethods: methods forClass: class inBuffer: bufferName
    self emacsFunction: 'smalltalk-method-browse' on:
	[ stdout nextPut: $";
	      nextPutAll: bufferName;
	      nextPutAll: '" ''('; nl.
	  methods associationsDo:
	      [ :sel | sel value value methodSourceFile notNil 
			   ifTrue:
			       [ stdout nextPutAll: '("'; 
				     print: sel key; 
				     nextPutAll: '" . ("'; 
				     nextPutAll: sel value value methodSourceFile;
				     nextPutAll: '" . ';
				     nextPutAll: sel value value methodSourcePos printString;
				     nextPutAll: '))'; nl ] 
			   ifFalse:
			       [ stdout nextPutAll: '("'; 
				     print: sel key; 
				     nextPutAll: '" . ("'; 
				     print: class;
				     nextPutAll: '" "';
				     nextPutAll: sel value value methodCategory;
				     nextPut: $"; nl;
				     nextPut: $";
				     nextPutAll: sel value value methodSourceString;
				     nextPutAll: '")'.
				 stdout nextPut: $); nl ]
			   ].
	  stdout nextPutAll: ')'; nl ]
!

oldShowMethods: class for: methodType
    | methods |
    methods _ class getMethods.    
    self withGcOff:
	[ self startEmacsMessage.
	  stdout nextPutAll: '(smalltalk-browse "';
	      nextPutAll: methodType;
	      nextPutAll: ' methods"'; nl;
	      nextPutAll: '''test-func'; nl;
	      nextPutAll: 't'; nl;
	      nextPutAll: '''('; nl.
	  methods associationsDo:
	      [ :sel | sel value methodSourceFile notNil ifTrue:
			   [ stdout nextPutAll: '("'; 
			         print: sel key;
    	    	    	    	 nextPutAll: '" . ("'; 
				 nextPutAll: sel value methodSourceFile;
				 nextPutAll: '" . ';
				 nextPutAll: sel value methodSourcePos printString;
				 nextPutAll: ')'.
			     stdout nextPutAll: ')'; nl ] ].
    	  stdout nextPutAll: '))'; nl.    
    	  self finishEmacsMessage ]
!

oldloadClassNames
    self withGcOff:
        [ self startEmacsMessage. 
    	  stdout nextPutAll: '(smalltalk-set-class-names ''('; nl. 
	  Object withAllSubclasses do: 
	      [ :class | class name == nil
			     ifFalse: [ stdout nextPutAll: class name; nl. ]
			     ].
	  stdout nextPutAll: '))'.
    	  self finishEmacsMessage ]
!

loadClassNames
    self emacsListFunction: 'smalltalk-set-class-names' on:
	[ Smalltalk associationsDo:
	      [ :assoc | (assoc value isKindOf: Behavior)
			     ifTrue: [ stdout nextPutAll: assoc key; nl ]
			     ] 
	      ]
!

selectors
    | md |
    self emacsListFunction: 'smalltalk-set-all-methods' on:
	[ Smalltalk associationsDo:
	      [ :assoc | (assoc value isKindOf: Behavior)
			     ifTrue: 
				 [ (md _ assoc value methodDictionary)
				       isNil ifFalse:
					   [ md keysDo:
						 " also spit out class methods"
						 [ :key | stdout nextPut: $";
							      print: key;
							      nextPut: $"; nl 
							      ]
						 ]
				       ]
			     ]
	      ]
!

browseHierarchy
    self emacsListFunction: 'smalltalk-hier-browser' on: 
	[ Object printHierarchy ]
!

testMethods: aClass for: methodType
    | classes methods md |
    classes _ (aClass allSuperclasses). 
    classes addFirst: aClass.
    self withGcOff:
	[ self startEmacsMessage.
	  stdout nextPutAll: '(smalltalk-fast-browse "';
	      nextPutAll: methodType;
	      nextPutAll: ' methods"'; nl;
	      nextPutAll: '''test-func'; nl;
	      nextPutAll: '''('; nl.
	  classes do:
	      [ :cl | md _ cl methodDictionary.
		      md notNil ifTrue:
			  [ md associationsDo: 
				[ :meth | stdout nextPutAll: '("';
					      nextPutAll: meth key;
					      nextPutAll: '" . ("'; 
					      nextPutAll: meth value methodSourceFile;
					      nextPutAll: '" . ';
					      nextPutAll: meth value methodSourcePos printString;
					      nextPutAll: '))';
					      nl ]
				]
			  ].
	  stdout nextPutAll: '))'.
	  self finishEmacsMessage ].
!!

!Behavior methodsFor: 'browsing'!

methodDictionary
    ^methodDictionary
!

getMethods
    | classes methods md |
    methods _ Dictionary new.
    self allSuperclasses reverseDo:
	[ :superclass | md _ superclass methodDictionary.
			md notNil ifTrue: 
			    [ md associationsDo:
				  [ :assoc | methods add: assoc ] ] ].
    methodDictionary notNil ifTrue: 
	[ methodDictionary associationsDo:
	      [ :assoc | methods add: assoc ] ].
    ^methods
!

newGetMethods
    | classes methods md b |
    methods _ Dictionary new.
    b _ [ :md :class | md associationsDo:
		  [ :assoc | methods 
				 add: (Association key: assoc key 
						   value: (Association 
							       key: class 
							       value: assoc value)) ] ].
    self allSuperclasses reverseDo:
	[ :superclass | md _ superclass methodDictionary.
			md notNil ifTrue: 
			    [ b value: md value: superclass ] ].
    methodDictionary notNil ifTrue: 
	[ b value: methodDictionary value: self ].
    ^methods
!

getIndirectMethods
    | classes methods md b |
    methods _ Dictionary new.
    b _ [ :md :class | md associationsDo:
		  [ :assoc | methods 
				 add: (assoc key ->
					   (class -> assoc value)) ] ].
    self allSuperclasses reverseDo:
	[ :superclass | md _ superclass methodDictionary.
			md notNil ifTrue: 
			    [ b value: md value: superclass ] ].
    ^methods
!

getAllMethods
    | classes methods md b |
    methods _ Dictionary new.
    b _ [ :md :class | md associationsDo:
		  [ :assoc | methods 
				 add: (assoc key ->
					    (class -> assoc value)) ] ].
    classes _ self allSuperclasses.
    classes addFirst: self.
    classes reverseDo:
	[ :superclass | md _ superclass methodDictionary.
			md notNil ifTrue: 
			    [ b value: md value: superclass ] ].
    ^methods
!

getDirectMethods
    | classes methods md b |
    methods _ Dictionary new.
    b _ [ :md :class | md associationsDo:
		  [ :assoc | methods 
				 add: (Association key: assoc key 
						   value: (Association 
							       key: class 
							       value: assoc value)) ] ].
    methodDictionary notNil ifTrue: 
	[ b value: methodDictionary value: self ].
    ^methods
!

getMethodsFor: aSelector
    | methods dict elt b |
    methods _ Dictionary new.
    b _ [ :subclass | dict _ subclass methodDictionary.
		      dict notNil ifTrue:
			  [ elt _ dict at: aSelector
				       ifAbsent: [ nil ].
			    elt notNil ifTrue:
				[ methods add: 
				      (subclass -> 
					   (subclass -> elt)) ]
				]
			  ].

    Object allSubclassesDo: b.
    b value: Object.
    ^methods
! !

!Behavior methodsFor: 'hierarchy browsing'!

printHierarchy
    "I my entire subclassclass hierarchy on the terminal."
    self printSubclasses: 0    
!!

!Behavior methodsFor: 'private'!

printSubclasses: level
    "I print my name, and then all my subclasses, each indented according
     to its position in the hierarchy."
    | mySubclasses |
    stdout nextPutAll: '("'.
    stdout print: self name;
	nextPutAll: '" . ';
	print: level;
	nextPutAll: ')'; nl.
    mySubclasses _ self subclasses asSortedCollection:
    	    	        [ :a :b | (a name isNil or: [ b name isNil ])
    	    	    	    	      ifTrue: [ true ]
		    	    	      ifFalse: [ a name <= b name ] ].
    mySubclasses do:
    	[ :subclass | subclass class ~~ Metaclass
	    	    	ifTrue: [ subclass printSubclasses: level + 1 ] ]
!

indentToLevel: level
    level timesRepeat:
    	[ stdout next: (self hierarchyIndent) put: Character space ]
!

hierarchyIndent
    ^4
!!
