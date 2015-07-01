package com.covoicar.rcdsm.utils;

import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by rcdsm on 28/06/15.
 */
public class parser_Json {

    public static JSONObject getJSONfromURL(String url) {

        //initialize
        InputStream is = null;
        String result = "";
        JSONObject jArray = null;

        //http post
        try {
            URL urlMaps = new URL(url);
            HttpURLConnection request = (HttpURLConnection) urlMaps.openConnection();
            request.connect();
            is = request.getInputStream();

        } catch (Exception e) {
            Log.e("log_tag", "Error in http connection " + e.toString());
        }

        //convert response to string
        try {
            BufferedReader reader = new BufferedReader(new InputStreamReader(is));
            StringBuilder sb = new StringBuilder();
            String line = null;
            while ((line = reader.readLine()) != null) {
                sb.append(line + "\n");
            }
            is.close();
            result = sb.toString();
        } catch (Exception e) {
            Log.e("log_tag", "Error converting result " + e.toString());
        }

        //try parse the string to a JSON object
        try {
            jArray = new JSONObject(result);
        } catch (JSONException e) {
            Log.e("log_tag", "Error parsing data " + e.toString());
        }

        return jArray;
    }
}
