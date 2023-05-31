package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public UserDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			String dbID = "root";
			String dbPassword ="1234";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID,dbPassword);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	// 로그인 기능 
		public int login(String userID, String userPassword) {
			String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, userID); //sql Injection 공격 방어 수단 : 1번째 물음표에 userID 입력
				rs = pstmt.executeQuery(); // 쿼리 실행 
				if (rs.next()) {
					if (rs.getString(1).equals(userPassword)) // rs.getString(1) : select된 첫번째 컬럼
						return 1; //로그인 성공
					else
						return 0; // 비밀번호 틀림
				}
				return -1; // 아이디 없음 
			}catch(Exception e) {
				e.printStackTrace();
				
			}
			return -2; //DB 오류 
		}

}
