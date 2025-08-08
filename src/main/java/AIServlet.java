import com.google.genai.Client;
import com.google.genai.types.Content;
import com.google.genai.types.GenerateContentConfig;
import com.google.genai.types.Part;
import io.github.cdimascio.dotenv.Dotenv;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

// [2]
//@WebServlet("/ai") // localhost:8080/ai
@WebServlet("/") // localhost:8080/
// 이 서블릿을 통해 호출
public class AIServlet extends HttpServlet { // [1]
    // doGet, doPost

    // 경로에 들어갔을 때 (GET) -> 그 때 호출될 기능
    @Override // [3]
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // [I] 배포 시의 이슈 : dotenv를 github에 푸시되는데 포함하면 X
        // - 환경변수를 직접 주입함 (render에서)
//        Dotenv dotenv = Dotenv.load(); // [7]
        Dotenv dotenv = Dotenv.configure()
                .ignoreIfMissing().load(); // 배포환경에서, '없으면 무시'
        // .env 파일이 없으면 에러를 던지는 설정
        String apiKey = dotenv.get("GOOGLE_API_KEY");
        // [8] -> resources/.env
        Client client = Client.builder()
                .apiKey(apiKey).build(); // [9]
        // gemini-2.0-flash
        String data = client.models.generateContent("gemini-2.0-flash",
                        "오늘 저녁 메뉴 추천해줘. 결과만 작성해줘. 마크다운 혹은 꾸미는 문법 없이 평문으로. 100자 이내로 작성해줘.", null)
                .text(); // text를 불러와줌. [10]
//        req.setAttribute("data", "안녕하세요! 반갑습니다!"); // [6]
        req.setAttribute("data", data); // [11]
        req.setAttribute("question", "오늘 저녁 메뉴 추천해줘"); // [question attribute 대응]
        RequestDispatcher dispatcher = req.getRequestDispatcher(
                "/WEB-INF/ai.jsp");
        dispatcher.forward(req, resp); // [4]
        // WEB-INF -> ai.jsp [5]
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // [3]
        // input/post -> paramter
        String question = req.getParameter("question");
        // [2]
        // [II]
        Dotenv dotenv = Dotenv.configure()
                .ignoreIfMissing().load(); // 배포환경에서, '없으면 무시'
        String apiKey = dotenv.get("GOOGLE_API_KEY");
        Client client = Client.builder()
                .apiKey(apiKey).build();
        String data = client.models.generateContent("gemini-2.0-flash",
                        question, GenerateContentConfig.builder().systemInstruction(Content.builder()
                                .parts(Part.builder().text(
                                        "100자 이내로, 마크다운 없이 간결하게 평문으로."))).build()) // [4]
                .text(); // text를 불러와줌.
        req.setAttribute("data", data);
        req.setAttribute("question", question); // input에다 넣었던 것을
        // attribute로 재전달 [5]
        // [1]
        RequestDispatcher dispatcher = req.getRequestDispatcher(
                "/WEB-INF/ai.jsp");
        dispatcher.forward(req, resp);
    }
}