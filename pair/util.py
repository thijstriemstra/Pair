# Copyright (c) 2007-2008 The Pair Project. All rights reserved.
# See LICENSE for details.

'''
Utilities for:

 - opening files or URLs in the registered default application
 - Windows Registry I/0
 - getting system/language/user dependent paths on Windows
 - transforming XML to Python data structure
 
@see: Based on U{Python Recipe 511443
<http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/511443>}
@see: Based on U{Python Recipe 476229
<http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/476229>}
@see: Based on U{Python Recipe 473846
<http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/473846>}
@see: Based on U{Python Recipe 534109
<http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/534109>}
'''

__all__ = ['open', 'xml2obj']

import os, sys, re
import webbrowser
import subprocess
import xml.sax.handler

_controllers = {}
_open = None

class BaseController(object):
    '''
    Base class for open program controllers.
    '''

    def __init__(self, name):
        self.name = name

    def open(self, filename):
        raise NotImplementedError

class Controller(BaseController):
    '''
    Controller for a generic open program.
    '''

    def __init__(self, *args):
        super(Controller, self).__init__(os.path.basename(args[0]))
        self.args = list(args)

    def _invoke(self, cmdline):
        if sys.platform[:3] == 'win':
            closefds = False
            startupinfo = subprocess.STARTUPINFO()
            startupinfo.dwFlags |= subprocess.STARTF_USESHOWWINDOW
        else:
            closefds = True
            startupinfo = None

        if (os.environ.get('DISPLAY') or sys.platform[:3] == 'win' or
                                                    sys.platform == 'darwin'):
            inout = file(os.devnull, 'r+')
        else:
            # for TTY programs, we need stdin/out
            inout = None

        # if possible, put the child precess in separate process group,
        # so keyboard interrupts don't affect child precess as well as
        # Python
        setsid = getattr(os, 'setsid', None)
        if not setsid:
            setsid = getattr(os, 'setpgrp', None)

        pipe = subprocess.Popen(cmdline, stdin=inout, stdout=inout,
                                stderr=inout, close_fds=closefds,
                                preexec_fn=setsid, startupinfo=startupinfo)

        # It is assumed that this kind of tools (gnome-open, kfmclient,
        # exo-open, xdg-open and open for OSX) immediately exit after lauching
        # the specific application
        returncode = pipe.wait()
        if hasattr(self, 'fixreturncode'):
            returncode = self.fixreturncode(returncode)
        return not returncode

    def open(self, filename):
        if isinstance(filename, basestring):
            cmdline = self.args + [filename]
        else:
            # assume it is a sequence
            cmdline = self.args + filename
        try:
            return self._invoke(cmdline)
        except OSError:
            return False

# Platform support for Windows
if sys.platform[:3] == 'win':

    class Start(BaseController):
        '''Controller for the win32 start progam through os.startfile.'''

        def open(self, filename):
            try:
                os.startfile(filename)
            except WindowsError:
                # [Error 22] No application is associated with the specified
                # file for this operation: '<URL>'
                return False
            else:
                return True

    _controllers['windows-default'] = Start
    _open = _controllers['windows-default'].open


# Platform support for MacOS
elif sys.platform == 'darwin':
    _controllers['open']= Controller('open')
    _open = _controllers['open'].open


