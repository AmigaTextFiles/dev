OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'	->guessed
MODULE 'target/x86_64-linux-gnu/bits/types/struct_statx_timestamp'	->guessed
->{#include <x86_64-linux-gnu/bits/types/struct_statx.h>}
/* Definition of the generic version of struct statx.
   Copyright (C) 2018-2020 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <https://www.gnu.org/licenses/>.  */

->NATIVE {__statx_defined} CONST __STATX_DEFINED = 1

/* Warning: The kernel may add additional fields to this struct in the
   future.  Only use this struct for calling the statx function, not
   for storing data.  (Expansion will be controlled by the mask
   argument of the statx function.)  */
NATIVE {statx} OBJECT statx
  {stx_mask}	mask	:UINT32_T__
  {stx_blksize}	blksize	:UINT32_T__
  {stx_attributes}	attributes	:UINT64_T__
  {stx_nlink}	nlink	:UINT32_T__
  {stx_uid}	uid	:UINT32_T__
  {stx_gid}	gid	:UINT32_T__
  {stx_mode}	mode	:UINT16_T__
->  {__statx_pad1}	__statx_pad1	:ARRAY OF UINT16_T__
  {stx_ino}	ino	:UINT64_T__
  {stx_size}	size	:UINT64_T__
  {stx_blocks}	blocks	:UINT64_T__
  {stx_attributes_mask}	attributes_mask	:UINT64_T__
  {stx_atime}	atime	:statx_timestamp
  {stx_btime}	btime	:statx_timestamp
  {stx_ctime}	ctime	:statx_timestamp
  {stx_mtime}	mtime	:statx_timestamp
  {stx_rdev_major}	rdev_major	:UINT32_T__
  {stx_rdev_minor}	rdev_minor	:UINT32_T__
  {stx_dev_major}	dev_major	:UINT32_T__
  {stx_dev_minor}	dev_minor	:UINT32_T__
->  {__statx_pad2}	__statx_pad2[14]	:ARRAY OF UINT64_T__
ENDOBJECT
