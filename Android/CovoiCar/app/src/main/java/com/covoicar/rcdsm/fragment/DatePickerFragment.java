package com.covoicar.rcdsm.fragment;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.os.Bundle;
import android.widget.DatePicker;
import android.widget.TextView;

import com.covoicar.rcdsm.covoicar.R;

import java.text.SimpleDateFormat;
import java.util.Calendar;

/**
 * Created by rcdsm on 25/06/15.
 */
public class DatePickerFragment extends DialogFragment
        implements DatePickerDialog.OnDateSetListener {

    private int info;

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        // Use the current date as the default date in the picker
        final Calendar c = Calendar.getInstance();
        int year = c.get(Calendar.YEAR);
        int month = c.get(Calendar.MONTH);
        int day = c.get(Calendar.DAY_OF_MONTH);


        // Create a new instance of DatePickerDialog and return it
        return new DatePickerDialog(getActivity(), this, year, month, day);
    }

    public void setArguments(Bundle args) {
        super.setArguments(args);
        info = args.getInt("infoDate");
    }

    public void onDateSet(DatePicker view, int year, int month, int day) {
        // Do something with the date chosen by the user
        Calendar c = Calendar.getInstance();
        c.set(year, month, day);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String formattedDate = sdf.format(c.getTime());

        Bundle args = new Bundle();

        if (info==0){
            ((TextView) getActivity().findViewById(R.id.textDateStart)).setText("Date : "+formattedDate);
            args.putString("dateStart",formattedDate);
        }else if(info==1) {
            ((TextView) getActivity().findViewById(R.id.textDateArrival)).setText("Date : "+formattedDate);
            args.putString("dateArrival",formattedDate);
        }else if(info==2) {
            ((TextView) getActivity().findViewById(R.id.textDateStartSearch)).setText("Date : "+formattedDate);
        }

    }
}
