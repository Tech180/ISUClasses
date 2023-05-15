package reline.messages;

import java.io.IOException;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;

@Controller
@ServerEndpoint(value = "/chat/{username}")
public class relineSocket {

    private static messagesRepository msgRepo;

    @Autowired
    public void setMessageRepository(messagesRepository repo) {
        msgRepo = repo;
    }

    private static Map<Session, String> sessionUsernameMap = new Hashtable<>();
    private static Map<String, Session> usernameSessionMap = new Hashtable<>();

    private final Logger logger = LoggerFactory.getLogger(relineSocket.class);

    @OnOpen
    public void onOpen(Session session, @PathParam("username") String username) throws IOException {

        logger.info("Entered into Open");

        sessionUsernameMap.put(session, username);
        usernameSessionMap.put(username, session);

        sendMessageToPArticularUser(username, getChatHistory());

        String message = "User:" + username + " has Joined the Chat";
        broadcast(message);
    }


    @OnMessage
    public void onMessage(Session session, String message) throws IOException {

        logger.info("Entered into Message: Got Message:" + message);
        String username = sessionUsernameMap.get(session);

        if (message.startsWith("@")) {
            String destUsername = message.split(" ")[0].substring(1);

            sendMessageToPArticularUser(destUsername, "[DM] " + username + ": " + message);
            sendMessageToPArticularUser(username, "[DM] " + username + ": " + message);

        }
        else {
            broadcast(username + ": " + message);
        }

        msgRepo.save(new messages(username, message));
    }


    @OnClose
    public void onClose(Session session) throws IOException {
        logger.info("Entered into Close");

        String username = sessionUsernameMap.get(session);
        sessionUsernameMap.remove(session);
        usernameSessionMap.remove(username);

        String message = username + " disconnected";
        broadcast(message);
    }


    @OnError
    public void onError(Session session, Throwable throwable) {

        logger.info("Entered into Error");
        throwable.printStackTrace();
    }


    private void sendMessageToPArticularUser(String username, String message) {
        try {
            usernameSessionMap.get(username).getBasicRemote().sendText(message);
        }
        catch (IOException e) {
            logger.info("Exception: " + e.getMessage().toString());
            e.printStackTrace();
        }
    }


    private void broadcast(String message) {
        sessionUsernameMap.forEach((session, username) -> {
            try {
                session.getBasicRemote().sendText(message);
            }
            catch (IOException e) {
                logger.info("Exception: " + e.getMessage().toString());
                e.printStackTrace();
            }

        });

    }

    private String getChatHistory() {
        List<messages> messages = msgRepo.findAll();

        StringBuilder sb = new StringBuilder();
        if(messages != null && messages.size() != 0) {
            for (messages message : messages) {
                sb.append(message.getUserName() + ": " + message.getContent() + "\n");
            }
        }
        return sb.toString();
    }

}
