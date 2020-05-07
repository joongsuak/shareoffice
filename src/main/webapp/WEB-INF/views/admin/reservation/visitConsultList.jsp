<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="tag" uri="/WEB-INF/tld/custom_tag.tld"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>방문 예약 리스트</title>
<!-- CSS -->
<link href="/resources/include/admin.css" rel="stylesheet">

<!-- js -->
<script type="text/javascript"
	src="/resources/include/js/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="/resources/include/js/common.js"></script>
<script type="text/javascript">
	$(function() {
		//페이지 로드 시 셀렉트 박스 설정
		$("#search").val("<c:out value='${data.search}'/>");

		if ($("#search").val() == 'today') {
			$('#today').attr('selected', 'selected');
		} else if ($("#search").val() == '3day') {
			$('#3day').attr('selected', 'selected');
		} else if ($("#search").val() == 'week') {
			$('#week').attr('selected', 'selected');
		} else {
			$('#viewAll').attr('selected', 'selected');
		}

		//행 클릭 시 상세 페이지 이동을 위한 처리 이벤트
		$(".goDetail").click(function() {
			var v_row = $(this).parents("tr");
			var v_num = v_row.data("num");

			$("#v_num").val(v_num);

			$("#detailForm").attr({
				"method" : "get",
				"action" : "/adminReservation/visitConsultDetail"
			})

			$("#detailForm").submit();
		})

		//선택한 옵션에 따라 테이블 내용 변경
		$("#search").change(function() {
			goPage(1);
		});
	})

	function goPage(page) {
		$("#page").val(page);
		$("#listOption").attr({
			"method" : "get",
			"action" : "/adminReservation/consultList"
		});
		$("#listOption").submit();
	}
</script>
</head>
<body>

	<!-- 상세 페이지 이동을 위한 Form -->
	<form id="detailForm" name="detailForm">
		<input type="hidden" name="v_num" id="v_num"> <input
			type="hidden" name="page" value="${data.page }">
		<!--  <input
			type="hidden" name="pageSize" value="5"> -->
	</form>

	<div class="container">

		<h1>방문상담 예약</h1>
		<!-- 방문 날짜에 따른 조회 옵션 -->
		<form id="listOption">
			<input type="hidden" id="page" name="page" value="${data.page }">

			<select id="search">
				<option id="viewAll" value="viewAll">전체</option>
				<option id="today" value="today">오늘</option>
				<option id="3day" value="3day">3일</option>
				<option id="week" value="week">일주일</option>
			</select>
		</form>
		<!-- 리스트 출력 -->
		<div id="qnaList">
			<table class="qnaList table table-striped table-bordered">
				<colgroup>
					<!-- 번호 -->
					<col width="10%">
					<!-- 이름 -->
					<col width="15%">
					<!-- 연락처 -->
					<col width="20%">
					<!-- 방문 예정일 -->
					<col width="20%">
					<!-- 방문 예정 시간 -->
					<col width="20%">
					<!-- 상담상태 -->
					<col width="15%">
				<thead>
					<tr>
						<th>번호</th>
						<th>이름</th>
						<th>연락처</th>
						<th>방문예정일</th>
						<th>방문예정시간</th>
						<th>상담상태</th>
					</tr>
				</thead>
				<!-- 데이터 출력 -->
				<tbody id="list">
					<c:choose>
						<c:when test="${not empty visitList }">
							<c:forEach var="list" items="${visitList }" varStatus="status">
								<tr class="goDetail" data-num="${list.v_num }"
									style="diplay: inline;">
									<td>${count - status.index}</td>
									<td>${list.v_name }</td>
									<td>${list.v_phone }</td>
									<td>${list.v_date }</td>
									<td>${list.v_time }</td>
									<c:choose>
										<c:when test="${list.v_status eq 1}">
											<td>상담전</td>
										</c:when>
										<c:when test="${list.v_status eq 2}">
											<td>상담완료</td>
										</c:when>
									</c:choose>
								</tr>

							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="5" class="tac">등록된 예약이 존재하지 않습니다</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
		</div>
		<!-- 페이지 네비게이션 -->
		<br> <br>
		<div id="qnaPage">
			<tag:paging page="${param.page }" total="${total }" list_size="10"></tag:paging>
		</div>
	</div>




</body>
</html>