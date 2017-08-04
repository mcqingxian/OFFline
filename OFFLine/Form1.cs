using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }


        /// <summary>
        /// 获得物体在手机屏幕中的Y坐标，单位为厘米(cm)
        /// </summary>
        /// <param name="length">手机屏幕长度，单位为厘米(cm)</param> 
        /// <param name="width">手机屏幕宽度，单位为厘米(cm)</param>
        /// <param name="focus">手机摄像头等效焦距，单位为毫米(mm)，例如iPhone5s的等效焦距为30 mm，iPhone6和iPhone6Plus的等效焦距为29 mm</param> 
        /// <param name="distance">物体与手机的垂直距离，单位为米(m)</param> 
        /// <param name="phoneHeight">手机所在位置海拔高度，单位为米(m)</param> 
        /// <param name="objectHeight">物体海拔高度，单位为米(m)</param> 
        /// <param name="angle">手机与水平面的倾斜角，单位为度，向上倾斜为正数，向下倾斜为负数</param> 
        /// <param name="horLabel">手机横向放置时为1，手机竖向放置时为0</param> 
        /// <returns>返回-1时，表示物体不在手机的视角范围</returns>
        public double getYCoordinate(double length, double width, double focus, double distance, double phoneHeight, double objectHeight, double angle, double horLabel)
        {
            angle = (angle * Math.PI) / 180; //角度转化为弧度

            double visualAngle = 0;

            if (horLabel == 1)   //手机横向放置时
            {
                visualAngle = 2 * Math.Atan(24 / (2 * focus));
                           
                if (angle >= 0) //手机向上倾斜时
                {
                    if (angle - visualAngle / 2 >= Math.PI / 2)
                        return -1;

                    double maxy = phoneHeight + distance * Math.Tan(visualAngle / 2 + angle);

                    if (visualAngle / 2 + angle >= Math.PI / 2)
                        maxy = double.MaxValue;

                    double miny = phoneHeight + distance * Math.Tan(angle - visualAngle / 2);

                    if (miny > objectHeight)
                        return -1;
                    else
                    {
                        if (maxy <= objectHeight)
                            return 0;
                        else
                            return width - ((objectHeight - miny) / (maxy - miny)) * width;
                    }
                }
                else
                {
                    if (angle * (-1) - visualAngle / 2 >= Math.PI / 2)
                        return -1;

                    double maxy = phoneHeight - distance * Math.Tan(angle * (-1) - visualAngle / 2);

                    double miny = phoneHeight - distance * Math.Tan(angle * (-1) + visualAngle / 2);

                    if (angle * (-1) + visualAngle / 2 >= Math.PI / 2)
                        miny = double.MinValue;

                    if (maxy < 0)
                        return -1;
                    else
                    {
                        if (maxy <= objectHeight)
                            return 0;
                        else
                            return ((maxy - objectHeight) / (maxy - miny)) * width;
                    }
                }
            }
            else
            {
                visualAngle = 2 * Math.Atan(36 / (2 * focus)); //手机竖向放置时

                if (angle >= 0) //手机向上倾斜时
                {
                    if (angle - visualAngle / 2 >= Math.PI / 2)
                        return -1;

                    double maxy = phoneHeight + distance * Math.Tan(visualAngle / 2 + angle);

                    if (visualAngle / 2 + angle >= Math.PI / 2)
                        maxy = double.MaxValue;

                    double miny = phoneHeight + distance * Math.Tan(angle - visualAngle / 2);

                    if (miny > objectHeight)
                        return -1;
                    else
                    {
                        if (maxy <= objectHeight)
                            return 0;
                        else
                            return length - ((objectHeight - miny) / (maxy - miny)) * length;
                    }
                }
                else
                {
                    if (angle * (-1) - visualAngle / 2 >= Math.PI / 2)
                        return -1;

                    double maxy = phoneHeight - distance * Math.Tan(angle * (-1) - visualAngle / 2);

                    double miny = phoneHeight - distance * Math.Tan(angle * (-1) + visualAngle / 2);

                    if (angle * (-1) + visualAngle / 2 >= Math.PI / 2)
                        miny = double.MinValue;

                    if (maxy < 0)
                        return -1;
                    else
                    {
                        if (maxy <= objectHeight)
                            return 0;
                        else
                            return ((maxy - objectHeight) / (maxy - miny)) * length;
                    }
                }
            }
        }

        /// <summary>
        /// 获得物体在手机屏幕中的X坐标，单位为厘米(cm)
        /// </summary>
        /// <param name="length">手机屏幕长度，单位为厘米(cm)</param> 
        /// <param name="width">手机屏幕宽度，单位为厘米(cm)</param>
        /// <param name="focus">手机摄像头等效焦距，单位为毫米(mm)，例如iPhone5s的等效焦距为30 mm，iPhone6和iPhone6Plus的等效焦距为29 mm</param> 
        /// <param name="rotAngle">手机与物体的夹角，单位为度，例如如果物体在手机正前方，度数为0；如果物体在手机的正前方偏右30度，就为正30度；如果物体在手机的正前方偏左30度，就为负30度</param> 
        /// <param name="horLabel">手机横向放置时为1，手机竖向放置时为0</param> 
        /// <returns>返回-1时，表示物体不在手机的视角范围</returns>
        public double getXCoordinate(double length, double width, double focus, double rotAngle, double horLabel)
        {
            rotAngle = (rotAngle * Math.PI) / 180; //角度转化为弧度

            double visualAngle = 0;

            if (horLabel == 1)   //手机横向放置时
            {
                visualAngle = 2 * Math.Atan(36 / (2 * focus));

                if (Math.Abs(rotAngle) > visualAngle / 2)
                    return -1;
                else
                    return ((visualAngle / 2 + rotAngle) / visualAngle) * length;                                         
            }
            else
            {
                visualAngle = 2 * Math.Atan(24 / (2 * focus)); //手机竖向放置时

                if (Math.Abs(rotAngle) > visualAngle / 2)
                    return -1;
                else
                    return ((visualAngle / 2 + rotAngle) / visualAngle) * width;  

            }
        }

        /// <summary>
        /// 获得物体在手机屏幕中的占比
        /// </summary>
        /// <param name="focus">手机摄像头等效焦距，单位为毫米(mm)，例如iPhone5s的等效焦距为30 mm，iPhone6和iPhone6Plus的等效焦距为29 mm</param> 
        /// <param name="distance">物体与手机的垂直距离，单位为米(m)</param> 
        /// <param name="phoneHeight">手机所在位置海拔高度，单位为米(m)</param> 
        /// <param name="objectHeight">物体海拔高度，单位为米(m)</param> 
        /// <param name="angle">手机与水平面的倾斜角，单位为度，向上倾斜为正数，向下倾斜为负数</param> 
        /// <param name="horLabel">手机横向放置时为1，手机竖向放置时为0</param> 
        /// <param name="maxPercent">设定占比最大限制值</param> 
        /// <returns>返回0时，表示物体不在手机的视角范围</returns>
        public double getPercent(double focus, double distance, double phoneHeight, double objectHeight, double angle, double horLabel, double maxPercent)
        {
            angle = (angle * Math.PI) / 180; //角度转化为弧度

            double visualAngle = 0;

            if (horLabel == 1)   //手机横向放置时
            {
                visualAngle = 2 * Math.Atan(24 / (2 * focus));

                if (angle >= 0) //手机向上倾斜时
                {
                    if (angle - visualAngle / 2 >= Math.PI / 2)
                        return 0;

                    double maxy = phoneHeight + distance * Math.Tan(visualAngle / 2 + angle);

                    if (visualAngle / 2 + angle >= Math.PI / 2)
                        maxy = double.MaxValue;

                    double miny = phoneHeight + distance * Math.Tan(angle - visualAngle / 2);

                    if (miny > objectHeight)
                        return 0;
                    else
                    {
                        if (maxy <= objectHeight && miny >= 0)
                            return maxPercent;
                        else
                        {
                            double newmaxy = Math.Min(objectHeight, maxy);

                            double newminy = Math.Max(0, miny);

                            return ((newmaxy - newminy) / (maxy - miny)) * maxPercent;
                        }
                    }
                }
                else
                {
                    if (angle * (-1) - visualAngle / 2 >= Math.PI / 2)
                        return 0;

                    double maxy = phoneHeight - distance * Math.Tan(angle * (-1) - visualAngle / 2);

                    double miny = phoneHeight - distance * Math.Tan(angle * (-1) + visualAngle / 2);

                    if (angle * (-1) + visualAngle / 2 >= Math.PI / 2)
                        miny = double.MinValue;

                    if (maxy < 0)
                        return 0;
                    else
                    {
                        if (maxy <= objectHeight && miny >= 0)
                            return maxPercent;
                        else
                        {
                            double newmaxy = Math.Min(objectHeight, maxy);

                            double newminy = Math.Max(0, miny);

                            return ((newmaxy - newminy) / (maxy - miny)) * maxPercent;
                        }
                    }
                }
            }
            else
            {
                visualAngle = 2 * Math.Atan(36 / (2 * focus)); //手机竖向放置时

                if (angle >= 0) //手机向上倾斜时
                {
                    if (angle - visualAngle / 2 >= Math.PI / 2)
                        return 0;

                    double maxy = phoneHeight + distance * Math.Tan(visualAngle / 2 + angle);

                    if (visualAngle / 2 + angle >= Math.PI / 2)
                        maxy = double.MaxValue;

                    double miny = phoneHeight + distance * Math.Tan(angle - visualAngle / 2);

                    if (miny > objectHeight)
                        return 0;
                    else
                    {
                        if (maxy <= objectHeight && miny >= 0)
                            return maxPercent;
                        else
                        {
                            double newmaxy = Math.Min(objectHeight, maxy);

                            double newminy = Math.Max(0, miny);

                            return ((newmaxy - newminy) / (maxy - miny)) * maxPercent;
                        }
                    }
                }
                else
                {
                    if (angle * (-1) - visualAngle / 2 >= Math.PI / 2)
                        return 0;

                    double maxy = phoneHeight - distance * Math.Tan(angle * (-1) - visualAngle / 2);

                    double miny = phoneHeight - distance * Math.Tan(angle * (-1) + visualAngle / 2);

                    if (angle * (-1) + visualAngle / 2 >= Math.PI / 2)
                        miny = double.MinValue;

                    if (maxy < 0)
                        return 0;
                    else
                    {
                        if (maxy <= objectHeight && miny >= 0)
                            return maxPercent;
                        else
                        {
                            double newmaxy = Math.Min(objectHeight, maxy);

                            double newminy = Math.Max(0, miny);

                            return ((newmaxy - newminy) / (maxy - miny)) * maxPercent;
                        }
                    }
                }
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {          
            double y = getYCoordinate(15, 8, 30, 3, 1.4, 1, 10, 1);
            
            double x = getXCoordinate(15, 8, 30, 25, 1);

            double percent = getPercent(30, 3, 1.4, 1, 10, 1, 0.5);
        }
    }
}
