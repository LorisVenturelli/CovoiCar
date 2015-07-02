package com.covoicar.rcdsm.manager;

import android.content.Context;
import android.util.Log;

import com.covoicar.rcdsm.models.Driver;
import com.covoicar.rcdsm.models.Trip;

import java.util.ArrayList;

import io.realm.Realm;
import io.realm.RealmResults;

/**
 * Created by rcdsm on 25/06/15.
 */

/**
 * TripManager is Utils for the Trip
 * Used for register information inside Realm
 */
public class TripManager {

    protected Realm realm;
    private static ArrayList<Trip> listTrip;

    public TripManager(Context context){
        realm = Realm.getInstance(context);

        if(!isPopulated()){
            Log.d("TripManager", "Created");
        }else{
            Log.d("TripManager","Display");
        }
    }

    /**
     *
     * @return an ArrayList content all Trip
     */
    public ArrayList<Trip> allListTrip(){
        ArrayList<Trip> items = new ArrayList<Trip>();
        RealmResults<Trip> results = realm.where(Trip.class).findAll();
        for(Trip travel : results){
            items.add(travel);
        }
        return items;
    }


    /**
     *
     * @return true if Trip is not null
     */
    //Verifie si il y a un resultat dans realm
    public boolean isPopulated(){
        return realm.where(Trip.class).findAll().size()>0;
    }


    /**
     * Add travel inside realm
     */
    public void addTravel(Trip valueTrip){
        try{
            realm.beginTransaction();
            Log.e("DEBUT DE LA TRANSACTION", "ADDTRAVEL :OK");

            Trip travel = realm.createObject(Trip.class);

            travel.setId(valueTrip.getId());
            travel.setStart(valueTrip.getStart());
            travel.setArrival(valueTrip.getArrival());
            travel.setHighway(valueTrip.getHighway());
            travel.setRoundTrip(valueTrip.getRoundTrip());
            travel.setDateStart(valueTrip.getDateStart());
            travel.setHoursStart(valueTrip.getHoursStart());
            travel.setDateTimeStart(valueTrip.getDateTimeStart());
            travel.setComment(valueTrip.getComment());
            travel.setPlace(valueTrip.getPlace());
            travel.setPrice(valueTrip.getPrice());
            if(Integer.parseInt(valueTrip.getRoundTrip())==1){
                travel.setDateArrival(valueTrip.getDateArrival());
                travel.setHoursArrival(valueTrip.getHoursArrival());
                travel.setDateTimeReturn(valueTrip.getDateTimeReturn());
            }
        }catch (Exception e){
            Log.e("Realm Error", "error"+e);
        } finally {
            realm.commitTransaction();
            Log.e("FIN DE LA TRANSACTION", "ADDTRAVEL :OK");
        }
    }


    /**
     *
     * @return return Trip with id
     */
    public Trip getTripWithId(long id){
        return realm.where(Trip.class).equalTo("id", id).findFirst();
    }


    /**
     * @return driver with id
     */
    public Driver getDriverWithId(long idDriver){
        RealmResults<Driver> results = realm.where(Driver.class).findAll();
        Driver myDriver = new Driver();
        for(Driver driver : results)
        {
            if(driver.getId() == idDriver)
            {
                myDriver = driver;
            }
        }
        return myDriver;
    }

}
