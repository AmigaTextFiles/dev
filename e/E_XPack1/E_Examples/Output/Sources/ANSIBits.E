/* ANSIBits.E Displays Some Neat Little ANSI Codes In CLI Via Amiga E.
   This Can Be Useful For All Sorts Of Things! Written By Edward Farrow.  */

PROC main()

   WriteF('\e[0mPlain Text\n')
   WriteF('\e[1mBold Text\e[0m\n')
   WriteF('\e[2mWhite Text\e[0m\n')
   WriteF('\e[3mItalic Text\e[0m\n')
   WriteF('\e[4mUnderlined Text\e[0m\n\n')
   WriteF('\e[7mReversed Text\e[0m\n\n')

   WriteF('\e[1;4mCombined Underlined And Bold!\e[0m\n')
   WriteF('\e[2;4mCombined Underlined And White!\e[0m\n')

ENDPROC

