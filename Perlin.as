//https://github.com/caseman/noise/blob/master/perlin.py
class PerlinBase{

	Array<Vector3> _GRAD3 = {Vector3(1,1,0),Vector3(-1,1,0),Vector3(1,-1,0),Vector3(-1,-1,0),
		Vector3(1,0,1),Vector3(-1,0,1),Vector3(1,0,-1),Vector3(-1,0,-1),
		Vector3(0,1,1),Vector3(0,-1,1),Vector3(0,1,-1),Vector3(0,-1,-1),
		Vector3(1,1,0),Vector3(0,-1,1),Vector3(-1,1,0),Vector3(0,-1,-1)};

	Array<int> permutation = {151,160,137,91,90,15,
		131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
		190,6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
		88,237,149,56,87,174,20,125,136,171,168,68,175,74,165,71,134,139,48,27,166,
		77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
		102,143,54,65,25,63,161,1,216,80,73,209,76,132,187,208,89,18,169,200,196,
		135,130,116,188,159,86,164,100,109,198,173,186,3,64,52,217,226,250,124,123,
		5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
		223,183,170,213,119,248,152,2,44,154,163,70,221,153,101,155,167,43,172,9,
		129,22,39,253,9,98,108,110,79,113,224,232,178,185,112,104,218,246,97,228,
		251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
		49,192,214,31,181,199,106,157,184,84,204,176,115,121,50,45,127,4,150,254,
		138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180};

	int period = permutation.length;
	//permutation = permutation * 2
	float _F2 = 0.5f * (Sqrt(3.0f) - 1.0f);
	float _G2 = (3.0f - Sqrt(3.0f)) / 6.0f;
	float _F3 = 1.0f / 3.0f;
	float _G3 = 1.0f / 6.0f;

	PerlinBase(uint i = 1){
		double_permutation();
		//randomize(i);
	}

	/*void init(){

	}*/

	void double_permutation(){
		int iter = permutation.length;
		for(int t=0; t<iter;t++){
			permutation.Push(permutation[t]);
		}
		//period = permutation.length-1;
	}

	void randomize(const int p = 0){
		/*Randomize the permutation table used by the noise functions. This
		makes them generate a different noise pattern for the same inputs.
		*/
		if (p > 0)
			period = p;

		Array<int> perm(period);
		int perm_right = period - 1;
		for (int i=0; i< period;i++){
			int j = RandomInt(0, perm_right);
			perm[j]=perm[i];
			perm[i]=perm[j];
		}
		permutation = perm;
		double_permutation();
	}
}


class Perlin: PerlinBase{

	Perlin(uint i = 1){super(i);}

	float noise2(const float x, const float y,const float sx=1.0f, const float sy=1.0f, const float ox=0.0f, const float oy=0.0f){
		/*2D Perlin simplex noise.
		Return a floating point value from -1 to 1 for the given x, y coordinate.
		The same value is always returned for a given x, y pair unless the
		permutation table changes (see randomize above).
		*/
		//Skew input space to determine which simplex (triangle) we are in

		float ax=(x*sx)+ox;//abs(x);
		float ay=(y*sy)+oy;//abs(y);

		float s = (ax + ay) * _F2;
		int i = int(Floor(ax + s));
		int j = int(Floor(ay + s));
		float t = (i + j) * _G2;
		float x0 = ax - (i - t); // "Unskewed" distances from cell origin
		float y0 = ay - (j - t);

		float i1 = 0;
		float j1 = 1; // Upper triangle, YX order: (0,0)->(0,1)->(1,1)
		if (x0 > y0){
			i1 = 1;
			j1 = 0; // Lower triangle, XY order: (0,0)->(1,0)->(1,1)
		}

		float x1 = x0 - i1 + _G2; // Offsets for middle corner in (x,y) unskewed coords
		float y1 = y0 - j1 + _G2;
		float x2 = x0 + _G2 * 2.0f - 1.0f; // Offsets for last corner in (x,y) unskewed coords
		float y2 = y0 + _G2 * 2.0f - 1.0f;

		//# Determine hashed gradient indices of the three simplex corners
		Array<int> perm = permutation;
		int ii = ((int(i) % period)+period)% period;//int(Abs(i) % period);
		int jj = ((int(j) % period)+period)% period;//int(Abs(j) % period);
		//Print( "str ii less than 0:"+(ii) );
		//Print( "str jj less than 0:"+(jj) );
		int gi0 = ((perm[ii + perm[jj]] % 12)+12)%12;
		int gi1 = ((perm[ii + int(i1) + perm[jj + int(j1)]] % 12)+12)%12;
		int gi2 = ((perm[ii + 1 + perm[jj + 1]] % 12)+12)%12;

		// Calculate the contribution from the three corners
		float tt = 0.5f - Pow(x0,2) - Pow(y0,2);
		float noise = 0.0f;
		Vector3 g = _GRAD3[0];
		if (tt > 0){
			g = _GRAD3[gi0];
			noise = Pow(tt,4) * (g.x * x0 + g.y * y0);
		}
		tt = 0.5f - Pow(x1,2) - Pow(y1,2);
		if (tt > 0){
			g = _GRAD3[gi1];
			noise += Pow(tt,4) * (g.x * x1 + g.y * y1);
		}
		tt = 0.5f - Pow(x2,2) - Pow(y2,2);
		if (tt > 0){
			g = _GRAD3[gi2];
			noise += Pow(tt,4) * (g.x * x2 + g.y * y2);
		}

		//return (ii)*1.0f;
		//float noise = 0.01f;
		return noise * 70.0f; // scale noise to [-1, 1]
	}

