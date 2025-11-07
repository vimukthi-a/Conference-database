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

public class DeletePaper extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JTextField V1;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					DeletePaper frame = new DeletePaper();
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
	public DeletePaper() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 500);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		JLabel lblNewLabel = new JLabel("Delete Paper");
		lblNewLabel.setFont(new Font("Tahoma", Font.BOLD, 15));
		lblNewLabel.setBounds(26, 25, 146, 24);
		contentPane.add(lblNewLabel);
		
		JLabel lblNewLabel_1 = new JLabel("Enter ID of paper you want to delete");
		lblNewLabel_1.setFont(new Font("Tahoma", Font.BOLD, 14));
		lblNewLabel_1.setBounds(26, 104, 284, 24);
		contentPane.add(lblNewLabel_1);
		
		V1 = new JTextField();
		V1.setFont(new Font("Tahoma", Font.PLAIN, 14));
		V1.setBounds(26, 161, 114, 30);
		contentPane.add(V1);
		V1.setColumns(10);
		
		JButton btnNewButton = new JButton("Delete");
		btnNewButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				
				try {
					Utility util = new Utility();
					
					util.conn.setAutoCommit(false);
					
				    String authorsInfo = "DELETE FROM PaperAuthors WHERE Paper_ID = ?";
				    util.pstmt = util.conn.prepareStatement(authorsInfo);
				    util.pstmt.setInt(1, Integer.parseInt(V1.getText()));
				    util.pstmt.executeUpdate();

				    // Then delete from Paper
				    String paperInfo = "DELETE FROM Paper WHERE paperID = ?";
				    util.pstmt = util.conn.prepareStatement(paperInfo);
				    util.pstmt.setInt(1, Integer.parseInt(V1.getText()));
				    util.pstmt.executeUpdate();
				    
				    // Finally delete from ContactAuthor
				    String contactAuth = "DELETE FROM ContactAuthor WHERE paperID = ?";
				    util.pstmt = util.conn.prepareStatement(contactAuth);
				    util.pstmt.setInt(1, Integer.parseInt(V1.getText()));
				    util.pstmt.executeUpdate();
					
					int x = JOptionPane.showConfirmDialog(null, "Do you wish to Delete?","Press Yes or No",JOptionPane.YES_NO_OPTION);


					if (x == JOptionPane.YES_OPTION) {
						util.conn.commit();
						JOptionPane.showMessageDialog(null, "Record deleted successfully!");
					}
					else {
						util.conn.rollback();
					}
					
					
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
		});
		btnNewButton.setFont(new Font("Tahoma", Font.BOLD, 14));
		btnNewButton.setBounds(187, 167, 85, 21);
		contentPane.add(btnNewButton);
		
		JButton btnHome = new JButton("Home");
		btnHome.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				setVisible(false);
				AuthorPage.main(null);
			}
		});
		btnHome.setFont(new Font("Tahoma", Font.BOLD, 14));
		btnHome.setBounds(26, 244, 85, 21);
		contentPane.add(btnHome);
		
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
		btnExit.setBounds(187, 246, 85, 21);
		contentPane.add(btnExit);
	}

}