# Platform support for Unix
else:

    import commands

    # @WARNING: use the private API of the webbrowser module
    from webbrowser import _iscommand

    class KfmClient(Controller):
        '''Controller for the KDE kfmclient program.'''

        def __init__(self, kfmclient='kfmclient'):
            super(KfmClient, self).__init__(kfmclient, 'exec')
            self.kde_version = self.detect_kde_version()

        def detect_kde_version(self):
            kde_version = None
            try:
                info = commands.getoutput('kde-config --version')

                for line in info.splitlines():
                    if line.startswith('KDE'):
                        kde_version = line.split(':')[-1].strip()
                        break
            except (OSError, RuntimeError):
                pass

            return kde_version

        def fixreturncode(self, returncode):
            if returncode is not None and self.kde_version > '3.5.4':
                return returncode
            else:
                return os.EX_OK

    def detect_desktop_environment():
        '''Checks for known desktop environments

        Return the desktop environments name, lowercase (kde, gnome, xfce)
        or "generic"

        '''

        desktop_environment = 'generic'

        if os.environ.get('KDE_FULL_SESSION') == 'true':
            desktop_environment = 'kde'
        elif os.environ.get('GNOME_DESKTOP_SESSION_ID'):
            desktop_environment = 'gnome'
        else:
            try:
                info = commands.getoutput('xprop -root _DT_SAVE_MODE')
                if ' = "xfce4"' in info:
                    desktop_environment = 'xfce'
            except (OSError, RuntimeError):
                pass

        return desktop_environment


    def register_X_controllers():
        if _iscommand('kfmclient'):
            _controllers['kde-open'] = KfmClient()

        for command in ('gnome-open', 'exo-open', 'xdg-open'):
            if _iscommand(command):
                _controllers[command] = Controller(command)

    def get():
        controllers_map = { \
            'gnome': 'gnome-open',
            'kde': 'kde-open',
            'xfce': 'exo-open',
        }

        desktop_environment = detect_desktop_environment()

        try:
            controller_name = controllers_map[desktop_environment]
            return _controllers[controller_name].open

        except KeyError:
            if _controllers.has_key('xdg-open'):
                return _controllers['xdg-open'].open
            else:
                return webbrowser.open


    if os.environ.get("DISPLAY"):
        register_X_controllers()
    _open = get()


def open(filename):
    '''Open a file or an URL in the registered default application.'''

    return _open(filename)

def xml2obj(src):
    """
    A simple function to converts XML data into native Python object.
    """

    non_id_char = re.compile('[^_0-9a-zA-Z]')
    def _name_mangle(name):
        return non_id_char.sub('_', name)

    class DataNode(object):
        def __init__(self):
            self._attrs = {}    # XML attributes and child elements
            self.data = None    # child text data
        def __len__(self):
            # treat single element as a list of 1
            return 1
        def __getitem__(self, key):
            if isinstance(key, basestring):
                return self._attrs.get(key,None)
            else:
                return [self][key]
        def __contains__(self, name):
            return self._attrs.has_key(name)
        def __nonzero__(self):
            return bool(self._attrs or self.data)
        def __getattr__(self, name):
            if name.startswith('__'):
                # need to do this for Python special methods???
                raise AttributeError(name)
            return self._attrs.get(name,None)
        def _add_xml_attr(self, name, value):
            if name in self._attrs:
                # multiple attribute of the same name are represented by a list
                children = self._attrs[name]
                if not isinstance(children, list):
                    children = [children]
                    self._attrs[name] = children
                children.append(value)
            else:
                self._attrs[name] = value
        def __str__(self):
            return self.data or ''
        def __repr__(self):
            items = sorted(self._attrs.items())
            if self.data:
                items.append(('data', self.data))
            return u'{%s}' % ', '.join([u'%s:%s' % (k,repr(v)) for k,v in items])

    class TreeBuilder(xml.sax.handler.ContentHandler):
        def __init__(self):
            self.stack = []
            self.root = DataNode()
            self.current = self.root
            self.text_parts = []
        def startElement(self, name, attrs):
            self.stack.append((self.current, self.text_parts))
            self.current = DataNode()
            self.text_parts = []
            # xml attributes --> python attributes
            for k, v in attrs.items():
                self.current._add_xml_attr(_name_mangle(k), v)
        def endElement(self, name):
            text = ''.join(self.text_parts).strip()
            if text:
                self.current.data = text
            if self.current._attrs:
                obj = self.current
            else:
                # a text only node is simply represented by the string
                obj = text or ''
            self.current, self.text_parts = self.stack.pop()
            self.current._add_xml_attr(_name_mangle(name), obj)
        def characters(self, content):
            self.text_parts.append(content)

    builder = TreeBuilder()
    if isinstance(src,basestring):
        xml.sax.parseString(src, builder)
    else:
        xml.sax.parse(src, builder)
    return builder.root._attrs.values()[0]

if __name__ == '__main__':
    from optparse import OptionParser
    
    version = '%%prog %s' % __version__
    usage = (
        '\n\n%prog FILENAME [FILENAME(s)] -- for opening files'
    )

    parser = OptionParser(usage=usage, version=version, description=__doc__)
    
    (options, args) = parser.parse_args()

    if not args:
        parser.print_usage()
        parser.exit(1)
        
    for arg in args:
        if not util.open(arg):
            print 'Unable to open "%s"' % arg
        else:
            success = True
    sys.exit(success)
