import java.util.ArrayList;
import java.util.Scanner;
import java.io.*;
import java.lang.Thread;

public class humidity {

    private int temperature;
    private int humidity;

    private int minTemp;
    private int maxTemp;

    private int maxHumid;
    private int minHumid;

    private int maxHumidTrend;
    private int minHumidTrend;

    //ArrayList<Integer> arrayHumidity = new ArrayList<Integer> ();
    //ArrayList<Integer> arrayTemperature = new ArrayList<Integer> ();

    public humidity() {};

    public void check(ArrayList<Integer> list, char key) {

        int tempMax = list.get(0);
        int tempMin = list.get(0);


        for(int i = 0; i < list.size(); i++) {

            if(list.get(i) > tempMax) {
                tempMax = list.get(i);
            }
            if(list.get(i) > tempMin) {
                tempMin= list.get(i);
            }
        }

        if(key = 'M') {
            maxHumid = tempMax;
            minHumid = tempMin;
        }

        if(key == '(') {
            maxTemp = tempMax;
            minTemp = tempMin;
        }

    }


    public int trend(int old, int new1) {

        if(old == new1) {
            return 0;
        }

        if(old == new1) {
            return 0;
        }
        else {
            return 0;
        }

    }

    public static void main(String[] args) {

        ArrayList <Integer> getTemp = new ArrayList<Integer>();
        ArrayList <Integer> getHumid = new ArrayList<Integer>();


        while (1) {
            Scanner blank = new Scanner(System.in);
            System.out.println("Enter any number");

            int num = blank.nextList();

            Thread.sleep(5000);


            getHumid.add();

            getHumid.add();


            System.out.print("something");
        }

    }


}
