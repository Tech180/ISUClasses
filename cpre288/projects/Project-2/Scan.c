#include "Scan.h"


void scan_init()
{
    uart_init();
    ping_init();
    adc_init();
    servo_init();
}

/**
 * Takes in an angle and scans that particular point
 *
 */
void scan(int angle, Scan_data *data)
{
    int raw = 0;
    int i = 0;

    servo_move(angle);
    data->sound_dist = ping_getDistance();

    for(i = 0; i < 64; i++)
    {
        raw += adc_read();
    }
    raw = raw / 64;

    int distance = 97397* pow(raw, -1.141);
    data->IR_raw_val = distance;

   // For testing purposes
    char str[200];
    sprintf(str, "%d\t%f\t%d\n\r", angle, data->sound_dist, data->IR_raw_val);
    uart_sendStr(str);
    timer_waitMillis(75);

}

int findObjects(Object_data objects[], int sizeOfObject)
{
    int i = 0;
    int objectNum = 0;
    int widthAngle = 0;
    int startingAngle = 0;
    double distance = 0;
    //bool errorPoint = false;
    Scan_data *data;
    Scan_data point;
    data = &point;
    Scan_data *data2;
    Scan_data point2;
    data2 = &point2;

    for(i = 0; i <= 180; i = i + 2)
    {
        // Scan until an object is found
        timer_waitMillis(25);
        scan(i, data);


        // Object has been found
        if(data->IR_raw_val < 200 && objectNum < sizeOfObject && (data->IR_raw_val <= (int)data->sound_dist + 5) &&
                (data->IR_raw_val >= (int)data->sound_dist - 5))
        {

            widthAngle = 0;
            distance = data->sound_dist;

            startingAngle = i;
            //
            while(((data->IR_raw_val <= (int)distance + 10 && data->IR_raw_val >= (int)distance - 10) ||
                     (data2->IR_raw_val <= (int)distance + 10 && data2->IR_raw_val >= (int)distance - 10)) && i <= 180)
            {
                timer_waitMillis(25);
                scan(i, data);
                widthAngle += 2;
                scan(i + 1, data2);
                i += 2;

            }

            // Update values
            if(widthAngle > 2)
            {
                widthAngle--;
            }

            if(widthAngle > 1 || distance > 50)
            {
                objectNum++;
                objects[objectNum - 1].distance = distance;
                objects[objectNum - 1].width = 2 * 3.1415926 * distance * ((double)(widthAngle) / 360);
                objects[objectNum - 1].angle = startingAngle + ((widthAngle)  / 2);
            }

        }
    }

    servo_move(90);

    return objectNum;
}

