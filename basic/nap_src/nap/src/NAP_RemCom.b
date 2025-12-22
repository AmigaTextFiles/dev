{
   NAP 2.03, a preprocessor for ACE
   Copyright (C) 1997/98 by Daniel Seifert 

		contact me at:  dseifert@berlin.sireco.net

				Daniel Seifert
				Elsenborner Weg 25
				12621 Berlin
				GERMANY

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or   
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software 
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

  {*
  ** This routine tries to remove comments.
  ** As of now, block comments and ' comments
  ** are valid.
  ** Earlier versions did also remove REMs,
  ** but as REM is a BASIC specific command,
  ** it isn't removed anymore.
  *}
  FoundSth = 0
  REPEAT

   {*
   ** Look for the next block comment.
   *}
   FoundSth=Search2(FoundSth+1,@text,"{")
   {*
   ** Is there one? And if, is this comment really a comment?
   *}
   IF (FoundSth>0) AND (Legal(@text,FoundSth) > 0) THEN

    {*
    ** Yeah, it is ;) So let's take the rest of the line as
    ** comment and preserve the first part.
    *}
    comment = MID$(text,FoundSth + 1)
    IF FoundSth > 1 THEN BigText = LEFT$(text,FoundSth-1) ELSE BigText = ""

    {*
    ** Might it happen by accident, that the comment ends at
    ** the same line?
    *}
    FoundEnd=search2(1,@comment,"}")
    IF FoundEnd>0 THEN
     IF Options->Remove_Comments = 0 THEN CALL schreibe ("{"+LEFT$(comment,FoundEnd))
     text=MID$(comment,FoundEnd+1)
    ELSE
     IF Options -> Remove_Comments = 0 THEN CALL schreibe ("{"+comment)
     REPEAT
      comment = Convert(lese(filenumber,bufferptrbase))
      ++ActLine
      FoundEnd=search2(1,@comment,"}")
      IF FoundEnd=0 THEN
       IF Options->Remove_Comments=0 THEN
        schreibe(comment)
       ELSE
        IF Options->Remove_Lines=0 THEN CALL schreibe("")
       END IF
      END IF
     UNTIL FoundEnd OR PEEK(FileReady) = 1
     IF FoundEnd = 0 THEN FoundSth = 0
     IF Options->Remove_Comments = 0 THEN call schreibe(left$(comment,FoundEnd))
     text = MID$(comment,FoundEnd+1)
    END IF
    text = BigText + text
   ' IF FoundSth > 1 THEN --FoundSth
   END IF
  UNTIL foundSth = 0

  IF Options->Remove_Comments THEN
   REPEAT
    FoundSth=search2(FoundSth+1,@text,"'")
    IF FoundSth THEN
     IF Legal(@text,FoundSth) THEN text=LEFT$(text,FoundSth-1) : FoundSth = 0
    END IF
   UNTIL FoundSth = 0
  END IF

