<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RGU_Key_Management_Tool._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="pnlMainContent" runat="server">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css">
    <script src="http://code.jquery.com/jquery-1.10.2.js"></script>
    <script src="http://code.jquery.com/ui/1.11.0/jquery-ui.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $(function () {
                $('#<%=txtDateFilter.ClientID%>').datepicker({ dateFormat: 'dd/mm/yy' });
            });
        });
    </script>

    <asp:Panel runat="server" ID="pnlMaster" CssClass="master">

        <asp:Panel runat="server" ID="pnlAccessMenu" Visible="true" Style="text-align: center; margin-bottom: 4%;">
            <asp:Button runat="server" ID="btnRegister" CssClass="mainButtons" Width="42%" Text="Register" OnClick="btnRegister_Click" />
            <asp:Button runat="server" ID="btnImport" CssClass="mainButtons" Width="42%" Text="Import Data" OnClick="btnImport_Click" />
            <asp:Button runat="server" ID="btnAdmin" CssClass="mainButtons" Width="42%" Text="Administration" OnClick="btnAdmin_Click" />
        </asp:Panel>

        <asp:Panel runat="server" ID="pnlReports" CssClass="reportPanel" Visible="true">
            <asp:Button runat="server" ID="Button1" CssClass="reportButtons" Text="Report 1" />
            <asp:Button runat="server" ID="Button4" CssClass="reportButtons" Text="Report 4" />
            <asp:Button runat="server" ID="Button7" CssClass="reportButtons" Text="Report 7" />
            <br />
            <asp:Button runat="server" ID="Button2" CssClass="reportButtons" Text="Report 2" />
            <asp:Button runat="server" ID="Button5" CssClass="reportButtons" Text="Report 5" />
            <asp:Button runat="server" ID="Button8" CssClass="reportButtons" Text="Report 8" />
            <br />
            <asp:Button runat="server" ID="Button3" CssClass="reportButtons" Text="Report 3" />
            <asp:Button runat="server" ID="Button6" CssClass="reportButtons" Text="Report 6" />
            <asp:Button runat="server" ID="Button9" CssClass="reportButtons" Text="Report 9" />
        </asp:Panel>

        <asp:Panel runat="server" ID="pnlFilters" CssClass="sidePanel" Visible="true">
            <asp:TextBox runat="server" ID="txtKeyFilter" PlaceHolder="Enter your key id" CssClass="mainFilters" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter your key identificator'" />
            <br />
            <asp:TextBox runat="server" ID="txtRoomFilter" PlaceHolder="Enter room number" CssClass="mainFilters" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter room number'" />
            <br />
            <asp:TextBox runat="server" ID="txtUserFilter" PlaceHolder="Enter user rented to" CssClass="mainFilters" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter user rented to'" />
            <br />
            <asp:TextBox runat="server" ID="txtDateFilter" PlaceHolder="Enter rented from date" CssClass="mainFilters" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter rented from date'" />
            <asp:Button runat="server" ID="btnApplyFilter" CssClass="applyFilter" Text="Apply entered filters" Style="padding: 10px;" />
        </asp:Panel>

        <asp:Panel runat="server" ID="pnlRegister" Style="text-align: center;" Visible="true">
            <asp:GridView runat="server" ID="gvKeys" CssClass="mydatagrid" HeaderStyle-CssClass="header" RowStyle-CssClass="rows"
                ShowHeaderWhenEmpty="true" AutoGenerateColumns="false" AllowSorting="true" Width="100%">
                <Columns>
                    <asp:BoundField HeaderText="Key Id" DataField="keyId" />
                    <asp:BoundField HeaderText="Key Description" DataField="keyDesc" />
                    <asp:BoundField HeaderText="Renter's Full Name" DataField="rentName" />
                    <asp:BoundField HeaderText="From Date" DataField="rentFrom" />
                    <asp:BoundField HeaderText="Return Date" DataField="rentTo" />
                    <asp:BoundField HeaderText="Days rented" DataField="rentCount" />
                </Columns>
            </asp:GridView>
        </asp:Panel>

        <asp:Panel runat="server" ID="pnlImport" Visible="false">
            <center>
                <asp:Label runat="server" ID="lblFileUpload" CssClass="Headers" Style="font-size: 20px; margin-bottom: 10px;">Please use this feature to load excel file with keys into the system</asp:Label>
                <asp:Table runat="server" style="border: 0;">
                    <asp:TableRow>
                        <asp:TableCell>
                            <asp:FileUpload runat="server" ID="fUpExcel"/>
                        </asp:TableCell>
                        <asp:TableCell>
                            <asp:Button runat="server" ID="btnUpload" CssClass="mainButtons" OnClick="btnUpload_Click" style="padding: 10px;" Text="Upload the file" />
                        </asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
            </center>
        </asp:Panel>

        <center>
        <asp:Panel runat="server" ID="pnlAdmin" Visible="false" Width="50%">
            <asp:GridView runat="server" ID="gvUsers" CssClass="mydatagrid" HeaderStyle-CssClass="header" RowStyle-CssClass="rows"
                ShowHeaderWhenEmpty="true" AutoGenerateColumns="false" AllowSorting="true">
                <Columns>
                    <asp:BoundField HeaderText="LoginID" DataField="userId" />
                    <asp:BoundField HeaderText="Full Name" DataField="userName" />
                </Columns>
            </asp:GridView>
        </asp:Panel>
        </center>
    </asp:Panel>
</asp:Content>