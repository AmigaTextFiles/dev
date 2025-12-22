#drinc:util.g

channel input binary ChIn;
channel output binary ChOut;

file() FIn, FOut;

[256] byte Key;
[256] char CharKey @ Key;
[256] byte StartKey;

[256] ushort Table1, Table2;

bool EnCrypt;

proc process()void:
    [256] byte buffer1, buffer2;
    [128] byte shortBuff;
    ushort i;
    bool done;

    done := false;
    while not done do
	if read(ChIn; shortBuff) then
	    for i from 0 upto 128 - 1 do
		buffer1[i] := shortBuff[i];
	    od;
	    if read(ChIn; shortBuff) then
		for i from 0 upto 128 - 1 do
		    buffer1[i + 128] := shortBuff[i];
		od;
	    else
		done := true;
	    fi;
	    for i from 0 upto 256 - 1 do
		if EnCrypt then
		    buffer2[i] := buffer1[Table1[i]] >< Key[i];
		else
		    buffer2[i] := buffer1[Table2[i]] >< Key[Table2[i]];
		fi;
	    od;
	    if not write(ChOut; buffer2) then
		write(" bad write to output file.");
		exit(1);
	    fi;
	    for i from 0 upto 256 - 1 do
		Key[i] := Key[i] * 19 + 37;
	    od;
	else
	    done := true;
	fi;
    od;
corp;

proc fixKey()void:
    ushort i, j, s;
    byte b;

    s := 256 - 1;
    while s ~= 0 and CharKey[s] = ' ' do
	s := s - 1;
    od;
    i := s + 1;
    j := 0;
    while
	CharKey[i] := CharKey[j];
	if j = s then
	    j := 0;
	else
	    j := j + 1;
	fi;
	i ~= 256 - 1
    do
	i := i + 1;
    od;
    b := 0;
    for i from 1 upto s do
	b := b + Key[i];
    od;
    for i from 0 upto 256 - 1 do
	Key[i] := Key[i] >< b;
	b := b * 13 + 59;
    od;
    StartKey := Key;
    for i from 0 upto 256 - 1 do
	Table1[i] := b;
	Table2[b] := i;
	b := b * 17 + 43;
    od;
corp;

proc main()void:
    *char par, p, q;
    [100] char nameIn, nameOut;

    par := GetPar();
    if par ~= nil and par* = '-' then
	par := par + 1;
    fi;
    if par = nil or par* ~= 'd' and par* ~= 'e' or (par + 1)* ~= '\e' then
	writeln("Use is: crypt -{d|e} file1 ... fileN");
    else
	EnCrypt := par* = 'e';
	par := GetPar();
	if par = nil then
	    writeln("Use is: crypt -{d|e} file1 ... fileN");
	else
	    write("Key> ");
	    if readln(CharKey) then
		fixKey();
		while
		    write(par, ':');
		    CharsCopy(&nameIn[0], par);
		    CharsCopy(&nameOut[0], par);
		    if EnCrypt then
			CharsConcat(&nameOut[0], ".CRP");
		    else
			CharsConcat(&nameIn[0], ".CRP");
		    fi;
		    if open(ChIn, FIn, &nameIn[0]) then
			if FileDestroy(&nameOut[0]) then fi;
			if FileCreate(&nameOut[0]) then
			    if open(ChOut, FOut, &nameOut[0]) then
				process();
				Key := StartKey;
				if not close(ChOut) then
				    write(" error closing output file");
				fi;
			    else
				write(" can't open output file");
			    fi;
			else
			    write(" can't create output file");
			fi;
			close(ChIn);
		    else
			write(" can't open input file");
		    fi;
		    writeln();
		    par := GetPar();
		    par ~= nil
		do
		od;
	    fi;
	fi;
    fi;
corp;
