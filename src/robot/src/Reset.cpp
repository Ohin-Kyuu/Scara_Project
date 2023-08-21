#include "ros/ros.h"
#include "std_msgs/Bool.h"

int main(int argc, char **argv)
{
    ros::init(argc, argv, "Reset");
    ros::NodeHandle nh;
    ros::Publisher pub = nh.advertise<std_msgs::Bool>("Reset", 10);
    ros::Rate rate(100);
    bool rest = false;
    while(ros::ok){
        std::cout << "Reset? ";
        std::cin >> rest;
        std_msgs::Bool msg;
        msg.data = rest;
        pub.publish(msg);
        rate.sleep();
    }
    return 0;
}