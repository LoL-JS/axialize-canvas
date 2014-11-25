axialize-canvas
===============

Axialize is a collaborative cashflow software focused on cash balance, for a precise budget forecast.
More information here : <a href="http://www.axialize.com">.
Axialize for Salesforce allows you to use this software with <strong>Opportunity</strong> object.

<h1>Install Axialize</h1>

Axialize for Salesforce runs in a Heroku environment. To deploy it, click on the below button :

<a href="https://heroku.com/deploy?template=https://github.com/Sylpheo/axialize-canvas">
  <img src="https://www.herokucdn.com/deploy/button.png" alt="Deploy">
</a>

In this document, we consider that the deployed application is called <strong>axialize-for-sf</strong>.

After this, the deployed application needs to be linked to your Salesforce organization via a <strong>Canvas</strong> application.
Please follow these steps to have Axialize correctly installed and set up :

<li>
	<ol>Create a <strong>connected application</strong> called Axialize.
		<ul>Check <strong>Enable OAuth Settings</strong>
			<ul>Fill <strong>Callback URL</strong> with https://axialize-for-sf.herokuapp.com/oauth_callback</ul>
			<ul>In <strong>Selected OAuth Scopes</strong>, select <strong>api</strong>, it should be enough</ul>
		</ul>
		<ul>Check <strong>Force.com Canvas</strong>
			<ul>Fill <strong>Canvas App URL</strong> with https://axialize-for-sf.herokuapp.com</ul>
			<ul>In <strong>Locations</strong>, select <strong>Visualforce Page</strong></ul>
		</ul>
		<ul>When done, click on <strong>Manage</strong> and select <strong>Admin approved users are pre-authorized</strong> in <strong>Permitted users</strong>.
		<ul>Retrieve the <strong>Consumer Secret</strong> and put it in your heroku app config variables (Settings on project) with the following key : <code>CANVAS_CONSUMER_SECRET</code>
	</ol>
    <ol>Create a <strong>Visualforce page</strong> and fill it with the following code :
    	<code 
    		<apex:page sidebar="false">
    			<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    			<style>
        			html, body { height: 100%; }
        			#map-canvas { height: min-height: 100%; }
    			</style>
	  			<apex:canvasApp applicationName="Axialize" id="canvas" width="100%" height="100%" onCanvasAppLoad="resize"/>
	  			<script>
	      			$(document).ready(function() {
	          			$(window).on('resize', function() {
	              			resize();
	          			});
	      			});
	      			function resize() {
	          			var offset = 220;
	          			if(typeof sforce != 'undefined' && sforce != null) {
	              			offset = 0;
	          			}
	          			$('[id="{!$Component.canvas}"] iframe').css('height', window.innerHeight - offset);
	      			}
				</script>
			</apex:page>
		/>
    </ol>
    <ol>Create a <strong>Visualforce tab</strong> and link it to the page we have just created.
	</ol>
	<ol>Don't forget to add access in your profile
		<ul>Add Axialize in <strong>Connected App Access</strong></ul>
	</ol>	
</li>

<h1>Adapt Axialize to your needs</h1>
Axialize for Salesforce is based on the Opportunity object. The code provided works with the following stages :
<li>
	<ol><strong>New</strong> (10%)</ol>
	<ol><strong>Analysis</strong> (20%)</ol>
	<ol><strong>Quote sent</strong> (30%)</ol>
	<ol><strong>Negociation</strong> (40%)</ol>
	<ol><strong>Verbal agreement</strong> (50%)</ol>
	<ol><strong>Closed won</strong> (100%)</ol>
</li>

In this example, steps must be in this order to work fine. <strong>New</strong> and <strong>Analysis</strong> steps are very first steps. Opportunities with one of these status are not counted in balance calculation. Other opportunities are counted. The <strong>Closed won</strong> step defines that an opportunity is really closed.

If you have another process, you must follow these steps :
<li>
	<ul>Define your process : what is the meaning of each step</ul>
	<ul>In the file <code>app/assets/javascripts/models/transaction.coffee</code> :
		<ul>Define what are the late steps (before 100%)</ul>
		<ul>Define what are the waiting steps (the steps which are not counted in balance calculation)</ul>
		<ul>Repeat each step in each status to define display functionalities<ul>
	</ul>
	<ul>In the file <code>app/assets/javascripts/templates/transaction-row.hbs</code> :
		<ul>Repeat each step name</ul>
	</ul>
	<ul>In the file <code>app/assets/javascripts/controllers/transactions-controller.coffee</code> :
		<ul>Repeat each step name which are counted in balance calculation</ul>
	</ul>
	<ul>In the file <code>app/assets/javascripts/components/transaction-box-component.coffee</code> :
		<ul>Repeat closed step name</ul>
	</ul>
	<ul>In the file <code>app/assets/javascripts/views/transaction-cell.coffee</code> :
		<ul>Repeat closed step name</ul>
	</ul>
</li>
