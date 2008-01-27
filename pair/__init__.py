# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
Pair: Python for the Adobe Integrated Runtime (AIR).

@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@copyright: Copyright (c) 2007-2008 The Pair Project. All rights reserved.
@contact: U{pair@collab.eu<mailto:pair@collab.eu>}
@see: U{http://pair.collab.eu}

@since: July 2007
@status: Pre-Alpha
@version: 1.0.0
"""

__version__ = '1.0.0'

import sys

from pair import options
from pair.services.core import ProjectService

from twisted.python import util

def run():
    """
    Run the Pair commandline tool.
    """
    from twisted.python import usage
    
    config = options.Options()
    
    try:
        config.parseOptions()
    except usage.error, e:
        print "%s:  %s" % (sys.argv[0], e)
        print
        print "Pair %s" % config.pair_version
        print
        c = getattr(config, 'subOptions', config)
        print str(c)
        sys.exit(1)

    command = config.subCommand
    so = config.subOptions

    project = ProjectService(so)
    
    if command == "initenv":
        project.init(util.sibpath(__file__, 'templates/settings.cfg'))
        
    elif command == "upgrade":
        project.upgrade(so)
        
    elif command == "build":
        project.build(so)
        
    elif command == "clean":
        project.clean(so)
        
    elif command == "dist":
        project.dist(so)
        
    elif command == "report":
        project.report(so)
        
    elif command == "docs":
        project.docs(so)
