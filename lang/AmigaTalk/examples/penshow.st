"
   this is useful only if the plot(3) routines work
"
Class Main
| bic show |
[
   init
      bic  <- Pen new: 'PenShow.st Example:'.
      bic openPlotEnv: 500 @ 350.
      bic setPens:     2 @ 0.
      show <- PenShow new.
      show withPen: bic.
|
   main
      self init.
      self polyShow.
      self spiralShow.
      self formShow.
|
   polyShow
      bic erase.
      bic goTo: 50 @ 50.

      (3 to: 8) do: [:i | show poly: i length: 10 ].
|
   spiralShow
      bic erase.
      bic    goTo: 250 @ 250.
      show spiral: 150 angle: 89
|
   formShow   | newForm saveBic |
      newForm <- Form new.
      saveBic <- bic.

      bic <- PenSave new.

      bic   setForm: newForm.
      bic direction: 0.

      show withPen: bic.
      self polyShow.

      bic <- saveBic.

      newForm with: bic displayAt: -15 @ ( -15 ).
      newForm with: bic displayAt: 0 @ 0.
      newForm with: bic displayAt: 20 @ ( -20 ).
      ^ newForm
]
