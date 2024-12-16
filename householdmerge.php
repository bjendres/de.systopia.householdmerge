<?php
/*-------------------------------------------------------+
| Household Merger Extension                             |
| Copyright (C) 2015 SYSTOPIA                            |
| Author: B. Endres (endres@systopia.de)                 |
+--------------------------------------------------------+
| This program is released as free software under the    |
| Affero GPL license. You can redistribute it and/or     |
| modify it under the terms of this license which you    |
| can read by viewing the included agpl.txt or online    |
| at www.gnu.org/licenses/agpl.html. Removal of this     |
| copyright header is strictly prohibited without        |
| written permission from the original author(s).        |
+--------------------------------------------------------*/

require_once 'householdmerge.civix.php';

use CRM_Householdmerge_ExtensionUtil as E;

/**
* Add an action for creating donation receipts after doing a search
*
* @param string $objectType specifies the component
* @param array $tasks the list of actions
*
* @access public
*/
function householdmerge_civicrm_searchTasks($objectType, &$tasks) {
  // add MERGE INTO HOUSEHOLD task to contact list
  if ($objectType == 'contact') {
    // this object is only available for the 'merge' mode
    if ('merge' == CRM_Householdmerge_Logic_Configuration::getHouseholdMode()) {
      $tasks['hh_merge'] = array(
          'title'  => ts('Merge into Household', array('domain' => 'de.systopia.householdmerge')),
          'class'  => 'CRM_Householdmerge_Form_Task_Merge',
          'result' => false);
    }
  }

  // add "Fix Problems" task for activities
  if ($objectType == 'activity') {
    $tasks['hh_merge_fixer'] = array(
        'title'  => ts('Fix Household Problems', array('domain' => 'de.systopia.householdmerge')),
        'class'  => 'CRM_Householdmerge_Form_Task_Fix',
        'result' => false);
  }


}

/**
 * Implements hook_civicrm_config().
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_config
 */
function householdmerge_civicrm_config(&$config) {
  _householdmerge_civix_civicrm_config($config);
}

/**
 * Implements hook_civicrm_install().
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_install
 */
function householdmerge_civicrm_install() {
  _householdmerge_civix_civicrm_install();
}

/**
 * Implements hook_civicrm_uninstall().
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_uninstall
 */
function householdmerge_civicrm_uninstall() {
  _householdmerge_civix_civicrm_uninstall();
}

/**
 * Implements hook_civicrm_enable().
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_enable
 */
function householdmerge_civicrm_enable() {
  _householdmerge_civix_civicrm_enable();
}

/**
 * Implements hook_civicrm_disable().
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_disable
 */
function householdmerge_civicrm_disable() {
  _householdmerge_civix_civicrm_disable();
}

/**
 * Implements hook_civicrm_upgrade().
 *
 * @param $op string, the type of operation being performed; 'check' or 'enqueue'
 * @param $queue CRM_Queue_Queue, (for 'enqueue') the modifiable list of pending up upgrade tasks
 *
 * @return mixed
 *   Based on op. for 'check', returns array(boolean) (TRUE if upgrades are pending)
 *                for 'enqueue', returns void
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_upgrade
 */
function householdmerge_civicrm_upgrade($op, CRM_Queue_Queue $queue = NULL) {
  return _householdmerge_civix_civicrm_upgrade($op, $queue);
}

/**
 * merge hook for 'merge' mode households
 */
function householdmerge_civicrm_merge($type, &$data, $mainId = NULL, $otherId = NULL, $tables = NULL) {
  if ('merge' == CRM_Householdmerge_Logic_Configuration::getHouseholdMode()) {
    // if in 'merge' mode, pass this hook to the househould merge controller
    $hhmerge_controller = new CRM_Householdmerge_MergeController();
    $hhmerge_controller->resolveConflicts($type, $data, $mainId, $otherId);
  }
}

/**
 * Set permissions for runner/engine API call
 */
function householdmerge_civicrm_alterAPIPermissions($entity, $action, &$params, &$permissions) {
  $permissions['contact']['create_household'] = CRM_Householdmerge_Logic_Configuration::getCreateHouseholdPermission();
}

/**
 * Implements hook_civicrm_xmlMenu().
 *
 * @param array $files
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_xmlMenu
 */
function householdmerge_civicrm_xmlMenu(&$files) {
  _householdmerge_civix_civicrm_xmlMenu($files);
}

/**
 * Implements hook_civicrm_postInstall().
 *
 * @link https://docs.civicrm.org/dev/en/latest/hooks/hook_civicrm_postInstall
 */
function householdmerge_civicrm_postInstall() {
  _householdmerge_civix_civicrm_postInstall();
}

/**
 * Implements hook_civicrm_entityTypes().
 *
 * @link https://docs.civicrm.org/dev/en/latest/hooks/hook_civicrm_entityTypes
 */
function householdmerge_civicrm_entityTypes(&$entityTypes) {
  _householdmerge_civix_civicrm_entityTypes($entityTypes);
}
