package bean;

import java.io.Serializable;

public class ProfileBean implements Serializable {
    private int id;
    private String studentId;
    private String name;
    private String email;
    private String programme;
    private String hobby;

    public ProfileBean() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getProgramme() { return programme; }
    public void setProgramme(String programme) { this.programme = programme; }
    
    public String getHobby() { return hobby; }
    public void setHobby(String hobby) { this.hobby = hobby; }
    
    @Override
    public String toString() {
        return "ProfileBean [id=" + id + ", studentId=" + studentId + ", name=" + name + 
               ", email=" + email + ", programme=" + programme + ", hobby=" + hobby + "]";
    }
}