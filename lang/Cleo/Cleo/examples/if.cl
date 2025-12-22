program IfThenElse;

var
    b      : real;
    reponse : real;

begin

    repeat
        write('Entrer un nombre:');
        readln(b);
        if b<5 then
            writeln(b,' est < 5')
        else
            if b=5 then writeln(' .....5')
        else
            if b=10 then
                   writeln ('..... 10')
        else
            if b>10 then
                writeln(b,' est > 10')
        else
            writeln(b,' est entre 5 et 10');
        write('On continue? (Non=0) :');
        readln(reponse);
   until reponse=0;
end.