class Bezier4{
    Vector3<Array> p;
    float t = timestep;
	t = Clamp(t + timestep,0.0,1.0);
    Bezier(Vector3 a, Vector3 b, Vector3 c, Vector3 d){
        p[0]=a;
		p[1]=b;
		p[2]=c;
		p[3]=d;
	}

    
Vector3 get_t(float t){ 
float x =  Pow((1 - t), 3.0)*p[0].x + 3 * Pow((1 - t), 2.0)*p[1].x + 3 * (1 - t)*Pow(t, 2.0)*p[2].x + Pow(t, 3.0)*p[3].x;
float y = Pow((1 - t), 3.0)*p[0].y + 3 * Pow((1 - t), 2.0)*p[1].y + 3 * (1 - t)*Pow(t, 2.0)*p[2].y + Pow(t, 3.0)*p[3].y;
float z = Pow((1 - t), 3.0)*p[0].z + 3 * Pow((1 - t), 2.0)*p[1].z + 3 * (1 - t)*Pow(t, 2.0)*p[2].z + Pow(t, 3.0)*p[3].z;

    }




