package bbs;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseConnectionTest {
    public static void main(String[] args) {
        String dbURL = "jdbc:mysql://localhost:3306/BBS";
        String dbID = "root";
        String dbPassword = "1234";
        

        try {
            Connection conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
            Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID,dbPassword);
            System.out.println("Database connection successful!");
            conn.close();
        } catch (Exception e) {
            System.out.println("Database connection failed!");
            e.printStackTrace();
        }
    }
}
