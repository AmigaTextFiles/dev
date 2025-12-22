*VECTORS.AS
*******************************************************************************
*                                                                             *
* The following definitions constitute the interrupt vector table. The user   *
* may modify this as necessary to fit his application. DO NOT CHANGE THE      *
* BASIC DEFINITIONS AS SHOWN BELOW.                                           *
*                                                                             *
*******************************************************************************

        ORG    $FFF0
        FDB    rtiisr              RTI Vector

        ORG    $FFF6
        FDB    mcxsrv              SWI Vector to enter MCX11 ESRs

        ORG    $FFFE
        FDB    mcxinit             Power-On/Reset Vector
