--------------------------------------------------------------------
ESPRESSO can take advantage of several optimized numerical libraries
(essl, fftw, mkl...).  This configure script attempts to find them,
but may fail if they have been installed in non-standard locations.
If a required library is not found, the local copy will be compiled.

The following libraries have been found:
  BLAS_LIBS=-L/usr/lib -lessl
  LAPACK_LIBS=/home/yu/workspace/espresso/espresso-5.2.0/lapack-3.2/lapack.a
  @delete@
  FFT_LIBS= -lfftw3 -L/usr/lib -lessl
  @delete@
  MASS_LIBS=-L/opt/ibm/xlmass/8.1.2/lib -lmass -lmassv -lmass_simdp8
Please check if this is what you expect.

If any libraries are missing, you may specify a list of directories
to search and retry, as follows:
  ./configure LIBDIRS="list of directories, separated by spaces"

Parallel environment not detected \(is this a parallel machine?\).\
Configured for compilation of serial executables.

For more info, read the ESPRESSO User's Guide (Doc/users-guide.tex).
--------------------------------------------------------------------
