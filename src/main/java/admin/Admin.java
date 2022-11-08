package admin;

public class Admin {
    private String AdminID; //관리자 로그인 아이디
    private String AdminPW; //관리자 로그인 비밀번호

    public String getAdminID() {
        return AdminID;
    }

    public void setAdminID(String adminID) {
        AdminID = adminID;
    }

    public String getAdminPW() {
        return AdminPW;
    }

    public void setAdminPW(String adminPW) {
        AdminPW = adminPW;
    }
}
