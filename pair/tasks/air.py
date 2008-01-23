# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@since: 1.0.0
"""

class AIRSource(object):
    """
    """
    def __init__(self, base_dir=None, swf_name=None, source=None):
        self.base_dir = base_dir
        self.swf_name = swf_name
        self.source = source
        self.libraries = None
        self.entry_point = None
        self.locale_path = None
        
    def __repr__(self):
        r = "<AIRSource base_dir=%s swf_name=%s/>" % (
            self.base_dir, self.swf_name)
        
        return r

class AIRCompiler(object):
    """
    """
    def __init__(self, home=None, libraries=None):
        self.home = home
        self.libraries = libraries
        self.config = None
        self.flex_tasks = None
        self.asdoc = None
        self.benchmark = True
        self.use_network = True
        
    def __repr__(self):
        r = "<AIRCompiler home=%s/>" % (self.home)
        
        return r

class AIRDocs(object):
    """
    """
    def __init__(self, output_dir=None, window_title=None):
        self.output_dir = output_dir
        self.window_title = window_title
        self.domain_extensions = None
        self.template = None
        self.frame_width = 15
        self.main_title = None
        self.footer = None
        
    def __repr__(self):
        r = "<AIRDocs output_dir=%s window_title=%s/>" % (
            self.output_dir, self.window_title)
        
        return r

class AIRApplication(object):
    """
    """
    def __init__(self, id=None, title=None):
        self.id = id
        self.title = title
        self.name = None
        self.description = None
        self.system_chrome = 'standard'
        self.transparent = False
        self.visible = True
        self.installFolder = None
        self.maximizable = True
        self.minimizable = True
        self.resizable = False
        self.width = 500
        self.height = 500
        self.min_size = [250, 250]
        self.max_size = [750, 750]
        self.x = 150
        self.y = 150
        self.icons = None
        
    def __repr__(self):
        r = "<AIRApplication id=%s title=%s/>" % (
            self.id, self.title)
        
        return r

class AIRIcons(object):
    """
    """
    def __init__(self, folder=None):
        self.folder = folder
        self.icon16x16 = title
        self.icon32x32 = None
        self.icon48x48 = None
        self.icon128x128 = None
                
    def __repr__(self):
        r = "<AIRIcons folder=%s/>" % (
            self.folder)
        
        return r

class AIRRuntime(object):
    """
    """
    def __init__(self, version=None):
        self.version = '1.0.M6'
        self.packager = None
        self.debugger = None
        self.windows = None
        self.macosx = None
                
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
