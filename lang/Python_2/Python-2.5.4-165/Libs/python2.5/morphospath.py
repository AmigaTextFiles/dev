################################################################################
### File: morphospath.py
### Author: Guillaume Roguez (aka Yomgui)
### Date (YYYY/MM/DD): 20041213
###
###
### Description:
###
### Common operations on Morphos pathnames.
###
### Note:
###
### Adapted from original posixpath.py
###
###
### History:
###
### Date     | Author       | Desciption of modifications
### ---------|--------------|-------------------------------------------------
### 20041213 | Yomgui       | Initial Release.
### 20041218 | Yomgui       | port of functions: normcase, isabs.
### 20050114 | Yomgui       | AddPart is in _doslib now.
### 20050217 | Yomgui       | FIX: split() was unported.
### 20050221 | Yomgui       | FIX: normcase() does nothing now.
### 20050223 | Yomgui       | FIX: splitdrive() is now right implemented.
### 20050303 | Yomgui       | Move AddPart() from os to os.path
### 20050316 | Yomgui       | FIX: normcase() is s.lower()
### 20050316 | Yomgui       | FIX: ':' is not an alt-separator !
### 20050420 | Yomgui       | defpath is computed from result of command 'Path'
### 20050605 | Yomgui       | FIX: normpath wasn't ported
### 20050717 | Yomgui       | PB: normpath is not correct yet!
### 20061009 | Yomgui       | FIX: join didn't put a '/' at end in some cases.
###
################################################################################
 
"""Common operations on Morphos pathnames.

Instead of importing this module directly, import os and refer to
this module as os.path.  The "os.path" name is an alias for this
module on Morphos systems; on other systems (e.g. Mac, Windows),
os.path provides the same operations in a manner specific to that
platform, and is an alias to another module (e.g. macpath, ntpath).

Some of this can actually be useful on non-Morphos systems too, e.g.
for manipulation of the pathname component of URLs.
"""

import os
import stat
import string
import morphos

__all__ = ["AddPart", "normcase","isabs","join","splitdrive","split","splitext",
           "basename","dirname","commonprefix","getsize","getmtime",
           "getatime","getctime","islink","exists","isdir","isfile","ismount",
           "walk","expanduser","expandvars","normpath","abspath",
           "samefile","sameopenfile","samestat",
           "curdir","pardir","sep","pathsep","defpath","altsep","extsep",
           "devnull","realpath","supports_unicode_filenames"]

AddPart = os.AddPart

# strings representing various path-related bits and pieces
curdir = ''
pardir = '/'
extsep = '.'
sep = '/'
pathsep = ';'
altsep = None
devnull = 'nil:'

# Get default executables paths by calling Path command
f = os.popen('Path')
defpath = pathsep.join(f.readlines()[1:]).replace('\n', '') # pass the first comment line
f.close() 
del f

# Normalize the case of a pathname.  Trivial in Posix, string.lower on Mac.
# On MS-DOS this may also turn slashes into backslashes; however, other
# normalizations (such as optimizing '../' away) are not allowed
# (another function should be defined to do that).

def normcase(s):
    """Normalize case of pathname."""
    return s.lower()


# Return whether a path is absolute.
# Trivial in Posix, harder on the Mac or MS-DOS.

def isabs(s):
    """Test whether a path is absolute"""
    return ':' in s


# Join pathnames.
# Ignore the previous parts if a part is absolute.
# Direct call of Amiga AddPath() function

def join(a, *p):
    """Join two or more pathname components, inserting '/' as needed"""
    path = a
    for b in p:
        path = AddPart(path, b)
    return path


# It's very tricky to split a path with AmigaOS style pathname !
# Because the '/' is used as a path separator but to ask for the parent
# dir too... And we've to handle the alt separator ':' too...
# Not an easy life ;-)
#   Yomgui.

def split(p):
    """Split a pathname. Returns tuple "(head, tail)" where "tail" is
    everything after the final '/' or ':'.  Either part may be empty."""
    try:
        i = p.rindex('/')
        if p[i-1] in ':/':
            i-=1
    except ValueError:
        i = p.rfind(':')
    i+=1
    head, tail = p[:i], p[i:]
    if head and head[-1] == '/':
        try:
            if head[-2] != '/':
                head = head[:-1]
        except IndexError:
            pass
    return head, tail


# Split a path in root and extension.
# The extension is everything starting at the last dot in the last
# pathname component; the root is everything before that.
# It is always true that root + ext == p.

def splitext(p):
    """Split the extension from a pathname.  Extension is everything from the
    last dot to the end.  Returns "(root, ext)", either part may be empty."""
    i = p.rfind('.')
    if i<=p.rfind('/'):
        return p, ''
    else:
        return p[:i], p[i:]


