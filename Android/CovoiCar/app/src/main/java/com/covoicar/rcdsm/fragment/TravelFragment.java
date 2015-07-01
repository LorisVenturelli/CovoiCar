package com.covoicar.rcdsm.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.covoicar.rcdsm.adapter.TripAdapter;
import com.covoicar.rcdsm.covoicar.ClientApi;
import com.covoicar.rcdsm.covoicar.R;
import com.covoicar.rcdsm.manager.TripManager;
import com.covoicar.rcdsm.models.Trip;
import com.covoicar.rcdsm.models.User;

import java.util.ArrayList;

/**
 * Created by rcdsm on 29/06/15.
 */
public class TravelFragment extends Fragment {

    private ArrayList<Trip> trips;
    private ListView tripList;
    private TripAdapter adapter;
    private TripManager trip;

    @Override
    public View onCreateView(LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_travel, container, false);
        /**
         * Inflate the layout for this fragment
         */
        tripList = (ListView)view.findViewById(R.id.tripsListView);
        User user = User.getInstance();

        /**
         * Take all travel create by User and participation travel
         */
        ClientApi.getInstance().takeTravel(user.getToken(), new ClientApi.APIListener() {
            @Override
            public void callback() {
                collectTrip();
            }
        });

        return view;
    }

    public void collectTrip(){
        trip = new TripManager(getActivity());
        trips = new ArrayList<Trip>();
        trips.addAll(trip.allListTrip());
        adapter = new TripAdapter(getActivity(),trips);
        tripList.setAdapter(adapter);
    }
}
