import java.sql.*;
import java.io.*;
 
public class OracleJDBC {
 
	public static void main(String[] argv) {
 
		System.out.println("-------- Oracle JDBC Connection Testing ------");
 
		try {
 
			Class.forName("oracle.jdbc.driver.OracleDriver");
 
		} catch (ClassNotFoundException e) {
 
			System.out.println("Where is your Oracle JDBC Driver?");
			e.printStackTrace();
			return;
 
		}
 
		System.out.println("Oracle JDBC Driver Registered!");

System.setProperty(
  "oracle.net.tns_admin",
  "d:/app/product/product/12.1.0/client_1/network/admin");
		String usr = "dbax";
        String pwd = "dbax";
		String url = "jdbc:oracle:thin:@(DESCRIPTION=(LOAD_BALANCE=YES)(ADDRESS=(PROTOCOL=TCP)(HOST=hostname)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=dbax)(FAILOVER_MODE=(TYPE=SELECT)(METHOD=BASIC)(RETRIES=180)(DELAY=5))))";
        //To read dbname from input...
		//Console console = System.console();
		//System.out.print("Enter dbname: ");
		//BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		//String db_host = null;
		//		try {
        //db_host = br.readLine();
		//} catch (IOException ioe) {
		//	System.out.println("IO error!");
        // System.exit(1);
		//}
		//	System.out.println("db_name is " + db_host);
		//String url = "jdbc:oracle:thin:@" + db_host;
		//	System.out.println("url is " + url);
		Connection connection = null;
		String sql = "select * from global_name" ;
		ResultSet rs = null; 
		try {
 
			connection = DriverManager.getConnection(
					url,usr,pwd);
					Statement stmt = connection.createStatement();
					rs = stmt.executeQuery(sql);
 
		} catch (SQLException e) {
 
			System.out.println("Connection Failed! Check output console");
			e.printStackTrace();
			return;
 
		}
 
		if (connection != null) {
			try{
			while (rs.next())
            System.out.println("Connected to "+rs.getString(1));
			}
			catch (SQLException e) 
			{
			System.out.println("SQL execution failed! Check output console");
			e.printStackTrace();
			}
			//System.out.println("You made it, take control your database now!");
		} else {
			System.out.println("Failed to make connection!");
		}

	}
 
}