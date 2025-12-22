# ====================================================================
# Copyright (c) 2000 by Soheil Seyfaie. All rights reserved.
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
# ====================================================================

# $Author: soheil $
# $Id: Movie.pm,v 1.1 2001/08/06 20:44:39 soheil Exp $

package SWF::Movie;
use SWF();

use strict;

sub streamMp3{
    my $movie = shift;
    my $filename = shift;
    $movie->setSoundStream(new SWF::Sound($filename));
}


1;
