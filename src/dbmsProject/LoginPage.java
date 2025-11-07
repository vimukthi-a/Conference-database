package dbmsProject;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import javax.swing.JLabel;
import javax.swing.JOptionPane;

import java.awt.Font;
import javax.swing.JTextField;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.sql.SQLException;
import java.awt.event.ActionEvent;

public class LoginPage extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JTextField user;
	private JTextField pass;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					LoginPage frame = new LoginPage();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public LoginPage() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		JLabel lblNewLabel = new JLabel("Enter required details");
		lblNewLabel.setFont(new Font("Tahoma", Font.BOLD, 15));
		lblNewLabel.setBounds(123, 10, 180, 19);
		contentPane.add(lblNewLabel);
		
		JLabel lblNewLabel_1 = new JLabel("Username:");
		lblNewLabel_1.setFont(new Font("Tahoma", Font.PLAIN, 14));
		lblNewLabel_1.setBounds(42, 86, 121, 13);
		contentPane.add(lblNewLabel_1);
		
		JLabel lblNewLabel_2 = new JLabel("Password:");
		lblNewLabel_2.setFont(new Font("Tahoma", Font.PLAIN, 14));
		lblNewLabel_2.setBounds(42, 135, 121, 13);
		contentPane.add(lblNewLabel_2);
		
		user = new JTextField();
		user.setBounds(207, 80, 150, 29);
		contentPane.add(user);
		user.setColumns(10);
		
		pass = new JTextField();
		pass.setBounds(207, 124, 150, 29);
		contentPane.add(pass);
		pass.setColumns(10);
		
		JButton btnNewButton = new JButton("Login");
		btnNewButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				
				try {
					Utility util = new Utility();
					String sql = "select username,password from login where username =? and password =?";
					
					util.pstmt = util.conn.prepareStatement(sql);
					util.pstmt.setString(1, user.getText());
					util.pstmt.setString(2, pass.getText());
					util.rs = util.pstmt.executeQuery();
					
					if(util.rs.next()) {
						JOptionPane.showMessageDialog(null, "Login Successful");
						setVisible(false);
//						MainSub.main(null);
						//OPEN PAGE IF AUTHOR OR REVIEWER
						
						String userType = "select username from authorlogin where username=?"; //USED TO CHECK FOR AUTHOR 
						
						util.pstmt = util.conn.prepareStatement(userType);
						util.pstmt.setString(1, user.getText());
						util.rs = util.pstmt.executeQuery();
						
						if(util.rs.next()) {
							setVisible(false);
							AuthorPage.main(null);
						}
						else {
							ReviewerPage.main(null);
						}
						
					}
					else {
						JOptionPane.showMessageDialog(null, "Incorrect Login details. Please try again");
					}
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				
			}
		});
		btnNewButton.setFont(new Font("Tahoma", Font.BOLD, 14));
		btnNewButton.setBounds(229, 177, 114, 21);
		contentPane.add(btnNewButton);
		
		JButton btnExit = new JButton("Exit");
		btnExit.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					Utility util = new Utility();
					
					util.terminate();
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				
				
			}
		});
		btnExit.setFont(new Font("Tahoma", Font.BOLD, 14));
		btnExit.setBounds(229, 216, 114, 21);
		contentPane.add(btnExit);
	}
}
