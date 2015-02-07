class Bezier4{

		Array<Vector3> pointsArray;

		Bezier4(Array<Vector3> incomingPoints ){
				for (uint i=0; i<incomingPoints.length; i++){
					pointsArray.Push(incomingPoints[i]);
				}
    }

    Vector3 bezierP(float timeU){
				timeU = Clamp(timeU, 0.0, 1.0);
				Array<Vector3> gah;
				//gah.Clear();


			if (timeU < 0.333) {
				gah.Push(pointsArray[0]);
				gah.Push(pointsArray[1]);
				gah.Push(pointsArray[2]);
				gah.Push(pointsArray[3]);
				timeU=fit(timeU,0.0,0.333);
			}
			else if (timeU < 0.666) {
				gah.Push(pointsArray[3]);
				gah.Push(pointsArray[4]);
				gah.Push(pointsArray[5]);
				gah.Push(pointsArray[6]);
				timeU=fit(timeU,0.3333,0.6666);
			}
			else {
				gah.Push(pointsArray[6]);
				gah.Push(pointsArray[7]);
				gah.Push(pointsArray[8]);
				gah.Push(pointsArray[9]);
				timeU=fit(timeU,0.6666,1.0);
			}
			//gah.Clear();


			float pow1 = Pow((1 - timeU), 3.0);
			float pow2 = Pow((1 - timeU), 2.0);
			float pow3 = Pow(timeU, 2.0);
			float pow4 = Pow(timeU, 3.0);

			//Print(timeU);
			//Print(gah[0].z);
			//Print(gah[1].z);
			//Print(gah[2].z);
			//Print(gah[3].z);

			float newPx =  (pow1*gah[0].x) + (3 * pow2*timeU*gah[1].x) + (3 * (1 - timeU)*pow3*gah[2].x) + pow4*gah[3].x;
			float newPy =  (pow1*gah[0].y) + (3 * pow2*timeU*gah[1].y) + (3 * (1 - timeU)*pow3*gah[2].y) + pow4*gah[3].y;
			float newPz =  (pow1*gah[0].z) + (3 * pow2*timeU*gah[1].z) + (3 * (1 - timeU)*pow3*gah[2].z) + pow4*gah[3].z;

			Vector3 newP = Vector3(newPx , newPy, newPz);

    	return newP;
	}

	float fit(const float v, const float l1, const float h1, const float l2=0.0f,const float h2=1.0f){
		return Clamp( l2 + (v - l1) * (h2 - l2) / (h1 - l1), l2,h2);
	}
}
