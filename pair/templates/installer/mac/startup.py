#!/usr/bin/env python
#
# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

'''
Mac OS X installation boot script.

py2app Mac OS X application using Apple's Python 2.3.

This script handles the installation and starts an AMF Remoting
gateway for the AIR application.

@author: U{Thijs Triemstra<mailto:info@collab.nl>}
@since: 1.0.0
'''

import sys

import pair
from pair import util

# Platform support for Mac OSX
if sys.platform == 'darwin':
    platform = "Mac OSX"
    
if __name__ == '__main__':
    print "Pair %s for Mac OS X" % (pair.__version__)
