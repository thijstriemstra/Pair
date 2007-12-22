#! /usr/bin/env python
# encoding: utf-8
# Gustavo Carneiro, 2007

import sys
from Params import fatal
import Configure

# the following two variables are used by the target "waf dist"
VERSION='0.0.1'
APPNAME='python_test'

# these variables are mandatory ('/' are converted automatically)
srcdir = '.'
blddir = 'build'

def set_options(opt):
	opt.tool_options('python') # options for disabling pyc or pyo compilation
	opt.tool_options('compiler_cc')

def configure(conf):
	conf.check_tool('compiler_cc')
	conf.check_tool('python')
	conf.check_python_version((2,4,2))
	conf.check_python_headers()

	try:
		conf.check_python_module('pygccxml')
	except Configure.ConfigurationError:
		print "(module not found, but we ignore it)"
		pass

def build(bld):
	# first compile a few pyc and pyo files
	obj = bld.create_obj('py')
	#obj.source = 'foo.py'
	obj.find_sources_in_dirs('.')

	# then a c extension module
	obj = bld.create_obj('cc', 'shlib', 'pyext')
	obj.source = 'spammodule.c'
	obj.target = 'spam'

	# then a c program
	obj = bld.create_obj('cc', 'program', 'pyembed')
	obj.source = 'test.c'
	obj.target = 'test'

def shutdown():
	#import os
	#print os.popen('build/default/test').read()
	pass


