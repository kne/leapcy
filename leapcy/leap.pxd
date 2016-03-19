from libcpp cimport bool
from libcpp.string cimport string
from libc.stdint cimport (int32_t, uint32_t, int64_t)


cdef extern from "Leap.h" namespace "Leap":
    cdef cppclass Interface:
        pass

    cdef cppclass Listener nogil:
        Listener()
        # ~Listener()
        void onInit(const Controller&)
        void onConnect(const Controller&)
        void onDisconnect(const Controller&)
        void onExit(const Controller&)
        void onFrame(const Controller&)
        void onFocusGained(const Controller&)
        void onFocusLost(const Controller&)
        void onServiceConnect(const Controller&)
        void onServiceDisconnect(const Controller&)
        void onDeviceChange(const Controller&)
        void onImages(const Controller&)

    cdef enum PolicyFlag:
        POLICY_DEFAULT "Leap::Controller::POLICY_DEFAULT"
        POLICY_BACKGROUND_FRAMES "Leap::Controller::POLICY_BACKGROUND_FRAMES"
        POLICY_IMAGES "Leap::Controller::POLICY_IMAGES"
        POLICY_OPTIMIZE_HMD "Leap::Controller::POLICY_OPTIMIZE_HMD"

    cdef cppclass Controller(Interface) nogil:
        # Controller(ControllerImplementation*)
        Controller()
        # ~Controller()
        Controller(Listener& listener)
        bool isConnected() const
        bool isServiceConnected() const
        bool hasFocus() const
        PolicyFlag policyFlags() const
        # void setPolicyFlags(PolicyFlag flags) const
        void setPolicy(PolicyFlag policy) const
        void clearPolicy(PolicyFlag policy) const
        bool isPolicySet(PolicyFlag policy) const
        bool addListener(Listener& listener)
        bool removeListener(Listener& listener)
        Frame frame(int history = 0) const
        ImageList images() const
        Config config() const
        DeviceList devices() const
        ScreenList locatedScreens() const
        BugReport bugReport() const
        void enableGesture(GestureType type, bool enable = true) const
        bool isGestureEnabled(GestureType type) const
        TrackedQuad trackedQuad() const
        int64_t now() const

    cdef cppclass Frame(Interface) nogil:
        Frame()
        int64_t id() const
        int64_t timestamp() const
        HandList hands() const
        Hand hand(int32_t id) const
        PointableList pointables() const
        Pointable pointable(int32_t id) const
        FingerList fingers() const
        Finger finger(int32_t id) const
        ToolList tools() const
        Tool tool(int32_t id) const
        Gesture gesture(int32_t id) const
        GestureList gestures() const
        GestureList gestures(const Frame& sinceFrame) const
        ImageList images() const
        Vector translation(const Frame& sinceFrame) const
        float translationProbability(const Frame& sinceFrame) const
        Vector rotationAxis(const Frame& sinceFrame) const
        float rotationAngle(const Frame& sinceFrame) const
        float rotationAngle(const Frame& sinceFrame, const Vector& axis) const
        Matrix rotationMatrix(const Frame& sinceFrame) const
        float rotationProbability(const Frame& sinceFrame) const
        float scaleFactor(const Frame& sinceFrame) const
        float scaleProbability(const Frame& sinceFrame) const
        InteractionBox interactionBox() const
        float currentFramesPerSecond() const
        bool isValid() const
        # static const Frame& invalid()
        const Frame& invalid()
        bool operator==(const Frame&) const
        bool operator!=(const Frame&) const
        # friend std::ostream& operator<<(std::ostream&, const Frame&)
        TrackedQuad trackedQuad() const
        const char* toCString() const
        const char* serializeCString(size_t& length) const
        void deserializeCString(const char* str, size_t length)
        string serialize() const
        void deserialize(string& str)

    cdef enum PointableZone:
        ZONE_NONE "Leap::Pointable::ZONE_NONE"
        ZONE_HOVERING "Leap::Pointable::ZONE_HOVERING"
        ZONE_TOUCHING "Leap::Pointable::ZONE_TOUCHING"

    cdef cppclass Pointable(Interface) nogil:
        Pointable()
        int32_t id() const
        Frame frame() const
        Hand hand() const
        Vector tipPosition() const
        Vector tipVelocity() const
        Vector direction() const
        float width() const
        float length() const
        bool isFinger() const
        bool isTool() const
        bool isExtended() const
        bool isValid() const
        PointableZone touchZone() const
        float touchDistance() const
        Vector stabilizedTipPosition() const
        float timeVisible() const
        # static
        const Pointable& invalid()
        bool operator==(const Pointable&) const
        bool operator!=(const Pointable&) const
        # friend std::ostream& operator<<(std::ostream&, const Pointable&)
        const char* toCString() const

    cdef cppclass Pointable(Interface) nogil:
        Pointable()
        int32_t id() const
        Frame frame() const
        Hand hand() const
        Vector tipPosition() const
        Vector tipVelocity() const
        Vector direction() const
        float width() const
        float length() const
        bool isFinger() const
        bool isTool() const
        bool isExtended() const
        bool isValid() const
        PointableZone touchZone() const
        float touchDistance() const
        Vector stabilizedTipPosition() const
        float timeVisible() const
        # static
        const Pointable& invalid()
        bool operator==(const Pointable&) const
        bool operator!=(const Pointable&) const
        # friend std::ostream& operator<<(std::ostream&, const Pointable&)
        const char* toCString() const

    cdef cppclass Arm(Interface) nogil:
        Arm()
        float width() const
        Vector direction() const
        Matrix basis() const
        Vector elbowPosition() const
        Vector wristPosition() const
        Vector center() const
        bool isValid() const
        # static
        const Arm& invalid()
        bool operator==(const Arm&) const
        bool operator!=(const Arm&) const
        # friend std::ostream& operator<<(std::ostream&, const Arm&)
        const char* toCString() const

    cdef cppclass Bone(Interface) nogil:
        Bone()
        Vector prevJoint() const
        Vector nextJoint() const
        Vector center() const
        Vector direction() const
        float length() const
        float width() const
        BoneType type() const
        Matrix basis() const
        bool isValid() const
        # static
        const Bone& invalid()
        bool operator==(const Bone&) const
        bool operator!=(const Bone&) const
        # friend std::ostream& operator<<(std::ostream&, const Bone&)
        const char* toCString() const

    cdef enum BoneType:
        TYPE_METACARPAL "Leap::Bone::TYPE_METACARPAL"
        TYPE_PROXIMAL "Leap::Bone::TYPE_PROXIMAL"
        TYPE_INTERMEDIATE "Leap::Bone::TYPE_INTERMEDIATE"
        TYPE_DISTAL "Leap::Bone::TYPE_DISTAL"

    cdef cppclass Finger(Pointable) nogil:
        Finger()
        # explicit
        Finger(const Pointable&)
        Vector jointPosition(FingerJoint jointIx) const
        Bone bone(BoneType boneIx) const
        FingerType type() const
        # static
        const Finger& invalid()
        const char* toCString() const

    cdef cppclass Tool(Pointable) nogil:
        Tool()
        # explicit
        Tool(const Pointable&)
        # static
        const Tool& invalid()
        const char* toCString() const

    cdef cppclass Hand(Interface) nogil:
        Hand()
        int32_t id() const
        Frame frame() const
        PointableList pointables() const
        Pointable pointable(int32_t id) const
        FingerList fingers() const
        Finger finger(int32_t id) const
        ToolList tools() const
        Tool tool(int32_t id) const
        Vector palmPosition() const
        Vector stabilizedPalmPosition() const
        Vector palmVelocity() const
        Vector palmNormal() const
        float palmWidth() const
        Vector direction() const
        Matrix basis() const
        Arm arm() const
        Vector wristPosition() const
        Vector sphereCenter() const
        float sphereRadius() const
        float pinchStrength() const
        float grabStrength() const
        Vector translation(const Frame& sinceFrame) const
        float translationProbability(const Frame& sinceFrame) const
        Vector rotationAxis(const Frame& sinceFrame) const
        float rotationAngle(const Frame& sinceFrame) const
        float rotationAngle(const Frame& sinceFrame, const Vector& axis) const
        Matrix rotationMatrix(const Frame& sinceFrame) const
        float rotationProbability(const Frame& sinceFrame) const
        float scaleFactor(const Frame& sinceFrame) const
        float scaleProbability(const Frame& sinceFrame) const
        float timeVisible() const
        float confidence() const
        bool isLeft() const
        bool isRight() const
        bool isValid() const
        # static
        const Hand& invalid()
        bool operator==(const Hand&) const
        bool operator!=(const Hand&) const
        # friend std::ostream& operator<<(std::ostream&, const Hand&)
        const char* toCString() const

    cdef enum GestureType:
        TYPE_INVALID "Leap::Gesture::TYPE_INVALID"
        TYPE_SWIPE "Leap::Gesture::TYPE_SWIPE"
        TYPE_CIRCLE "Leap::Gesture::TYPE_CIRCLE"
        TYPE_SCREEN_TAP "Leap::Gesture::TYPE_SCREEN_TAP"
        TYPE_KEY_TAP "Leap::Gesture::TYPE_KEY_TAP"

    cdef enum GestureState:
        STATE_INVALID "Leap::Gesture::STATE_INVALID"
        STATE_START "Leap::Gesture::STATE_START"
        STATE_UPDATE "Leap::Gesture::STATE_UPDATE"
        STATE_STOP "Leap::Gesture::STATE_STOP"

    cdef cppclass Gesture(Interface) nogil:
        Gesture()
        Gesture(const Gesture& rhs)
        GestureType type() const
        GestureState state() const
        int32_t id() const
        int64_t duration() const
        float durationSeconds() const
        Frame frame() const
        HandList hands() const
        PointableList pointables() const
        bool isValid() const
        bool operator==(const Gesture& rhs) const
        bool operator!=(const Gesture& rhs) const
        # static
        const Gesture& invalid()
        const char* toCString() const

    cdef cppclass SwipeGesture(Gesture) nogil:
        SwipeGesture()
        SwipeGesture(const Gesture& rhs)
        Vector startPosition() const
        Vector position() const
        Vector direction() const
        float speed() const
        Pointable pointable() const

    cdef cppclass CircleGesture(Gesture) nogil:
        CircleGesture()
        CircleGesture(const Gesture& rhs)
        Vector center() const
        Vector normal() const
        float progress() const
        float radius() const
        Pointable pointable() const

    cdef cppclass ScreenTapGesture(Gesture) nogil:
        ScreenTapGesture()
        ScreenTapGesture(const Gesture& rhs)
        Vector position() const
        Vector direction() const
        float progress() const
        Pointable pointable() const

    cdef cppclass KeyTapGesture(Gesture) nogil:
        KeyTapGesture()
        KeyTapGesture(const Gesture& rhs)
        Vector position() const
        Vector direction() const
        float progress() const
        Pointable pointable() const

    cdef cppclass Screen(Interface) nogil:
        Screen()
        int32_t id() const
        Vector intersect(const Pointable& pointable, bool normalize, float clampRatio = 1.0) const
        Vector intersect(const Vector& position, const Vector& direction, bool normalize, float clampRatio = 1.0) const
        Vector project(const Vector& position, bool normalize, float clampRatio = 1.0) const
        Vector horizontalAxis() const
        Vector verticalAxis() const
        Vector bottomLeftCorner() const
        Vector normal() const
        int widthPixels() const
        int heightPixels() const
        float distanceToPoint(const Vector& point) const
        bool isValid() const
        # static
        const Screen& invalid()
        bool operator==(const Screen&) const
        bool operator!=(const Screen&) const
        # friend std::ostream& operator<<(std::ostream&, const Screen&)
        const char* toCString() const

    cdef enum DeviceType:
        TYPE_PERIPHERAL "Leap::Device::TYPE_PERIPHERAL"
        TYPE_LAPTOP "Leap::Device::TYPE_LAPTOP"
        TYPE_KEYBOARD "Leap::Device::TYPE_KEYBOARD"

    cdef cppclass Device(Interface) nogil:
        Device()
        float horizontalViewAngle() const
        float verticalViewAngle() const
        float range() const
        float baseline() const
        float distanceToBoundary(const Vector& position) const
        bool isEmbedded() const
        bool isStreaming() const
        bool isFlipped() const
        DeviceType type() const
        Vector position() const
        Matrix orientation() const
        bool isValid() const
        # static
        const Device& invalid()
        bool operator==(const Device&) const
        bool operator!=(const Device&) const
        # friend std::ostream& operator<<(std::ostream&, const Device&)
        const char* toCString() const
        const char* serialNumberCString() const

    cdef enum FormatType:
        INFRARED "Leap::Image::INFRARED"

    cdef cppclass Image(Interface) nogil:
        Image()
        int64_t sequenceId() const
        int32_t id() const
        const unsigned char* data() const
        const float* distortion() const
        int width() const
        int height() const
        int bytesPerPixel() const
        FormatType format() const
        int distortionWidth() const
        int distortionHeight() const
        float rayOffsetX() const
        float rayOffsetY() const
        float rayScaleX() const
        float rayScaleY() const
        Vector rectify(const Vector& uv) const
        Vector warp(const Vector& xy) const
        int64_t timestamp() const
        bool isValid() const
        # static
        const Image& invalid()
        bool operator==(const Image&) const
        bool operator!=(const Image&) const
        # friend std::ostream& operator<<(std::ostream&, const Image&)
        const char* toCString() const

    cdef cppclass Mask(Interface) nogil:
        Mask()
        int64_t sequenceId() const
        int32_t id() const
        const unsigned char* data() const
        int width() const
        int height() const
        int offsetX() const
        int offsetY() const
        bool isValid() const
        # static
        const Mask& invalid()
        bool operator==(const Mask&) const
        bool operator!=(const Mask&) const
        # friend std::ostream& operator<<(std::ostream&, const Mask&)
        const char* toCString() const

    cdef cppclass PointableList(Interface) nogil:
        PointableList()
        int count() const
        bool isEmpty() const
        Pointable operator[](int index) const
        PointableList& append(const PointableList& other)
        PointableList& append(const FingerList& other)
        PointableList& append(const ToolList& other)
        Pointable leftmost() const
        Pointable rightmost() const
        Pointable frontmost() const
        PointableList extended() const
        # const_iterator begin() const
        # const_iterator end() const

    cdef enum FingerJoint:
        JOINT_MCP "Leap::Finger::JOINT_MCP"
        JOINT_PIP "Leap::Finger::JOINT_PIP"
        JOINT_DIP "Leap::Finger::JOINT_DIP"
        JOINT_TIP "Leap::Finger::JOINT_TIP"

    cdef enum FingerType:
        TYPE_THUMB "Leap::Finger::TYPE_THUMB"
        TYPE_INDEX "Leap::Finger::TYPE_INDEX"
        TYPE_MIDDLE "Leap::Finger::TYPE_MIDDLE"
        TYPE_RING "Leap::Finger::TYPE_RING"
        TYPE_PINKY "Leap::Finger::TYPE_PINKY"

    cdef cppclass FingerList(Interface) nogil:
        FingerList()
        int count() const
        bool isEmpty() const
        Finger operator[](int index) const
        FingerList& append(const FingerList& other)
        Finger leftmost() const
        Finger rightmost() const
        Finger frontmost() const
        FingerList extended() const
        FingerList fingerType(FingerType type) const
        # const_iterator begin() const
        # const_iterator end() const

    cdef cppclass ToolList(Interface) nogil:
        ToolList()
        int count() const
        bool isEmpty() const
        Tool operator[](int index) const
        ToolList& append(const ToolList& other)
        Tool leftmost() const
        Tool rightmost() const
        Tool frontmost() const
        # const_iterator begin() const
        # const_iterator end() const

    cdef cppclass HandList(Interface) nogil:
        HandList()
        int count() const
        bool isEmpty() const
        Hand operator[](int index) const
        HandList& append(const HandList& other)
        Hand leftmost() const
        Hand rightmost() const
        Hand frontmost() const
        # const_iterator begin() const
        # const_iterator end() const

    cdef cppclass GestureList(Interface) nogil:
        GestureList()
        int count() const
        bool isEmpty() const
        Gesture operator[](int index) const
        GestureList& append(const GestureList& other)
        # const_iterator begin() const
        # const_iterator end() const

    cdef cppclass ScreenList(Interface) nogil:
        ScreenList()
        int count() const
        bool isEmpty() const
        Screen operator[](int index) const
        # const_iterator begin() const
        # const_iterator end() const
        Screen closestScreenHit(const Pointable& pointable) const
        Screen closestScreenHit(const Vector& position, const Vector& direction) const
        Screen closestScreen(const Vector& position) const

    cdef cppclass DeviceList(Interface) nogil:
        DeviceList()
        int count() const
        bool isEmpty() const
        Device operator[](int index) const
        DeviceList& append(const DeviceList& other)
        # const_iterator begin() const
        # const_iterator end() const

    cdef cppclass ImageList(Interface) nogil:
        ImageList()
        int count() const
        bool isEmpty() const
        Image operator[](int index) const
        ImageList& append(const ImageList& other)
        # const_iterator begin() const
        # const_iterator end() const

    cdef cppclass TrackedQuad(Interface) nogil:
        TrackedQuad()
        float width() const
        float height() const
        int resolutionX() const
        int resolutionY() const
        bool visible() const
        Matrix orientation() const
        Vector position() const
        MaskList masks() const
        ImageList images() const
        bool isValid() const
        # static
        const TrackedQuad& invalid()
        bool operator==(const TrackedQuad&) const
        bool operator!=(const TrackedQuad&) const
        # friend std::ostream& operator<<(std::ostream&, const TrackedQuad&)
        const char* toCString() const

    cdef cppclass MaskList(Interface) nogil:
        MaskList()
        int count() const
        bool isEmpty() const
        Mask operator[](int index) const
        MaskList& append(const MaskList& other)
        # const_iterator begin() const
        # const_iterator end() const

    cdef cppclass InteractionBox(Interface) nogil:
        InteractionBox()
        Vector normalizePoint(const Vector& position, bool clamp = true) const
        Vector denormalizePoint(const Vector& normalizedPosition) const
        Vector center() const
        float width() const
        float height() const
        float depth() const
        bool isValid() const
        # static
        const InteractionBox& invalid()
        bool operator==(const InteractionBox&) const
        bool operator!=(const InteractionBox&) const
        # friend std::ostream& operator<<(std::ostream&, const InteractionBox&)
        const char* toCString() const

    cdef cppclass BugReport(Interface) nogil:
        BugReport()
        bool beginRecording()
        void endRecording()
        bool isActive() const
        float progress() const
        float duration() const

    cdef enum ValueType:
        TYPE_UNKNOWN "Leap::Config::TYPE_UNKNOWN"
        TYPE_BOOLEAN "Leap::Config::TYPE_BOOLEAN"
        TYPE_INT32 "Leap::Config::TYPE_INT32"
        TYPE_FLOAT "Leap::Config::TYPE_FLOAT"
        TYPE_STRING "Leap::Config::TYPE_STRING"

    cdef cppclass Config(Interface) nogil:
        Config()
        bool save()
        ValueType typeCString(const char* key) const
        bool getBoolCString(const char* key) const
        bool setBoolCString(const char* key, bool value)
        int32_t getInt32CString(const char* key) const
        bool setInt32CString(const char* key, int32_t value)
        float getFloatCString(const char* key) const
        bool setFloatCString(const char* key, float value)
        const char* getStringCString(const char* key) const
        bool setStringCString(const char* key, const char* value)
