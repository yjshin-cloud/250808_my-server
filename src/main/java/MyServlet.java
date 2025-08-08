import com.google.genai.Client;
import io.github.cdimascio.dotenv.Dotenv;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

// Servlet -> HttpServlet 상속
@WebServlet("/chat") // '/chat'라고 하는 요청을 받을 수 있음
public class MyServlet extends HttpServlet {
    // 일반적인 브라우저 접속 GET
    @Override
    protected void doGet(
            HttpServletRequest req,
            HttpServletResponse resp) throws ServletException, IOException {
        // req -> 인풋 (데이터)
//        req.setAttribute(
//                "키", "값"
//        );
//        req.setAttribute("name", "김자바");
        req.setAttribute("name", "박서블릿");
        Dotenv dotenv = Dotenv.load(); // 이것만해도 불러와진 것
        // dotenv -> 주의해야할 점. 루트경로가 아니라 'resources'안에 .env가 있어야함
        Client client = Client.builder()
                .apiKey(dotenv.get("GOOGLE_API_KEY"))
                .build(); // GOOGLE_API_KEY => 환경변수
        req.setAttribute("saying", client.models.generateContent("gemini-2.0-flash", "오늘 날씨에 어울리는 명언, 결과만 짧게.", null)
                .candidates().get().get(0).content().get().text());
        // resp -> 아웃풋 (화면 표현되는 것, 주소)
        // 화면을 그려주는 것
//        resp.getWriter().println("Hello AI!"); // 직접 print하면 꾸미기 어려움
        // 그렇다고 index.jsp -> 파일을 노출해서 접근하게 만드는 것 -> 자동으로 되는데
        // 그러면 보안적으로 권장되지는 않음
        RequestDispatcher dispatcher = req.getRequestDispatcher(
                "/WEB-INF/chat.jsp");
        dispatcher.forward(req, resp); // forward
        // 넘기기. -> 처리를 여기로 넘겨달라.
    }
}

// 1. HttpServlet을 '상속(Extend)'해야함
// 2. @WebServlet (애너테이션) -> ('/경로')
// 3. doGet -> Override
// 4. resp(HttpServletResponse) -> Writer -> println