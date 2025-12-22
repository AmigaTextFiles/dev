#!/usr/bin/perl
#
# genuser: Generate username:password entries for AuthUserFile style
#          databases.
#
# Author:  MacGyver aka Habeeb J. Dihu <macgyver@tos.net>
#
# Copyright (C) 1999, MacGyver aka Habeeb J. Dihu <macgyver@tos.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307, USA.
#

use Carp;

croak "Usage: $0 <user> <password>\n" unless $#ARGV == 1;

# Random salt.
$salt = join '', ('.', '/', 0..9, 'A'..'Z', 'a'..'z')[rand 64, rand 64];

print $ARGV[0], ':', crypt($ARGV[1], $salt), "\n";
