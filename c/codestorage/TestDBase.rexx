/* TestDBase.rexx exercises the various messages that */
/* DBaseManager © recognizes! */

Options FailAt 5

if ~show( 'l',"rexxsupport.library" ) then do
   check = addlib( 'rexxsupport.library',0,-30,0 )
end

TRACE ALL

/* HostIDCommand = 'DataManagerID '||address() */
ADDRESS "DBase_Rexx"

DO
OPTIONS RESULTS

    nfields    = 3
    recsize    = 35
    memosize   = 4096
    recaddr    = GetSpace( recsize )
    r          = c2x( recaddr )
    memoaddr   = GetSpace( memosize )
    m          = c2x( memoaddr )
    userfaddr  = GetSpace( nfields * 14 ) /* each dBFIELD is 14 bytes */
    u          = c2x( userfaddr )
    say "UserFields = "||u

    'ClearMemory '||u||' 42'
    'ClearMemory '||r||' 35'
    'ClearMemory '||m||' 4096'
    'SetupField '||u||' CharacStr1 C 20 0'
    'SetupField '||u||' Numberone1 N 5  2'
    'SetupField '||u||' DateIsNice D 10 0' 
    'InitEnv myenv '||r||' '||m||' '||u||' 3 35 4096'
    'DefineFileName myenv DBFfilename'
    'DefineFileName myenv NDXfilename'
    'DefineFileName myenv DBTfilename'
    'ChooseEnv myenv'
    'TranslateErrorNumber 2504'
    Addr = x2c(value( Result ))
    Str  = import( Addr )
    say Str

    'CreateDataFile DBFfilename'
    if Result > 0 then
       do
        say "Result was "
        'TranslateErrorNumber '||Result
        Addr = x2c(value( Result ))
        Str  = import( Addr )
        say Str
       end
    'OpenDataFile'
    if Result > 0 then
       do
        say "Result was "
        'TranslateErrorNumber '||Result
        Addr = x2c(value( Result ))
        Str  = import( Addr )
        say Str
       end
    'GetRecord 0'
    if Result > 0 then
       do
        say "Result was "
        'TranslateErrorNumber '||Result
        Addr = x2c(value( Result ))
        Str  = import( Addr )
        say Str
       end
    'OutputRecord'   /* the one that GetRecord just loaded into the
                     ** Current Record Buffer! */
/*
       Addr = x2c(value( Result ))
       Str  = import( Addr )
       say Str
*/
    /* Do some modifications, if desired. */
    'PutRecord 1'
    if Result > 0 then
       do
        say "Result was "
        'TranslateErrorNumber '||Result
        Addr = x2c(value( Result ))
        Str  = import( Addr )
        say Str
       end
    'CloseDataFile'
    'PurgeEnv myenv'
    'QuitDBase'
RETURN
