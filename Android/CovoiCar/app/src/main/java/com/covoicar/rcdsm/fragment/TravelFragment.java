package com.covoicar.rcdsm.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
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
        final User user = User.getInstance();

        /**
         * Take all travel create by User and participation travel
         */
        ClientApi.getInstance().takeTravel(user.getToken(), new ClientApi.APIListener() {
            @Override
            public void callback() {
                collectTrip();
            }

            @Override
            public void searchResultsCallback(ArrayList<Trip> trips) {/* not used */}
        });

        // Click event for single list row
        tripList.setOnItemClickListener(new AdapterView.OnItemClickListener() {

            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int posiotion, final long id){
                TripManager tripManager = new TripManager(getActivity());
                final Trip trip = tripManager.getTripWithId(id);

                ClientApi.getInstance().getDriver(trip, new ClientApi.APIListener() {
                    @Override
                    public void callback() {
                        FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
                        Fragment moreTravel = new MoreTravelFragment();
                        Bundle args = new Bundle();
                        args.putString("start",trip.getStart());
                        args.putString("arrival",trip.getArrival());
                        args.putString("datetime",trip.getDateTimeStart());
                        args.putString("distanceTravel",trip.getDistance());
                        args.putString("timeTravel", trip.getDuration());
                        args.putInt("driver", trip.getDriver());
                        args.putBoolean("buttonReserved", false);
                        args.putLong("idTrip", id);
                        moreTravel.setArguments(args);
                        fragmentManager.beginTransaction().addToBackStack(null)
                                .replace(R.id.container, moreTravel)
                                .commit();
                    }

                    @Override
                    public void searchResultsCallback(ArrayList<Trip> trips) {/*not used*/}
                });


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
