#! /usr/bin/env python

# =======
# Imports
# =======

from __future__ import print_function
import os
import sys
import subprocess


# ===============
# Install Package
# ===============

def InstallPackage(Package):
    """
    Installs packages using pip.

    Example:

    .. code-block:: python

        >>> InstallPackage('numpy>1.11')

    :param Package: Name of pakcage with or without its version pin.
    :type Package: string
    """

    subprocess.check_call([sys.executable, "-m", "pip", "install", Package])


# =====================
# Import Setup Packages
# =====================

# Import numpy
try:
    from numpy.distutils.misc_util import Configuration
except ImportError:
    # Install numpy
    InstallPackage('numpy>1.11')
    from numpy.distutils.misc_util import Configuration

# Import Cython (to convert pyx to C code)
try:
    from Cython.Build import cythonize
    UseCython = True
except ImportError:
    # Install Cython
    InstallPackage('cython')
    from Cython.Build import cythonize


# =============
# configuration
# =============

def configuration(parent_package='', top_path=None):
    config = Configuration(None, parent_package, top_path)

    # Define extern directory where external libraries source codes are.
    package_name = 'special_functions'
    extern_directory_name = '_extern'
    extern_directory = os.path.join('.', package_name, extern_directory_name)

    # amos (fortran library)
    config.add_library(
            'amos',
            sources=[
                os.path.join(extern_directory, 'amos', '*.f'),
                os.path.join(extern_directory, 'mach', '*.f')
            ],
            extra_f77_compile_args=['-O3', '-fPIC'])

    # cephes (c library)
    config.add_library(
            'cephes',
            sources=[
                os.path.join(extern_directory, 'cephes', 'bessel', '*.c'),
                os.path.join(extern_directory, 'cephes', 'cprob', '*.c'),
                os.path.join(extern_directory, 'cephes', 'eval', '*.c'),
                os.path.join(extern_directory, 'cephes', 'cmath', '*.c')
            ],
            include_dirs=[
                os.path.join(extern_directory, 'cephes', 'eval')
            ],
            extra_compiler_args=['-O3', '-fPIC'])

    # If envirinment var "CYTHON_BUILD_IN_SOURCE" exists, cython builds *.c
    # files in the source code, otherwise in /build.
    cython_build_in_source = os.environ.get('CYTHON_BUILD_IN_SOURCE', None)
    if bool(cython_build_in_source):
        cython_build_dir = None    # builds *.c in source alongside *.pyx files
    else:
        cython_build_dir = 'build'

    # Cythontize *.pyx files to generate *.c files.
    extensions = cythonize(
            os.path.join('.', package_name, '*.pyx'),
            build_dir=cython_build_dir,
            include_path=[os.path.join('.', package_name)],
            compiler_directives={
                'boundscheck': False,
                'cdivision': True,
                'wraparound': False,
                'nonecheck': False,
                "embedsignature": True
            })

    # add extensions to config per each *.c file
    for extension in extensions:
        config.add_extension(
                extension.name,
                sources=extension.sources,
                include_dirs=extension.include_dirs,
                extra_compile_args=['-fPIC', '-O3'],
                libraries=['amos', 'cephes'],
                library_dirs=["."],               # Test
                language='c++')                   # Test
                # runtime_library_dirs=["."])       # Test

    config.add_data_files((package_name, 'LICENSE.txt'))
    config.add_data_files((package_name, 'AUTHORS.txt'))
    config.add_data_files((package_name, 'README.rst'))
    config.add_data_files((package_name, 'CHANGELOG.rst'))
    config.add_data_files(os.path.join(package_name, '*.pxd'))     # cython API
    config.add_data_files(os.path.join(package_name, '*.py'))      # python API

    return config


# =====================
# parse setup arguments
# =====================

