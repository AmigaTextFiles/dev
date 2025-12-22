/* $VER: Emperor_CED.script 4.3  (16.6.2002)   */
/* written anno 2000-2002 by Matthias Gietzelt */
/* script to:                                  */
/* + open                                      */
/* + save                                      */
/* + edit                                      */
/* + navigate                                  */
/* + handle                                    */

PARSE ARG mode value

ADDRESS 'rexx_ced'

OPTIONS RESULTS

result = 0

/* defined procedures */
COMMAND_GETLINE               = 0
COMMAND_GETCOLUMN             = 1
COMMAND_GETPOSITION           = 2
COMMAND_CURSORUP              = 100
COMMAND_CURSORDOWN            = 101
COMMAND_TOFRONT               = 102
COMMAND_MATCHINGBRACKET       = 103
COMMAND_MARKON                = 104
COMMAND_MARKOFF               = 105
COMMAND_CUT                   = 106
COMMAND_COPY                  = 107
COMMAND_PASTE                 = 108
COMMAND_ERASE                 = 109
COMMAND_DELETEALL             = 110
COMMAND_UNDO                  = 111
COMMAND_REDO                  = 112
COMMAND_POS_SOW               = 113
COMMAND_POS_EOW               = 114
COMMAND_POS_SOL               = 115
COMMAND_POS_EOL               = 116
COMMAND_POS_SOF               = 117
COMMAND_POS_EOF               = 118
COMMAND_NEXT_WORD             = 119
COMMAND_NEXT_SENTENCE         = 120
COMMAND_NEXT_PARAGRAPH        = 121
COMMAND_NEXT_PAGE             = 122
COMMAND_PREV_WORD             = 123
COMMAND_PREV_SENTENCE         = 124
COMMAND_PREV_PARAGRAPH        = 125
COMMAND_PREV_PAGE             = 126
COMMAND_GOTOBOOKMARK1         = 127
COMMAND_GOTOBOOKMARK2         = 128
COMMAND_GOTOBOOKMARK3         = 129
COMMAND_GOTOBOOKMARK4         = 130
COMMAND_SETBOOKMARK1          = 131
COMMAND_SETBOOKMARK2          = 132
COMMAND_SETBOOKMARK3          = 133
COMMAND_SETBOOKMARK4          = 134
COMMAND_UPPERLOWERMARK        = 135
COMMAND_UPPERLOWERWORD        = 136
COMMAND_UPPERLOWERCHAR        = 137
COMMAND_LOWERMARK             = 138
COMMAND_LOWERWORD             = 139
COMMAND_LOWERCHAR             = 140
COMMAND_UPPERMARK             = 141
COMMAND_UPPERWORD             = 142
COMMAND_UPPERCHAR             = 143
COMMAND_LEAVE                 = 144
COMMAND_START                 = 145
COMMAND_JUMPTOLINE            = 200
COMMAND_JUMPTOCOLUMN          = 201
COMMAND_JUMPTOBYTE            = 202
COMMAND_INSERTTEXT            = 203
COMMAND_INSERTMODE            = 204
COMMAND_SAVE                  = 205
COMMAND_OPEN                  = 206
COMMAND_MACRO_MARKALL         = 300
COMMAND_MACRO_MARKTHISWORD    = 301
COMMAND_MACRO_MARKNEXTWORD    = 302
COMMAND_MACRO_MARKPREVWORD    = 303
COMMAND_MACRO_MARKLINE        = 304
COMMAND_MACRO_MARKLINEBEGIN   = 305
COMMAND_MACRO_MARKLINEEND     = 306
COMMAND_MACRO_MARKTOPTOCURSOR = 307
COMMAND_MACRO_MARKCURSORTOEND = 308

if mode = COMMAND_START then do
   if ~show('P', "rexx_ced") then address command value
   else OPEN NEW
end

