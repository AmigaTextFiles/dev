# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub fscanf {
    unimpl "fscanf() is C-specific--use <> and regular expressions instead";
}

1;
