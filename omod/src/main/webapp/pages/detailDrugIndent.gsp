<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Detailed Drug Indent"])
    ui.includeCss("billingui", "jquery.dataTables.min.css")
    ui.includeCss("registration", "onepcssgrid.css")

    ui.includeJavascript("billingui", "moment.js")
    ui.includeJavascript("billingui", "jquery.dataTables.min.js")
    ui.includeJavascript("laboratoryapp", "jq.browser.select.js")
    ui.includeJavascript("billingui", "jquery.PrintArea.js")
%>
<script>
    INDENT = {

        detailDrugIndent: function (indentId) {
            if (SESSION.checkSession()) {
                url = "detailDrugIndent.form?indentId=" + indentId + "&keepThis=false&TB_iframe=true&height=500&width=1000";
                tb_show("Detail Indent Drug....", url, false);
            }
        }
    }
</script>

<script>

    jQuery(document).ready(function () {
        function print() {
            var printDiv = jQuery("#print").html();
            var printWindow = window.open('', '', 'height=400,width=800');
            printWindow.document.write('<html><head><title>Information</title>');
            printWindow.document.write(printDiv);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }

        jQuery("#printButton").on("click", function (e) {
            print().show();
        });
    });
</script>

<style>
body {
    margin-top: 20px;
}

#modal-overlay {
    background: #000 none repeat scroll 0 0;
    opacity: 0.3 !important;
}

.col1, .col2, .col3, .col4, .col5, .col6, .col7, .col8, .col9, .col10, .col11, .col12 {
    color: #555;
    text-align: left;
}

form input,
form select {
    margin: 0px;
    display: inline-block;
    min-width: 50px;
    padding: 2px 10px;
    height: 32px !important;
}

.info-header span {
    cursor: pointer;
    display: inline-block;
    float: right;
    margin-top: -2px;
    padding-right: 5px;
}

.dashboard .info-section {
    margin: 2px 5px 5px;
}

.toast-item {
    background-color: #222;
}

@media all and (max-width: 768px) {
    .onerow {
        margin: 0 0 100px;
    }
}

form .advanced {
    background: #363463 none repeat scroll 0 0;
    border-color: #dddddd;
    border-style: solid;
    border-width: 1px;
    color: #fff;
    cursor: pointer;
    float: right;
    padding: 6px 0;
    text-align: center;
    width: 27%;
}

form .advanced i {
    font-size: 22px;
}

.col4 label {
    width: 110px;
    display: inline-block;
}

.col4 input[type=text] {
    display: inline-block;
    padding: 4px 10px;
}

.col4 select {
    padding: 4px 10px;
}

form select {
    min-width: 50px;
    display: inline-block;
}

.identifiers span {
    border-radius: 50px;
    color: white;
    display: inline;
    font-size: 0.8em;
    letter-spacing: 1px;
    margin: 5px;
}

table.dataTable thead th, table.dataTable thead td {
    padding: 5px 10px;
}

input[type="text"], select {
    border: 1px solid #aaa;
    border-radius: 2px !important;
    box-shadow: none !important;
    box-sizing: border-box !important;
    height: 32px;
    width: 250px;
    padding: 5px 0 5px 10px;
}

.newdtp {
    width: 166px;
}

#lastDayOfVisit label,
#referred-date label {
    display: none;
}

#lastDayOfVisit input {
    width: 160px;
}

.add-on {
    color: #f26522;
    float: right;
    left: auto;
    margin-left: -29px;
    margin-top: 2px;
    position: absolute;
    right: 25px;
}

.chrome .add-on {
    margin-left: -31px;
    margin-top: -27px !important;
    position: relative !important;
}

#lastDayOfVisit-wrapper .add-on {
    margin-top: 5px;
}

.ui-widget-content a {
    color: #007fff;
}

#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
    text-decoration: none;
}

.new-patient-header .identifiers {
    margin-top: 5px;
}

.name {
    color: #f26522;
}

#inline-tabs {
    background: #f9f9f9 none repeat scroll 0 0;
}

.formfactor {
    background: #f3f3f3 none repeat scroll 0 0;
    border: 1px solid #ddd;
    margin-bottom: 5px;
    padding: 5px 10px;
    text-align: left;
    width: auto;
}

