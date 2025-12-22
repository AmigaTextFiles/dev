" -------------------------------------------------------------
  TypeConverter extends PluggableAdaptor by adding custom 
  instance creation protocol based on the type of object that 
  its model, a ValueModel, will hold.  TypeConverters let
  updates propogate back up from the model (a ValueModel), 
  and override the automatic sending of updates to the 
  TypeConverter's dependents.

  Object Reference:
  A TypeConverter translates one type of object into another 
  type of object, such as a number into a string containing that 
  number.  It's used by the input field widget, so that the 
  string of characters that is entered by an application user 
  can be converted to a number, a symbol, a date, etc., 
  depending on the Type property that was selected for the input 
  field.  An application can, of course, create and use a 
  TypeConverter directly, to perform similar conversions. 
  The instance creation protocol contains several methods for 
  creating various types of converters.  All of the methods 
  will accept a value model as the given value for conversion -- 
  some will accept values that are not enfolded in value models. 
  --------------------------------------------------------------
"

Class TypeConverter :PluggableAdaptor
[
   forBitSet: aValue bit: aBitNumber

     ^ (self on: aValue) forBit: aBitNumber
|
   onDateValue: aValue

     ^ (self on: aValue) dateToText
|
   onNumberValue: aValue

     ^ (self on: aValue) numberToText
|
   onNumberValue: aValue format: formatString

     ^ (self on: aValue) numberToTextFormattedBy: formatString
|
   onObjectValue: aValue

     ^ (self on: aValue) objectToText
|
   onStringOrSymbolValue: aValue

     ^ (self on: aValue) stringOrSymbolToText
|
   onStringValue: aValue

     ^ (self on: aValue) stringToText
|
   onSymbolValue: aValue

     ^ (self on: aValue) symbolToText
|
   onTimestampValue: aValue

     ^ (self on: aValue) timestampToText
|
   onTimeValue: aValue

     ^ (self on: aValue) timeToText
|
   dateToText ! amigatalk !

     amigatalk <- AmigaTalk new.
     
     self
     	getBlock: [:m |	(amigatalk date) printAsTime: m value policyNamed: #editing ]
        putBlock: [:m :v | (v isEmpty)
                      ifTrue: [m value: nil]
                     ifFalse: [m value: ((amigatalk date) readDateFrom: v readStream) ] ]
        updateBlock: [:m :a :p | ^ true ]
|
   forBit: aBitNumber ! mask !
     mask <- 2 raisedTo: aBitNumber - 1.
     
     self getBlock: [:m | (m value anyMask: mask)]
          putBlock: [:m :v | (v = true)
                             ifTrue: [m value: (m value maskSet: mask)]
                            ifFalse: [m value: (m value maskClear: mask)] ]
       updateBlock: [:m :a :p | true].
|
   numberOrNil ! amigatalk !
     " Initialize the receiver to perform the action
     * when assigned a value 
     "
     amigatalk <- AmigaTalk new.
     
     self getBlock: [:m | (amigatalk date) printAsNumber: m value]
       
          putBlock: [:m :v | (v readStream) skipSeparators.
                             (m value: ((v readStream) atEnd)
                            ifTrue: [nil]
                           ifFalse: [(amigatalk date) readNumberFrom: (v readStream) type: Number]) ]
       
       updateBlock: [:m :a :p | true]
|
   numberToText ! amigatalk !
     " Initialize the receiver to perform the action
     * when assigned a value 
     "
     amigatalk <- AmigaTalk new.
     
     self
          getBlock: [:m | (amigatalk date) printAsNumber: m value]
          putBlock: [:m :v |
                        (v readStream) skipSeparators.
			
                        (m value: ((v readStream) atEnd)
                                    ifTrue: [ 0 ]
                                   ifFalse: [(amigatalk date) readNumberFrom: (v readStream) type: Number])]

       updateBlock: [:m :a :p | ^ true ]
|
   numberToTextFormattedBy: formatString
     " Initialize the receiver to perform the action
     * when assigned a value 
     "
     self
          getBlock: [:m | (m value) == nil
                            ifTrue: [String new]
                           ifFalse: [PrintConverter print: (m value) formattedBy: formatString]]
          
          putBlock: [:m :v | (v isEmpty)
                       ifTrue: [m value: 0]
                      ifFalse: [m value: (v asNumberFromFormatString: formatString)]]
		
       updateBlock: [:m :a :p | ^ true ]
|
   objectToText
     " Initialize the receiver to perform the action
     * when assigned a value 
     "
     self
          getBlock: [:m | ((m value) == nil)
                            ifTrue: [String new]
                           ifFalse: [(m value) printString] ]
                        
          putBlock: [:m :v | (v isEmpty)
                       ifTrue: [m value: nil]
                      ifFalse: [m value: (Object readFrom: v readStream)]]
		
       updateBlock: [:m :a :p | true]
|
   simpleLiteralToText
     " Initialize the receiver to perform the action
     * when assigned a value 
     "
     self
          getBlock: [:m | (m value) == nil
                            ifTrue: [String new]
                           ifFalse: [(m value) storeString]]

          putBlock: [:m :v | (v isEmpty)
                               ifTrue: [m value: nil]
                              ifFalse: [m value: (self convertToLiteral: v asString)]]
		
       updateBlock: [:m :a :p | true]
|
   stringOrSymbolToText
     " Initialize the receiver to perform the action
     * when assigned a value 
     "
     self
          getBlock: [:m | (m value) == nil
                        ifTrue: [String new]

                       ifFalse: [(m value) isSymbol
                                    ifTrue: ['#', (m value) asString]
                                   ifFalse: [(m value) ] ] ]

          putBlock: [:m :v | m value: ((v size > 0)
                          ifTrue: [v first == $#
                             ifTrue: [(self stripTrailingSeparators: (v copyFrom: 2 to: v size)) asSymbol]
                            ifFalse: [v string]]

                         ifFalse: [String new]) ]

       updateBlock: [:m :a :p | true]
|
   stringToNumber ! amigatalk !
     " Initialize the receiver to perform the action
     * when assigned a value 
     "
     amigatalk <- AmigaTalk new.
     
     self
          getBlock: [:m | (m value) == nil
                           ifTrue: [0]
                          ifFalse: [((m value) readStream) skipSeparators.
                                    ((m value) readStream) atEnd
                                     ifTrue: [0]
                                    ifFalse: [(amigatalk date) readNumberFrom: ((m value) readStream) type: Number]]]
		
          putBlock: [:m :v | m value: ((amigatalk date) printAsNumber: v)]
       updateBlock: [:m :a :p | ^ true ]
|
   stringToText
     " Initialize the receiver to perform the action
     * when assigned a value 
     "
     self
          getBlock: [:m | (m value) == nil
                          ifTrue: [String new]
                         ifFalse: [(m value) ] ]
		
          putBlock: [:m :v | m value: v string]

       updateBlock: [:m :a :p | ^ true ]
|
   symbolToText
     " Initialize the receiver to perform the action
     * when assigned a value 
     "
     self
          getBlock: [:m | (m value) == nil
                            ifTrue: [String new]
                           ifFalse: ['#' , (m value) ] ]

          putBlock: [:m :v | | t |
                      (v size > 0)
                        ifTrue: [v first == $#
                                  ifTrue: [t <- v copyFrom: 2 to: v size]
                                 ifFalse: [t <- v]]
                       ifFalse: [t <- String new].

                      (t isEmpty)
                        ifTrue: [m value: nil]
                       ifFalse: [m value: (self stripTrailingSeparators: t) asSymbol]]
		
       updateBlock: [:m :a :p | ^ true ]
|
   timestampToText
     " Initialize the receiver to perform the action
     * when assigned a value 
     "
     self
          getBlock: [:m | Locale current printAsTime: m value policyNamed: #editing]
       
          putBlock: [:m :v | (v isEmpty)
                               ifTrue: [m value: nil]
                              ifFalse: [m value: (Locale current readTimestampFrom: v readStream)]]
       
       updateBlock: [:m :a :p | true]
|
   timeToText
     " Initialize the receiver to perform the action
     * when assigned a value 
     "
     self
          getBlock: [:m | Locale current printAsTime: m value policyNamed: #editing]
       
          putBlock: [:m :v | (v isEmpty)
                               ifTrue: [m value: nil]
                              ifFalse: [m value: (Locale current readTimeFrom: v readStream)]]
       
       updateBlock: [:m :a :p | true]
|
   subject

     ^ model
|
   value: newValue
     " Set the currently stored value.  Allow the update to propogate back
     * up from the model.
     "

     self setValue: newValue
|
   aspectToText
     " Initialize the receiver to perform the action
     * when assigned a value 
     "
     self
          getBlock: [:m | (m value) == nil
                            ifTrue: [String new]
                           ifFalse: [((m value) detect: [:c | c isSeparator] ifNone: []) notNil
                                       ifTrue: ['#', (m value)]
                                      ifFalse: [(m value) printString ] ] ]
          
          putBlock: [:m :v | | t | (v size > 0)
                       ifTrue: [v first == $#
                                  ifTrue: [t <- v copyFrom: 2 to: v size]
                                 ifFalse: [t <- v] ]
                      ifFalse: [t <- String new].
                      
                      (t isEmpty)
                        ifTrue: [m value: nil]
                       ifFalse: [m value: (self stripTrailingSeparators: t) asSymbol]]

       updateBlock: [:m :a :p | ^ true ]
|
   convertToLiteral: aString ! array s indx obj !

     array <- Scanner new scanTokens: aString.
     
     array size = 0 ifTrue: [^nil].
     
     obj   <- array first.
     
     (array size = 1)
       ifTrue: [(obj == #true) 
                 ifTrue: [ ^ true].
                
                (obj == #false)
                 ifTrue: [ ^ false ].

                (obj == #'nil')
                 ifTrue: [ ^ nil ].
                
                ^ obj ].

     (obj == #'#')
         ifTrue: [indx <- 2]
        ifFalse: [indx <- 1].
	
     s <- String new writeStream.

     indx to: array size do: [:i | | e | e <- array at: i.
                               s nextPutAll: (e isCharacters
                                     ifTrue: [e]
                                    ifFalse: [e printString]);
                               space ].
     s skip: -1.
     
     ^ s contents asSymbol
|
   stripTrailingSeparators: aString ! size !

     (size <- aString size) to: 1 
                            by: -1 
                            do: [:index | (aString at: index) isSeparator
                                             ifTrue: [size <- size -1]
                                            ifFalse: [^aString copyFrom: 1 to: size] ].
     ^ aString
]
