<cfcomponent>
	<cfscript>
	items = ArrayNew(1);
		
	itemObj = StructNew();
	itemObj['name'] = "Mega Sheilds";
	itemObj['number'] ="123";
	itemObj['qty'] = "1";	
	itemObj['taxamt'] = "0";
	itemObj['amt'] = "1.00";
	itemObj['desc'] = "Unlock the power!";
	itemObj['category'] = "Digital";
	temp = ArrayAppend(items,itemObj);
	
	itemObj = StructNew();
	itemObj['name'] = "Laser Cannon";
	itemObj['number'] ="456";
	itemObj['qty'] = "1";	
	itemObj['taxamt'] = "0";
	itemObj['amt'] = "1.25";
	itemObj['desc'] = "Lock and load!";
	itemObj['category'] = "Digital";
	temp = ArrayAppend(items,itemObj);
		
	</cfscript>
        
	<cfset  webtoken = '999999'>
	<cffunction name="connect" access="remote" returntype="any" returnFormat="JSON">
		
		<cfset var result="">
        
        <cfscript>
		var webObj = StructNew();
		webObj['success'] = true;
		webObj['webtoken'] = webtoken;
		webObj['state'] = 'init';
		</cfscript>
		<cfset result = serializeJSON(webObj)>	

		<cfreturn result>
	</cffunction>
    
    <cffunction name="createButton" access="remote" returntype="any" returnFormat="JSON">
		<cfargument name="webToken" type="string" required="no">
        <cfargument name="itemId" type="string" required="no">
        
       
		<cfset returnObj = ''>
   		<cfloop from="1" to="#ArrayLen(items)#" index="i">
			<cfif items[i].number eq "456">
                <cfset returnObj = items[i]>
                <cfset returnObj['buttonId'] = createUUID()>
                <cfbreak>
            </cfif>
        </cfloop>
      
        <cfscript>
		/*
		var result = "";
		

		
		if(webToken eq arguments.webToken) 
		{
			var webObj = StructNew();
			webObj['success'] = true;
			webObj['webtoken'] = webtoken;
			webObj['buttonId'] = 'button_' & createUUID();	
			webObj['state'] = 'createButton';	
		} else {
			var webObj = StructNew();
			webObj['success'] = true;
			webObj['webtoken'] = '7777777';
			webObj['buttonId'] = 'button_' & createUUID();	
			webObj['state'] = 'createButton';		
		}
		*/
		
	
		</cfscript>
		<cfset result = serializeJSON(returnObj)>	

		<cfreturn result>
	</cffunction>
    
    
     <cffunction name="setExpressCheckout" access="remote" returntype="any" returnFormat="JSON">
		<cfargument name="webToken" type="string" required="no">
        <cfargument name="itemNumber" type="string" required="no">
		
		<cfset var result = "">
        
        <cfscript>
			try {	
				// create our objects to call methods on
				caller = createObject("CallerService");
				ec = createObject("ExpressCheckout");
				
				StructClear(Session);
				
				data = StructNew();
				data.METHOD = "SetExpressCheckout";
				
				data.PAYMENTREQUEST_0_CURRENCYCODE="USD";
      			data.PAYMENTREQUEST_0_AMT="2.00";
   				data.PAYMENTREQUEST_0_ITEMAMT="2.00";
   				data.PAYMENTREQUEST_0_TAXAMT="0";
   				
				data.PAYMENTREQUEST_0_DESC="Movies";
   				data.PAYMENTREQUEST_0_PAYMENTACTION="Sale";
   				data.L_PAYMENTREQUEST_0_ITEMCATEGORY0="Digital";
   				data.L_PAYMENTREQUEST_0_NAME0="Mega Sheilds";
   				data.L_PAYMENTREQUEST_0_NUMBER0="1234";
   				data.L_PAYMENTREQUEST_0_QTY0="2";
   				data.L_PAYMENTREQUEST_0_TAXAMT0="0";
   				data.L_PAYMENTREQUEST_0_AMT0="1.00";
   				data.L_PAYMENTREQUEST_0_DESC0="Download";
				
			
				FORM.L_NAME0 = "boo";
				FORM.L_AMT0 = "1.00";
				FORM.L_QTY0="2";
				FORM.currencyCodeType = "USD";
			
				FORM.ITEMCNT = "1";
				data.SHIPPINGAMT = "0";
				data.SHIPDISCAMT = "0";
				data.TAXAMT = "0";
				data.INSURANCEAMT = "0";
				form.paymentAction = "sale";
				form.paymentType="sale";
				
				
				// set url info
				data.serverName = SERVER_NAME;
				data.serverPort = CGI.SERVER_PORT;
				data.contextPath = GetDirectoryFromPath(#SCRIPT_NAME#);
				data.protocol = CGI.SERVER_PROTOCOL;
				data.cancelPage = "cancel.cfm";
				data.returnPage = "success.cfm";
				
				requestData = ec.setExpressCheckoutData(form,request,data);
				
				response = caller.doHttppost(requestData);
				
				responseStruct = caller.getNVPResponse(#URLDecode(response)#);
				session.resStruct = responseStruct;
			
				if (responseStruct.Ack is not "Success")
				{
					Throw(type="InvalidData",message="Response:#responseStruct.Ack#, ErrorCode: #responseStruct.L_ERRORCODE0#, Message: #responseStruct.L_LONGMESSAGE0#"); 	
				
				} else {
					token = responseStruct.token;
				}
				
				/*	cfhttp.FileContent returns token and other response value from the server.
				We need to pass token as parameter to destination URL which redirect to return URL
				*/
				redirecturl = request.PayPalURL & token;
				//location(redirecturl,false);
				
				var webObj = StructNew();
				webObj['success'] = true;
				webObj['webtoken'] = webtoken;
				webObj['redirecturl'] = redirecturl;	
				webObj['state'] = 'setExpressCheckout';
				
			}
			
			catch(any e) 
			{
				var webObj = StructNew();
				webObj['success'] = true;
				webObj['error'] = e.message;
				webObj['webtoken'] = webtoken;
				webObj['state'] = 'setExpressCheckout';
			}
		
			
		</cfscript>

		
		<cfset result = serializeJSON(webObj)>	

		<cfreturn result>
	</cffunction>
    
</cfcomponent>