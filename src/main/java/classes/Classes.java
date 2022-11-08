package classes;

public class Classes {
    private String ClassID;
    private String ClassNum;
    private String CourseID;
    private String CourseName;
    private int MajorID;
    private int Year; //학년
    private int Credit; //학점수
    private String LecturerID;
    private int PersonMax; //수강정원
    private String OpenedYear;
    private int RoomID;
    private float OLAP; //for OLAP
    private String LecturerName; //강사명
    private String MajorName; //전공명
    private int PersonNum; //신청인원
    private String BuildingName; //건물명
    private String Day1; //1교시 요일
    private String Start1; //1교시 시작시간
    private String End1; //1교시 종료시간
    private String Day2; //2교시 요일
    private String Start2; //2교시 시작시간
    private String End2; //2교시 종료시간



    public String getClassID() {
        return ClassID;
    }

    public void setClassID(String classID) {
        ClassID = classID;
    }

    public String getClassNum() {
        return ClassNum;
    }

    public void setClassNum(String classNum) {
        ClassNum = classNum;
    }

    public String getCourseID() {
        return CourseID;
    }

    public void setCourseID(String courseID) {
        CourseID = courseID;
    }

    public String getCourseName() {
        return CourseName;
    }

    public void setCourseName(String courseName) {
        CourseName = courseName;
    }

    public int getMajorID() {
        return MajorID;
    }

    public void setMajorID(int majorID) {
        MajorID = majorID;
    }

    public int getYear() {
        return Year;
    }

    public void setYear(int year) {
        Year = year;
    }

    public int getCredit() {
        return Credit;
    }

    public void setCredit(int credit) {
        Credit = credit;
    }

    public String getLecturerID() {
        return LecturerID;
    }

    public void setLecturerID(String lecturerID) {
        LecturerID = lecturerID;
    }

    public int getPersonMax() {
        return PersonMax;
    }

    public void setPersonMax(int personMax) {
        PersonMax = personMax;
    }

    public String getOpenedYear() {
        return OpenedYear;
    }

    public void setOpenedYear(String openedYear) {
        OpenedYear = openedYear;
    }

    public int getRoomID() {
        return RoomID;
    }

    public void setRoomID(int roomID) {
        RoomID = roomID;
    }

    public float getOLAP() {
        return OLAP;
    }

    public void setOLAP(float OLAP) {
        this.OLAP = OLAP;
    }

    public String getLecturerName() {
        return LecturerName;
    }

    public void setLecturerName(String lecturerName) {
        LecturerName = lecturerName;
    }

    public String getMajorName() {
        return MajorName;
    }

    public void setMajorName(String majorName) {
        MajorName = majorName;
    }

    public int getPersonNum() {
        return PersonNum;
    }

    public void setPersonNum(int personNum) {
        PersonNum = personNum;
    }

    public String getBuildingName() {
        return BuildingName;
    }

    public void setBuildingName(String buildingName) {
        BuildingName = buildingName;
    }

    public String getStart1() {
        return Start1;
    }

    public void setStart1(String start1) {
        Start1 = start1;
    }

    public String getEnd1() {
        return End1;
    }

    public void setEnd1(String end1) {
        End1 = end1;
    }

    public String getStart2() {
        return Start2;
    }

    public void setStart2(String start2) {
        Start2 = start2;
    }

    public String getEnd2() {
        return End2;
    }

    public void setEnd2(String end2) {
        End2 = end2;
    }

    public String getDay1() { return Day1; }

    public void setDay1(String day1) {
        Day1 = day1;
    }

    public String getDay2() {
        return Day2;
    }

    public void setDay2(String day2) {
        Day2 = day2;
    }
}
