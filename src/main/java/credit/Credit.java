package credit;

public class Credit {
    private String CourseID;
    private String CourseName;
    private String credit; // A+, A0, ...
    private float creditByNum; // 4.5, 4.0, ...

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

    public String getCredit() {
        return credit;
    }

    public void setCredit(String credit) {
        this.credit = credit;
    }

    public float getCreditByNum() {
        return creditByNum;
    }

    public void setCreditByNum(float creditByNum) {
        this.creditByNum = creditByNum;
    }
}
