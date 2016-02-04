'''
setup.py - Setup file for the python-atik module.

Author:
    Martin Norbury

February 2016
'''
from setuptools import setup, Extension

extensions = [Extension('_atik', ['atik.i'], swig_opts=['-c++'], libraries=['atikccd'])]

setup(name    = 'python-atik',
      version = '0.1',
      author  = 'Martin Norbury',
      description = '''Simple swig wrappings around ATIK camera''',
      ext_modules = extensions,
      install_requires = ['numpy'],
     )
