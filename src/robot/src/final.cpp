#include <ros/ros.h>
#include <robot/inv.h>
#include <geometry_msgs/Pose.h>
#include <std_msgs/Int64.h>
#include <std_msgs/Float64.h>
#include <std_msgs/Bool.h>
#include <iostream>

float arr[10][2];

int num_calls = 0; // items(block) number
int st = 0; // define the joint state
int last_st = 0;
int c = 0;

int i = 0; // msg4_count
int k = -1;
int mx_stc = 1; // max_st_count

bool msg3_up = false;
bool req_st = false;
bool reset = false;

std_msgs::Float64 msg1, msg2, msg3;
std_msgs::Int64 msg4;

void service(float a, float b, float c);
void client();

void Callback(const std_msgs::Int64::ConstPtr& msg)
{
    if (!reset && msg->data == 1) {
        last_st = 1;
    } else if (!reset && msg->data == 0 && msg->data != last_st) {
        st++;
        last_st = 0;
    }
    
    if (reset && msg->data == 1) {
        last_st = 1;
    } else if (reset && msg->data == 0 && msg->data != last_st) {
        st--;
        last_st = 0;
    }
}

void Reset(const std_msgs::Bool::ConstPtr& msg)
{
    if (msg->data) {
        msg1.data = 0;
        msg2.data = 0;
        msg3.data = 0;
        msg4.data = 0;
        st = 4;
        reset = true;
    }
}

void callsrv()
{
    st = 0;
    if (num_calls <= 0) {
        exit(1);
    }
    num_calls--;
    k++;
    std::cout << "Running for Point " << k + 1 << "\n";
    c = c + 68;
    service(arr[k][0], arr[k][1], 60);
}


void service(float a, float b, float c)
{
    ros::NodeHandle nh;
    ros::ServiceClient inv_client = nh.serviceClient<robot::inv>("/inv");
    robot::inv srv;
    geometry_msgs::Pose req;

    req.position.x = a;
    req.position.y = b;
    req.position.z = c;
    srv.request.pose = req;

    if (inv_client.call(srv)) {
        msg1.data = srv.response.joints.position[0] * 180 / M_PI + 91;
        msg2.data = srv.response.joints.position[1] * 180 / M_PI + 148;
        msg3.data = srv.response.joints.position[2];
        client();
    } else {
        ROS_WARN("Service call failed");
    }
}

void client()
{
    ros::NodeHandle nh;
    ros::Subscriber sub1 = nh.subscribe("Jointstate", 10, Callback);
    ros::Subscriber sub2 = nh.subscribe("Reset", 10, Reset);

    ros::Publisher pub1 = nh.advertise<std_msgs::Float64>("joint1", 10);
    ros::Publisher pub2 = nh.advertise<std_msgs::Float64>("joint2", 10);
    ros::Publisher pub3 = nh.advertise<std_msgs::Float64>("joint3", 10);
    ros::Publisher pub4 = nh.advertise<std_msgs::Int64>("suckinfo", 10);

    ros::Rate rate(30);
    ros::Rate rate2(100);

    while (ros::ok) {
        ros::spinOnce();
        ros::spinOnce();
        if (!reset) {
            if (st == 0) {
                // Move Joint1
                ROS_INFO("%f", msg1.data);
                pub1.publish(msg1);
                rate.sleep();
            } else if (st == 1) {
                // Joint1 finish, Move Joint2
                ROS_INFO("%f", msg2.data);
                pub2.publish(msg2);
                rate.sleep();
            } else if (st == 2) {
                // Joint2 finish, Move Joint3
                ROS_INFO("%f", msg3.data);
                pub3.publish(msg3);
                rate.sleep();
            } else if (st == 3) {
                // Joint3 finish, Open Sucker
                i++;
                msg4.data = 1;
                ROS_INFO("%ld", msg4.data);
                pub4.publish(msg4);
                rate.sleep();
                if (i >= 100) {
                    i = 0;
                    st++;
                    msg3_up = true;
                    // Wait for 1s catching the block
                    ros::Duration(1.0).sleep();
                }
            } else if (st == 4) {
                // Finsh Catching and Rise Joint3 up
                if (msg3_up) {
                    msg3.data = 1000;
                    msg3_up = false;
                    req_st = true;
                }
                ROS_INFO("%f", msg3.data);
                pub3.publish(msg3);
                rate.sleep();
            } else if (st == 5) {
                // Joint3 up finsh and req srv for placing the block
                if (req_st) {
                    req_st = false;
                    service(150, -250, c);
                }
                ROS_INFO("%f, %f", msg1.data, msg2.data);
                pub1.publish(msg1);
                pub2.publish(msg2);
                rate.sleep();
            } else if (st == 6) {
                ROS_INFO("%f", msg3.data);
                pub3.publish(msg3);
                rate.sleep();
            } else if (st == 7) {
                i++;
                msg4.data = 0;
                ROS_INFO("%ld", msg4.data);
                pub4.publish(msg4);
                rate.sleep();
                if (i >= 100) {
                    i = 0;
                    st++;
                    ros::Duration(1.0).sleep();
                }
            } else if(st == 8) {
                msg3.data = 1000;
                ROS_INFO("%f", msg3.data);
                pub3.publish(msg3);
                rate.sleep();
            } else if(st == 9){
                break;
            }
            else {
                ros::Duration(1.0).sleep();
                ROS_WARN("Error!!! State Unexpected...");
                break;
            }
            rate2.sleep();
        } else {
            c = c - 68;
            if (st == 4) {
                i++;
                ROS_INFO("%ld", msg4.data);
                pub4.publish(msg4);
                rate.sleep();
                if (i == 100) {
                    i = 0;
                    st--;
                    ros::Duration(1.0).sleep();
                }
            } else if (st == 3) {
                ROS_INFO("%f", msg3.data);
                pub3.publish(msg3);
                rate.sleep();
            } else if (st == 2) {
                ROS_INFO("%f", msg2.data);
                pub2.publish(msg2);
                rate.sleep();
            } else if (st == 1) {
                ROS_INFO("%f", msg1.data);
                pub1.publish(msg1);
                rate.sleep();
            } else if (st == 0) {
                ros::Duration(1.0).sleep();
                ROS_WARN("RESET COMPLETE");
                reset = false;
                break;
            }
        }
    }
    callsrv();
}

int main(int argc, char **argv)
{
    ros::init(argc, argv, "mainode");
    std::cout << "Times of Calls:";
    std::cin >> num_calls;
    for (int m = 0; m < num_calls; m++) {
        std::cout << "Point " << m + 1 << "\n";
        for (int n = 0; n < 2; n++) {
            std::cin >> arr[m][n];
        }
    }
    callsrv();
    return 0;
}
