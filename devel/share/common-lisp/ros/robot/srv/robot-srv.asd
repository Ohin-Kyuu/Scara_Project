
(cl:in-package :asdf)

(defsystem "robot-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :geometry_msgs-msg
               :sensor_msgs-msg
)
  :components ((:file "_package")
    (:file "inv" :depends-on ("_package_inv"))
    (:file "_package_inv" :depends-on ("_package"))
  ))