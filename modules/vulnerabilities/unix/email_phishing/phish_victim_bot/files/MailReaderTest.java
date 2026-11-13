import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.MimeMessage;
import java.nio.file.DirectoryStream.Filter;

class MailReaderTest {

    private String[] input;
    private String[] anotherInput;
    private Message message;
    @Mock
    private Session session;

    @BeforeEach
    public void setUp() {
        input = new String[]{"apple", "pear", "banana"};
        anotherInput = "apple pear banana".split(" ");
        message = new MimeMessage(session);
    }

    @Test
    void test_containKeywords_worksWithThreeStringsAndThreeOccurrences() throws Exception {
        message.setText("I can see an apple, a banana and a pear.");
        Filter<Message> filter = MailReader.containsKeywords(input, 3);
        assert filter.accept(message);
    }

    @Test
    void test_containKeywords_worksWithThreeStringsAndTwoOccurrences() throws Exception {
        message.setText("I can see an apple and a pear.");
        Filter<Message> filter = MailReader.containsKeywords(input, 2);
        assert filter.accept(message);
    }

    @Test
    void test_containKeywords_worksWithThreeStringsAndOneOccurrence() throws Exception {
        message.setText("I can see an apple.");
        Filter<Message> filter = MailReader.containsKeywords(input, 1);
        assert filter.accept(message);
    }

    @Test
    void test_containKeywords_worksWithThreeStringsAndZeroOccurrences() throws Exception {
        message.setText("I can see nothing.");
        Filter<Message> filter = MailReader.containsKeywords(input, 0);
        assert filter.accept(message);
    }

    @Test
    void test_containKeywords_worksWithThreeStringsAndThreeOccurrences_withRepetition() throws Exception {
        message.setText("I can see an apple, a pear, a banana and an apple.");
        Filter<Message> filter = MailReader.containsKeywords(input, 3);
        assert filter.accept(message);
    }
    @Test
    void test_containKeywords_worksWithThreeStringsAndThreeOccurrences_withAlternativeInput() throws Exception {
        message.setText("I can see an apple, a banana and a pear.");
        Filter<Message> filter = MailReader.containsKeywords(anotherInput, 3);
        assert filter.accept(message);
    }

    @Test
    void test_containKeywords_worksWithThreeStringsAndTwoOccurrences_withAlternativeInput() throws Exception {
        message.setText("I can see an apple and a pear.");
        Filter<Message> filter = MailReader.containsKeywords(anotherInput, 2);
        assert filter.accept(message);
    }

    @Test
    void test_containKeywords_worksWithThreeStringsAndOneOccurrence_withAlternativeInput() throws Exception {
        message.setText("I can see an apple.");
        Filter<Message> filter = MailReader.containsKeywords(anotherInput, 1);
        assert filter.accept(message);
    }

    @Test
    void test_containKeywords_worksWithThreeStringsAndZeroOccurrences_withAlternativeInput() throws Exception {
        message.setText("I can see nothing.");
        Filter<Message> filter = MailReader.containsKeywords(anotherInput, 0);
        assert filter.accept(message);
    }

    @Test
    void test_containKeywords_worksWithThreeStringsAndThreeOccurrences_withRepetition_andAlternativeInput() throws Exception {
        message.setText("I can see an apple, a pear, a banana and an apple.");
        Filter<Message> filter = MailReader.containsKeywords(anotherInput, 3);
        assert filter.accept(message);
    }

}