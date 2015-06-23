package com.covoicar.rcdsm.fragment;

import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.covoicar.rcdsm.covoicar.R;

/**
 * Created by rcdsm on 23/06/15.
 */
public class LoginFragment extends Fragment {

    private Button login;

    @Override
    public View onCreateView(LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_login, container, false);
        /**
         * Inflate the layout for this fragment
         */
        login = (Button)view.findViewById(R.id.buttonLogin);
        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((OnLoginClickListener)(getActivity())).onLoginClick();
            }
        });
        return view;
    }

    public interface OnLoginClickListener {
        public void onLoginClick();
    }

}
