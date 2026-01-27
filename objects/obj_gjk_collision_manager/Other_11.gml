/// @description GJK & EPA library
function triple_product(_v1, _v2, _v3){
	return (_v1.cross(_v2)).cross(_v3);
}

function minkowski_support(_polygon1, _polygon2, _dir){
	_polygon1.update_support_point(_dir);
	_polygon2.update_support_point(_dir + 180);
	var _p1 = _polygon1.support_point;
	var _p2 = _polygon2.support_point;
	return new vec3(_p1.x - _p2.x, _p1.y - _p2.y, _p1.z - _p2.z);
}

function line_case(){
	var _a = simplex[0];
	var _b = simplex[1];
	var _ab = new vec3(_b.x - _a.x, _b.y - _a.y, 0);
	var _ao = new vec3(-_a.x, -_a.y, 0);
	var _ab_perp = triple_product(_ab, _ao, _ab);
	unit = _ab_perp;
	return false;
}

function triangle_case(){
	var _a = simplex[0];
	var _b = simplex[1];
	var _c = simplex[2];
	var _ab = new vec3(_b.x - _a.x, _b.y - _a.y, 0);
	var _ac = new vec3(_c.x - _a.x, _c.y - _a.y, 0);
	var _ao = new vec3(-_a.x, -_a.y, 0);
	var _ab_perp = triple_product(_ac, _ab, _ab);
	var _ac_perp = triple_product(_ab, _ac, _ac);
	if(_ab_perp.dot(_ao) > 0){
		array_delete(simplex, 2, 1);
		unit = _ab_perp;
		return false;
	}
	else if(_ac_perp.dot(_ao) > 0){
		array_delete(simplex, 2, 1);
		unit = _ac_perp;
		return false;
	}
	return true;
}

function handle_simplex(){
	if(array_length(simplex) == 2){
		return line_case();
	}
	return triangle_case();
}

function gjk(_polygon1, _polygon2){
	simplex = [];
	unit = new vec3(_polygon2.center_x - _polygon1.center_x, _polygon2.center_y - _polygon1.center_y, 0);
	array_push(simplex, minkowski_support(_polygon1, _polygon2, unit.get_direction()));
	unit = new vec3(-simplex[0].x, -simplex[0].y, 0);
	while(true){
		var _a = minkowski_support(_polygon1, _polygon2, unit.get_direction());
		if(unit.dot(_a) < 0){
			return false;
		}
		array_push(simplex, _a);
		if(handle_simplex()){
			return true;
		}
	}
}

function find_closest_edge(){
	var _min_distance = infinity;
	var _distance = noone;
	var _n = noone;
	var _index = noone;
	for(var _i = 0; _i < array_length(simplex); _i++){
		var _j = (_i + 1) % array_length(simplex);
		var _a = simplex[_i];
		var _b = simplex[_j];
		var _ab = new vec3(_b.x - _a.x, _b.y - _a.y, 0);
		_normal = new vec3( -_ab.y, _ab.x, _ab.z );
		_normal.normalize();
		_distance = _normal.dot(_a);
		if(_distance < _min_distance){
			_min_distance = _distance;
			_n = _normal;
			_index = _i;
		}
	}
	return {
		distance : _min_distance,
		n : _n,
		index : _index
	};
}

function epa(_polygon1, _polygon2){
	if(gjk(_polygon1, _polygon2)){
		var _epsilon = 0.1;
		while(true){
			var _edge = find_closest_edge();
			var _support = minkowski_support(_polygon1, _polygon2, _edge.n.get_direction());
			var _s_distance = _support.dot(_edge.n);
			if(abs(_s_distance - _edge.distance) > _epsilon){
				array_insert(simplex, _edge.index + 1, _support);
				continue;
			}
			_polygon1.center_x -= lengthdir_x(_edge.distance, _edge.n.get_direction());
			_polygon1.center_y -= lengthdir_y(_edge.distance, _edge.n.get_direction());
			_polygon1.update_points();
			break;
		}
	}
}




