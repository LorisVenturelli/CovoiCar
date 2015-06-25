package com.covoicar.rcdsm.models;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/**
 * Created by rcdsm on 25/06/15.
 */
public class Trip extends RealmObject  {

    @PrimaryKey
    private long     id;

    private String start;
    private User driver;
    private String arrival;
    private String highway;
    private String roundTrip;
    private String dateStart;
    private String dateArrival;
    private String hoursStart;
    private String hoursArrival;
    private int price;
    private int place;
    private String comment;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getStart() {
        return start;
    }

    public void setStart(String start) {
        this.start = start;
    }

    public String getArrival() {
        return arrival;
    }

    public void setArrival(String arrival) {
        this.arrival = arrival;
    }

    public User getDriver() {
        return driver;
    }

    public void setDriver(User driver) {
        this.driver = driver;
    }

    public String getHighway() {
        return highway;
    }

    public void setHighway(String highway) {
        this.highway = highway;
    }

    public String getRoundTrip() {
        return roundTrip;
    }

    public void setRoundTrip(String roundTrip) {
        this.roundTrip = roundTrip;
    }

    public String getHoursStart() {
        return hoursStart;
    }

    public void setHoursStart(String hoursStart) {
        this.hoursStart = hoursStart;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getPlace() {
        return place;
    }

    public void setPlace(int place) {
        this.place = place;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getHoursArrival() {
        return hoursArrival;
    }
    public void setHoursArrival(String hoursArrival) {
        this.hoursArrival = hoursArrival;
    }

    public String getDateStart() {
        return dateStart;
    }

    public void setDateStart(String dateStart) {
        this.dateStart = dateStart;
    }

    public String getDateArrival() {
        return dateArrival;
    }

    public void setDateArrival(String dateArrival) {
        this.dateArrival = dateArrival;
    }

}
