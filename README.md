# higher

A new Flutter project for Higher Technical Education.

## Getting Started

A single App for Higher Technical Education
Keep Offline support

On main page, before logging in ask the user which access group they want to login as:


Access Group Levels:
1. Principal (HoI) (referenced as master throughout the app)
2. HoD (referenced as head throughout the app)
3. Teaching Staff member other than HoIs and HoDs (referenced as faculty throughout the app)
4. Non-Teaching Staff member (referenced as ntStaff throughout the app)
5. Parent (referenced as parent throughout the app)
6. Student (referenced as student throughout the app)

- Head, Master, Faculty and ntStaff will login using email
- Parent will login using mobile number
- Student using their enrollment Id;


Data and Features Accessible grouped by access group:
1. Student
    - View Attendance (Month-wise)
    - View Leave Application Status
    - Apply for leave with image attachment
    - View Mid-Sem marks

2. Parent
    - View Attendance (Month-wise) of their wards
    - View Leave Application Status of their wards
    - Apply for leave with image attachment of their wards
    - View Mid-Sem marks of their wards

3. Non-Teaching Staff member
    - View Attendance (Month-wise)
    - View Leave Application Status
    - Apply for leave with image attachment

4. Teaching Staff member (faculty)
    - View Attendance (Month-wise)
    - View Leave Application Status
    - Mark Student Attendance

5. HoDs (heads)
    - View Attendance (Month-wise)
    - View Leave Application Status
    - View Staff members (faculty and ntStaff) attendance
    - Approve/Reject Leave Applications (faculty & ntStaff)

6. HoIs (master)
    - View Department-wise faculty and heads attendance counts
    - Approve/Reject leave requests
    - Mark Attendance (faculty + heads)

A faculty who is also an Head needs to use both of his accounts separately.


///
Leave apply faculty mode application not saved locally. Work on this feature

/// 
Head mode leave approve
update Button of dialog box on student approve and faculty approve
