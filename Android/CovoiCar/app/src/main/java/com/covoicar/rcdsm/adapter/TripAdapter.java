package com.covoicar.rcdsm.adapter;


import android.content.Context;
import android.graphics.Color;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.covoicar.rcdsm.covoicar.R;
import com.covoicar.rcdsm.models.Trip;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.NoSuchElementException;
import java.util.StringTokenizer;

/**
 * Created by rcdsm on 25/06/15.
 */
public class TripAdapter extends BaseAdapter {

    Context context;
    ArrayList<Trip> trips;
    Trip currentTrip;
    String dateInfo = null;
    String timeInfo = null;

    LayoutInflater inflater;

    public TripAdapter(Context context, ArrayList<Trip> trip) {
        this.context = context;
        this.trips = trip;
        inflater = LayoutInflater.from(context);
    }

    @Override
    public int getCount() {
        return trips.size();
    }

    @Override
    public Object getItem(int position) {
        return trips.size();
    }

    @Override
    public long getItemId(int position) {
        return trips.get(position).getId();
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;

        if(convertView==null) {
            convertView = inflater.inflate(R.layout.item_travel, null);
            holder = new ViewHolder();
            holder.date = (TextView)convertView.findViewById(R.id.dayInfo);
            holder.hours = (TextView)convertView.findViewById(R.id.hourInfo);
            holder.price = (TextView)convertView.findViewById(R.id.priceInfo);
            holder.startTravel = (TextView) convertView.findViewById(R.id.startTravel);
            holder.arrivalTravel = (TextView) convertView.findViewById(R.id.arrivalTravel);
            holder.infoPlace = (TextView)convertView.findViewById(R.id.infoPlace);
            holder.duration =(TextView)convertView.findViewById(R.id.duration);
            holder.distance=(TextView)convertView.findViewById(R.id.distance);
            convertView.setTag(holder);
        }
        else {
            holder = (ViewHolder) convertView.getTag();
        }

        try{

            currentTrip = trips.get(position);

            holder.startTravel.setText(currentTrip.getStart());
            holder.arrivalTravel.setText(currentTrip.getArrival());
            holder.price.setText(String.valueOf(currentTrip.getPrice() + "€"));
            holder.price.setTextColor(Color.rgb(0, 200, 0));
            holder.infoPlace.setText(String.valueOf(currentTrip.getPlace()));
            holder.distance.setText(currentTrip.getDistance());
            holder.duration.setText(currentTrip.getDuration());

            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

            Calendar c = Calendar.getInstance();
            System.out.println("Current time => " + c.getTime());
            String formattedDate = formatter.format(c.getTime());
            Date date2 = formatter.parse(formattedDate);

            String dateInString = currentTrip.getDateTimeStart();
            Date date1 = null;

            try {
                StringTokenizer date = new StringTokenizer(dateInString, " ");
                 dateInfo = date.nextToken();
                 timeInfo = date.nextToken();
            }catch (NoSuchElementException e){
                Log.e("INFO ERROR", ""+trips);
                Log.e("INFO ERROR POSITION", ""+position);
                Log.e("ERROR ", " ERROR "+currentTrip);
            }

            if(dateInfo!=null){
                 date1  = formatter.parse(dateInfo);

                if (date1.compareTo(date2)<0)
                {
                    holder.date.setText("Demain");

                }else if(date1.equals(date2)){
                    holder.date.setText("Aujourd'hui");
                }else{
                    holder.date.setText(dateInfo);
                }
            }

            if(timeInfo != null) {
                StringTokenizer time = new StringTokenizer(timeInfo, ":");
                String hourInfo = time.nextToken();
                String minuteInfo = time.nextToken();
                String newTime = hourInfo + ":" + minuteInfo;
                holder.hours.setText(newTime);
            }else {
                Log.e("ERROR 2 ", " ERROR 2");
            }

        }catch (ParseException e1){
            e1.printStackTrace();
        }

        return convertView;
    }

    class ViewHolder {
        public TextView date;
        public TextView hours;
        public TextView startTravel;
        public TextView arrivalTravel;
        public TextView infoPlace;
        private TextView duration;
        private TextView distance;
        public TextView price;
    }
}
