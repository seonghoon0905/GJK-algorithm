event_user(0); // constructor
event_user(1); // GJK & EPA
event_user(2); // other

polygon1 = new polygon(100, 100, 1, 1, 0, [
	new vec3(-50, -50, 0),
	new vec3(50, -50, 0),
	new vec3(50, 50, 0),
	new vec3(-50, 50, 0)
]);

polygon2 = new polygon(room_width / 2, room_height / 2, 1, 1, 0, [
	new vec3(-100, 0, 0),
	new vec3(-50, -100, 0),
	new vec3(50, -100, 0),
	new vec3(100, 0, 0),
	new vec3(50, 100, 0),
	new vec3(-50, 100, 0)
]);

circle1 = new circle(room_width - 100, room_height - 100, 50);
eclipse1 = new eclipse(100, room_height - 100, 50, 25);

unit = noone;
simplex = [];

//event_function
function step(){
	handle_polygon_move();
	epa(polygon1, polygon2);
	epa(polygon1, circle1);
	epa(polygon1, eclipse1);
}

function draw(){
	draw_polygon(polygon1, c_silver);
	draw_polygon(polygon2, c_teal);
	draw_circle_color(circle1.center_x, circle1.center_y, circle1.r, c_fuchsia, c_fuchsia, true);
	draw_ellipse_ext(eclipse1, c_orange);
	draw_info();
}