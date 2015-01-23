class Bezier4{

	Array<Vector3> pointsArray;

	Bezier4(Vector3 point0 , Vector3 point1 , Vector3 point2, Vector3 point3 ){
		//pointsArray[0] = point0;
        //pointsArray[1] = point1;
        //pointsArray[2] = point2;
        //pointsArray[3] = point3;
		pointsArray.Push(point0);
		pointsArray.Push(point1);
		pointsArray.Push(point2);
		pointsArray.Push(point3);

    }

    Vector3 bezierP(float timeU){

        timeU = Clamp(timeU, 0.0, 1.0);

		float newPx =  Pow((1 - timeU), 3.0)*pointsArray[0].x + 3 * Pow((1 - timeU), 2.0)*pointsArray[1].x + 3 * ((1 - timeU)*Pow(timeU,2.0))*pointsArray[2].x + Pow(timeU, 3.0)*pointsArray[3].x;
		float newPy =  Pow((1 - timeU), 3.0)*pointsArray[0].y + 3 * Pow((1 - timeU), 2.0)*pointsArray[1].y + 3 * ((1 - timeU)*Pow(timeU,2.0))*pointsArray[2].y + Pow(timeU, 3.0)*pointsArray[3].y;
		float newPz =  Pow((1 - timeU), 3.0)*pointsArray[0].z + 3 * Pow((1 - timeU), 2.0)*pointsArray[1].z + 3 * ((1 - timeU)*Pow(timeU,2.0))*pointsArray[2].z + Pow(timeU, 3.0)*pointsArray[3].z;

		Vector3 newP = Vector3(newPx , newPy, newPz);
		return newP;
	}
}