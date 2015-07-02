package com.covoicar.rcdsm.fragment;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.covoicar.rcdsm.covoicar.R;
import com.covoicar.rcdsm.models.User;

/**
 * Created by rcdsm on 25/06/15.
 */

/**
 *Fragment Search
 */
public class SearchFragment extends Fragment {

    private Button searchButton;

    @Override
    public View onCreateView(LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_search, container, false);
        /**
         * Inflate the layout for this fragment
         */
        searchButton = (Button)view.findViewById(R.id.buttonSearch);
        User user = User.getInstance();

        searchButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((OnSearchTripListener) (getActivity())).onSearchTripClick();
            }
        });

        /**
         * Take all travel create by User and participation travel
         */
        return view;
    }

    /**
     * Listener on button search
     */
    public interface OnSearchTripListener {
        public void onSearchTripClick();
    }
}