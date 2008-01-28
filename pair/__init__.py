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

from pair.options import PairOptions
from pair.core import CoreService, ProjectService

from twisted.python import util

class Project(object):
    """
    Project.
    """
    def __init__(self, name=None, description=None, language='en'):
        self.name = name
        self.description = description
        self.language = language
        self.version = None
        self.url = None
        self.copyright = None
        self.license = None
        
    def __repr__(self):
        r = "<Project name='%s'/>" % (self.name)
        
        return r

class Organization(object):
    """
    Project organization info.
    """
    def __init__(self, name=None, unit=None, country=None):
        self.name = name
        self.unit = unit
        self.country = country
        self.email = None
        
    def __repr__(self):
        r = "<Organization name=%s unit=%s/>" % (
            self.name, self.unit)
        
        return r

class BuildFolders(object):
    """
    Build folders for project.
    """
    def __init__(self, base=None, build=None, image=None):
        self.base = base
        self.build = build
        self.image = image
        self.dist = None
        self.report = None
        
    def __repr__(self):
        r = "<BuildFolders base=%s build=%s/>" % (
            self.base, self.build)
        
        return r

class Runtime(object):
    """
    Base runtime.
    """
    def __init__(self, name=None, version=None):
        self.name = name
        self.version = version
        self.macosx = None
        self.windows = None
        
    def __repr__(self):
        r = "<Runtime name=%s version=%s/>" % (
            self.name, self.version)
        
        return r

    def install(self):
        """
        Install the runtime.
        """
        
    def uninstall(self):
        """
        Uninstall the runtime.
        """

def run():
    """
    Run the Pair commandline tool.
    """
    from twisted.python import usage
    
    config = PairOptions()
    
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

    # 1. start core:
    # - create core databases
    # - detect adapters
    core = CoreService(so)
    core.start()

    # 2. create project
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
