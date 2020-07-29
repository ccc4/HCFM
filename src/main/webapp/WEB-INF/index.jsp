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
		<div class="login_area">
			<input type="text" name="user_name" placeholder="이름 입력">
			<input type="button" onclick="login()" value="로그인"> 
		</div>
		<div>
			<span id="login_name"></span>
		</div>
		<div class="vote_area" style="display: none;">
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
			<div class="btn_area">
				<input onclick="vote_execute()" type="button" name="vote_btn" value="투표하기">
			</div>
		</div>
	</div>
	
	<script type="text/javascript">

		var cur_data = [];
		
		dataLoad();
		
		function dataLoad() {
			var jsonLocation = '/static/jsonData_tmp.json';
			$.getJSON(jsonLocation, (data)=> {
				cur_data = data;
			})
		}

		function makeTable(data) {
			/* 
			console.log(data);
			 */
			cur_data = data;

			$(".vote_table").empty();


			var user_name = sessionStorage.getItem("user_name");
			
			$.each(data, (i, item)=> {
				/* 
				console.log(item.name);
				console.log(item.members);
				console.log(item.members.length);
			 */	
				var name = "";
				var length = "";
				var members = [];
				var members_list = "";
				var checked = false;
				
				name = item.name;
				length = item.members.length;
				
					for(var j=0;j<item.members.length;j++) {
						/* 
						console.log(item.members[j]);
						 */
						if(item.members[j] == user_name) {
							checked = true;
						}
						members.push(item.members[j]);
						members_list += (item.members[j]+"<br>");
					}
					/* 
				console.log(i + " [name: " + name + ", length: " + length + ", members: " + members);
 */
				var tr = '';
				tr += '<tr>';
				if(checked) {
					tr += '<td><input class="vote_checkbox" type="checkbox" id="select_' + i + '" value="select_' + i + '" checked="checked"></td>';
				} else {
					tr += '<td><input class="vote_checkbox" type="checkbox" id="select_' + i + '" value="select_' + i + '"></td>';
				}
				tr += '<td><label for="select_' + i + '">' + name + '</label></td>';
				tr += '<td><span onclick="view_members(this)">(' + length + ')</span></td>';
				tr += '<td><span class="members_list" style="display: none;">' + members_list + '</span></td>';
				tr += '</tr>';

				$(".vote_table").append(tr);
			});
		}

		function login() {
			var user_name = $("input[name=user_name]").val().trim();

			if(!(user_name.length > 0)) {
				alert("이름적어");
				$("input[name=user_name]").focus();
				return;
			}
			sessionStorage.setItem("user_name", user_name);

			$(".login_area").hide();
			$("#login_name").html(user_name);
			makeTable(cur_data);
			$(".vote_area").show();
		}
		
		function view_members(obj) {
			$(obj).parent().next().children('.members_list').toggle();
		}
	
		function vote_execute() {
			var user_name = $("input[name=user_name]").val().trim();

			if(!(user_name.length > 0)) {
				alert("이름적어");
				$("input[name=user_name]").focus();
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
/* 
			console.log("value_arr: " + value_arr);
 */

			var new_data = [];
			for(var i=0;i<cur_data.length;i++) {
/* 				
				console.log(cur_data[i]);
 */
				if(value_arr.indexOf(i) > -1) {
					var new_name = cur_data[i].name;
					
					var new_members = cur_data[i].members;
					new_members.push(user_name);

					var new_obj = '{"name":"'+new_name+'","members":'+JSON.stringify(new_members)+'}';
					new_data.push(JSON.parse(new_obj));
				} else {
					new_data.push(cur_data[i]);
				}
			}
			makeTable(new_data);
		}

	</script>
</body>
</html>