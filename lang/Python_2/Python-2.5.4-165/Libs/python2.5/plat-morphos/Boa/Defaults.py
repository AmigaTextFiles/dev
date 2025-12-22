# -*- coding: iso-8859-15 -*-
#
# File:     Defaults.py
#
# Author:   Guillaume ROGUEZ <yomgui1@gmail.com>
# Creation date:            2005/06/16
# Last modification date:   2005/06/17
#

import os, time
from Boa.Environment import *
from Boa.Utils import toposix

__all__ = [ 'DefaultEnv' ]

defaults = {'root': '.',
            'dryrun': False,
            'verbose': False,
            'quiet': False,
            'ref_time': int(time.time()),
            'builddir': toposix(os.getcwd())}

class DefaultEnv(Environment):
    def __init__(self, **kw):
        Environment.__init__(self, defaults, **kw)
