package com.covoicar.rcdsm.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.covoicar.rcdsm.covoicar.R;
import com.covoicar.rcdsm.models.Trip;

import java.util.ArrayList;

/**
 * Created by rcdsm on 25/06/15.
 */
public class TripAdapter extends BaseAdapter {

    Context context;
    ArrayList<Trip> trips;

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
        ViewHolder holder;

        if(convertView==null) {
            convertView = inflater.inflate(R.layout.item_travel, null);
            holder = new ViewHolder();
            holder.date = (TextView)convertView.findViewById(R.id.dayInfo);
            holder.hours = (TextView)convertView.findViewById(R.id.hourInfo);
            holder.startTravel = (TextView) convertView.findViewById(R.id.startTravel);
            holder.arrivalTravel = (TextView) convertView.findViewById(R.id.arrivalTravel);
            holder.infoPlace = (TextView)convertView.findViewById(R.id.infoPlace);
            holder.more = (ImageView)convertView.findViewById(R.id.imageMore);
            convertView.setTag(holder);
        }
        else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.date.setText(trips.get(position).getDateStart());
        holder.hours.setText(trips.get(position).getHoursStart());
        holder.startTravel.setText(trips.get(position).getStart());
        holder.arrivalTravel.setText(trips.get(position).getArrival());
//        holder.infoPlace.setText(trips.get(position).getPlace());

        return convertView;
    }

    class ViewHolder {
        public TextView date;
        public TextView hours;
        public TextView startTravel;
        public TextView arrivalTravel;
        public TextView infoPlace;
        public ImageView more;

    }
}
