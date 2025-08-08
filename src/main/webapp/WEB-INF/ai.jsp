
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI 챗봇 - Gemini 2.0 Flash</title>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Noto Sans KR', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .chat-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .chat-header {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            padding: 25px 30px;
            text-align: center;
            position: relative;
        }
        
        .chat-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="2" fill="rgba(255,255,255,0.1)"/><circle cx="80" cy="40" r="3" fill="rgba(255,255,255,0.1)"/><circle cx="40" cy="80" r="1" fill="rgba(255,255,255,0.1)"/></svg>');
        }
        
        .chat-header h1 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
        }
        
        .chat-header p {
            font-size: 16px;
            opacity: 0.9;
            font-weight: 300;
            position: relative;
            z-index: 1;
        }
        
        .chat-body {
            padding: 30px;
        }
        
        .conversation-area {
            min-height: 200px;
            margin-bottom: 30px;
        }
        
        .message {
            margin-bottom: 20px;
            animation: fadeInUp 0.5s ease-out;
        }
        
        .message-label {
            font-size: 14px;
            font-weight: 600;
            color: #666;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .message-content {
            background: #f8fafc;
            border: 2px solid #e2e8f0;
            border-radius: 16px;
            padding: 20px;
            line-height: 1.6;
            font-size: 16px;
            position: relative;
            transition: all 0.3s ease;
        }
        
        .question .message-content {
            background: linear-gradient(135deg, #e3f2fd 0%, #f3e5f5 100%);
            border-color: #90caf9;
        }
        
        .answer .message-content {
            background: linear-gradient(135deg, #e8f5e8 0%, #f1f8e9 100%);
            border-color: #81c784;
        }
        
        .message-content:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }
        
        .input-section {
            background: #f8fafc;
            border-radius: 20px;
            padding: 25px;
            border: 2px solid #e2e8f0;
        }
        
        .input-form {
            display: flex;
            gap: 15px;
            align-items: flex-end;
        }
        
        .input-wrapper {
            flex: 1;
            position: relative;
        }
        
        .input-field {
            width: 100%;
            padding: 18px 24px;
            border: 2px solid #e2e8f0;
            border-radius: 16px;
            font-size: 16px;
            font-family: inherit;
            background: white;
            transition: all 0.3s ease;
            resize: none;
            min-height: 60px;
        }
        
        .input-field:focus {
            outline: none;
            border-color: #4facfe;
            box-shadow: 0 0 0 4px rgba(79, 172, 254, 0.1);
            transform: translateY(-1px);
        }
        
        .submit-btn {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            border: none;
            border-radius: 16px;
            padding: 18px 30px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
            white-space: nowrap;
            box-shadow: 0 4px 15px rgba(79, 172, 254, 0.3);
        }
        
        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(79, 172, 254, 0.4);
        }
        
        .submit-btn:active {
            transform: translateY(0);
        }
        
        .empty-state {
            text-align: center;
            color: #64748b;
            font-size: 18px;
            padding: 40px 20px;
        }
        
        .empty-state i {
            font-size: 48px;
            color: #cbd5e1;
            margin-bottom: 16px;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @media (max-width: 768px) {
            .chat-container {
                margin: 10px;
                border-radius: 16px;
            }
            
            .chat-header {
                padding: 20px;
            }
            
            .chat-header h1 {
                font-size: 24px;
            }
            
            .chat-body {
                padding: 20px;
            }
            
            .input-form {
                flex-direction: column;
                align-items: stretch;
            }
            
            .submit-btn {
                justify-content: center;
            }
        }

        /* 데모용 스타일 추가 */
        .demo-mode {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 1000;
        }

        .demo-btn {
            background: #ff6b6b;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(255, 107, 107, 0.3);
            transition: all 0.3s ease;
        }

        .demo-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.4);
        }
    </style>
