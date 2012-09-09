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
<title>[<% ident(); %>] Admin: JFFS</title>
<% include("common-header.html"); %>

<% css(); %>
<script type='text/javascript' src='tomato.js'></script>

<!-- / / / -->

<script type='text/javascript' src='debug.js'></script>

<script type='text/javascript'>

//	<% nvram("jffs2_on,jffs2_exec,t_fix1"); %>

fmtwait = (nvram.t_fix1 == 'RT-N16' ? 120 : 60);

function verifyFields(focused, quiet)
{
	var b = !E('_f_jffs2_on').checked;
	E('format').disabled = b;
	E('_jffs2_exec').disabled = b;
	return 1;
}

function formatClicked()
{
	if (!verifyFields(null, 0)) return;
	if (!confirm("Format the JFFS partition?")) return;
	save(1);
}

function formatClock()
{
	if (ftime == 0) {
		E('fclock').innerHTML = 'a few more seconds';
	}
	else {
		E('fclock').innerHTML = ((ftime > 0) ? 'about ' : '') + ftime + ' second' + ((ftime == 1) ? '' : 's');
	}
	if (--ftime >= 0) setTimeout(formatClock, 1000);
}

function save(format)
{
	if (!verifyFields(null, 0)) return;

	E('format').disabled = 1;
	if (format) E('fmsg').style.visibility = 'visible';

	var fom = E('_fom');
	var on = E('_f_jffs2_on').checked ? 1 : 0;
	fom.jffs2_on.value = on;
	if (format) {
		fom.jffs2_format.value = 1;
		fom._commit.value = 0;
		fom._nextwait.value = fmtwait;
	}
	else {
		fom.jffs2_format.value = 0;
		fom._commit.value = 1;
		fom._nextwait.value = on ? 15 : 3;
	}
	form.submit(fom, 1);

	if (format) {
		ftime = fmtwait;
		formatClock();
	}
}

function submit_complete()
{
	reloadPage();
}
</script>

</head>
<body>
    
<% include(header.html); %>

<!-- / / / -->
<form id='_fom' method='post' action='tomato.cgi'>
<input type='hidden' name='_nextpage' value='admin-jffs2.asp'>
<input type='hidden' name='_nextwait' value='10'>
<input type='hidden' name='_service' value='jffs2-restart'>
<input type='hidden' name='_commit' value='1'>

<input type='hidden' name='jffs2_on'>
<input type='hidden' name='jffs2_format' value='0'>

<h3>JFFS</h3>
<div class='section'>
<script type='text/javascript'>
// <% statfs("/jffs", "jffs2"); %>

jfon = (nvram.jffs2_on == 1);
createFieldTable('', [
	{ title: 'Enable', name: 'f_jffs2_on', type: 'checkbox', value: jfon },
	{ title: 'Execute When Mounted', name: 'jffs2_exec', type: 'text', maxlen: 64, size: 34, value: nvram.jffs2_exec },
	null,
	{ title: 'Total / Free Size', text: (((jffs2.mnt) || (jffs2.size > 0)) ? scaleSize(jffs2.size) : '') + ((jffs2.mnt) ? ' / ' + scaleSize(jffs2.free) : ' (not mounted)') },
	null,
	{ title: '', custom: '<input type="button" value="Format / Erase..." onclick="formatClicked()" id="format" class="btn">' +
		'<span style="background:#b55;color:#fff;padding:1px 8px;visibility:hidden" id="fmsg">Please wait for <span id="fclock">about 60 seconds</span>...</span>' }
]);
</script>
</div>

<script type='text/javascript'>show_notice1('<% notice("jffs"); %>');</script>

<span id='footer-msg'></span>
	<input type='button' value='Save' id='save-button' onclick='save()' class='btn'>
	<input type='button' value='Cancel' id='cancel-button' onclick='javascript:reloadPage();' class='btn'>

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