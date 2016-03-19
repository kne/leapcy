import logging

from cython.operator import dereference

include "leap_math.pxd"
include "leap.pxd"

logger = logging.getLogger('leapcy')


cdef extern from "Python.h":
    void PyEval_InitThreads() nogil


cdef class Base:
    cpdef _get_repr_info(self):
        raise NotImplementedError()

    def __repr__(self):
        repr_info = ('{}={!r}'.format(k, v) for k, v in self._get_repr_info())
        return '{0}({1})'.format(self.__class__.__name__, ', '.join(repr_info))

    def __getstate__(self):
        return dict(self._get_repr_info())

    def __setstate__(self):
        pass


cdef class PyFrame(Base):
    cdef Frame *frame
    cdef bool owner

    def __init__(self):
        pass

    def __dealloc__(self):
        if self.owner and self.frame != NULL:
            del self.frame
            self.frame = NULL

    @staticmethod
    cdef from_serialized_frame(string serialized_frame):
        pyframe = PyFrame()
        pyframe.frame = new Frame()
        print('serialized length', len(serialized_frame))
        pyframe.frame.deserialize(serialized_frame)
        pyframe.owner = True
        return pyframe

    @property
    def valid(self):
        return self.frame.isValid()

    cpdef _get_repr_info(self):
        return [('valid', self.valid),
                ]


cdef cppclass _Listener(Listener):
    __init__():  # , callback):
        # self.callback = callback
        pass

    void onInit(const Controller& controller) nogil:
        PyEval_InitThreads()
        with gil:
            logger.debug('Init')

    void onConnect(const Controller& controller) nogil:
        with gil:
            logger.info('Connect')

    void onDisconnect(const Controller& controller) nogil:
        with gil:
            logger.info('Disconnect')

    void onExit(const Controller& controller) nogil:
        with gil:
            logger.info('Exit')

    void onFrame(const Controller& controller) nogil:
        cdef string serialized = controller.frame().serialize()
        with gil:
            try:
                pyframe = PyFrame.from_serialized_frame(serialized)
                logger.debug('Frame %s', pyframe)
            except Exception as ex:
                print('failed', ex)

    void onFocusGained(const Controller& controller) nogil:
        with gil:
            logger.info('FocusGained')

    void onFocusLost(const Controller& controller) nogil:
        with gil:
            logger.info('FocusLost')

    void onServiceConnect(const Controller& controller) nogil:
        with gil:
            logger.info('ServiceConnect')

    void onServiceDisconnect(const Controller& controller) nogil:
        with gil:
            logger.info('ServiceDisconnect')

    void onDeviceChange(const Controller& controller) nogil:
        with gil:
            logger.info('DeviceChange')

    void onImages(const Controller& controller) nogil:
        with gil:
            logger.debug('Images')


cdef class PyListener:
    cdef _Listener listener

    def __cinit__(self):
        pass

    def __dealloc__(self):
        pass

    @property
    def connected(self):
        return False
        # return self.thisptr.isConnected()


cdef class EventIterator:
    cdef Controller *ctrl
    cdef readonly PyListener listener
    cdef readonly list listeners

    def __cinit__(self):
        self.listener = PyListener()
        self.ctrl = new Controller()
        self.ctrl.addListener(self.listener.listener)

    property monitor_background_frames:
        '''Listen for frames'''
        def __get__(self):
            return self.ctrl.isPolicySet(POLICY_BACKGROUND_FRAMES)

        def __set__(self, listen):
            if listen:
                self.ctrl.setPolicy(POLICY_BACKGROUND_FRAMES)
            else:
                self.ctrl.clearPolicy(POLICY_BACKGROUND_FRAMES)

    property monitor_images:
        '''Listen for raw sensor images'''
        def __get__(self):
            return self.ctrl.isPolicySet(POLICY_IMAGES)

        def __set__(self, listen):
            if listen:
                self.ctrl.setPolicy(POLICY_IMAGES)
            else:
                self.ctrl.clearPolicy(POLICY_IMAGES)

    property optimize_hmd:
        '''Optimize for head-mounted devices (HMD)'''
        def __get__(self):
            return self.ctrl.isPolicySet(POLICY_OPTIMIZE_HMD)

        def __set__(self, listen):
            if listen:
                self.ctrl.setPolicy(POLICY_OPTIMIZE_HMD)
            else:
                self.ctrl.clearPolicy(POLICY_OPTIMIZE_HMD)

    def next_event(self):
        pass

    def stop(self):
        self.monitor_background_frames = False
        self.monitor_images = False

    def __dealloc__(self):
        del self.ctrl
