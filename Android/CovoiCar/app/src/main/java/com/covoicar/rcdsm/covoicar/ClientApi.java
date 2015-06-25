package com.covoicar.rcdsm.covoicar;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;
import android.widget.Toast;

import com.androidquery.AQuery;
import com.androidquery.callback.AjaxCallback;
import com.androidquery.callback.AjaxStatus;
import com.covoicar.rcdsm.models.Trip;
import com.covoicar.rcdsm.models.User;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.realm.Realm;

/**
 * Created by rcdsm on 23/06/15.
 */
public class ClientAPI {

    private Context context;
    private AQuery aq;
    protected Realm realm;
    private static ClientAPI instance;
    private SharedPreferences.Editor editor;
    private SharedPreferences preferences;

    public static void createInstance(Context context){
        instance = new ClientAPI(context);
    }

    public static ClientAPI getInstance(){
        return instance;
    }

    public ClientAPI(Context appContext){
        this.context = appContext;
    }

    public void connect(final String email,final String password,APIListener listener){

        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);

        final APIListener _listener = listener;
        aq = new AQuery(context);

        Map<String, String> params = new HashMap<String, String>();
        params.put("password", password);
        params.put("email",email);


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
                            user.setFirtname(json.getJSONObject("data").getString("firstname"));
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

    public void addTrip(final String start,final String arrival, final String highway, final String hoursStart, final int price, final int place, final String comment,APIListener listener){

        preferences = context.getSharedPreferences("Login", Context.MODE_PRIVATE);
        final APIListener _listener = listener;

        Map<String, String> params = new HashMap<String, String>();
        params.put("start", start);
        params.put("arrival",arrival);
        params.put("highway", highway);
        params.put("hoursStart", hoursStart);
        params.put("price", String.valueOf(price));
        params.put("place", String.valueOf(place));
        params.put("comment", comment);

        Log.e("Info dans params", " : " + params);

        aq = new AQuery(context);
        String url = "http://172.31.1.36:8888/covoicar/trip/add";
        aq.ajax(url, params, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {
                try {
                    if (json.getString("reponse").equals("success")) {
                        Log.e("TAG", "Add new note : ");
                        Trip trip = new Trip();
                        trip.setStart(start);
                        trip.setArrival(arrival);
                        trip.setHighway(highway);
                        trip.setHoursArrival(hoursStart);
                        trip.setPrice(price);
                        trip.setPlace(place);
                        trip.setComment(comment);
                        _listener.callback();
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        });
    }


    public interface APIListener{
        public void callback();
    }
}