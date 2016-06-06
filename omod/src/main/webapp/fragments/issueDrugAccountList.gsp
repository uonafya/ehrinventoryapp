<%
	ui.includeJavascript("billingui", "moment.js")
%>

<script>
    jq(function () {
        var date = jq("#acctFrom-field").val();
		
        jq.getJSON('${ui.actionLink("inventoryapp", "IssueDrugAccountList", "fetchList")}',{
			"date": moment(date).format('DD/MM/YYYY'),
			"currentPage": 1
		}).success(function (data) {
			if (data.length === 0) {}
			else {
				QueueTable(data)
			}
		});
		
		jq('#issue-button').click(function(){
			window.location.href = emr.pageLink("inventoryapp", "subStoreIssueAccountDrug");
		});		

        jq("#acctFrom-display, #acctDate-display").on("change", function () {
            reloadmyList();
        });

        jq('#accountName').on("keyup", function () {
            reloadmyList();
        });
		
        function reloadmyList() {
            var accountName = jq("#accountName").val();
            var acctFrom = moment(jq("#acctFrom-field").val()).format('DD/MM/YYYY');
            var acctDate = moment(jq("#acctDate-field").val()).format('DD/MM/YYYY');
			
            getAccountList(accountName, acctFrom, acctDate);
        }

        getAccountList();
    });

    //update the queue table
    function QueueTable(tests) {
        jq('#accounts-list > tbody > tr').remove();
        var tbody = jq('#accounts-list > tbody');
        for (index in tests) {
            var item = tests[index];
            var row = '<tr>';

            row += '<td>' + (parseInt(index)+1) + '</td>'
            row += '<td>' + item.createdOn.toString().substring(0, 11).replaceAt(2, ",").replaceAt(6, " ").insertAt(3, 0, " ") + '</td>'
            row += '<td><a href="#" onclick="accountDetail(' + item.id + ');"' +
                    'accountDetail(id);' +
                    '">' + item.name + '  <a/></td>'
            row += '<td>N/A</td>'
            row += '<td><a onclick="accountDetail(' + item.id + ');"><i class="icon-bar-chart small"></i>VIEW</a></td>'

            row += '</tr>';
            tbody.append(row);
        }
    }

    function accountDetail(id) {
        window.location.href = emr.pageLink("inventoryapp", "issueDrugAccountDetail", {
            "issueId": id
        });
    }
	
    function getAccountList(issueName, acctFrom, acctDate) {
        jq.getJSON('${ui.actionLink("inventoryapp", "issueDrugAccountList", "fetchList")}',{
			issueName:	issueName,			
			fromDate: 	acctFrom,
			toDate: 	acctDate,
		}).success(function (data) {
			if (data.length === 0 && data != null) {
				jq().toastmessage('showNoticeToast', "No account found!");
				jq('#accounts-list > tbody > tr').remove();
				var tbody = jq('#accounts-list > tbody');
				var row = '<tr align="center"><td>&nbsp;</td><td colspan="5">No accounts found</td></tr>';
				tbody.append(row);

			} else {
				QueueTable(data);

			}
		}).error(function () {
			jq().toastmessage('showNoticeToast', "An Error Occured while Fetching List");
			jq('#accounts-list > tbody > tr').remove();
			var tbody = jq('#accounts-list > tbody');
			var row = '<tr align="center"><td colspan="5">No Accounts found</td></tr>';
			tbody.append(row);

		});
    }
</script>

<style>
	#acctFrom label,
	#acctDate label{
		display: none;
	}
	#accounts-list{
		font-size: 14px;
	}
	#accounts-list th:first-child{
		width: 5px;
	}
	#accounts-list th:nth-child(2){
		width: 95px;
	}
	#accounts-list th:nth-child(4){
		min-width: 150px;
	}
	#accounts-list th:last-child{
		width: 60px;
	}
</style>

<div class="dashboard clear">
	<div class="info-section">
		<div class="info-header">
			<i class="icon-list-ul"></i>
            <h3>RECEIPT DRUGS</h3>
			
			<div style="margin-top: -1px">
				<i class="icon-filter" style="font-size: 26px!important; color: #5b57a6"></i>
				
				<label for="accountName">Description</label>
				<input type="text" id="accountName" name="accountName" placeholder="Account Name" class="searchFieldBlur" title="Receipt Name" style="width: 160px"/>
				<label>&nbsp;&nbsp;From&nbsp;</label>${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'acctFrom', id: 'acctFrom', label: 'cc', useTime: false, defaultToday: false, class: ['newdtp']])}
				<label>&nbsp;&nbsp;To&nbsp;</label  >${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'acctDate',    id: 'acctDate',   label: 'cc', useTime: false, defaultToday: false, class: ['newdtp']])}
			</div>
			
			
		</div>
	</div>
</div>

<table id="accounts-list">
    <thead>
		<th>#</th>
		<th>DATE</th>
		<th>ACCOUNT NAME</th>
		<th>NOTES</th>
		<th>ACTION</th>
    </thead>
	
    <tbody>
		<td></td>
		<td colspan="6">No Accounts found</td>
    </tbody>
</table>

<div class="summary-div">
	<a class="button task" href="subStoreIssueAccountDrug.page" style="float: right; margin-top: 5px; text-align: center; height: 20px; padding-top: 15px">
		<i class="icon-plus small"> </i>
		&nbsp; Issue Drugs
	</a>
</div>

