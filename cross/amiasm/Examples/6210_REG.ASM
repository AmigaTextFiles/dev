;|---------------------------------------------------------------------------|
;|                    ST6210/15 and ST6220/25 Registers Declaration          |
;| Use this file with the .input directive.                                  |
;|---------------------------------------------------------------------------|

x        .def 80h                 ; Index register.
y        .def 81h                 ; Index register.
v        .def 82h                 ; Short direct register.
w        .def 83h                 ; Short direct register.

a        .def 0ffh                ; Accumulator.

dra      .def 0c0h                ; Port a data register.
drb      .def 0c1h                ; Port b data register.
drc      .def 0c2h                ; Port c data register.

ddra     .def 0c4h                ; Port a direction register.
ddrb     .def 0c5h                ; Port b direction register.
ddrc     .def 0c6h                ; Port c direction register.

ior      .def 0c8h                ; Interrupt option register.
drwr     .def 0c9h                ; Data rom window register.

ora      .def 0cch                ; Port a option register.
orb      .def 0cdh                ; Port b option register.
orc      .def 0ceh                ; Port c option register.

adr      .def 0d0h                ; A/D data register.
adcr     .def 0d1h                ; A/D control register.

psc      .def 0d2h                ; Timer prescaler register.
tcr      .def 0d3h                ; Timer counter register.
tscr     .def 0d4h                ; Timer status control register.

wdr      .def 0d8h                ; Watchdog register.

