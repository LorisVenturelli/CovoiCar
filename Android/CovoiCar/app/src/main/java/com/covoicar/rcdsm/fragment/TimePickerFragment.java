package com.covoicar.rcdsm.fragment;

import android.app.Dialog;
import android.app.DialogFragment;
import android.app.TimePickerDialog;
import android.os.Bundle;
import android.text.format.DateFormat;
import android.widget.TextView;
import android.widget.TimePicker;

import com.covoicar.rcdsm.covoicar.R;

import java.text.SimpleDateFormat;
import java.util.Calendar;

/**
 * Created by rcdsm on 25/06/15.
 */

/**
 * Fragment TimePicker display clock
 */
public  class TimePickerFragment extends DialogFragment
        implements TimePickerDialog.OnTimeSetListener {

    TheListenerTimeStart listenerTimeStart;
    TheListenerTimeEnd listenerTimeEnd;
    TheListenerTimeSearch listenerTimeSearch;

    private int info;

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        // Use the current time as the default values for the picker
        final Calendar c = Calendar.getInstance();
        int hour = c.get(Calendar.HOUR_OF_DAY);
        int minute = c.get(Calendar.MINUTE);
        listenerTimeStart = (TheListenerTimeStart) getActivity();
        listenerTimeEnd = (TheListenerTimeEnd) getActivity();
        listenerTimeSearch = (TheListenerTimeSearch) getActivity();

        // Create a new instance of TimePickerDialog and return it
        return new TimePickerDialog(getActivity(), this, hour, minute,
                DateFormat.is24HourFormat(getActivity()));
    }

    public void setArguments(Bundle args) {
        super.setArguments(args);
        info = args.getInt("infoTime");
    }

    public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
        // Do something with the time chosen by the user
        Calendar c = Calendar.getInstance();
        c.set(0,0,0,hourOfDay, minute);
        SimpleDateFormat sdf = new SimpleDateFormat("kk:mm:ss");
        String formattedDate = sdf.format(c.getTime());

        if (info == 0){
            ((TextView) getActivity().findViewById(R.id.textTimeStart)).setText("Heure : "+formattedDate);
            if (listenerTimeStart != null)
            {
                listenerTimeStart.returnTimeStart(formattedDate);
            }
        }else if(info == 1) {
            ((TextView) getActivity().findViewById(R.id.textTimeArrival)).setText("Heure : " + formattedDate);
            if (listenerTimeEnd != null)
            {
                listenerTimeEnd.returnTimeEnd(formattedDate);
            }
        }else if(info == 2) {
            ((TextView) getActivity().findViewById(R.id.textTimeSearch)).setText("Heure : " + formattedDate);
            if (listenerTimeSearch != null)
            {
                listenerTimeSearch.returnTimeSearch(formattedDate);
            }
        }
    }

    /**
     * Listener for time start
     */
    public interface TheListenerTimeStart{
        public void returnTimeStart(String timeStart);
    }

    /**
     * Listener for time end
     */
    public interface TheListenerTimeEnd{
        public void returnTimeEnd(String timeEnd);
    }

    /**
     * Listener for time search
     */
    public interface TheListenerTimeSearch{
        public void returnTimeSearch(String timeSerch);
    }
}
