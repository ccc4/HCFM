<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HCFM</title>
<!-- CSS only -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">

<!-- JS, Popper.js, and jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<style type="text/css">
	.core {
		margin-top: 30px;
	}
	
	label {
		margin-bottom: 0;
	}
</style>

</head>
<body>
	<div class="core">
		<div class="name_area">
			이름: <input type="text" name="user_name">
		</div>
		<div class="vote_area">
			<table class="vote_table">
			<!-- 
				<tr>
					<td><input type="checkbox" id="select_1" value="select_1"></td>
					<td><label for="select_1">7월28일</label></td>
					<td>1명</td>
				</tr>
				<tr>
					<td><input type="checkbox" id="select_2" value="select_1"></td>
					<td><label for="select_2">7월29일</label></td>
					<td>2명</td>
				</tr>
				<tr>
					<td><input type="checkbox" id="select_3" value="select_1"></td>
					<td><label for="select_3">7월30일</label></td>
					<td>3명</td>
				</tr>
				 -->
			</table>
		</div>
		<div class="btn_area">
			<input onclick="vote_execute()" type="button" name="vote_btn" value="투표하기">
		</div>
	</div>
	
	<script type="text/javascript">

		var cur_data = [];
		
		firstLoad();
	
		function firstLoad() {
			var jsonLocation = '/static/jsonData_tmp.json';
			$.getJSON(jsonLocation, (data)=> {
				makeTable(data);
			})
		}

		function makeTable(data) {
			console.log(data);
			cur_data = data;

			$(".vote_table").empty();
			
			$.each(data, (i, item)=> {
				/* 
				console.log(item.name);
				console.log(item.members);
				console.log(item.members.length);
			 */	
				var name = "";
				var length = "";
				var members = [];
				
				name = item.name;
				length = item.members.length;
				
					for(var j=0;j<item.members.length;j++) {
						/* 
						console.log(item.members[j]);
						 */
						members.push(item.members[j]);
					}
					/* 
				console.log(i + " [name: " + name + ", length: " + length + ", members: " + members);
 */
				var tr = '';
				tr += '<tr>';
				tr += '<td><input class="vote_checkbox" type="checkbox" id="select_' + i + '" value="select_' + i + '"></td>';
				tr += '<td><label for="select_' + i + '">' + name + '</label></td>';
				tr += '<td>(' + length + ')</td>';
				tr += '</tr>';

				$(".vote_table").append(tr);
			});
		}
	
		function vote_execute() {
			console.log("투표하기 버튼 클릭");

			var user_name = $("input[name=user_name]").val().trim();

			if(!(user_name.length > 0)) {
				alert("이름적어");
				return;
			}
			
			var checkArr = []; 
			$(".vote_checkbox:checked").each(function() {
				checkArr.push($(this).val());			
			});

			var value_arr = [];
			for(var i=0;i<checkArr.length;i++) {
				var select = checkArr[i];
				var select_num = select.split("_")[1];
				/* 
				console.log(select_num);
				 */
				value_arr.push(select_num*1);
			}

			console.log("value_arr: " + value_arr);
			
			var new_data = [];
			for(var i=0;i<cur_data.length;i++) {
/* 				
				console.log(cur_data[i]);
 */
				console.log(i+"번째"); 				
				if(value_arr.indexOf(i) > -1) {
					console.log("true");
					console.log(i+"번째 value 있음!");
					var b = cur_data[i];
					console.log("b " + b);
					var new_members = cur_data[i].members;
					console.log("11: " + new_members);
					new_members.push(user_name);
					console.log("22: " + new_members);
					new_data.push(new_members);
				} else {
					console.log("false");
					new_data.push(cur_data[i]);
				}
			}
			makeTable(new_data);
		}

	</script>
</body>
</html>