if show('P', "rexx_ced") then do
   select
      when mode = COMMAND_GETLINE then STATUS CURSORLINE
      when mode = COMMAND_GETCOLUMN then STATUS CURSORCOLUMN
      when mode = COMMAND_GETPOSITION then do
         STATUS LINEBUFFEROFFSET
         buffer = result 
         STATUS CURSORCOLUMN
         result = buffer + result
         end
      when mode = COMMAND_CURSORUP then UP
      when mode = COMMAND_CURSORDOWN then DOWN
      when mode = COMMAND_TOFRONT then CEDTOFRONT
      when mode = COMMAND_MATCHINGBRACKET then FIND MATCHING BRACKET
      when mode = COMMAND_MARKON then do
         MARK
         if RESULT = 0 then MARK
         end
      when mode = COMMAND_MARKOFF then do
         MARK
         if RESULT = 1 then MARK
         end
      when mode = COMMAND_CUT then CUT
      when mode = COMMAND_COPY then COPY
      when mode = COMMAND_PASTE then PASTE
      when mode = COMMAND_ERASE then CUT
      when mode = COMMAND_DELETEALL then CLEAR 1
      when mode = COMMAND_UNDO then UNDO
      when mode = COMMAND_REDO then REDO
      when mode = COMMAND_POS_SOW then do
         PREV WORD
         NEXT WORD
         end
      when mode = COMMAND_POS_EOW then NEXT WORD
      when mode = COMMAND_POS_SOL then BEG OF LINE
      when mode = COMMAND_POS_EOL then call END OF LINE
      when mode = COMMAND_POS_SOF then BEG OF FILE
      when mode = COMMAND_POS_EOF then call END OF FILE
      when mode = COMMAND_NEXT_WORD then NEXT WORD
      when mode = COMMAND_NEXT_SENTENCE then NEXT SENTENCE
      when mode = COMMAND_NEXT_PARAGRAPH then NEXT PARAGRAPH
      when mode = COMMAND_NEXT_PAGE then NEXT PAGE
      when mode = COMMAND_PREV_WORD then PREV WORD
      when mode = COMMAND_PREV_SENTENCE then PREV SENTENCE
      when mode = COMMAND_PREV_PARAGRAPH then PREV PARAGRAPH
      when mode = COMMAND_PREV_PAGE then PREV PAGE
      when mode = COMMAND_GOTOBOOKMARK1 then JUMP MARK 1
      when mode = COMMAND_GOTOBOOKMARK2 then JUMP MARK 2
      when mode = COMMAND_GOTOBOOKMARK3 then JUMP MARK 3
      when mode = COMMAND_GOTOBOOKMARK4 then JUMP MARK 4
      when mode = COMMAND_SETBOOKMARK1 then do
         STATUS MARKX1
         STATUS MARKY1
         end
      when mode = COMMAND_SETBOOKMARK2 then do
         STATUS MARKX2
         STATUS MARKY2
         end
      when mode = COMMAND_SETBOOKMARK3 then do
         STATUS MARKX3
         STATUS MARKY3
         end
      when mode = COMMAND_SETBOOKMARK4 then do
         STATUS MARKX4
         STATUS MARKY4
         end
      when mode = COMMAND_UPPERLOWERMARKED then CHANGE CASE MARKED
      when mode = COMMAND_UPPERLOWERWORD then CHANGE CASE WORD
      when mode = COMMAND_UPPERLOWERCHAR then CHANGE CASE LETTER
      when mode = COMMAND_LOWERMARKED then LOWER CASE MARKED
      when mode = COMMAND_LOWERWORD then LOWER CASE WORD
      when mode = COMMAND_LOWERCHAR then LOWER CASE LETTER
      when mode = COMMAND_UPPERMARKED then UPPER CASE MARKED
      when mode = COMMAND_UPPERWORD then UPPER CASE WORD
      when mode = COMMAND_UPPERCHAR then UPPER CASE LETTER
      when mode = COMMAND_START then PASTE
      when mode = COMMAND_JUMPTOLINE then JUMP TO LINE value
      when mode = COMMAND_JUMPTOCOLUMN then do
         STATUS CURSORLINE
         JUMPTO result+1 value
         end
      when mode = COMMAND_JUMPTOBYTE then JUMP TO BYTE value
      when mode = COMMAND_INSERTTEXT then TEXT value
      when mode = COMMAND_INSERTMODE then INSERT MODE
      when mode = COMMAND_OPEN then OPEN 1 value
      when mode = COMMAND_SAVE then SAVE value
      when mode = COMMAND_COMMAND_MACRO_MARKALL then do
         MARK
         if RESULT = 1 then MARK
         BEG OF FILE
         MARK
         if RESULT = 0 then MARK
         call END OF FILE
         end
      when mode = COMMAND_COMMAND_MACRO_MARKTHISWORD then do
         MARK
         if RESULT = 1 then MARK
         PREV WORD
         NEXT WORD
         MARK
         if RESULT = 0 then MARK
         NEXT WORD
         end
      when mode = COMMAND_COMMAND_MACRO_MARKNEXTWORD then do
         MARK
         if RESULT = 1 then MARK
         NEXT WORD
         MARK
         if RESULT = 0 then MARK
         NEXT WORD
         end
      when mode = COMMAND_COMMAND_MACRO_MARKPREVWORD then do
         MARK
         if RESULT = 1 then MARK
         PREV WORD
         MARK
         if RESULT = 0 then MARK
         PREV WORD
         NEXT WORD
         end
      when mode = COMMAND_COMMAND_MACRO_MARKLINE then do
         MARK
         if RESULT = 1 then MARK
         BEG OF LINE
         MARK
         if RESULT = 0 then MARK
         DOWN
         end
      when mode = COMMAND_COMMAND_MACRO_MARKLINEBEGIN then do
         MARK
         if RESULT = 0 then MARK
         BEG OF LINE
         end
      when mode = COMMAND_COMMAND_MACRO_MARKLINEEND then do
         MARK
         if RESULT = 0 then MARK
         call END OF LINE
         end
      when mode = COMMAND_COMMAND_MACRO_MARKTOPTOCURSOR then do
         MARK
         if RESULT = 0 then MARK
         BEG OF FILE
         end
      when mode = COMMAND_COMMAND_MACRO_MARKCURSORTOEND then do
         MARK
         if RESULT = 0 then MARK
         call END OF FILE
         end
      otherwise nop
   end
end

if mode < 100 then do
   outvalue = result
   Open(output, "RAM:T/Emperor_RexxOutput.tmp", Write)
   Writeln(output, outvalue)
   Close(output)
end

exit
