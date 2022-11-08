package credit;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.Reader;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class CreditDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    private String DBPassWord;

    public CreditDAO()
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

    private void ReadJsonFile() { // DB password json 파일로 분리,보안
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

    public ArrayList<Credit> courseCredit(String studentID) // 학생의 과목별 학점을 배열로 반환 (관리자 - 학생 성적 조회 )
    {
        String SQL = "select credits.과목ID, 과목명, 성적, (case 성적 when 'A+' then 4.5 when 'A0' then 4.0 when 'B+' then 3.5 when 'B0' then 3.0  when 'C+' then 2.5 when 'C0' then 2.0 when 'D+' then 1.5 when 'D0' then 1.0 when 'F' then 0.0 end) as 학점 from credits, course where credits.과목ID=course.과목ID and 학생ID=?";
        ArrayList<Credit> creditList = new ArrayList<Credit>();
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentID);
            rs = pstmt.executeQuery();
            while(rs.next())
            {
                Credit credit = new Credit();
                credit.setCourseID(rs.getString(1));
                credit.setCourseName(rs.getString(2));
                credit.setCredit(rs.getString(3));
                credit.setCreditByNum(rs.getFloat(4));

                creditList.add(credit);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return creditList;
    }
}
