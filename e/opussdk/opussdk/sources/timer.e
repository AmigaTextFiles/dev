/*****************************************************************************

 Timer

 *****************************************************************************/

OPT MODULE
OPT EXPORT

MODULE 'exec/ports', 'devices/timer'

OBJECT timerHandle
    port:PTR TO mp          -> Port to wait on
    req:timerequest         -> Timer request
    my_port:PTR TO mp       -> Supplied port
    active:INT              -> Indicates active request
ENDOBJECT
