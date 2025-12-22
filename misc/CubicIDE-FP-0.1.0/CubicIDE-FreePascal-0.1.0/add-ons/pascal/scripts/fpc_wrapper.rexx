/*
    $VER = 0.1.0

    @author: Manfred Bergmann


    Wrapper for FreePascal compiler/build

    possible arguments:
    1. mode [compile | compile_verbose | build | compile_run | run]
    2. input [filepath]
    3. (opt) debug [echo]: outputs the entered parameters

*/

parse arg mode input debug

signal on halt
signal on break_c

options results

FPC = 'FreePascal:bin/m68k-amiga/fpc'
/*FPC = 'FreePascal:bin/powerpc-morphos/fpc'*/

/* check arguments */
if mode = '' then do
    say "Unknown mode!"
    exit
end
if input = '' then do
    say "Unknown input!"
    exit
end

if debug = 'echo' then do
    say 'mode: 'mode
    say 'input: 'input
    exit
end

/* extract the folder and filename of the file to be compiled */
inputLen = length(input)
p = lastpos('/', input)
if p > 0 then do
    file_name = trim(substr(input, p+1, inputLen-1))
    folder_path = substr(input, 1, p-1)
end
else do
    file_name = input
    folder_path = ''
end
say 'filename: 'file_name
say 'folder: 'folder_path

/* generate the assembly name (stripping away the .pas) */
p = lastpos('.', file_name)
if p = 0 then do
    say 'Not a valid Pascal filename, should contain ".pas"!'
    exit
end
assembly_name = trim(substr(file_name, 1, p-1))
say 'Assembly name: 'assembly_name

/* construct output filename mapping */
if length(folder_path) = 0 then
    outputmap_path = '.fpcout-'assembly_name
else
    outputmap_path = folder_path'/.fpcout-'assembly_name

/* check for a compile output name, if it doesn't exist request one */
if exists(outputmap_path) = 0 then do
    outputname = assembly_name

    /* store output name in file */
    say 'Storing out name to: 'outputmap_path
    if open('outFile', outputmap_path, 'W') = 0 then do
        say 'Error opening file for writing!'
        exit
    end
    foo = writeln('outFile', outputname)
    if close('outFile') = 0 then say 'Error at closing output file!'
end
else do
    /* read output name from file */
    if open('inFile', outputmap_path) = 0 then do
        say 'Error opening file for writing!'
        exit
    end
    outputname = trim(readln('inFile'))
    if close('inFile') = 0 then say 'Error at closing input file!'
end
say 'Output name: 'outputname

/* Now compile and or run */
if mode = 'compile' | mode = 'compile_run' then do
    say 'Compiling...'
    ADDRESS COMMAND FPC input '-o'outputname
    say 'Compiling...done'
end
else if mode = 'compile_verbose' then do
    say 'Compiling verbose...'
    ADDRESS COMMAND FPC '-va ' input '-o'outputname
    say 'Compiling verbose...done'
end
/* TODO: not sure what build actually does */
else if mode = 'build' then do
    say 'Building...'
    ADDRESS COMMAND FPC '-B 'input '-o'outputname
    say 'Building...done'
end

/* run? */
if mode = 'compile_run' | mode = 'run' then do
    if length(folder_path) = 0 then
        exepath = outputname
    else
        exepath = folder_path'/'outputname

    say 'Run...'exepath
    ADDRESS COMMAND exepath
end

exit

