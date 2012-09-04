<!DOCTYPE html>
<!--
	Tomato GUI
	Copyright (C) 2006-2010 Jonathan Zarate
	http://www.polarcloud.com/tomato/

	For use with Tomato Firmware only.
	No part of this file may be used without permission.
-->
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv='content-type' content='text/html;charset=utf-8'>
<meta name='robots' content='noindex,nofollow'>
<title>[<% ident(); %>] Admin: CIFS Client</title>
<link href="bootstrap.min.css" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 60px;
        padding-bottom: 40px;
      }
      .sidebar-nav {
        padding: 9px 0;
      }
    </style>
    <link href="bootstrap-responsive.min.css" rel="stylesheet">

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

<% css(); %>
<script type='text/javascript' src='tomato.js'></script>

<!-- / / / -->

<script type='text/javascript' src='debug.js'></script>

<script type='text/javascript'>

//	<% nvram("cifs1,cifs2"); %>

function verifyFields(focused, quiet)
{
	var i, p, b;
	var unc, user, pass, dom, exec, servern, sec;

	for (i = 1; i <= 2; ++i) {
		p = '_f_cifs' + i;
		unc = E(p + '_unc');
		user = E(p + '_user');
		pass = E(p + '_pass');
		dom = E(p + '_dom');
		exec = E(p + '_exec');
		servern = E(p + '_servern');
		sec = E(p + '_sec');

		b = !E(p + '_enable').checked;
		unc.disabled = b;
		user.disabled = b;
		pass.disabled = b;
		exec.disabled = b;
		dom.disabled = b;
		servern.disabled = b;
		sec.disabled = b;
		if (!b) {
			if ((!v_nodelim(unc, quiet, 'UNC')) || (!v_nodelim(user, quiet, 'username')) || (!v_nodelim(pass, quiet, 'password')) ||
				 (!v_nodelim(servern, quiet, 'Netbios name')) ||
				 (!v_nodelim(dom, quiet, 'domain')) || (!v_nodelim(exec, quiet, 'exec path'))) return 0;
			if ((!v_length(user, quiet, 1)) || (!v_length(pass, quiet, 1))) return 0;
			unc.value = unc.value.replace(/\//g, '\\');
			if (!unc.value.match(/^\\\\.+\\/)) {
				ferror.set(unc, 'Invalid UNC', quiet);
				return 0;
			}
		}
		else {
			ferror.clear(unc, user, pass, dom, exec, servern, sec);
		}
	}

	return 1;
}

function save()
{
	var i, p;

	if (!verifyFields(null, 0)) return;

	for (i = 1; i <= 2; ++i) {
		p = '_f_cifs' + i;
		E('cifs' + i).value = (E(p + '_enable').checked ? '1' : '0') + '<' + E(p + '_unc').value + '<' +
			E(p + '_user').value + '<' + E(p + '_pass').value + '<' + E(p + '_dom').value + '<' + E(p + '_exec').value
			+ '<' + E(p + '_servern').value + '<' + E(p + '_sec').value;
	}
	form.submit('_fom', 0);
}
</script>

</head>
<body>
    
<% include(header.html); %>

<!-- / / / -->
<form id='_fom' method='post' action='tomato.cgi'>
<input type='hidden' name='_nextpage' value='admin-cifs.asp'>
<input type='hidden' name='_nextwait' value='10'>
<input type='hidden' name='_service' value='cifs-restart'>

<input type='hidden' name='cifs1' id='cifs1'>
<input type='hidden' name='cifs2' id='cifs2'>

<h3>CIFS Client</h3>
<div class='section'>
<script type='text/javascript'>
a = b = [0, '\\\\192.168.1.5\\shared_example', '', '', '', '', '', ''];

if (r = nvram.cifs1.match(/^(0|1)<(\\\\.+)<(.*)<(.*)<(.*)<(.*)<(.*)<(.*)$/)) a = r.splice(1, 8);
if (r = nvram.cifs2.match(/^(0|1)<(\\\\.+)<(.*)<(.*)<(.*)<(.*)<(.*)<(.*)$/)) b = r.splice(1, 8);

//	<% statfs("/cifs1", "cifs1"); %>
//	<% statfs("/cifs2", "cifs2"); %>

createFieldTable('', [
	{ title: '/cifs1' },
	{ title: 'Enable', indent: 2, name: 'f_cifs1_enable', type: 'checkbox', value: a[0]*1 },
	{ title: 'UNC', indent: 2, name: 'f_cifs1_unc', type: 'text', maxlen: 128, size: 64, value: a[1] },
	{ title: 'Netbios Name', indent: 2, name: 'f_cifs1_servern', type: 'text', maxlen: 128, size: 64, value: a[6] },
	{ title: 'Username', indent: 2, name: 'f_cifs1_user', type: 'text', maxlen: 32, size: 34, value: a[2] },
	{ title: 'Password', indent: 2, name: 'f_cifs1_pass', type: 'password', maxlen: 32, size: 34, peekaboo: 1, value: a[3] },
	{ title: 'Domain', indent: 2, name: 'f_cifs1_dom', type: 'text', maxlen: 32, size: 34, value: a[4] },
	{ title: 'Execute When Mounted', indent: 2, name: 'f_cifs1_exec', type: 'text', maxlen: 64, size: 34, value: a[5] },
	{ title: 'Security', indent: 2, name: 'f_cifs1_sec', type: 'select',
		options: [['','Default (NTLM)'],['ntlmi','NTLM and packet signing'],['ntlmv2','NTLMv2'],['ntlmv2i','NTLMv2 and packet signing'],['nontlm','No NTLM'],['lanman','LANMAN'],['none','None']],
		value: a[7] },
	{ title: 'Total / Free Size', indent: 2, text: cifs1.size ? (scaleSize(cifs1.size) + ' / ' + scaleSize(cifs1.free)) : '(not mounted)' },
	null,
	{ title: '/cifs2' },
	{ title: 'Enable', indent: 2, name: 'f_cifs2_enable', type: 'checkbox', value: b[0]*1 },
	{ title: 'UNC', indent: 2, name: 'f_cifs2_unc', type: 'text', maxlen: 128, size: 64, value: b[1] },
	{ title: 'Netbios Name', indent: 2, name: 'f_cifs2_servern', type: 'text', maxlen: 128, size: 64, value: b[6] },
	{ title: 'Username', indent: 2, name: 'f_cifs2_user', type: 'text', maxlen: 32, size: 34, value: b[2] },
	{ title: 'Password', indent: 2, name: 'f_cifs2_pass', type: 'password', maxlen: 32, size: 34, peekaboo: 1, value: b[3] },
	{ title: 'Domain', indent: 2, name: 'f_cifs2_dom', type: 'text', maxlen: 32, size: 34, value: b[4] },
	{ title: 'Execute When Mounted', indent: 2, name: 'f_cifs2_exec', type: 'text', maxlen: 64, size: 34, value: b[5] },
	{ title: 'Security', indent: 2, name: 'f_cifs2_sec', type: 'select',
		options: [['','Default (NTLM)'],['ntlmi','NTLM and packet signing'],['ntlmv2','NTLMv2'],['ntlmv2i','NTLMv2 and packet signing'],['nontlm','No NTLM'],['lanman','LANMAN'],['none','None']],
		value: b[7] },
	{ title: 'Total / Free Size', indent: 2, text: cifs2.size ? (scaleSize(cifs2.size) + ' / ' + scaleSize(cifs2.free)) : '(not mounted)' }
]);
</script>
</div>

<script type='text/javascript'>show_notice1('<% notice("cifs"); %>');</script>

<span id='footer-msg'></span>
	<input type='button' value='Save' id='save-button' onclick='save()'>
	<input type='button' value='Cancel' id='cancel-button' onclick='javascript:reloadPage();'>
<!-- / / / -->

<div id='footer'></div>
		</div><!--/row-->
        </div><!--/span-->
      </div><!--/row-->
      <hr>
      <footer>
        <p>&copy; Tomato 2012</p>
      </footer>
    </div><!--/.fluid-container-->
    <script type='text/javascript'>verifyFields(null, 1);</script>
</body>
</html>