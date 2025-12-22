REBOL []

list: charset "*#"
non-list: complement list
;empty: charset ""
;non-empty: complement empty
space: charset " ^(tab)"
;non-space: complement space
;non-chars: charset " ^(tab)^/"
;chars: complement non-chars
header1?:   ["111" some space copy text to newline (header text 1)]
header2?:   ["222" some space copy text to newline (header text 2)]
header3?:   ["333" some space copy text to newline (header text 3)]
header4?:   ["444" some space copy text to newline (header text 4)]
header5?:   ["555" some space copy text to newline (header text 5)]
header6?:   ["666" some space copy text to newline (header text 6)]
;bullet?:    ["*" some space copy text to "^/*" (bullet text 'begin)]
;bullet2?:   ["*" some space copy text to "^/^/" (bullet text 'end)]
enum?:      ["#" some space copy text to "^/#" (enum text 'begin)]
enum2?:     ["#" some space copy text to "^/^/" (enum text 'end)]
code?:      [space copy text to "^/^/" (code text)]
text?:      [copy text to newline (textline text)]
text2?:     [copy text to "^/^/" (textline2 text)]
image?:     ["%<" some space copy text to newline (image text 'left)]
image2?:    ["%|" some space copy text to newline (image text 'center)]
image3?:    ["%>" some space copy text to newline (image text 'right)]
title?:     ["%RAPIDOC%" some space copy text to newline  (title: text)]
title2?:    ["%RAPIDOC%" to newline]
pagebreak?: ["---" any space to newline (pagebreak)]
comment?:   ["!!!" any space copy text to newline (comment text)]
url?:       ["://" some space copy text to " " any space copy text2 to newline (url text text2)]

was_bullet: 0
was_enum: 0
rule: [some  [
                [newline newline mark: non-list :mark (if (was_bullet = 1) [output "</UL>^/" was_bullet: 0] if (was_enum = 1) [output "</OL>^/" was_enum: 0])]
              | [newline some newline mark: "*" (output "<UL>^/") :mark]
              | ["*" (was_bullet: 1) some space copy text to newline (output rejoin ["<LI>" text "</LI>^/"])]
              | [newline some newline mark: "#" (output "<OL>^/") :mark]
              | ["#" (was_enum: 1) some space copy text to newline (output rejoin ["<LI>" text "</LI>^/"])]
              | newline
              | title?
              | title2?
              | header1?
              | header2?
              | header3?
              | header4?
              | header5?
              | header6?
              | code?
              | image?
              | image2?
              | image3?
              | pagebreak?
              | comment?
              | url?
              | text2?
              | text?

             ]
      ]

header: func [text level]
[
 output rejoin ["<H" level ">" escape text "</H" level ">" newline]
]

x: 0
bullet: func [text type]
[
 if ((type = 'begin) and (x = 0)) [output rejoin ["" <UL> newline] x: 1]
 output rejoin ["" <LI> escape text </LI> newline]
 if (type = 'end) [output rejoin ["" </UL> newline] x: 0]
]

enum: func [text type]
[
 if (type = 'begin) [output rejoin ["" <OL> newline]]
 output rejoin ["" <LI> escape text </LI> newline]
 if (type = 'end) [output rejoin ["" </OL> newline]]
]

code: func [text]
[
 output rejoin ["" <BLOCKQUOTE> <PRE> newline " " text newline </PRE> </BLOCKQUOTE> <BR>  newline]
]

image: func [text type]
[
 output rejoin ["" "<P ALIGN=^"" to-string type "^">" newline "<IMG SRC=^"" text "^">" newline </P> newline <BR> newline]
]

output: func [text]
[
 append body text
]

textline: func [text]
[
 output rejoin [escape text newline]
]

textline2: func [text]
[
 output rejoin [escape text newline <BR> newline]
]

pagebreak: func []
[
 output rejoin ["" <!-- PAGE BREAK --> newline]
]

comment: func [text]
[
 output rejoin ["<!-- " text " -->" newline]
]

url: func [text text2]
[
 output rejoin ["<A HREF=^"" text "^">" escape text2 </A> newline <BR> newline]
]

escape: func [text]
[
 replace replace text "<" "&lt;" ">" "&gt;"
]

title: none
body: ""
doc: rejoin
     [
      ""
      <HTML>
      newline
      <HEAD>
      newline
     ]

infile: to-rebol-file first system/options/args
outfile: to-rebol-file rejoin [first system/options/args ".htm"]
print infile
print outfile
parse/all source: read infile rule

if not none? title
[
 append doc rejoin
            [
             ""
             <TITLE>
             newline
             escape title
             newline
             </TITLE>
             newline
            ]
]

append doc rejoin
           [
            ""
            </HEAD>
            newline
            <BODY>
            newline
            body
            newline
            </BODY>
            newline
            </HTML>
            newline
           ]

write outfile doc

