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
        
        self._mkdir()
        self._chdir()

        self._sample_config(util.sibpath(__file__, '../templates/sample.cfg'))
        self._sample_air(util.sibpath(__file__, '../templates/air'))
        self._sample_python(util.sibpath(__file__, '../templates/python'))
        
        if not self.quiet:
            print "Project configured in %s" % self.basedir
            
class ProjectService(object):
    """
    Base class for an environment.
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
        r = "<ProjectService name=%s/>" % (self.name)

    def init(self, db_cfg):
        """
        Create a new project L{environment<pair.Environment>}.
        """
        from pair import db
                
        # setup database connection
        ses = db.connect(db_cfg)
        
        # create project
        proj = db.create_project(ses)

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
        
        self._mkdir()
        self._chdir()

        self._sample_config(util.sibpath(__file__, '../templates/sample.cfg'))
        self._sample_air(util.sibpath(__file__, '../templates/air'))
        self._sample_python(util.sibpath(__file__, '../templates/python'))
        
        if not self.quiet:
            print "Project configured in %s" % self.basedir

    def upgrade(self):
        """
        Upgrade an existing project directory for the current version.
        
        @param config:
        @type config:
        """
        basedir = config['basedir']
        m = Maker(config)
        # check web files
        webdir = os.path.join(basedir, "public_html")
        m.upgrade_public_html(util.sibpath(__file__, "../web/index.html"),
                              util.sibpath(__file__, "../web/css/pair.css"),
                              util.sibpath(__file__, "../web/css/dependencies.css"),
                              util.sibpath(__file__, "../web/robots.txt"),
                              )
        m.populate_if_missing(os.path.join(basedir, "project.cfg.sample"),
                              util.sibpath(__file__, "sample.cfg"),
                              overwrite=True)
        rc = m.check_master_cfg()
        
        if rc:
            return rc
        if not config['quiet']:
            print "Upgrade complete"

    def clean(self):
        """
        Clean the project build files.
        
        @param config:
        @type config:
        """
        m = Maker(config)
        m.mkdir()
        m.chdir()
        
        try:
            master = config['master']
            host, port = re.search(r'(.+):(\d+)', master).groups()
            config['host'] = host
            config['port'] = int(port)
        except:
            print "unparseable master location '%s'" % master
            print " expecting something more like localhost:8007"
            raise
        
        contents = slaveTAC % config

        m.makeTAC(contents, secret=True)

        m.makefile()
        m.mkinfo()

        if not m.quiet:
            print "project configured in %s" % m.basedir

    def build(self):
        """
        Build source.
        
        @param config:
        @type config:
        """
        
    def report(self):
        """
        Generate project report.
        
        @param config:
        @type config:
        """

    def docs(self):
        """
        Create project documentation.
        
        @param config:
        @type config:
        """

    def _chdir(self):
        """
        Change into base directory.
        """
        if not self.quiet:
            print "Changing to", self.basedir
        os.chdir(self.basedir)

    def _mkdir(self):
        """
        Create new base directory, skip if it exists.
        """
        if os.path.exists(self.basedir):
            if not self.quiet:
                print "Updating existing installation"
            return
        
        if not self.quiet:
            print "Creating", self.basedir
            
        os.mkdir(self.basedir)

    def _sample_config(self, source):
        """
        Generate sample project configuration file.

        @param source: Path to sample.conf file.
        @type source: string
        """
        target = "project.cfg.sample"
        config_sample = open(source, "rt").read()
        
        if os.path.exists(target):
            oldcontents = open(target, "rt").read()
            if oldcontents == config_sample:
                if not self.quiet:
                    print "%s already exists and is up-to-date" % target
                return
            if not self.quiet:
                print "Replacing", target
        else:
            if not self.quiet:
                print "Creating", target
        
        f = open(target, "wt")
        f.write(config_sample)
        f.close()
        os.chmod(target, 0600)
        
    def _sample_air(self, source):
        """
        Generate sample AIR source and config files for the new project.

        Includes the CommandProxy ActionScript library.

        @param source: Path to AIR template files.
        @type source: string
        """
        airdir = os.path.join(self.basedir, "air")
        srcdir = os.path.join(self.basedir, "air/src/eu/collab/pair")
        libdir = os.path.join(self.basedir, "air/lib")
        cssdir = os.path.join(self.basedir, "air/resources/css")
        imgdir = os.path.join(self.basedir, "air/resources/images")
        locdir = os.path.join(self.basedir, "air/resources/locale/en_US")
        
        if os.path.exists(airdir):
            if not self.quiet:
                print "air/ already exists: not replacing"
            return
        else:
            if not self.quiet:
                print "Populating air/"
                
            os.makedirs(srcdir)
            os.makedirs(libdir)
            os.makedirs(cssdir)
            os.mkdir(imgdir)
            os.makedirs(locdir)
            
    def _sample_python(self, source):
        """
        Generate sample Python source files for the new project.

        @param source: Path to Python template files.
        @type source: string
        """
        pydir = os.path.join(self.basedir, "python")
        
        if os.path.exists(pydir):
            if not self.quiet:
                print "python/ already exists: not replacing"
            return
        else:
            os.mkdir(pydir)
        if not self.quiet:
            print "Populating python/"

    def _sample_install(self, source):
        """
        Cross-platform installer files (nsis/appinstaller).

        @param source: Path to installer template files.
        @type source: string
        """
        installerdir = os.path.join(self.basedir, "installer")
        
        if os.path.exists(installerdir):
            if not self.quiet:
                print "installer/ already exists: not replacing"
            return
        else:
            os.mkdir(installerdir)
        if not self.quiet:
            print "Populating installer/"
            
    def _mkinfo(self):
        path = os.path.join(self.basedir, "info")
        if not os.path.exists(path):
            if not self.quiet: print "mkdir", path
            os.mkdir(path)
        created = False
        admin = os.path.join(path, "admin")
        if not os.path.exists(admin):
            if not self.quiet:
                print "Creating info/admin, you need to edit it appropriately"
            f = open(admin, "wt")
            f.write("Your Name Here <admin@youraddress.invalid>\n")
            f.close()
            created = True
        host = os.path.join(path, "host")
        if not os.path.exists(host):
            if not self.quiet:
                print "Creating info/host, you need to edit it appropriately"
            f = open(host, "wt")
            f.write("Please put a description of this build host here\n")
            f.close()
            created = True
        if created and not self.quiet:
            print "Please edit the files in %s appropriately." % path

    def _populate_if_missing(self, target, source, overwrite=False):
        new_contents = open(source, "rt").read()
        if os.path.exists(target):
            old_contents = open(target, "rt").read()
            if old_contents != new_contents:
                if overwrite:
                    if not self.quiet:
                        print "%s has old/modified contents" % target
                        print " overwriting it with new contents"
                    open(target, "wt").write(new_contents)
                else:
                    if not self.quiet:
                        print "%s has old/modified contents" % target
                        print " writing new contents to %s.new" % target
                    open(target + ".new", "wt").write(new_contents)
            # otherwise, it's up to date
        else:
            if not self.quiet:
                print "populating %s" % target
            open(target, "wt").write(new_contents)
            
    def _upgrade_public_html(self, index_html, pair_css, dependencies_css, robots_txt):
        """
        """
        webdir = os.path.join(self.basedir, "public_html")
        cssdir = os.path.join(webdir, "css")
        imagesdir = os.path.join(webdir, "images")
        
        if not os.path.exists(webdir):
            if not self.quiet:
                print "populating public_html/"
            os.mkdir(webdir)
            os.mkdir(cssdir)
            os.mkdir(imagesdir)
            
        self.populate_if_missing(os.path.join(webdir, "index.html"),
                                 index_html)
        self.populate_if_missing(os.path.join(cssdir, "pair.css"),
                                 pair_css)
        self.populate_if_missing(os.path.join(cssdir, "dependencies.css"),
                                 dependencies_css)
        self.populate_if_missing(os.path.join(webdir, "robots.txt"),
                                 robots_txt)

    def _check_master_cfg(self):
        from buildbot.master import BuildMaster
        from twisted.python import log, failure

        proj_cfg = os.path.join(self.basedir, "project.cfg")
        if not os.path.exists(proj_cfg):
            if not self.quiet:
                print "No project.conf found"
            return 1

        if sys.path[0] != self.basedir:
            sys.path.insert(0, self.basedir)

        m = BuildMaster(self.basedir)
       
        messages = []
        log.addObserver(messages.append)
        try:
            m.loadConfig(open(proj_cfg, "r"))
        except:
            f = failure.Failure()
            if not self.quiet:
                print
                for m in messages:
                    print "".join(m['message'])
                print f
                print
                print "An error was detected in the project.cfg file."
                print "Please correct the problem and run 'pair upgrade' again."
                print
            return 1
        return 0
