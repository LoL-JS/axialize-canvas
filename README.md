axialize-canvas
===============

Axialize is a collaborative cashflow software focused on cash balance, for a precise budget forecast.
More information here : <a href="http://www.axialize.com">.
Axialize for Salesforce allows you to use this software with <strong>Opportunity</strong> object.

Install Axialize
----------------

Axialize for Salesforce runs in a Heroku environment. To deploy it, click on the below button :

<a href="https://heroku.com/deploy?template=https://github.com/Sylpheo/axialize-canvas">
  <img src="https://www.herokucdn.com/deploy/button.png" alt="Deploy">
</a>

In this document, we consider that the deployed application is called <strong>axialize-for-sf</strong>.

After this, the deployed application needs to be linked to your Salesforce organization via a <strong>Canvas</strong> application.
Please follow these steps to have Axialize correctly installed and set up :

1. Create a <strong>connected application</strong> called Axialize.

* Check <strong>Enable OAuth Settings</strong>
* Fill <strong>Callback URL</strong> with https://axialize-for-sf.herokuapp.com/oauth_callback
* In <strong>Selected OAuth Scopes</strong>, select <strong>api</strong>, it should be enough
* Check <strong>Force.com Canvas</strong>
	* Fill <strong>Canvas App URL</strong> with https://axialize-for-sf.herokuapp.com
	* In <strong>Locations</strong>, select <strong>Visualforce Page</strong>
* When done, click on <strong>Manage</strong> and select <strong>Admin approved users are pre-authorized</strong> in <strong>Permitted users</strong>.
* Retrieve the <strong>Consumer Secret</strong> and put it in your heroku app config variables (Settings on project) with the following key : <code>CANVAS_CONSUMER_SECRET</code>

2. Create a <strong>Visualforce page</strong> and fill it with the following code :
 
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
		
3. Create a <strong>Visualforce tab</strong> and link it to the page we have just created.
	
4. Don't forget to add access in your profile
		* Add Axialize in <strong>Connected App Access</strong>

Adapt Axialize to your needs
----------------------------

Axialize for Salesforce is based on the Opportunity object. The code provided works with the following stages :
*<strong>New</strong> (10%)
*<strong>Analysis</strong> (20%)
*<strong>Quote sent</strong> (30%)
*<strong>Negociation</strong> (40%)
*<strong>Verbal agreement</strong> (50%)
*<strong>Closed won</strong> (100%)


In this example, steps must be in this order to work fine. <strong>New</strong> and <strong>Analysis</strong> steps are very first steps. Opportunities with one of these status are not counted in balance calculation. Other opportunities are counted. The <strong>Closed won</strong> step defines that an opportunity is really closed.

If you have another process, you must follow these steps :
	* Define your process : what is the meaning of each step
	* In the file `app/assets/javascripts/models/transaction.coffee`:
		* Define what are the late steps (before 100%)
		* Define what are the waiting steps (the steps which are not counted in balance calculation)
		* Repeat each step in each status to define display functionalities
	* In the file `app/assets/javascripts/templates/transaction-row.hbs` :
		* Repeat each step name
	* In the file `app/assets/javascripts/controllers/transactions-controller.coffee` :
		* Repeat each step name which are counted in balance calculation
	* In the file `app/assets/javascripts/components/transaction-box-component.coffee` :
		* Repeat closed step name
	* In the file `app/assets/javascripts/views/transaction-cell.coffee` :
		* Repeat closed step name
