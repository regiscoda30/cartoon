$(document).ready(function(){
  $(document).on("click", ".icone", function(event){
    $(this).siblings().show()
    $(this).parent().siblings().each(function(index,element){
       $(element).find(".page:visible").hide();
    });
  });
});

$(document).ready(function(){
  $('#button').onclick(){
    $(this).("#blackscreen").fadeToggle(1);
  });
});

