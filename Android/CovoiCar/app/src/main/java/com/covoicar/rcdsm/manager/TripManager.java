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

    public ArrayList<Trip> allListTrip(){
        ArrayList<Trip> items = new ArrayList<Trip>();
        RealmResults<Trip> results = realm.where(Trip.class).findAll();
        for(Trip travel : results){
            items.add(travel);
        }
        return items;
    }

    //Verifie si il y a un resultat dans realm
    public boolean isPopulated(){
        return realm.where(Trip.class).findAll().size()>0;
    }

    /*public void clear(){
        realm.beginTransaction();
        RealmResults<Trip> results = realm.where(Trip.class).findAll();
        results.clear();
        realm.commitTransaction();
    }*/

    /*public void clearOneItem(long id){
        realm.beginTransaction();
        Trip results = realm.where(Trip.class).equalTo("id", id).findFirst();
        results.removeFromRealm();
        realm.commitTransaction();

        ClientAPI.getInstance().deleteNote(id,new ClientAPI.APIListener() {
            @Override
            public void callback() {
            }
        });
    }*/

    /*public void modificated(long id,Trip valueNote){
        realm.beginTransaction();
        Trip results = realm.where(Trip.class).equalTo("id", id).findFirst();
        results.setTitle(valueNote.getTitle());
        results.setContent(valueNote.getContent());
        results.setUpdated_at(new Date());
        realm.commitTransaction();
    }*/

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

    public Trip getTripWithId(long id){

        return realm.where(Trip.class).equalTo("id", id).findFirst();

    }

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


    public void addUserDriver(Trip valueTrip){
        try{
            realm.beginTransaction();
            Trip travel = realm.copyToRealmOrUpdate(valueTrip);
            travel.setUserDriver(valueTrip.getUserDriver());
        }catch (Exception e){
            Log.e("Realm Error", "error"+e);
        } finally {
            realm.commitTransaction();
        }
    }
}
