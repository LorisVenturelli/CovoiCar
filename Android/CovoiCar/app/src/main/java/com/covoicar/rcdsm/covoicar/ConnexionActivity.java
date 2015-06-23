package com.covoicar.rcdsm.covoicar;

/**
 * Created by rcdsm on 23/06/15.
 */

import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.widget.EditText;
import android.widget.Toast;

import com.androidquery.AQuery;
import com.covoicar.rcdsm.fragment.ConnexionFragment;
import com.covoicar.rcdsm.fragment.LoginFragment;
import com.covoicar.rcdsm.fragment.RegisterFragment;

public class ConnexionActivity extends ActionBarActivity implements ConnexionFragment.OnRegisterClickListener,ConnexionFragment.OnConnexionClickListener,RegisterFragment.OnFirstConnexionClickListener,LoginFragment.OnLoginClickListener {

    private AQuery      aq;
    private EditText    firstName;
    private EditText    lastName;
    private EditText    email;
    private EditText    password;
    private EditText    newEmail;
    private EditText    newPassword;
    private EditText    confirmationPassword;

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.login_layout);

        ClientAPI.createInstance(getApplicationContext());
        SharedPreferences preferences = getApplicationContext().getSharedPreferences("Login", Context.MODE_PRIVATE);

        if(preferences.contains("Token")){
            Intent intent = new Intent(ConnexionActivity.this,MainActivity.class);
            startActivity(intent);
            finish();
        }

        FragmentManager fragmentManager = getFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();

        ConnexionFragment connexion = new ConnexionFragment();
        fragmentTransaction.replace(R.id.connexion_fragment, connexion);

        fragmentTransaction.commit();

    }

    @Override
    public void onConnexionClick() {

        FragmentManager fragmentManager = getFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();

        LoginFragment login = new LoginFragment();
        fragmentTransaction.replace(R.id.connexion_fragment, login);

        fragmentTransaction.commit();

    }

    @Override
    public void onFirstConnexionClick() {

        firstName = (EditText)findViewById(R.id.editFirstName);
        lastName = (EditText)findViewById(R.id.editLasttName);
        newEmail = (EditText)findViewById(R.id.editEmailRegister);
        newPassword = (EditText)findViewById(R.id.editPasswordRegister);
        confirmationPassword = (EditText)findViewById(R.id.editConformation);

        Toast.makeText(getApplicationContext(), "FirstName ="+firstName, Toast.LENGTH_SHORT).show();

   /*     ClientAPI.getInstance().subscrib(newEmail.getText().toString(),newPassword.getText().toString(),confirmationPassword.getText().toString(),new ClientAPI.APIListener() {
            @Override
            public void callback() {
                Intent intent = new Intent(ConnexionActivity.this,MainActivity.class);
                startActivity(intent);
                finish();
            }
        });*/
    }

    @Override
    public void onRegisterClick() {

        FragmentManager fragmentManager = getFragmentManager();
        FragmentTransaction fragmentTransaction = fragmentManager.beginTransaction();

        RegisterFragment register = new RegisterFragment();
        fragmentTransaction.replace(R.id.connexion_fragment, register);

        fragmentTransaction.commit();

    }

    @Override
    public void onLoginClick() {

        email = (EditText)findViewById(R.id.emailLogin);
        password = (EditText)findViewById(R.id.passwordLogin);

        /*ClientAPI.getInstance().connect(email.getText().toString(), password.getText().toString(), new ClientAPI.APIListener() {
            @Override
            public void callback() {
                Intent intent = new Intent(ConnexionActivity.this, MainActivity.class);
                startActivity(intent);
                finish();
            }
        });*/

    }
}



