# NOTE: Derived from ../../lib/POSIX.pm.  Changes made here will be lost.
package POSIX;

sub getcwd
{
    usage "getcwd()" if @_ != 0;
    chop($cwd = `pwd`);
    $cwd;
}

1;