def parse_setup_arguments():
    """
    Checks the arguments of sys.argv. If any build (or related to build)
    command was found in the arguments, this function returns True, otherwise
    it returns False.

    This function is used to determine wether to use the setup() function from
        1. numpy.distutil.core.setup()    # used if this function returns True
        2. setuptools.setup()             # used if this function returns False
    """

    # List of commands that require build using numpy.distutils
    build_commands = ['build', 'build_ext', 'install', 'bdist_wheel', 'sdist',
                      'develop', 'build_py', 'bdist_rpm', 'bdist_msi',
                      'bdist_mpkg', 'bdist_wininst', 'build_scripts',
                      'build_clib']

    run_build = False
    for build_command in build_commands:
        if build_command in sys.argv:
            run_build = True
            break

    return run_build


# ====
# main
# ====

def main(argv):

    directory = os.path.dirname(os.path.realpath(__file__))
    package_name = "special_functions"

    # Version
    version_dummy = {}
    version_file = os.path.join(directory, package_name, '__version__.py')
    exec(open(version_file, 'r').read(), version_dummy)
    version = version_dummy['__version__']
    del version_dummy

    # Author
    author_file = os.path.join(directory, 'AUTHORS.txt')
    author = open(author_file, 'r').read().rstrip()

    # Requirements
    # requirements_file = os.path.join(directory, "requirements.txt")
    # requirements = [i.strip() for i in open(requirements_file, 'r').readlines()]

    # ReadMe
    readme_file = os.path.join(directory, 'README.rst')
    long_description = open(readme_file, 'r').read()

    # inputs to numpy.distutils.core.setup
    metadata = dict(
        name=package_name,
        version=version,
        author=author,
        author_email='sameli@berkeley.edu',
        description="Cython and Python API for special functions.",
        long_description=long_description,
        keywords="""special-functions bessel-function airy-function
            gamma-function""",
        url='https://github.com/ameli/special_functions',
        download_url='https://github.com/ameli/special_functions/archive/main.zip',
        platforms=['Linux', 'OSX', 'Windows'],
        classifiers=[
            'Programming Language :: Python :: 2.7',
            'Programming Language :: Python :: 3.6',
            'Programming Language :: Python :: 3.7',
            'Programming Language :: Python :: 3.8',
            'Programming Language :: Python :: 3.9',
            'License :: OSI Approved :: MIT License',
            'Operating System :: OS Independent',
            'Natural Language :: English',
            'Intended Audience :: Science/Research',
            'Intended Audience :: Developers',
            'Topic :: Software Development',
            'Topic :: Software Development :: Libraries :: Python Modules',
        ],
    )

    # additional inputs that can only be used for setuptools.setup.
    # These inputs cannot be used for numpy.distutil.core.setup
    additional_metadata = dict(
        long_description_content_type='text/x-rst',
        project_urls={
            "Documentation": "https://github.com/ameli/special_functions/blob/main/README.rst",
            "Source": "https://github.com/ameli/special_functions",
            "Tracker": "https://github.com/ameli/special_functions/issues",
        },
        # ext_modules=ExternalModules,
        # include_dirs=[numpy.get_include()],
        # install_requires=requirements,
        python_requires='>=2.7',
        setup_requires=[
            'numpy>1.11',
            'cython',
            'pytest-runner'],
        tests_require=[
            'pytest',
            'pytest-cov'],
        include_package_data=True,
        # cmdclass={'build_ext': CustomBuildExtension},
        zip_safe=False,    # the package can run out of an .egg file
        extras_require={
            'test': [
                'pytest-cov',
                'codecov'
            ],
            'docs': [
                'sphinx',
                'sphinx-math-dollar',
                'sphinx-toggleprompt',
                'sphinx_rtd_theme',
                'graphviz',
                'sphinx-automodapi',
            ]
        },
    )

    # if run_build is true, we will use numpy.distutils.core.setup to build,
    # otherwise, we will use setuptools.setup
    run_build = parse_setup_arguments()

    # Note: setuptools.setup must be imported before numpy.distutils.core.setup
    # so that some input commands (like bdist_wheel) work properly with the
    # numpy.distutil.core.setup.
    from setuptools import setup

    if run_build:
        from numpy.distutils.core import setup
        metadata['configuration'] = configuration
    else:
        metadata.update(additional_metadata)

    setup(**metadata)


# ============
# Scipt's Main
# ============

if __name__ == "__main__":
    main(sys.argv)
