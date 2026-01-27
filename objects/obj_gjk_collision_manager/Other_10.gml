/// @description constructor library
function vec3(_x, _y, _z) constructor{
	x = _x;
	y = _y;
	z = _z;
	add = function(_v){
		x += _v.x;
		y += _v.y;
		z += _v.z;	
	}
	sub = function(_v){
		x -= _v.x;
		y -= _v.y;
		z -= _v.z;
	}
	dot = function(_v){
		return x * _v.x + y *_v.y + z * _v.z;	
	}
	cross = function(_v){
		return new other.vec3(y * _v.z - z * _v.y, z * _v.x - x * _v.z, x * _v.y - y * _v.x);
	}
	get_direction = function(){
		return point_direction(0, 0, x, y);
	}
	normalize = function(){
		var _x = lengthdir_x(1, get_direction());
		var _y = lengthdir_y(1, get_direction());
		x = _x;
		y = _y;
	}
}

function circle(_center_x, _center_y, _r) constructor{
	center_x = _center_x;
	center_y = _center_y;
	r = _r;
	support_point = noone;
	update_support_point = function(_dir){
		support_point = new other.vec3(center_x + lengthdir_x(r, _dir), center_y + lengthdir_y(r, _dir), 0);
	}
}

function eclipse(_center_x, _center_y, _major_axis, _minor_axis) constructor{
	center_x = _center_x;
	center_y = _center_y;
	major_axis = _major_axis;
	minor_axis = _minor_axis;
	support_point = noone;
	update_support_point = function(_dir){
		support_point = new other.vec3(center_x + lengthdir_x(major_axis, _dir), center_y + lengthdir_y(minor_axis, _dir), 0);
	}
}

function polygon(_center_x, _center_y, _xscale, _yscale, _dir, _prime_points) constructor{
	center_x = _center_x;
	center_y = _center_y;
	xscale = _xscale;
	yscale =_yscale;
	dir = _dir;
	prime_points = _prime_points;
	
	points = noone;
	support_point = noone;
	
	update_points = function(){
		var _points = [];
		for(var _i = 0; _i < array_length(prime_points); _i++){
			var _len = point_distance(0, 0, prime_points[_i].x, prime_points[_i].y);
			var _prime_dir = point_direction(0, 0, prime_points[_i].x, prime_points[_i].y);
			var _x = center_x + xscale * lengthdir_x(_len, _prime_dir + dir);
			var _y = center_y + yscale * lengthdir_y(_len, _prime_dir + dir);
			array_push(_points, new other.vec3(_x, _y, 0));
		}
		points = _points;
	}
	update_points();
	
	update_support_point = function(_dir){
		var _unit = new other.vec3(lengthdir_x(1, _dir), lengthdir_y(1, _dir), 0);
		var _center = new other.vec3(center_x, center_y, 0);
		var _max_value = -infinity;
		var _point = noone;
		for(var _i = 0; _i < array_length(points); _i++){
			points[_i].sub(_center);
			if(_unit.dot(points[_i]) >= _max_value){
				_max_value = _unit.dot(points[_i]);
				points[_i].add(_center);
				_point = points[_i];
				continue;
			}
			points[_i].add(_center);
		}
		support_point = _point;
	}
}
