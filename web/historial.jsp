<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="Modelo.Conexion" %>
<% 
    String usuario = request.getParameter("usuario");
    PreparedStatement ps;
    Statement pss;
    ResultSet rt = null; 
    Conexion conn = new Conexion();
    int opcionSeleccionada = 0;
    int count = 0;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="style.css"/>
         <!-- UNICONS -->
        <link rel="stylesheet" href="https://unicons.iconscout.com/release/v4.0.0/css/line.css">
    </head>
    <body>
        <nav class="navbar">
		<h1><img src="./images/gas-logowbg.png" /></h1>
		<div class="navbar__links">
			<a href="homeL.jsp?pagina=1">REPORTES</a>
			<!-- <a class="active" href="registro.jsp">REGISTRAR</a> -->
			<a href="historial.jsp">HISTORIAL</a>
			<i class="uil uil-moon change-theme" id="theme-button"></i>
                        <a href="login?accion=cerrar">CERRAR SESIÓN</a>
		</div>
	</nav>
        
        <form action="historial.jsp" method="post">
            <div class="selectBox">
                <select name="txtAccidente">
                    <option disabled selected>Selecciona una opcion</option>
                    <% 

                        String sql = "SELECT * FROM accidente";
                        try {
                            pss = conn.conectar().createStatement();
                            rt = pss.executeQuery(sql);

                            while(rt.next()) {
                                out.println("<option value="+rt.getInt(1)+">"+rt.getString(2)+"</option>");
                        }


                        } catch(SQLException e) {
                            System.out.println(e.getMessage());
                        }


                    %>
                </select>
                <button type="submit"><i class="uil uil-search"></i></button>
        </div>
        </form>
        
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
				</tr>
			</thead>
			<tbody>
                            <%
                                if(request.getParameter("txtAccidente") != null) {
                                    opcionSeleccionada = Integer.parseInt(request.getParameter("txtAccidente"));
                                    String sql2 = "SELECT u.nombre, t.descripcion, re.\"fecha \", r.descripcion, re.hora, re.\"lugar \" FROM registroaccidente re INNER JOIN tipousuario t on t.tipousuario = 1 INNER JOIN usuario u on re.usuario = u.usuario INNER JOIN ruta r on r.ruta = re.ruta WHERE re.descripcion = ?";
                                try {
                                    ps = conn.conectar().prepareStatement(sql2);
                                    ps.setInt(1, opcionSeleccionada);
                                    rt = ps.executeQuery();
                                    while(rt.next()) {
                                                    count++;
                                                        out.println(
                                                        "<tr>"+
                                                        "<td>"+rt.getString(1)+"</td>" +
                                                        "<td>"+rt.getString(2)+"</td>"+
                                                        "<td>"+rt.getString(3)+"</td>"+
                                                        "<td>"+rt.getString(3)+"</td>"+
                                                        "<td>"+rt.getString(4)+"</td>"+
                                                        "<td>"+rt.getString(5)+"</td>"+
                                                        "<td>"+rt.getString(6)+"</td>"+
                                                        "</tr>"
                                                        );
                                        }
                                    } catch(Exception e) {
                                        System.out.println("Error: " + e.getMessage());
                                    }
                                    if(count == 0) {
                                        out.println("<div class='message'>¡No hay resultados para mostrar!</div>");
                                    }
                                } else {
                                    out.println("<div class='message'>Seleccione una opción</div>");
                                }
                                
                            %>
			</tbody>
		</table>
	</div>
        
        <script type="text/javascript" src="app.js"></script>
    </body>
</html>
