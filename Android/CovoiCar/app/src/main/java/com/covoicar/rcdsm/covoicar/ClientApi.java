package com.covoicar.rcdsm.covoicar;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;
import android.widget.Toast;

import com.androidquery.AQuery;
import com.androidquery.callback.AjaxCallback;
import com.androidquery.callback.AjaxStatus;
import com.covoicar.rcdsm.manager.TripManager;
import com.covoicar.rcdsm.models.Driver;
import com.covoicar.rcdsm.models.Trip;
import com.covoicar.rcdsm.models.User;
import com.covoicar.rcdsm.utils.GetDistance;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;

import io.realm.Realm;

/**
 * Created by rcdsm on 23/06/15.
 */


/**
 *
 * Class with all callback for manage apllication with API
 */
public class ClientApi {

    private Context context;
    private AQuery aq;
    protected Realm realm;
    private static ClientApi instance;
    private SharedPreferences.Editor editor;
    private SharedPreferences preferences;
    public String ip = "172.31.1.36:8888";
    //"192.168.100.19:8888";
    //172.31.1.36:8888

    public static void createInstance(Context context){
        instance = new ClientApi(context);
    }

    public static ClientApi getInstance(){
        return instance;
    }

    public ClientApi(Context appContext){
        this.context = appContext;
    }


    /**
     *Connect user
     */
    public void connect(final String email,final String password,APIListener listener){

        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);

        final APIListener _listener = listener;
        aq = new AQuery(context);

        Map<String, String> params = new HashMap<String, String>();
        params.put("password", password);
        params.put("email", email);


