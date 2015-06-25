package com.covoicar.rcdsm.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.covoicar.rcdsm.covoicar.R;

/**
 * Created by rcdsm on 25/06/15.
 */
public class SearchFragment   extends Fragment {


    @Override
    public View onCreateView(LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_search, container, false);
        /**
         * Inflate the layout for this fragment
         */

        return view;
    }
}