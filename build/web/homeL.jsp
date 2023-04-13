<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="Modelo.Conexion" %>
<% 
    Conexion conn = new Conexion();
    Statement ps;
    ResultSet rt; 
    PreparedStatement pss;
    String sentencia = "SELECT * FROM registroaccidente";
    int total = 0;
    try {
        ps = conn.conectar().createStatement();
        rt = ps.executeQuery(sentencia);
        while(rt.next()) {
        total++;
    }
    } catch(Exception e) {
    
    }
    int articulos_x_pagina = 8;
    double paginas = Math.ceil((double)total / articulos_x_pagina);
%>
<%
	if(session.getAttribute("investigador") != null) {	
%> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Inicio</title>
        <link rel="stylesheet" href="style.css" />
        <!-- UNICONS -->
        <link rel="stylesheet" href="https://unicons.iconscout.com/release/v4.0.0/css/line.css">
    </head>
    <body>
        
        <nav class="navbar">
		<h1><img src="./images/gas-logowbg.png" /> </h1>
		<div class="navbar__links">
			<a class="active" href="homeL.jsp?pagina=1">REPORTES</a>
			<!-- <a href="registro.jsp">REGISTRAR</a> -->
			<a href="historial.jsp">HISTORIAL</a>
			<i class="uil uil-moon change-theme" id="theme-button"></i>
			<a href="login?accion=cerrar">CERRAR SESIÓN</a>
		</div>
	</nav>
	
	<div class="table__container">
		<table>
			<thead>
				<tr>
					<th>Nombre completo</th>
					<th>Puesto</th>
					<th>Fecha del suceso</th>
					<th>Fecha Reportada</th>
					<th>Ruta</th>
					<th>Hora</th>
					<th>Lugar exacto</th>
                                        <th>Operaciones</th>
				</tr>
			</thead>
			<tbody>
                            <% 
                                                int pages = Integer.parseInt(request.getParameter("pagina"));
                                                int inicio = (pages - 1)*articulos_x_pagina;
                                                String sql = "SELECT u.nombre, t.descripcion, re.\"fecha \", r.descripcion, re.hora, re.\"lugar \" FROM registroaccidente re INNER JOIN tipousuario t on t.tipousuario = 1 INNER JOIN usuario u on re.usuario = u.usuario INNER JOIN ruta r on r.ruta = re.ruta ORDER BY re.accidente ASC OFFSET ? LIMIT ?";
                                                try {
                                                    pss = conn.conectar().prepareStatement(sql);
                                                    pss.setInt(1, inicio);
                                                    pss.setInt(2, articulos_x_pagina);
                                                    rt = pss.executeQuery();
                                                    while(rt.next()) {
                                                        out.println(
                                                        "<tr>"+
                                                        "<td>"+rt.getString(1)+"</td>" +
                                                        "<td>"+rt.getString(2)+"</td>"+
                                                        "<td>"+rt.getString(3)+"</td>"+
                                                        "<td>"+rt.getString(3)+"</td>"+
                                                        "<td>"+rt.getString(4)+"</td>"+
                                                        "<td>"+rt.getString(5)+"</td>"+
                                                        "<td>"+rt.getString(6)+"</td>"+
                                                        "<td><a class='optionLink' href='registro.jsp?usuario="+rt.getString(1)+"'>Investigar</a></td>"+
                                                        "</tr>"
                                                        );
                                                    }
                                                } catch(SQLException e) {
                                                    System.out.println(e.getMessage());
                                                }
                            %>
			</tbody>
		</table>
	</div>
        
	<div class="pagination">
		<ul>
                    <% int currentPage = Integer.parseInt(request.getParameter("pagina"));%>
                    <li><a class="<%= currentPage - 1 <= 0 ? "disabled" : "" %>" href="homeL.jsp?pagina=<%= currentPage - 1%>">Anterior</a></li>
                    <% for(int i = 0; i < paginas; i++) { %>
                    <li><a class="<%= currentPage == i+1 ? "active" : "" %>" href="homeL.jsp?pagina=<%= i+1%>"><%= i+1 %></a></li>
                    <% } %>
                    <li><a class="<%= currentPage + 1 > paginas ? "disabled" : "" %>" href="homeL.jsp?pagina=<%= currentPage + 1 %>">Siguiente</a></li>
		</ul>
                <%
                    if(currentPage > paginas || currentPage <= 0) {
                        response.sendRedirect("homeL.jsp?pagina=1");
                    }
                %>
	</div> 
	<script type="text/javascript" src="app.js"></script>
    </body>
</html>
<% 
	}else {
		response.sendRedirect("index.jsp");
	}
%>