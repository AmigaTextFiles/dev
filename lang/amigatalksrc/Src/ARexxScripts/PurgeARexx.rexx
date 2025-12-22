/*************************************************************
** PurgeARexx.rexx Test the ARexxManager & ARexxFuncs for
**                 AmigaTalk!
**************************************************************/

Options FailAt 5

if ~show( 'l', "rexxsupport.library" ) then do
   check = addlib( 'rexxsupport.library', 0, -30, 0 )
end

ADDRESS "AmigaTalk_Rexx"

Do

/*   'Interpret PurgeEnvFile' */
   'Interpret KillScreen'
      
RETURN 