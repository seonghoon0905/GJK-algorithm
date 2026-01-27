/// @description other library

function handle_polygon_move(){
	var _r = keyboard_check(vk_right);
	var _l = keyboard_check(vk_left);
	var _u = keyboard_check(vk_up);
	var _d = keyboard_check(vk_down);
	var _spd = 4;
	var _pu = keyboard_check(vk_pageup);
	var _pd = keyboard_check(vk_pagedown);
	
	polygon1.center_x += (_r - _l) * _spd;
	polygon1.center_y += (_d - _u) * _spd;
	polygon1.dir += _pd - _pu;
	polygon1.update_points();
}

function draw_polygon(_polygon, _col){
	draw_set_color(_col);
	for(var _i = 0; _i < array_length(_polygon.points); _i++){
		var _ni = (_i + 1) % array_length(_polygon.points);
		draw_line(_polygon.points[_i].x, _polygon.points[_i].y, _polygon.points[_ni].x, _polygon.points[_ni].y);
	}
}

function draw_ellipse_ext(_eclipse, _col){
	var _x1 = _eclipse.center_x - _eclipse.major_axis;
	var _x2 = _eclipse.center_x + _eclipse.major_axis;
	var _y1 = _eclipse.center_y + _eclipse.minor_axis;
	var _y2 = _eclipse.center_y - _eclipse.minor_axis;
	draw_set_color(_col);
	draw_ellipse(_x1, _y1, _x2, _y2, true);
}

function draw_info(){
	draw_set_color(c_white);
	draw_set_font(fnt_serif);
	draw_set_halign(fa_right);
	draw_set_valign(fa_top);
	draw_text(768, 32, 
	string("Arrow Keys to move"
	+ "\nPageUp / Down to adjust direction"));
}
