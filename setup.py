# Copyright (c) 2007 The Pair Project. All rights reserved.

from ez_setup import use_setuptools

use_setuptools()

from setuptools import setup, find_packages

setup(name = "Pair",
    version = "1.0.0",
    description = "AIR for Python",
    url = "http://dev.collab.com/pair",
    packages = find_packages(exclude=["*.tests"]),
    license = "MIT License",
    classifiers = [
        "Development Status :: 2 - Pre-Alpha",
        "Natural Language :: English",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python",
        "Topic :: Software Development :: Libraries :: Python Modules",
    ])
