OPT MODULE
OPT EXPORT
OPT NODEFMODS
-> Module created with E:bin/fd2mod from YAECv2.5 package.
MACRO Translate(inputString,inputLength,outputBuffer,bufferSize) IS Stores(translatorbase,inputString,inputLength,outputBuffer,bufferSize) BUT Loads(A6,A0,D0,A1,D1) BUT ASM ' jsr -30(a6)'
