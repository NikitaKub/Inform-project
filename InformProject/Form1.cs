using Microsoft.Data.SqlClient;
using System;
using System.Data;
using System.Data.SqlClient;

namespace InformProject
{
    public partial class Form1 : Form
    {
        private string connectString = "Data Source=DESKTOP-KC6S2TH; Initial Catalog=Machinery; User ID=sa; Password=312; TrustServerCertificate=True";
        private SqlConnection conn;

        public Form1()
        {
            InitializeComponent();
            sqlConnect();
            comboBox1_Fill();
        }

        private void sqlConnect()
        {
            try
            {
                conn = new SqlConnection(connectString);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
                throw;
            }
        }

        private void comboBox1_Fill()
        {
            try
            {
                conn.Open();
                
                string query = "select name from sys.tables;";
                SqlCommand cmd = new SqlCommand(query, conn);

                comboBox1.Items.Clear();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    comboBox1.Items.Add(reader.GetString(0));
                }

                conn.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                conn.Open();

                string query = "select * from " + comboBox1.SelectedItem;
                SqlDataAdapter da = new SqlDataAdapter(query, conn);

                DataTable dt = new DataTable();
                da.Fill(dt);
                dataGridView1.DataSource = dt;

                conn.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message.ToString());
            }
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            
        }
    }
}
