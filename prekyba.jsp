<!DOCTYPE html>
<%@page pageEncoding="UTF-8" language="java"%>
<%@page contentType="text/html;charset=UTF-8"%>
<html>
	<head>
		<meta charset="utf-8">
		<style>
			th {
				background-color: #A52A2A
			}
		</style>
	</head>
<body>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>

<%
// String id = request.getParameter("userId");
	String driverName = "com.mysql.jdbc.Driver";
	String connectionUrl = "jdbc:mysql://localhost:3306/";
	String dbName = "gyv_karalyste";
	String userId = "root";
	String password = "";
/*
try {
Class.forName(driverName);
} catch (ClassNotFoundException e) {
e.printStackTrace();
}
*/
	Connection connection = null;
	Statement statement = null;
	ResultSet resultSet = null;
	Statement statement_take = null;
	
/*
	2	id	int(10)
	3	pav	varchar(24) utf8_lithuanian_ci
	4	kar_pav	varchar(24) utf8_lithuanian_ci
	5	valgomas	tinyint(1)
	
*/
%>
<form method="post" action="">
<table>
<tr>
	<th>Karalyste</th>
	<td>
		<input type="text" name="pav" required>
	</td>
</tr>

<tr>

		<td>
		
			<input type="submit" name="search" value="Ieskoti">
		</td>	
</tr>
</table>
<h2 align="center"><strong>Retrieve data from database in jsp</strong></h2>
<table align="center" cellpadding="5" cellspacing="5" border="1">
<tr>

</tr>
<tr>
	<th>kodas</th>
	<th>Pavadinimas</th>
	<th>sk_karalysciu..</th>
	<th>sugrupuota</th>
</tr>

<%

	try{
	     
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");		
		
	} catch(Exception e) {}

	try { 
	
		connection = DriverManager.getConnection ( connectionUrl + dbName + "?useUnicode=yes&characterEncoding=UTF-8", userId, password );
		String ivestis = request.getParameter ("search");
		String data;
		String where_part = "WHERE 1";
		
		if ( ivestis != null ) {
		
			data = request.getParameter ("pav");																																// Miestai miestas = new Miestai ( lent_miestu );
			where_part += " AND `sub_karalyste`.`kar_pav`= '"+ data +"'";																																				// miestas.takeFromParams ( request );
		 } 
					 		
		String datax = 
			"SELECT `domenas`.*"	 
			+ ", COUNT( `karalystes`.`id` ) AS `sk_karalysciu` " 
			+ ", GROUP_CONCAT( CONCAT( `karalystes`.`pav`, '(', `sub_karalyste`.`pav`, ') ') ) AS `sugrupuota`"
			+ "FROM `domenas` "
			+ "LEFT JOIN `karalystes` ON ( `karalystes`.`domeno_kodas`=`domenas`.`kodas` ) "
			+ "LEFT JOIN `sub_karalyste` ON ( `karalystes`.`pav`=`sub_karalyste`.`kar_pav` ) "
			+ where_part
			+ "GROUP BY `domenas`.`kodas`";
			
			out.println ( datax );

			statement_take = connection.createStatement();	
			resultSet = statement_take.executeQuery(datax);
			
	/*	String jdbcutf8 = ""; //  "&useUnicode=true&characterEncoding=UTF-8";	
		connection = DriverManager.getConnection ( connectionUrl + dbName + jdbcutf8, userId, password );
		
		statement=connection.createStatement();		
		//String sql ="SELECT * FROM `sub_karalyste`  WHERE 1";

		resultSet = statement.executeQuery(
				"SELECT `domenas`.*"	 
				+ ", COUNT( `karalystes`.`id` ) AS `sk_karalysciu` " 
				+ ", GROUP_CONCAT( CONCAT( `karalystes`.`pav`, '(', `sub_karalyste`.`pav`, ') ') ) AS `sugrupuota`"
				+ "FROM `domenas` "
				+ "LEFT JOIN `karalystes` ON ( `karalystes`.`domeno_kodas`=`domenas`.`kodas` ) "
				+ "LEFT JOIN `sub_karalyste` ON ( `karalystes`.`pav`=`sub_karalyste`.`kar_pav` ) "
				+ "WHERE `sub_karalyste`.`kar_pav`= '""'
				+ "GROUP BY `domenas`.`kodas`"
			);*/
		 
		while( resultSet.next() ){
%>
<tr style="background-color: #DEB887">
	<td><%= resultSet.getString ( "kodas" ) %></td>
	<td><%= resultSet.getString ( "pavadinimas" ) %></td>
	<td><%= resultSet.getString  ("sk_karalysciu" ) %></td>
	<td><%=resultSet.getString ( "sugrupuota" ) %></td>
</tr>

<% 
		}

	} catch (Exception e) {
	
		e.printStackTrace();
	}
%>
</table>

</form>

</body>