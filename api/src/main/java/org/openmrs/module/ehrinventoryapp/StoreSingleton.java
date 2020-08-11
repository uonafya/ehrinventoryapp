package org.openmrs.module.ehrinventoryapp;

import java.util.HashMap;

public class StoreSingleton {
    private static StoreSingleton instance = null;
    public static final StoreSingleton getInstance(){
        if (instance == null) {
            instance = new StoreSingleton();
        }
        return instance;
    }
    private static HashMap<String, Object> hash;
    public static HashMap<String, Object> getHash() {
        if( hash == null )
            hash = new HashMap<String, Object>();
        return hash;
    }
}
