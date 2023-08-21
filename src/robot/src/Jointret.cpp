#include "ros/ros.h"
#include "std_msgs/Int64.h"

int main(int argc, char **argv)
{
    ros::init(argc, argv, "Jointret");
    ros::NodeHandle nh;
    ros::Publisher pub = nh.advertise<std_msgs::Int64>("stm32", 10);
    ros::Rate rate(100);
    int Jret = 0;
    while(ros::ok){
        std::cout << "Jointstate:";
        std::cin >> Jret;
        std_msgs::Int64 Jmsg;
        for(int i=0; i<=10; i++){
            Jmsg.data = Jret;
            pub.publish(Jmsg);
            rate.sleep();
        }
    }
    return 0;
}
