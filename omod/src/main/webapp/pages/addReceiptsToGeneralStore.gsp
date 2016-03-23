<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Module"])

    ui.includeCss("billingui", "jquery.dataTables.min.css")
    ui.includeCss("registration", "onepcssgrid.css")

    ui.includeJavascript("billingui", "moment.js")
    ui.includeJavascript("billingui", "jquery.dataTables.min.js")
    ui.includeJavascript("laboratoryapp", "jq.browser.select.js")
%>
<head>
    <script>
        jq(function () {
            jq("#tabs").tabs();

            var getJSON = function (dataToParse) {
                if (typeof dataToParse === "string") {
                    return JSON.parse(dataToParse);
                }
                return dataToParse;
            }

            var drugOrder = [];

            var adddrugdialog = emr.setupConfirmationDialog({
                selector: '#addDrugDialog',
                actions: {
                    confirm: function() {
                        var tbody = jq('#addDrugsTable').children('tbody');
                        var table = tbody.length ? tbody : jq('#addDrugsTable');
                        var index = drugOrder.length + 1;
                        table.append('<tr><td>'+ index +'</td><td>'+jq("#drugCategory").val()+'</td><td>'+jq("#drugName").val()+'</td><td>'+jq("#drugFormulation option:selected").text()+'</td><td>'+jq("#quantity").val()+'</td><td>'+jq("#unitPrice").val()+'</td><td>'+jq("#institutionalCost").val()+'</td><td>'+jq("#costToThePatient").val()+'</td><td>'+jq("#batchNo").val()+'</td><td>'+jq("#companyName").val()+'</td><td>'+jq("#dateOfManufacture").val()+'</td><td>'+jq("#dateOfExpiry").val()+'</td><td>'+jq("#receiptDate").val()+'</td><td>'+jq("#receiptFrom").val()+'</td></tr>');
                        drugOrder.push(
                                {
                                    drugCategoryId: jq("#drugCategory").children(":selected").attr("id"),
                                    drugId: jq("#drugName").children(":selected").attr("id"),
                                    drugFormulationId: jq("#drugFormulation").children(":selected").attr("id"),
                                    quantity: jq("#drugDays").val(),
                                    unitPrice: jq("#unitPrice").val(),
                                    institutionalCost:jq("#institutionalCost").val(),
                                    costToThePatient:jq("#costToThePatient").val(),
                                    batchNo:jq("#batchNo").val(),
                                    companyName:jq("#companyName").val(),
                                    dateOfManufacture:jq("#dateOfManufacture").val(),
                                    dateOfExpiry:jq("#dateOfExpiry").val(),
                                    receiptDate:jq("#receiptDate").val(),
                                    receiptFrom:jq("#receiptFrom").val()
                                }
                        );
                        adddrugdialog.close();
                    },
                    cancel: function() {
                        adddrugdialog.close();
                    }
                }
            });

            jq("#addDrugsButton").on("click", function(e){
                adddrugdialog.show();
            });

            jq("#drugCategory").on("change",function(e){
                var categoryId = jq(this).children(":selected").attr("id");
                var drugNameData ="";
                jq.getJSON('${ ui.actionLink("inventoryapp", "AddReceiptsToStore", "fetchDrugNames") }',{
                    categoryId:categoryId
                })
                        .success(function(data) {

                            for (var key in data) {
                                if (data.hasOwnProperty(key)) {
                                    var val = data[key];
                                    for (var i in val) {
                                        if (val.hasOwnProperty(i)) {
                                            var j = val[i];
                                            if(i=="id")
                                            {
                                                drugNameData=drugNameData + '<option id="'+j+'"';
                                            }
                                            else{
                                                drugNameData=drugNameData+ 'name="' +j+ '">' + j+'</option>';
                                            }
                                        }
                                    }
                                }
                            }
                            jq(drugNameData).appendTo("#drugName");
                        })
                        .error(function(xhr, status, err) {
                            alert('AJAX error ' + err);
                        });
            });

            jq("#drugName").on("change",function(e){
                var drugName = jq(this).children(":selected").attr("name");
                var drugFormulationData ="";
                jq.getJSON('${ ui.actionLink("inventoryapp", "AddReceiptsToStore", "getFormulationByDrugName") }',{
                            drugName:drugName
                        })
                        .success(function(data) {
                            for (var key in data) {
                                if (data.hasOwnProperty(key)) {
                                    var val = data[key];
                                    for (var i in val) {
                                        if (val.hasOwnProperty(i)) {
                                            var j = val[i];
                                            if(i=="id")
                                            {
                                               drugFormulationData=drugFormulationData + '<option id="'+j+'">';
                                            }
                                            else{
                                                drugFormulationData=drugFormulationData + j+'</option>';
                                            }
                                        }
                                    }
                                }
                            }
                            jq(drugFormulationData).appendTo("#drugFormulation");
                        })
                        .error(function(xhr, status, err) {
                            alert('AJAX error ' + err);
                        });
            });

            jq("#addDrugsSubmitButton").click(function(event) {

                drugOrder = JSON.stringify(drugOrder);

                var addDrugsData = {
                    'drugOrder':drugOrder
                };

                jq.getJSON('${ ui.actionLink("inventoryapp", "AddReceiptsToStore", "saveReceipt") }',addDrugsData)
                        .success(function(data) {
                            alert('ok');
                        })
                        .error(function(xhr, status, err) {
                            alert('AJAX error ' + err);
                        })

            });

        });
    </script>

    <style>
    body {
        margin-top: 20px;
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

    form input:focus {
        border: 1px solid #00f !important;
    }

    input[type="text"], select {
        border: 1px solid #aaa;
        border-radius: 2px !important;
        box-shadow: none !important;
        box-sizing: border-box !important;
        height: 32px;
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
        margin-top: 10px;
        position: absolute;
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
    </style>
</head>

<body>
<div class="clear"></div>

<div class="container">
    <div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="${ui.pageLink('referenceapplication', 'home')}">
                    <i class="icon-home small"></i></a>
            </li>

            <li>
                <i class="icon-chevron-right link"></i>
                Inventory Module
            </li>
        </ul>
    </div>

    <div class="patient-header new-patient-header">
        <div class="demographics">
            <h1 class="name" style="border-bottom: 1px solid #ddd;">
                <span>INVENTORY DASHBOARD &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
            </h1>
        </div>

        <div>
            <table id="addDrugsTable" class="dataTable">
                <thead>
                <tr role="row">
                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">S.No<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Drug Category<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Drug Name<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Formulation<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Quantity<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Unit Price<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Institutional Cost(%)<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Cost To The Patient<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Batch No.<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">CN<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">DM<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">DE<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">RD<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">RF<span class="DataTables_sort_icon"></span></div>
                    </th>
                </tr>
                </thead>

                <tbody>
                </tbody>
            </table>

            <input type="button" value="Add" class="button confirm" name="addDrugsButton" id="addDrugsButton" style="margin-top:20px;">
            <input type="button" value="Submit" class="button confirm" name="addDrugsSubmitButton" id="addDrugsSubmitButton" style="margin-top:20px;">
        </div>

    </div>
</div>

<div id="addDrugDialog" class="dialog">
    <div class="dialog-header">
        <i class="icon-folder-open"></i>
        <h3>Prescription</h3>
    </div>
    <div class="dialog-content">
        <ul>
            <li>
                <lable for="listCategory">Drug Category</lable>
                <select name="drugCategory" id="drugCategory" >
                    <option>Select Category</option>
                    <% if (listCategory!=null || listCategory!="") { %>
                    <% listCategory.each { drugCategory -> %>
                        <option id="${drugCategory.id}">${drugCategory.name}</option>
                    <% } %>
                    <% } %>
                </select>
            </li>
            <li>
                <label for="drugName">Drug Name</label>
                <select name="drugName" id="drugName" >
                    <option>Select Drug</option>
                </select>
            </li>
            <li>
                <lable for="drugFormulation">Formulation</lable>
                <select name="drugFormulation" id="drugFormulation" >
                    <option>Select Formulation</option>
                </select>
            </li>

            <li>
                <label for="quantity">Quantity</label>
                <input name="quantity" id="quantity" type="text" >
            </li>

            <li>
                <label for="unitPrice">Unit Price</label>
                <input name="unitPrice" id="unitPrice" type="text" >
            </li>

            <li>
                <label for="institutionalCost">Institutional Cost(%)</label>
                <input name="institutionalCost" id="institutionalCost" type="text" >
            </li>

            <li>
                <label for="costToThePatient">Cost To The Patient</label>
                <input name="costToThePatient" id="costToThePatient" type="text" >
            </li>

            <li>
                <label for="batchNo">Batch No.</label>
                <input name="batchNo" id="batchNo" type="text" >
            </li>

            <li>
                <label for="companyName">Company Name</label>
                <input name="companyName" id="companyName" type="text" >
            </li>

            <li>
                <label for="dateOfManufacture">Date of Manufacture</label>
                <input type="date" name="dateOfManufacture" id="dateOfManufacture" type="text" >
            </li>

            <li>
                <label for="dateOfExpiry">Date of Expiry</label>
                <input type="date" name="dateOfExpiry" id="dateOfExpiry" type="text" >
            </li>

            <li>
                <label for="receiptDate">Receipt Date</label>
                <input type="date" name="receiptDate" id="receiptDate" type="text" >
            </li>

            <li>
                <label for="receiptFrom">Receipt From</label>
                <input name="receiptFrom" id="receiptFrom" type="text" >
            </li>

        </ul>

        <span class="button confirm right" > Confirm </span>
        <span class="button cancel"> Cancel </span>
    </div>
</div>

</body>


