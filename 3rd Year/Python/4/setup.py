from distutils.core import setup, Extension

module1 = Extension('stringutils',
                    sources = ['stringutilsmodule.c'])

setup (name = 'StringUtils',
       version = '1.0',
       description = 'String utilities package (for University)',
       ext_modules = [module1])