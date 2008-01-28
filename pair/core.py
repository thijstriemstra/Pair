# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

"""
@author: U{Thijs Triemstra<mailto:info@collab.nl>}

@since: 1.0.0
"""

import os, sys

import pair

from sqlalchemy.sql import select, insert, and_

from twisted.python import util

# defined when connected to the database
projects = organizations = build_folders = adapters = runtimes = \
doctools = libraries = None

class CoreService(object):
    """
    Main Pair service.
    """
    def __init__(self, cmd_options):
        """
        @param cmd_options: Commandline options.
        @type cmd_options: L{Options<pair.options.Options>}
        """
        self.config = cmd_options
        self.basedir = cmd_options['basedir']
        self.force = cmd_options.get('force', False)
        self.quiet = cmd_options['quiet']
        self.components = []

    def __repr__(self):
        r = "<CoreService name=%s/>" % (self.name)

    def create(self):
        """
        Create the core database.

         - create core databases
         - detect adapters
        """
        from pair import db
                
        # setup database session
        ses = db.connect(db_cfg)
        
        # create core database
        core = db.create_project(ses)

        # query projects
        for project in ses.query(Project):
            print 'AIR:', project.air
            for app in project.air:
                print 'source:', app.source
                print 'runtimes:', app.runtimes
            print
            print 'Python:', project.python
            for app in project.python:
                print 'source:', app.source
                print 'runtimes:', app.runtimes

        # detect adapters
        
