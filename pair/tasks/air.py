# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@since: 1.0.0
"""

from pair.tasks import Runtime

class AIRApplication(object):
    """
    """
    def __init__(self, appid=None, title=None):
        self.appid = appid
        self.title = title
        self.name = None
        self.description = None
        self.systemchrome = None
        self.transparent = False
        self.visible = True
        self.installfolder = None
        self.maximizable = True
        self.minimizable = True
        self.resizable = False
        self.width = None
        self.height = None
        self.minsize = None
        self.maxsize = None
        self.x = None
        self.y = None
        
    def __repr__(self):
        r = "<AIRApplication appid=%s title=%s/>" % (
            self.appid, self.title)
        
        return r

class AIRSource(object):
    """
    """
    def __init__(self, base=None, swf=None, source=None):
        self.base = base
        self.swf = swf
        self.source = source
        self.libraries = None
        self.entry = None
        self.locale = None
        
    def __repr__(self):
        r = "<AIRSource base=%s swf=%s/>" % (
            self.base, self.swf)
        
        return r

class AIRCompiler(object):
    """
    """
    def __init__(self, home=None, libraries=None):
        self.home = home
        self.libraries = libraries
        self.config = None
        self.ant = None
        self.asdoc = None
        self.benchmark = True
        self.network = True
        
    def __repr__(self):
        r = "<AIRCompiler home=%s/>" % (self.home)
        
        return r

class AIRDocs(object):
    """
    """
    def __init__(self, output=None, windowtitle=None):
        self.output = output
        self.windowtitle = windowtitle
        self.domains = None
        self.template = None
        self.framewidth = None
        self.maintitle = None
        self.footer = None
        
    def __repr__(self):
        r = "<AIRDocs output=%s windowtitle=%s/>" % (
            self.output, self.windowtitle)
        
        return r

class AIRIcons(object):
    """
    """
    def __init__(self, folder=None):
        self.folder = folder
        self.icon16x16 = None
        self.icon32x32 = None
        self.icon48x48 = None
        self.icon128x128 = None
                
    def __repr__(self):
        r = "<AIRIcons folder=%s/>" % (
            self.folder)
        
        return r

class AIRRuntime(Runtime):
    """
    """
    def __init__(self, name='Adobe Integrated Runtime', version='1.0.M6'):
        self.name = name
        self.version = version
        self.base = None
        self.packager = None
        self.debugger = None
                        
    def __repr__(self):
        r = "<AIRRuntime version=%s/>" % (
            self.version)
        
        return r

class AIRCertificate(object):
    """
    """
    def __init__(self, name=None, type=None):
        self.name = name
        self.type = type
        self.file = None
        self.password = None
                
    def __repr__(self):
        r = "<AIRCertificate name=%s type=%s/>" % (
            self.name, self.type)
        
        return r
