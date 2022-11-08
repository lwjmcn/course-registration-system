package student;

import java.sql.*;
import java.util.ArrayList;

import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.Reader;

import classes.Classes;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class StudentDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    private String DBPassWord;

    public StudentDAO()
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
    private void ReadJsonFile()
    { // DB password json 파일로 분리,보안
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
    public int login(String userID, String userPassword) // 학생 로그인 식별
    {
        String SQL = "SELECT 비밀번호 FROM STUDENT WHERE 아이디 = ?";
        try{
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();
            if(rs.next())
            {
                if(rs.getString(1).equals(userPassword))
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
    public Student showMe(String userID) // 로그인한 학생 본인 정보
    {
        String SQL = "SELECT * FROM STUDENT WHERE 아이디 = ?";
        Student student = new Student();
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();
            if(rs.next())
            {
                student.setStudentID(rs.getString(1));
                student.setUserID(rs.getString(2));
                student.setUserPassword(rs.getString(3));
                student.setStudentName(rs.getString(4));
                student.setStudentGender(rs.getString(5));
                student.setMajorID(rs.getInt(6));
                student.setProfessorID(rs.getString(7));
                student.setStudentYear(rs.getInt(8));
                student.setStudentState(rs.getString(9));
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return student;
    }
    public int showCreditNum(String studentID) // 신청학점 수 반환
    {
        String SQL = "select sum(학점수) from registerclass natural join class where 학생ID=?";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentID);
            rs = pstmt.executeQuery();
            if (rs.next()) // 교시 수에 따라 여러번 받을 수 있다.
            {
                return rs.getInt(1);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return 0;
    }
    public Student showGrade(String studentID) // 평점평균 반환 (관리자 조회)
    {
        String SQL = "select sum((case 성적 when 'A+' then 4.5 when 'A0' then 4.0 when 'B+' then 3.5 when 'B0' then 3.0 when 'C+' then 2.5 when 'C0' then 2.0 when 'D+' then 1.5 when 'D0' then 1.0 when 'F' then 0.0 end)*학점수)/sum(학점수) from credits natural join course where 학생ID=?";
        Student student = new Student();
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentID);
            rs = pstmt.executeQuery();
            if (rs.next()) // 교시 수에 따라 여러번 받을 수 있다.
            {
                student.setGrade(rs.getFloat(1));
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return student;
    }
    public ArrayList<Student> showAll() // 모든 학생 정보 배열로 반환 (관리자 조회)
    {
        String SQL = "SELECT * FROM STUDENT NATURAL JOIN MAJOR JOIN LECTURER WHERE 지도교수ID=강사ID ORDER BY 이름";
        ArrayList<Student> studentList = new ArrayList<Student>();
        try
        {
            pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();

            while(rs.next())
            {
                Student student = new Student();
                student.setMajorID(rs.getInt(1));
                student.setStudentID(rs.getString(2));
                student.setUserID(rs.getString(3));
                student.setUserPassword(rs.getString(4));
                student.setStudentName(rs.getString(5));
                student.setStudentGender(rs.getString(6));
                student.setProfessorID(rs.getString(7));
                student.setStudentYear(rs.getInt(8));
                student.setStudentState(rs.getString(9));
                student.setMajorName(rs.getString(10));
                student.setProfessorName(rs.getString(12));

                studentList.add(student);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return studentList;
    }
    public int updateState(String state, String studentID) // 학생 상태 변경 (관리자, 재학/휴학/자퇴)
    {
        String SQL = "update student set 상태 = ? where 학생ID=?";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1,state);
            pstmt.setString(2,studentID);
            return pstmt.executeUpdate();
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return -1; //데이터베이스오류
    }
    public int ifDrop(String studentID) // 휴학/자퇴로 변경된 경우 수강신청인원에서 제외
    {
        String SQL = "delete from registerclass where 학생ID=?";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1,studentID);
            return pstmt.executeUpdate();
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return -1; //데이터베이스오류
    }
}
