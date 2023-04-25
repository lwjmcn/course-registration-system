# Course Registration System

## 개발환경

Window10 / IntelliJ IDEA / MySQL

## 실행환경

IntelliJ IDEA 2022.2

MySQL 8.0

Tomcat 9.0.65

SDK Amazon Corretto version 15.0.2

Connector mysql-connector-java-8.0.20.jar

## 개요

- Front-End: 데이터 베이스에 연결 가능한 사용자 어플리케이션을 제작
- Back-End: 주어진 수강 신청 데이터를 기반으로 데이터 베이스를 생성

## 과제 명세

### All

- 지속적인 트랜잭션이 가능한 인터페이스
- 수강 편람 기능
    - 지정 검색: 수업번호(완전일치), 학수번호(완전일치), 교과목명(키워드포함)
    - 신청버튼, 수업번호, 학수번호, 교과목명, 교강사이름, 수업시간, 신청인원/수강정원, 강의실(건물+호수) 표시

### Admin

- 관리자 로그인/로그아웃
- 학생 정보 조회 및 변경
    - 금학기 시간표 조회, 성적 조회, 지도교수 조회, 재학/휴학/자퇴 등 상태 변경
- 과목 상태 조회 및 변경
    - 과목 증원 가능, 수강 허용 반영
- 과목 설강 및 폐강
    - (수강 정원 > 강의실 수용 인원)의 경우 과목 개설 불가
    - 폐강 시 해당 수업 신청/희망한 학생들의 목록에서 과목 내역 삭제
    - 토요일, 평일 18시 이후 수업은 E-러닝 강의로 분류
    - 일요일 과목 개설 불가능
- OLAP 통계 조회
    - (평점 평균 - 특정 과목 학점)이 가장 큰 Top10 과목 추출

### User

- 사용자 로그인/로그아웃
- 수강 신청 및 취소
    - 재수강 여부 표시
    - 수강 신청 이전 희망 수업 신청 가능
    - 수강 신청 내역의 삽입, 삭제, 갱신
        - 이전 성적이 B0 이상일 경우 신청 불가
        - 정원이 다 찼을 경우 해당 과목 신청 불가
        - 동일 시간대 2개 이상의 과목 신청 불가
        - 최대 학점 18학점 제한, 초과 신청 불가
- 수업 시간표 생성
    - E-러닝 강의는 신청내역/희망내역에는 표시되지만, 시간표에는 표시되지 않음

## 디자인 계획

### DataBase Schema

MySQL workbench EER Diagram 활용

