MODULE 'oomodules/GUI/requester/standard'

PROC main()
DEF sr:PTR TO standardRequester,
    bla:PTR TO CHAR

  NEW sr.new()

  sr.message('You are about to loose weight')

  sr.choice('Do you want to explode?')

  sr.query('Choose your favourite colour','Red|Green|Blue')

   bla :=sr.getFile('#?.e', [SR_TITLE, 'Please choose a file to add to the project',
                                                SR_DIR, sr.getLastDirChosen(),
                                                SR_WINDOW, sr.getWindowToAppearOn()])

WriteF('You chose \s.\n', bla)

  WriteF('the last dir you chose was \s.\n', sr.getLastDirChosen())
  WriteF('the last file you chose was \s.\n', sr.getLastFileChosen())



  WriteF('You chose \s.\n', sr.getFile('*.m', [SR_DIR,'emodules:',SR_TITLE,'juhuuu']))

  WriteF('the last dir you chose was \s.\n', sr.getLastDirChosen())
  WriteF('the last file you chose was \s.\n', sr.getLastFileChosen())


ENDPROC
