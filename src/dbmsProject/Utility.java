package dbmsProject;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.swing.JOptionPane;

public class Utility {

	public String url = "jdbc:oracle:thin:@coestudb.qu.edu.qa:1521/STUD.qu.edu.qa";
	public String user = "nm2309242";
	public String pw = "nm2309242";
	
	public Connection conn;
	public Statement stmt;
	public PreparedStatement pstmt;
	public ResultSet rs;
	
	public Utility() throws SQLException {
		
		conn = DriverManager.getConnection(url,user,pw);
		stmt = conn.createStatement();
		
	}
	
//	public String[] getData(int dno) throws SQLException{
//		String result[] = new String[2];
//		String sql = "Select dname,loc from dept where deptno="+dno;
//		rs = stmt.executeQuery(sql);
//		
//		if(rs.next()) {
//			result[0] = rs.getString(1);
//			result[1] = rs.getString(2);
//		}
//		
//		return result;
//	}
	public void terminate() throws SQLException {
		JOptionPane.showMessageDialog(null, "Terminating the Connection");
		conn.close();
		System.exit(0);
	}

}

