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
"""

import os

from twisted.python import util

__version__ = '1.0.0'

class Maker(object):
    """
    """
    
    def __init__(self, config):
        self.config = config
        self.basedir = config['basedir']
        self.force = config.get('force', False)
        self.quiet = config['quiet']

    def chdir(self):
        """
        Change into base directory.
        """
        if not self.quiet:
            print "Changing to", self.basedir
        os.chdir(self.basedir)
        
    def mkdir(self):
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

    def init_env(self):
        """
        Create and populate a directory for a new project.
        """
        self.sample_config(util.sibpath(__file__, "templates/sample.cfg"))

        self.sample_air(util.sibpath(__file__, "templates/air"))

        self.sample_python(util.sibpath(__file__, "templates/python"))
        
        #util.sibpath(__file__, "templates/html/index.html"),
        #
        #util.sibpath(__file__, "templates/images"),
        #util.sibpath(__file__, "templates/air"),
        #util.sibpath(__file__, "templates/air"),

    def sample_config(self, source):
        """
        Generate sample project configuration file.

        @param source: Path to sample.cfg file.
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
        
    def sample_air(self, source):
        """
        Generate sample AIR source and config files for the new project.

        Includes the CommandProxy ActionScript library.

        @param source: Path to AIR template files.
        @type source: string
        """
        airdir = os.path.join(self.basedir, "air")
        
        if os.path.exists(airdir):
            if not self.quiet:
                print "air/ already exists: not replacing"
            return
        else:
            if not self.quiet:
                print "Populating air/"
            # copy source dir to new airdir
            os.mkdir(airdir)

    def sample_python(self, source):
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

    def sample_install(self, source):
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
            
    def mkinfo(self):
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
        
    def makefile(self):
        target = "Makefile.sample"
        if os.path.exists(target):
            oldcontents = open(target, "rt").read()
            if oldcontents == makefile_sample:
                if not self.quiet:
                    print "Makefile.sample already exists and is correct"
                return
            if not self.quiet:
                print "replacing Makefile.sample"
        else:
            if not self.quiet:
                print "creating Makefile.sample"
        f = open(target, "wt")
        f.write(makefile_sample)
        f.close()

    def populate_if_missing(self, target, source, overwrite=False):
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
            
    def upgrade_public_html(self, index_html, pair_css, dependencies_css, robots_txt):
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

    def check_master_cfg(self):
        from buildbot.master import BuildMaster
        from twisted.python import log, failure

        master_cfg = os.path.join(self.basedir, "master.cfg")
        if not os.path.exists(master_cfg):
            if not self.quiet:
                print "No master.cfg found"
            return 1

        if sys.path[0] != self.basedir:
            sys.path.insert(0, self.basedir)

        m = BuildMaster(self.basedir)
       
        messages = []
        log.addObserver(messages.append)
        try:
            m.loadConfig(open(master_cfg, "r"))
        except:
            f = failure.Failure()
            if not self.quiet:
                print
                for m in messages:
                    print "".join(m['message'])
                print f
                print
                print "An error was detected in the master.cfg file."
                print "Please correct the problem and run 'pair upgrade-master' again."
                print
            return 1
        return 0

def createEnvironment(config):
    """
    Create and populate a directory for a new project.

    @param config:
    @type config:
    """
    m = Maker(config)
    m.mkdir()
    m.chdir()    
    m.init_env()

    if not m.quiet:
        print "Project configured in %s" % m.basedir
    
def upgradeEnvironment(config):
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
    m.populate_if_missing(os.path.join(basedir, "master.cfg.sample"),
                          util.sibpath(__file__, "sample.cfg"),
                          overwrite=True)
    rc = m.check_master_cfg()
    if rc:
        return rc
    if not config['quiet']:
        print "upgrade complete"

def cleanProject(config):
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

    if not m.quiet: print "buildslave configured in %s" % m.basedir
    
