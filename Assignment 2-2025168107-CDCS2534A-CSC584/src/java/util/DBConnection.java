package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnection {
    
    private static final String URL = "jdbc:derby://localhost:1527/student_profiles;create=true";
    private static final String USER = "app";
    private static final String PASS = "app";
    
    static {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            System.out.println("✅ JavaDB Driver Loaded");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ JavaDB Driver not found!");
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("✅ Database Connected: student_profiles");
            
            return conn;
            
        } catch (SQLException e) {
            System.err.println("❌ Connection FAILED: " + e.getMessage());
            
            if (e.getMessage().contains("Database") && e.getMessage().contains("not found")) {
                System.err.println("\n⚠️  Database 'student_profiles' doesn't exist!");
                System.err.println("Create in NetBeans:");
                System.err.println("1. Services → Databases → JavaDB");
                System.err.println("2. Right-click → Create Database...");
                System.err.println("3. Name: student_profiles, User: app, Password: app");
            }
            
            e.printStackTrace();
            return null;
        }
    }

    public static void main(String[] args) {
        System.out.println("=== TESTING DATABASE CONNECTION ===");
        
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("✅ Connection successful!");
                
                Statement stmt = conn.createStatement();

                try {
                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM APP.PROFILE");
                    System.out.println("✅ PROFILE table exists");
                    rs.close();
                } catch (SQLException e) {
                    System.out.println("ℹ️  PROFILE table not found");
                }
                
                stmt.close();
                
            } else {
                System.err.println("❌ Connection returned null");
            }
        } catch (Exception e) {
            System.err.println("❌ Test failed: " + e.getMessage());
        }
    }
}