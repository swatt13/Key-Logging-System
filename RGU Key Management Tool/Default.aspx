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
            <asp:Button runat="server" ID="btnReport1" CssClass="reportButtons" Text="List completed rentals" OnClick="BtnReport1_Click" />
            <br />
            <asp:Button runat="server" ID="btnReport2" CssClass="reportButtons" Text="List over 14 days rentals" OnClick="BtnReport2_Click" />
            <br />
            <asp:Button runat="server" ID="btnReport3" CssClass="reportButtons" Text="List over 31 days rentals" OnClick="BtnReport3_Click" />
        </asp:Panel>

        <asp:Panel runat="server" ID="pnlFilters" CssClass="sidePanel" Visible="true">
            <asp:TextBox runat="server" autocomplete="off" ID="txtKeyFilter" PlaceHolder="Enter the identificator" CssClass="mainFilters" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter the identificator'" />
            <br />
            <asp:TextBox runat="server" autocomplete="off" ID="txtRoomFilter" PlaceHolder="Enter the location" CssClass="mainFilters" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter the location'" />
            <br />
            <asp:TextBox runat="server" autocomplete="off" ID="txtUserFilter" PlaceHolder="Enter user rented to" CssClass="mainFilters" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter user rented to'" />
            <asp:Button runat="server" ID="btnResetFilter" CssClass="applyFilter" Text="Reset entered filters" Style="padding: 10px;" OnClick="BtnResetFilter_Click1" />
            <br />
            <asp:TextBox runat="server" autocomplete="off" ID="txtDateFilter" PlaceHolder="Enter rented from date" CssClass="mainFilters" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter rented from date'" />
            <asp:Button runat="server" ID="btnApplyFilter" CssClass="applyFilter" Text="Apply entered filters" Style="padding: 10px;" OnClick="BtnApplyFilter_Click1" />
        </asp:Panel>

        <asp:Panel runat="server" ID="pnlRegister" Style="text-align: center;" Visible="true">

            <asp:TextBox runat="server" autocomplete="off" ID="txtRentalId" CssClass="mainFilters"  Visible="false" />
            <asp:TextBox runat="server" autocomplete="off" ID="txtKeyId" PlaceHolder="Physical ID" CssClass="mainFilters" Style="width: 10em;" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Physical ID'" />
            <asp:TextBox runat="server" autocomplete="off" ID="txtKeyDesc" PlaceHolder="Description" CssClass="mainFilters" Style="width: 10em;" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Description'" />
            <asp:TextBox runat="server" autocomplete="off" ID="txtKeyLoc" PlaceHolder="Location" CssClass="mainFilters" Style="width: 10em;" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Location'" />
            <asp:TextBox runat="server" autocomplete="off" ID="txtRenter" PlaceHolder="Renter Name" CssClass="mainFilters" Style="width: 10em;" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Renter Name'" />
            <asp:TextBox runat="server" autocomplete="off" ID="txtFrom" PlaceHolder="From Date" CssClass="mainFilters" Style="width: 10em;" onfocus="this.placeholder = ''" onblur="this.placeholder = 'From Date'" />
            <asp:TextBox runat="server" autocomplete="off" ID="txtTo" Visible="false" PlaceHolder="To Date" CssClass="mainFilters" Style="width: 10em;" onfocus="this.placeholder = ''" onblur="this.placeholder = 'To Date'" />
            <asp:Button runat="server" ID="btnAddRental" CssClass="applyFilter" Text="Submit" Style="padding: 10px;" Width="10%" OnClick="BtnAddRental_Click" />

            <br />
            <asp:Label runat="server" ID="lblAddError" Style="color: red; font-size: 18px; margin-bottom: 20px;" Text="Please make sure all the fields are filled in before submitting." Visible="false" />
            <br />

            <asp:GridView runat="server" ID="gvKeys" CssClass="mydatagrid" HeaderStyle-CssClass="header" RowStyle-CssClass="rows"
                ShowHeaderWhenEmpty="true" AutoGenerateColumns="false" AllowSorting="true" Width="100%" OnRowDataBound="gvKeys_RowDataBound" OnRowCommand="gvKeys_RowCommand">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnEdit" CssClass="mainButtons" Width="80%" style="padding:5px; margin:5px;" runat="server" CommandName="EditRecord" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="Edit" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="UniqueId" DataField="RentalId" />
                    <asp:BoundField HeaderText="PhysicalId" DataField="KeyId" />
                    <asp:BoundField HeaderText="Description" DataField="KeyDesc" />
                    <asp:BoundField HeaderText="Location" DataField="KeyLoc" />
                    <asp:BoundField HeaderText="Renter's Full Name" DataField="CurrentRenter" />
                    <asp:BoundField HeaderText="From Date" DataField="RentFrom" />
                    <asp:BoundField HeaderText="Return Date" DataField="RentTo" />
                    <asp:BoundField HeaderText="Days rented" DataField="rentalTime" />
                </Columns>
            </asp:GridView>
        </asp:Panel>

        <center>
        <asp:Panel runat="server" ID="pnlImport" Visible="false">
            <asp:Label runat="server" ID="lblFileUpload" CssClass="Headers" Style="font-size: 20px; margin-bottom: 10px;">Please use this feature to load excel file with keys into the system</asp:Label>
            <asp:Table runat="server" Style="border: 0;">
                <asp:TableRow>
                    <asp:TableCell>
                        <asp:FileUpload runat="server" ID="fUpExcel" />
                    </asp:TableCell>
                    <asp:TableCell>
                        <asp:Button runat="server" ID="btnUpload" CssClass="mainButtons" OnClick="BtnUpload_Click" Style="padding: 10px;" Text="Upload the file" />
                    </asp:TableCell>
                </asp:TableRow>
            </asp:Table>
        </asp:Panel>

        <asp:Panel runat="server" ID="pnlAdmin" Visible="false">
            <asp:GridView runat="server" ID="gvUsers" CssClass="mydatagrid" HeaderStyle-CssClass="header" RowStyle-CssClass="rows"
                ShowHeaderWhenEmpty="true" AutoGenerateColumns="false" AllowSorting="true" Width="50%">
                <Columns>
                    <asp:BoundField HeaderText="LoginID" DataField="RguId" />
                    <asp:BoundField HeaderText="Full Name" DataField="FullName" />
                    <asp:BoundField HeaderText="Access Level" DataField="AccessLevel" />
                </Columns>
            </asp:GridView>

            <br />

            <asp:TextBox runat="server" autocomplete="off" ID="txtRguId" PlaceHolder="RGU Login Id" CssClass="mainFilters" Style="width: 10em;" onfocus="this.placeholder = ''" onblur="this.placeholder = 'RGU Login ID'" />
            <asp:TextBox runat="server" autocomplete="off" ID="txtFullName" PlaceHolder="Full Name" CssClass="mainFilters" Style="width: 10em;" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Full Name'" />
            <asp:DropDownList runat="server" ID="ddlAccess" CssClass="mainFilters" Style="width: 10em;">
                <asp:ListItem Text="Read" Value="1"></asp:ListItem>
                <asp:ListItem Text="Read/Write" Value="2"></asp:ListItem>
                <asp:ListItem Text="Administrator" Value="3"></asp:ListItem>
            </asp:DropDownList>
            <asp:Button runat="server" ID="btnAddUser" CssClass="applyFilter" Text="Submit" Style="padding: 10px;" Width="10%" OnClick="BtnAddUser_Click" />
        </asp:Panel>
        </center>

    </asp:Panel>

    <asp:Panel runat="server" ID="pnlFooter" Visible="true" CssClass="master" Style="text-align: center; margin-top: 50px;">
        <asp:HyperLink ID="lnkAdmin" runat="server" NavigateUrl="mailto:1403780@rgu.ac.uk?subject=Access" Text="Contact for access" Style="margin-right: 20px; font-size: 18px; color: #89867e"></asp:HyperLink>
        <asp:HyperLink ID="lnkBug" runat="server" NavigateUrl="mailto:1403780@rgu.ac.uk?subject=Bug" Text="Report Bugs" Style="margin-right: 20px; margin-top: 20px; font-size: 18px; color: #89867e"></asp:HyperLink>
    </asp:Panel>
</asp:Content>