package file;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class FileDAO {
	private Connection conn;

	public FileDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			String dbID = "root";
			String dbPassword = "1234";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public int upload(String fileName, String fileRealName, int bbsID) {
		String SQL = "INSERT INTO bbs_file VALUES (?,?,?)";
		try {

			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, fileName);
			pstmt.setString(2, fileRealName);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {

		}
		return -1;

	}

//	public void uploadFile(int bbsID, String fileName, String fileRealName) throws IOException {
//		String directory = "/upload/" + bbsID + "/";
//		String filePath = directory + fileRealName;
//
//		File file = new File(filePath);
//		upload(fileName, fileRealName, bbsID);
//	}

	public void deleteFile(int bbsID, String fileName) {
		String SQL = "DELETE FROM bbs_file WHERE bbsID = ?"; // 합니다.

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		//String directory = "D:/CRUD/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/BBS/upload" + bbsID+"/";
		String directory = "/upload/" + bbsID + "/";
		String filePath = directory + "/" + bbsID;
		File directoryPath = new File(filePath);
		if (directoryPath.exists()) {
			File[] files = directoryPath.listFiles();
			for (File file : files) {
				file.delete();
			}
			directoryPath.delete();
		}
	}
	
	
	
	
	
	public int getFileBbsID(String fileName) {
	    String SQL = "SELECT bbsID FROM bbs_file WHERE fileName = ?";
	    try {
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setString(1, fileName);
	        ResultSet rs = pstmt.executeQuery();
	        if (rs.next()) {
	            return rs.getInt("bbsID");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return -1;
	}

}