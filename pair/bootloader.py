#!/usr/bin/env python

'''
Cross-platform installation script.

 - Windows: NSIS and NSIS-Python plugin with WAF build script for
            embedded Python 2.3
 - Mac OSX: py2app Mac OSX application, created with WAF build script
            Apple's Python 2.3
 - Unix:    Shell script

The runtime detection scripts is basically a Buildbot master/slave
that starts an AMF Remoting gateway for the AIR application.

This buildbot master/slave will die after the installation is
completed.
'''

__version__ = '1.0.0'

import sys
from pair import util

# Platform support for Windows
if sys.platform[:3] == 'win':
    platform = "Windows"
    try:
        import nsis
        nsis.log(platform)
    except ImportError:
        pass
    
# Platform support for Mac OSX
elif sys.platform == 'darwin':
    platform = "Mac OSX"
    # 

# Platform support for Unix
else:
    platform = "Unix"

if __name__ == '__main__':
    print "Pair %s for %s" % (__version__, platform)
