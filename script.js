// Composé avec amour par HorsContexte

$(document).ready(function(){

	$("#liste").hide();
	$(".page").hide();


	//Fonction des icones "quand l'un est ouvert, les autres sont fermé"
	$("#icone1").click(function(){

		
		 $(".page").hide();
			$("#page1").fadeToggle(1000);

});

	$("#icone2").click(function(){

		
		 $(".page").hide();
			$("#page2").fadeToggle(1000);
});

	$("#icone3").click(function(){

		
		 $(".page").hide();
			$("#page3").fadeToggle(1000);
});
	$("#icone4").click(function(){

		
		 $(".page").hide();
			$("#page4").fadeToggle(1000);

});

	//Fonction "Black Screen"
	 $("#button").click(function(){
    	$("#blackscreen").fadeToggle(1000);

});

	 	
	 	//Fonction "menu démarrer" 	
		$("#1").click(function(){
			$("#liste").toggle(300);
	});
});