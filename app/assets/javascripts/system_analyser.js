function serverSelect() {
  	serverList = document.getElementById("selectServer");
  	var server = serverList.options[serverList.selectedIndex].value;
  	if (server != "dummy") {
  		window.location="/SystemAnalyserHome/" + server;
  	}
}
	
function dateSelect() {
  	dateList = document.getElementById("selectDate");
  	var dateValue = dateList.options[dateList.selectedIndex].value;
  	if (dateValue != "dummy") {
    	if (dateValue == "reset") {
      		window.location="/SystemAnalyserHome";
    	}
    	else {
    		var args=dateValue.split(":");
      		var url="/SystemAnalyserServerMetrics/" + args[0] + "/" + args[1];
      		window.open(url,'_blank');
    	}
  	}
}

function toolSelect() {
  	toolList = document.getElementById("selectTool");
  	var tool = toolList.options[toolList.selectedIndex].value;
  	if (tool == "SystemAnalyserHome") {
  		var url="/SystemAnalyserHome";
  		window.open(url,'_blank');
  	} 
}
