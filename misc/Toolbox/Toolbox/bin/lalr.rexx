/* lalr start-script */

usebnf   = 0
bnffile  = "t:lalr.tmp"
bnfargs  = ""
lalrargs = ""
infile   = ""
status   = 0

PARSE ARG arguments

DO WHILE arguments ~= ""
  arg = SUBWORD(arguments,1,1)
  arguments = SUBWORD(arguments,2)
  SELECT
    WHEN arg = "-b" THEN usebnf = 1
    WHEN arg = "-c" THEN DO
      lalrargs = lalrargs || " " || arg
      bnfargs  = bnfargs || " " || arg
    END
    WHEN arg = "-l" THEN DO
      lalrargs = lalrargs || " " || arg
      bnfargs  = bnfargs || " " || arg
    END
    WHEN arg = "-m" THEN DO
      lalrargs = lalrargs || " " || arg
      bnfargs  = bnfargs || " " || arg
    END
    WHEN arg = "-NoAction" THEN bnfargs = bnfargs || " " || arg
    WHEN LEFT(arg,1) = "-" THEN lalrargs = lalrargs || " " || arg
    WHEN VERIFY(LEFT(arg,1),"0123456789") = 0 THEN lalrargs = lalrargs || " " || arg
    OTHERWISE infile = infile || " " || arg
  END
END
infile   = STRIP(infile)
lalrargs = STRIP(lalrargs)
bnfargs  = STRIP(bnfargs)

IF usebnf = 1 THEN DO
  SHELL COMMAND "toolbox:lib/lalr/bnf" ">" bnffile infile bnfargs
  SHELL COMMAND "toolbox:lib/lalr/lalr" bnffile lalrargs
END
ELSE DO
  SHELL COMMAND "toolbox:lib/lalr/lalr" infile lalrargs
END
SHELL COMMAND delete bnffile
EXIT status
