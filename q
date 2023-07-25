[1mdiff --git a/lang/en/block_link_logins.php b/lang/en/block_link_logins.php[m
[1mindex ce4a7ec..6c4fa91 100644[m
[1m--- a/lang/en/block_link_logins.php[m
[1m+++ b/lang/en/block_link_logins.php[m
[36m@@ -28,6 +28,9 @@[m [m$string['homedomain'] = 'Home Domain';[m
 $string['homedomain_desc'] = 'Your OAuth2 home domain. These emails will not be converted to #ext# usernames.';[m
 $string['extdomain'] = 'External Domain';[m
 $string['extdomain_desc'] = 'Your OAuth2 external domain used by your authentication source.';[m
[32m+[m[32m$string['issuerid'] = 'Issuer ID';[m
[32m+[m[32m$string['issuerid_desc'] = 'Pick the Oauth 2 issuer you are using for default logins.';[m
[32m+[m[32m$string['link'] = 'Link';[m
 $string['link'] = 'Link';[m
 $string['link_logins'] = 'Link Logins';[m
 $string['link_logins:addinstance'] = 'Add a new Link Logins block';[m
[1mdiff --git a/locallib.php b/locallib.php[m
[1mindex d038a53..a253686 100644[m
[1m--- a/locallib.php[m
[1m+++ b/locallib.php[m
[36m@@ -101,7 +101,10 @@[m [mclass link {[m
     }[m
 [m
     public static function handle_creating_link($prospectiveemail, $prospectiveusername, $existinguserid) {[m
[31m-        global $DB, $USER;[m
[32m+[m[32m        global $CFG, $DB, $USER;[m
[32m+[m
[32m+[m[32m        // Get the issuerid or set it to 1 as a default.[m
[32m+[m[32m        $issuerid = isset($CFG->block_link_logins_issuerid) ? $CFG->block_link_logins_issuerid : 1;[m
 [m
         // Set the table.[m
         $table = 'auth_oauth2_linked_login';[m
[36m@@ -112,8 +115,7 @@[m [mclass link {[m
         $dataobject->timemodified = time();[m
         $dataobject->usermodified = $USER->id;[m
         $dataobject->userid = $existinguserid;[m
[31m-        // TODO: deal with this.[m
[31m-        $dataobject->issuerid = 2;[m
[32m+[m[32m        $dataobject->issuerid = $issuerid;[m
         $dataobject->username = $prospectiveusername;[m
         $dataobject->email = $prospectiveemail;[m
         $dataobject->confirmtoken = '';[m
[1mdiff --git a/settings.php b/settings.php[m
[1mindex 8a9ea5c..d3a3e06 100755[m
[1m--- a/settings.php[m
[1m+++ b/settings.php[m
[36m@@ -24,6 +24,18 @@[m
 [m
 global $CFG, $DB;[m
 [m
[32m+[m[32m// Get the list of issuers for later.[m
[32m+[m[32m$datas = $DB->get_records('oauth2_issuer', array('enabled' => 1, 'showonloginpage' => 1), $sort='', 'id, name');[m
[32m+[m
[32m+[m[32m// Set up the empty array.[m
[32m+[m[32m$issuers = array();[m
[32m+[m
[32m+[m[32m// Loop through the data and build the key / value pair.[m
[32m+[m[32mforeach ($datas as $data) {[m
[32m+[m[32m    // Set the key / value pair here.[m
[32m+[m[32m    $issuers[$data->id] = $data->name;[m
[32m+[m[32m}[m
[32m+[m
 // Set up the allowed users.[m
 $settings->add([m
     new admin_setting_configtext([m
[36m@@ -53,3 +65,14 @@[m [m$settings->add([m
         'admin'[m
     )[m
 );[m
[32m+[m
[32m+[m[32m// Set the issuerid.[m
[32m+[m[32m$settings->add([m
[32m+[m[32m    new admin_setting_configselect([m
[32m+[m[32m        'block_link_logins_issuerid',[m
[32m+[m[32m        get_string('issuerid', 'block_link_logins'),[m
[32m+[m[32m        get_string('issuerid_desc', 'block_link_logins'),[m
[32m+[m[32m        1,[m
[32m+[m[32m        $issuers[m
[32m+[m[32m    )[m
[32m+[m[32m);[m