        String url = "http://"+ip+"/covoicar/user/connect";
        aq.ajax(url, params, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {

                if (json != null) {
                    User user = User.getInstance();
                    try {
                        if (json.getString("reponse").equals("success")) {
                            Toast.makeText(aq.getContext(), "Welcom : " + email, Toast.LENGTH_LONG).show();

                            user.setId(json.getJSONObject("data").getLong("id"));
                            user.setToken(json.getJSONObject("data").getString("token"));
                            user.setEmail(json.getJSONObject("data").getString("email"));
                            user.setFirstName(json.getJSONObject("data").getString("firstname"));
                            user.setLastName(json.getJSONObject("data").getString("lastname"));
                            user.setPhone(json.getJSONObject("data").getString("phone"));
                            user.setBio(json.getJSONObject("data").getString("bio"));
                            user.setBirthday(json.getJSONObject("data").getString("birthday"));
                            user.setGender(json.getJSONObject("data").getString("gender"));

                            if (preferences.contains("Token") == false) {
                                editor = preferences.edit();
                                editor.putString("Token", json.getJSONObject("data").getString("token"));
                                editor.commit();
                            }
                            Log.i("Token", user.getToken());
                            _listener.callback();
                        } else {
                            Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_LONG).show();
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                } else {
                    //ajax error, show error code
                    Toast.makeText(aq.getContext(), "Error:" + status.getCode(), Toast.LENGTH_LONG).show();
                }
            }
        });
    }


    /**
     *
     * Subcrib user
     */
    public void subscrib(final String email,final String password,final String confirmPassword,String lastname,String firstname,int gender,String birthday,APIListener listener){


        final APIListener _listener = listener;
        aq = new AQuery(context);

        Map<String, String> params = new HashMap<String, String>();
        params.put("password", password);
        params.put("email",email);
        params.put("repassword", confirmPassword);
        params.put("lastname", lastname);
        params.put("firstname", firstname);
        params.put("gender", String.valueOf(gender));
        params.put("birthday", birthday);

        Log.e("Info dans params", " : " + params);

        String url =  "http://"+ip+"/covoicar/user/add";
        aq.ajax(url, params, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {

                if (confirmPassword.equals(password)) {
                    try {
                        if (json.getString("reponse").equals("success")) {
                            connect(email, password, _listener);
                        } else {
                            Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_LONG).show();
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                } else {
                    Toast.makeText(aq.getContext(), "The confirm password is wrong !", Toast.LENGTH_LONG).show();
                }
            }
        });
    }


    /**
     *
     * Add new Trip
     */
    public void addTrip(final Trip trip, APIListener listener){

        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);
        final APIListener _listener = listener;

        Map<String, String> params = new HashMap<String, String>();
        params.put("start", trip.getStart());
        params.put("arrival",trip.getArrival());
        params.put("token",User.getInstance().getToken());
        params.put("highway", trip.getHighway());
        params.put("hourStart", trip.getDateTimeStart());
        params.put("price", String.valueOf(trip.getPrice()));
        params.put("place", String.valueOf(trip.getPlace()));
        params.put("comment", trip.getComment());
        params.put("roundTrip", trip.getDateTimeReturn());

        Log.e("Info dans params", " : " + params);

        aq = new AQuery(context);
        String url = "http://"+ip+"/covoicar/trip/add";
        aq.ajax(url, params, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {
                try {
                    if (json.getString("reponse").equals("success")) {
                        Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();

                        final TripManager tripManager = new TripManager(context);

                        trip.setId(json.getJSONObject("data").getLong("id"));
                        tripManager.addTravel(trip);

                        _listener.callback();
                    } else {
                        Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
    }


    /**
     *
     * Take all travel and registre inside Realm
     */
    public void takeTravel(final String token,APIListener listener){

        final APIListener _listener = listener;
        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);
        realm = Realm.getInstance(context);

        Map<String, String> params = new HashMap<String, String>();
        params.put("token", token);

        aq = new AQuery(context);
        String url =  "http://"+ip+"/covoicar/travel/list";
        aq.ajax(url,params,JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {
                try {
                    if (json.getString("reponse").equals("success")) {
                        JSONArray jArray  = json.getJSONArray("data");

                        for(int i=0;i<jArray.length();i++)
                        {
                            realm.beginTransaction();
                            Log.e("DEBUT DE LA TRANSACTION", " TAKETRAVEL :OK"+i);

                                JSONObject obj = jArray.getJSONObject(i);
                                final Trip trip = new Trip();
                                trip.setStart(obj.getString("start"));
                                trip.setArrival(obj.getString("arrival"));
                                trip.setDriver(obj.getInt("driver"));
                                trip.setComment(obj.getString("comment"));
                                trip.setDateTimeStart(obj.getString("hourStart"));
                                trip.setHighway(obj.getString("highway"));
                                trip.setId(obj.getLong("id"));
                                trip.setPlace(obj.getInt("place"));
                                trip.setPrice(obj.getInt("price"));
                                trip.setPlaceAvailable(obj.getInt("placeAvailable"));

                            try{
                                realm.copyToRealmOrUpdate(trip);
                            }catch (Exception e){
                                Log.e("Realm Error", "error"+e);
                            } finally {
                                realm.commitTransaction();
                                Log.e("FIN DE LA TRANSACTION", "TAKETRAVEL :OK"+i);
                            }


                            /**
                             *
                             * Get coordination for each travel
                             */
                        getCoordinate(trip, new ClientApi.APIListener() {
                            @Override
                            public void callback() {
                                _listener.callback();
                            }

                            @Override
                            public void searchResultsCallback(ArrayList<Trip> trips) {/* not used */}
                        });

                        }

                    } else {
                        Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
        });
    }


    /**
     *
     * Get info user
     */
    public void infoUser(final String token,APIListener listener){

        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);
        final APIListener _listener = listener;
        aq = new AQuery(context);

        Map<String, String> params = new HashMap<String, String>();
        params.put("token", token);

        String url =  "http://"+ip+"/covoicar/user/info";
        aq.ajax(url, params, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {
                if (json != null) {
                    User user = User.getInstance();
                    try {
                        if (json.getString("reponse").equals("success")) {

                            user.setId(json.getJSONObject("data").getLong("id"));
                            user.setEmail(json.getJSONObject("data").getString("email"));
                            user.setFirstName(json.getJSONObject("data").getString("firstname"));
                            user.setLastName(json.getJSONObject("data").getString("lastname"));
                            user.setPhone(json.getJSONObject("data").getString("phone"));
                            user.setBio(json.getJSONObject("data").getString("bio"));
                            user.setBirthday(json.getJSONObject("data").getString("birthday"));
                            user.setGender(json.getJSONObject("data").getString("gender"));

                            Log.i("Token", user.getToken());
                            _listener.callback();
                        } else {
                            Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                } else {
                    //ajax error, show error code
                    Toast.makeText(aq.getContext(), "Error:" + status.getCode(), Toast.LENGTH_SHORT).show();
                }
            }
        });
    }


    /**
     *
     * Get driver from Trip
     */
    public void getDriver(final Trip trip,APIListener listener){

        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);
        realm = Realm.getInstance(context);

        final APIListener _listener = listener;
        aq = new AQuery(context);

        Map<String, String> params = new HashMap<String, String>();
        String token = User.getInstance().getToken();
        String id = String.valueOf(trip.getDriver());
        params.put("token", token);
        params.put("userid",id );


        String url =  "http://"+ip+"/covoicar/user/getbyid";
        aq.ajax(url, params, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {
                Driver driver = new Driver();
                if (json != null) {
                    try {
                        if (json.getString("reponse").equals("success")) {
                          Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();

                            driver.setId(Long.parseLong(json.getJSONObject("data").getString("id")));
                            driver.setEmail(json.getJSONObject("data").getString("email"));
                            driver.setLastName(json.getJSONObject("data").getString("lastname"));
                            driver.setFirstName(json.getJSONObject("data").getString("firstname"));
                            driver.setGender(json.getJSONObject("data").getString("gender"));
                            driver.setPhone(json.getJSONObject("data").getString("phone"));
                            driver.setBio(json.getJSONObject("data").getString("bio"));
                            driver.setBirthday(json.getJSONObject("data").getString("birthday"));

                            realm.beginTransaction();
                            Log.e("DEBUT DE LA TRANSACTION", "GETUSER :OK");

                            realm.copyToRealmOrUpdate(driver);

                            try{
                                realm.copyToRealmOrUpdate(trip);
                            }catch (Exception e){
                                Log.e("Realm Error", "error"+e);
                            } finally {
                                realm.commitTransaction();
                                Log.e("FIN DE LA TRANSACTION", "GETUSER :OK");
                            }
                            _listener.callback();
                        } else {
                            Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                } else {
                    //ajax error, show error code
                    Toast.makeText(aq.getContext(), "Error:" + status.getCode(), Toast.LENGTH_LONG).show();
                }
            }
        });
    }


    /**
     *
     * Get coordination travel
     */
    public void getCoordinate(final Trip trip, APIListener listener){

        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);

        final APIListener _listener = listener;
        aq = new AQuery(context);

        Map<String, String> params = new HashMap<String, String>();
        params.put("token", User.getInstance().getToken());
        params.put("start", trip.getStart());
        params.put("arrival", trip.getArrival());


        String url =  "http://"+ip+"/covoicar/coordinate";
        aq.ajax(url, params, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {
                if (json != null) {
                    try {
                        if (json.getString("reponse").equals("success")) {
                            Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();
                            final GetDistance task = new GetDistance();
                            try {
                                JSONObject date = json.getJSONObject("data");
                                JSONObject start = date.getJSONObject("start");
                                JSONObject arrival = date.getJSONObject("arrival");

                                double latitudeStart = Double.parseDouble(start.getString("latitude"));
                                double longitureStart = Double.parseDouble(start.getString("longitude"));
                                double latitudeEnd = Double.parseDouble(arrival.getString("latitude"));
                                double longitudeEnd = Double.parseDouble(arrival.getString("longitude"));

                                String[] result = task.execute(latitudeStart, longitureStart, latitudeEnd, longitudeEnd).get();
                                String distance = result[0];
                                String duration = result[1];

                                realm.beginTransaction();
                                Log.e("DEBUT DE LA TRANSACTION", " GETCOORDINATE :OK");

                                    trip.setDistance(distance);
                                    trip.setDuration(duration);

                                try{
                                    realm.copyToRealmOrUpdate(trip);
                                }catch (Exception e){
                                    Log.e("Realm Error", "error"+e);
                                } finally {
                                    Log.e("FIN DE LA TRANSACTION","GETCOORDINATE :OK");
                                    realm.commitTransaction();
                                }

                            } catch (InterruptedException e) {
                                e.printStackTrace();
                            } catch (ExecutionException e) {
                                e.printStackTrace();
                            }
                            _listener.callback();

                        } else {
                            Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                } else {
                    //ajax error, show error code
                    Toast.makeText(aq.getContext(), "Error:" + status.getCode(), Toast.LENGTH_LONG).show();
                }
            }
        });
    }


    /**
     *
     * Search travel with ID
     */
    public void searchTravel(final String token,final String start,final String arrival,final String time,APIListener listener){

        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);

        final APIListener _listener = listener;
        aq = new AQuery(context);

        Map<String, String> params = new HashMap<String, String>();
        params.put("token", token);
        params.put("start", start);
        params.put("arrival", arrival);
        params.put("time", time);

        String url =  "http://"+ip+"/covoicar/trip/search";
        aq.ajax(url, params, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {
                ArrayList<Trip> filteredTrips = new ArrayList<Trip>();
                User driver = new User();
                if (json != null) {
                    try {
                        if (json.getString("reponse").equals("success")) {
                            Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();
                            JSONArray jArray  = json.getJSONArray("data");

                            for(int i=0;i<jArray.length();i++)
                            {
                                JSONObject obj = jArray.getJSONObject(i);
                                final Trip trip = new Trip();
                                trip.setStart(obj.getString("start"));
                                trip.setArrival(obj.getString("arrival"));
                                trip.setDriver(obj.getInt("driver"));
                                trip.setComment(obj.getString("comment"));
                                trip.setDateTimeStart(obj.getString("hourStart"));
                                trip.setHighway(obj.getString("highway"));
                                trip.setId(obj.getLong("id"));
                                trip.setPlace(obj.getInt("place"));
                                trip.setPrice(obj.getInt("price"));
                                trip.setPlaceAvailable(obj.getInt("placeAvailable"));

                                filteredTrips.add(trip);


                                /**
                                 *
                                 * Get coordinate for each Travel found
                                 */
                                getCoordinate(trip, new ClientApi.APIListener() {
                                    @Override
                                    public void callback() {
                                        _listener.callback();
                                    }

                                    @Override
                                    public void searchResultsCallback(ArrayList<Trip> trips) {/* not used */}
                                });
                            }

                        }  else {
                            Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                } else {
                    //ajax error, show error code
                    Toast.makeText(aq.getContext(), "Error:" + status.getCode(), Toast.LENGTH_LONG).show();
                }
                _listener.searchResultsCallback(filteredTrips);
            }
        });
    }


    /**
     *
     * Reserved travel
     */
    public void reserveTheTrip(final String token,final String id_trip,APIListener listener){

        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);

        final APIListener _listener = listener;
        aq = new AQuery(context);

        Map<String, String> params = new HashMap<String, String>();
        params.put("token", token);
        params.put("id_trip", id_trip);

        String url =  "http://"+ip+"/covoicar/travel/add";
        aq.ajax(url, params, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {
                ArrayList<Trip> filteredTrips = new ArrayList<Trip>();

                if (json != null) {
                    try {
                        if (json.getString("reponse").equals("success")) {
                            Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();

                        }  else {
                            Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                } else {
                    //ajax error, show error code
                    Toast.makeText(aq.getContext(), "Error:" + status.getCode(), Toast.LENGTH_LONG).show();
                }
                _listener.callback();
            }
        });

    }

    /**
     *
     * Listener Api
     */
    public interface APIListener{
        public void callback();
        public void searchResultsCallback(ArrayList<Trip> trips);
    }
}

