###### tags: `HungPin` `SCARA` `V3`

{%hackmd hackmd-dark-theme %}
# III.  <font color="#FFF">Version 3</font>
第3個版本，已經可以達成了全部任務(夾取隨機座標的三個方塊，並依序疊起在指定座標)
* 因為機構已經確定完成了，所以將機器的預設值(手臂的長度、高度、初始角度)，全部都在程式中進行了最後的調整
* 最主要與第2個版本的差別是，為了達成手臂的分組動作，原先是以STM端發送一個變數的不同訊息達成 **(msg=0, 1, 2, 3...)**
而為了解決一些問題，更改了訊息的發送方式為僅發送0或1 **(msg= 0, 1)**

## <font color="#FFC300">程式架構</font>
![](https://hackmd.io/_uploads/HyzaROLY3.png)
-
相較之前，這裡把 **STM** 端包含機構的部分全部寫出來，以表示完整的系統架構

<font color="#FFC300">**解釋：**</font>
　　在 **ROS** 端以 **Raspberry Pi4** 作為主要控制機器人的平台，運行主程式並處理方塊的定位，以逆向運動學轉換方塊座標至手臂各關節的角度，再透過 **USB to TTL** 和 **STM** 上的手臂控制系統進行通訊，用來控制步進馬達、吸盤並回傳手臂狀態給 **ROS** 端。在需要 **Reset** 時，以 **ROS** 端的 **Reset Node** 發布消息到主程式，以同樣通訊方式至 **STM** 端進行控制，並在碰到限位開關時歸零步進馬達控制的步數。
##  <font color="#FFC300">Service 程式</font>
**Service** 程式在``兩個地方``做了些微改動，因為想極大化手臂的可運動範圍，所以透過測量了手臂y在哪些座標範圍內可以運動而不會打到本身，最後測出約在 **y=125**為界線，手臂需要分別呈現不同姿態，即可達到最大工作範圍
```python
    if(x > 0 and y < 125):
        ##First Solution 手臂開口向左
        q2 = -math.atan2(math.sqrt(1 - D**2), D)
        q1 = np.arctan2(y, x) - np.arctan2(a2*math.sin(q2), (a1 + a2*math.cos(q2)))
    elif(x >= 0 and y >= 125):
        ##Second Solution 手臂開口向右
        q2 = math.atan2(math.sqrt(1-D**2), D)
        q1 = np.arctan2(y, x) - np.arctan2(a2*math.sin(q2), (a1 + a2*math.cos(q2)))
    d3 = ((h0 + a0 - z)*0.26)*360
```
以下是手臂的姿態簡易圖，經過量測，當下臂接上臂的軸超過Y=125，即可將手臂向開口向右以達最大工作範圍而不會打到自己

![](https://hackmd.io/_uploads/ryuquFUKh.png)
-
最後就是更改第一個版本中的手臂實際長度及高度
```python
# a0 + a1 are the lengths of the two segments of link1, 
# a2 is the length of link2
# h0 is the base cylinder offset
a1 = 160
a2 = 185
a0 = 126
h0 = 80
```

##  <font color="#FFC300">主程式</font>
在先前版本中，回傳的方式會出現以下的問題：
* 如果指使用一個變數，並保持通訊，在 **STM** 端會沒辦法僅以一個變數同時做到，因為要在手臂動作結束時增加變數的值，但該值又要保持通訊而放在迴圈中
* 當然也可以以傳統方式不要一直保持通訊，以　**delay publish** 的時間來解決，但這樣會比較容易發生丟包問題
舉例來說，當第一個關節因為丟包問題，在第**90**筆才收到資料，剛開始運動，第二個關節卻在 **delay** 後很快收到第**10**筆訊息，但由於第一個關節還沒完成動作，就有可能會導致機器本體被撞到

所以以下介紹了我們最終想到的解法，不僅解決上述問題，還可以極大化機器的流暢度：
* 改良過後，STM端不需要回傳多個手臂姿態，僅需回傳 **SCARA** 手臂目前的運動狀態，當有馬達運作時回傳 **「1」**，完全靜止則回傳 **「0」**，因此回傳的值會成為方波的形式。在ROS端，Callback Function增加了一個判斷STM端手臂的運動狀態(scara_state)透過檢測從1到0的瞬間，ROS端即可判定動作的完成與否，並進行下一個關節的發布，而完整的寫出所有關節動作的劇本，就能完成一套動作。另外，當機器需要進行Reset時，也是從ROS端進行「軟重置」，依序收回各關節，通訊的邏輯也與進行任務時相同，僅改變角度為0而已

![](https://hackmd.io/_uploads/r1wF4tIt2.png)
-
> 　　這樣的解法，看似只有檢測從1變0的瞬間，但實際上，因為是一直保持通訊的，所以就算晚接收到0，值都會從1轉為0，就能確保動作完成，並解決了丟包問題的影響


而初始角度的問題，為求方便，我直接放在主程式中，統一增加初始角度至Service response的值
```cpp
msg1.data = srv.response.joints.position[0] * 180 / M_PI + 91;
msg2.data = srv.response.joints.position[1] * 180 / M_PI + 148;
```

:::info
**完整主程式**
:::spoiler
```cpp=
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
    if (num_calls <= 0) {
        return;
    }
    num_calls--;
    k++;
    std::cout << "Running for Point " << k + 1 << "\n";
    c = c + 60;
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
                if (i == 100) {
                    i = 0;
                    st++;
                    msg3_up = true;
                    // Wait for 1s catching the block
                    ros::Duration(1.0).sleep();
                }
            } else if (st == 4) {
                // Finsh Catching and Rise Joint3 up
                if (msg3_up) {
                    msg3.data -= 2000;
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
                    service(0, 100, c);
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
                if (i == 100) {
                    i = 0;
                    st = 0;
                    ros::Duration(1.0).sleep();
                    break;
                }
            } else {
                ros::Duration(1.0).sleep();
                ROS_WARN("Error!!! State Unexpected...");
                break;
            }
            rate2.sleep();
        } else {
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

```
:::