![Class table의 1 more :: 강의실ID INT](Course%20Registration%20System%2034207f1a74b04a81adb69d5374bd76ae/DB_Schema.pnghttps://user-images.githubusercontent.com/114637188/234225614-996b2ca9-9d19-4209-8b98-c1cddfe84421.png)

Class table의 1 more :: 강의실ID INT

- 강의실(room): 강의실 개수의 합과 건물의 총 강의실 개수는 같아야 함
- 건물(building): 건물의 총 강의실 개수는 강의실 개수의 합과 같아야 함
- 과목(course)
- 전공(major)
- 성적(credits): 이수 년도(year)에는 학기를 구분하지 않음
- 교강사(lecturer)
- 학생(student): 학생의 지도교수는 교강사 목록에 실제로 존재해야 함
- 수업(class): 신청 수강 정원이 강의실의 수용 인원을 넘을 수 없음
- 수업시간(time) 1900-01-0DTHH:MM:00.000Z (D: 요일, HH: 시, MM: 분)
- admin(관리자), registerclass(수강신청내역), wantclass(수강희망내역) table 추가

```sql
alter table student add constraint CK_studentID check(아이디 not like '%admin%'); 
-- "admin"이 포함된 아이디는 모두 관리자에게 부여하도록 제한을 두었다.
```

```sql
alter table time drop foreign key fk_Time_Class1;
alter table time add constraint fk_Time_Class1 FOREIGN KEY (수업ID) REFERENCES Class(수업ID) ON DELETE CASCADE;

alter table registerclass drop foreign key fk_RegisterClass_Class1;
alter table registerclass add constraint fk_RegisterClass_Class1 FOREIGN KEY (수업ID) REFERENCES Class(수업ID) ON DELETE CASCADE;

alter table wantclass drop foreign key fk_WantClass_Class1;
alter table wantclass add constraint fk_WantClass_Class1 FOREIGN KEY (수업ID) REFERENCES Class(수업ID) ON DELETE CASCADE;
-- class 삭제(폐강) 시 수업시간을 삭제하고, 학생들의 수강신청, 희망목록에서도 삭제되도록 ON DELETE CASCADE 속성을 추가하였다.
```

```sql
ALTER TABLE Time MODIFY 시간ID INT NOT NULL AUTO_INCREMENT;
-- 시간 추가 시 primary key가 자동생성 되도록 수정
```

### Input Data Set

[https://tableconvert.com/ko/csv-to-sql](https://tableconvert.com/ko/csv-to-sql) .csv > sql insert문 변환

registerclass, wantclass에는 따로 insert를 진행하지 않음.

csv 기본 파일에서 학생 아이디/비밀번호 추가.

admin에는 1 tuple만 insert (admin, adminpwd!!). 필요하다면 추가 가능.

### 최종 db script

[SQL_ScriptInsert.txt](https://github.com/lwjmcn/course-registration-system/files/11320642/SQL_ScriptInsert.txt)

### UI 계획

[UI 디자인(1).pdf]([Course%20Registration%20System%2034207f1a74b04a81adb69d5374bd76ae/UI_%25EB%2594%2594%25EC%259E%2590%25EC%259D%25B8(1).pdf](https://github.com/lwjmcn/course-registration-system/files/11320649/UI_.EB.94.94.EC.9E.90.EC.9D.B8.1.pdf))

![MainPage(pdf 1페이지)](https://user-images.githubusercontent.com/114637188/234226202-77fd875d-ad97-4168-b219-6c741ea5101a.png)

MainPage(pdf 1페이지)

## 코드 설명

### 1. DTO/DAO

src/main/java/ 

Classes(수업), Student(학생), Admin(관리자), Credit(성적)를 각각 package로 만들어 하위에 각각 DTO(Student.java 등)와 DAO(StudentDAO.java 등)을 작성함.

DTO 파일: 필요한 attributes와 추가 members(private), getter, setter

DAO 파일: SQL 실행문을 포함한 함수

### AdminDAO

- 관리자 로그인 확인

**`int** login(String adminID, String adminPassword)`

```sql
SELECT 관리자PW FROM ADMIN WHERE 관리자ID = ?
```

### StudentDAO

- 학생 로그인 확인

**`int** login(String userID, String userPassword)`

```sql
SELECT 비밀번호 FROM STUDENT WHERE 아이디 = ?
```

- 학생ID(로그인 정보)로 학생 정보 찾기

`Student showMe(String userID)`

```sql
SELECT * FROM STUDENT WHERE 아이디 = ?
```

- 학생의 신청 학점 수 계산

**`int** showCreditNum(String studentID)`

```sql
select sum(학점수)
from registerclass natural join course
where 학생ID=?
```

- 학생의 평점평균 계산

`Student showGrade(String studentID)`

```sql
select sum((case 성적 when 'A+' then 4.5 
											when 'A0' then 4.0
											when 'B+' then 3.5
											when 'B0' then 3.0
											when 'C+' then 2.5
											when 'C0' then 2.0
											when 'D+' then 1.5
											when 'D0' then 1.0
											when 'F' then 0.0 end)*학점수)/sum(학점수) 
from credits natural join course
where 학생ID=?
```

- 모든 학생 정보 (관리자)

`ArrayList<Student> showAll()`

```sql
SELECT * 
FROM STUDENT NATURAL JOIN MAJOR JOIN LECTURER
WHERE 지도교수ID=강사ID
ORDER BY 이름
```

- 학생 상태 변경 (관리자)

**`int** updateState(String state, String studentID)`

```sql
update student set 상태 = ? where 학생ID=?
-- 상태 : 재학/휴학/자퇴
```

- 휴학/자퇴 시 수강 신청 인원에서 제외 (관리자 상태 변경)

**`int** ifDrop(String studentID)`

```sql
delete from registerclass where 학생ID=?
```

### CreditDAO

- 학생의 과목별 성적 정보

`ArrayList<Credit> courseCredit(String studentID)`

```sql
select credits.과목ID, 과목명, 성적, (case 성적 when 'A+' then 4.5
																								when 'A0' then 4.0 
																								when 'B+' then 3.5 
																								when 'B0' then 3.0 
																								when 'C+' then 2.5 
																								when 'C0' then 2.0 
																								when 'D+' then 1.5 
																								when 'D0' then 1.0 
																								when 'F' then 0.0 end) as 학점 
from credits, course 
where credits.과목ID=course.과목ID and 학생ID=?
```

### ClassesDAO

- 수강편람 검색 조회

`ArrayList<Classes> search(String classNum, String courseID, String courseName)`

```sql
SELECT 수강정원, 수업번호, 과목ID, 과목명, 강사명, 건물명, 강의실ID, 설강연도, 전공명, 학년, 학점수, class.수업ID 
FROM CLASS NATURAL JOIN ROOM NATURAL JOIN BUILDING NATURAL JOIN LECTURER NATURAL JOIN MAJOR 
WHERE 수업번호 = ? or 과목ID = ? or 과목명 like ?
-- 과목명 %?% 처리(java)
-- 수업번호 완전일치, 학수번호 완전일치, 과목명 키워드포함 검색
-- 셋 중 하나라도 만족 시 모두 출력
```

- 수업 신청인원 수

**`int** showPersonNum(String classID)`

```sql
select count(*) 
from registerclass 
where 수업ID=?
```

- 수강정원 조회

**`int** showPersonMax(String classID)`

```sql
select 수강정원 from class where 수업ID=?
```

- 학점수 조회

**`int** showCreditNum(String classID)`

```sql
select 학점수 from class where 수업ID=?
```

- 수업 시간 조회

`String showTime(String classID)`

```sql
select * from time where 수업ID=?
-- java 함수에서 사용자가 보기 쉬운 형태로 변환
```

- OLAP 통계 산출

`ArrayList<Classes> showOLAP()`

```sql
-- 학생별 평점평균: Σ(과목평점*과목학점수)/Σ(과목학점수)
with student_credit(학생ID, 평점평균) as ( 
		select 학생ID, sum((case 성적 when 'A+' then 4.5 
																	when 'A0' then 4.0 
																	when 'B+' then 3.5 
																	when 'B0' then 3.0 
																	when 'C+' then 2.5  
																	when 'C0' then 2.0  
																	when 'D+' then 1.5  
																	when 'D0' then 1.0  
																	when 'F' then 0.0 end)*학점수)/sum(학점수) 
		from credits, course
		where credits.과목ID=course.과목ID
        group by 학생ID),

-- OLAP 통계 결과
	course_OLAP(과목ID, OLAP) as (
		select 과목ID, avg(student_credit.평점평균 - (case 성적 when 'A+' then 4.5 
																												when 'A0' then 4.0 
																												when 'B+' then 3.5 
																												when 'B0' then 3.0 
																												when 'C+' then 2.5  
																												when 'C0' then 2.0  
																												when 'D+' then 1.5  
																												when 'D0' then 1.0  
																												when 'F' then 0.0 end))
        from student_credit natural join credits
        group by 과목ID)

-- 과목명과 함께 TOP10 출력
select 과목ID, 과목명, OLAP
from course_OLAP natural join course
order by OLAP desc
limit 0,10
```

- 수업 전체 조회 (관리자)

`ArrayList<Classes> showAll()`

```sql
SELECT 수강정원, 설강연도, 수업번호, 과목ID, 과목명, 강사명, 전공명, 학년, 학점수, 수업ID 
FROM CLASS NATURAL JOIN LECTURER NATURAL JOIN MAJOR 
ORDER BY 설강연도 DESC, 과목명
```

- 강의실 수용인원 조회

**`int** roomPersonMax(**int** roomID)`

```sql
select 수용정원 from room where 강의실ID=?
```

- 수업 개설 (관리자)

**`int** openClass(String classID, String classNum, String courseID, **int** majorID, **int** year, **int** credit, String lecturerID, **int** personMax, **int** roomID, String start1, String end1, String start2, String end2)`

```sql
SET @courseNameByJoin = (SELECT 과목명 FROM course WHERE 과목ID = ? LIMIT 1); 
-- 과목명 변수 설정

insert into class values(?,?,?,@courseNameByJoin ,?,?,?,?,?,?,?)
-- 수업 목록 추가

insert into time(수업ID, 몇교시, 시작시간, 종료시간) values(?,?,?,?)
-- 시간 목록 추가

-- 제한 조건은 action.jsp에서 다룬다
```

- 수업 폐강 (관리자)

**`int** cancelClass(String classID)`

```sql
delete from class where 수업ID=?
```

- 희망 추가 (학생)

**`int** addWant(String studentID, String classID)`

```sql
insert into wantclass values(?,?)
```

- 희망 삭제 (학생)

**`int** deleteWant(String studentID, String classID)`

```sql
delete from wantclass where 학생ID=? and 수업ID=?
```

- 희망 내역 조회 (학생)

`ArrayList<Classes> showWant(String studentID)`

```sql
select 수강정원, 수업번호, 과목ID, 과목명, 강사명,수업ID,건물명,강의실ID 
from  wantclass natural join class natural join lecturer natural join room natural join building 
where 학생ID=?
```

- 수강 신청 (학생)

**`int** register(String studentID, String classID)`

```sql
insert into registerclass values(?,?)
-- 제한 조건은 action.jsp에서 다룬다
```

- 신청 내역 조회 (학생)

`ArrayList<Classes> showRegister(String studentID)`

```sql
select 수강정원, 수업번호, 과목ID, 과목명, 강사명,수업ID,건물명,강의실ID
from  registerclass natural join class natural join lecturer natural join room natural join building
where 학생ID=?";
```

- 수강 취소 (학생)

**`int** deleteRegister(String studentID, String classID)`

```sql
delete from registerclass 
where 학생ID=? and 수업ID=?
```

- 수업 시간표 생성

`String[][] makeTable(String studentID)`

```sql
select 과목ID,과목명,시작시간,종료시간
from registerclass natural join class natural join time
where 학생ID=?
-- 시간 조회 후
-- 함수에서 2차원 배열 생성
```

- 수강 정원 변경 (관리자)

**`int** updatePersonMax(String personMax, String classID)`

```sql
update class set 수강정원=? 
where 수업ID=?
```

- 수강 허용 (관리자)

**`int** allowRegister(String studentID, String classID)`

```sql
update class set 수강정원=수강정원+1 where 수업ID=?
-- 수강정원 1 증가
insert into registerclass values(?, ?)
-- 학생의 수강신청 목록에 수업 추가
```

- 재수강 여부 표시

`String ifRetake(String studentID,String courseID)`

```sql
select EXISTS 
		( select * 
			from credits 
			where 학생ID=? and 과목ID=? 
			limit 1 )
```

- 재수강 이전 성적

`String showRetakeCredit(String studentID, String classID)`

```sql
select 성적 
from credits natural join class 
where 학생ID = ? and 수업ID = ?
```

- 신청 내역에 이미 존재하는가 (>신청 버튼 비활성화)

**`boolean** ifRegistered(String studentID,String classID)`

```sql
select EXISTS 
		( select 수업ID
			from registerclass
			where 학생ID= ? and 수업ID=?
			limit 1 )
```

- 희망 내역에 이미 존재하는가 (>희망 추가 버튼 비활성화)

**`boolean** ifWanted(String studentID,String classID)`

```sql
select EXISTS
		( select * 
			from wantclass 
			where 학생ID=? and 수업ID=? 
			limit 1 )
```

### 2. JSP (ViewPage/ActionPage)

<aside>
💡 자세한 내용은 코드 주석을 참고해주세요.

</aside>

src/main/java/webapp/WEB_INF/

Action.jsp : 백엔드 처리.

그 외 : html/css/jsp로 프론트엔드(일부 간단한 백엔드 포함) 처리.

모든 페이지의 하단에 copyright 추가.

### 로그인 페이지

- login.jsp: 로그인 화면 구성
    - loginAction.jsp: 로그인 화면에서 로그인 버튼을 누르면 정보를 확인하고 결과를 alert
- logoutAction.jsp: 로그인 이후 화면에서 로그아웃 버튼을 누르면 session invalidate

### 학생 페이지

헤더의 로고를 클릭 시 메인화면으로 이동

헤더 바로 아래의 메뉴에서 5개의 화면을 오갈 수 있다.

헤더 오른쪽 아래에서 학생의 신청학점/최대학점을 확인할 수 있다.

- main.jsp: 로그인 안 되어 있을 시의 메인화면이자, 학생 로그인 이후 메인화면. 수강편람탭. 2022년 수업만 검색할 수 있다.
- Register.jsp: 수강신청 탭. 수강편람과 같이 검색 가능. 이미 신청/희망되어있다면 버튼이 뜨지 않음.
    - RegisterAction.jsp: 수강 신청 버튼 클릭 시, 제한 조건을 확인 후 처리.
    - AddWantAction.jsp: 희망 추가 버튼 클릭 시
- showWant.jsp: 희망 내역을 보여줌. 수강 신청 가능.
    - RegisterAction.jsp: 수강 신청 버튼 클릭 시, 제한 조건을 확인 후 처리.
    - DeleteWantAction.jsp: 희망 삭제 버튼 클릭 시
- showRegister.jsp: 수강신청 내역을 보여줌.
    - DeleteRegisterAction.jsp: 수강 취소 버튼 클릭 시
- showTimetable.jsp: 수강신청 내역을 바탕으로 수업시간표를 생성 후 조회.

### 관리자 페이지

헤더의 로고를 클릭하면 관리자의 메인화면으로 간다.

헤더 바로 아래의 메뉴에서 5개의 화면을 오갈 수 있다.

- AdminMain.jsp: 관리자로 로그인 시 메인화면. 수강편람 탭.
- AdminStudent.jsp : 학생정보 탭. 학생 정보를 볼 수 있으며, 지도교수ID/이름을 모두 표시함.
    - AdminUpdateStudent.jsp : 상태 변경 버튼 클릭 시의 화면. 재학/휴학/자퇴 중 하나를 선택.
        - UdpateStateAction.jsp : 변경 버튼 클릭 시 액션.
    - AdminShowCredit.jsp : 성적 조회 버튼 클릭 시 화면. 평점평균과 과목별 학점 조회.
    - AdminShowTimetable.jsp : 금학기 시간표 조회 버튼 클릭 시 화면. 학생의 신청내역에 따른 시간표를 조회할 수 있다.
- AdminClasses.jsp : 과목정보 탭. 수업 정보를 모두 볼 수 있다. 2022년에 설강된 수업이 먼저 표시된다. 아래 액션들은 2022년 수업에만 적용 가능하다.
    - AdminUpdatePersonMax.jsp : 증원 버튼 클릭 시 화면. 수강정원 변경.
        - UpdatePersonMaxAction.jsp : 증원 버튼 클릭 시 액션.
    - AdminAllowRegister.jsp : 수강 허용 버튼 클릭 시 화면. 학생 학번 입력.
        - AllowRegisterAction.jsp : 허용 버튼 클릭 시 액션.
    - CancelClassAction.jsp : 수업 폐강 버튼 클릭 시 액션.
- AdminOpenClass.jsp : 수업설강 탭. 수업 정보를 입력하면 설강할 수 있다.
    - OpenClassAction.jsp : 설강 버튼 클릭 시 액션. 제한조건을 확인한 후 수업을 추가한다.
- AdminOLAP.jsp : 명세에 따른 OLAP 결과를 보여주는 페이지.
    - 과목별이 아닌 (과목,교수)별로 분리하려고 했으나, 주어진 data set에서 성적에 대한 정보가 수업 단위가 아닌 과목 단위였기 때문에 data set를 수정하지 않고 과목별로 처리함.

### 3. DB Password 파일 분리

reference : [https://hianna.tistory.com/622](https://hianna.tistory.com/622)  

json-simple-1.1.1.jar 프로젝트 라이브러리에 추가

src/secrets.json 생성 : DBPassWord 저장

proj1/.gitignore 생성 : git 업로드 시 secrets.json 제외

DAO.java : secrets.json에서 filereader와 jsonparser를 통해 DBPassWord를 통해 불러옴

<aside>
💡 다만 parsing 과정에서 간헐적으로 오류 발생 > 주석 처리

</aside>

## 실행

### 빌드 및 실행 방법

<aside>
💡 명세와 같은 환경에서 진행했습니다.

</aside>

+MySQL script문을 통해 create table, insert data sets 필요

+UTF-8 encoding, decoding 설정 필요

### 실행 결과

- 수강 편람 검색 0:00
- 관리자 로그인/로그아웃 0:37  / 3:26
- 관리자 수강 개설 및 삭제 가능 1:21
- 관리자 학생/과목 상태 조회 및 변경 0:50 / 2:53
- 관리자 통계 기능 (OLAP) 3:21
- 사용자 로그인/로그아웃 3:27 / 4:57
- 사용자 수강 신청 및 취소 가능 3:49
- 사용자 수업 시간표 생성 가능 4:30
- GUI
- 요구사항 외 추가 기능

[https://youtu.be/__p-3GG7yqc](https://youtu.be/__p-3GG7yqc)

## Trouble Shooting

1. DB를 새로 생성한 후 에러 메시지가 발생하며, 로그인이 실패했다.

```sql
Loading class com.mysql.jdbc.Driver'. This is deprecated. The new driver class is com.mysql.cj.jdbc.Driver'. The driver is automatically registered via the SPI and manual loading of the driver class is generally unnecessary.
```

해결: 에러 메시지에 따라 UserDAO.java 파일에서 `Class.*forName*`을 `com.mysql.cj.jdbc.Driver`로 수정하니 정상적으로 실행됨.

JDBC DriverManager Interface가 업데이트 되면서 경로가 바뀌었다고 하는데 정확한 이유는 잘 모르겠다. json-simple-1.1.1.jar 설치 이후 오류가 발생한 것으로 추정됨.

1. ReadJSONFile 실패, “../../../secrets.json” 경로에서 FileNotFoundException, 해결X
2. 수강편람에서 교과목명을 검색하면 결과에 아무것도 뜨지 않음 
    
    해결: 한글 깨짐. 입력을 받는 jsp파일들의 헤더에 intelliJ default encoding 값을 UTF-8로 변경하고 해당 파일의 코드 상단에 `<%request.setCharacterEncoding("UTF-8"); %>`를 적어줌.
    
3. 과목 설강 시 과목명에 한글을 입력하면 깨져서 출력됨
    
    시도(1): `<% request.setCharacterEncoding("UTF-8");%>`(실패)
    
    시도(2): charset을 “euc-kr”로 변경(실패)
    
    시도(3): [https://blog.okno.co.kr/11](https://blog.okno.co.kr/11) `str = new String(str.getBytes("8859_1"),"KSC5601");`(실패)
    
    해결: 과목명은 학수번호에 의해 결정되므로 SQL 변수 지정을 통해 입력을 받는 대신 데이터베이스에서 값을 가져오는 방식으로 수정함.
    
4. 부트스트랩에서 Modal 코드를 그대로 불러왔는데도 버튼을 클릭했을 때 Modal 창이 뜨지 않음. 부트스트랩 사이트에서는 정상 동작하는 것으로 보아 브라우저 버전의 문제는 아님. 해결X
5. 실행 시 HTTP 404 오류. Origin 서버가 대상 리소스를 위한 현재의 representation을 찾지 못했거나, 그것이 존재하는지를 밝히려 하지 않습니다.
    
    해결: index.jsp는 파일명을 수정할 수 없음. index.jsp 복구.
    
6. 이 외의 오류는 모두 구문 실수(소괄호, 중괄호, capitalizing, ‘==’로 String 비교 시도 등)

## Need to Improve

- UI 계획과 프로그래밍 계획을 더 구체적으로 짠 뒤 시작하자
- 파일명, 함수명, 함수의 순서, SQL문 등의 통일성 부족
- MySQL에서 다이어그램을 바로 테이블로 변환할 수 있다.
    
    다이어그램은 보기 편한 용도라고 생각해서 한글로 만들었는데, 시간이 부족해서 데이터베이스 attribute명들을 전부 한글로 만들게 된 점이 아쉬움
    
- time 값을 1900-01-0D0HH:MM:0.000Z가 아닌 요일/시/분으로 attribute를 나눴다면 더 편하게 접근할 수 있었을 것
- page.jsp와 action.jsp의 폴더를 구분하면 보기 편했을 것
