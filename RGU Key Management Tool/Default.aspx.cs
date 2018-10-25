using System;
using System.Web.UI;
using System.Data;
using System.IO;
using System.Data.SqlClient;
using System.Configuration;

namespace RGU_Key_Management_Tool
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                LoadData();
            }
            
            // Security lockdown, currently only restricted for my rgu login and personal login (can be easily changed to lookup administrators when user table is implemented)
            if (!Page.User.Identity.Name.Contains("1403780") && !Page.User.Identity.Name.Contains("irm") && !Page.User.Identity.Name.Contains("zayy"))
            {
                pnlError.Visible = true;
                pnlMaster.Visible = false;
                lblError.Text = Page.User.Identity.Name + " is not permitted to use this application.";
                lblAdmin.Text = "Please contact the administrator using links at the bottom of the page, if you require access.";
            }

            // Sample data for admin table
            DataTable dt2 = new DataTable();
            dt2.Columns.Add("userId");
            dt2.Columns.Add("userName");
            dt2.Columns.Add("accessLevel");

            var dr1 = dt2.NewRow();
            dr1["userId"] = "1403780";
            dr1["userName"] = "James Parker";
            dr1["accessLevel"] = "Administrator";

            var dr2 = dt2.NewRow();
            dr2["userId"] = "0000000";
            dr2["userName"] = "Shona Lilly";
            dr2["accessLevel"] = "Read-Only";

            dt2.Rows.Add(dr1);
            dt2.Rows.Add(dr2);

            gvUsers.DataSource = dt2;
            gvUsers.DataBind();
        }

        // Visibility thingies
        protected void BtnRegister_Click(object sender, EventArgs e)
        {
            pnlRegister.Visible = true;
            pnlFilters.Visible = true;
            pnlReports.Visible = true;
            pnlImport.Visible = false;
            pnlAdmin.Visible = false;

        }

        protected void BtnImport_Click(object sender, EventArgs e)
        {
            pnlRegister.Visible = false;
            pnlFilters.Visible = false;
            pnlReports.Visible = false;
            pnlImport.Visible = true;
            pnlAdmin.Visible = false;

        }

        protected void BtnAdmin_Click(object sender, EventArgs e)
        {
            pnlRegister.Visible = false;
            pnlFilters.Visible = false;
            pnlImport.Visible = false;
            pnlReports.Visible = false;
            pnlAdmin.Visible = true;
        }

        protected void BtnLoad_Click(object sender, EventArgs e)
        {
            pnlRegister.Visible = true;
            pnlFilters.Visible = true;
            pnlFilters.Visible = true;
            pnlImport.Visible = false;
        }

        protected void BtnUpload_Click(object sender, EventArgs e)
        {
            pnlRegister.Visible = true;
            pnlFilters.Visible = true;
            pnlFilters.Visible = true;
            pnlImport.Visible = false;
        }

        protected void LoadData()
        {
            DataTable dtRentals = new DataTable();

            string query = "SELECT * FROM vwKeys";

            SqlConnection conn = new SqlConnection(ConfigurationManager.AppSettings["conString"].ToString());
            SqlCommand cmd = new SqlCommand(query, conn);
            conn.Open();

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dtRentals);
            conn.Close();
            da.Dispose();

            gvKeys.DataSource = dtRentals;
            gvKeys.DataBind();
        }

        protected void BtnApplyFilter_Click1(object sender, EventArgs e)
        {
            DataTable dtRentals = new DataTable();

            string query = "SELECT * FROM vwKeys ";

            if (!String.IsNullOrEmpty(txtKeyFilter.Text))
            {
                query = query + "WHERE KeyId = '" + txtKeyFilter.Text + "' ";
            }

            if (!String.IsNullOrEmpty(txtRoomFilter.Text))
            {
                if (query.Contains("WHERE"))
                {
                    query = query + " AND KeyLoc LIKE '%" + txtRoomFilter.Text + "%' ";
                }
                else
                {
                    query = query + "WHERE KeyLoc LIKE '%" + txtRoomFilter.Text + "%' ";
                }
            }

            if (!String.IsNullOrEmpty(txtUserFilter.Text))
            {
                if (query.Contains("WHERE"))
                {
                    query = query + " AND CurrentRenter LIKE %' " + txtUserFilter.Text + "'% ";
                }
                else
                {
                    query = query + "WHERE CurrentRenter LIKE '%" + txtUserFilter.Text + "%' ";
                }
            }

            if (!String.IsNullOrEmpty(txtDateFilter.Text))
            {
                if (query.Contains("WHERE"))
                {
                    query = query + " AND RentFrom > CONVERT(datetime, '" + txtDateFilter.Text + "', 103)";
                }
                else
                {
                    query = query + "WHERE RentFrom > CONVERT(datetime, '" + txtDateFilter.Text + "', 103)";
                }
            }

            SqlConnection conn = new SqlConnection(ConfigurationManager.AppSettings["conString"].ToString());
            SqlCommand cmd = new SqlCommand(query, conn);
            conn.Open();

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dtRentals);
            conn.Close();
            da.Dispose();

            gvKeys.DataSource = dtRentals;
            gvKeys.DataBind();
        }

        protected void BtnResetFilter_Click1(object sender, EventArgs e)
        {
            DataTable dtRentals = new DataTable();
            string query = "SELECT * FROM vwKeys ";

            SqlConnection conn = new SqlConnection(ConfigurationManager.AppSettings["conString"].ToString());
            SqlCommand cmd = new SqlCommand(query, conn);
            conn.Open();

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dtRentals);
            conn.Close();
            da.Dispose();

            gvKeys.DataSource = dtRentals;
            gvKeys.DataBind();

            txtKeyFilter.Text = String.Empty;
            txtRoomFilter.Text = String.Empty;
            txtUserFilter.Text = String.Empty;
            txtDateFilter.Text = String.Empty;
        }

        protected void BtnAddRental_Click(object sender, EventArgs e)
        {
            if (!(String.IsNullOrEmpty(txtKeyId.Text) &&
                String.IsNullOrEmpty(txtKeyDesc.Text) &&
                String.IsNullOrEmpty(txtKeyLoc.Text) &&
                String.IsNullOrEmpty(txtRenter.Text) &&
                String.IsNullOrEmpty(txtFrom.Text) &&
                String.IsNullOrEmpty(txtTo.Text)))
            {
                DataTable dtRentals = new DataTable();
                string query = "INSERT INTO Rentals (KeyId, KeyDesc, CurrentRenter, KeyLoc, RentFrom, RentTo) VALUES('" + txtKeyId.Text + "', '" + txtKeyDesc.Text + "', '" + txtRenter.Text + "', '" + txtKeyLoc.Text + "', CONVERT(datetime, '" + txtFrom.Text + "', 103), CONVERT(datetime, '" + txtTo.Text + "', 103));";

                SqlConnection conn = new SqlConnection(ConfigurationManager.AppSettings["conString"].ToString());
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dtRentals);
                conn.Close();
                da.Dispose();

                gvKeys.DataSource = dtRentals;
                gvKeys.DataBind();

                txtKeyId.Text = String.Empty;
                txtKeyDesc.Text = String.Empty;
                txtKeyLoc.Text = String.Empty;
                txtRenter.Text = String.Empty;
                txtFrom.Text = String.Empty;
                txtTo.Text = String.Empty;

                LoadData();
            }
            else
            {
                lblAddError.Visible = true;
            }
        }
    }
}