package com.covoicar.rcdsm.fragment;

import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.Spinner;

import com.covoicar.rcdsm.covoicar.R;

import java.util.ArrayList;

/**
 * Created by rcdsm on 23/06/15.
 */

/**
 * Fragment register new user
 */
public class RegisterFragment extends Fragment {

    private Button      connexion;
    private Spinner     gender;
    private Spinner     birthday;

    @Override
    public View onCreateView(LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_register, container, false);
        /**
         * Inflate the layout for this fragment
         */

        gender = (Spinner) view.findViewById(R.id.spinnerGender);
        // Create an ArrayAdapter using the string array and a default spinner layout
        ArrayAdapter<CharSequence> adapterGender = ArrayAdapter.createFromResource(getActivity(),
                R.array.gender_array, android.R.layout.simple_spinner_item);
        // Specify the layout to use when the list of choices appears
        adapterGender.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        // Apply the adapter to the spinner
        gender.setAdapter(adapterGender);


        //Add years inside Spinner
        ArrayList<String> years = new ArrayList<String>();
        years.add("Année de naissance");
        for (int i = 1997; i >= 1900; i--) {
            years.add(Integer.toString(i));
        }
        ArrayAdapter<String> adapterBirthday = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_spinner_item, years);
        birthday = (Spinner)view.findViewById(R.id.spinnerBirthday);
        birthday.setAdapter(adapterBirthday);

        //Add Listener on button
        connexion = (Button) view.findViewById(R.id.buttonConnexionRegister);
        connexion.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((OnFirstConnexionClickListener) (getActivity())).onFirstConnexionClick();
            }
        });
        return view;
    }

    /**
     * Listener on button add new user
     */
    public interface OnFirstConnexionClickListener {
        public void onFirstConnexionClick();
    }
}