def buildProject(config):
    """
    Start a project build.
    
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

    if not m.quiet: print "buildslave configured in %s" % m.basedir
    
def createDistribution(config):
    """
    Create application installer.
    
    @param config:
    @type config:
    """
    quiet = config['quiet']
    from buildbot.scripts.startup import start
    stop(config, wait=True)
    if not quiet:
        print "now restarting Pair process.."
    start(config)

def createReport(config):
    """
    Generate project report.
    
    @param config:
    @type config:
    """
    os.chdir(config['basedir'])
    if not os.path.exists("pair.tac"):
        print "This doesn't look like a Pair base directory:"
        print "No pair.tac file."
        print "Giving up!"
        sys.exit(1)
    if config['quiet']:
        return launch(config)

    # we probably can't do this os.fork under windows
    from twisted.python.runtime import platformType
    if platformType == "win32":
        return launch(config)

    # fork a child to launch the daemon, while the parent process tails the
    # logfile
    if os.fork():
        # this is the parent
        rc = Follower().follow()
        sys.exit(rc)
    # this is the child: give the logfile-watching parent a chance to start
    # watching it before we start the daemon
    time.sleep(0.2)
    launch(config)

def createDocs(config):
    """
    Create project documentation.
    
    @param config:
    @type config:
    """
    sys.path.insert(0, os.path.abspath(os.getcwd()))
    
    # see if we can launch the application without actually having to
    # spawn twistd, since spawning processes correctly is a real hassle
    # on windows.
    from twisted.python.runtime import platformType
    argv = ["twistd",
            "--no_save",
            "--logfile=twistd.log", # windows doesn't use the same default
            "--python=pair.tac"]
    if platformType == "win32":
        argv.append("--reactor=win32")
    sys.argv = argv

    # this is copied from bin/twistd. twisted-2.0.0 through 2.4.0 use
    # _twistw.run . Twisted-2.5.0 and later use twistd.run, even for
    # windows.
    from twisted import __version__
    major, minor, ignored = __version__.split(".", 2)
    major = int(major)
    minor = int(minor)
    if (platformType == "win32" and (major == 2 and minor < 5)):
        from twisted.scripts import _twistw
        run = _twistw.run
    else:
        from twisted.scripts import twistd
        run = twistd.run
    run()

def loadOptions(filename="options", here=None, home=None):
    """
    Find the .pair/FILENAME file. Crawl from the current directory up
    towards the root, and also look in ~/.buildbot . The first directory
    that's owned by the user and has the file we're looking for wins. Windows
    skips the owned-by-user test.
    
    @rtype:  dict
    @return: a dictionary of names defined in the options file. If no options
             file was found, return an empty dict.
    """

    if here is None:
        here = os.getcwd()
    here = os.path.abspath(here)

    if home is None:
        if runtime.platformType == 'win32':
            home = os.path.join(os.environ['APPDATA'], "pair")
        else:
            home = os.path.expanduser("~/.pair")

    searchpath = []
    toomany = 20
    while True:
        searchpath.append(os.path.join(here, ".pair"))
        next = os.path.dirname(here)
        if next == here:
            break # we've hit the root
        here = next
        toomany -= 1 # just in case
        if toomany == 0:
            raise ValueError("Hey, I seem to have wandered up into the "
                             "infinite glories of the heavens. Oops.")
    searchpath.append(home)

    localDict = {}

    for d in searchpath:
        if os.path.isdir(d):
            if runtime.platformType != 'win32':
                if os.stat(d)[stat.ST_UID] != os.getuid():
                    print "skipping %s because you don't own it" % d
                    continue # security, skip other people's directories
            optfile = os.path.join(d, filename)
            if os.path.exists(optfile):
                try:
                    f = open(optfile, "r")
                    options = f.read()
                    exec options in localDict
                except:
                    print "error while reading %s" % optfile
                    raise
                break

    for k in localDict.keys():
        if k.startswith("__"):
            del localDict[k]
    return localDict
