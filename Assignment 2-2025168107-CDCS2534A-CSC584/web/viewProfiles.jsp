<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.ProfileDAO, bean.ProfileBean, java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>All Student Profiles</title>
    <style>
        body { background: #f0f2f5; padding: 20px; font-family: Arial; }
        .container { max-width: 1400px; margin: auto; }
        .header { text-align: center; margin: 20px 0; }
        .header h1 { color: #1a73e8; margin-bottom: 10px; }
        .header p { color: #666; }
        .message { 
            padding: 15px; 
            border-radius: 8px; 
            margin: 20px auto; 
            max-width: 800px; 
            text-align: center;
            font-weight: bold;
            animation: fadeIn 0.5s;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .success { 
            background: #d4edda; 
            color: #155724; 
            border: 1px solid #c3e6cb;
            box-shadow: 0 0 10px rgba(40, 167, 69, 0.2);
        }
        .error { 
            background: #f8d7da; 
            color: #721c24; 
            border: 1px solid #f5c6cb;
            box-shadow: 0 0 10px rgba(220, 53, 69, 0.2);
        }
        
        .search-box { text-align: center; margin: 20px 0; }
        .search-input { padding: 12px; width: 300px; border: 2px solid #ddd; border-radius: 8px; font-size: 16px; }
        .search-btn { padding: 12px 25px; background: #1a73e8; color: white; border: none; border-radius: 8px; font-size: 16px; cursor: pointer; }
        .search-btn:hover { background: #0d62d9; }
        .actions { text-align: center; margin: 25px 0; }
        .btn { background: #1a73e8; color: white; padding: 12px 25px; text-decoration: none; border-radius: 8px; margin: 0 10px; font-size: 16px; display: inline-block; }
        .btn:hover { background: #0d62d9; }
        .stats { text-align: center; margin: 20px 0; padding: 15px; background: white; border-radius: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .profiles-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 25px; margin-top: 30px; }
        .profile-card { background: white; border-radius: 15px; padding: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); transition: transform 0.3s; }
        .profile-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.15); }
        .card-header { border-bottom: 2px solid #f0f2f5; padding-bottom: 20px; margin-bottom: 20px; }
        .student-id { background: #1a73e8; color: white; padding: 6px 15px; border-radius: 20px; font-size: 14px; font-weight: bold; display: inline-block; margin-bottom: 10px; }
        .profile-name { font-size: 24px; color: #333; margin-bottom: 5px; }
        .profile-program { color: #666; font-size: 16px; }
        .card-body { margin-top: 15px; }
        .info-row { display: flex; margin-bottom: 15px; }
        .info-label { font-weight: bold; color: #555; width: 100px; }
        .info-value { color: #333; flex: 1; }
        .hobby-tags { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 5px; }
        .hobby-tag { background: #e6fffa; color: #234e52; padding: 5px 12px; border-radius: 15px; font-size: 14px; }
        .empty-state { text-align: center; padding: 60px 20px; background: white; border-radius: 15px; }
        .empty-icon { font-size: 60px; color: #cbd5e0; margin-bottom: 20px; }
        .search-results { background: #e6fffa; padding: 15px; border-radius: 10px; margin-bottom: 25px; text-align: center; }

        .new-profile {
            animation: pulse 2s infinite;
            border: 2px solid #28a745;
        }
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(40, 167, 69, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(40, 167, 69, 0); }
            100% { box-shadow: 0 0 0 0 rgba(40, 167, 69, 0); }
        }
    </style>
    <script>
        setTimeout(function() {
            var messages = document.querySelectorAll('.message');
            messages.forEach(function(msg) {
                msg.style.opacity = '0';
                msg.style.transition = 'opacity 1s';
                setTimeout(function() {
                    msg.style.display = 'none';
                }, 1000);
            });
        }, 5000);
    </script>
</head>
<body>
    <div class="container">
        <%
            String saveStatus = (String) session.getAttribute("saveStatus");
            String newStudentId = (String) session.getAttribute("profileStudentId");
            String newName = (String) session.getAttribute("profileName");
            
            if ("success".equals(saveStatus)) {
                session.removeAttribute("saveStatus");
                session.removeAttribute("profileStudentId");
                session.removeAttribute("profileName");
        %>
            <div class="message success">
                ✅ Profile "<%= newName %>" (ID: <%= newStudentId %>) saved successfully!
            </div>
        <%
            } else if ("failed".equals(saveStatus)) {
                String error = (String) session.getAttribute("errorMessage");
                session.removeAttribute("saveStatus");
                session.removeAttribute("errorMessage");
        %>
            <div class="message error">
                ❌ Failed to save profile. 
                <% if (error != null && error.contains("duplicate")) { %>
                    Student ID "<%= newStudentId %>" already exists!
                <% } else if (error != null) { %>
                    <%= error %>
                <% } else { %>
                    Unknown error occurred.
                <% } %>
            </div>
        <%
            }
        %>
        
        <div class="header">
            <h1>👥 Student Profiles Directory</h1>
            <p>View and manage all student profiles in the system</p>
        </div>

        <div class="search-box">
            <form method="get">
                <%
                    String searchKeyword = request.getParameter("search");
                    if (searchKeyword == null) searchKeyword = "";
                %>
                <input type="text" name="search" class="search-input" placeholder="🔍 Search by name or student ID..." value="<%= searchKeyword %>">
                <button type="submit" class="search-btn">Search</button>
            </form>
        </div>
        <div class="actions">
            <a href="index.html" class="btn">➕ Add New Profile</a>
            <a href="viewProfiles.jsp" class="btn">🔄 Refresh View</a>
        </div>
        
        <%
            ProfileDAO profileDAO = new ProfileDAO();
            List<ProfileBean> profiles;
            boolean isSearch = false;
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                profiles = profileDAO.searchProfiles(searchKeyword.trim());
                isSearch = true;
            } else {
                profiles = profileDAO.getAllProfiles();
            }
            
            int totalProfiles = profileDAO.getProfileCount();
        %>

        <% if (isSearch && !searchKeyword.isEmpty()) { %>
            <div class="search-results">
                <strong>Search Results for: "<%= searchKeyword %>"</strong> | 
                Found: <%= profiles.size() %> profile(s)
            </div>
        <% } %>

        <div class="stats">
            <strong>Total Profiles:</strong> <%= totalProfiles %> | 
            <strong>Showing:</strong> <%= profiles.size() %> profile(s) |
            <strong>Last Updated:</strong> <%= new java.util.Date() %>
        </div>
s
        <%
            if (profiles == null || profiles.isEmpty()) {
        %>
            <div class="empty-state">
                <div class="empty-icon">👤</div>
                <h3>No Profiles Found</h3>
                <p><% if (isSearch) { %>
                    No profiles match your search criteria.
                <% } else { %>
                    No student profiles in the database yet.
                <% } %></p>
                <a href="index.html" class="btn" style="margin-top: 20px;">➕ Add First Profile</a>
            </div>
        <%
            } else {
        %>
            <div class="profiles-grid">
                <% 
                    for (ProfileBean profile : profiles) { 
                        String hobbies = profile.getHobby();
                        String[] hobbyArray = (hobbies != null && !hobbies.isEmpty()) ? hobbies.split(",") : new String[0];
                       
                        boolean isNew = (newStudentId != null && newStudentId.equals(profile.getStudentId()));
                %>
                <div class="profile-card <%= isNew ? "new-profile" : "" %>">
                    <div class="card-header">
                        <div class="student-id">ID: <%= profile.getStudentId() %></div>
                        <h3 class="profile-name"><%= profile.getName() %></h3>
                        <div class="profile-program">
                            <% if (profile.getProgramme() != null && !profile.getProgramme().isEmpty()) { %>
                                🎓 <%= profile.getProgramme() %>
                            <% } else { %>
                                🎓 Not specified
                            <% } %>
                        </div>
                    </div>
                    
                    <!-- Card Body -->
                    <div class="card-body">
                        <div class="info-row">
                            <div class="info-label">DB ID #:</div>
                            <div class="info-value">#<%= profile.getId() %></div>
                        </div>
                        
                        <div class="info-row">
                            <div class="info-label">Email:</div>
                            <div class="info-value">
                                <% if (profile.getEmail() != null && !profile.getEmail().isEmpty()) { %>
                                    📧 <a href="mailto:<%= profile.getEmail() %>"><%= profile.getEmail() %></a>
                                <% } else { %>
                                    📧 Not provided
                                <% } %>
                            </div>
                        </div>
                        
                        <div class="info-row">
                            <div class="info-label">Hobbies:</div>
                            <div class="info-value">
                                <div class="hobby-tags">
                                    <% if (hobbyArray.length > 0) { 
                                        for (String hobby : hobbyArray) {
                                            if (!hobby.trim().isEmpty()) { %>
                                                <span class="hobby-tag"><%= hobby.trim() %></span>
                                            <% }
                                        }
                                    } else { %>
                                        <span class="hobby-tag">No hobbies listed</span>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        <%
            }
        %>
    </div>
    
    <script>
        setTimeout(function() {
            window.location.reload();
        }, 30000);
    </script>
</body>
</html>