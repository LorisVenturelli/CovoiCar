package com.covoicar.rcdsm.covoicar;

import android.app.Activity;
import android.app.DialogFragment;
import android.app.FragmentTransaction;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Spinner;
import android.widget.Toast;

import com.covoicar.rcdsm.adapter.TripAdapter;
import com.covoicar.rcdsm.fragment.DatePickerFragment;
import com.covoicar.rcdsm.fragment.NavigationDrawerFragment;
import com.covoicar.rcdsm.fragment.SearchFragment;
import com.covoicar.rcdsm.fragment.TimePickerFragment;
import com.covoicar.rcdsm.fragment.TripFragment;
import com.covoicar.rcdsm.manager.TripManager;
import com.covoicar.rcdsm.models.Trip;
import com.covoicar.rcdsm.utils.GetDistance;

import java.util.ArrayList;
import java.util.concurrent.ExecutionException;


public class MainActivity extends ActionBarActivity
        implements NavigationDrawerFragment.NavigationDrawerCallbacks,TripFragment.OnCreateTripListener,DatePickerFragment.TheListenerDateStart,TimePickerFragment.TheListenerTimeStart,DatePickerFragment.TheListenerDateEnd,TimePickerFragment.TheListenerTimeEnd{

    private EditText start,arrival,comment;
    private Spinner price,place;
    private String dateStart;
    private String dateEnd;
    private String timeStart;
    private String timeEnd;

    /**
     * Fragment managing the behaviors, interactions and presentation of the navigation drawer.
     */
    private NavigationDrawerFragment mNavigationDrawerFragment;

    /**
     * Used to store the last screen title. For use in {@link #restoreActionBar()}.
     */
    private CharSequence mTitle;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mNavigationDrawerFragment = (NavigationDrawerFragment)
                getSupportFragmentManager().findFragmentById(R.id.navigation_drawer);
        mTitle = getTitle();

        // Set up the drawer.
        mNavigationDrawerFragment.setUp(
                R.id.navigation_drawer,
                (DrawerLayout) findViewById(R.id.drawer_layout));

    }

    @Override
    public void onNavigationDrawerItemSelected(int position) {
        // update the main content by replacing fragments
        FragmentManager fragmentManager = getSupportFragmentManager();
        fragmentManager.beginTransaction()
                .replace(R.id.container, PlaceholderFragment.newInstance(position + 1))
                .commit();
    }

    public void onSectionAttached(int number) {
        FragmentManager fragmentManager = getSupportFragmentManager();
        switch (number) {
            case 1:
                mTitle = getString(R.string.title_section1);
                break;
            case 2:
                mTitle = getString(R.string.title_section2);
                break;
            case 3:
                mTitle = getString(R.string.title_section3);

                Fragment search = new SearchFragment();
                fragmentManager.beginTransaction().addToBackStack(null)
                        .replace(R.id.container, search)
                        .commit();
                break;
            case 4:
                mTitle = getString(R.string.title_section4);

                Fragment trip = new TripFragment();
                fragmentManager.beginTransaction().addToBackStack(null)
                        .replace(R.id.container, trip)
                        .commit();
                break;
        }
    }

    public void restoreActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_STANDARD);
        actionBar.setDisplayShowTitleEnabled(true);
        actionBar.setTitle(mTitle);
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        if (!mNavigationDrawerFragment.isDrawerOpen()) {
            // Only show items in the action bar relevant to this screen
            // if the drawer is not showing. Otherwise, let the drawer
            // decide what to show in the action bar.
            getMenuInflater().inflate(R.menu.main, menu);
            restoreActionBar();
            return true;
        }
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onCreateTripClick(String highway,String roundTrip) {

        int i = 0;

        start = (EditText)findViewById(R.id.editStart);
        arrival = (EditText)findViewById(R.id.editArrival);
        comment = (EditText)findViewById(R.id.editComment);
        price =(Spinner)findViewById(R.id.spinnerPrice);
        place =(Spinner)findViewById(R.id.spinnerPlace);

        int intPrice = Integer.parseInt(price.getSelectedItem().toString());
        int intPlace = Integer.parseInt(place.getSelectedItem().toString());

        TripManager trip = new TripManager(this);
        Trip trip2 = new Trip();
        trip2.setId((new java.util.Date()).getTime()+i);
        i++;
        trip2.setStart(start.getText().toString());
        trip2.setArrival(arrival.getText().toString());
        trip2.setHighway(highway);
        trip2.setRoundTrip(roundTrip);
        trip2.setPlace(intPlace);
        trip2.setPrice(intPrice);
        trip2.setDateStart(dateStart);
        trip2.setDateArrival(dateEnd);
        trip2.setHoursStart(timeStart);
        trip2.setHoursArrival(timeEnd);
        trip2.setComment(comment.getText().toString());
        trip.addTravel(trip2);

        String duration;
        String distance;

        GetDistance task = new GetDistance();
        try {
            String[] result = task.execute(43.300,5.367,43.600,3.883).get();
            distance = result[0];
            duration = result[1];
            Toast.makeText(this,"DISTANCE : "+distance+" DURATION : "+duration,Toast.LENGTH_SHORT).show();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }


        String DateStart = dateEnd+" "+timeStart;
        Log.e("TEST DATE & HOUR : ", dateStart + " , " + dateEnd + " , " + timeStart + " , " + timeEnd+" = "+DateStart);

       /* ClientAPI.getInstance().addTrip(start.getText().toString(),arrival.getText().toString(),highway,roundTrip,new ClientAPI.APIListener() {
            @Override
            public void callback() {
                Log.e("Add note", "Add note");
            }
        });*/
    }

    @Override
    public void returnDateStart(String dateStart) {
        this.dateStart = dateStart;
        Log.e("TEST DATE  : ", this.dateStart);
    }

    @Override
    public void returnTimeStart(String timeStart) {
        this.timeStart = timeStart;
        Log.e("TEST DATE  : ", this.timeStart);
    }

    @Override
    public void returnDateEnd(String dateEnd) {
        this.dateEnd = dateEnd;
        Log.e("TEST DATE  : ", this.dateEnd);
    }

    @Override
    public void returnTimeEnd(String timeEnd) {
        this.timeEnd = timeEnd;
        Log.e("TEST DATE  : ", this.timeEnd);
    }

    /**
     * A placeholder fragment containing a simple view.
     */
    public static class PlaceholderFragment extends Fragment {

        private ArrayList<Trip> trips;
        private ListView tripList;
        private TripAdapter adapter;
        private TripManager trip;

        /**
         * The fragment argument representing the section number for this
         * fragment.
         */
        private static final String ARG_SECTION_NUMBER = "section_number";

        /**
         * Returns a new instance of this fragment for the given section
         * number.
         */
        public static PlaceholderFragment newInstance(int sectionNumber) {
            PlaceholderFragment fragment = new PlaceholderFragment();
            Bundle args = new Bundle();
            args.putInt(ARG_SECTION_NUMBER, sectionNumber);
            fragment.setArguments(args);
            return fragment;
        }

        public PlaceholderFragment() {
        }

        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                                 Bundle savedInstanceState) {
            View rootView = inflater.inflate(R.layout.fragment_main, container, false);

            tripList = (ListView)rootView.findViewById(R.id.tripsListView);

            ClientAPI.getInstance().takeTravel("7d0fcac2ad0d2080e56f", new ClientAPI.APIListener() {
                @Override
                public void callback() {
                    trips = new ArrayList<Trip>();
                    adapter = new TripAdapter(getActivity(), trips);
                    tripList.setAdapter(adapter);
                    trips.clear();
                    trips.addAll(trip.allListTrip());
                }
            });

            sendTrip();
            return rootView;
    }

    public void sendTrip(){
        trip = new TripManager(getActivity());
        trips = new ArrayList<Trip>();
        adapter = new TripAdapter(getActivity(),trips);
        tripList.setAdapter(adapter);
        trips.clear();
        trips.addAll(trip.allListTrip());
    }

        @Override
        public void onAttach(Activity activity) {
            super.onAttach(activity);
            ((MainActivity) activity).onSectionAttached(
                    getArguments().getInt(ARG_SECTION_NUMBER));
        }
    }

    public void showDateStartPickerDialog(View v) {
        FragmentTransaction ft = getFragmentManager().beginTransaction();
        DialogFragment newFragment = new DatePickerFragment();
        Bundle args = new Bundle();
        args.putInt("infoDate", 0);
        newFragment.setArguments(args);
        newFragment.show(ft, "datePicker");
    }

    public void showTimeStartPickerDialog(View v) {
        FragmentTransaction ft = getFragmentManager().beginTransaction();
        DialogFragment newFragment = new TimePickerFragment();
        Bundle args = new Bundle();
        args.putInt("infoTime", 0);
        newFragment.setArguments(args);
        newFragment.show(ft, "timePicker");
    }

    public void showDateArrivalPickerDialog(View v) {
        FragmentTransaction ft = getFragmentManager().beginTransaction();
        DialogFragment newFragment = new DatePickerFragment();
        Bundle args = new Bundle();
        args.putInt("infoDate", 1);
        newFragment.setArguments(args);
        newFragment.show(ft, "datePicker");
    }

    public void showTimeArrivalPickerDialog(View v) {
        FragmentTransaction ft = getFragmentManager().beginTransaction();
        DialogFragment newFragment = new TimePickerFragment();
        Bundle args = new Bundle();
        args.putInt("infoTime", 1);
        newFragment.setArguments(args);
        newFragment.show(ft, "timePicker");
    }

    public void showDateStartSearchPickerDialog(View v) {
        FragmentTransaction ft = getFragmentManager().beginTransaction();
        DialogFragment newFragment = new DatePickerFragment();
        Bundle args = new Bundle();
        args.putInt("infoDate", 2);
        newFragment.setArguments(args);
        newFragment.show(ft, "datePicker");
    }
}
