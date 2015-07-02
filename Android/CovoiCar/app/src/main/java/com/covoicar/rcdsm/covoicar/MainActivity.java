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
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Spinner;

import com.covoicar.rcdsm.adapter.TripAdapter;
import com.covoicar.rcdsm.fragment.DatePickerFragment;
import com.covoicar.rcdsm.fragment.MoreTravelFragment;
import com.covoicar.rcdsm.fragment.NavigationDrawerFragment;
import com.covoicar.rcdsm.fragment.SearchFragment;
import com.covoicar.rcdsm.fragment.TimePickerFragment;
import com.covoicar.rcdsm.fragment.TravelFragment;
import com.covoicar.rcdsm.fragment.TripFragment;
import com.covoicar.rcdsm.manager.TripManager;
import com.covoicar.rcdsm.models.Trip;
import com.covoicar.rcdsm.models.User;

import java.util.ArrayList;


public class MainActivity extends ActionBarActivity
        implements NavigationDrawerFragment.NavigationDrawerCallbacks,TripFragment.OnCreateTripListener,DatePickerFragment.TheListenerDateStart,TimePickerFragment.TheListenerTimeStart,DatePickerFragment.TheListenerDateEnd,TimePickerFragment.TheListenerTimeEnd,DatePickerFragment.TheListenerDateSearch,TimePickerFragment.TheListenerTimeSearch,SearchFragment.OnSearchTripListener,MoreTravelFragment.OnReservationListener{

    private EditText start,arrival,comment;
    private Spinner price,place;
    private String dateStart;
    private String dateEnd;
    private String timeStart;
    private String timeEnd;
    private String dateSearch;
    private String timeSearch;
    private ListView tripSearchList;
    private ArrayList<Trip> trips;


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

                Fragment travel = new TravelFragment();
                fragmentManager.beginTransaction().addToBackStack(null)
                        .replace(R.id.container, travel)
                        .commit();
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

        start = (EditText)findViewById(R.id.editStart);
        arrival = (EditText)findViewById(R.id.editArrival);
        comment = (EditText)findViewById(R.id.editComment);
        price =(Spinner)findViewById(R.id.spinnerPrice);
        place =(Spinner)findViewById(R.id.spinnerPlace);

        int intPrice = Integer.parseInt(price.getSelectedItem().toString());
        int intPlace = Integer.parseInt(place.getSelectedItem().toString());

        String dateTimeStart = dateStart+" "+timeStart;
        Log.e("TEST DATE & HOUR : ", dateStart + " , " + dateEnd + " , " + timeStart + " , " + timeEnd + " = " + dateTimeStart);
        String dateTimeReturn = dateEnd+" "+timeEnd;
        Log.e("TEST DATE & HOUR : ", dateStart + " , " + dateEnd + " , " + timeStart + " , " + timeEnd + " = " + dateTimeReturn);


        final Trip trip = new Trip();
        trip.setStart(start.getText().toString());
        trip.setArrival(arrival.getText().toString());
        trip.setHighway(highway);
        trip.setRoundTrip(roundTrip);
        trip.setPlace(intPlace);
        trip.setPrice(intPrice);
        trip.setDateStart(dateStart);
        trip.setHoursStart(timeStart);
        trip.setDateTimeStart(dateTimeStart);
        if(Integer.parseInt(roundTrip)==1){
            trip.setDateArrival(dateEnd);
            trip.setHoursArrival(timeEnd);
            trip.setDateTimeReturn(dateTimeReturn);
        }
        trip.setComment(comment.getText().toString());
                /**
                 * Add new trip
                 */
                ClientApi.getInstance().addTrip(trip, new ClientApi.APIListener() {
                            @Override
                            public void callback() {
                                FragmentManager fragmentManager = getSupportFragmentManager();
                                Fragment travel = new TravelFragment();
                                fragmentManager.beginTransaction().addToBackStack(null)
                                        .replace(R.id.container, travel)
                                        .commit();
                                Log.e("Add note", "Add note");
                            }

                    @Override
                    public void searchResultsCallback(ArrayList<Trip> trips) {/* not used */}
                });
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

    @Override
    public void onSearchTripClick() {

        String startTravelSearch,arrvialTravelSearch;
        EditText start,arrival;

        tripSearchList = (ListView)findViewById(R.id.listSearch);
        start = (EditText)findViewById(R.id.editStartSearch);
        arrival = (EditText)findViewById(R.id.editArrivalSearch);

        startTravelSearch = start.getText().toString();
        arrvialTravelSearch = arrival.getText().toString();

        String dateTimeSearch = dateSearch+" "+timeSearch;
        Log.e("TEST DATE & HOUR : ", dateSearch + " , " + timeSearch + " = " + dateTimeSearch);

        User user = User.getInstance();
        ClientApi.getInstance().searchTravel(user.getToken(), startTravelSearch, arrvialTravelSearch, dateTimeSearch, new ClientApi.APIListener() {
            @Override
            public void callback() { /* not used */ }

            @Override
            public void searchResultsCallback(ArrayList<Trip> trips) {
                collectTrip(trips);
            }
        });

    }

    public void collectTrip(ArrayList<Trip> trips){

        final TripAdapter adapter;

        adapter = new TripAdapter(this,trips);
        tripSearchList.setAdapter(adapter);

        // Click event for single list row
        tripSearchList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int position,final long id) {
                TripManager tripManager = new TripManager(getApplicationContext());
                final Trip trip = tripManager.getTripWithId(id);

                ClientApi.getInstance().getDriver(trip, new ClientApi.APIListener() {
                    @Override
                    public void callback() {
                        FragmentManager fragmentManager = getSupportFragmentManager();
                        Fragment moreTravel = new MoreTravelFragment();
                        Bundle args = new Bundle();
                        args.putString("start", trip.getStart());
                        args.putString("arrival", trip.getArrival());
                        args.putString("datetime", trip.getDateTimeStart());
                        args.putString("distanceTravel", trip.getDistance());
                        args.putString("timeTravel", trip.getDuration());
                        args.putInt("driver", trip.getDriver());
                        args.putLong("idTrip", id);
                        args.putBoolean("buttonReserved",true);
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
    }

    @Override
    public void returnDateSearch(String dateSearch) {
        this.dateSearch = dateSearch;
        Log.e("TEST DATE SEARCH  : ", this.dateSearch);
    }

    @Override
    public void returnTimeSearch(String timeSearch) {
        this.timeSearch = timeSearch;
        Log.e("TEST DATE SEARCH  : ", this.timeSearch);
    }

    @Override
    public void onReservationClick(Long idTrip) {

        ClientApi.getInstance().reserveTheTrip(User.getInstance().getToken(), String.valueOf(idTrip), new ClientApi.APIListener() {
            @Override
            public void callback() { /* not used */ }

            @Override
            public void searchResultsCallback(ArrayList<Trip> trips) {
            }
        });

    }

    /**
     * A placeholder fragment containing a simple view.
     */
    public static class PlaceholderFragment extends Fragment {


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

            return rootView;
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


    public void showTimeStartSearchPickerDialog(View v) {
        FragmentTransaction ft = getFragmentManager().beginTransaction();
        DialogFragment newFragment = new TimePickerFragment();
        Bundle args = new Bundle();
        args.putInt("infoTime", 2);
        newFragment.setArguments(args);
        newFragment.show(ft, "timePicker");
    }
}