.formfactor .lone-col {
    display: inline-block;
    margin-top: 5px;
    overflow: hidden;
    width: 100%;
}

.formfactor .first-col {
    display: inline-block;
    margin-top: 5px;
    overflow: hidden;
    width: 300px;
}

.formfactor .second-col {
    display: inline-block;
    float: right;
    margin-top: 5px;
    overflow: hidden;
    width: 600px;
}

.formfactor .lone-col input,
.formfactor .first-col input,
.formfactor .second-col input {
    margin-top: 5px;
    padding: 5px 15px;
    width: 100%;
}

.formfactor .lone-col label,
.formfactor .first-col label,
.formfactor .second-col label {
    padding-left: 5px;
    color: #363463;
    cursor: pointer;
}

.ui-tabs-panel h2 {
    display: inline-block;
}

#drugIndentList {
    font-size: 12px;
    margin-top: 5px;
}

.dialog li label span {
    color: #f00;
    float: right;
    margin-right: 10px;
}

.dialog label {
    display: inline-block;
    width: 180px;
}

.dialog select {
    display: inline-block;
    margin: 0;
    padding: 2px 0 2px 5px;
    width: 250px;
}

.dialog .dialog-content li {
    margin-bottom: 2px;
}

.dialog .dialog-content {
    padding: 5px 20px 0;
}

.dialog select option {
    font-size: 1.0em;
}

td a,
td a:hover {
    text-decoration: none;
}

.red {
    border: 1px solid #f00 !important;
}

#dateOfExpiry label,
#receiptDate label,
#dateOfManufacture label {
    display: none;
}

table th, table td {
    padding: 5px;
}

th:nth-child(4),
th:nth-child(5) {
    width: 65px;
}

th:nth-child(6) {
    width: 75px;
}

th:nth-child(7) {
    min-width: 30px;
}

th:nth-child(8),
th:last-child {
    width: 35px;
}

form input:focus, form select:focus, form textarea:focus, form ul.select:focus, .form input:focus, .form select:focus, .form textarea:focus, .form ul.select:focus {
    outline: 2px none #007fff;
    box-shadow: 0 0 2px 0 #888 !important;
}

#footer {
    height: 50px;
    margin-top: 5px;
}

#footer img {
    float: left;
    height: 20px;
    margin-right: 5px;
    margin-top: 6px;
}

#footer span {
    color: #777;
    float: left;
    font-size: 12px;
    margin-top: 8px;
}

#footer button {
    float: right;
}
.hide{
	display: none;
}
</style>

<div class="clear"></div>

<div class="container">
    <div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="${ui.pageLink('referenceapplication', 'home')}">
                    <i class="icon-home small"></i></a>
            </li>

            <li>
                <a href="${ui.pageLink('inventoryapp', 'main')}">
                    <i class="icon-chevron-right link"></i>Inventory
                </a>
            </li>

            <li>
                <i class="icon-chevron-right link"></i>
                Manage Indents
            </li>
        </ul>
    </div>

    <div class="patient-header new-patient-header">
        <div class="demographics">
            <h1 class="name" style="border-bottom: 1px solid #ddd;">
                <span>DRUG INDENT DETAILS &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
            </h1>
        </div>
    </div>
</div>

