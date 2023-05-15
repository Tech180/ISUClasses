package com.example.reline;

public interface UsernameView {
    void changeUsername(String newUsername);
    void showError();
    void hideError();
    String getUsername(String username);
    void setError(String error);
    boolean underscoreStart(String username);

}