# Split a path in a drive specification (a name followed by ':') and the path specification.
# It is always true that drivespec + pathspec == p
def splitdrive(p):
    """Split a pathname into drive and path specifiers.
    Returns a 2-tuple "(drive,path)";  either part may be empty"""
    i = p.find(':') + 1
    return p[:i], p[i:]

# Return the tail (basename) part of a path.

def basename(p):
    """Returns the final component of a pathname"""
    return split(p)[1]


# Return the head (dirname) part of a path.

def dirname(p):
    """Returns the directory component of a pathname"""
    return split(p)[0]


# Return the longest prefix of all list elements.

def commonprefix(m):
    "Given a list of pathnames, returns the longest common leading component"
    if not m: return ''
    s1 = min(m)
    s2 = max(m)
    n = min(len(s1), len(s2))
    for i in xrange(n):
        if s1[i] != s2[i]:
            return s1[:i]
    return s1[:n]

# Get size, mtime, atime of files.

def getsize(filename):
    """Return the size of a file, reported by os.stat()."""
    return os.stat(filename).st_size

def getmtime(filename):
    """Return the last modification time of a file, reported by os.stat()."""
    return os.stat(filename).st_mtime

def getatime(filename):
    """Return the last access time of a file, reported by os.stat()."""
    return os.stat(filename).st_atime

def getctime(filename):
    """Return the metadata change time of a file, reported by os.stat()."""
    return os.stat(filename).st_ctime

# Is a path a symbolic link?
# This will always return false on systems where os.lstat doesn't exist.

def islink(path):
    """Test whether a path is a symbolic link"""
    try:
        st = os.lstat(path)
    except (os.error, AttributeError):
        return False
    return stat.S_ISLNK(st.st_mode)


# Does a path exist?
# This is false for dangling symbolic links.

def exists(path):
    """Test whether a path exists.  Returns False for broken symbolic links"""
    try:
        st = os.stat(path)
    except os.error:
        return False
    return True


# Being true for dangling symbolic links is also useful.

def lexists(path):
    """Test whether a path exists.  Returns True for broken symbolic links"""
    try:
        st = os.lstat(path)
    except os.error:
        return False
    return True


# Is a path a directory?
# This follows symbolic links, so both islink() and isdir() can be true
# for the same path.

def isdir(path):
    """Test whether a path is a directory"""
    try:
        st = os.stat(path)
    except os.error:
        return False
    return stat.S_ISDIR(st.st_mode)


# Is a path a regular file?
# This follows symbolic links, so both islink() and isfile() can be true
# for the same path.

def isfile(path):
    """Test whether a path is a regular file"""
    try:
        st = os.stat(path)
    except os.error:
        return False
    return stat.S_ISREG(st.st_mode)


# Are two filenames really pointing to the same file?

def samefile(f1, f2):
    """Test whether two pathnames reference the same actual file"""
    s1 = os.stat(f1)
    s2 = os.stat(f2)
    return samestat(s1, s2)


# Are two open files really referencing the same file?
# (Not necessarily the same file descriptor!)

def sameopenfile(fp1, fp2):
    """Test whether two open file objects reference the same file"""
    s1 = os.fstat(fp1)
    s2 = os.fstat(fp2)
    return samestat(s1, s2)


# Are two stat buffers (obtained from stat, fstat or lstat)
# describing the same file?

def samestat(s1, s2):
    """Test whether two stat buffers reference the same file"""
    return s1.st_ino == s2.st_ino and \
           s1.st_dev == s2.st_dev


# Is a path a mount point?
# (Does this work for all UNIXes?  Is it even guaranteed to work by Posix?)

def ismount(path):
    """Test whether a path is a mount point"""
    try:
        s1 = os.stat(path)
        s2 = os.stat(join(path, '..'))
    except os.error:
        return False # It doesn't exist -- so not a mount point :-)
    dev1 = s1.st_dev
    dev2 = s2.st_dev
    if dev1 != dev2:
        return True     # path/.. on a different device as path
    ino1 = s1.st_ino
    ino2 = s2.st_ino
    if ino1 == ino2:
        return True     # path/.. is the same i-node as path
    return False


# Directory tree walk.
# For each directory under top (including top itself, but excluding
# '.' and '..'), func(arg, dirname, filenames) is called, where
# dirname is the name of the directory and filenames is the list
# of files (and subdirectories etc.) in the directory.
# The func may modify the filenames list, to implement a filter,
# or to impose a different order of visiting.

def walk(top, func, arg):
    """Directory tree walk with callback function.

    For each directory in the directory tree rooted at top (including top
    itself, but excluding '.' and '..'), call func(arg, dirname, fnames).
    dirname is the name of the directory, and fnames a list of the names of
    the files and subdirectories in dirname (excluding '.' and '..').  func
    may modify the fnames list in-place (e.g. via del or slice assignment),
    and walk will only recurse into the subdirectories whose names remain in
    fnames; this can be used to implement a filter, or to impose a specific
    order of visiting.  No semantics are defined for, or required of, arg,
    beyond that arg is always passed to func.  It can be used, e.g., to pass
    a filename pattern, or a mutable object designed to accumulate
    statistics.  Passing None for arg is common."""

    try:
        names = os.listdir(top)
    except os.error:
        return
    func(arg, top, names)
    for name in names:
        name = join(top, name)
        try:
            st = os.lstat(name)
        except os.error:
            continue
        if stat.S_ISDIR(st.st_mode):
            walk(name, func, arg)


