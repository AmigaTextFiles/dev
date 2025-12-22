program chaines;   { Affectation de chaines...}

var
    chaine1, chaine2    : string;
    chaine3, chaine4    : string;
    ch1, ch2    : char;
    ch3, ch4    : char;

begin
    chaine1 := 'Hello';
    chaine2 := ' World ';
    chaine3 := '!!!';
    writeln ('Phrase: ',chaine1,chaine2,chaine3);

    chaine4 := chaine1;
    chaine1 := chaine3;
    chaine3 := chaine4;
    writeln ('Inversion: ',chaine1,chaine2,chaine3);

    ch1 := 'O';
    ch2 := 'k';
    ch3 := '!';
    writeln ('Carac: ',ch1,' ',ch2,' ',ch3);

    ch4 := ch1;
    ch1 := ch3;
    ch3 := ch4;
    writeln ('inverse: ',ch1,' ',ch2,' ',ch3);

end.