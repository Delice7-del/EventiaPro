package org.example.eventiapro.util;

import jakarta.servlet.http.HttpServletRequest;
import org.junit.jupiter.api.Test;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

public class XSSRequestWrapperTest {

    @Test
    public void testSanitizeSimple() {
        HttpServletRequest mockReq = mock(HttpServletRequest.class);
        when(mockReq.getParameter("input")).thenReturn("<script>alert('xss')</script>");
        XSSRequestWrapper wrapper = new XSSRequestWrapper(mockReq);
        assertEquals("&lt;script&gt;alert(&#x27;xss&#x27;)&lt;&#x2F;script&gt;", wrapper.getParameter("input"));
    }

    @Test
    public void testSanitizeNull() {
        XSSRequestWrapper wrapper = new XSSRequestWrapper(mock(HttpServletRequest.class));
        assertNull(wrapper.getParameter(null));
    }

    @Test
    public void testSanitizeAllBlockedChars() {
        // Sanitize with all blocked characters
        // Testing < > & " ' /
        // We'll mock getParameter to return the dirty string
        HttpServletRequest mockReq = mock(HttpServletRequest.class);
        when(mockReq.getParameter("dirty")).thenReturn("<>&\"'/");

        XSSRequestWrapper wrapperWithMock = new XSSRequestWrapper(mockReq);
        assertEquals("&lt;&gt;&amp;&quot;&#x27;&#x2F;", wrapperWithMock.getParameter("dirty"));
    }
}
