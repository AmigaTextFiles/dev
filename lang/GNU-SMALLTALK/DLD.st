"======================================================================
|
|   GNU Dynamic Loader Method Definitions
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
| sbb	     19 Jul 91	  Created.
|
"

Object subclass: #DLD
       instanceVariableNames: ''
       classVariableNames: ''
       poolDictionaries: ''
       category: 'Cool hacks'
!

DLD comment: '###NO COMMENT YET###'!

"
     int dld_link (char *FILENAME)
"

Behavior defineCFunc: 'dldLink'
	 withSelectorArgs: 'linkFile: aFileName'
	 forClass: DLD class
	 returning: #int
	 args: #(string)
!

"
     int dld_unlink_by_file (char *PATH, int HARD)

     int dld_unlink_by_symbol (char *ID, int HARD)
"

Behavior defineCFunc: 'dldUnlinkByFile'
	 withSelectorArgs: 'unlinkFile: aFileName force: aBool'
	 forClass: DLD class
	 returning: #int
	 args: #(string int)
!

Behavior defineCFunc: 'dldUnlinkBySymbol'
	 withSelectorArgs: 'unlinkModuleContaining: aStringName force: aBool'
	 forClass: DLD class
	 returning: #int
	 args: #(string int)
!

"
     unsigned long dld_get_symbol (char *ID)

     unsigned long dld_get_func (char *FUNC)
"

Behavior defineCFunc: 'dldGetSymbol'
	 withSelectorArgs: 'getSymbol: aStringName'
	 forClass: DLD class
	 returning: #cObject
	 args: #(string)
!

Behavior defineCFunc: 'dldGetFunc'
	 withSelectorArgs: 'getFunc: aFuncString'
	 forClass: DLD class
	 returning: #cObject
	 args: #(string)
!


"
     int dld_function_executable_p (char *FUNC)
"

Behavior defineCFunc: 'dldFunctionExecutableP'
	 withSelectorArgs: 'isExecutable: aFuncString'
	 forClass: DLD class
	 returning: #int	"bool"
	 args: #(string)
!

"
     char **dld_list_undefined_sym ()
"

CStruct newStruct: #StringArray
	declaration: #((val (ptr string)))
!


Behavior defineCFunc: 'dldListUndefinedSym'
	 withSelectorArgs: 'undefinedSymbols'
	 forClass: DLD class
	 returning: "CStringType ""(CType baseType: StringArray)"
	      "(CType baseType: CPtr subType: CStringType)"
	      (CType baseType: CArray subType: CStringType)
	 args: #()
!

"
     int dld_create_reference (char *NAME)
"

Behavior defineCFunc: 'dldCreateReference'
	 withSelectorArgs: 'createReference: aString'
	 forClass: DLD class
	 returning: #int
	 args: #(string)
!

"
     int dld_define_sym (char *NAME, unsigned int SIZE)
     void dld_remove_defined_symbol (char *NAME)
"

Behavior defineCFunc: 'dldDefineSym'
	 withSelectorArgs: 'defineSym: symbolName size: anInteger'
	 forClass: DLD class
	 returning: #int
	 args: #(string int)
!

Behavior defineCFunc: 'dldRemoveDefinedSymbol'
	 withSelectorArgs: 'removeDefinedSymbol: aString'
	 forClass: DLD class
	 returning: #void
	 args: #(string)
!

Behavior defineCFunc: 'getUndefinedSymCount'
	 withSelectorArgs: 'numUndefinedSymbols'
	 forClass: DLD class
	 returning: #int
	 args: #()
!


"Generally useful in the presence of dynamic linking"

Behavior defineCFunc: 'defineCFunc'
	 withSelectorArgs: 'defineCFunc: aName as: aFuncAddr'
	 forClass: Behavior class
	 returning: #void
	 args: #(string cObject)
!


!DLD class methodsFor: 'Dynamic Linking'!

defineExternFunc: aFuncName
    withSelectorArgs: selector
    forClass: aClass
    returning: aReturnType
    args: argsArray
    | funcAddr |
    
    funcAddr _ self getFunc: aFuncName.
    funcAddr isNil
	ifTrue: [ ^self error: 'Function ', aFuncName, ' not found' ].
    Behavior defineCFunc: aFuncName as: funcAddr.
    Behavior defineCFunc: aFuncName
	     withSelectorArgs: selector
	     forClass: aClass
	     returning: aReturnType
	     args: argsArray
! !


"
| syms |
    DLD createReference: 'printf'.
    DLD createReference: 'open'.
    syms _ DLD undefinedSymbols.
    0 to: DLD numUndefinedSymbols - 1
      do: [ :i | (syms at: i) value printNl ]
!
"
