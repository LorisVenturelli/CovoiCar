package com.covoicar.rcdsm.fragment;


import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.covoicar.rcdsm.covoicar.R;
import com.covoicar.rcdsm.manager.TripManager;
import com.covoicar.rcdsm.models.Driver;

import java.util.StringTokenizer;

/**
 * Created by rcdsm on 01/07/15.
 */

/**
 * Fragment information travel
 */
public class MoreTravelFragment extends Fragment {

    String startInfo,arrivalInfo,emailInfo,bioInfo,phoneInfo,nameInfo,dateInfo,lastNameInfo,dateTimeInfo,timeInfo,timeInfoTravel, distanceInfoTravel;
    TextView start,arrival,email,bio,phone,name,lastName,dates,time,timeTravel, distanceTravel;
    int driverID;
    Button buttonReserved;
    boolean activiationButton;
    long idTrip;

    @Override
    public View onCreateView(LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.more_travel_fragment, container, false);
        /**
         * Inflate the layout for this fragment
         */
        start = (TextView)view.findViewById(R.id.infoStartTravel);
        arrival = (TextView)view.findViewById(R.id.infoEndTravel);
        email = (TextView)view.findViewById(R.id.infoEmailUser);
        bio = (TextView)view.findViewById(R.id.infoBioUser);
        phone = (TextView)view.findViewById(R.id.infoPhoneUser);
        name = (TextView)view.findViewById(R.id.infoNameUser);
        lastName = (TextView)view.findViewById(R.id.infoLastNameUser);
        dates = (TextView)view.findViewById(R.id.infoDateTravel);
        time = (TextView)view.findViewById(R.id.infoTimeTravel);
        timeTravel = (TextView)view.findViewById(R.id.infoMapTravelTime);
        distanceTravel = (TextView)view.findViewById(R.id.infoMapTravelKilo);
        buttonReserved = (Button)view.findViewById(R.id.buttonReserved);

        if(activiationButton){
            buttonReserved.setVisibility(View.VISIBLE);
        }else{
            buttonReserved.setVisibility(View.GONE);
        }

        buttonReserved.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((OnReservationListener) (getActivity())).onReservationClick(idTrip);
            }
        });

        //Slit date which content date and time
        StringTokenizer date = new StringTokenizer(dateTimeInfo, " ");
        dateInfo = date.nextToken();
        timeInfo = date.nextToken();

        //Slit time for have hh H mm
        StringTokenizer times = new StringTokenizer(timeInfo, ":");
        String hourInfo = times.nextToken();
        String minuteInfo = times.nextToken();
        String newTime = hourInfo + "h" + minuteInfo;

        TripManager tripManager = new TripManager(getActivity());
        Driver driver = tripManager.getDriverWithId(driverID);

        nameInfo = driver.getFirstName();
        lastNameInfo = driver.getLastName();

        emailInfo = driver.getEmail();
        dates.setText(dateInfo);
        start.setText(startInfo);
        arrival.setText(arrivalInfo);
        email.setText(emailInfo);
        bio.setText("Aucun résultat");
        phone.setText("Aucun résultat");
        name.setText(nameInfo);
        lastName.setText(lastNameInfo);
        time.setText(newTime);
        timeTravel.setText(timeInfoTravel);
        distanceTravel.setText(distanceInfoTravel);

        return view;
    }

    /**
     * @param args :content all information travel and user
     * Get data travel and user inside Bundle
     *
     */
    public void setArguments(Bundle args) {
        super.setArguments(args);
        startInfo = args.getString("start");
        arrivalInfo = args.getString("arrival");
        dateTimeInfo = args.getString("datetime");
        distanceInfoTravel = args.getString("distanceTravel");
        timeInfoTravel = args.getString("timeTravel");
        driverID = args.getInt("driver");
        activiationButton = args.getBoolean("buttonReserved");
        idTrip = args.getLong("idTrip");

    }

    /**
     * Listener on the button reserved
     */
    public interface OnReservationListener {
        public void onReservationClick(Long idTrips);
    }
}
