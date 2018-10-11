using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;


namespace RGU_Key_Management_Tool
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("keyId");
            dt.Columns.Add("keyDesc");
            dt.Columns.Add("rentName");
            dt.Columns.Add("rentFrom");
            dt.Columns.Add("rentTo");
            dt.Columns.Add("rentCount");

            var dr = dt.NewRow();
            dr["keyId"] = "1";
            dr["keyDesc"] = "N5330";
            dr["rentName"] = "James Parker";
            dr["rentfrom"] = "10/10/2018";
            dr["rentTo"] = "20/10/2018";
            dr["rentCount"] = "10";

            DataTable dt2 = new DataTable();
            dt2.Columns.Add("userId");
            dt2.Columns.Add("userName");

            var dr2 = dt2.NewRow();
            dr2["userId"] = "1403780";
            dr2["userName"] = "James Parker";

            dt.Rows.Add(dr);
            dt2.Rows.Add(dr2);

            gvKeys.DataSource = dt;
            gvKeys.DataBind();

            gvUsers.DataSource = dt2;
            gvUsers.DataBind();
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            pnlRegister.Visible = true;
            pnlFilters.Visible = true;
            pnlReports.Visible = true;
            pnlImport.Visible = false;
            pnlAdmin.Visible = false;

        }

        protected void btnImport_Click(object sender, EventArgs e)
        {
            pnlRegister.Visible = false;
            pnlFilters.Visible = false;
            pnlReports.Visible = false;
            pnlImport.Visible = true;
            pnlAdmin.Visible = false;

        }

        protected void btnAdmin_Click(object sender, EventArgs e)
        {
            pnlRegister.Visible = false;
            pnlFilters.Visible = false;
            pnlImport.Visible = false;
            pnlReports.Visible = false;
            pnlAdmin.Visible = true;
        }

        protected void btnLoad_Click(object sender, EventArgs e)
        {
            pnlRegister.Visible = true;
            pnlFilters.Visible = true;
            pnlFilters.Visible = true;
            pnlImport.Visible = false;
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            pnlRegister.Visible = true;
            pnlFilters.Visible = true;
            pnlFilters.Visible = true;
            pnlImport.Visible = false;
        }
    }
}