package dao;

import bean.ProfileBean;
import util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ProfileDAO {
    
    // Insert profile into APP.PROFILE
    public boolean insertProfile(ProfileBean profile) {
        String sql = "INSERT INTO APP.PROFILE (student_id, name, email, programme, hobby) VALUES (?, ?, ?, ?, ?)";
        
        System.out.println("=== ProfileDAO.insertProfile() ===");
        System.out.println("Inserting into APP.PROFILE: " + profile.getStudentId() + " - " + profile.getName());
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                System.err.println("❌ FATAL: Database connection is NULL!");
                return false;
            }
            
            System.out.println("✅ Connected to student_profiles database");
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, profile.getStudentId());
            pstmt.setString(2, profile.getName());
            pstmt.setString(3, profile.getEmail());
            pstmt.setString(4, profile.getProgramme());
            pstmt.setString(5, profile.getHobby());
            
            System.out.println("Executing SQL: " + sql);
            
            int rows = pstmt.executeUpdate();
            System.out.println("✅ Insert successful! Rows affected: " + rows);
            
            return rows > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ SQL INSERT ERROR:");
            System.err.println("Message: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            
            // Check for duplicate key error (23505 in Derby)
            if (e.getSQLState() != null && e.getSQLState().equals("23505")) {
                System.err.println("⚠️  DUPLICATE ENTRY: Student ID '" + profile.getStudentId() + "' already exists in APP.PROFILE!");
            }
            
            e.printStackTrace();
            return false;
            
        } finally {
            // Close resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }
    
    // Get all profiles from APP.PROFILE
    public List<ProfileBean> getAllProfiles() {
        List<ProfileBean> list = new ArrayList<>();
        String sql = "SELECT * FROM APP.PROFILE ORDER BY id DESC";
        
        System.out.println("=== ProfileDAO.getAllProfiles() from APP.PROFILE ===");
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                System.err.println("❌ Connection is NULL!");
                return list;
            }
            
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            int count = 0;
            while (rs.next()) {
                count++;
                ProfileBean profile = new ProfileBean();
                profile.setId(rs.getInt("id"));
                profile.setStudentId(rs.getString("student_id"));
                profile.setName(rs.getString("name"));
                profile.setEmail(rs.getString("email"));
                profile.setProgramme(rs.getString("programme"));
                profile.setHobby(rs.getString("hobby"));
                list.add(profile);
            }
            
            System.out.println("✅ Retrieved " + count + " profile(s) from APP.PROFILE");
            
        } catch (SQLException e) {
            System.err.println("❌ ERROR retrieving from APP.PROFILE:");
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
        
        return list;
    }
    
    // Search profiles in APP.PROFILE
    public List<ProfileBean> searchProfiles(String keyword) {
        List<ProfileBean> list = new ArrayList<>();
        String sql = "SELECT * FROM APP.PROFILE WHERE name LIKE ? OR student_id LIKE ? ORDER BY name";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ProfileBean profile = new ProfileBean();
                profile.setId(rs.getInt("id"));
                profile.setStudentId(rs.getString("student_id"));
                profile.setName(rs.getString("name"));
                profile.setEmail(rs.getString("email"));
                profile.setProgramme(rs.getString("programme"));
                profile.setHobby(rs.getString("hobby"));
                list.add(profile);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ ERROR searching APP.PROFILE:");
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
        
        return list;
    }
    
    // Get profile count from APP.PROFILE
    public int getProfileCount() {
        String sql = "SELECT COUNT(*) as total FROM APP.PROFILE";
        int count = 0;
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            if (rs.next()) {
                count = rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.err.println("❌ ERROR counting APP.PROFILE:");
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
        
        return count;
    }
    
    // Get profile by Student ID from APP.PROFILE
    public ProfileBean getProfileByStudentId(String studentId) {
        String sql = "SELECT * FROM APP.PROFILE WHERE student_id = ?";
        ProfileBean profile = null;
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                profile = new ProfileBean();
                profile.setId(rs.getInt("id"));
                profile.setStudentId(rs.getString("student_id"));
                profile.setName(rs.getString("name"));
                profile.setEmail(rs.getString("email"));
                profile.setProgramme(rs.getString("programme"));
                profile.setHobby(rs.getString("hobby"));
            }
            
        } catch (SQLException e) {
            System.err.println("❌ ERROR getting profile from APP.PROFILE:");
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
        
        return profile;
    }
    
    // Check if student ID exists in APP.PROFILE
    public boolean studentIdExists(String studentId) {
        String sql = "SELECT COUNT(*) as count FROM APP.PROFILE WHERE student_id = ?";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ ERROR checking student ID in APP.PROFILE:");
            System.err.println("Message: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
        
        return false;
    }
}