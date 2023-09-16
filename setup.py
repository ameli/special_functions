#! /usr/bin/env python

# =======
# Imports
# =======

from __future__ import print_function
import os
from os.path import join
import sys
import subprocess
import multiprocessing


# ===============
# install package
# ===============

def install_package(package):
    """
    Installs packages using pip.

    Example:

    .. code-block:: python

        >>> install_package('numpy>1.11')

    :param package: Name of package with or without its version pin.
    :type package: string
    """

    subprocess.check_call([sys.executable, "-m", "pip", "install",
                           "--prefer-binary", package])


# =====================
# Import Setup Packages
# =====================

# Import numpy
try:
    from numpy.distutils.misc_util import Configuration
except ImportError:
    # Install numpy
    install_package('numpy>1.11')
    from numpy.distutils.misc_util import Configuration

# Import Cython (to convert pyx to C code)
try:
    from Cython.Build import cythonize
except ImportError:
    # Install Cython
    install_package('cython')
    from Cython.Build import cythonize


# =============
# configuration
# =============

def configuration(parent_package='', top_path=None):
    """
    A utility function from numpy.distutils.misc_util to compile Fortran and C
    codes. This function will be passed to numpy.distutil.core.setup().
    """

    config = Configuration(None, parent_package, top_path)

    # Define extern directory where external libraries source codes are.
    package_name = 'special_functions'
    extern_dir_name = '_extern'
    extern_dir = os.path.join('.', package_name, extern_dir_name)

    macros = []
    if sys.platform == 'win32':
        macros.append(('_USE_MATH_DEFINES', None))

    # amos (fortran library)
    config.add_library(
            'amos',
            sources=[
                os.path.join(extern_dir, 'amos', 'mach', '*.f'),
                os.path.join(extern_dir, 'amos', 'double_precision', '*.f'),
                os.path.join(extern_dir, 'amos', 'single_precision', '*.f')
            ],
            macros=macros)

    # cephes (c library)
    config.add_library(
            'cephes',
            sources=[
                os.path.join(extern_dir, 'cephes', 'bessel', '*.c'),
                os.path.join(extern_dir, 'cephes', 'cprob', '*.c'),
                os.path.join(extern_dir, 'cephes', 'eval', '*.c'),
                os.path.join(extern_dir, 'cephes', 'cmath', '*.c')
            ],
            include_dirs=[
                os.path.join(extern_dir, 'cephes', 'eval')
            ],
            macros=macros)

    # If environment var "CYTHON_BUILD_IN_SOURCE" exists, cython creates *.c
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
            language_level="3",
            nthreads=multiprocessing.cpu_count(),
            compiler_directives={
                'boundscheck': False,
                'cdivision': True,
                'wraparound': False,
                'nonecheck': False,
                'embedsignature': True,
                'cpow': True,
                'linetrace': True
            })

    # Add extensions to config per each *.c file
    for extension in extensions:
        config.add_extension(
                extension.name,
                sources=extension.sources,
                include_dirs=extension.include_dirs,
                libraries=['amos', 'cephes'],
                language=extension.language,
                define_macros=macros)

    # Additional files, particularly, the API files to (c)import (*.pxd, *.py)
    config.add_data_files(os.path.join(package_name, '*.pxd'))     # cython API
    config.add_data_files(os.path.join(package_name, '*.py'))      # python API
    config.add_data_files((package_name, 'LICENSE.txt'))
    config.add_data_files((package_name, 'AUTHORS.txt'))
    config.add_data_files((package_name, 'README.rst'))
    config.add_data_files((package_name, 'CHANGELOG.rst'))

    return config


# =====================
# parse setup arguments
# =====================

def parse_setup_arguments():
    """
    Checks the arguments of sys.argv. If any build (or related to build)
    command was found in the arguments, this function returns True, otherwise
    it returns False.

    This function is used to determine whether to use the setup() function from
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


# ================
# get requirements
# ================

def get_requirements(directory, subdirectory=""):
    """
    Returns a list containing the package requirements given in a file named
    "requirements.txt" in a subdirectory.
    """

    requirements_filename = join(directory, subdirectory, "requirements.txt")
    requirements_file = open(requirements_filename, 'r')
    requirements = [i.strip() for i in requirements_file.readlines()]

    return requirements


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
    test_requirements = get_requirements(directory, subdirectory="tests")
    docs_requirements = get_requirements(directory, subdirectory="docs")

    # ReadMe
    readme_file = os.path.join(directory, 'README.rst')
    long_description = open(readme_file, 'r').read()

    # URLs
    url = 'https://github.com/ameli/special_functions'
    download_url = url + '/archive/main.zip'
    documentation_url = url + '/blob/main/README.rst'
    tracker_url = url + '/issues'

    # inputs to numpy.distutils.core.setup
    metadata = dict(
        name=package_name,
        packages=['special_functions'],  # needed after setuptools for py>=3.7
        version=version,
        author=author,
        author_email='sameli@berkeley.edu',
        description="Cython and Python API for special functions.",
        long_description=long_description,
        long_description_content_type='text/x-rst',
        keywords="""special-functions bessel-function gamma-function""",
        url=url,
        download_url=download_url,
        platforms=['Linux', 'OSX', 'Windows'],
        classifiers=[
            'Programming Language :: Cython',
            'Programming Language :: Python :: 3.7',
            'Programming Language :: Python :: 3.8',
            'Programming Language :: Python :: 3.9',
            'Programming Language :: Python :: 3.10',
            'Programming Language :: Python :: 3.11',
            'Programming Language :: Python :: Implementation :: CPython',
            'Programming Language :: Python :: Implementation :: PyPy',
            'License :: OSI Approved :: MIT License',
            'Operating System :: POSIX :: Linux',
            'Operating System :: Microsoft :: Windows',
            'Operating System :: MacOS',
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
            "Documentation": documentation_url,
            "Source": url,
            "Tracker": tracker_url
        },
        # ext_modules=ExternalModules,
        # include_dirs=[numpy.get_include()],
        # install_requires=requirements,
        packages=['special_functions'],
        python_requires='>=3.7',
        setup_requires=[
            'numpy>1.11',
            'cython'],
        tests_require=[
            'pytest',
            'pytest-cov'],
        include_package_data=True,
        # cmdclass={'build_ext': custom_build_extension},
        zip_safe=False,    # the package can run out of an .egg file
        extras_require={
            'test': test_requirements,
            'docs': docs_requirements,
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
        from numpy.distutils.core import setup                     # noqa: F811
        metadata['configuration'] = configuration
    else:
        metadata.update(additional_metadata)

    setup(**metadata)


# ============
# Scipt's Main
# ============

if __name__ == "__main__":
    main(sys.argv)
