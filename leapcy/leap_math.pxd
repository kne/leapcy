
cdef extern from "LeapMath.h" namespace "Leap":
    const float PI          = 3.1415926536
    const float DEG_TO_RAD  = 0.0174532925
    const float RAD_TO_DEG  = 57.295779513
    const float EPSILON = 1.192092896e-07

    cdef cppclass Vector nogil:
        Vector()
        Vector(float _x, float _y, float _z)

    cdef cppclass FloatArray nogil:
        FloatArray()

    cdef cppclass Matrix nogil:
        Matrix()
