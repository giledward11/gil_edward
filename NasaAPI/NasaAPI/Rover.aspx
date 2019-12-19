<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Rover.aspx.cs" Inherits="NasaAPI.Rover" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <%--<asp:FileUpload ID="fuGetImages" runat="server" on />--%>
            <input type="file" id="inpGetImage" />
            <input type="button" value="Get Nasa Images" onclick="GetImage()" />
        </div>
    <div id="divItems">
        <%--<asp:GridView ID="gvNasaImages" runat="server" AutoGenerateColumns="False"
            BorderStyle="NotSet" BorderColor="#6f91af" EmptyDataText="Empty Grid" DataKeyNames="" >
            <HeaderStyle CssClass="nobordercolumnheader" HorizontalAlign="Center"/>
            <AlternatingRowStyle CssClass="even" />
            <RowStyle CssClass="odd" />
                <Columns>                   
                    <asp:BoundField HeaderText="ID" DataField="id"/>                                             
                    <asp:BoundField HeaderText="Earth Date" DataField="earth_date" ItemStyle-HorizontalAlign="Center" DataFormatString="{0:MM/dd/yyyy}"  />                          
                </Columns>
            </asp:GridView>--%>
    </div>
        <%--<div>
            <iframe id="frmROver"></iframe>
        </div>--%>
    </form>
</body>
</html>
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript">
    //window.onload = LoadNasaImages();
    
    NSA = new Object();
    NSA.UploadControl = document.getElementById("inpGetImage");;
    var itemRow = "<table>";
    function GetImage()
    {
        //var input = document.getElementById("inpGetImage");
        var input = NSA.UploadControl;
        //alert(input);
        
        var fUpload = input.files[0];        
        //console.log(fUpload);      
        
        //return;
        if (input.files.length > 0) {

            if (fUpload) {

                //alert('ge');
                var r = new FileReader();
                r.onload = function (e) {

                    var strDate = e.target.result;
                    var arr = strDate.split('|');

                    for (var i = 0; i < arr.length; i++) {
                        //alert(arr[i]);

                        var e_date = arr[i];
                        e_date = (FormatDateForNASA(e_date));
                        if (isValidDate(e_date))
                            LoadNasaImages(e_date);
                        else {
                            alert('Invalid Date!');
                            return;
                        }
                    }
                }
                r.readAsText(fUpload);
            } else {
                alert("Unable to load the upload file");
            }
        }
        else
            alert('Please select the upload file that contains date.');


    }
    function LoadNasaImages(e_date) {
        
        //var curl = '<%=Page.ResolveUrl( "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&camera=fhaz&api_key=DEMO_KEY" )%>';
        var curl = '<%=Page.ResolveUrl("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?api_key=DEMO_KEY" )%>';
       
        //var tstval = "2015-06-03";
        
            $.ajax({
                type: "GET",
                url: curl,
                data: "&earth_date=" + e_date,
                //async:true,
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                dataType: "json",
                success: function (msg) {
                    window.localStorage.setItem("rover", JSON.stringify(msg));     //Supposed to be used inside the function DownloadImage()    
                    itemRow += "<table>";
                    $.each(msg.photos, function (index, msg) {                        
                        itemRow += "<tr><td>" + msg.id + "</td><td>" + msg.earth_date + "</td><td>" + msg.camera.full_name +
                            "</td><td><a href=" + msg.img_src + ">View</a>" +
                            //"</td><td><a href='javascript:DownloadImage(" + img.img_src + ");'>Download Image</a>" +
                            "</td><td><a href='' download=" + encodeURI(msg.img_src) + ">Download</a>" +
                            //"</td><td><a href='javascript:DownloadImage(" + msg.id + ");'>Download Image</a>" +
                            "</td> </tr>";
                    });
                    itemRow += "</table>";

                    $("#divItems").html(itemRow);                  
                },
                error: function (e) {
                    alert(e);
                    alert("Json Script Error - Getting images from NASA", 350, null, "NASA", null);
                }
            });
        
    }
    //function DownloadImage(url) {
    function DownloadImage(id) {       
        var data = JSON.parse(window.localStorage.getItem('rover'));     

        $.each(data.photos, function (index, data) {            
            if (data.id == id)
            {
                var reader = new FileReader();
                //download the image file locally                           
                
            }
            
        });
        
    }
    function isValidDate(dateString) {
        var regEx = /^\d{4}-\d{2}-\d{2}$/;
        return dateString.match(regEx) != null;
    }
    function FormatDateForNASA(date) {
        var d = new Date(date),
            month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();

        if (month.length < 2) month = '0' + month;
        if (day.length < 2) day = '0' + day;

        return [year, month, day].join('-');
    }    
    

</script>

<style type="text/css">
    #divItems table
    {
      border:1px solid gray; padding:3px;   
    }
    #divItems table td
    {
     padding:3px; border:1px solid gray; 
    }
</style>
