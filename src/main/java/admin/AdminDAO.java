package admin;

import java.sql.*;
import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.Reader;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class AdminDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    private String DBPassWord;

    public AdminDAO()
    {
        try{
            //ReadJsonFile(); // json parse 실행
            String dbURL = "jdbc:mysql://localhost:3306/mydb?serverTimezone=Asia/Seoul";
            String dbID = "root";
            //String dbPassword = DBPassWord;
            String dbPassword = "benedict@1221";
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    private void ReadJsonFile() // DB password json 파일로 분리,보안
    {
        JSONParser parser = new JSONParser();
        try (FileReader reader = new FileReader("../../../secrets.json")) {
            JSONObject jsonObject = (JSONObject) parser.parse(reader);
            DBPassWord = (String) jsonObject.get("DBPassWord");
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    public int login(String adminID, String adminPassword) //관리자 로그인 식별
    {
        String SQL = "SELECT 관리자PW FROM ADMIN WHERE 관리자ID = ?";
        try{
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, adminID);
            rs = pstmt.executeQuery();
            if(rs.next())
            {
                if(rs.getString(1).equals(adminPassword)) //관리자PW가 입력 받은 비밀번호와 일치하는가?
                {
                    return 1; //로그인 성공
                }
                else
                {
                    return 0; //비밀번호 불일치
                }
            }
            return -1; // 아이디가 없음
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -2; // 데이터베이스 오류
    }
}
