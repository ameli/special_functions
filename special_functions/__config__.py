# The purpose of this file is to load the compiled Fortran libraries, only
# on windows. When the amos library is compiled with Fortran, in  windows
# platform, a DLL file for the file _extern/amos/mach/d1mach.f is generated.
# When this package is installed, this DLL file is placed in a sub-directory of
# the package, in python/site-packages/special_functions/.libs. Unfortunately,
# because this DLL file is in a subfolder (.libs), the package cannot load
# properly. Calling this file will add the .libs subdirectory of the package to
# the path environment variable. To use it, simply import this file in either
# __init__.py or __init__.pxd.
#
# This file is inherited from scipy, and it is generated during the compilation
# using ``config.make_config_py()`` in setup.py. Here, we do not need to auto-
# generated this file.

# =======
# Imports
# =======

import os
import sys

__all__ = ['get_info', 'show']

# =================
# Add .libs to PATH
# =================

extra_dll_dir = os.path.join(os.path.dirname(__file__), '.libs')

if sys.platform == 'win32' and os.path.isdir(extra_dll_dir):
    if sys.version_info >= (3, 8):
        os.add_dll_directory(extra_dll_dir)
    os.environ.setdefault('PATH', '')
    os.environ['PATH'] += os.pathsep + extra_dll_dir


# ========
# get info
# ========

def get_info(name):
    """
    Returns the directory containing NumPy C header files.
    """

    g = globals()
    return g.get(name, g.get(name + "_info", {}))


# ====
# show
# ====

def show():
    """
    Show libraries in the system on which NumPy was built.

    Print information about various resources (libraries, library directories,
    include directories, etc.) in the system on which the package was built.
    """

    for name, info_dict in globals().items():
        if name[0] == "_" or not isinstance(info_dict, dict):
            continue
        print(name + ":")
        if not info_dict:
            print("  NOT AVAILABLE")
        for k, v in info_dict.items():
            v = str(v)
            if k == "sources" and len(v) > 200:
                v = v[:60] + " ...\n... " + v[-60:]
            print("    %s = %s" % (k, v))
