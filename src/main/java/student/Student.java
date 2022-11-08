package student;

public class Student {
    private String StudentID;
    private String UserID; //로그인 아이디
    private String UserPassword; //로그인 비밀번호
    private String StudentName;
    private String StudentGender;
    private int MajorID;
    private String ProfessorID;
    private String ProfessorName; // 지도교수명
    private int StudentYear;
    private String StudentState;
    private String MajorName; // 전공명
    private int CreditNum; // 신청학점 수
    private float Grade; // 평점평균

    public String getStudentID() {
        return StudentID;
    }
    public void setStudentID(String studentID) {
        StudentID = studentID;
    }

    public String getUserID() {
        return UserID;
    }
    public void setUserID(String userID) {
        UserID = userID;
    }

    public String getUserPassword() {
        return UserPassword;
    }
    public void setUserPassword(String userPassword) { UserPassword = userPassword; }

    public String getStudentName() { return StudentName;}
    public void setStudentName(String studentName) { StudentName = studentName;}

    public String getStudentGender() { return StudentGender;}
    public void setStudentGender(String studentGender) { StudentGender = studentGender;}

    public int getMajorID() { return MajorID;}
    public void setMajorID(int majorID) { MajorID = majorID;}

    public String getProfessorID() { return ProfessorID;}
    public void setProfessorID(String professorID) { ProfessorID = professorID;}

    public String getProfessorName() {
        return ProfessorName;
    }

    public void setProfessorName(String professorName) {
        ProfessorName = professorName;
    }

    public int getStudentYear() { return StudentYear;}
    public void setStudentYear(int studentYear) { StudentYear = studentYear;}

    public String getStudentState() { return StudentState;}
    public void setStudentState(String studentState) { StudentState = studentState;}

    public String getMajorName() {
        return MajorName;
    }

    public void setMajorName(String majorName) {
        MajorName = majorName;
    }

    public int getCreditNum() {
        return CreditNum;
    }

    public void setCreditNum(int creditNum) {
        CreditNum = creditNum;
    }

    public float getGrade() {
        return Grade;
    }

    public void setGrade(float grade) {
        Grade = grade;
    }
}
