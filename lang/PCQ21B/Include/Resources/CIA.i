{
        CIA.i for PCQ Pascal
}

{$I "Include:Exec/Interrupts.i"}
{$I "Include:Exec/Libraries.i"}

Const

    CIAANAME    = "ciaa.resource";
    CIABNAME    = "ciab.resource";

FUNCTION AddICRVector(Resource : LibraryPtr; iCRBit : Integer; 
                      int : InterruptPtr) : InterruptPtr;
    External;

PROCEDURE RemICRVector(Resource : LibraryPtr; iCRBit : Integer;
                       int : InterruptPtr);
    External;

FUNCTION AbleICR(Resource : LibraryPtr; mask : Integer) : WORD;
    External;

FUNCTION SetICR(Resource : LibraryPtr; mask : Integer) : WORD;
    External;


