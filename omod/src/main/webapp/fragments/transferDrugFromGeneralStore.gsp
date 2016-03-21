<style>
.dialog input {
    display: block;
    margin: 5px 0;
    color: #363463;
    padding: 5px 0 5px 10px;
    background-color: #FFF;
    border: 1px solid #DDD;
    width: 100%;
}

.dialog select option {
    font-size: 1em;
}

#modal-overlay {
    background: #000 none repeat scroll 0 0;
    opacity: 0.4 !important;
}

.dialog {
    display: none;
}

</style>
<script>
    var pDataString;
    jq(function () {


        jQuery('.date-pick').datepicker({minDate: '-100y', dateFormat: 'dd/mm/yy'});
        getIndentList();


    });//end of doc ready function
    function detailDrugIndent(indentId) {
        prescriptionDialog.show();

    }

    function processDrugIndent(indentId){
        window.location.href = emr.pageLink("inventoryapp", "mainStoreDrugProcessIndent", {
            "indentId": indentId
        });
    }

    var prescriptionDialog = emr.setupConfirmationDialog({
        selector: '#prescription-dialog',
        actions: {
            confirm: function () {
                console.log("This is the prescription object:");
                prescriptionDialog.close();
            },
            cancel: function () {
                prescriptionDialog.close();
            }
        }
    });


    function getIndentList(storeId, statusId, indentName, fromDate, toDate, viewIndent, indentId) {
        jq.getJSON('${ui.actionLink("inventoryapp", "transferDrugFromGeneralStore", "getIndentList")}',
                {
                    storeId: storeId,
                    statusId: statusId,
                    indentName: indentName,
                    fromDate: fromDate,
                    toDate: toDate,
                    viewIndent: viewIndent,
                    indentId: indentId
                }).success(function (data) {
                    if (data.length === 0 && data != null) {
                        jq().toastmessage('showNoticeToast', "No drug found!");
                    } else {
                        updateTransferList(data);
                    }
                }).error(function () {
                    jq().toastmessage('showNoticeToast', "An Error Occured while Fetching List");
                    jq('#transferList > tbody > tr').remove();
                    var tbody = jq('#transferList > tbody');
                    var row = '<tr align="center"><td colspan="6">No Drugs found</td></tr>';
                    tbody.append(row);
                });
    }

    //update the queue table
    function updateTransferList(tests) {
        jq('#transferList > tbody > tr').remove();
        var tbody = jq('#transferList > tbody');

        for (index in tests) {
            var row = '<tr>';
            var item = tests[index];
            row += '<td>' + (++index) + '</td>';
            row += '<td>' + item.store.name + '</td>';
            row += '<td><a href="#" title="Detail indent" onclick="detailDrugIndent(' + item.id + ');" ;>' + item.name + '</a></td>';
            row += '<td>' + item.createdOn + '</td>';
            row += '<td>' + item.mainStoreStatusName + '</td>';
            var link = "";
            if(item.mainStoreStatus == 1){
                link+= '<a href="#" title="Process Indent" onclick="processDrugIndent(' + item.id + ');" >Process Indent</a>';
            }
            row += '<td>' + link + '</td>';
            row += '</tr>';
            tbody.append(row);
        }
    }

</script>

<table id="transferList">
    <select name="storeId" class="searchField" title="Select Drug Store">
        <option value="">Select Store</option>
        <% listStore.each { %>
        <option value="${it.id}" title="${it.name}">
            ${it.name}
        </option>
        <% } %>
    </select>

    <select name="statusId" class="searchField" title="Select Status">
        <option value="">Select Status</option>
        <% listMainStoreStatus.each { %>
        <option value="${it.id}" title="${it.name}">
            ${it.name}
        </option>
        <% } %>
    </select>

    <input type="text" id="indentName" name="indentName" placeholder="Drug Name" class="searchField"
           title="Enter Drug Name"/>
    <label for="fromDate">From</label>
    <input type="text" id="fromDate" class="date-pick searchField" readonly="readonly" name="fromDate"
           title="Double Click to Clear" ondblclick="this.value = '';"/>
    <label for="toDate">To</label>
    <input type="text" id="toDate" class="date-pick searchField" readonly="readonly" name="toDate"
           title="Double Click to Clear" ondblclick="this.value = '';"/>
    <thead>
    <th>S. No</th>
    <th>From Store</th>
    <th>Indent Name</th>
    <th>Created On</th>
    <th>Status Indent</th>
    <th>Action</th>
    </thead>
    <tbody role="alert" aria-live="polite" aria-relevant="all">
    <tr align="center">
        <td colspan="6">No Drugs found</td>
    </tr>
    </tbody>
</table>

<div id="prescription-dialog" class="dialog">
    <div class="dialog-header">
        <i class="icon-folder-open"></i>

        <h3>Prescription</h3>
    </div>

    <div class="dialog-content">


        <span class="button confirm right">Confirm</span>
        <span class="button cancel">Cancel</span>
    </div>
</div>