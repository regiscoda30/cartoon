// Composé avec amour par HorsContexte

$(document).ready(function(){

	$("#liste").hide();


	//Fonction des icones "quand l'un est ouvert, les autres sont fermé"
	$("#icone1").click(function(){

		
		 $(".page").hide();
			$("#page1").toggle(2500);

});

	$("#icone2").click(function(){

		
		 $(".page").hide();
			$("#page2").toggle(2500);
});

	$("#icone3").click(function(){

		
		 $(".page").hide();
			$("#page3").toggle(2500);
});
	$("#icone4").click(function(){

		
		 $(".page").hide();
			$("#page4").toggle(2500);

});

	//Fonction "Black Screen"
	 $("#button").click(function(){
    	$("#blackscreen").fadeToggle(500);

});

	 	
	 	//Fonction "menu démarré" 	
		$("#1").click(function(){
			$("#liste").toggle(100);
	});
});