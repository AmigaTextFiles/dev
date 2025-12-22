// tato ukazka predvadi pouziti funkce ReadEStr() = cteni textu z shellu

// nejprve musime vytvorit promennou typu STRING (textovy retezec)
// do ktere budeme ukladat textove znaky, nastavime mu maximalni delku 32 znaku
DEF	text[32]:STRING

PROC main()

	// ukazka A

	// zde vypiseme nejaky text
	PrintF('napis nejaky text, a ja ho napisu 2x\n')

	// nyni pouzijeme funkci ReadEStr(), abychom do promenne s nazvem 'text'
	// ulozili to, co jsme v shellu napsali a odentrovali
	ReadEStr(stdin,text)
	// prvnim argumentem by skoro vzdy mela byt promenna s nazvem 'stdin' tak
	// jako v nasem pripade, druhym argumentem je promenna s nazvem 'text', coz
	// musi byt promenna typu STRING s definovanou maximalni velikosti

	// a nyni vypiseme obsah promenne 'text' do shellu 2x
	PrintF('poprve:  "\s"\npodruhe: "\s"\n',text,text)
	// text se vypise pokazde v uvozovkach, a je na dva radky.


	// ukazka B

	// pokud chcete, aby se text nepsal na vlastnim radku, ale aby se
	// psal bezprostredne za vami vypsanym textem, je treba pouzit funkci
	// WriteF() na misto funkce PrintF(), protoze funkce PrintF() pouziva
	// bufferovany zapis, a text se bez odradkovani '\n' nevypise, takze to
	// udelame takto:
	WriteF('napis nejaky text: ')
	// vsimnete si, ze text neodradkujeme pomoci '\n', kurzor tedy zustane
	// bezprostredne za textem, to je zpusobeno tim, ze funkce WriteF() pouziva
	// primy zapis, a vypisuje kazdy znak, nekdy je to vyhodne, nekdy ne.
	// s klidem muzete funkce WriteF() pouzivat vzdy, ale ne vzdy bude rychlejsi
	// nez PrintF()

	// nyni opet precteme to, co jsme napsali do shellu, uplne stejne
	// jako v ukazce A
	ReadEStr(stdin,text)

	// nyni text vypiseme
	PrintF('napsal jsi: "\s"\n',text)
	// jak je videt, uz jsem pouzil opet funkce PrintF(), ted uz nepotrebujeme
	// mit kurzor na konci radku, tim nasim '\n' ho presuneme na novy radek a
	// vypiseme text ktery tomuto znaku predchazel do shellu


	// ukazka C

	// nyni vepiseme preddefinovany text tak, aby stacilo pouze odentrovat,
	// a meli jsme zvoleny text, ktery jsme tam predem vepsali, k tomu slouzi
	// specialni znak '\b', coz je snak return, jenz navraci kurzor zpet na
	// prvni znak na aktualnim radku, a tim nam umoznuje radek prepisovat:
	PrintF('napis nejaky text: MarK je nejlepsi!\b')
	WriteF('napis nejaky text: ')
	// vypsali jsme text i s preddefinovanou volbou textu 'MarK je nejlepsi!', a
	// znakem '\b' jsme se vratili na zacatek radku, potom jsme funkci WriteF()
	// vypsali znovu text dotazu tak, aby byl odpovidal textu nad nim, protoze
	// se prepise.

	// nyni opet precteme to, co jsme napsali do shellu, uplne stejne
	// jako v ukazce A a B
	ReadEStr(stdin,text)
	// zde tato funkce cte pouze ty znaky, ktere predchazeji odentrovani, tudiz
	// pokud bude napsany text kratsi, nez je text 'MarK je nejlepsi!', nebude
	// v promenne 'text' zbytek tohoto textu nacten

	// pokud pouze odentrujeme, bude promenna 'text' obsahovat pouze prazdny
	// retezec, takze zjistime, jestli je jeho velikost nulova (tzn, ze jsme
	// pouze odentrovali, a muzeme tak tedy zkopirovat prednastaveny text
	IF StrLen(text)=0 THEN StrCopy(text,'MarK je nejlepsi!')
	// cte se: pokud je delka retezce v promenne 'text' nulova, pak do promenne
	// 'text' zkopiruj retezec: 'MarK je nejlepsi!'

	// nyni text vypiseme
	PrintF('napsal jsi: "\s"\n',text)
ENDPROC

