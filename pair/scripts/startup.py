
import os, sys, time

from buildbot.scripts.startup import Follower

def start(config):
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

def launch(config):
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

