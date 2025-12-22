#!@PATH_PERL@
eval 'exec @PATH_PERL@ -S $0 ${1+"$@"}'
    if $running_under_some_shell;
##   ____ __  __       _        
##  / ___|  \/  | __ _| | _____ 
##  \___ \ |\/| |/ _` | |/ / _ \
##   ___) ||  | | (_| |   <  __/
##  |____/_|  |_|\__,_|_|\_\___|
##                             
##  SMake -- Makefile generator
##
##  SMake is a powerful mechanism to generate standard Makefiles out
##  of skeleton Makefiles which only provide the essential parts.
##  The missing stuff gets automatically filled in by shared include
##  files. A great scheme to create a huge Makefile hierarchy and to
##  keep it consistent for the time of development.  The trick is
##  that it merges the skeleton and the templates in a
##  priority-driven way. The idea is taken from X Consortiums Imake,
##  but the goal here is not inherited system independency, the goal
##  is consistency and power without the need of manually maintaining
##  a Makefile hierarchy. 
##
##  Copyright (C) 1994-1999 Ralf S. Engelschall, <rse@engelschall.com>
##
##  This program is free software; it may be redistributed and/or
##  modified only under the terms of the GNU General Public License,
##  which may be found in the SMake source distribution.  Look at the
##  file COPYING. 
##  
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
##  General Public License for more details.
## 
##  smake_smkmf.pl -- main procedure for "smkmf" executable
##

require 5.0;

#   include the common parts
#   (these will be substituted by 
#    the real contents via ``unrequire'' later)
require "smake_misc.pl";
require "smake_getopts.pl";
require "smake_file.pl";
require "smake_version.pl";

#
#   print command line usage
#
sub usage {
    print <<'EOT';
Usage: smkmf [options] [directory]
  were options are
    -I includepath   add includepath to list of include directories
    -a               operate on all SMakefiles found in the current subtree
    -q               quiet mode
    -x               debug mode
    -V               display version identification string
    -h               display usage list (this one)
EOT
}

#
#   parse argument line
#
if (&Getopts('aI+qVh') == 0) {
    &usage;
    exit $EX{'USAGE'};
}
if ($opt_h) {
    &usage;
    exit $EX{'OK'};
}
if ($opt_V) {
    print "$smake_Hello\n";
    exit $EX{'OK'};
}
if ($#ARGV == -1) {
    $makedir = '.';
}
elsif ($#ARGV == 0) {
    $makedir = &file::CanonFilename($ARGV[0]);
}
else {
    &usage;
    exit $EX{'USAGE'};
}
$all   = $opt_a ? 1 : 0;
$quiet = $opt_q ? 1 : 0;
@includepath = ();
if ($#opt_I != -1) {
    push(@includepath, @opt_I);
}
push(@includepath, split(':', $default_includepath));


#
#   determine path to ``smake'' program
#
$smakepath='';
foreach $path (split(/:/, $ENV{'PATH'})) {
    if (-x "$path/smake") {
        $smakepath = "$path/smake";
        last;
    }
}
if ($smakepath eq '' && -x "$prgpath/smake") {
    $smakepath = "$prgpath/smake";
}
if ($smakepath eq '') {
    print "$prgname: program \`\`smake\'\' not found\n";
    exit $EX{'OSERR'};
}
$smakepath = &file::CanonFilename($smakepath);
if ($makedir =~ m|^/.*|) {
    $smakepath = &file::AbsFilename($smakepath);
}
else {
    if ($smakepath !~ m|^/.*|) {
        $smakepath = &file::CanonFilename(&file::RevPath($makedir) . '/' . $smakepath);
	}
}


#
#   canonicalize includepath components according to 
#   the make root dir
#
@includepathnew = ();
foreach $path (@includepath) {
    if ($path =~ m|^/.*|) {
        push(@includepathnew, $path);
    }
    else {
        push(@includepathnew, &file::CanonFilename(&file::RevPath($makedir) . '/' . $path));
    }
}
$includepath = join(':', @includepathnew);

#$definclpath = $smakepath;
#$definclpath =~ s|^(.*)/[^/]+$|\1|;
#$definclpath = $definclpath . "/include";
#$definclpath = &file::CanonFilename($definclpath);
#$includepath = $includepath . ':' . $definclpath;


#
#   recursive function to process a directory
#
sub ProcessDir {
    my ($echodir, $dir, $inclpath, $smakepath, $mode) = @_;
    my (@flist, $path, @inclpathnew);
    my ($filepath, $filename, $smakefile, $inclpathCur, $smakepathCur);

    if ($echodir ne '') {
        $echodir = "$echodir/";
    }

    @flist = sort(&file::xfts($dir));
    @flistfile = ();
    @flistdir = ();
    foreach $filepath (@flist) {
        if (-f "$filepath") {
            push(@flistfile, $filepath);
        }
        else {
            push(@flistdir, $filepath);
        }
    }
    @flist = (sort(@flistfile), sort(@flistdir));

    foreach $filepath (@flist) {
        $filepath = &file::CanonFilename($filepath);
        $filename = $filepath;
        $filename =~ s|^.*/([^/]+)$|\1|;

        if (-f "$filepath" && $filename =~ m|^([sS][mM]akefile)$|) {
            #   process smakefile
            $found = 1;
            print "$smakepath -I$inclpath $filepath\n";
            system("$smakepath -I$inclpath $filepath");
        }

        if (-d "$filepath" && $mode == 1) {

            #   determine individual include path
            @inclpathnew = ();
            foreach $path (split(/:/, $inclpath)) {
                if ($path =~ m|^\/.*|  ||
                    $path =~ m|^\.$|   ||
                    $path =~ m|^\.\.$|   ) {
                    push(@inclpathnew, $path);
                }
                else {
                    push(@inclpathnew, &file::CanonFilename("../$path"));
                }
            }
            $inclpathCur = "@inclpathnew";
            $inclpathCur =~ s| |:|g;

            #   determine individual path to smake binary
            if ($smakepath =~ m|^\/.*|) {
                $smakepathCur = $smakepath;
            }
            else {
                $smakepathCur = "../$smakepath";
            }
            $smakepathCur = &file::CanonFilename($smakepathCur);

            #   process subdir
            if ($quiet == 0) {
                print "===> $echodir$filename\n";
            }
            chdir ($filename);
            &ProcessDir("$echodir$filename", '.', $inclpathCur, $smakepathCur, $mode);
            chdir ("..");
        }
    }
}


#
#   start of actual processing
#
$found = 0;

$ocwd = `pwd`;
chdir($makedir);
if ($quiet == 0) {
    print "[dir=$makedir]\n";
}

&ProcessDir('', '.', $includepath, $smakepath, $all);

chdir($ocwd);

if ($found == 0) {
    print "$prgname: no \`\`smakefile\'\', \`\`Smakefile\'\' or \`\`SMakefile\'\' files found\n";
}

#
#   exit gracefully
#
exit $EX{'OK'};


#EOF#
