$(document).ready(function() {
	player_hits();
	player_stays();
	dealer_hits();
	hidden_card();
});


function player_hits() {
	$(document).on('click', 'form#hit_form input', function() {	
		$.ajax({
			type: 'POST',
			url: '/game/player/hit'	
		}).done(function(msg) {
			$('#game').replaceWith(msg);
		});
		
		return false;
 	});
	
}

function player_stays() {
	$(document).on('click', 'form#stay_form input', function() {	
		$.ajax({
			type: 'POST',
			url: '/game/player/stay'	
		}).done(function(msg) {
			$('#game').replaceWith(msg);
		 });
		
		return false;
 	});
	
}

function dealer_hits() {
	$(document).on('click', 'form#resize_deal input', function() {	
		$.ajax({
			type: 'POST',
			url: '/game/dealer/hit'	
		}).done(function(msg) {
			$('#show_cards').replaceWith(msg);
		 });
		
		return false;
 	});
	
}

function hidden_card() {
	$(document).on('click', 'form#hidden_card input', function() {		
		$.ajax({
			type: 'POST',
			url: '/game/player/stay'	
		}).done(function(msg) {
			$('#game').replaceWith(msg);
		 });
		
		return false;
 	});
	
}






