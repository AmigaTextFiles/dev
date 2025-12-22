MODULE MemManHierachyDemo;

FROM memmanagerL    IMPORT CreateVMem, RemoveVMem, LockVMem, UnlockVMem,
			       DefineVMemHierachy, ClearVMemHierachy,
			       ChangeVMemPri, paged, disposable;
FROM ExecD          IMPORT MemReqSet, public;
FROM InOut          IMPORT WriteLn, WriteString, WriteCard;
FROM DosL           IMPORT Delay;
FROM SYSTEM         IMPORT ADDRESS, CAST, ADR;


TYPE
    somedataPtr = POINTER TO somedata;
    somedata    = RECORD
	s   : ARRAY[1..40] OF CHAR;
	n   : CARDINAL;
    END;

VAR
    myvmem  : ARRAY [1..65] OF ADDRESS;
    myadr   : ADDRESS;
    i       : CARDINAL;
    ch      : ARRAY [1..2] OF ADDRESS;
    data    : somedataPtr;



BEGIN
    WriteString("Opened library");
    WriteLn;

    (* Allocate a load OF memory AND use hierachies TO tell mammanager
    ** what we will need IN whatorder
    ** We allocate 4 megabytes in 64 64k chunks.
    *)

    FOR i:=1 TO 64 DO
	myvmem[i]:=CreateVMem(65536, CAST(LONGINT,MemReqSet{public}), 0, paged);

	(* Priority is 8 as we are using the block *)

	WriteString("Created memory"); WriteLn;

	myadr:=LockVMem(myvmem[i]);
	IF myadr<>NIL THEN
	    WriteString("Locked Memory"); WriteLn;
		(* This is just TO force it into memory *)

	    (* Now it is ok FOR us TO Write TO the memory as long
	    ** as myadr is NOT NIL *)

	    data:=CAST(somedataPtr, myadr);
	    data^.s := "Some data retreived : ";
	    data^.n := i;

	    UnlockVMem(myvmem[i]);
	ELSE
	    WriteString("Couldn't lock vmem - disk or ram full");
	END;

	WriteString("Unlocked Memory"); WriteLn;
    END;

    myvmem[65]:=NIL; (* has TO be NIL terminated *)

    (* Create a Hierachy containing the items we will need IN the
    order we will need them IN *)

    DefineVMemHierachy(ADR(myvmem[1]));

    (* Now we lock it all again TO test reloading *)

    WriteString("Now lets lock all OF that again"); WriteLn;

    FOR i:=1 TO 64 DO
	myadr:=LockVMem(myvmem[i]);

	WriteString("Locked Memory"); WriteLn;
	    (* This is just TO force it into memory *)

	(* Now it is ok FOR us TO Write TO the memory as long
	** as myadr is NOT NIL *)

	IF myadr<>NIL THEN
	    data:=CAST(somedataPtr, myadr);
	    WriteString(data^.s);
	    WriteCard(data^.n , 5);
	    WriteLn;

	    UnlockVMem(myvmem[i]);

	    WriteString("Unlocked Memory"); WriteLn;
	ELSE
	    WriteString("Couldn't lock memory!");
	END;

	(* Now remove the item FROM the hierachy
	AND reduce it's priority *)

	ch[1]:=myvmem[i]; ch[2]:=NIL;

	ClearVMemHierachy(ADR(ch));
	ChangeVMemPri(myvmem[i],-8); (* as no longer IN use *)

    END;

    Delay(200);

    WriteString("Removing VMem buffers"); WriteLn;

    FOR i:=1 TO 64 DO
	RemoveVMem(myvmem[i]);
    END;

END MemManHierachyDemo.




