<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ProfileDAO, bean.ProfileBean" %>
<!DOCTYPE html>
<html>
<head>
    <title>Profile Created</title>
    <style>
        body { background: #f0f2f5; padding: 20px; font-family: Arial; }
        .container { max-width: 600px; margin: auto; }
        .card { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { text-align: center; margin-bottom: 30px; }
        .header h2 { color: #1a73e8; }
        .info { margin: 15px 0; }
        .label { font-weight: bold; color: #555; }
        .value { color: #333; margin-top: 5px; }
        .actions { text-align: center; margin-top: 30px; }
        .btn { background: #1a73e8; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; margin: 0 10px; }
        .btn:hover { background: #0d62d9; }
        .message { 
            background: #d4edda; 
            color: #155724; 
            padding: 15px; 
            border-radius: 5px; 
            margin-bottom: 20px;
            text-align: center;
            font-weight: bold;
        }
        .error { 
            background: #f8d7da; 
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .warning {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }

        .db-status {
            background: #e8f4fd;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
            font-size: 14px;
            text-align: center;
        }
        .db-success { color: #155724; }
        .db-fail { color: #721c24; }
    </style>
</head>
<body>
    <div class="container">
        <%
            String saveStatus = (String) session.getAttribute("saveStatus");
            String studentId = (String) session.getAttribute("profileStudentId");
            
            ProfileBean profile = null;
            boolean inDatabase = false;

            if (studentId != null && !studentId.isEmpty()) {
                ProfileDAO dao = new ProfileDAO();
                profile = dao.getProfileByStudentId(studentId);
                
                if (profile != null) {
                    inDatabase = true;
                    System.out.println("✅ Profile found in database: " + studentId);
                } else {
                    System.err.println("❌ Profile NOT found in database: " + studentId);
                }
            }

            String name, program, email, hobbies;
            
            if (profile != null) {
                name = profile.getName();
                studentId = profile.getStudentId();
                program = profile.getProgramme();
                email = profile.getEmail();
                hobbies = profile.getHobby();
            } else {
                name = (String) session.getAttribute("profileName");
                studentId = (String) session.getAttribute("profileStudentId");
                program = (String) session.getAttribute("profileProgram");
                email = (String) session.getAttribute("profileEmail");
                hobbies = (String) session.getAttribute("profileHobbies");
            }

            if (name == null) name = "Not provided";
            if (studentId == null) studentId = "Not provided";
            if (program == null) program = "Not provided";
            if (email == null) email = "Not provided";
            if (hobbies == null) hobbies = "Not provided";
        %>

        <% if ("success".equals(saveStatus)) { %>
            <div class="message">
                ✅ Profile saved successfully!
                <% if (inDatabase) { %>
                    <div class="db-status db-success">✓ Verified in database</div>
                <% } else { %>
                    <div class="db-status warning">⚠️ Saved to session but NOT in database!</div>
                <% } %>
            </div>
        <% } else if ("failed".equals(saveStatus)) { %>
            <div class="message error">
                ❌ Failed to save profile.
                <% 
                    String error = (String) session.getAttribute("errorMessage");
                    if (error != null && error.contains("duplicate")) { 
                %>
                    <div>Student ID already exists!</div>
                <% } %>
            </div>
        <% } %>
        
        <div class="card">
            <div class="header">
                <h2>📋 Student Profile</h2>
                <div style="font-size: 14px; color: #666; margin-top: 10px;">
                    <% if (inDatabase) { %>
                        <span style="color: green;">✓ Stored in Database</span>
                    <% } else { %>
                        <span style="color: orange;">⚠️ Session Data Only</span>
                    <% } %>
                </div>
            </div>
            
            <div class="info">
                <div class="label">Student ID:</div>
                <div class="value"><%= studentId %></div>
            </div>
            
            <div class="info">
                <div class="label">Name:</div>
                <div class="value"><%= name %></div>
            </div>
            
            <div class="info">
                <div class="label">Programme:</div>
                <div class="value"><%= program %></div>
            </div>
            
            <div class="info">
                <div class="label">Email:</div>
                <div class="value">
                    <% if (email != null && !email.equals("Not provided")) { %>
                        <a href="mailto:<%= email %>"><%= email %></a>
                    <% } else { %>
                        <%= email %>
                    <% } %>
                </div>
            </div>
            
            <div class="info">
                <div class="label">Hobbies:</div>
                <div class="value"><%= hobbies %></div>
            </div>
            
            <div class="actions">
                <a href="index.html" class="btn">➕ Add New Profile</a>
                <a href="viewProfiles.jsp" class="btn">👥 View All Profiles</a>

                <br><br>
                <a href="debugDB.jsp" style="font-size: 12px; color: #666;">🔍 Check Database</a>
            </div>
        </div>

        <details style="margin-top: 20px; font-size: 12px; color: #666;">
            <summary>Debug Information</summary>
            <div style="background: #f8f9fa; padding: 10px; border-radius: 5px; margin-top: 5px;">
                <p>Save Status: <%= saveStatus %></p>
                <p>In Database: <%= inDatabase %></p>
                <p>Student ID: <%= studentId %></p>
                <p>Session ID: <%= session.getId() %></p>
            </div>
        </details>
    </div>
    
    <script>

        setTimeout(function() {
            var message = document.querySelector('.message');
            if (message) {
                message.style.opacity = '0';
                message.style.transition = 'opacity 1s';
                setTimeout(function() {
                    message.style.display = 'none';
                }, 1000);
            }
        }, 5000);
    </script>
</body>
</html>