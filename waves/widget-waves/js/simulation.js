$(function(){
	var animframe = -1;
	var updateCursor;
	
	var init = function() {
		var points = 251; //1024;
		var dx = 3;
		var startx = 0;
		var starty = 200;
		var gamma = 0.05; //0.085;
		var smooth = 0.01; //0.02;
		sim_speed = 4;
		var dt = 20;//12; // don't go about changing this value dynamically (at least not too much),
		// screws up the simulation momentarily
		var Csquared = gamma*gamma*dt*dt;
		
		var mousePos = { x: 0, y: 0 };
		var mouseActive = false;
		var lastMousePos = mousePos;
		var lastTime = (new Date()).getTime();
		
		var $canvas = $('#wave');
		var context = $canvas.get(0).getContext('2d');
		context.strokeStyle = 'rgba(255,20,20,1)';
		context.fillStyle = 'rgba(255,20,20,0.5)';
			
		var u = [];
		var speed = [];
		for (var i=0; i<points; i++) {
			//u[i] = Math.sin(i*3/points*2*Math.PI)*150;
			u[i] = 0;
			speed[i] = 0;
		};
		
		var update = function() {
			// new speeds
			for (var i=1; i<points-1; i++) {
				speed[i] += Csquared*(u[i-1] - 2*u[i] + u[i+1]);
				speed[i] -= speed[i]*dt/4000;
				speed[i] = clamp(speed[i], -6, 6);
				u[i-1] += speed[i-1];
			}
			u[points-1] += speed[points-1];
			u[0] = u[points-1] = 0;
			
			// smooth points
			var prevu = u[0];
			for (var i=1; i<points-1; i++) {
				var nextprevu = u[i];
				u[i] = clamp((smooth*dt*prevu + u[i] + smooth*dt*u[i+1])/(1+smooth*dt*2), -1000, 1000);
				prevu = nextprevu;
			}
			
			// open ends
			//u[0] = u[1];
			//u[points-1] = u[points-2];
		};
		
		var sometimes = function() {
			var maxspeed = 0;
			for (var i=1; i<points-1; i++) {
				maxspeed = Math.max(Math.abs(speed[i]), maxspeed);
			}
			
			// if there is no motion anymore, stop animating
			if (maxspeed < 0.0001 && !mouseActive) {
				//window.cancelAnimationFrame(animframe);
				window.clearTimeout(animframe);
			}
			
			for (var i=1; i<points-1; i++) {
				u[i] = clamp(u[i], -1000, 1000);
			}
		};
		
		var render = function(time) {
			//window.cancelAnimationFrame(animframe);
			//animframe = window.requestAnimationFrame(render);
			window.clearTimeout(animframe);
			animframe = window.setTimeout(function(){render((new Date()).getTime())}, 30);
			
			var actual_dt = time-lastTime;
			
			iterations = Math.floor(actual_dt*sim_speed/dt);
			
			if (iterations > 500) {
				iterations = 1;
				lastTime = time;
			}
			if (iterations < 1) {
				iterations = 1;
			}
			
			for (var i=1; i<=iterations; i++) {
				if (mouseActive) {
					var xFrom = Math.round(inter(lastMousePos.x, mousePos.x, (i-1)/iterations));
					var xTo = Math.round(inter(lastMousePos.x, mousePos.x, i/iterations));
					var xIterations = Math.abs(xTo-xFrom)+1;
					
					for (var j=0; j<xIterations; j++) {
						var x;
						if (xFrom > xTo) {
							x = xFrom - j;
						} else {
							x = xFrom + j;
						}
						
						u[x] = inter(lastMousePos.y, mousePos.y, (i + j/xIterations)/iterations);
						speed[x] = 0;
					}
				}
				
				update();
			}
			sometimes();
			
			lastTime += iterations*dt/sim_speed;
			
			context.clearRect(0, 0, $canvas.width(), $canvas.height());
			context.beginPath();
			context.moveTo(startx, starty-u[0]);
			for (var i=1; i<points; i++) {
				context.lineTo(startx + i*dx, starty - u[i]);
			}
			context.stroke();
			
			if (mouseActive) {
				context.beginPath();
				context.arc(startx + mousePos.x*dx, starty - mousePos.y, 20, 0, Math.PI*2); 
				context.fill();
			}
			
			lastMousePos = mousePos;
		};
		
		var move = function(e) {
			e.stop();
			
			// create new mousePos object
			mousePos = {
				x: (e.page.x - $canvas.offset().left - startx)/dx,
				y: starty - (e.page.y - $canvas.offset().top)
			};
			
			if (mousePos.x < 0 || mousePos.x > $canvas.width() || mousePos.y < -$canvas.height()/2 || mousePos.y > $canvas.height()/2) {
				mouseActive = false;
				//updateCursor();
			}
		};
		
		var end = function(e) {
			mouseActive = false;
			//updateCursor();
		}
		
		updateCursor = function() {
			$canvas.css('cursor', mouseActive ? 'crosshair' : 'pointer');
			render((new Date()).getTime());
		};
		
		$canvas.get(0).addEvent("mousedown", function(e) {
			$canvas.get(0).addEvent("mousemove", move);
			mouseActive = !mouseActive;
			move(e);
			lastMousePos = mousePos;
			updateCursor();
			
			$('#wavehelp').hide();
		});
		
		$canvas.get(0).addEvent("touchstart", function(e) {
			$canvas.get(0).removeEvent("mousedown");
			$canvas.get(0).removeEvent("mousemove");
			$canvas.get(0).addEvent("touchmove", move);
			$canvas.get(0).addEvent("touchend", end);
			mouseActive = true;
			move(e);
			lastMousePos = mousePos;
			updateCursor();
			$('#wavehelp').hide();
		});
		
		$('#wavehelp').get(0).addEvent('mousedown', function(e) { $canvas.get(0).fireEvent('mousedown', e); });
		$('#wavehelp').get(0).addEvent('touchstart', function(e) { $canvas.get(0).fireEvent('touchstart', e); });
		$('#wavehelp').get(0).addEvent('touchmove', function(e) { $canvas.get(0).fireEvent('touchmove', e); });
		$('#wavehelp').get(0).addEvent('touchend', function(e) { $canvas.get(0).fireEvent('touchend', e); });
		
		$canvas.mouseleave(function(e) {
			mouseActive = false;
			updateCursor();
		});
		
		var inter = function(a,b,t) {
			return a + (b-a)*t;
		};
		
		var clamp = function(x, low, high) {
			//return Math.min(Math.max(x, low), high);
			return (x < low ? low : (x > high ? high : x));
		};
		
		updateCursor();
	};
	
	init();
});