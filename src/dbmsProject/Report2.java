package dbmsProject;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import net.proteanit.sql.DbUtils;

import javax.swing.JButton;
import java.awt.Font;
import javax.swing.JLabel;
import javax.swing.JScrollPane;
import java.awt.event.ActionListener;
import java.sql.SQLException;
import java.awt.event.ActionEvent;
import javax.swing.JTable;

public class Report2 extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JTable table;

	/**
	 * Create the frame.
	 */
	public Report2() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 500);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		JButton btnResults = new JButton("Results");
		btnResults.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					Utility util = new Utility();
					
					String sql = "SELECT * FROM Conference_summary_report";
					util.pstmt = util.conn.prepareStatement(sql);
					util.rs = util.pstmt.executeQuery();
					table.setModel(DbUtils.resultSetToTableModel(util.rs));
				} catch (SQLException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
		});
		btnResults.setFont(new Font("Tahoma", Font.BOLD, 15));
		btnResults.setBounds(206, 10, 103, 21);
		contentPane.add(btnResults);
		
		JLabel lblNewLabel = new JLabel("Conference Summary ");
		lblNewLabel.setFont(new Font("Tahoma", Font.BOLD, 15));
		lblNewLabel.setBounds(1, 11, 196, 21);
		contentPane.add(lblNewLabel);
		
		JLabel lblReport = new JLabel("Report");
		lblReport.setFont(new Font("Tahoma", Font.BOLD, 15));
		lblReport.setBounds(1, 32, 196, 21);
		contentPane.add(lblReport);
		
		JScrollPane scrollPane = new JScrollPane();
		scrollPane.setBounds(11, 63, 415, 390);
		contentPane.add(scrollPane);
		
		table = new JTable();
		scrollPane.setViewportView(table);
		
		JButton btnHome = new JButton("Home");
		btnHome.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				setVisible(false);
				AuthorPage.main(null);
			}
		});
		btnHome.setFont(new Font("Tahoma", Font.BOLD, 15));
		btnHome.setBounds(323, 12, 103, 21);
		contentPane.add(btnHome);
		
	}
}
