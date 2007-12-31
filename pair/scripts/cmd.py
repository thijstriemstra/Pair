import os, sys, stat, re, time

from twisted.python import usage, util, runtime

from buildbot.scripts import runner

class PairMaker(runner.Maker):
   
    def makeTAC(self, contents, secret=False):
        tacfile = "pair.tac"
        if os.path.exists(tacfile):
            oldcontents = open(tacfile, "rt").read()
            if oldcontents == contents:
                if not self.quiet:
                    print tacfile, "already exists and is correct"
                return
            if not self.quiet:
                print "not touching existing", tacfile
                print "creating %s.new instead" % tacfile
            tacfile = "%s.new" % tacfile
        f = open(tacfile, "wt")
        f.write(contents)
        f.close()
        if secret:
            os.chmod(tacfile, 0600)

    def public_html(self, index_html, buildbot_css, robots_txt):
        webdir = os.path.join(self.basedir, "public_html")
        if os.path.exists(webdir):
            if not self.quiet:
                print "public_html/ already exists: not replacing"
            return
        else:
            os.mkdir(webdir)
        if not self.quiet:
            print "populating public_html/"
        target = os.path.join(webdir, "index.html")
        f = open(target, "wt")
        f.write(open(index_html, "rt").read())
        f.close()

        target = os.path.join(webdir, "pair.css")
        f = open(target, "wt")
        f.write(open(buildbot_css, "rt").read())
        f.close()

        target = os.path.join(webdir, "robots.txt")
        f = open(target, "wt")
        f.write(open(robots_txt, "rt").read())
        f.close()

    def upgrade_public_html(self, index_html, buildbot_css, robots_txt):
        webdir = os.path.join(self.basedir, "public_html")
        if not os.path.exists(webdir):
            if not self.quiet:
                print "populating public_html/"
            os.mkdir(webdir)
        self.populate_if_missing(os.path.join(webdir, "index.html"),
                                 index_html)
        self.populate_if_missing(os.path.join(webdir, "pair.css"),
                                 buildbot_css)
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

class UpgradeMasterOptions(runner.UpgradeMasterOptions):

    def getSynopsis(self):
        return "Usage:    pair upgrade-master [options] <basedir>"

    longdesc = """
    This command takes an existing buildmaster working directory and
    adds/modifies the files there to work with the current version of
    buildbot. When this command is finished, the buildmaster directory should
    look much like a brand-new one created by the 'create-master' command.

    Use this after you've upgraded your buildbot installation and before you
    restart the buildmaster to use the new version.

    If you have modified the files in your working directory, this command
    will leave them untouched, but will put the new recommended contents in a
    .new file (for example, if index.html has been modified, this command
    will create index.html.new). You can then look at the new version and
    decide how to merge its contents into your modified file.
    """

