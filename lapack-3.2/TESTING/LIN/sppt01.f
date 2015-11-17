      SUBROUTINE SPPT01( UPLO, N, A, AFAC, RWORK, RESID )
*
*  -- LAPACK test routine (version 3.1) --
*     Univ. of Tennessee, Univ. of California Berkeley and NAG Ltd..
*     November 2006
*
*     .. Scalar Arguments ..
      CHARACTER          UPLO
      INTEGER            N
      REAL               RESID
*     ..
*     .. Array Arguments ..
      REAL               A( * ), AFAC( * ), RWORK( * )
*     ..
*
*  Purpose
*  =======
*
*  SPPT01 reconstructs a symmetric positive definite packed matrix A
*  from its L*L' or U'*U factorization and computes the residual
*     norm( L*L' - A ) / ( N * norm(A) * EPS ) or
*     norm( U'*U - A ) / ( N * norm(A) * EPS ),
*  where EPS is the machine epsilon.
*
*  Arguments
*  ==========
*
*  UPLO    (input) CHARACTER*1
*          Specifies whether the upper or lower triangular part of the
*          symmetric matrix A is stored:
*          = 'U':  Upper triangular
*          = 'L':  Lower triangular
*
*  N       (input) INTEGER
*          The number of rows and columns of the matrix A.  N >= 0.
*
*  A       (input) REAL array, dimension (N*(N+1)/2)
*          The original symmetric matrix A, stored as a packed
*          triangular matrix.
*
*  AFAC    (input/output) REAL array, dimension (N*(N+1)/2)
*          On entry, the factor L or U from the L*L' or U'*U
*          factorization of A, stored as a packed triangular matrix.
*          Overwritten with the reconstructed matrix, and then with the
*          difference L*L' - A (or U'*U - A).
*
*  RWORK   (workspace) REAL array, dimension (N)
*
*  RESID   (output) REAL
*          If UPLO = 'L', norm(L*L' - A) / ( N * norm(A) * EPS )
*          If UPLO = 'U', norm(U'*U - A) / ( N * norm(A) * EPS )
*
*  =====================================================================
*
*     .. Parameters ..
      REAL               ZERO, ONE
      PARAMETER          ( ZERO = 0.0E+0, ONE = 1.0E+0 )
*     ..
*     .. Local Scalars ..
      INTEGER            I, K, KC, NPP
      REAL               ANORM, EPS, T
*     ..
*     .. External Functions ..
      LOGICAL            LSAME
      REAL               SDOT, SLAMCH, SLANSP
      EXTERNAL           LSAME, SDOT, SLAMCH, SLANSP
*     ..
*     .. External Subroutines ..
      EXTERNAL           SSCAL, SSPR, STPMV
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          REAL
*     ..
*     .. Executable Statements ..
*
*     Quick exit if N = 0
*
      IF( N.LE.0 ) THEN
         RESID = ZERO
         RETURN
      END IF
*
*     Exit with RESID = 1/EPS if ANORM = 0.
*
      EPS = SLAMCH( 'Epsilon' )
      ANORM = SLANSP( '1', UPLO, N, A, RWORK )
      IF( ANORM.LE.ZERO ) THEN
         RESID = ONE / EPS
         RETURN
      END IF
*
*     Compute the product U'*U, overwriting U.
*
      IF( LSAME( UPLO, 'U' ) ) THEN
         KC = ( N*( N-1 ) ) / 2 + 1
         DO 10 K = N, 1, -1
*
*           Compute the (K,K) element of the result.
*
            T = SDOT( K, AFAC( KC ), 1, AFAC( KC ), 1 )
            AFAC( KC+K-1 ) = T
*
*           Compute the rest of column K.
*
            IF( K.GT.1 ) THEN
               CALL STPMV( 'Upper', 'Transpose', 'Non-unit', K-1, AFAC,
     $                     AFAC( KC ), 1 )
               KC = KC - ( K-1 )
            END IF
   10    CONTINUE
*
*     Compute the product L*L', overwriting L.
*
      ELSE
         KC = ( N*( N+1 ) ) / 2
         DO 20 K = N, 1, -1
*
*           Add a multiple of column K of the factor L to each of
*           columns K+1 through N.
*
            IF( K.LT.N )
     $         CALL SSPR( 'Lower', N-K, ONE, AFAC( KC+1 ), 1,
     $                    AFAC( KC+N-K+1 ) )
*
*           Scale column K by the diagonal element.
*
            T = AFAC( KC )
            CALL SSCAL( N-K+1, T, AFAC( KC ), 1 )
*
            KC = KC - ( N-K+2 )
   20    CONTINUE
      END IF
*
*     Compute the difference  L*L' - A (or U'*U - A).
*
      NPP = N*( N+1 ) / 2
      DO 30 I = 1, NPP
         AFAC( I ) = AFAC( I ) - A( I )
   30 CONTINUE
*
*     Compute norm( L*U - A ) / ( N * norm(A) * EPS )
*
      RESID = SLANSP( '1', UPLO, N, AFAC, RWORK )
*
      RESID = ( ( RESID / REAL( N ) ) / ANORM ) / EPS
*
      RETURN
*
*     End of SPPT01
*
      END
