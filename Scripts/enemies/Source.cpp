//Bezier curves test

Vector3 p0 = { 0.0, 0.0, 0.0 };
Vector3 p1 = { 1.0, 0.0, 0.0 };
Vector3 p2 = { 0.0, 2.0, 0.0 };
Vector3 p3 = { 0.0, 0.0, 3.0 };

float t = timestep;
Vector3 NewP_ = { 
	pow((1 - t), 3.0)*p0[0] + 3 * pow((1 - t), 2.0)*p1[0] + 3 * (1 - t)*pow(t, 2.0)*p2[0] + pow(t, 3.0)*p3[0],
	pow((1 - t), 3.0)*p0[1] + 3 * pow((1 - t), 2.0)*p1[1] + 3 * (1 - t)*pow(t, 2.0)*p2[1] + pow(t, 3.0)*p3[1],
	pow((1 - t), 3.0)*p0[2] + 3 * pow((1 - t), 2.0)*p1[2] + 3 * (1 - t)*pow(t, 2.0)*p2[2] + pow(t, 3.0)*p3[2] 
};

return NewP_

//[x, y] = (1–t)3P0 + 3(1–t)2tP1 + 3(1–t)t2P2 + t3P3