# Expand paths beginning with '~' or '~user'.
# '~' means $HOME; '~user' means that user's home directory.
# If the path doesn't begin with '~', or if the user or $HOME is unknown,
# the path is returned unchanged (leaving error reporting to whatever
# function is called with the expanded path as argument).
# See also module 'glob' for expansion of *, ? and [...] in pathnames.
# (A function should also be defined to do full *sh-style environment
# variable expansion.)
#
# MorphOS is not a multi-user system based, so default user may or not
# exists... and a HOME var also. So in this case, we fallback on a
# hardcoded directory.
#

def expanduser(path):
    """Expand ~ and ~user constructions.  If user or $HOME is unknown,
    do nothing."""
    if not path.startswith('~'):
        return path
    i = path.find('/', 1)
    if i < 0:
        i = len(path)
    if i == 1:
        if 'HOME' not in os.environ:
            import pwd
            try:
                userhome = pwd.getpwuid(os.getuid()).pw_dir
            except:
                userhome = "PROGDIR:"
        else:
            userhome = os.environ['HOME']
    else:
        import pwd
        try:
            pwent = pwd.getpwnam(path[1:i])
        except KeyError:
            return path
        userhome = pwent.pw_dir
    return join(userhome, path[i:])


# Expand paths containing shell variable substitutions.
# This expands the forms $variable and ${variable} only.
# Non-existent variables are left unchanged.

_varprog = None

def expandvars(path):
    """Expand shell variables of form $var and ${var}.  Unknown variables
    are left unchanged."""
    global _varprog
    if '$' not in path:
        return path
    if not _varprog:
        import re
        _varprog = re.compile(r'\$(\w+|\{[^}]*\})')
    i = 0
    while True:
        m = _varprog.search(path, i)
        if not m:
            break
        i, j = m.span(0)
        name = m.group(1)
        if name.startswith('{') and name.endswith('}'):
            name = name[1:-1]
        if name in os.environ:
            tail = path[j:]
            path = path[:i] + os.environ[name]
            i = len(path)
            path += tail
        else:
            i = j
    return path


# Normalize a path, e.g. A/foo//B becomes A/B and A/ become A.
# It should be understood that this may change the meaning of the path
# if it contains symbolic links!

# [YOMGUI]: May it be more optimized ?
# [YOMGUI]: Implementation is wrong for multiple ending '/': like 'A//'

def normpath(path):
    """Normalize path, eliminating double slashes, etc."""
    drive, path = os.path.splitdrive(path)
    elem = path.split('/')
    path = []

    # remove trailing '/' in 'foo/'
    try:
        if not elem[-1]:
            elem.pop()
    except IndexError:
        pass

    for node in elem:
        if not node:
            if path and (path[-1] != ''):
                path.pop()
            else:
                path.append('')
        else:
            path.append(node)

    return drive+'/'.join(path)

def abspath(path):
    """Return an absolute path."""
    if not isabs(path):
        path = join(os.getcwd(), path)
    return normpath(path)


# Return a canonical path (i.e. the absolute location of a file on the
# filesystem).

def realpath(filename):
    """Return the canonical path of the specified filename, eliminating any
symbolic links encountered in the path."""
    if isabs(filename):
        devl = filename.find(':')
        bits = [ filename[:devl+1] ] + filename[devl+1:].split('/')
    else:
        bits = filename.split('/')

    for i in range(2, len(bits)+1):
        component = join(*bits[0:i])
        # Resolve symbolic links.
        if islink(component):
            resolved = _resolve_link(component)
            if resolved is None:
                # Infinite loop -- return original component + rest of the path
                return abspath(join(*([component] + bits[i:])))
            else:
                newpath = join(*([resolved] + bits[i:]))
                return realpath(newpath)

    return abspath(filename)


def _resolve_link(path):
    """Internal helper function.  Takes a path and follows symlinks
    until we either arrive at something that isn't a symlink, or
    encounter a path we've seen before (meaning that there's a loop).
    """
    paths_seen = []
    while islink(path):
        if path in paths_seen:
            # Already seen this path, so we must have a symlink loop
            return None
        paths_seen.append(path)
        # Resolve where the link points to
        resolved = os.readlink(path)
        if not isabs(resolved):
            dir = dirname(path)
            path = normpath(join(dir, resolved))
        else:
            path = normpath(resolved)
    return path

supports_unicode_filenames = False
