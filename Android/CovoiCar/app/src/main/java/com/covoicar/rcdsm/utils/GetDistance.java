package com.covoicar.rcdsm.utils;

import android.os.AsyncTask;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by rcdsm on 28/06/15.
 */
public class GetDistance extends AsyncTask<Double, String, String[]> {

    private double startLat;
    private double startLong;
    private double endLat;
    private double endLong;

    @Override
    protected String[] doInBackground(Double... infoLatLong) {
        String Distance = "error";
        String Duration = "error";
        String Status = "error";
        startLat = infoLatLong[0];
        startLong = infoLatLong[1];
        endLat = infoLatLong[2];
        endLong = infoLatLong[3];

        try {
            Log.e("Distance Link : ", "http://maps.googleapis.com/maps/api/directions/json?origin=" + startLat + "," + startLong + "&destination=" + endLat + "," + endLong + "&sensor=false");
            JSONObject jsonObj = parser_Json.getJSONfromURL("http://maps.googleapis.com/maps/api/directions/json?origin=" + startLat + "," + startLong + "&destination=" + endLat + "," + endLong + "&sensor=false");
            Status = jsonObj.getString("status");
            if (Status.equalsIgnoreCase("OK")) {
                JSONArray routes = jsonObj.getJSONArray("routes");
                JSONObject zero = routes.getJSONObject(0);
                JSONArray legs = zero.getJSONArray("legs");
                JSONObject zero2 = legs.getJSONObject(0);
                JSONObject dist = zero2.getJSONObject("distance");
                Distance = dist.getString("text");
                JSONObject dur = zero2.getJSONObject("duration");
                Duration = dur.getString("text");
            } else {
                Distance = "Too Far";
            }
        } catch (JSONException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        String[] args = new String[2];
        args[0] = Distance;
        args[1] = Duration;
        return args;
    }

    @Override
        protected void onPreExecute() {}

    @Override
    protected void onPostExecute(String[] strFromDoInBg) {
    }

}
