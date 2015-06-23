package com.covoicar.rcdsm.fragment;

import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.covoicar.rcdsm.covoicar.R;

/**
 * Created by rcdsm on 23/06/15.
 */
public class ConnexionFragment extends Fragment {

    private TextView register;
    private TextView connexion;

    @Override
    public View onCreateView(LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_connexion, container, false);
        /**
         * Inflate the layout for this fragment
         */
        register = (TextView)view.findViewById(R.id.buttonInscription);
        register.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((OnRegisterClickListener)(getActivity())).onRegisterClick();
            }
        });

        connexion = (TextView)view.findViewById(R.id.buttonConnexion);
        connexion.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((OnConnexionClickListener)(getActivity())).onConnexionClick();
            }
        });

        return view;
    }

    public interface OnRegisterClickListener {
        public void onRegisterClick();
    }

    public interface OnConnexionClickListener {
        public void onConnexionClick();
    }
}
