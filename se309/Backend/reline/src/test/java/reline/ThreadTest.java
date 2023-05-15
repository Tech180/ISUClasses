package reline;


import reline.users.PasswordEncoder;

/*
//test the password encoder in another thread
public class ThreadTest {

    public void passwordThread() {
        new Thread(() -> {
            try {
                Thread.sleep(200);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            PasswordEncoder.encode("woot");
        }).start();
    }
}
*/