</head>
<body>
    <div class="chat-container">
        <div class="chat-header">
            <h1><i class="fas fa-robot"></i> AI 챗봇</h1>
            <p>Gemini 2.0 Flash 기반 지능형 대화 시스템</p>
        </div>
        
        <div class="chat-body">
            <div class="conversation-area" id="conversationArea">
                <!-- 기본적으로는 빈 상태로 시작 -->
                <div class="empty-state" id="emptyState">
                    <i class="fas fa-comments"></i>
                    <p>AI와 대화를 시작해보세요!</p>
                </div>
            </div>
            
            <div class="input-section">
                <form class="input-form" id="chatForm">
                    <div class="input-wrapper">
                        <textarea 
                            id="questionInput"
                            class="input-field" 
                            placeholder="궁금한 것을 물어보세요..."
                            rows="1"
                            required></textarea>
                    </div>
                    <button type="submit" class="submit-btn">
                        <i class="fas fa-paper-plane"></i>
                        질문하기
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- 데모 버튼 -->
    <div class="demo-mode">
        <button class="demo-btn" onclick="showDemo()">데모 보기</button>
    </div>

    <script>
        // 자동으로 textarea 높이 조절
        const textarea = document.getElementById('questionInput');
        textarea.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = Math.min(this.scrollHeight, 120) + 'px';
        });
        
        // 엔터키로 전송 (Shift+Enter는 줄바꿈)
        textarea.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                document.getElementById('chatForm').dispatchEvent(new Event('submit'));
            }
        });
        
        // 폼 제출 이벤트
        document.getElementById('chatForm').addEventListener('submit', function(e) {
            e.preventDefault();
            const question = textarea.value.trim();
            if (question) {
                addMessage(question, 'question');
                textarea.value = '';
                textarea.style.height = 'auto';
                
                // 시뮬레이트된 AI 응답
                setTimeout(() => {
                    const responses = [
                        '안녕하세요! 궁금한 것이 있으시면 언제든 물어보세요.',
                        '네, 도움이 되도록 최선을 다해 답변드리겠습니다.',
                        '좋은 질문이네요! 이에 대해 자세히 설명드리겠습니다.',
                        '물론입니다. 더 구체적인 정보를 제공해드릴 수 있어요.',
                        '이해했습니다. 관련된 정보를 찾아서 알려드리겠습니다.'
                    ];
                    const randomResponse = responses[Math.floor(Math.random() * responses.length)];
                    addMessage(randomResponse, 'answer');
                }, 1000);
            }
        });

        function addMessage(content, type) {
            const conversationArea = document.getElementById('conversationArea');
            const emptyState = document.getElementById('emptyState');
            
            // 첫 메시지면 빈 상태 제거
            if (emptyState) {
                emptyState.remove();
            }
            
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${type}`;
            
            const icon = type === 'question' ? 'fas fa-user' : 'fas fa-robot';
            const label = type === 'question' ? '질문' : 'AI 답변';
            
            messageDiv.innerHTML = `
                <div class="message-label">
                    <i class="${icon}"></i> ${label}
                </div>
                <div class="message-content">
                    ${content}
                </div>
            `;
            
            conversationArea.appendChild(messageDiv);
            
            // 스크롤을 맨 아래로
            conversationArea.scrollTop = conversationArea.scrollHeight;
        }

        function showDemo() {
            // 데모 대화 추가
            const demoConversations = [
                { question: "인공지능이 어떻게 작동하나요?", answer: "인공지능은 기계학습과 신경망을 통해 데이터에서 패턴을 학습하고, 이를 바탕으로 예측이나 결정을 내리는 기술입니다. 마치 인간의 뇌가 경험을 통해 학습하는 것과 비슷한 원리로 작동합니다." },
                { question: "오늘 날씨는 어때요?", answer: "죄송하지만 실시간 날씨 정보는 제공할 수 없습니다. 정확한 날씨 정보는 기상청이나 날씨 앱을 확인해주세요. 대신 날씨와 관련된 일반적인 질문이나 팁은 언제든 도움드릴 수 있습니다!" }
            ];

            // 기존 대화 초기화
            const conversationArea = document.getElementById('conversationArea');
            conversationArea.innerHTML = '';

            let delay = 0;
            demoConversations.forEach(conv => {
                setTimeout(() => addMessage(conv.question, 'question'), delay);
                delay += 1500;
                setTimeout(() => addMessage(conv.answer, 'answer'), delay);
                delay += 2000;
            });
        }
        
        // 포커스 시 스크롤
        textarea.addEventListener('focus', function() {
            setTimeout(() => {
                this.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }, 300);
        });
    </script>
</body>
</html>