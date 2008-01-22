# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

import os, sys, stat, re, time

from twisted.python import usage, util, runtime

class MakerBase(usage.Options):
    optFlags = [
        ['help', 'h', "Display this message"],
        ["quiet", "q", "Do not emit the commands being run"],
        ]

    opt_h = usage.Options.opt_help

    def parseArgs(self, *args):
        if len(args) > 0:
            self['basedir'] = args[0]
        else:
            self['basedir'] = None
        if len(args) > 1:
            raise usage.UsageError("I wasn't expecting so many arguments")

    def postOptions(self):
        if self['basedir'] is None:
            raise usage.UsageError("<basedir> parameter is required")
        self['basedir'] = os.path.abspath(self['basedir'])

class UpgradeOptions(MakerBase):
    optFlags = [
        ["replace", "r", "Replace any modified files without confirmation."],
        ]

    def getSynopsis(self):
        return "Usage:    pair upgrade [options] <basedir>"

    longdesc = """
    This command takes an existing project working directory and
    adds/modifies the files there to work with the current version of
    Pair. When this command is finished, the project directory should
    look much like a brand-new one created by the 'initenv' command.
    Use this after you've upgraded your pair installation.

    If you have modified the files in your working directory, this command
    will leave them untouched, but will put the new recommended contents in a
    .new file (for example, if index.html has been modified, this command
    will create index.html.new). You can then look at the new version and
    decide how to merge its contents into your modified file.
    """

class EnvironmentOptions(MakerBase):
    optFlags = [
        ["force", "f",
         "Re-use an existing directory (will not overwrite project.cfg file)"],
        ]
    optParameters = [
        ["config", "c", "project.cfg", "name of the project config file"],
        ]
    def getSynopsis(self):
        return "Usage:    pair initenv [options] <basedir>"

    longdesc = """
    This command creates a project development environment. The project will
    live in <basedir> and create various files there.

    At runtime, the project will read a configuration file (named
    'project.cfg' by default) in its basedir.
    """

class SlaveOptions(MakerBase):
    optFlags = [
        ["force", "f", "Re-use an existing directory"],
        ]
    optParameters = [
#        ["name", "n", None, "Name for this build slave"],
#        ["passwd", "p", None, "Password for this build slave"],
#        ["basedir", "d", ".", "Base directory to use"],
#        ["master", "m", "localhost:8007",
#         "Location of the buildmaster (host:port)"],

        ["keepalive", "k", 600,
         "Interval at which keepalives should be sent (in seconds)"],
        ["usepty", None, 1,
         "(1 or 0) child processes should be run in a pty"],
        ["umask", None, "None",
         "controls permissions of generated files. Use --umask=022 to be world-readable"],
        ]
    
    longdesc = """
    This command creates a buildslave working directory and buildbot.tac
    file. The bot will use the <name> and <passwd> arguments to authenticate
    itself when connecting to the master. All commands are run in a
    build-specific subdirectory of <basedir>. <master> is a string of the
    form 'hostname:port', and specifies where the buildmaster can be reached.

    <name>, <passwd>, and <master> will be provided by the buildmaster
    administrator for your bot. You must choose <basedir> yourself.
    """

    def getSynopsis(self):
        return "Usage:    buildbot create-slave [options] <basedir> <master> <name> <passwd>"

    def parseArgs(self, *args):
        if len(args) < 4:
            raise usage.UsageError("command needs more arguments")
        basedir, master, name, passwd = args
        self['basedir'] = basedir
        self['master'] = master
        self['name'] = name
        self['passwd'] = passwd

    def postOptions(self):
        MakerBase.postOptions(self)
        self['usepty'] = int(self['usepty'])
        self['keepalive'] = int(self['keepalive'])
        if self['master'].find(":") == -1:
            raise usage.UsageError("--master must be in the form host:portnum")

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

class BuildOptions(MakerBase):
    optFlags = [
        ['quiet', 'q', "Don't display startup log messages"],
        ]
    def getSynopsis(self):
        return "Usage:    pair build <basedir>"

class DistOptions(MakerBase):
    def getSynopsis(self):
        return "Usage:    pair dist <basedir>"

class ReportOptions(MakerBase):
    optFlags = [
        ['quiet', 'q', "Don't display log messages about reconfiguration"],
        ]
    def getSynopsis(self):
        return "Usage:    pair report <basedir>"

class CleanOptions(MakerBase):
    optFlags = [
        ['quiet', 'q', "Don't display startup log messages"],
        ]
    def getSynopsis(self):
        return "Usage:    pair clean <basedir>"
   
class Options(usage.Options):
    """
    """
    import pair
    import buildbot
    import pyamf
    
    buildbot_version = buildbot.version
    pair_version = pair.__version__
    pyamf_version = pyamf.__version__[:3]
        
    synopsis = "Usage:    pair <command> [command options]"

    subCommands = [
        ['initenv', None, EnvironmentOptions,
         "Create and populate a directory for a new project"],
        ['upgrade', None, UpgradeOptions,
         "Upgrade an existing project directory for the current version"],
        ['build', None, BuildOptions,
         "Start a project build"],
        ['clean', None, CleanOptions, "Clean the project build files"],
        ['dist', None, DistOptions, "Create a distribution"],
        ['report', None, ReportOptions,
         "Create project report"],
        ['docs', None, ReportOptions,
         "Create project documentation"],
    ]

    def opt_version(self):
        print "Pair version:", Options.pair_version
        print "PyAMF version:", Options.pyamf_version
        print "Buildbot version:", Options.buildbot_version
        usage.Options.opt_version(self)

    def opt_verbose(self):
        from twisted.python import log
        log.startLogging(sys.stderr)

    def postOptions(self):
        if not hasattr(self, 'subOptions'):
            raise usage.UsageError("must specify a command")

def run():
    """
    """
    config = Options()
    try:
        config.parseOptions()
    except usage.error, e:
        print "%s:  %s" % (sys.argv[0], e)
        print
        print "Pair %s" % Options.pair_version
        print
        c = getattr(config, 'subOptions', config)
        print str(c)
        sys.exit(1)

    command = config.subCommand
    so = config.subOptions
    
    if command == "initenv":
        createEnvironment(so)
    elif command == "upgrade":
        upgradeEnvironment(so)
    elif command == "build":
        buildProject(so)
    elif command == "clean":
        print command
    elif command == "dist":
        print command
    elif command == "report":
        print command
    elif command == "docs":
        print command
