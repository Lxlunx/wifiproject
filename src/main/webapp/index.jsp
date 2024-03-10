<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>와이파이 정보 구하기</title>
    <style>
        #wifiTable {
            font-family: Arial, Helvetica, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        #wifiTable td, #wifiTable th {
            border: 1px solid #ddd;
            padding: 8px;
        }

        #wifiTable tr:nth-child(even){background-color: #f2f2f2;}

        #wifiTable tr:hover {background-color: #ddd;}

        #wifiTable th {
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: left;
            background-color: #04AA6D;
            color: white;
        }
    </style>
</head>
<body>
<h1><%= "와이파이 정보 구하기" %>
</h1>
<a href="index.jsp">홈 |</a>
<a href="history.jsp">위치 히스토리 목록 |</a>
<a href="api.jsp">Open API 와이파이 정보 가져오기</a></br>
    <label for="lat">LAT:</label>
    <input type="text" id="lat" name="lat">

    <label for="lnt">, LNT:</label>
    <input type="text" id="lnt" name="lnt">

    <button type="button" onclick="getLocation()">내 위치 가져오기</button>
<button type="button" onclick="getNearbyWIFI()">근처 WIFI 정보 보기</button></form></br></br>
</form>

<table id="wifiTable">
    <tr>
        <th>거리(Km)</th>
        <th>관리번호</th>
        <th>자치구</th>
        <th>와이파이명</th>
        <th>도로명주소</th>
        <th>상세주소</th>
        <th>설치위치(층)</th>
        <th>설치유형</th>
        <th>설치기관</th>
        <th>서비스구분</th>
        <th>망종류</th>
        <th>설치년도</th>
        <th>실내외구분</th>
        <th>WIFI접속환경</th>
        <th>X좌표</th>
        <th>Y좌표</th>
        <th>작업일자</th>
    </tr>
</table>
<script>
    function getLocation() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(showPosition);
        } else {
            alert("Geolocation is not supported by this browser.");
        }
    }

    function showPosition(position) {
        document.getElementById("lat").value = position.coords.latitude;
        document.getElementById("lnt").value = position.coords.longitude;
    }

    function getNearbyWIFI() {
        var lat = document.getElementById("lat").value;
        var lnt = document.getElementById("lnt").value;

        fetch('getNearbyWIFI.jsp?lat=' + lat + '&lnt=' + lnt)
            .then(response => response.text())
            .then(data => {
                var table = document.getElementById("wifiTable");
                table.style.display = "block";
                table.innerHTML += data;
            })
            .catch(error => console.error('Error:', error));
    }
</script>

</body>
</html>