package com.covoicar.rcdsm.covoicar;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;
import android.widget.Toast;

import com.androidquery.AQuery;
import com.androidquery.callback.AjaxCallback;
import com.androidquery.callback.AjaxStatus;
import com.covoicar.rcdsm.models.User;

import org.json.JSONException;
import org.json.JSONObject;

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
        //On crée un JSOnObject et on recupère les informations email/password
        JSONObject requete = new JSONObject();
        //Puis on crée un deuxième JSONObject user ou l'on va mettre les informations recuperé précedement
        JSONObject userJson = new JSONObject();

        final APIListener _listener = listener;
        aq = new AQuery(context);

        Log.i("Note", requete.toString());

        try {
            userJson.putOpt("email", email);
            userJson.putOpt("password",password);

            requete.putOpt("user", userJson);
            Log.i("Note","Paramètre : "+ requete.toString());
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        String url = "http://notes.lloyd66.fr/api/v1/user/connect";
        aq.post(url, requete, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {

                if (json != null) {
                    User user = User.getInstance();
                    user.setEmail(email);
                    try {
                        user.setToken(json.getJSONObject("token").getString("value"));

                        if (preferences.contains("Token") == false) {
                            editor = preferences.edit();
                            editor.putString("Token", json.getJSONObject("token").getString("value"));
                            editor.commit();
                        }

                        Log.i("Token", user.getToken());
                        user.setSucces(json.getBoolean("success"));
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    //successful ajax call, show status code and json content
                    //Toast.makeText(aq.getContext(), status.getCode() + ":" + json.toString(), Toast.LENGTH_LONG).show();
                    if (user.isSucces()) {
                        Toast.makeText(aq.getContext(), "Welcom : " + email, Toast.LENGTH_LONG).show();
                        _listener.callback();
                    } else {
                        Toast.makeText(aq.getContext(), "Email or Password is wrong !", Toast.LENGTH_LONG).show();
                    }

                } else {
                    //ajax error, show error code
                    Toast.makeText(aq.getContext(), "Error:" + status.getCode(), Toast.LENGTH_LONG).show();
                }
            }
        });
    }

    public void subscrib(final String email,final String password,final String confirmPassword,APIListener listener){

        //On crée un JSOnObject et on recupère les informations email/password
        JSONObject requete = new JSONObject();
        //Puis on crée un deuxième JSONObject user ou l'on va mettre les informations recuperé précedement
        JSONObject user = new JSONObject();

        final APIListener _listener = listener;

        Log.i("CovoiCar", requete.toString());

        try {
            user.putOpt("email",email);
            user.putOpt("password",password);

            requete.putOpt("user", user);
            Log.i("CovoiCar", requete.toString());
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        aq = new AQuery(context);
        String url = "http://notes.lloyd66.fr/api/v1/user/";
        aq.post(url, requete, JSONObject.class, new AjaxCallback<JSONObject>() {

            @Override
            public void callback(String url, JSONObject json, AjaxStatus status) {

                User user = User.getInstance();
                user.setEmail(email);
                user.setStatus(status.getCode());
                try {
                    user.setSucces(json.getBoolean("success"));
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                //successful ajax call, show status code and json content
                //Toast.makeText(aq.getContext(), status.getCode() + ":" + json.toString(), Toast.LENGTH_LONG).show();
                if (confirmPassword.equals(password)) {
                    if (user.isSucces()) {
                        connect(email, password, _listener);
                    } else {
                        Toast.makeText(aq.getContext(), "User already exist !", Toast.LENGTH_LONG).show();
                    }
                } else {
                    Toast.makeText(aq.getContext(), "The confirm password is wrong !", Toast.LENGTH_LONG).show();
                }
            }
        });
    }

    public interface APIListener{
        public void callback();
    }
}