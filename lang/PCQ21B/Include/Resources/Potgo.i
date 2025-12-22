{
        Potgo.i for PCQ Pascal
}

Const

    POTGONAME   = "potgo.resource";

FUNCTION AllocPotBits(bits : Integer): Word;
EXTERNAL;

PROCEDURE FreePotBits(bits : Integer);
EXTERNAL;

PROCEDURE WritePotgo(theword : Integer; mask : Integer);
EXTERNAL;


