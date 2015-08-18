// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var app = angular.module("App", []);

app.filter('capitalize', function() {
	return function(input, all) {
		return (!!input) ? input.replace(/([^\W_]+[^\s-]*) */g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();}) : '';
	}
});

app.directive("select", function(){
	return {
		scope: {
		"client": "=",
		"show": "="
		},
		link: function(scope,el,attr){
			el.on("click", function(){
				scope.client = el.text().trim();
				scope.show = true;
				scope.$apply();
			});
		}
	};
});

app.controller("DocCtrl", function(){
	var doc = this;
	doc.showUpload = false;
	doc.setShowUpload = function(){
		doc.showUpload = !doc.showUpload;
	}
});

app.controller("GetDocsCtrl", function($http){
	var docs = this;
	var parts = window.location.href.split("/");
	docs.client = parts[parts.length - 1].toLowerCase();

	docs.get = function(client){
		$http.get("/api/documents/"+client).success(function(resp){
			if(resp.status == 200)
				docs.all = resp.docs;
		});
	}

	docs.get(docs.client);

});





