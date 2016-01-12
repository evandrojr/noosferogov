$( document ).ready(function() {
	//move a busca para o primeiro block 'block-outer'
   $('.action-home-index #user #top-search').appendTo('.box-1 .blocks .block-outer:nth-child(1) .box');
   //troca para português o termo de busca
   $('.action-home-index #top-search input').attr( 'title', 'BUSCAR NO PORTAL' ); 
   $('.action-home-index #top-search input').attr( 'value', 'BUSCAR NO PORTAL' ); 
});