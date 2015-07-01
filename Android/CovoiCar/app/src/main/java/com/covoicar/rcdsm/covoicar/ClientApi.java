package com.covoicar.rcdsm.covoicar;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;
import android.widget.Toast;

import com.androidquery.AQuery;
import com.androidquery.callback.AjaxCallback;
import com.androidquery.callback.AjaxStatus;
import com.covoicar.rcdsm.manager.TripManager;
import com.covoicar.rcdsm.models.Trip;
import com.covoicar.rcdsm.models.User;
import com.covoicar.rcdsm.utils.GetDistance;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;

import io.realm.Realm;

/**
 * Created by rcdsm on 23/06/15.
 */
public class ClientApi {

    private Context context;
    private AQuery aq;
    protected Realm realm;
    private static ClientApi instance;
    private SharedPreferences.Editor editor;
    private SharedPreferences preferences;

    public static void createInstance(Context context){
        instance = new ClientApi(context);
    }

    public static ClientApi getInstance(){
        return instance;
    }

    public ClientApi(Context appContext){
        this.context = appContext;
    }

    public void connect(final String email,final String password,APIListener listener){

        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);

        final APIListener _listener = listener;
        aq = new AQuery(context);

        Map<String, String> params = new HashMap<String, String>();
        params.put("password", password);
        params.put("email", email);


        String url = "http://172.31.1.36:8888/covoicar/user/connect";
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

        String url = "http://172.31.1.36:8888/covoicar/user/add";
        aq.ajax(url, params, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {

                User user = User.getInstance();
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

    public void addTrip(final Trip trip, APIListener listener){

        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);
        final APIListener _listener = listener;
        realm = Realm.getInstance(context);

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
        String url = "http://172.31.1.36:8888/covoicar/trip/add";
        aq.ajax(url, params, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {
                try {
                    if (json.getString("reponse").equals("success")) {
                        Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();
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

    public void takeTravel(final String token,APIListener listener){

        final APIListener _listener = listener;
        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);
        realm = Realm.getInstance(context);

        Map<String, String> params = new HashMap<String, String>();
        params.put("token", token);

        aq = new AQuery(context);
        String url = "http://172.31.1.36:8888/covoicar/travel/list";
        aq.ajax(url,params,JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {
                try {
                    if (json.getString("reponse").equals("success")) {
                        Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();
                        JSONArray jArray  = json.getJSONArray("data");

                        realm.beginTransaction();

                        for(int i=0;i<jArray.length();i++)
                        {
                            JSONObject obj = jArray.getJSONObject(i);
                            final Trip trip = new Trip();
                            trip.setStart(obj.getString("start"));
                            trip.setArrival(obj.getString("arrival"));
                            trip.setIdDriver(obj.getInt("driver"));
                            trip.setComment(obj.getString("comment"));
                            trip.setDateTimeStart(obj.getString("hourStart"));
                            trip.setHighway(obj.getString("highway"));
                            trip.setId(obj.getLong("id"));
                            trip.setPlace(obj.getInt("place"));
                            trip.setPrice(obj.getInt("price"));
                            trip.setPlaceAvailable(obj.getInt("placeAvailable"));

                            try{
                                realm.copyToRealm(trip);
                            }catch (Exception e){
                                Log.e("Realm Error", "error"+e);
                            } finally {
                                realm.commitTransaction();
                            }

                           /* trip.setIdDriver(new User());
                            getIdDriver(User.getInstance().getToken(), trip, obj.getString("driver"), new ClientApi.APIListener() {
                                @Override
                                public void callback() {


                                }
                            });*/
                        }

                    } else {
                        Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                _listener.callback();
            }
        });
    }

    public void infoUser(final String token,APIListener listener){

        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);
        final APIListener _listener = listener;
        aq = new AQuery(context);

        Map<String, String> params = new HashMap<String, String>();
        params.put("token", token);


        String url = "http://172.31.1.36:8888/covoicar/user/info";
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

    public void getDriver(final String token,final Trip trip,final String id,APIListener listener){

        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);

        final APIListener _listener = listener;
        aq = new AQuery(context);

        Map<String, String> params = new HashMap<String, String>();
        params.put("token", token);
        params.put("userid", id);


        String url = "http://172.31.1.36:8888/covoicar/user/getbyid";
        aq.ajax(url, params, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {
                User driver = new User();
                if (json != null) {
                    try {
                        if (json.getString("reponse").equals("success")) {
                          //  Toast.makeText(aq.getContext(), json.getString("message"), Toast.LENGTH_SHORT).show();
                            driver.setId(json.getJSONObject("data").getInt("id"));
                            driver.setEmail(json.getJSONObject("data").getString("email"));
                            driver.setLastName(json.getJSONObject("data").getString("lastname"));
                            driver.setFirstName(json.getJSONObject("data").getString("firstname"));
                            driver.setGender(json.getJSONObject("data").getString("gender"));
                            driver.setPhone(json.getJSONObject("data").getString("phone"));
                            driver.setBio(json.getJSONObject("data").getString("bio"));
                            driver.setBirthday(json.getJSONObject("data").getString("birthday"));

                             trip.setDriver(driver);
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

    public void getCoordinate(final Trip trip, APIListener listener){

        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);

        final APIListener _listener = listener;
        aq = new AQuery(context);

        Map<String, String> params = new HashMap<String, String>();
        params.put("token", User.getInstance().getToken());
        params.put("start", trip.getStart());
        params.put("arrival", trip.getArrival());


        String url = "http://172.31.1.36:8888/covoicar/coordinate";
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

                                trip.setDistance(distance);
                                trip.setDuration(duration);

                                TripManager tripManager = new TripManager(context);
                                tripManager.addInfoDistDur(trip);

                                Toast.makeText(aq.getContext(),"DISTANCE : "+distance+" Duration : "+duration , Toast.LENGTH_SHORT).show();

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




    public interface APIListener{
        public void callback();
    }
}

