{Pomocnik Tîumacza v0.2beta by Albert Jasinski}
program pomocnik_tlumacza;

uses 
	crt;

Var	
	plik_odczytu,plik_zapisu	:text;
	linia_odczytu,linia_zapisu	:string[100];
	nazwa_odczytu,nazwa_zapisu	:string[100];
	menu						:byte;

procedure podpis;
begin
clrscr;
Writeln ('Pomocnik Tîumacza - Albert Jasiïski 2002');
Writeln ('v0.2beta 20.02.2002');
Writeln('');
end;

procedure pomoc;
begin
podpis;
Writeln('Najlepiej odpalaê z Shella gdyû program koûysta z KingCONa');
Writeln('');
Writeln('Program ten pomaga w lokalizowaniu programów które nie koûystajâ z systemowej lokalizacji');
Writeln('Najpierw naleûy wyciâê za pomocâ CEDa fragment z orginalnymi tekstami (najczëôciej znajdujâ sië w EXEcu).');
Writeln('Nastëpnie naleûy zamieniê znaki konca linji uzyte w execu na normalne Entery (teû CEDem).');
Writeln('Taki plik moûna obrabiaê Pomocnikiem Tîumacza pamiëtajâc o zachowaniu dîugoôêi kaûdej linijki tekstu.');
Writeln('W tym caîa niestety trudnoôê tîumaczenia bo jak zapisaê "NIE" w 2 literach :).');
Writeln('Po przetworzeniu caîego pliku naleûy sprawdziê czy dîugoôê pliku sie nie zmieniîa.');
Writeln('Normalne Entery trzeba na powrót zamieniê na orginalne znaki konca linji');
Writeln('Teraz naleûy wkleiê W ODPOWIEDNIE miejsce przetîumaczony fragment');
Writeln('caîy czas pamiëtajâc o zachowaniu dîugoôci caîego pliku.');
Writeln('');
Writeln('Pomocnik Tîumacza ma status FREEWARE');
Writeln('Kaûdy chëtny moûe go rozwijaê jednak proszë o wczeôniejszâ konsultacjë poprzez EMAIL: haas@kocham.krakow.pl');
Writeln('');
Writeln('Do zrobienia:');
Writeln('	1. Automatyczne ucinanie za dîugich linijek przetîumaczonego tekstu.');
Writeln('	2. Automatyczne dopeînianie krutszych linijek przetîumaczonego tekstu.');
Writeln('	3. Moûliwoôê przerwania pracy w dowolnym momencie i póúniej kontynuowania.');
Writeln('	4. Automatyczna zamiana znaków koïca linijek (w obie strony)');
Writeln('	5. Automatyczne przeszukiwanie plików w poszukiwaniu Tekstów');
Writeln('');
Writeln('Oczekujë wsparcia ze strony programistów (jako ûe ze mnie to .... a nie programista)');
Writeln('                                                                Albert Jasiïski');
Writeln('[ENTER]');
readln;
end;

procedure praca;
begin
	podpis;
	write('Podaj scieûkë i nazwë pliku úródîowego:');
	readln(nazwa_odczytu);
	clrscr;
	podpis;
	write('Podaj ôciaûkë i nazwë pliku docelowego:');
	readln(nazwa_zapisu);
	assign(plik_odczytu,nazwa_odczytu);
	reset(plik_odczytu);
	assign(plik_zapisu,nazwa_zapisu);
	rewrite(plik_zapisu);
	 while not eof(plik_odczytu) do begin
		clrscr;
		readln(plik_odczytu,linia_odczytu);
		writeln('Angielski: ',linia_odczytu);
		write('Polski:    ');
		readln(linia_zapisu);
		writeln(plik_zapisu,linia_zapisu);
	 end;
	close(plik_odczytu);
	close(plik_zapisu);
end;

procedure wyjscie;
begin
	clrscr;
	podpis;
	write('Do Zobaczenia !!!');
	Delay (3000);
end;

begin
	menu:=3;
	repeat
	podpis;
	write('MENU:  1=POMOC  2=ROZPOCZËCIE PRACY  3=WYJSCIE Z PROGRAMU : ');
	readln(menu);
	clrscr;
	if (menu=1) then pomoc;
	if (menu=2) then praca;
	if (menu=3) then wyjscie;
	until (menu=3)
end.