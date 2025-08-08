<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <title>내가 만든 챗봇</title>
    <meta property="og:title" content="내가 만든 챗봇">
    <meta property="og:description" content="Gemini 2.0 Flash로 구현한 챗봇">
    <style>
        @font-face {
            font-family: 'SunBatang-Light';
            src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_eight@1.0/SunBatang-Light.woff') format('woff');
        }
        body {
            font-family: 'SunBatang-Light', 'Apple SD Gothic Neo', 'Malgun Gothic', sans-serif;
            background: #e5e5e5;
            margin: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }
        .chat-frame {
            background: #f9f9f9;
            border-radius: 18px;
            box-shadow: 0 4px 24px 0 rgba(31, 38, 135, 0.07);
            margin-top: 60px;
            padding: 38px 30px 30px 30px;
            min-width: 340px;
            min-height: 350px;
        }
        .bubble-row {
            display: flex;
            margin-bottom: 14px;
        }
        .bubble-user {
            margin-left: auto;
            max-width: 75%;
            background: #fee500;
            color: #232323;
            border-radius: 16px 16px 4px 16px;
            padding: 12px 15px;
            font-size: 1.05em;
            box-shadow: 0 2px 6px 0 rgba(230,220,80,0.08);
            word-break: break-word;
            font-weight: bold;
        }
        .bubble-bot {
            margin-right: auto;
            max-width: 75%;
            background: #fff;
            color: #333;
            border-radius: 16px 16px 16px 4px;
            padding: 12px 15px;
            font-size: 1.05em;
            box-shadow: 0 2px 6px 0 rgba(140,150,170,0.10);
            border: 1px solid #f2f2f2;
            word-break: break-word;
        }
        form {
            display: flex;
            gap: 8px;
            align-items: center;
            margin-top: 25px;
        }
        input[name="question"] {
            flex: 1;
            padding: 12px 18px;
            border-radius: 22px;
            border: 1.5px solid #eee;
            font-size: 1em;
            background: #fafafa;
            outline: none;
            transition: border 0.18s;
        }
        input[name="question"]:focus {
            border: 1.5px solid #ffe066;
            background: #fff;
        }
        button[type="submit"], button {
            background: #fee500;
            color: #232323;
            border: none;
            border-radius: 18px;
            padding: 12px 24px;
            font-size: 1em;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 2px 8px 0 rgba(230,220,80,0.13);
            transition: background 0.15s, transform 0.12s;
            white-space: nowrap;
            min-width: 80px;
            letter-spacing: 1px;
        }
        button[type="submit"]:hover, button:hover {
            background: #ffec82;
            transform: translateY(-2px) scale(1.05);
        }
    </style>
</head>
<body>
<div class="chat-frame">
    <!-- 질문 -->
    <div class="bubble-row">
        <div class="bubble-user">
            질문 : <%= request.getAttribute("question") != null ? request.getAttribute("question") : " " %>
        </div>
    </div>
    <!-- 답변 -->
    <div class="bubble-row">
        <div class="bubble-bot">
            답변 : <%= request.getAttribute("data") != null ? request.getAttribute("data") : " " %>
        </div>
    </div>
    <form method="post">
        <input name="question" placeholder="메시지를 입력하세요" autocomplete="off" required>
        <button type="submit">전송</button>
    </form>
</div>
</body>
</html>
