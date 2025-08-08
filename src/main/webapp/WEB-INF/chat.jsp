<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<body>
<h2>AI 채팅을 합시다!</h2> <!-- ## -->
<!-- p 태그 : paragraph -->
<h3>오늘의 명언</h3> <!-- ### -->
<p>
    <%= request.getAttribute("saying") %>
</p>
<p>
    이름 : <%= request.getAttribute("name") %>
</p>
</body>
</html>