package ibm.techsales.demo.was.mq.aa;

import java.io.IOException;
import javax.annotation.Resource;
import javax.jms.ConnectionFactory;
import javax.jms.JMSContext;
import javax.jms.Queue;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * The SendMessageServlet class uses the Javax library to send a message to IBM MQ.
 * The purpose of this is to demonistrate load balancing the message sent to 2 queue managers
 */
@WebServlet("/SendMessage")
public class SendMessageServlet extends HttpServlet {

    @Resource(lookup = "jms/QCF")
    private ConnectionFactory connectionFactory;

    @Resource(lookup = "jms/Q1")
    private Queue queue;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try (JMSContext jmsContext = connectionFactory.createContext()) {
            jmsContext.createProducer().send(queue, "Hello, IBM MQ!");
        }
        resp.getWriter().write("Message sent!");
    }
}