def upgradeMaster(config):
    basedir = config['basedir']
    m = PairMaker(config)
    # TODO: check Makefile
    # TODO: check TAC file
    # check web files: index.html, classic.css, robots.txt
    webdir = os.path.join(basedir, "public_html")
    m.upgrade_public_html(util.sibpath(__file__, "../web/index.html"),
                          util.sibpath(__file__, "../web/pair.css"),
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


class MasterOptions(runner.MasterOptions):
    
    def getSynopsis(self):
        return "Usage:    pair create-master [options] <basedir>"

    longdesc = """
    This command creates a buildmaster working directory and pair.tac
    file. The master will live in <dir> and create various files there.

    At runtime, the master will read a configuration file (named
    'master.cfg' by default) in its basedir. This file should contain python
    code which eventually defines a dictionary named 'BuildmasterConfig'.
    The elements of this dictionary are used to configure the Buildmaster."""

masterTAC = """
from twisted.application import service
from buildbot.master import BuildMaster

basedir = r'%(basedir)s'
configfile = r'%(config)s'

application = service.Application('buildmaster')
BuildMaster(basedir, configfile).setServiceParent(application)

"""

def createMaster(config):
    m = PairMaker(config)
    m.mkdir()
    m.chdir()
    contents = masterTAC % config
    m.makeTAC(contents)
    m.sampleconfig(util.sibpath(__file__, "sample.cfg"))
    m.public_html(util.sibpath(__file__, "../web/index.html"),
                  util.sibpath(__file__, "../web/classic.css"),
                  util.sibpath(__file__, "../web/robots.txt"),
                  )

    if not m.quiet: print "buildmaster configured in %s" % m.basedir

class SlaveOptions(runner.SlaveOptions):
    
    longdesc = """
    This command creates a buildslave working directory and pair.tac
    file. The bot will use the <name> and <passwd> arguments to authenticate
    itself when connecting to the master. All commands are run in a
    build-specific subdirectory of <basedir>. <master> is a string of the
    form 'hostname:port', and specifies where the buildmaster can be reached.

    <name>, <passwd>, and <master> will be provided by the buildmaster
    administrator for your bot. You must choose <basedir> yourself.
    """

    def getSynopsis(self):
        return "Usage:    pair create-slave [options] <basedir> <master> <name> <passwd>"

slaveTAC = """
from twisted.application import service
from buildbot.slave.bot import BuildSlave

basedir = r'%(basedir)s'
buildmaster_host = '%(host)s'
port = %(port)d
slavename = '%(name)s'
passwd = '%(passwd)s'
keepalive = %(keepalive)d
usepty = %(usepty)d
umask = %(umask)s

application = service.Application('buildslave')
s = BuildSlave(buildmaster_host, port, slavename, passwd, basedir,
               keepalive, usepty, umask=umask)
s.setServiceParent(application)

"""

def createSlave(config):
    m = PairMaker(config)
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

def createProject(conf):
    master = createMaster(conf)
    slave = createSlave(conf)

    if not m.quiet: print "project configured in %s" % master.basedir

def restart(config):
    quiet = config['quiet']
    from buildbot.scripts.startup import start
    stop(config, wait=True)
    if not quiet:
        print "now restarting Pair process.."
    start(config)


def loadOptions(filename="options", here=None, home=None):
    """Find the .pair/FILENAME file. Crawl from the current directory up
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

class StartOptions(runner.MakerBase):
    optFlags = [
        ['quiet', 'q', "Don't display startup log messages"],
        ]
    def getSynopsis(self):
        return "Usage:    pair start <basedir>"

class StopOptions(runner.MakerBase):
    def getSynopsis(self):
        return "Usage:    pair stop <basedir>"

class ReconfigOptions(runner.MakerBase):
    optFlags = [
        ['quiet', 'q', "Don't display log messages about reconfiguration"],
        ]
    def getSynopsis(self):
        return "Usage:    pair reconfig <basedir>"


class RestartOptions(runner.MakerBase):
    optFlags = [
        ['quiet', 'q', "Don't display startup log messages"],
        ]
    def getSynopsis(self):
        return "Usage:    pair restart <basedir>"

class DebugClientOptions(usage.Options):
    optFlags = [
        ['help', 'h', "Display this message"],
        ]
    optParameters = [
        ["master", "m", None,
         "Location of the buildmaster's slaveport (host:port)"],
        ["passwd", "p", None, "Debug password to use"],
        ]

    def parseArgs(self, *args):
        if len(args) > 0:
            self['master'] = args[0]
        if len(args) > 1:
            self['passwd'] = args[1]
        if len(args) > 2:
            raise usage.UsageError("I wasn't expecting so many arguments")

class StatusClientOptions(usage.Options):
    optFlags = [
        ['help', 'h', "Display this message"],
        ]
    optParameters = [
        ["master", "m", None,
         "Location of the buildmaster's status port (host:port)"],
        ]

    def parseArgs(self, *args):
        if len(args) > 0:
            self['master'] = args[0]
        if len(args) > 1:
            raise usage.UsageError("I wasn't expecting so many arguments")

class SendChangeOptions(runner.SendChangeOptions):
    def getSynopsis(self):
        return "Usage:    pair sendchange [options] filenames.."

class ForceOptions(usage.Options):
    optParameters = [
        ["builder", None, None, "which Builder to start"],
        ["branch", None, None, "which branch to build"],
        ["revision", None, None, "which revision to build"],
        ["reason", None, None, "the reason for starting the build"],
        ]

    def parseArgs(self, *args):
        args = list(args)
        if len(args) > 0:
            if self['builder'] is not None:
                raise usage.UsageError("--builder provided in two ways")
            self['builder'] = args.pop(0)
        if len(args) > 0:
            if self['reason'] is not None:
                raise usage.UsageError("--reason provided in two ways")
            self['reason'] = " ".join(args)


class TryOptions(runner.TryOptions):
    
    def getSynopsis(self):
        return "Usage:    pair try [options]"

class TryServerOptions(usage.Options):
    optParameters = [
        ["jobdir", None, None, "the jobdir (maildir) for submitting jobs"],
        ]

class Options(usage.Options):
    import pair

    version = pair.__version__
    synopsis = "Usage:    pair <command> [command options]"

    subCommands = [
        # the following are all admin commands
        ['create-master', None, MasterOptions,
         "Create and populate a directory for a new buildmaster"],
        ['upgrade-master', None, UpgradeMasterOptions,
         "Upgrade an existing buildmaster directory for the current version"],
        ['create-slave', None, SlaveOptions,
         "Create and populate a directory for a new buildslave"],
        ['start', None, StartOptions, "Start a buildmaster or buildslave"],
        ['stop', None, StopOptions, "Stop a buildmaster or buildslave"],
        ['restart', None, RestartOptions,
         "Restart a buildmaster or buildslave"],

        ['reconfig', None, ReconfigOptions,
         "Re-read the config file for a buildmaster"],
        
        ['sendchange', None, SendChangeOptions,
         "Send a change to the buildmaster"],

        ['statuslog', None, StatusClientOptions,
         "Emit current builder status to stdout"],
        
        ['statusgui', None, StatusClientOptions,
         "Display a small window showing current builder status"],

        ['try', None, TryOptions, "Run a build with your local changes"],

        ]

    def opt_version(self):
        print "Pair version: %s" % Options.version
        usage.Options.opt_version(self)

    def opt_verbose(self):
        from twisted.python import log
        log.startLogging(sys.stderr)

    def postOptions(self):
        if not hasattr(self, 'subOptions'):
            raise usage.UsageError("must specify a command")

def run():
    config = Options()
    try:
        config.parseOptions()
    except usage.error, e:
        print "%s:  %s" % (sys.argv[0], e)
        print
        import pair
        print "Pair %s" % Options.version
        print
        c = getattr(config, 'subOptions', config)
        print str(c)
        sys.exit(1)

    command = config.subCommand
    so = config.subOptions

    if command == "create-master":
        createMaster(so)
    elif command == "upgrade-master":
        upgradeMaster(so)
    elif command == "create-slave":
        createSlave(so)
    elif command == "start":
        from buildbot.scripts.startup import start
        start(so)
    elif command == "stop":
        runner.stop(so, wait=True)
    elif command == "restart":
        restart(so)
    elif command == "reconfig":
        from buildbot.scripts.reconfig import Reconfigurator
        Reconfigurator().run(so)
    elif command == "sendchange":
        runner.sendchange(so, True)
    elif command == "statuslog":
        runner.statuslog(so)
    elif command == "statusgui":
        runner.statusgui(so)
    elif command == "try":
        runner.doTry(so)
    elif command == "tryserver":
        runner.doTryServer(so)


