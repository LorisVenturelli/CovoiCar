package com.covoicar.rcdsm.models;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;
import io.realm.annotations.RealmClass;

/**
 * Created by rcdsm on 25/06/15.
 */
@RealmClass
public class Trip extends RealmObject  {

    @PrimaryKey
    private long     id;

    private String start;
    private int idDriver;
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
    private String distance;
    private String duration;
    private String dateTimeStart;
    private String dateTimeReturn;
    private int placeAvailable;
    private User driver;

    public int getPlaceAvailable() {
        return placeAvailable;
    }

    public void setPlaceAvailable(int placeAvailable) {
        this.placeAvailable = placeAvailable;
    }

    public int getIdDriver() {
        return idDriver;
    }

    public void setIdDriver(int idDriver) {
        this.idDriver = idDriver;
    }

    public String getDateTimeReturn() {
        return dateTimeReturn;
    }

    public void setDateTimeReturn(String dateTimeReturn) {
        this.dateTimeReturn = dateTimeReturn;
    }

    public String getDateTimeStart() {
        return dateTimeStart;
    }

    public void setDateTimeStart(String dateTimeStart) {
        this.dateTimeStart = dateTimeStart;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getDistance() {
        return distance;
    }

    public void setDistance(String distance) {
        this.distance = distance;
    }

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

        public User getDriver() {
            return driver;
        }

       public void setDriver(User driver) {
        driver.setBirthday(driver.getBirthday());
        driver.setBio(driver.getBio());
        driver.setId(driver.getId());
        driver.setPhone(driver.getPhone());
        driver.setEmail(driver.getEmail());
        driver.setFirstName(driver.getFirstName());
        driver.setLastName(driver.getLastName());
        driver.setGender(driver.getGender());
    }

}
