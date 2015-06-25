package com.covoicar.rcdsm.manager;

import android.content.Context;
import android.util.Log;

import com.covoicar.rcdsm.models.Trip;

import io.realm.Realm;

/**
 * Created by rcdsm on 25/06/15.
 */
public class TripManager {

    protected Realm realm;

    public TripManager(Context context){
        realm = Realm.getInstance(context);

        if(!isPopulated()){
            Log.d("TripManager", "Created");
        }else{
            Log.d("TripManager","Display");
        }
    }

    /*public ArrayList<Trip> allListNote(){
        ArrayList<Trip> items = new ArrayList<Trip>();
        RealmResults<Trip> results = realm.where(Trip.class).findAllSorted("created_at",RealmResults.SORT_ORDER_DESCENDING);
        for(Trip travel : results){
            items.add(travel);
        }

        ClientAPI.getInstance().takeTravel(new ClientAPI.APIListener() {
            @Override
            public void callback() {
            }
        });

        return items;
    }*/

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

    public void addTravel(Trip valueTravel){
        realm.beginTransaction();
        Trip travel = realm.createObject(Trip.class);
        travel.setId(valueTravel.getId());
        travel.setStart(valueTravel.getStart());
        travel.setArrival(valueTravel.getArrival());
        travel.setHighway(valueTravel.getHighway());
       /* travel.setRoundTrip(valueTravel.getRoundTrip());
        travel.setDateStart(valueTravel.getDateStart());
        travel.setDateArrival(valueTravel.getDateArrival());
        travel.setHoursStart(valueTravel.getHoursStart());
        travel.setHoursArrival(valueTravel.getHoursArrival());*/
        travel.setComment(valueTravel.getComment());
        realm.commitTransaction();
    }
}