<div id="print">
    <% if (listTransactionDetail == null && listTransactionDetail.size() == 0) { %>
    <div style="margin: 10px auto; width: 981px; font-size: 1.0em;font-family:'Dot Matrix Normal',Arial,Helvetica,sans-serif;">
        <div class='hide'>
			<br/>
			<br/>
			<center style="float:center;font-size: 2.2em">Indent From ${store.name}</center>
			<br/>
			<br/>
			<span style="float:right;font-size: 1.7em">Date: ${date}</span>
			<br/>
			<br/>
		</div>
		
        <table border="1">
            <tr>
                <th>#</th>
                <th>CATEGORY</th>
                <th>DRUG NAME</th>
                <th>FORMULATION</th>
                <th>INDENT QNTY</th>
                <th>TRANSFER QNTY</th>
            </tr>

            <% if (listIndentDetail != null || listIndentDetail.size() > 0) { %>
            <% listIndentDetail.eachWithIndex { indent, varStatus -> %>
            <tr>
                <td>${varStatus + 1}</td>
                <td>${indent.drug.category.name}</td>
                <td>${indent.drug.name}</td>
                <td>${indent.formulation.name}-${indent.formulation.dozage}</td>
                <td>${indent.quantity}</td>
                <td>${indent.mainStoreTransfer}</td>
            </tr>
            <% } %>
            <% } %>

        </table>

        <br/><br/><br/><br/><br/><br/>
        <span style="float:left;font-size: 1.5em">Signature of sub-store/ Stamp</span><span
            style="float:right;font-size: 1.5em">Signature of inventory clerk/ Stamp</span>
        <br/><br/><br/><br/><br/><br/>
        <span style="margin-left: 13em;font-size: 1.5em">Signature of Medical Superintendent/ Stamp</span>
    </div>
    <% } else { %>
        <div class='hide'>
			<br/>
			<br/>
			<center style="float:center;font-size: 2.2em">Indent From ${store.name}</center>
			<br/>
			<br/>
			<span style="float:right;font-size: 1.7em">Date: ${date}</span>
			<br/>
			<br/>
		</div>
        <table border="1">
            <tr>
                <th>#</th>
                <th>CATEGORY</th>
                <th>DRUG NAME</th>
                <th>FORMULATION</th>
                <th>INDENT QNTY</th>
                <th>BATCH#</th>
                <th>EXPIRY</th>
                <th>COMPANY</th>
                <th>TRANSFER QNTY</th>
            </tr>

                <% if (listIndentDetail != null && listIndentDetail.size() > 0) { %>
                    <% listIndentDetail.eachWithIndex { indent, varStatus -> %>
                        <tr align="center">
                        <td>${varStatus+1}</td>
                        <td>${indent.drug.category.name}</td>
                        <td>${indent.drug.name}</td>
                        <td>${indent.formulation.name}-${indent.formulation.dozage}</td>
                        <td>${indent.quantity}</td>

                        <% def count=0 %>
                        <% def check=0 %>
                        <% listTransactionDetail.each { trDetail ->  %>
                            <% if (trDetail.drug.id == indent.drug.id && trDetail.formulation.id == indent.formulation.id) { %>
                                <% check=1 %>

                                    <% if (count > 0) { %>
                                        </tr>
                                        <tr align="center"
                                            class='${varStatus.index % 2 == 0 ? "oddRow" : "evenRow"} '>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td>${trDetail.batchNo}</td>
                                            <td>${trDetail.dateExpiry}</td>
                                            <td>${trDetail.companyName}</td>
                                            <td>${trDetail.issueQuantity}</td>
                                        </tr>
                                    <% } else {%>
                                        <td>${trDetail.batchNo}</td>
                                        <td>${trDetail.dateExpiry}</td>
                                        <td>${trDetail.companyName}</td>
                                        <td>${trDetail.issueQuantity}</td>
                                        </tr>
                                    <% } %>


                                <% count=count + 1 %>
                            <% } %>
                        <% } %>
                        <% if (check == 0){ %>
                            <td>N/A</td>
                            <td>N/A</td>
                            <td>N/A</td>
                            <td>0</td>
                            </tr>
                        <% } %>
                    <% } %>
                <% } %>

        </table>

        <br/><br/><br/><br/><br/><br/>
        <span style="float:left;font-size: 1.5em">Signature of sub-store/ Stamp</span><span
            style="float:right;font-size: 1.5em">Signature of inventory clerk/ Stamp</span>
        <br/><br/><br/><br/><br/><br/>
        <span style="margin-left: 13em;font-size: 1.5em">Signature of Medical Superintendent/ Stamp</span>
    <% } %>
</div>

<div id="footer">
    <img src="../ms/uiframework/resource/inventoryapp/images/tooltip.jpg"/>
    <span>Place the mouse over the Titles to get the meaning in full</span>

    <button class="button task" type="button" id="printButton"><i class="icon-print small"></i>Print</button>
</div>