#!/usr/bin/env python
#
# Copyright (c) 2007 The Pair Project. All rights reserved.
# See LICENSE for details.

'''
Windows installer boot script.

Executed inside the NSIS installer with the NSIS-Python plugin
using an embedded Python 2.3 DLL.

This script handles the installation and starts an AMF Remoting
gateway for the AIR application.

@author: U{Thijs Triemstra<mailto:info@collab.nl>}
@since: 1.0.0
'''

import sys

import pair
from pair import util

# Platform support for Windows
if sys.platform[:3] == 'win':
    
    try:
        import nsis
        nsis.log(platform)
        
    except ImportError:
        pass

if __name__ == '__main__':
    print "Pair %s for Windows" % (pair.__version__)
