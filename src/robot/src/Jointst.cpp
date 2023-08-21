#include "ros/ros.h"
#include "std_msgs/Int64.h"

int stnum = 0;

void Callback(const std_msgs::Int64::ConstPtr& Jmsg)
{
    if(Jmsg->data == 0){
        stnum = 0;
    }else if(Jmsg->data == 1){
        stnum = 1;
    }
}


int main(int argc, char **argv)
{
    ros::init(argc, argv, "Jointst");
    ros::NodeHandle nh;
    ros::Publisher pub = nh.advertise<std_msgs::Int64>("Jointstate", 10);
    ros::Subscriber sub = nh.subscribe("stm32", 10, Callback);
    ros::Rate rate(100);
    std_msgs::Int64 msg;
    
    while(ros::ok())
    {
        ros::spinOnce();
        msg.data = stnum;
        ROS_INFO("%ld", msg.data);
        pub.publish(msg);
        rate.sleep();
    }
    return 0;
}

