{*-------------------------------------------------------+
| SYSTOPIA Donation Receipts Extension                   |
| Household Merger Extension                             |
| Copyright (C) 2015-2023 SYSTOPIA                       |
| Author: B. Endres (endres@systopia.de)                 |
| http://www.systopia.de/                                |
+--------------------------------------------------------+
| This program is released as free software under the    |
| Affero GPL license. You can redistribute it and/or     |
| modify it under the terms of this license which you    |
| can read by viewing the included agpl.txt or online    |
| at www.gnu.org/licenses/agpl.html. Removal of this     |
| copyright header is strictly prohibited without        |
| written permission from the original author(s).        |
+--------------------------------------------------------*}

<h3>{ts domain="de.systopia.householdmerge"}Options{/ts}</h3>
<div class="label">
  <label for="result_count">{ts domain="de.systopia.householdmerge"}Maximum number of results{/ts}</label>
  <select id="result_count">
    <option {if $result_count eq "25"}selected=selected{/if} value="25">25</option>
    <option {if $result_count eq "50"}selected=selected{/if} value="50">50</option>
    <option {if $result_count eq "100"}selected=selected{/if} value="100">100</option>
    <option {if $result_count eq "500"}selected=selected{/if} value="500">500</option>
    <option {if $result_count eq "all"}selected=selected{/if} value="all">{ts domain="de.systopia.householdmerge"}all{/ts}</option>
  </select>
</div>
<br/>
<div>
  <a class="button" id="exec_all">{ts domain="de.systopia.householdmerge"}Create all selected households{/ts}</a>
</div>


<br/><br/><br/>

<h3>{ts domain="de.systopia.householdmerge"}Results{/ts}</h3>
{foreach from=$proposals item=proposal}
{assign var=some_member_id value=$proposal.member_ids|@reset}

<h2>
  <input style="float:left;" value="{$proposal.id}" type="checkbox" id="select-{$proposal.id}" class="selector" checked="1" />
  <div class="icon crm-icon Household-icon"></div>{ts domain="de.systopia.householdmerge"}New Household:{/ts} {$proposal.contacts.$some_member_id.last_name}
</h2>
<table id="{$proposal.id}" nostyle="width: 400px">
{if $proposal.head_id}
  {assign var=head_id value=$proposal.head_id}
  <tr>
    <td width="100px">{ts domain="de.systopia.householdmerge"}Head{/ts}</td>
    <td>
      <div class="icon crm-icon Individual-icon"></div>
      <a href="{crmURL p='civicrm/contact/view' q="reset=1&cid=$head_id"}">{$proposal.contacts.$head_id.display_name} [{$head_id}]</a>
    </td>
  </tr>
{/if}

{foreach from=$proposal.member_ids item=member_id name=memberloop}
  <tr>
    <td>{ts domain="de.systopia.householdmerge"}Member{/ts}</td>
    <td>
      <div class="icon crm-icon Individual-icon"></div>
      <a href="{crmURL p='civicrm/contact/view' q="reset=1&cid=$member_id"}">{$proposal.contacts.$member_id.display_name} [{$member_id}]</a>
    </td>
    {if $smarty.foreach.memberloop.first}
    <td rowspan="{$proposal.member_ids|@count}">
      <a class="button hhcreate" id="button-{$proposal.id}" style="float:right;">{ts domain="de.systopia.householdmerge"}Create Household{/ts}</a>
    </td>
    {/if}
  </tr>
{/foreach}

  <tr>
    <td>{ts domain="de.systopia.householdmerge"}Address{/ts}</td>
    <td>
      <div class="icon crm-icon Household-icon"></div>
      {$proposal.contacts.$some_member_id.street_address}, {$proposal.contacts.$some_member_id.postal_code} {$proposal.contacts.$some_member_id.city}, {$proposal.contacts.$some_member_id.country}
    </td>
  </tr>
</table>
<br/>
{/foreach}


<script type="text/javascript">
let page_url = "{crmURL p='civicrm/household/finder' q="count=__count__"}";
let busy_icon_url = "{$config->resourceBase}i/loading.gif";
let check_icon_url = "{$config->resourceBase}i/contact_house.png";
let proposals = {$proposals_json};
{literal}

// click on CREATE ALL
cj("#exec_all").click(function() {
  // mark as busy
  cj("#exec_all").addClass('disabled');

  // find the next selected item
  let selectors = cj("input.selector");
  for (let i = 0; i < selectors.length; i++) {
    let element = cj(selectors[i]);
    if (element.prop('checked')) {
      let button = cj("#button-" + element.prop("value"));
      button.click();
      return;
    }
  }

  // if we get here, we can enable the button again
  cj("#exec_all").removeClass('disabled');
});

// click on INDIVIDUAL BUTTON
cj("a.hhcreate").click(function(e) {
  // find ID
  let identifier = cj(e.currentTarget).closest("table").prop('id');

  // untick / disable checkbox
  cj("#select-" + identifier).prop('checked', false);
  cj("#select-" + identifier).remove();

  // disable button, add busy icon
  cj(e.currentTarget).parent().append('&nbsp;<img class="busyindicator" height="12" src="' + busy_icon_url + '"/>');
  cj(e.currentTarget).remove();

  // build and send query
  let query = proposals[identifier];
  delete query['contacts']; // remove contact details
  CRM.api('Contact', 'create_household', query,
    { // SUCCESS HANDLER
      success: function(data) {
        // replace BUSY icon
        cj("#" + identifier).find("img.busyindicator").prop('src', check_icon_url);

        // TODO: display/link result?

        // if "exec_all" is active -> trigger next
        if (cj("#exec_all").hasClass('disabled')) {
          cj("#exec_all").click();
        }
      }
    });
});

// change result count
cj("#result_count").change(function() {
  window.location = page_url.replace('__count__', cj("#result_count").val());
});

</script>
{/literal}
