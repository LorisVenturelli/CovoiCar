package com.covoicar.rcdsm.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.Spinner;
import android.widget.Switch;
import android.widget.Toast;

import com.covoicar.rcdsm.covoicar.R;

import java.util.ArrayList;

/**
 * Created by rcdsm on 24/06/15.
 */

/**
 * Fragment Trip
 */
public class TripFragment  extends Fragment {

    private Switch switchRoundTrip,switchHighway;
    private EditText start,arrival,comment;
    private RelativeLayout dateArrival;
    private String highway,roundTrip;
    private Button createTrip;
    private Spinner price,place;
    private String startTravel,arrivalTravel,commentTravel;

    @Override
    public View onCreateView(LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_trips, container, false);
        /**
         * Inflate the layout for this fragment
         */
        switchRoundTrip = (Switch)view.findViewById(R.id.switchRoundTrip);
        switchHighway = (Switch)view.findViewById(R.id.switchHighway);
        dateArrival = (RelativeLayout)view.findViewById(R.id.dateArrival);
        createTrip = (Button)view.findViewById(R.id.buttonCreateTrip);

        start = (EditText)view.findViewById(R.id.editStart);
        arrival = (EditText)view.findViewById(R.id.editArrival);
        comment = (EditText)view.findViewById(R.id.editComment);

        price = (Spinner)view.findViewById(R.id.spinnerPrice);
        place = (Spinner)view.findViewById(R.id.spinnerPlace);

        ArrayList<String> places = new ArrayList<String>();
        places.add("Nombre de places");
        for (int i = 1; i <= 9; i++) {
            places.add(Integer.toString(i));
        }
        ArrayAdapter<String> adapterPlace = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_spinner_item, places);
        place.setAdapter(adapterPlace);

        ArrayList<String> prices = new ArrayList<String>();
        prices.add("Prix");
        for (int i = 1; i <= 30; i++) {
            prices.add(Integer.toString(i));
        }
        ArrayAdapter<String> adapterPrice = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_spinner_item, prices);
        price.setAdapter(adapterPrice);

        createTrip.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startTravel = start.getText().toString();
                arrivalTravel = arrival.getText().toString();
                commentTravel = comment.getText().toString();
                if(startTravel.equals("") || arrivalTravel.equals("") || commentTravel.equals("")){
                    Toast.makeText(getActivity(),"Champs Manquant",Toast.LENGTH_SHORT).show();
                }else {
                    ((OnCreateTripListener) (getActivity())).onCreateTripClick(highway, roundTrip);
                }
            }
        });

        //set the switch to ON
        switchRoundTrip.setChecked(true);
        //attach a listener to check for changes in state
        switchRoundTrip.setOnCheckedChangeListener(new OnCheckedChangeListener() {

            @Override
            public void onCheckedChanged(CompoundButton buttonView,
                                         boolean isChecked) {
                if(isChecked){
                    roundTrip ="1";
                    dateArrival.setVisibility(View.VISIBLE);
                }else{
                    roundTrip ="2";
                    dateArrival.setVisibility(View.GONE);
                }
            }
        });

        //check the current state before we display the screen
        if(switchRoundTrip.isChecked()){
            roundTrip ="1";
            dateArrival.setVisibility(View.VISIBLE);
        }
        else {
            roundTrip ="2";
            dateArrival.setVisibility(View.VISIBLE);
        }

        //set the switch to ON
        switchHighway.setChecked(true);
        //attach a listener to check for changes in state
        switchHighway.setOnCheckedChangeListener(new OnCheckedChangeListener() {

            @Override
            public void onCheckedChanged(CompoundButton buttonView,
                                         boolean isChecked) {
                if(isChecked){
                    highway ="1";
                }else{
                    highway ="2";
                }
            }
        });

        //check the current state before we display the screen
        if(switchRoundTrip.isChecked()){
            highway ="1";
        }
        else {
            highway ="2";
        }

        return view;
    }

    /**
     * Listener on button creat Trip
     */
    public interface OnCreateTripListener {
        public void onCreateTripClick(String highway,String roundTrip);
    }
}

