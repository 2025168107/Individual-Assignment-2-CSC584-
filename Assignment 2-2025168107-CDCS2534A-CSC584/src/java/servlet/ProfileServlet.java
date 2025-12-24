package servlet;

import bean.ProfileBean;
import dao.ProfileDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private ProfileDAO profileDAO;
    
    @Override
    public void init() throws ServletException {
        try {
            profileDAO = new ProfileDAO();
            System.out.println("  ProfileServlet initialized, DAO created");
        } catch (Exception e) {
            System.err.println(" Error initializing ProfileServlet: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("\n=== ProfileServlet.doPost() START ===");

        if (profileDAO == null) {
            System.out.println("⚠️  DAO is null, initializing now...");
            profileDAO = new ProfileDAO();
        }

        String name = request.getParameter("name");
        String studentId = request.getParameter("studentId");
        String program = request.getParameter("program");
        String email = request.getParameter("email");
        String hobbies = request.getParameter("hobbies");

        System.out.println("  Form Data Received:");
        System.out.println("  Student ID: " + studentId);
        System.out.println("  Name: " + name);
        System.out.println("  Email: " + email);
        System.out.println("  Program: " + program);
        System.out.println("  Hobbies: " + hobbies);

        if (studentId == null || studentId.trim().isEmpty() || 
            name == null || name.trim().isEmpty()) {
            
            System.err.println("❌ Validation failed: Student ID and Name are required");
            HttpSession session = request.getSession();
            session.setAttribute("saveStatus", "failed");
            session.setAttribute("errorMessage", "Student ID and Name are required");
            response.sendRedirect("index.html");
            return;
        }

        studentId = studentId.trim();
        name = name.trim();
        program = (program != null) ? program.trim() : "";
        email = (email != null) ? email.trim() : "";
        hobbies = (hobbies != null) ? hobbies.trim() : "";

        ProfileBean profile = new ProfileBean();
        profile.setName(name);
        profile.setStudentId(studentId);
        profile.setProgramme(program);
        profile.setEmail(email);
        profile.setHobby(hobbies);

        boolean success = false;
        String errorMessage = "";
        
        try {
            System.out.println("💾 Attempting to save to database...");
            success = profileDAO.insertProfile(profile);
            
            if (success) {
                System.out.println("✅ SUCCESS: Profile saved to database!");
            } else {
                System.err.println("❌ FAILED: insertProfile returned false");
                errorMessage = "Database insert returned false";
            }
            
        } catch (Exception e) {
            System.err.println("❌ EXCEPTION during database save:");
            e.printStackTrace();
            errorMessage = e.getMessage();
            success = false;
        }

        HttpSession session = request.getSession();
        session.setAttribute("profileName", name);
        session.setAttribute("profileStudentId", studentId);
        session.setAttribute("profileProgram", program);
        session.setAttribute("profileEmail", email);
        session.setAttribute("profileHobbies", hobbies);
        session.setAttribute("saveStatus", success ? "success" : "failed");
        
        if (!success) {
            session.setAttribute("errorMessage", 
                errorMessage.isEmpty() ? "Failed to save profile to database" : errorMessage);
        }

        System.out.println("📊 Save Status: " + (success ? "SUCCESS" : "FAILED"));
        System.out.println("=== ProfileServlet.doPost() END ===\n");

        response.sendRedirect("profile.jsp");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.html");
    }
}