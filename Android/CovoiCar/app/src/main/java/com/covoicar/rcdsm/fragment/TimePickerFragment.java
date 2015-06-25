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
public  class TimePickerFragment extends DialogFragment
        implements TimePickerDialog.OnTimeSetListener {

    private int info;

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        // Use the current time as the default values for the picker
        final Calendar c = Calendar.getInstance();
        int hour = c.get(Calendar.HOUR_OF_DAY);
        int minute = c.get(Calendar.MINUTE);

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

        Bundle args = new Bundle();

        if (info==0){
            ((TextView) getActivity().findViewById(R.id.textTimeStart)).setText("Heure : "+formattedDate);
            args.putString("hoursStart",formattedDate);
        }else if(info==1) {
            ((TextView) getActivity().findViewById(R.id.textTimeArrival)).setText("Heure : "+formattedDate);
            args.putString("hoursArrival",formattedDate);
        }
    }
}
