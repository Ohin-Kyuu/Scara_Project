; Auto-generated. Do not edit!


(cl:in-package robot-srv)


;//! \htmlinclude inv-request.msg.html

(cl:defclass <inv-request> (roslisp-msg-protocol:ros-message)
  ((pose
    :reader pose
    :initarg :pose
    :type geometry_msgs-msg:Pose
    :initform (cl:make-instance 'geometry_msgs-msg:Pose)))
)

(cl:defclass inv-request (<inv-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <inv-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'inv-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name robot-srv:<inv-request> is deprecated: use robot-srv:inv-request instead.")))

(cl:ensure-generic-function 'pose-val :lambda-list '(m))
(cl:defmethod pose-val ((m <inv-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader robot-srv:pose-val is deprecated.  Use robot-srv:pose instead.")
  (pose m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <inv-request>) ostream)
  "Serializes a message object of type '<inv-request>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'pose) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <inv-request>) istream)
  "Deserializes a message object of type '<inv-request>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'pose) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<inv-request>)))
  "Returns string type for a service object of type '<inv-request>"
  "robot/invRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'inv-request)))
  "Returns string type for a service object of type 'inv-request"
  "robot/invRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<inv-request>)))
  "Returns md5sum for a message object of type '<inv-request>"
  "8124fdf484553a52e7b685afd1f774e4")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'inv-request)))
  "Returns md5sum for a message object of type 'inv-request"
  "8124fdf484553a52e7b685afd1f774e4")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<inv-request>)))
  "Returns full string definition for message of type '<inv-request>"
  (cl:format cl:nil "geometry_msgs/Pose pose~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'inv-request)))
  "Returns full string definition for message of type 'inv-request"
  (cl:format cl:nil "geometry_msgs/Pose pose~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <inv-request>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'pose))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <inv-request>))
  "Converts a ROS message object to a list"
  (cl:list 'inv-request
    (cl:cons ':pose (pose msg))
))
;//! \htmlinclude inv-response.msg.html

(cl:defclass <inv-response> (roslisp-msg-protocol:ros-message)
  ((joints
    :reader joints
    :initarg :joints
    :type sensor_msgs-msg:JointState
    :initform (cl:make-instance 'sensor_msgs-msg:JointState)))
)

(cl:defclass inv-response (<inv-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <inv-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'inv-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name robot-srv:<inv-response> is deprecated: use robot-srv:inv-response instead.")))

(cl:ensure-generic-function 'joints-val :lambda-list '(m))
(cl:defmethod joints-val ((m <inv-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader robot-srv:joints-val is deprecated.  Use robot-srv:joints instead.")
  (joints m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <inv-response>) ostream)
  "Serializes a message object of type '<inv-response>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'joints) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <inv-response>) istream)
  "Deserializes a message object of type '<inv-response>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'joints) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<inv-response>)))
  "Returns string type for a service object of type '<inv-response>"
  "robot/invResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'inv-response)))
  "Returns string type for a service object of type 'inv-response"
  "robot/invResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<inv-response>)))
  "Returns md5sum for a message object of type '<inv-response>"
  "8124fdf484553a52e7b685afd1f774e4")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'inv-response)))
  "Returns md5sum for a message object of type 'inv-response"
  "8124fdf484553a52e7b685afd1f774e4")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<inv-response>)))
  "Returns full string definition for message of type '<inv-response>"
  (cl:format cl:nil "sensor_msgs/JointState joints~%~%~%~%================================================================================~%MSG: sensor_msgs/JointState~%# This is a message that holds data to describe the state of a set of torque controlled joints. ~%#~%# The state of each joint (revolute or prismatic) is defined by:~%#  * the position of the joint (rad or m),~%#  * the velocity of the joint (rad/s or m/s) and ~%#  * the effort that is applied in the joint (Nm or N).~%#~%# Each joint is uniquely identified by its name~%# The header specifies the time at which the joint states were recorded. All the joint states~%# in one message have to be recorded at the same time.~%#~%# This message consists of a multiple arrays, one for each part of the joint state. ~%# The goal is to make each of the fields optional. When e.g. your joints have no~%# effort associated with them, you can leave the effort array empty. ~%#~%# All arrays in this message should have the same size, or be empty.~%# This is the only way to uniquely associate the joint name with the correct~%# states.~%~%~%Header header~%~%string[] name~%float64[] position~%float64[] velocity~%float64[] effort~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'inv-response)))
  "Returns full string definition for message of type 'inv-response"
  (cl:format cl:nil "sensor_msgs/JointState joints~%~%~%~%================================================================================~%MSG: sensor_msgs/JointState~%# This is a message that holds data to describe the state of a set of torque controlled joints. ~%#~%# The state of each joint (revolute or prismatic) is defined by:~%#  * the position of the joint (rad or m),~%#  * the velocity of the joint (rad/s or m/s) and ~%#  * the effort that is applied in the joint (Nm or N).~%#~%# Each joint is uniquely identified by its name~%# The header specifies the time at which the joint states were recorded. All the joint states~%# in one message have to be recorded at the same time.~%#~%# This message consists of a multiple arrays, one for each part of the joint state. ~%# The goal is to make each of the fields optional. When e.g. your joints have no~%# effort associated with them, you can leave the effort array empty. ~%#~%# All arrays in this message should have the same size, or be empty.~%# This is the only way to uniquely associate the joint name with the correct~%# states.~%~%~%Header header~%~%string[] name~%float64[] position~%float64[] velocity~%float64[] effort~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <inv-response>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'joints))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <inv-response>))
  "Converts a ROS message object to a list"
  (cl:list 'inv-response
    (cl:cons ':joints (joints msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'inv)))
  'inv-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'inv)))
  'inv-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'inv)))
  "Returns string type for a service object of type '<inv>"
  "robot/inv")