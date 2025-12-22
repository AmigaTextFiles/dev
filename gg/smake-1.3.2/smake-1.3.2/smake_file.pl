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
##  smake_file.pl -- file I/O stuff
##

package file;


#   Use this function to convert a relative path to a reverse path.
#   i.e.   ./xx/abc -> ../../
#
#   SYNOPSIS: $newfilename = &file::RevPath($filename)
#
sub RevPath {
    my ($path) = @_;
    my ($cwd, $dir);

    if ($path =~ m|^/.*|) {
        $revpath = `pwd`;
    }
    else {
        push(@cwd, split(/\//, &CanonFilename(`pwd`)));
        $revpath = '';
        foreach $name (split(/\//, &CanonFilename($path))) {
            if ($name eq "..") {
                $revpath =  pop(@cwd) . ' ' . $revpath;
            }
            elsif ($name eq ".") {
                $revpath = '.' . ' ' . $revpath;
            }
            else {
                $revpath = '..' . ' ' . $revpath;
            }
        }
        $revpath =~ s|^[ ]*(.*[^ ]+)[ ]*$|\1|;
        $revpath =~ s| +|/|g;
    }
    return ($revpath);
}


#   Use this function to convert a filename to absolute path.
#
#   SYNOPSIS: $newfilename = &file::AbsFilename($filename)
#
sub AbsFilename {
    my ($filename) = @_;
    my ($cwd, $dir);

    if ($filename !~ m|^/.*|) {
        if (-d "$filename") {
            $cwd = `pwd`;
            chdir($filename);
            $filename = `pwd`;
            chdir($cwd);
        }
        else {
            $dir = $filename;
            if ($dir =~ m|^[^/]+$|) {
                $filename = "`pwd`/$filename";
            }
            else {
                $dir =~ s|^(.*)/[^/]+$|\1|;
                $cwd = `pwd`;
                chdir($dir);
                $filename = "`pwd`/$filename";
                chdir($cwd);
            }
        }
    }
    return ($filename);
}


#   Use this function to canonicalize a filename.
#
#   SYNOPSIS: $newfilename = &file::CanonFilename($filename)
#
sub CanonFilename {
    local ($filename) = @_;

    $filename =~ s|\n$||;                      # remove newline terminator

    $filename =~ s|/$||;                       # strip useless slash at end

    $filename =~ s|/\./|/|g;                   # canonicalize /ab/./xy/ -> ab/xy
    $filename =~ s|^\./||;                     # canonicalize ./xy -> xy
    $filename =~ s|/\.[/]*$||g;                # canonicalize /ab/./ -> ab

    $filename =~ s|//|/|g;                     # strip unneeded slahes even
    $filename =~ s|//|/|g;                     # strip unneeded slahes odd

    if ($filename !~ m|/\.\./\.\./|) {
        $filename =~ s|/([^/]+)/\.\./|/|g;     # canonicalize /ab/../xy/ -> /xy/
    }

    if ($filename !~ m|^\.\./\.\./|) {
        $filename =~ s|^([^/]+)/\.\./||g;      # canonicalize ab/../xy/ -> xy/
    }

    if ($filename !~ m|/\.\./\.\.[/]*$|) {
        $filename =~ s|/([^/]+)/\.\.[/]*$||g;  # canonicalize /ab/../xy -> /xy
    }

    return ($filename);
}


#   xfts -- eXtended FileTraverSe 
#   This is a modified version of the dodir() function found
#   in ``The Camel Book'' on page 56/57. This version collects
#   all files in a list instead of printing them directly. 
#   It is also sorts each subtree and has the startup bug fixed.
#   It also does a chdir() to the PWD which was active when called
#   and handles the "//<n>" notation and it canonicalises
#   the initial dir name.
#
#   <path>      only the contents of <path>, no subdir recusion
#   <path>/     only the contents of <path>, no subdir recusion
#   <path>//0   same as <path> or <path>/
#   <path>//<N> only the contents of <path> and the contents of
#               all subdirs <N> subdir-steps deep.
#   <path>//    all under path (recursive)
#
#   This functions uses two optimization tricks:
#   1. dirs without real subdirs are scanned very quick due to
#      comparison with its nlink attribute.
#   2. we traverse via chdir to each subtree relatively to avoid
#      full pathname expansion by the UNIX system.
#
#   SYNOPSIS: @filelist = &file::xfts($dirpath);
#
sub xfts {
    my ($dir, $nlink, $depth) = @_;
    my ($dev, $ino, $mode, $subcount);
    my (@flist, $name);
    my ($pwd);

    #   initialize at startup
    if ($nlink == 0) {
        #   handle //<N> notation
        chop($dir) if ($dir =~ /\n$/);        # remove newline terminator
        if ($dir =~ m|(.*)//(\d*)$|) {
            ($dir, $depth) = ($1, $2 eq '' ? -1 : $2); 
        }
        else {
            $depth = 0;
        }

        #   canonicalise remaining dirname
        $dir =~ s|/$||g;                      # strip useless slash at end
        $dir =~ s|//|/|g;                     # strip unneeded slahes even
        $dir =~ s|//|/|g;                     # strip unneeded slahes odd
        $dir =~ s|/\./|/|g;                   # canonicalize /ab/./xy/ -> ab/xy
        $dir =~ s|/([^/]+)/\.\./|/|g;         # canonicalize /ab/../xy/ -> /xy/

        #   determine current working directory
        #   taken from pwd.pl:initpwd()
        #   it is not needed to set it here for this process,
        #   but if xfts() is called again, a correct $ENV{'PWD'}
        #   will speed up a little bit.
        if ($ENV{'PWD'}) {
            local($dd,$di) = stat('.');
            local($pd,$pi) = stat($ENV{'PWD'});
            if ($di != $pi || $dd != $pd) {
                chop($ENV{'PWD'} = `pwd`);
            }
        }
        else {
            chop($ENV{'PWD'} = `pwd`);
        }

        #   remember the CWD
        $pwd = $ENV{'PWD'};
        #   change to the root-dir which should be examined
        #   and initialize the nlink variable
        chdir($dir) || die "$dir: Can't chdir to this directory\n";
        ($dev, $ino, $mode, $nlink) = stat('.');
    }

    #   read all filenames in sorted order
    opendir(DIRFP, '.') || die("$dir: $!\n");
    local(@filenames) = sort(readdir(DIRFP));
    closedir(DIRFP);

    #   step through the files... 
    @flist = ();
    if ($nlink == 2) {
        #   optimization: a directory with no real subdirs has only
        #   two directories (nlinks == 2): dot and dotdot!
        for (@filenames) {
            next if $_ eq '.';    # skip dot
            next if $_ eq '..';   # skip dotdot
            push(@flist, "$dir/$_");
        }
    }
    else {
        #   there are real subdirs...
        $subcount = $nlink - 2;
        for (@filenames) {
            next if $_ eq '.';    # skip dot
            next if $_ eq '..';   # skip dotdot
            $name = "$dir/$_";
            push(@flist, $name);

            next if $subcount == 0;   # no more subdirs

            ($dev, $ino, $mode, $nlink) = lstat($_);
            next unless -d _;     # use _ to use Perls internal knowledge

            if ($depth > 0 || $depth == -1) {
                #   change to directory and recurse into it
                chdir($_) || die "$_: Can't chdir to this directory\n";
            push(@flist, &xfts($name, $nlink, $depth - 1)) if ($depth >= 0);
            push(@flist, &xfts($name, $nlink, -1))         if ($depth == -1);
                chdir('..');
            }

            --$subcount;
        }
    }

    #    change back to the original CWD which was
    #    active when this function was called by the user
    #    this is not executed if this is a recursive call!
    chdir($pwd) if ($pwd ne '');
    
    #    return the file list
    return(@flist);
}
   
package main;
1;

#EOF#
