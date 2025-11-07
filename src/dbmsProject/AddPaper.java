package dbmsProject;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import javax.swing.JButton;
import java.awt.Font;
import javax.swing.JComboBox;
import javax.swing.DefaultComboBoxModel;
import java.awt.event.ActionListener;
import java.sql.SQLException;
import java.awt.event.ActionEvent;

public class AddPaper extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JTextField title;
	private JTextField name;
	private JTextField abstractfield;
	private JTextField tracks;
	private JTextField theDate;
	private JTextField mail;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					AddPaper frame = new AddPaper();
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
	public AddPaper() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 500);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);

		JLabel lblNewLabel = new JLabel("Add Paper");
		lblNewLabel.setFont(new Font("Tahoma", Font.BOLD, 15));
		lblNewLabel.setBounds(41, 31, 93, 30);
		contentPane.add(lblNewLabel);

		JLabel lblNewLabel_1 = new JLabel("Title");
		lblNewLabel_1.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblNewLabel_1.setBounds(41, 152, 99, 13);
		contentPane.add(lblNewLabel_1);

		JLabel lblNewLabel_2 = new JLabel("File Name");
		lblNewLabel_2.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblNewLabel_2.setBounds(41, 192, 99, 13);
		contentPane.add(lblNewLabel_2);

		JLabel lblNewLabel_3 = new JLabel("Abstract");
		lblNewLabel_3.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblNewLabel_3.setBounds(41, 232, 99, 13);
		contentPane.add(lblNewLabel_3);

		JLabel lblNewLabel_5 = new JLabel("Tracks");
		lblNewLabel_5.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblNewLabel_5.setBounds(41, 275, 99, 13);
		contentPane.add(lblNewLabel_5);

		JLabel lblNewLabel_6 = new JLabel("Status field");
		lblNewLabel_6.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblNewLabel_6.setBounds(41, 316, 99, 13);
		contentPane.add(lblNewLabel_6);

		title = new JTextField();
		title.setFont(new Font("Tahoma", Font.PLAIN, 12));
		title.setColumns(10);
		title.setBounds(154, 144, 189, 30);
		contentPane.add(title);

		name = new JTextField();
		name.setFont(new Font("Tahoma", Font.PLAIN, 12));
		name.setColumns(10);
		name.setBounds(154, 184, 189, 30);
		contentPane.add(name);

		abstractfield = new JTextField();
		abstractfield.setFont(new Font("Tahoma", Font.PLAIN, 12));
		abstractfield.setColumns(10);
		abstractfield.setBounds(154, 224, 189, 30);
		contentPane.add(abstractfield);

		tracks = new JTextField();
		tracks.setFont(new Font("Tahoma", Font.PLAIN, 12));
		tracks.setColumns(10);
		tracks.setBounds(154, 267, 189, 30);
		contentPane.add(tracks);

		JComboBox status = new JComboBox();
		status.setFont(new Font("Tahoma", Font.PLAIN, 12));
		status.setModel(new DefaultComboBoxModel(new String[] {"Submitted", "Under Review", "Accepted", "Rejected", "Published"}));
		status.setBounds(154, 307, 189, 30);
		contentPane.add(status);

		JButton btnNewButton = new JButton("Add");
		btnNewButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				try {
					Utility util = new Utility();
					
					util.conn.setAutoCommit(false);

					String SeqID = "SELECT PAPER_ID_INCR.NEXTVAL FROM dual";
					util.pstmt = util.conn.prepareStatement(SeqID);
					util.rs = util.pstmt.executeQuery();
					int paperId = util.rs.next() ? util.rs.getInt(1) : -1;

					String contactAuth = "INSERT INTO ContactAuthor (paperID, Email) VALUES (?, ?)";
					util.pstmt = util.conn.prepareStatement(contactAuth);
					util.pstmt.setInt(1, paperId);
					util.pstmt.setString(2, mail.getText());
					util.pstmt.executeUpdate();

					String paperInfo = "INSERT INTO Paper (paperID, Title, FileName, PaperDesc, " +
							"Submission_Date, Tracks, Status_Field) " +
							"VALUES (?, ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?)";
					util.pstmt = util.conn.prepareStatement(paperInfo);
					util.pstmt.setInt(1, paperId);
					util.pstmt.setString(2, title.getText());
					util.pstmt.setString(3, name.getText());
					util.pstmt.setString(4, abstractfield.getText());
					util.pstmt.setString(5, theDate.getText());
					util.pstmt.setString(6, tracks.getText());
					util.pstmt.setString(7, status.getSelectedItem().toString());
					util.pstmt.executeUpdate();


					String authorsInfo = "INSERT INTO PaperAuthors (Author_Email, Paper_ID, AuthorOrder) " +
							"VALUES (?, ?, 1)";
					util.pstmt = util.conn.prepareStatement(authorsInfo);
					util.pstmt.setString(1, mail.getText());
					util.pstmt.setInt(2, paperId); 
					util.pstmt.executeUpdate();

					int x = JOptionPane.showConfirmDialog(null, "Do you wish to Save?","Press Yes or No",JOptionPane.YES_NO_OPTION);


					if (x == JOptionPane.YES_OPTION) {
						util.conn.commit();
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
		btnNewButton.setFont(new Font("Tahoma", Font.BOLD, 12));
		btnNewButton.setBounds(154, 405, 85, 21);
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
		btnExit.setFont(new Font("Tahoma", Font.BOLD, 12));
		btnExit.setBounds(258, 405, 85, 21);
		contentPane.add(btnExit);

		theDate = new JTextField();
		theDate.setFont(new Font("Tahoma", Font.PLAIN, 12));
		theDate.setColumns(10);
		theDate.setBounds(154, 347, 189, 30);
		contentPane.add(theDate);

		JLabel lblNewLabel_4 = new JLabel("Submission Date");
		lblNewLabel_4.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblNewLabel_4.setBounds(41, 356, 106, 13);
		contentPane.add(lblNewLabel_4);

		JButton btnNewButton_1 = new JButton("Home");
		btnNewButton_1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				setVisible(false);
				AuthorPage.main(null);
			}
		});
		btnNewButton_1.setFont(new Font("Tahoma", Font.BOLD, 12));
		btnNewButton_1.setBounds(41, 406, 85, 21);
		contentPane.add(btnNewButton_1);

		mail = new JTextField();
		mail.setFont(new Font("Tahoma", Font.PLAIN, 12));
		mail.setColumns(10);
		mail.setBounds(154, 104, 189, 30);
		contentPane.add(mail);

		JLabel lblNewLabel_1_1 = new JLabel("Author Email");
		lblNewLabel_1_1.setFont(new Font("Tahoma", Font.BOLD, 12));
		lblNewLabel_1_1.setBounds(41, 112, 99, 13);
		contentPane.add(lblNewLabel_1_1);
	}
}
