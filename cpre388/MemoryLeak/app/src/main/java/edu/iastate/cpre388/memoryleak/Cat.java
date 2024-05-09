package edu.iastate.cpre388.memoryleak;

public class Cat {
    public String name;
    public int age;
    public String color;

    public Cat(String name, int age, String color) {
        this.name = name;
        this.age = age;
        this.color = color;
        BagOfCats.bag.add(this);
    }
}
