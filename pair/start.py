# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

import os, sys, stat, re, time

import pair

from twisted.python import usage, util

class MakerBase(usage.Options):
    """
    """
    optFlags = [
        ['help', 'h', "Display this message"],
        ["quiet", "q", "Do not emit the commands being run"],
    ]

    opt_h = usage.Options.opt_help

    def opt_version(self):
        print "Pair version:", Options.pair_version
        print "PyAMF version:", Options.pyamf_version
        
        usage.Options.opt_version(self)
        
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

class EnvironmentOptions(MakerBase):
    """
    Create a new project environment.
    """
    optFlags = [
        ["force", "f",
         "Re-use an existing directory (will not overwrite project.cfg file)"],
    ]
    
    optParameters = [
        ["config", "c", "project.cfg", "Name of the project config file"],
    ]
    
    def getSynopsis(self):
        return "Usage:    pair initenv [options] <basedir>"

    longdesc = """
    This command creates a project development environment. The project will
    live in <basedir> and create various files there.

    At runtime, the project will read a configuration file (named
    'project.cfg' by default) in its basedir.
    """
    
class UpgradeOptions(MakerBase):
    """
    """
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

class CleanOptions(MakerBase):
    """
    """
    optFlags = [
        ['quiet', 'q', "Don't display startup log messages"],
    ]
    
    def getSynopsis(self):
        return "Usage:    pair clean <basedir>"

class BuildOptions(MakerBase):
    """
    """
    optFlags = [
        ['quiet', 'q', "Don't display startup log messages"],
    ]

    def getSynopsis(self):
        return "Usage:    pair build <basedir>"

class DistOptions(MakerBase):
    """
    """
    def getSynopsis(self):
        return "Usage:    pair dist <basedir>"

class ReportOptions(MakerBase):
    """
    """
    optFlags = [
        ['quiet', 'q', "Don't display log messages about reconfiguration"],
    ]

    def getSynopsis(self):
        return "Usage:    pair report <basedir>"
  
class Options(usage.Options):
    """
    Option list parser class.
    """
    from pair import __version__ as pair_version
    from pyamf import __version__
    pyamf_version = '%s.%s' % (__version__[0], __version__[1])
        
    synopsis = "Usage:    pair <command> [command options]"

    #: Main options
    subCommands = [
        ['initenv', None, EnvironmentOptions,
         "Create and populate a directory for a new project"],
        
        ['upgrade', None, UpgradeOptions,
         "Upgrade an existing project directory for the current version"],
        
        ['build', None, BuildOptions,
         "Start a project build"],
        
        ['clean', None, CleanOptions,
         "Clean the project build files"],
        
        ['dist', None, DistOptions,
         "Create application installer"],
        
        ['report', None, ReportOptions,
         "Generate project report"],
        
        ['docs', None, ReportOptions,
         "Create project documentation"],
    ]
       
    def opt_version(self):
        print "Pair version:", Options.pair_version
        print "PyAMF version:", Options.pyamf_version
        
        usage.Options.opt_version(self)

    def opt_verbose(self):
        """
        Use verbose logging that adds a timestamp for every line
        """
        from twisted.python import log
        log.startLogging(sys.stderr)

    def postOptions(self):
        """
        Called after the options are parsed, used to validate that
        all options are sane.
        """
        if not hasattr(self, 'subOptions'):
            raise usage.UsageError("must specify a command")

def run():
    """
    Start the Pair commandline tool.
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
        pair.createEnvironment(so)
    elif command == "upgrade":
        pair.upgradeEnvironment(so)
    elif command == "build":
        pair.buildProject(so)
    elif command == "clean":
        pair.cleanProject(so)
    elif command == "dist":
        pair.createDistribution(so)
    elif command == "report":
        pair.createReport(so)
    elif command == "docs":
        pair.createDocs(so)
