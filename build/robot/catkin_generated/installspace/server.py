#!/usr/bin/env python3 	

from robot.srv import inv, invResponse
import rospy
import numpy as np
import math
from sensor_msgs.msg import JointState

# a0 + a1 are the lengths of the two segments of link1, 
# a2 is the length of link2
# h0 is the base cylinder offset
a1 = 163.5
a2 = 181
a0 = 126
h0 = 100

def handle_inverse_kin(req):
    x = req.pose.position.x
    y = req.pose.position.y
    z = req.pose.position.z

    D = ((x**2)+(y**2)-(a1**2)-(a2**2))/(2*a1*a2)
    print(D, x, y, z)
    if(x > 0 and y <= 125):
        ##First Solution
        q2 = -math.atan2(math.sqrt(1 - D**2), D)
        q1 = np.arctan2(y, x) - np.arctan2(a2*math.sin(q2), (a1 + a2*math.cos(q2)))
        d3 = (((h0 + a0 - z)*0.25)*360)-980
    elif(y > 125):
        ##Second Solution
        q2 = math.atan2(math.sqrt(1-D**2), D)
        q1 = np.arctan2(y, x) - np.arctan2(a2*math.sin(q2), (a1 + a2*math.cos(q2)))
        d3 = (((h0 + a0 - z)*0.25)*360)-300
    

    print("Output:")
    print('%f, %f, %f' % (q1*180/math.pi+90.5, q2*180/math.pi+151, d3))
    joints = JointState()
    joints.name = ["joint1", "joint2", "joint3"]
    joints.position = [q1, q2, d3]
    return joints

def inv_kin_server():
    rospy.init_node('server')
    s = rospy.Service('inv', inv, handle_inverse_kin)
    print("Inverse Kinematics: ")
    rospy.spin()

if __name__ == "__main__":
    inv_kin_server()
