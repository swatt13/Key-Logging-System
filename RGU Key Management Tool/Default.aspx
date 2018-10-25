<%@ Page Title="RGU Key Manager" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RGU_Key_Management_Tool._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="pnlMainContent" runat="server">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.11.0/themes/smoothness/jquery-ui.css">
    <script src="http://code.jquery.com/jquery-1.10.2.js"></script>
    <script src="http://code.jquery.com/ui/1.11.0/jquery-ui.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $(function () {
                $('#<%=txtDateFilter.ClientID%>').datepicker({ dateFormat: 'dd/mm/yy' });
                $('#<%=txtFrom.ClientID%>').datepicker({ dateFormat: 'dd/mm/yy' });
                $('#<%=txtTo.ClientID%>').datepicker({ dateFormat: 'dd/mm/yy' });
            });
        });
    </script>

    <asp:Panel runat="server" ID="pnlError" CssClass="master" Style="text-align: center;" Visible="false">
        <asp:Label runat="server" ID="lblError" Text="No Access" Style="color: red; font-size: 28px" />
        <br />
        <asp:Label runat="server" ID="lblAdmin" Text="" Style="color: red; font-size: 24px" />
    </asp:Panel>

    <asp:Panel runat="server" ID="pnlMaster" CssClass="master">

        <asp:Panel runat="server" ID="pnlAccessMenu" Visible="true" Style="text-align: center; margin-bottom: 4%;">
            <asp:Button runat="server" ID="btnRegister" CssClass="mainButtons" Width="42%" Text="Register" OnClick="BtnRegister_Click" />
            <asp:Button runat="server" ID="btnImport" CssClass="mainButtons" Width="42%" Text="Import Data" OnClick="BtnImport_Click" />
            <asp:Button runat="server" ID="btnAdmin" CssClass="mainButtons" Width="42%" Text="Administration" OnClick="BtnAdmin_Click" />
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
            <asp:TextBox runat="server" autocomplete="off" ID="txtKeyFilter" PlaceHolder="Enter your key identificator" CssClass="mainFilters" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter your key identificator'" />
            <br />
            <asp:TextBox runat="server" autocomplete="off" ID="txtRoomFilter" PlaceHolder="Enter key location" CssClass="mainFilters" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter key location'" />
            <br />
            <asp:TextBox runat="server" autocomplete="off" ID="txtUserFilter" PlaceHolder="Enter user rented to" CssClass="mainFilters" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter user rented to'" />
            <asp:Button runat="server" ID="btnResetFilter" CssClass="applyFilter" Text="Reset entered filters" Style="padding: 10px;" OnClick="BtnResetFilter_Click1" />
            <br />
            <asp:TextBox runat="server" autocomplete="off" ID="txtDateFilter" PlaceHolder="Enter rented from date" CssClass="mainFilters" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter rented from date'" />
            <asp:Button runat="server" ID="btnApplyFilter" CssClass="applyFilter" Text="Apply entered filters" Style="padding: 10px;" OnClick="BtnApplyFilter_Click1" />
        </asp:Panel>

        <asp:Panel runat="server" ID="pnlRegister" Style="text-align: center;" Visible="true">

            <asp:TextBox runat="server" autocomplete="off" ID="txtKeyId" PlaceHolder="Physical ID" CssClass="mainFilters" style="width: 10em;" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Key Id'" />
            <asp:TextBox runat="server" autocomplete="off" ID="txtKeyDesc" PlaceHolder="Key Description" CssClass="mainFilters" style="width: 10em;" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Key Desc'" />
            <asp:TextBox runat="server" autocomplete="off" ID="txtKeyLoc" PlaceHolder="Key Location" CssClass="mainFilters" style="width: 10em;" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Key Loc'" />
            <asp:TextBox runat="server" autocomplete="off" ID="txtRenter" PlaceHolder="Renter Name" CssClass="mainFilters" style="width: 10em;" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Renter Name'" />
            <asp:TextBox runat="server" autocomplete="off" ID="txtFrom" PlaceHolder="From Date" CssClass="mainFilters" style="width: 10em;" onfocus="this.placeholder = ''" onblur="this.placeholder = 'From Date'" />
            <asp:TextBox runat="server" autocomplete="off" ID="txtTo" PlaceHolder="To Date" CssClass="mainFilters" style="width: 10em;" onfocus="this.placeholder = ''" onblur="this.placeholder = 'To Date'" />
            <asp:Button runat="server" ID="btnAddRental" CssClass="applyFilter" Text="Submit" Style="padding: 10px;" Width="10%" OnClick="BtnAddRental_Click" />

            <br />
            <asp:Label runat="server" ID="lblAddError" Style="color: red; font-size: 18px; margin-bottom: 20px;" Text="Please make sure all the fields are filled in before submitting." Visible="false" />
            <br />

            <asp:GridView runat="server" ID="gvKeys" CssClass="mydatagrid" HeaderStyle-CssClass="header" RowStyle-CssClass="rows"
                ShowHeaderWhenEmpty="true" AutoGenerateColumns="false" AllowSorting="true" Width="100%">
                <Columns>
                    <asp:BoundField HeaderText="Key Id" DataField="KeyId" />
                    <asp:BoundField HeaderText="Key Description" DataField="KeyDesc" />
                    <asp:BoundField HeaderText="Key Location" DataField="KeyLoc" />
                    <asp:BoundField HeaderText="Renter's Full Name" DataField="CurrentRenter" />
                    <asp:BoundField HeaderText="From Date" DataField="RentFrom" />
                    <asp:BoundField HeaderText="Return Date" DataField="RentTo" />
                    <asp:BoundField HeaderText="Days rented" DataField="rentalTime" />
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
                            <asp:Button runat="server" ID="btnUpload" CssClass="mainButtons" OnClick="BtnUpload_Click" style="padding: 10px;" Text="Upload the file" />
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
                    <asp:BoundField HeaderText="Access Level" DataField="accessLevel" />
                </Columns>
            </asp:GridView>
        </asp:Panel>
        </center>

    </asp:Panel>

    <asp:Panel runat="server" ID="pnlFooter" Visible="true" CssClass="master" Style="text-align: center; margin-top: 50px;">
        <asp:HyperLink ID="lnkAdmin" runat="server" NavigateUrl="mailto:1403780@rgu.ac.uk?subject=Access" Text="Contact for access" Style="margin-right: 20px; font-size: 18px; color: #89867e"></asp:HyperLink>
        <asp:HyperLink ID="lnkBug" runat="server" NavigateUrl="mailto:1403780@rgu.ac.uk?subject=Bug" Text="Report Bugs" Style="margin-right: 20px; margin-top: 20px; font-size: 18px; color: #89867e"></asp:HyperLink>
    </asp:Panel>
</asp:Content>
