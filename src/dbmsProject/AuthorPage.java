package dbmsProject;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import net.proteanit.sql.DbUtils;

import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.JTable;
import javax.swing.JScrollPane;
import javax.swing.JButton;
import java.awt.Font;
import java.awt.event.ActionListener;
import java.sql.SQLException;
import java.awt.event.ActionEvent;

public class AuthorPage extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JTable table;
	private JScrollPane scrollPane;
	private JButton btnUpdatePaper;
	private JButton btnNewButton_2;
	private JButton btnNewButton_3;
	private JButton btnAddpaper;
	private JButton btnAllPapers;
	private JTextField V1;
	private JButton btnUpdatePaper_1;
	private JScrollPane scrollPane_1;
	private JButton btnUpdatePaper_2;

	/**
	 * Create the frame.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					AuthorPage frame = new AuthorPage();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}
	public AuthorPage() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 500);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);

		JLabel lblNewLabel = new JLabel("Welcome");
		lblNewLabel.setFont(new Font("Tahoma", Font.BOLD, 15));
		lblNewLabel.setBounds(154, 10, 101, 18);
		contentPane.add(lblNewLabel);
		
		scrollPane_1 = new JScrollPane();
		scrollPane_1.setBounds(10, 173, 416, 280);
		contentPane.add(scrollPane_1);

		scrollPane = new JScrollPane();
		scrollPane_1.setViewportView(scrollPane);

		table = new JTable();
		scrollPane.setViewportView(table);

		btnUpdatePaper = new JButton("Update Paper");
		btnUpdatePaper.setFont(new Font("Tahoma", Font.BOLD, 12));
		btnUpdatePaper.setBounds(294, 53, 132, 21);
		contentPane.add(btnUpdatePaper);

		btnNewButton_2 = new JButton("Delete Paper");
		btnNewButton_2.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				setVisible(false);
				DeletePaper.main(null);
			}
		});
		btnNewButton_2.setFont(new Font("Tahoma", Font.BOLD, 12));
		btnNewButton_2.setBounds(142, 53, 134, 21);
		contentPane.add(btnNewButton_2);

		btnNewButton_3 = new JButton("Exit");
		btnNewButton_3.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				Utility util;
				try {
					util = new Utility();
					util.terminate();
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}

			}
		});
		btnNewButton_3.setFont(new Font("Tahoma", Font.BOLD, 12));
		btnNewButton_3.setBounds(341, 10, 85, 21);
		contentPane.add(btnNewButton_3);

		btnAddpaper = new JButton("AddPaper");
		btnAddpaper.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				setVisible(false);
				AddPaper.main(null);
			}
		});
		btnAddpaper.setFont(new Font("Tahoma", Font.BOLD, 12));
		btnAddpaper.setBounds(10, 53, 115, 21);
		contentPane.add(btnAddpaper);
		
		btnAllPapers = new JButton("Search Author");
		btnAllPapers.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				
				//SEARCH FOR AUTHOR
				
				Utility util;
				try {
					util = new Utility();
					
					String sql = "SELECT a.First_Name, a.Last_Name, p.paperID, p.Title, p.Status_Field, " +
				             "TO_CHAR(p.Submission_Date, 'YYYY-MM-DD') AS Submission_Date, p.Tracks " +
				             "FROM Author a, PaperAuthors pa, Paper p " +  
				             "WHERE a.Email = pa.Author_Email " +           
				             "AND pa.Paper_ID = p.paperID " +              
				             "AND a.First_Name = ? " +                     
				             "ORDER BY p.Title";
					util.pstmt = util.conn.prepareStatement(sql);
					util.pstmt.setString(1, V1.getText());
					
					util.rs = util.pstmt.executeQuery();

					table.setModel(DbUtils.resultSetToTableModel(util.rs));
					
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
		});
		btnAllPapers.setFont(new Font("Tahoma", Font.BOLD, 12));
		btnAllPapers.setBounds(10, 133, 134, 21);
		contentPane.add(btnAllPapers);
		
		V1 = new JTextField();
		V1.setBounds(154, 135, 201, 19);
		contentPane.add(V1);
		V1.setColumns(10);
		
		btnUpdatePaper_1 = new JButton("Report 1");
		btnUpdatePaper_1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
			}
		});
		btnUpdatePaper_1.setFont(new Font("Tahoma", Font.BOLD, 12));
		btnUpdatePaper_1.setBounds(47, 96, 132, 21);
		contentPane.add(btnUpdatePaper_1);
		
		btnUpdatePaper_2 = new JButton("Report 2");
		btnUpdatePaper_2.setFont(new Font("Tahoma", Font.BOLD, 12));
		btnUpdatePaper_2.setBounds(265, 96, 132, 21);
		contentPane.add(btnUpdatePaper_2);
	}


}
