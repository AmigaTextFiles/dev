
NB. 'Eliza the analyst.'
NB. 'A simplified Eliza program similar to the one in the'
NB. 'ABC PROGRAMMERS  GUIDE by Guerts, Meertens, and Pemberton.'
NB. 'Written in J by R.L.W. Brown. RLWBROWN at YORKVM1 (bitnet)'
NB. '	<RLWBROWN@VM1.YorkU.CA> '

NB. 'CONSTANTS AND UTILITY FUNCTIONS'
end=.0$0
ALPH=. 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ?,!;.''"()/'
LOWER=.'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz?          '
lowercase=.'(ALPH i. y.){LOWER' : ''
say=.'y.(1!:2) 2' : ''
listen=.';:lowercase(1!:1)1' : ''
choose=.'say>(?$,y.){,y.' : ''
has=.'' : '($y.)>k=:<./y.i.x.'
from=.'>k{y.' : ''
if=.".>
then=.{.<

NB. 'ELIZA DIALOG FUNCTION'
c=.0 1$''
c=.c,'say''Hello, I am Eliza.  Tell me about yourself.'''
c=.c,'say''"Bye" to finish.'''
c=.c,'s=.listen '''''
c=.c,'if ((;:''bye'') e. s) then ''''''Bye, bye!''''[$.=.end'''
c=.c,'reply s[$.=.2 3 4'
eliza=.c  : ''

NB. 'ELIZA REPLY FUNCTION'
c=.0 1$' '
c=.c,'if ((<y.) has Simple) then ''choose from SimpleAns[$.=.end'''
c=.c,'if (y. has Keyword) then ''choose from KeywordAns[$.=.end'''
c=.c,'if ((;:''?'') e. y.) then ''choose Answer[$.=.end'''
c=.c,'if (y. has Otherword) then ''choose from OtherwordAns[$.=.end'''
c=.c,'choose Starter'
reply=.c  : ''

NB. 'ELIZA DATA'
c=.,<'yes'
c=.c;<,<'no'
Simple=.c

c=.(<'Are you sure?'),(<'You seem positive.')
c=.<c,(<'Can you be more specific?'),(<'Really?')
c=.c,<(<'Don''t be negative!'),(<'Why not?'),(<'You seem definite!')
SimpleAns=.c

c=.(<'mother')
c=.c,(<'father')
c=.c,(<'brother')
c=.c,(<'sister')
c=.c,(<'girlfriend')
c=.c,(<'boyfriend')
c=.c,(<'love')
c=.c,(<'hate')
c=.c,(<'family')
Keyword=.c

c=.<(<'And your father?'),(<'Tell me more about your family.')
c=.c,<(<'And your mother?'),(<'Tell me about your father.')
c=.c,<(<'You have one brother?'),(<'Tell me more about your brother.')
c=.c,<(<'You have one sister?'),(<'Tell me more about your sister.')
c=.c,<(<'Why bring your girlfriend in?'),(<'Tell me about your girlfriend.')
c=.c,<(<'Why bring your boyfriend in?'),(<'Tell me about your boyfriend.')
c=.c,<(<'Do you really mean love?'),(<'What kind of love?.')
c=.c,<(<'Is not hate too strong?'),(<'Why do you hate?')
c=.c,<(<'Is your family important?'),(<'Tell me more about your family.')
KeywordAns=.c

c=.(<'Why do you ask?')
c=.c,(<'Why do you think this?')
c=.c,(<'What are your thoughts on this?')
Answer=.c

c=.(<'never')
c=.c,(<'you')
Otherword=.c

c=.<(<'Never?'),(<'Never say never!')
c=.c,<(<'Lets talk about you, not me.'),(<'Me?')
OtherwordAns=.c

c=.<'Lets change the subject.'
c=.c,<'What do you do for fun?'
c=.c,<'What are your interests?'
c=.c,<'What else would you like to talk about?'
c=.c,<'How would you describe your personal life in one word?'
Starter=.c
c=.0$0

NB. 'To run, type: eliza 0   '
NB. '(Or  eliza <arg>  where <arg> is any valid J expression.)'

