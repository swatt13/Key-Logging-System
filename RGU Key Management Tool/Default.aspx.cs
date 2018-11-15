using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Drawing;

namespace RGU_Key_Management_Tool
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // If filters are applied, don't load the data
            if (!Page.IsPostBack)
            {
                LoadData();
            }

            // Code for security lockdown, currently only restricted for my rgu login and personal login (can be easily changed to lookup administrators)
            //if (!Page.User.Identity.Name.Contains("1403780") && !Page.User.Identity.Name.Contains("irm") && !Page.User.Identity.Name.Contains("zayy"))
            //{
            //    pnlError.Visible = true;
            //    pnlMaster.Visible = false;
            //    lblError.Text = Page.User.Identity.Name + " is not permitted to use this application.";
            //    lblAdmin.Text = "Please contact the administrator using links at the bottom of the page, if you require access.";
            //}
        }

        // Loading the data for both the main grid and user grid, can be seperated into 2 different methods to not load the second grid unnecessarly
        protected void LoadData()
        {
            DataTable dtRentals = new DataTable();
            DataTable dtUsers = new DataTable();

            string query = "SELECT * FROM vwKeys WHERE RentTo IS NULL ORDER BY rentalTime DESC";
            string query2 = "SELECT * FROM vwUsers";

            SqlConnection conn = new SqlConnection(ConfigurationManager.AppSettings["conString"].ToString());

            SqlCommand cmd = new SqlCommand(query, conn);
            SqlCommand cmd2 = new SqlCommand(query2, conn);
            conn.Open();

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(dtRentals);
            da.Dispose();

            SqlDataAdapter da2 = new SqlDataAdapter(cmd2);
            da2.Fill(dtUsers);
            conn.Close();
            da2.Dispose();

            gvKeys.DataSource = dtRentals;
            gvKeys.DataBind();

            gvUsers.DataSource = dtUsers;
            gvUsers.DataBind();
        }

        // Buttons (Normally I would use object loading/saving but since the application is not complicated at all I just appended queries)
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

            if (query.Contains("WHERE"))
            {
                query = query + " AND RentTo IS NULL ORDER BY rentalTime DESC";
            } else
            {
                query = query + " WHERE RentTo IS NULL ORDER BY rentalTime DESC";
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
            string query = "SELECT * FROM vwKeys WHERE RentTo IS NULL ORDER BY rentalTime DESC ";

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

        // Adding and Editing Keys/Rentals
        protected void BtnAddRental_Click(object sender, EventArgs e)
        {
            if (btnAddRental.Text == "Submit")
            {
                if (!(String.IsNullOrEmpty(txtKeyId.Text) || 
                    String.IsNullOrEmpty(txtKeyDesc.Text) || 
                    String.IsNullOrEmpty(txtRenter.Text) || 
                    String.IsNullOrEmpty(txtKeyLoc.Text) || 
                    String.IsNullOrEmpty(txtFrom.Text)))
                {
                    DataTable dtRentals = new DataTable();
                    string query = "INSERT INTO Rentals (KeyId, KeyDesc, CurrentRenter, KeyLoc, RentFrom, RentTo) VALUES('" + txtKeyId.Text + "', '" + txtKeyDesc.Text + "', '" + txtRenter.Text + "', '" + txtKeyLoc.Text + "', CONVERT(datetime, '" + txtFrom.Text + "', 103), NULL);";

                    SqlConnection conn = new SqlConnection(ConfigurationManager.AppSettings["conString"].ToString());
                    SqlCommand cmd = new SqlCommand(query, conn);
                    conn.Open();

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dtRentals);
                    conn.Close();
                    da.Dispose();

                    gvKeys.DataSource = dtRentals;
                    gvKeys.DataBind();

                    clearAdd();

                    LoadData();
                    lblAddError.Visible = false;
                } else
                {
                    lblAddError.Visible = true;
                }
            }
            else if (btnAddRental.Text == "Update")
            {
                if (!(String.IsNullOrEmpty(txtKeyId.Text) ||
                    String.IsNullOrEmpty(txtKeyDesc.Text) ||
                    String.IsNullOrEmpty(txtRenter.Text) ||
                    String.IsNullOrEmpty(txtKeyLoc.Text) ||
                    String.IsNullOrEmpty(txtFrom.Text)))
                {
                    DataTable dtRentals = new DataTable();
                    string query = "UPDATE Rentals SET KeyId = '" + txtKeyId.Text + "', " +
                                    "KeyDesc = '" + txtKeyDesc.Text + "', " +
                                    "currentRenter = '" + txtRenter.Text + "', " +
                                    "KeyLoc = '" + txtKeyLoc.Text + "', " +
                                    "RentFrom = CONVERT(datetime, '" + txtFrom.Text + "', 103)";
                                    
                    // if the to date is empty, ignore it, else add it to the query
                    if (!String.IsNullOrEmpty(txtTo.Text)){
                        query = query + ", RentTo = CONVERT(datetime, '" + txtTo.Text + "', 103) WHERE RentalId = " + txtRentalId.Text;
                    } else
                    {
                        query = query + " WHERE RentalId = " + txtRentalId.Text;
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

                    clearAdd();
                    btnAddRental.Text = "Submit";

                    LoadData();
                    txtTo.Visible = false;
                } else
                {
                    lblAddError.Visible = true;
                }
            }
        }

        // Adding users in administration tab
        protected void BtnAddUser_Click(object sender, EventArgs e)
        {
            {
                DataTable dtUsers = new DataTable();
                string query = "INSERT INTO Users (RguId, FullName, AccessLevel) VALUES('" + txtRguId.Text + "', '" + txtFullName.Text + "', '" + ddlAccess.SelectedValue + "');";

                SqlConnection conn = new SqlConnection(ConfigurationManager.AppSettings["conString"].ToString());
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dtUsers);
                conn.Close();
                da.Dispose();

                gvUsers.DataSource = dtUsers;
                gvUsers.DataBind();

                txtRguId.Text = String.Empty;
                txtFullName.Text = String.Empty;
                ddlAccess.SelectedIndex = 0;

                LoadData();
            }
        }

        // Reports
        protected void BtnReport1_Click(object sender, EventArgs e)
        {
            DataTable dtRentals = new DataTable();

            string query = "SELECT * FROM vwKeys WHERE RentTo IS NOT NULL ORDER BY rentalTime DESC";

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

        protected void BtnReport2_Click(object sender, EventArgs e)
        {
            DataTable dtRentals = new DataTable();

            string query = "SELECT * FROM vwKeys WHERE rentalTime > 14 AND RentTo IS NULL ORDER BY rentalTime DESC";

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

        protected void BtnReport3_Click(object sender, EventArgs e)
        {
            DataTable dtRentals = new DataTable();

            string query = "SELECT * FROM vwKeys WHERE rentalTime > 31 AND RentTo IS NULL ORDER BY rentalTime DESC";

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

        // Changing grid colours
        protected void gvKeys_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (Int32.Parse(e.Row.Cells[8].Text) > 31 && e.Row.Cells[7].Text == "&nbsp;")
                {
                    e.Row.BackColor = Color.Firebrick;
                }
                else if (Int32.Parse(e.Row.Cells[8].Text) > 21 && e.Row.Cells[7].Text == "&nbsp;")
                {
                    e.Row.BackColor = Color.SandyBrown;
                }
                else if (Int32.Parse(e.Row.Cells[8].Text) > 14 && e.Row.Cells[7].Text == "&nbsp;")
                {
                    e.Row.BackColor = Color.PaleGoldenrod;
                }
            }
        }

        // Prepping field for an edit
        protected void gvKeys_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRecord")
            {
                txtTo.Visible = true;

                int id = Convert.ToInt32(e.CommandArgument);

                foreach (TableCell c in gvKeys.Rows[id].Cells)
                {
                    if (c.Text == "&nbsp;")
                    {
                        c.Text = "";
                    }
                }

                txtRentalId.Text = gvKeys.Rows[id].Cells[1].Text;
                txtKeyId.Text = gvKeys.Rows[id].Cells[2].Text;
                txtKeyDesc.Text = gvKeys.Rows[id].Cells[3].Text;
                txtKeyLoc.Text = gvKeys.Rows[id].Cells[4].Text;
                txtRenter.Text = gvKeys.Rows[id].Cells[5].Text;
                txtFrom.Text = gvKeys.Rows[id].Cells[6].Text;
                txtTo.Text = gvKeys.Rows[id].Cells[7].Text;

                btnAddRental.Text = "Update";
            }
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteRecord")
            {
                int id = Convert.ToInt32(e.CommandArgument);

                DataTable dtUsers = new DataTable();
                string query = "DELETE FROM Users WHERE Id = " + gvUsers.Rows[id].Cells[1].Text;

                SqlConnection conn = new SqlConnection(ConfigurationManager.AppSettings["conString"].ToString());
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dtUsers);
                conn.Close();
                da.Dispose();

                gvUsers.DataSource = dtUsers;
                gvUsers.DataBind();
            }
        }

        // clearing all the rental fields
        protected void clearAdd()
        {
            txtKeyId.Text = String.Empty;
            txtKeyDesc.Text = String.Empty;
            txtKeyLoc.Text = String.Empty;
            txtRenter.Text = String.Empty;
            txtFrom.Text = String.Empty;
            txtTo.Text = String.Empty;
        }

        // Visiblity settings
        protected void BtnRegister_Click(object sender, EventArgs e)
        {
            pnlRegister.Visible = true;
            pnlFilters.Visible = true;
            pnlReports.Visible = true;
            pnlImport.Visible = false;
            pnlAdmin.Visible = false;

            clearAdd();
            LoadData();
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
    }
}