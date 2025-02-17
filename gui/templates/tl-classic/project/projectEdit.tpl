{**
 * TestLink Open Source Project - http://testlink.sourceforge.net/
 *
 * Smarty template - Edit existing Test project
 *
 * @filesource  projectEdit.tpl
 *
 *
 *}
{$cfg_section=$smarty.template|basename|replace:".tpl":""}
{config_load file="input_dimensions.conf" section=$cfg_section}

{* Configure Actions *}
{$managerURL="lib/project/projectEdit.php"}
{$editAction="$managerURL?doAction=edit&tprojectID="}

{lang_get var="labels"
  s='show_event_history,th_active,cancel,info_failed_loc_prod,invalid_query,
  create_from_existent_tproject,opt_no,caption_edit_tproject,caption_new_tproject,name,
  title_testproject_management,testproject_enable_priority, testproject_enable_automation,
  public,testproject_color,testproject_alt_color,testproject_enable_requirements,
  testproject_enable_inventory,testproject_features,testproject_description,
  testproject_prefix,availability,mandatory,warning,warning_empty_tcase_prefix,api_key,
  warning_empty_tproject_name,testproject_issue_tracker_integration,issue_tracker,
  testproject_code_tracker_integration,code_tracker,testproject_reqmgr_integration,reqmgrsystem,
  no_rms_defined,no_issuetracker_defined,no_codetracker_defined'}

{include file="inc_head.tpl" openHead="yes" jsValidate="yes" editorType=$editorType}
{include file="inc_del_onclick.tpl"}
{include file="bootstrap.inc.tpl"}

{if $gui_cfg->testproject_coloring neq 'none'}
  {include file="inc_jsPicker.tpl"}
{/if}

<script type="text/javascript">
var alert_box_title = "{$labels.warning|escape:'javascript'}";
var warning_empty_tcase_prefix = "{$labels.warning_empty_tcase_prefix|escape:'javascript'}";
var warning_empty_tproject_name = "{$labels.warning_empty_tproject_name|escape:'javascript'}";

function validateForm(f)
{
  if (isWhitespace(f.tprojectName.value))
  {
     alert_message(alert_box_title,warning_empty_tproject_name);
     selectField(f, 'tprojectName');
     return false;
  }
  if (isWhitespace(f.tcasePrefix.value))
  {
     alert_message(alert_box_title,warning_empty_tcase_prefix);
     selectField(f, 'tcasePrefix');
     return false;
  }

  return true;
}

/**
 *
 *
 */
function manageTracker(selectOID,targetOID)
{
  var so;
  var to;

  to = document.getElementById(targetOID);
  if ( typeof(to) == 'undefined' || to == null) {
    return;
  }

  so = document.getElementById(selectOID);
  to.disabled = false;
  if (so.selectedIndex == 0){
    to.checked = false;
    to.disabled = true;
  }

}

</script>
</head>

<body onload="manageTracker('issue_tracker_id','issue_tracker_enabled');
manageTracker('code_tracker_id','code_tracker_enabled');">
<h1 class="title">
  {$main_descr|escape}  {$tlCfg->gui_title_separator_1}
  {$caption|escape}
  {if $mgt_view_events eq "yes" and $gui->tprojectID}
    <img style="margin-left:5px;" class="clickable" src="{$tlImages.help}"
           onclick="showEventHistoryFor('{$gui->tprojectID}','testprojects')"
           alt="{$labels.show_event_history}" title="{$labels.show_event_history}"/>
  {/if}
</h1>

{if $user_feedback != ''}
  {include file="inc_update.tpl" user_feedback=$user_feedback feedback_type=$feedback_type}
{/if}

<div class="workBack">
  {if $gui->found == "yes"}
    <div style="width:80%; margin: auto;">
    <form name="edit_testproject" id="edit_testproject"
          method="post" action="{$managerURL}"
          onSubmit="javascript:return validateForm(this);">
    <table id="item_view" class="common" style="width:100%; padding:3px;margin-bottom: 0px;">

      {if $gui->tprojectID eq 0}
        {if $gui->testprojects != ''}
       <tr>
         <td>{$labels.create_from_existent_tproject}</td>
         <td class="form-row" style="padding: 0 0 0 0;">
           <div class="form-group col-md-1" style="padding-left: 0">
           <select class="form-control" name="copy_from_tproject_id">
           <option value="0">{$labels.opt_no}</option>
           {foreach item=testproject from=$gui->testprojects}
             <option value="{$testproject.id}">{$testproject.name|escape}</option>
           {/foreach}
           </select>
           </div>
         </td>
       </tr>
       {/if}
      {/if}
      <tr>
        <td>{$labels.name} *</td>
        <td class="form-row" style="padding: 0 0 0 0;">
          <div class="form-group col-md-6" style="padding-left: 0; height: 30px;">
          <input class="form-control" type="text" name="tprojectName" size="{#TESTPROJECT_NAME_SIZE#}"
            value="{$gui->tprojectName|escape}" maxlength="{#TESTPROJECT_NAME_MAXLEN#}" required />
            {include file="error_icon.tpl" field="tprojectName"}
          </div>
        </td>
      </tr>
      <tr>
        <td>{$labels.testproject_prefix} *</td>
        <td class="form-row" style="padding: 0 0 0 0;">
          <div class="form-group col-md-6" style="padding-left: 0; height: 30px;">
          <input class="form-control" type="text" name="tcasePrefix" size="{#TESTCASE_PREFIX_SIZE#}"
                   value="{$gui->tcasePrefix|escape}" maxlength="{#TESTCASE_PREFIX_MAXLEN#}" required />
            {include file="error_icon.tpl" field="tcasePrefix"}
          </div>
        </td>
      </tr>
      <tr>
        <td>{$labels.testproject_description}</td>
        <td style="width:80%">{$notes}</td>
      </tr>
      {if $gui_cfg->testproject_coloring neq 'none'}
      <tr>
        <th style="background:none;">{$labels.testproject_color}</th>
        <td>
          <input type="text" name="color" value="{$color|escape}" maxlength="12" />
          {* this function below calls the color picker javascript function.
          It can be found in the color directory *}
          <a href="javascript: TCP.popup(document.forms['edit_testproject'].elements['color'], '{$basehref}third_party/color_picker/picker.html');">
            <img width="15" height="13" border="0" alt="{$labels.testproject_alt_color}"
            src="third_party/color_picker/img/sel.gif" />
          </a>
        </td>
      </tr>
      {/if}
      <tr>
        <td>{$labels.testproject_features}</td><td></td>
      </tr>
      <tr>
        <td></td><td>
            <input class="form-check-input" type="checkbox" name="optReq"
                {if $gui->projectOptions->requirementsEnabled} checked="checked"  {/if} />
          {$labels.testproject_enable_requirements}
        </td>
      </tr>
      <tr>
        <td></td><td>
          <input class="form-check-input" type="checkbox" name="optPriority"
              {if $gui->projectOptions->testPriorityEnabled} checked="checked"  {/if} />
          {$labels.testproject_enable_priority}
        </td>
      </tr>
      <tr>
        <td></td><td>
          <input class="form-check-input" type="checkbox" name="optAutomation"
                {if $gui->projectOptions->automationEnabled} checked="checked" {/if} />
          {$labels.testproject_enable_automation}
        </td>
      </tr>
      <tr>
        <td></td><td>
          <input class="form-check-input" type="checkbox" name="optInventory"
                {if $gui->projectOptions->inventoryEnabled} checked="checked" {/if} />
          {$labels.testproject_enable_inventory}
        </td>
      </tr>

      <tr>
        <td>{$labels.testproject_issue_tracker_integration}</td><td></td>
      </tr>
      {if $gui->issueTrackers == ''}
        <tr>
          <td></td>
          <td>{$labels.no_issuetracker_defined}</td>
        </tr>
      {else}
        <tr>
          <td></td>
          <td>
            <input class="form-check-input" type="checkbox" id="issue_tracker_enabled"
                   name="issue_tracker_enabled" {if $gui->issue_tracker_enabled == 1} checked="checked" {/if} />
            {$labels.th_active}
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            {$labels.issue_tracker}
             <select name="issue_tracker_id" id="issue_tracker_id"
             onchange="manageTracker('issue_tracker_id','issue_tracker_enabled');">
             <option value="0">&nbsp;</option>
             {foreach item=issue_tracker from=$gui->issueTrackers}
               <option value="{$issue_tracker.id}"
                 {if $issue_tracker.id == $gui->issue_tracker_id} selected {/if}
               >
               {$issue_tracker.verbose|escape}</option>
             {/foreach}
             </select>
          </td>
        </tr>
      {/if}

      <tr>
        <td>{$labels.testproject_code_tracker_integration}</td><td></td>
      </tr>
      {if $gui->codeTrackers == ''}
        <tr>
          <td></td>
          <td>{$labels.no_codetracker_defined}</td>
        </tr>
      {else}
        <tr>
          <td></td>
          <td>
            <input class="form-check-input" type="checkbox" id="code_tracker_enabled"
                   name="code_tracker_enabled" {if $gui->code_tracker_enabled == 1} checked="checked" {/if} />
            {$labels.th_active}
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            {$labels.code_tracker}
             <select name="code_tracker_id" id="code_tracker_id"
             onchange="manageTracker('code_tracker_id','code_tracker_enabled');">
             <option value="0">&nbsp;</option>
             {foreach item=code_tracker from=$gui->codeTrackers}
               <option value="{$code_tracker.id}"
                 {if $code_tracker.id == $gui->code_tracker_id} selected {/if}
               >
               {$code_tracker.verbose|escape}</option>
             {/foreach}
             </select>
          </td>
        </tr>
      {/if}

      {*
      <tr>
        <td>{$labels.testproject_reqmgr_integration}</td><td></td>
      </tr>
      {if $gui->reqMgrSystems == ''}
      <tr>
        <td></td>
        <td>{$labels.no_rms_defined}</td>
      </tr>
      {else}
      <tr>
        <td></td>
        <td>
          <input type="checkbox" id="reqmgr_integration_enabled"
                 name="reqmgr_integration_enabled" {if $gui->reqmgr_integration_enabled == 1} checked="checked" {/if} />
            {$labels.th_active}
          </td>
      </tr>
      <tr>
        <td></td>
        <td>
            {$labels.reqmgrsystem}
             <select name="reqmgrsystem_id" id="reqmgrsystem_id">
             <option value="0">&nbsp;</option>
             {foreach item=rms from=$gui->reqMgrSystems}
               <option value="{$rms.id}"
                 {if $rms.id == $gui->reqmgrsystem_id} selected {/if}
               >
               {$rms.verbose|escape}</option>
             {/foreach}
             </select>
          </td>
      </tr>
      {/if}
      *}

      <tr>
        <td>{$labels.availability}</td><td></td>
      </tr>
      <tr>
        <td></td><td>
            <input class="form-check-input" type="checkbox" name="active" {if $gui->active eq 1} checked="checked" {/if} />
            {$labels.th_active}
          </td>
          </tr>

      <tr>
        <td></td><td>
            <input class="form-check-input" type="checkbox" name="is_public" {if $gui->is_public eq 1} checked="checked"  {/if} />
            {$labels.public}
          </td>
      </tr>

      {if $gui->api_key != ''}
      <tr>
        <td>{$labels.api_key}</td>
        <td>{$gui->api_key}</td>
      </tr>
      {/if}



      <tr><td cols="2">
        {if $gui->canManage == "yes"}
        <div class="groupBtn">
          <input class="btn btn-primary" type="hidden" name="doAction" value="{$doActionValue}" />
          <input class="btn btn-primary" type="hidden" name="tprojectID" value="{$gui->tprojectID}" />
          <input class="btn btn-primary" type="submit" name="doActionButton" value="{$buttonValue}"/>
          <input class="btn btn-primary" type="button" name="go_back" value="{$labels.cancel}"
                 onclick="javascript: location.href=fRoot+'lib/project/projectView.php';" />

        </div>
      {/if}
      </td></tr>

    </table>
    </form>
    <p>* {$labels.mandatory}</p>
  </div>
  {else}
    <p class="info">
    {if $gui->tprojectName != ''}
      {$labels.info_failed_loc_prod} - {$gui->tprojectName|escape}!<br />
    {/if}
    {$labels.invalid_query}: {$sqlResult|escape}</p>
  {/if}
</div>
</body>
</html>
