<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Process Indent "])
%>

<div class="patient-header new-patient-header">
    <div class="demographics">
        <h1 class="name">
            <span>${indent.name},<em>Drug Name</em></span>
            <span>${indent.store.name}  <em>From Store</em></span>
            <span>${indent.createdOn}  <em>Created On</em></span>
        </h1>
    </div>
    <div class="close"></div>
</div>
<div class="dashboard clear">
    <div class="info-section">
        <div class="info-header">
            <i class="icon-share"></i>
            <h3>Process Indent</h3>
        </div>
    </div>
</div>
