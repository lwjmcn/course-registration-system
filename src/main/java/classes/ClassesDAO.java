package classes;

import java.sql.*;
import java.util.ArrayList;

import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.Reader;
import java.util.Objects;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class ClassesDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    private String DBPassWord;

    public ClassesDAO()
    {
        try{
            //ReadJsonFile(); // json parse 실행
            String dbURL = "jdbc:mysql://localhost:3306/mydb?useUnicode=true&characterEncoding=UTF-8&allowPublicKeyRetrieval=true&serverTimezone=Asia/Seoul";
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
    public ArrayList<Classes> search(String classNum, String courseID, String courseName) // 수강편람 검색 조회
    {
        // 조건 중 하나라도 만족하면 모두 출력
        String SQL = "SELECT 수강정원, 수업번호, 과목ID, 과목명, 강사명, 건물명, 강의실ID, 설강연도, 전공명, 학년, 학점수, class.수업ID FROM CLASS NATURAL JOIN ROOM NATURAL JOIN BUILDING NATURAL JOIN LECTURER NATURAL JOIN MAJOR WHERE 수업번호 = ? or 과목ID = ? or 과목명 like ?";
        ArrayList<Classes> classList = new ArrayList<Classes>();
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, classNum); //완전 일치 검색
            pstmt.setString(2, courseID); //완전 일치 검색
            if(!courseName.equals("")) {
                pstmt.setString(3, "%"+courseName+"%"); //키워드 포함 검색
            } else {
                pstmt.setString(3, "");
            }
            rs = pstmt.executeQuery();

            while(rs.next()) //배열 생성
            {
                Classes classes = new Classes();
                classes.setPersonMax(rs.getInt(1));
                classes.setClassNum(rs.getString(2));
                classes.setCourseID(rs.getString(3));
                classes.setCourseName(rs.getString(4));
                classes.setLecturerName(rs.getString(5));
                classes.setBuildingName(rs.getString(6));
                classes.setRoomID(rs.getInt(7));
                classes.setOpenedYear(rs.getString(8));
                classes.setMajorName(rs.getString(9));
                classes.setYear(rs.getInt(10));
                classes.setCredit(rs.getInt(11));
                classes.setClassID(rs.getString(12));

                classList.add(classes);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return classList;
    }
    public int showPersonNum(String classID) // 신청인원 수 반환
    {
        String SQL = "select count(*) from registerclass where 수업ID=?";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, classID);
            rs = pstmt.executeQuery();
            if (rs.next())
            {
                return rs.getInt(1);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return 0;
    }
    public int showPersonMax(String classID) // 수강정원 반환
    {
        String SQL = "select 수강정원 from class where 수업ID=?";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, classID);
            rs = pstmt.executeQuery();
            if (rs.next())
            {
                return rs.getInt(1);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return 0;
    }
    public int showCreditNum(String classID) // 학점수 반환
    {
        String SQL = "select 학점수 from class where 수업ID=?";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, classID);
            rs = pstmt.executeQuery();
            if (rs.next())
            {
                return rs.getInt(1);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return 0;
    }
    public String showTime(String classID) //수업시간 1900-01-0DTHH:MM:00.000Z를 D(HH:MM-HH:MM)형태로 변환하여 반환
    {
        String SQL = "select * from time where 수업ID=?";
        String time = "";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, classID);
            rs = pstmt.executeQuery();
            while (rs.next()) // 교시 수에 따라 여러번 받을 수 있다.
            {
                int period = rs.getInt(3);
                String tmp = rs.getString(4); //임시로 1900-01-0DTHH:MM:00.000Z 형태로 받아옴
                int d =Integer.parseInt(tmp.substring(9,10)); //요일의 D를 int형으로 변환
                switch(d){case 1: time+="월";break;case 2:time+="화";break;case 3:time+="수";break;case 4:time+="목";break;case 5:time+="금";break;case 6:time+="토";break; default:time+="Invalid";break;}
                time += "(" + tmp.substring(11,16) + " - "; //시작시간
                tmp = rs.getString(5);
                time += tmp.substring(11,16) + ") "; //종료시간
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return time;
    }
    public ArrayList<Classes> showOLAP() // 명세에 따른 OLAP Top10 수업 배열로 반환
    {
        String SQL = "with student_credit(학생ID, 평점평균) as (select 학생ID, sum((case 성적 when 'A+' then 4.5 when 'A0' then 4.0 when 'B+' then 3.5 when 'B0' then 3.0 when 'C+' then 2.5  when 'C0' then 2.0  when 'D+' then 1.5  when 'D0' then 1.0  when 'F' then 0.0 end)*학점수)/sum(학점수) from credits, course where credits.과목ID=course.과목ID group by 학생ID), course_OLAP(과목ID, OLAP) as ( select 과목ID, avg(student_credit.평점평균 - (case 성적 when 'A+' then 4.5 when 'A0' then 4.0 when 'B+' then 3.5 when 'B0' then 3.0 when 'C+' then 2.5  when 'C0' then 2.0  when 'D+' then 1.5  when 'D0' then 1.0  when 'F' then 0.0 end)) from student_credit natural join credits group by 과목ID) select 과목ID, 과목명, OLAP from course_OLAP natural join course order by OLAP desc limit 0,10;";
        ArrayList<Classes> classList = new ArrayList<Classes>();
        try
        {
            pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();

            while(rs.next())
            {
                Classes classes = new Classes();
                classes.setCourseID(rs.getString(1));
                classes.setCourseName(rs.getString(2));
                classes.setOLAP(rs.getFloat(3)); // 차이

                classList.add(classes);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return classList;
    }
    public ArrayList<Classes> showAll() // 관리자 수업 열람(전체)
    {
        // order by 설강연도 desc: 2022년 수업을 가장 상위에 띄우고
        // , 과목명: 그 안에서 과목명 순서로 나열함
        String SQL = "SELECT 수강정원, 설강연도, 수업번호, 과목ID, 과목명, 강사명, 전공명, 학년, 학점수, 수업ID FROM CLASS NATURAL JOIN LECTURER NATURAL JOIN MAJOR ORDER BY 설강연도 DESC, 과목명";
        ArrayList<Classes> classList = new ArrayList<Classes>();
        try
        {
            pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();

            while(rs.next())
            {
                Classes classes = new Classes();
                classes.setPersonMax(rs.getInt(1));
                classes.setOpenedYear(rs.getString(2));
                classes.setClassNum(rs.getString(3));
                classes.setCourseID(rs.getString(4));
                classes.setCourseName(rs.getString(5));
                classes.setLecturerName(rs.getString(6));
                classes.setMajorName(rs.getString(7));
                classes.setYear(rs.getInt(8));
                classes.setCredit(rs.getInt(9));
                classes.setClassID(rs.getString(10));

                classList.add(classes);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return classList;
    }
    public int roomPersonMax(int roomID) // 강의실의 수용인원 반환
    {
        String SQL = "select 수용정원 from room where 강의실ID=?";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, roomID);
            rs = pstmt.executeQuery();
            if(rs.next()) {
               return rs.getInt(1);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return -1; //데이터베이스오류
    }
    public int openClass(String classID, String classNum, String courseID, int majorID, int year, int credit, String lecturerID, int personMax, int roomID, String start1, String end1, String start2, String end2)
    {
        int result = -1;
        String SQL0 = "SET @courseNameByJoin = (SELECT 과목명 FROM course WHERE 과목ID = ? LIMIT 1)"; //학수번호에 따라 과목명 변수에 저장
        try {
            pstmt = conn.prepareStatement(SQL0);
            pstmt.setString(1, courseID);
            result = pstmt.executeUpdate(); //성공
        } catch (Exception e) {
            e.printStackTrace();
            return result; //실패 시 -1 반환
        }
        String SQL = "insert into class values(?,?,?,@courseNameByJoin ,?,?,?,?,?,?,?)"; // 함수 인자, SQL0에서 생성한 변수 insert
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1,classID);
            pstmt.setString(2, classNum);
            pstmt.setString(3, courseID);
            pstmt.setInt(4, majorID);
            pstmt.setInt(5, year);
            pstmt.setInt(6,credit);
            pstmt.setString(7,lecturerID);
            pstmt.setInt(8,personMax);
            pstmt.setString(9,"2022"); //설강시 항상 2022년
            pstmt.setInt(10,roomID);
            result = pstmt.executeUpdate();
        } catch (Exception e)
        {
            e.printStackTrace();
            return result;
        }
        String SQL2 = "insert into time(수업ID, 몇교시, 시작시간, 종료시간) values(?,?,?,?)"; // 수업시간도 insert
        try {
            pstmt = conn.prepareStatement(SQL2);
            pstmt.setString(1,classID);
            pstmt.setString(2,"1");
            pstmt.setString(3,start1);
            pstmt.setString(4,end1);

            result = pstmt.executeUpdate();
        } catch (Exception e){
            e.printStackTrace();
            return result;
        }
        if(start2 != null) { //2교시가 존재하는 경우 insert
            String SQL3 = "insert into time(수업ID, 몇교시, 시작시간, 종료시간) values(?,?,?,?)";
            try {
                pstmt = conn.prepareStatement(SQL3);
                pstmt.setString(1,classID);
                pstmt.setString(2,"2");
                pstmt.setString(3,start2);
                pstmt.setString(4,end2);
                result = pstmt.executeUpdate();
            } catch (Exception e){
                e.printStackTrace();
            }
        }
        return result; //데이터베이스오류
    } //수업개설
    public int cancelClass(String classID) // 수업 폐강
    {
        String SQL = "delete from class where 수업ID=?";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1,classID);
            return pstmt.executeUpdate();
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return -1; //데이터베이스오류
    }
    public int addWant(String studentID, String classID) // 희망 추가 (장바구니)
    {
        String SQL = "insert into wantclass values(?,?)";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentID);
            pstmt.setString(2,classID);
            return pstmt.executeUpdate();
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return -1; //데이터베이스오류
    }
    public int deleteWant(String studentID, String classID) // 희망 삭제
    {
        String SQL = "delete from wantclass where 학생ID=? and 수업ID=?";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentID);
            pstmt.setString(2,classID);
            return pstmt.executeUpdate();
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return -1; //데이터베이스오류
    }
    public ArrayList<Classes> showWant(String studentID) // 희망 추가한 내역을 배열로 반환
    {
        String SQL = "select 수강정원, 수업번호, 과목ID, 과목명, 강사명,수업ID,건물명,강의실ID from  wantclass natural join class natural join lecturer natural join room natural join building where 학생ID=?";
        ArrayList<Classes> classList = new ArrayList<Classes>();
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentID);
            rs = pstmt.executeQuery();

            while(rs.next())
            {
                Classes classes = new Classes();
                classes.setPersonMax(rs.getInt(1));
                classes.setClassNum(rs.getString(2));
                classes.setCourseID(rs.getString(3));
                classes.setCourseName(rs.getString(4));
                classes.setLecturerName(rs.getString(5));
                classes.setClassID(rs.getString(6));
                classes.setBuildingName(rs.getString(7));
                classes.setRoomID(rs.getInt(8));

                classList.add(classes);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return classList;
    }
    public int register(String studentID, String classID) // 수강 신청
    {
        String SQL = "insert into registerclass values(?,?)";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentID);
            pstmt.setString(2, classID);
            return pstmt.executeUpdate();
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return -1; //데이터베이스오류
    }
    public ArrayList<Classes> showRegister(String studentID) // 수강 신청한 내역을 배열로 반환
    {
        String SQL = "select 수강정원, 수업번호, 과목ID, 과목명, 강사명,수업ID,건물명,강의실ID from registerclass natural join class natural join lecturer natural join room natural join building where 학생ID=?";
        ArrayList<Classes> classList = new ArrayList<Classes>();
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentID);
            rs = pstmt.executeQuery();

            while(rs.next())
            {
                Classes classes = new Classes();
                classes.setPersonMax(rs.getInt(1));
                classes.setClassNum(rs.getString(2));
                classes.setCourseID(rs.getString(3));
                classes.setCourseName(rs.getString(4));
                classes.setLecturerName(rs.getString(5));
                classes.setClassID(rs.getString(6));
                classes.setBuildingName(rs.getString(7));
                classes.setRoomID(rs.getInt(8));

                classList.add(classes);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return classList;
    }
    public int deleteRegister(String studentID, String classID) // 수강 신청 취소
    {
        String SQL = "delete from registerclass where 학생ID=? and 수업ID=?";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentID);
            pstmt.setString(2,classID);
            return pstmt.executeUpdate();
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return -1; //데이터베이스오류
    }
    public String[][] makeTable(String studentID) // 수업 시간표 생성, String 2차원 배열 반환
    { // 월~금 오전8시~오후6시까지 표시
        String SQL = "select 과목ID,과목명,시작시간,종료시간 from registerclass natural join class natural join time where 학생ID=?";
        String[][] table = new String[5][20];
        for(int i=0;i<5;i++) //배열 초기화
            for(int j=0;j<20;j++)
                table[i][j]="";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentID);
            rs = pstmt.executeQuery();
            while (rs.next()) // 교시 수에 따라 여러번 받을 수 있다.
            {
                String name = rs.getString(1)+rs.getString(2);
                String start = rs.getString(3);
                String end = rs.getString(4);
                int d = Integer.parseInt(start.substring(9,10)); //요일의 D를 int형으로 변환
                int hh = Integer.parseInt(start.substring(11,13)); //시작시간 시
                int mm = Integer.parseInt(start.substring(14,16)); //시작시간 분
                int hh2 = Integer.parseInt(end.substring(11,13)); //종료시간 시
                int mm2 = Integer.parseInt(end.substring(14,16)); //종료시간 분
                if(hh>=0 && hh<5) hh+=12; // 0시~4시30분에 시작하는 수업은 오후 수업이라고 판단 (DB data set의 모호함)
                if(hh2>=0 && hh2<8) hh2+=12;
                if (d>=1 && d<=5 && hh>=8 && hh<18)
                {
                    for(int i=((hh-8)*2+mm/30); i < ((hh2-8)*2+mm2/30); i++){
                        table[d-1][i] = name; //배열을 학수번호+과목명으로 채운다
                    }
                }
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return table;
    }
    public int updatePersonMax(String personMax, String classID) // 수강정원 변경
    {
        String SQL = "update class set 수강정원=? where 수업ID=?";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1,personMax);
            pstmt.setString(2,classID);
            return pstmt.executeUpdate();
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return -1; //데이터베이스오류
    }
    public int allowRegister(String studentID, String classID) // 수강 허용
    {
        //수강정원 += 1
        String SQL = "update class set 수강정원=수강정원+1 where 수업ID=?;";
        int result = -1;
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1,classID);
            result = pstmt.executeUpdate();
        } catch (Exception e)
        {
            e.printStackTrace();
            return result;
        }
        // 학생의 수강신청 내역에 추가
        String SQL2 = "insert into registerclass values(?, ?)";
        try
        {
            pstmt = conn.prepareStatement(SQL2);
            pstmt.setString(1,studentID);
            pstmt.setString(2, classID);
            result = pstmt.executeUpdate();
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return result; //데이터베이스오류
    }
    public String ifRetake(String studentID,String courseID) //재수강 여부 판단
    {
        String SQL = "select EXISTS (select * from credits where 학생ID=? and 과목ID=? limit 1)"; // 존재하면 1, 아니면 0을 value로 가짐
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentID);
            pstmt.setString(2,courseID);
            rs = pstmt.executeQuery();
            if(rs.next()){
                if(rs.getInt(1)==0) {
                    return "N"; //수강한 적 없음
                } else{
                    return "Y"; //재수강
                }
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return "Invalid"; //데이터베이스오류
    }
    public String showRetakeCredit(String studentID, String classID) // 재수강인 경우 이전 성적 반환
    {
        String SQL = "select 성적 from credits natural join class where 학생ID = ? and 수업ID = ?";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentID);
            pstmt.setString(2,classID);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return rs.getString(1);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return "N"; //수강한 적 없음
    }
    public boolean ifWanted(String studentID,String classID) //희망추가가 이미 되어 있는가 (버튼을 비활성화하는 데 쓰임)
    {
        String SQL = "select EXISTS (select * from wantclass where 학생ID=? and 수업ID=? limit 1)";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentID);
            pstmt.setString(2,classID);
            rs = pstmt.executeQuery();
            if(rs.next()){
                if(rs.getInt(1)==0) {
                    return false;
                } else{
                    return true;
                }
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return false; //데이터베이스오류
    }
    public boolean ifRegistered(String studentID,String classID) //수강신청이 이미 되어 있는가 (버튼을 비활성화하는 데 쓰임)
    {
        String SQL = "select EXISTS (select * from registerclass where 학생ID=? and 수업ID=? limit 1)";
        try
        {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, studentID);
            pstmt.setString(2,classID);
            rs = pstmt.executeQuery();
            if(rs.next()){
                if(rs.getInt(1)==0) {
                    return false;
                } else{
                    return true;
                }
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return false; //데이터베이스오류
    }
}