	float noise3(const float x, const float y, const float z, const float sx=1.0f, const float sy=1.0f, const float sz=1.0f, const float ox=0.0f, const float oy=0.0f, const float oz=0.0f){
		float ax=(x*sx)+ox;//abs(x);
		float ay=(y*sy)+oy;//abs(y);
		float az=(z*sz)+oz;//abs(x);

		/*3D Perlin simplex noise.
		Return a floating point value from -1 to 1 for the given x, y, z coordinate.
		The same value is always returned for a given x, y, z pair unless the
		permutation table changes (see randomize above).*/

		// Skew the input space to determine which simplex cell we're in
		float s = (ax + ay + az) * _F3;
		int i = int(Floor(ax + s));
		int j = int(Floor(ay + s));
		int k = int(Floor(az + s));
		float t = (i + j + k) * _G3;
		float x0 = ax - (i - t); // "Unskewed" distances from cell origin
		float y0 = ay - (j - t);
		float z0 = az - (k - t);

		// For the 3D case, the simplex shape is a slightly irregular tetrahedron.
		// Determine which simplex we are in.
		float i1,j1,k1,i2,j2,k2;
		if (x0 >= y0){
			if (y0 >= z0){
				i1 = 1; j1 = 0; k1 = 0;
				i2 = 1; j2 = 1; k2 = 0;
			}else{
				if (x0 >= z0){
					i1 = 1; j1 = 0; k1 = 0;
					i2 = 1; j2 = 0; k2 = 1;
				}else{
					i1 = 0; j1 = 0; k1 = 1;
					i2 = 1; j2 = 0; k2 = 1;
				}
			}
		}else{ // x0 < y0
			if (y0 < z0){
				i1 = 0; j1 = 0; k1 = 1;
				i2 = 0; j2 = 1; k2 = 1;
			}else{
				if (x0 < z0){
					i1 = 0; j1 = 1; k1 = 0;
					i2 = 0; j2 = 1; k2 = 1;
				}else{
					i1 = 0; j1 = 1; k1 = 0;
					i2 = 1; j2 = 1; k2 = 0;
				}
			}
		}

		//# Offsets for remaining corners
		float x1 = x0 - i1 + _G3;
		float y1 = y0 - j1 + _G3;
		float z1 = z0 - k1 + _G3;
		float x2 = x0 - i2 + 2.0f * _G3;
		float y2 = y0 - j2 + 2.0f * _G3;
		float z2 = z0 - k2 + 2.0f * _G3;
		float x3 = x0 - 1.0f + 3.0f * _G3;
		float y3 = y0 - 1.0f + 3.0f * _G3;
		float z3 = z0 - 1.0f + 3.0f * _G3;

		//# Calculate the hashed gradient indices of the four simplex corners
		Array<int> perm = permutation;
		int ii = ((int(i) % period)+period)% period;
		int jj = ((int(j) % period)+period)% period;
		int kk = ((int(k) % period)+period)% period;
		int gi0 = ((perm[ii + perm[jj + perm[kk]]] % 12)+12)%12;
		int gi1 = ((perm[ii + int(i1) + perm[jj + int(j1) + perm[kk + int(k1)]]] % 12)+12)%12;
		int gi2 = ((perm[ii + int(i2) + perm[jj + int(j2) + perm[kk + int(k2)]]] % 12)+12)%12;
		int gi3 = ((perm[ii + 1 + perm[jj + 1 + perm[kk + 1]]] % 12)+12)%12;

		//# Calculate the contribution from the four corners
		float noise = 0.0f;
		float tt = 0.6f - Pow(x0,2) - Pow(y0,2) - Pow(z0,2);
		Vector3 g = _GRAD3[0];
		if (tt > 0){
			g = _GRAD3[gi0];
			noise = Pow(tt,4) * (g.x * x0 + g.y * y0 + g.z * z0);
		}else{
			noise = 0.0f;
			tt = 0.6 - Pow(x1,2) - Pow(y1,2) - Pow(z1,2);
		}
		if (tt > 0){
			g = _GRAD3[gi1];
			noise += Pow(tt,4) * (g.x * x1 + g.y * y1 + g.z * z1);
			tt = 0.6f - Pow(x2,2) - Pow(y2,2) - Pow(z2,2);
		}
		if (tt > 0){
			g = _GRAD3[gi2];
			noise += Pow(tt,4) * (g.x * x2 + g.y * y2 + g.z * z2);
			tt = 0.6f - Pow(x3,2) - Pow(y3,2) - Pow(z3,2);
		}
		if (tt > 0){
			g = _GRAD3[gi3];
			noise += tt**4 * (g.x * x3 + g.y * y3 + g.z * z3);
		}
		return noise * 32.0f;
	}

}
