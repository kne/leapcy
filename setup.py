import os
from distutils.core import (setup, Extension)
import glob
from Cython.Build import cythonize
from Cython.Distutils import build_ext

leap_sdk_path = os.path.join(os.path.expanduser('~'), 'LeapSDK')
leap_include_path = os.path.join(leap_sdk_path, 'include')
leap_library_path = os.path.join(leap_sdk_path, 'lib')


ext = Extension(
    "leapcy",
    ["leapcy/main.pyx"],
    language="c++",
    include_dirs=[leap_include_path, ],
    library_dirs=[leap_library_path, ],
    libraries=['Leap'],
)


setup(name='leapcy',
      ext_modules=[ext],
      cmdclass={'build_ext': build_ext},
      )
