<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Your Profile</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background: #fff; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }
        .card { max-width: 800px; background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 25px 50px rgba(0,0,0,0.15); animation: fadeIn 0.8s ease; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px; background: linear-gradient(90deg, #4361ee, #3a0ca3); }
        .header { background: #f8fafc; padding: 40px; text-align: center; border-bottom: 1px solid #e2e8f0; }
        .icon { width: 100px; height: 100px; background: linear-gradient(135deg, #4361ee, #3a0ca3); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; font-size: 40px; color: white; box-shadow: 0 10px 30px rgba(67,97,238,0.3); }
        .name { font-size: 32px; font-weight: 700; margin-bottom: 8px; color: #1e293b; }
        .title { font-size: 18px; color: #64748b; font-weight: 500; }
        .body { padding: 40px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 25px; }
        .item { padding: 15px 0; border-bottom: 1px solid #f1f5f9; transition: transform 0.3s ease; }
        .item:hover { transform: translateX(5px); }
        .label { display: flex; align-items: center; font-size: 14px; font-weight: 600; color: #64748b; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px; }
        .label i { margin-right: 10px; color: #4361ee; font-size: 16px; width: 20px; text-align: center; }
        .value { font-size: 18px; color: #1e293b; font-weight: 500; padding-left: 30px; }
        .about { grid-column: 1 / -1; margin-top: 10px; }
        .actions { text-align: center; margin-top: 40px; padding-top: 30px; border-top: 1px solid #f1f5f9; }
        .btn { display: inline-flex; align-items: center; padding: 14px 32px; background: #4361ee; color: white; text-decoration: none; border-radius: 10px; font-size: 16px; font-weight: 600; transition: all 0.3s ease; box-shadow: 0 8px 20px rgba(67,97,238,0.3); }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 12px 25px rgba(67,97,238,0.4); background: #3a56d4; }
        .btn i { margin-right: 8px; }
        @media (max-width: 768px) { .body, .header { padding: 30px; } .grid { grid-template-columns: 1fr; } .name { font-size: 26px; } .icon { width: 80px; height: 80px; font-size: 32px; } }
    </style>
</head>
<body>

<%
    String name = (String) session.getAttribute("profileName");
    String studentId = (String) session.getAttribute("profileStudentId");
    String program = (String) session.getAttribute("profileProgram");
    String email = (String) session.getAttribute("profileEmail");
    String hobbies = (String) session.getAttribute("profileHobbies");
    String intro = (String) session.getAttribute("profileIntroduction");
    if (name == null) name = "Not Provided";
    if (studentId == null) studentId = "Not Provided";
    if (program == null) program = "Not Provided";
    if (email == null) email = "Not Provided";
    if (hobbies == null) hobbies = "Not Provided";
    if (intro == null) intro = "Not Provided";
%>

<div class="card">
    <div class="header">
        <div class="icon"><i class="fas fa-user-graduate"></i></div>
        <h1 class="name"><%= name %></h1>
        <div class="title"><%= program %></div>
    </div>
    
    <div class="body">
        <div class="grid">
            <div class="item">
                <span class="label"><i class="fas fa-id-card"></i> Student ID</span>
                <span class="value"><%= studentId %></span>
            </div>
            <div class="item">
                <span class="label"><i class="fas fa-graduation-cap"></i> Program</span>
                <span class="value"><%= program %></span>
            </div>
            <div class="item">
                <span class="label"><i class="fas fa-envelope"></i> Email</span>
                <span class="value"><%= email %></span>
            </div>
            <div class="item">
                <span class="label"><i class="fas fa-heart"></i> Hobbies</span>
                <span class="value"><%= hobbies %></span>
            </div>
            <div class="item about">
                <span class="label"><i class="fas fa-user-circle"></i> About Me</span>
                <span class="value"><%= intro %></span>
            </div>
        </div>
        
        <div class="actions">
            <a href="index.html" class="btn"><i class="fas fa-arrow-left"></i> Back to Form</a>
        </div>
    </div>
</div>

</body>
</html>