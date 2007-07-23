"""
    py2app/py2exe build script for Pair.

    Will automatically ensure that all build prerequisites are available
    via ez_setup.

    Usage (Mac OS X):
     python setup.py py2app

    Usage (Windows):
     python setup.py py2exe
"""

import ez_setup
ez_setup.use_setuptools()

import sys
from setuptools import setup

mainscript = "pair.py"

# Mac OS X
if sys.platform == 'darwin':
    extra_options = dict(
         setup_requires=['py2app'],
         app=[mainscript]
     )

# Windows
elif sys.platform == 'win32':
    import py2exe
    extra_options = dict(
        console=[dict(script=mainscript, packages=["encodings"])],
    )

# Unix
else:
     extra_options = dict(
         # Normally unix-like platforms will use "setup.py install"
         # and install the main script as such
         scripts=[mainscript],
     )

setup(
    name="Pair",
    **extra_options
)
